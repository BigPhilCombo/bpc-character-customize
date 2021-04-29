RegisterCommand('customization', function()
    OpenCustomization()
end, false)

function OpenCustomization()
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
      }    
      exports['fivem-appearance']:startPlayerCustomization(function (appearance)
        if (appearance) then     
          TriggerServerEvent("BPC:clothes:save",json.encode(appearance) )          
        else
          print('Canceled character customization')
        end
      end, config)
end

AddEventHandler("BPC:customize",  function()
    OpenCustomization()
end, false)

RegisterNetEvent("BPC:clothes:loaded")
AddEventHandler("BPC:clothes:loaded",  function(appearance)   
  exports['fivem-appearance']:setPlayerAppearance(appearance);
end, false)

--Listen for initialization and then load outfit
RegisterNetEvent("BPC:clothes:ready")
AddEventHandler("BPC:clothes:ready", function(appearance)
  TriggerServerEvent("BPC:clothes:load")
end)

-- PRETTY MUCH COPIED FROM drp_clothing
local clothing_shops = {
  {name="Clothing Store", id=73, x = 74.847686767578, y = -1399.1446533203, z = 29.376159667969},
   {name="Clothing Store", id=73, x=1693.26, y=4822.27, z=42.06},
   {name="Clothing Store", id=73, x=125.83, y=-223.16, z=54.55},
   {name="Clothing Store", id=73, x=-710.16, y=-153.26, z=37.41},
   {name="Clothing Store", id=73, x=-821.69, y=-1073.90, z=11.32},
   {name="Clothing Store", id=73, x=-1192.81, y=-768.24, z=17.31},
   {name="Clothing Store", id=73, x=4.25, y=6512.88, z=31.87},
   {name="Clothing Store", id=73, x=425.471, y=-806.164, z=29.4911},
   {name="Clothing Store", id=73, x=-3170.7, y=1044.46, z=20.86},
   {name="Clothing Store", id=73, x=-1101.39, y=2710.09, z=19.11},
   {name="Clothing Store", id=73, x=614.98, y=2762.52, z=42.09},
   {name="Clothing Store", id=73, x=1196.56, y=2709.85, z=38.22},
}
incircle = false
Citizen.CreateThread(function()
   for _, item in pairs(clothing_shops) do
     item.blip = AddBlipForCoord(item.x, item.y, item.z)
     SetBlipSprite(item.blip, item.id)
     SetBlipColour(item.blip, item.colour)
     SetBlipAsShortRange(item.blip, true)
     BeginTextCommandSetBlipName("STRING")
     AddTextComponentString(item.name)
     EndTextCommandSetBlipName(item.blip)
   end
   local waitTime = 1000
   while true do
       Citizen.Wait(waitTime)
       local pos = GetEntityCoords(PlayerPedId(), true)
       for k,v in ipairs(clothing_shops) do
           if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 15.0)then
               waitTime = 1
               DrawMarker(1, v.x, v.y, v.z - 1, 0, 0, 0, 0, 0, 0, 3.0001, 3.0001, 0.5001, 0, 0, 1555,165, 0, 0, 0,0)
               if(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) < 2.0)then
                   if (incircle == false) then
                       DisplayHelpText("Press ~INPUT_CONTEXT~ to customise your character.")
                   end
                   incircle = true
                   if IsControlJustReleased(1, 51) then -- INPUT_CELLPHONE_DOWN                      
                       TriggerEvent("BPC:customize")
                   end
               elseif(Vdist(pos.x, pos.y, pos.z, v.x, v.y, v.z) > 3.0)then
                   incircle = false                  
               end
           end
       end      
   end
end)


function DisplayHelpText(str)
  SetTextComponentFormat("STRING")
  AddTextComponentString(str)
  DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
-- END OF COPIED FROM drp_clothing