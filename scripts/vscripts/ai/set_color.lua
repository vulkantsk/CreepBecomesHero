



function SetColor(data)

	local moob = data.caster
	local name = moob:GetUnitName()
	
	local a = 255
	local b = 255
	local c = 255

	if name == "npc_dota_direr3_1" then
		a = 255
		b = 15
		c = 0
	end

	if name == "npc_dota_direr3_2" then
		a = 0
		b = 0
		c = 205
	end

	if name == "npc_dota_direr3_3" then
		a = 25
		b = 255
		c = 0
	end	

	if name == "npc_dota_" then
		a = 255
		b = 0
		c = 0
	end	
	

	if name == "npc_dota_elemental_4" then
		a = 119
		b = 49
		c = 0
	end	

	if name == "npc_dota_hero_winter_wyvern" then
		a = 0
		b = 0
		c = 255
	end	
	
	if name == "npc_riki_shadow" then
		a = 0
		b = 0
		c = 0
	end	

	if name == "npc_dota_greevil_lord_egg" then
		a = 255
		b = 255
		c = 0
	end	

	if name == "npc_dota_greevil_lord_ultimate_egg" then
		a = 255
		b = 153
		c = 51
	end	

	if name == "npc_dota_greevil_lord_mega_egg" then
		a = 153
		b = 102
		c = 255
	end	

	if name == "npc_candy" then
		team = DOTA_TEAM_GOODGUYS
	end

--	GameRules:GetGameModeEntity():SetContextThink(string.format("RespawnThink_%d",moob:GetEntityIndex()), 
--		function()
		moob:SetRenderColor(a, b, c)
--		end,
--		data.Time)		

end


