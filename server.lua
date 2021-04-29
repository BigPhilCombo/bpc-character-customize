RegisterServerEvent("BPC:clothes:save")
AddEventHandler("BPC:clothes:save",function(appearance)
	local src = source
	local character = exports["drp_id"]:GetCharacterData(src)
	exports["externalsql"]:AsyncQueryCallback({
		query = "UPDATE character_appearance SET `appearance` = :appearance WHERE `char_id` = :charid",
		data = {
			appearance = appearance,			
			charid = character.charid
		}
	}, function(results)
	end)
end)

RegisterServerEvent("BPC:clothes:load")
AddEventHandler("BPC:clothes:load", function()
	local src = source
	local character = exports["drp_id"]:GetCharacterData(src)
	exports["externalsql"]:AsyncQueryCallback({
		query = "SELECT `appearance` FROM `character_appearance` WHERE `char_id` = :charid",
		data = {
			charid = character.charid
		}
	}, function(results)       
        local appearance =  json.decode(results["data"][1].appearance)
        TriggerClientEvent("BPC:clothes:loaded",src, appearance )        
	end)
end)

RegisterServerEvent("BPC:clothes:init")
AddEventHandler("BPC:clothes:init", function(charid)  
	local src = source;
	initializeClothes(src)
end)

-- Hijack DRP Events
RegisterServerEvent("DRP_Clothing:FirstSpawn")
AddEventHandler("DRP_Clothing:FirstSpawn", function()
	local src = source;
	IntializeClothes(src)
end)
RegisterServerEvent("DRP_Clothing:RestartClothing")
AddEventHandler("DRP_Clothing:RestartClothing", function()
	local src = source;
	TriggerClientEvent("BPC:clothes:ready", src)
end)

function IntializeClothes(srcX)
	local src = srcX
	local character = exports["drp_id"]:GetCharacterData(src)
	local charid = character.charid
	exports["externalsql"]:AsyncQueryCallback({
		query = "SELECT * FROM `character_apperance` WHERE `char_id` = :charid",
		data = {
			charid = charid
		}
	}, function(results)

		if json.encode(results["data"]) == "[]" then
			exports["externalsql"]:AsyncQueryCallback({
				query = "INSERT INTO `character_appearance` SET `appearance` = :appearance, `char_id` = :charid",
				data = {
					appearance = '{"props":[{"drawable":-1,"prop_id":0,"texture":-1},{"drawable":-1,"prop_id":1,"texture":-1},{"drawable":-1,"prop_id":2,"texture":-1},{"drawable":-1,"prop_id":6,"texture":-1},{"drawable":-1,"prop_id":7,"texture":-1}],"eyeColor":-1,"hair":{"highlight":0,"style":0,"color":0},"components":[{"drawable":0,"component_id":0,"texture":0},{"drawable":0,"component_id":1,"texture":0},{"drawable":0,"component_id":2,"texture":0},{"drawable":0,"component_id":3,"texture":0},{"drawable":0,"component_id":4,"texture":0},{"drawable":0,"component_id":5,"texture":0},{"drawable":0,"component_id":6,"texture":0},{"drawable":0,"component_id":7,"texture":0},{"drawable":0,"component_id":8,"texture":0},{"drawable":0,"component_id":9,"texture":0},{"drawable":0,"component_id":10,"texture":0},{"drawable":0,"component_id":11,"texture":0}],"model":"mp_m_freemode_01","headBlend":{"shapeMix":0,"skinFirst":0,"skinSecond":0,"skinMix":0,"shapeSecond":0,"shapeFirst":0},"faceFeatures":{"noseBoneTwist":0,"noseBoneHigh":0,"eyeBrownForward":0,"chinBoneLenght":0,"jawBoneWidth":0,"eyesOpening":0,"noseWidth":0,"neckThickness":0,"chinBoneSize":0,"cheeksWidth":0,"chinHole":0,"cheeksBoneWidth":0,"nosePeakSize":0,"chinBoneLowering":0,"jawBoneBackSize":0,"nosePeakLowering":0,"nosePeakHigh":0,"cheeksBoneHigh":0,"lipsThickness":0,"eyeBrownHigh":0},"headOverlays":{"sunDamage":{"opacity":0,"style":0,"color":0},"bodyBlemishes":{"opacity":0,"style":0,"color":0},"makeUp":{"opacity":0,"style":0,"color":0},"ageing":{"opacity":0,"style":0,"color":0},"lipstick":{"opacity":0,"style":0,"color":0},"complexion":{"opacity":0,"style":0,"color":0},"blemishes":{"opacity":0,"style":0,"color":0},"moleAndFreckles":{"opacity":0,"style":0,"color":0},"eyebrows":{"opacity":0,"style":0,"color":0},"chestHair":{"opacity":0,"style":0,"color":0},"beard":{"opacity":0,"style":0,"color":0},"blush":{"opacity":0,"style":0,"color":0}}}',
					charid = charid
				}
			}, function(yeet)
				TriggerClientEvent("BPC:clothes:ready", src)
			end)
		else
			TriggerClientEvent("BPC:clothes:ready", src)
		end
	end)
end