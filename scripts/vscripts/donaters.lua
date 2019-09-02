FirstSpawned = {}
local RoshdefPremium1 = {
	105803530,-- Maxim Shirinov
	179496404,-- Dima Medvedev
--	347624347,-- Vitalya Medvedev(vulkan)
	131171839,-- Maxim Chermat(Shesmu)
	338138866,-- Slava Kolienko
	836500968,-- Dmitry Hasanov
	412093271,-- Nikita Makushev
	408491440,-- Nikita Makushev(drug)
	324462062,-- Nikita Makushev(drug)
	303355696,-- Artur Saribekov
	186287226,-- Mark Anuchin	
	472748265,-- Kiryan Khambikov 
	253444224,-- Anton Beltyukov
	148686427,-- Anton Shaposhnikov
	93653615 ,-- Arkady Kolbov
	204434409,-- Roma Shavkunov
	864990343,-- Marishka Drezina	
	161901711, -- Вовчик Кунаев
----PATREON	
	125731801,-- Neptune
	83161702 ,-- braydon robert hollis
----Donation alerts
	36475988 ,87665104 ,857231081,445093215,894471104,
	309107093,459724428,192926025,246665292,198330008,
	354211948,371012623,404077314,848341909,
	
}


local RoshdefPremium2 = {
--	347624347,-- Vitalya Medvedev(vulkan)
----Donation alerts
	326877293,182842044,191148421,413908276,295826274,
	271895336,167691043,

}
local RoshdefPremium3 = {
	116186776,-- Alexander Nesterov

}
local RoshdefLightPack = {	
	293819111,--Hesperid contest
	227019126,--Hesperid contest
	181377720,--Hesperid contest
	162342583,--Hesperid contest
	140461903,--orlov
	123106753,--grisha
	301284236,  --gleb
	243260944, -- damir
	331923807, -- Макс Олейник
	110395734, -- Noname Donator				
	132213460, -- Noname Donator				
	172172047, -- misha shevtsov
	246697593,
	175802236,
	342742125,333956343,198000730,77359583 ,295239965,
	885685239,317220344,412663064,148550169,197892667,
	334574385,
	
	84930581 ,
	135152517,--valera
	396873101,
	902513692, --roma
	97829600 , -- Виктор Миронов
	177999328, --mark twink
	
}

local RoshdefSkullOfMidas = {
	94118708 ,174357710,228635657,159045754,53244522 ,
	178396298,442969826,226493967,148550169,205208478,
	288746380,
}

local RoshdefDrowRangerEnum = {-- Drow ranger			
	331923807,342742125,224979433,442969826,307132081,
	198000730,444342213,97829600 ,83899875 ,333956343,
	205208478,397292967,373557389,164972289,
	
}		

local RoshdefPhantomAssassinEnum = {-- Phantom assassin			
	331923807,224979433,152044079,333956343,364044715,
	426957525,288746380,
	
}		

local RoshdefAlchemistEnum = {-- Alchemist			
	331923807, -- Макс Олейник
}			

local RoshdefSniperEnum = {-- Sniper			
	331923807,152044079,
}		
	
local RoshdefPhoenixEnum = {-- Phoenix			
	331923807,83899875 ,364044715,148550169,152044079, -- Макс Олейник
}	
	
local TestItemEnum = {-- Testitem(???)			
	108116183,472748265,331923807,301284236,93653615 ,
	338138866,186287226,902513692,105803530,--347624347,
	84930581 ,332561278,864990343,148686427,303355696,
	243260944,125731801,204434409,224979433,442969826,
	326877293,333956343,198000730,77359583 ,83161702 ,
	161901711,295239965,131171839,271895336,295826274,
	192926025,459724428,148550169,
	
----contest
	189516918,315539927,167093266,181377720,185088726,
	444342213,140144812,875680680,159333618,253444224,

	
}		
	
local SkullOfMidasEnums = {
	RoshdefPremium1,
	RoshdefPremium2,
	RoshdefPremium3,
	RoshdefLightPack,
	RoshdefSkullOfMidas,

}		

local RoshanSonEnums = {
	RoshdefPremium1,
	RoshdefPremium2,
	RoshdefPremium3,
	RoshdefLightPack,
	RoshdefRoshanSonEnum,

}

local DrowRangerEnums = {
	RoshdefPremium1,
	RoshdefPremium2,
	RoshdefPremium3,
	RoshdefDrowRangerEnum,

}		

local PhantomAssassinEnums = {
	RoshdefPremium1,
	RoshdefPremium2,
	RoshdefPremium3,
	RoshdefPhantomAssassinEnum,

}		
local AlchemistEnums = {
	RoshdefPremium1,
	RoshdefPremium2,
	RoshdefPremium3,
	RoshdefAlchemistEnum,

}		

local SniperEnums = {
	RoshdefPremium1,
	RoshdefPremium2,
	RoshdefSniperEnum,
}		

local PhoenixEnums = {
	RoshdefPremium1,
	RoshdefPremium2,
	RoshdefPremium3,
	RoshdefPhoenixEnum,

}		

if not donaters then
	donaters = class({})
end

function donaters:Init()
	ListenToGameEvent("npc_spawned",Dynamic_Wrap(self,'OnNPCSpawned'),self)
end

 function donaters:OnNPCSpawned(keys)
	print("[BAREBONES] NPC Spawned")
--	DeepPrintTable(keys)
	local npc = EntIndexToHScript(keys.entindex)
	local name = npc:GetUnitName()
	
	if npc:IsRealHero() and npc.bFirstSpawned == nil then
		npc.bFirstSpawned = true
		local playerID = npc:GetPlayerID()
		
		--npc:AddItemByName("item_skull_of_midas")
		local steamID = PlayerResource:GetSteamAccountID(playerID)
		
		print( "Steam Community ID: " .. tostring( steamID ) )
		print( "Current Hero: " .. tostring( name ) )
--	

	
		addModifierBySteamID(RoshdefPremium1,"modifier_special_effect_legendary",steamID,npc)
		addModifierBySteamID(RoshdefPremium2,"modifier_special_effect_divine",steamID,npc)
				
		
		if not FirstSpawned[playerID] then
			if GetMapName() == "roshdef_turbo" then
				print("vse rabotaet")
				Timers:CreateTimer(0.1,function() npc:AddItemByName("item_courier") end)
			end
		
			FirstSpawned[playerID] = true
			--Premium
			addItemByEnum(SkullOfMidasEnums,"item_skull_of_midas",steamID,npc)		
			addItemByEnum(RoshanSonEnums,"item_roshan_essence",steamID,npc)		
			addItemByEnum(DrowRangerEnums,"item_drow_ranger_essence",steamID,npc)		
			addItemByEnum(PhantomAssassinEnums,"item_phantom_assassin_essence",steamID,npc)		
			addItemByEnum(AlchemistEnums,"item_alchemist_essence",steamID,npc)		
			addItemByEnum(SniperEnums,"item_sniper_essence",steamID,npc)		
			addItemByEnum(PhoenixEnums,"item_phoenix_essence",steamID,npc)		
			addItemBySteamID(TestItemEnum,"item_test_essence",steamID,npc)		
			addItemBySteamID(TestItemEnum,"item_test1_essence",steamID,npc)		
			addItemBySteamID(TestItemEnum,"item_ventors_gamble",steamID,npc)		

		end
	end
end

function addItemByEnum(players_enum,item_name,steamID,npc)
	for _,enum in pairs(players_enum) do
		addItemBySteamID(enum,item_name,steamID,npc)
	end
end

function addItemBySteamID(enum,item_name,steamID,npc)
	for _,ID in pairs(enum) do
		if steamID == ID then
			Timers:CreateTimer(1,function() npc:AddItemByName(item_name) end)
		end
	end
end

function addModifierBySteamID(enum,modifier_name,steamID,npc)
	for _,ID in pairs(enum) do
		if steamID == ID then
			Timers:CreateTimer(1,function() npc:AddNewModifier( npc, nil, modifier_name, nil) end)
		end
	end
end


donaters:Init()