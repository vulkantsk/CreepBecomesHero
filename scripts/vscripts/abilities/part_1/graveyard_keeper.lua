LinkLuaModifier("modifier_graveyard_keeper", "abilities/part_1/graveyard_keeper", LUA_MODIFIER_MOTION_NONE)

graveyard_keeper = class({})

function graveyard_keeper:GetIntrinsicModifierName()
	return "modifier_graveyard_keeper"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_graveyard_keeper = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_graveyard_keeper:OnCreated()
	self:StartIntervalThink(0.1)
	local ghosts_lil = {"npc_graveyard_ghost_dire_lil","npc_graveyard_ghost_radiant_lil"}
	local ghosts_big = {"npc_graveyard_ghost_dire_big","npc_graveyard_ghost_radiant_big"}

	local points = Entities:FindAllByName("ghost_spawn_point")

	for i=1,30 do
		local point = points[RandomInt(1,#points)]
		point = point:GetAbsOrigin() + RandomVector(RandomInt(100,250))
		local unit_name = ghosts_lil[1]
		local unit = CreateUnitByName( unit_name , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 				
	end
	for i=1,7 do
		local point = points[RandomInt(1,#points)]
		point = point:GetAbsOrigin() + RandomVector(RandomInt(100,250))
		local unit_name = ghosts_big[1]
		local unit = CreateUnitByName( unit_name , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 				
	end
	
	for i=1,30 do
		local point = points[RandomInt(1,#points)]
		point = point:GetAbsOrigin() + RandomVector(RandomInt(100,250))
		local unit_name = ghosts_lil[2]
		local unit = CreateUnitByName( unit_name , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 				
	end
	for i=1,7 do
		local point = points[RandomInt(1,#points)]
		point = point:GetAbsOrigin() + RandomVector(RandomInt(100,250))
		local unit_name = ghosts_big[2]
		local unit = CreateUnitByName( unit_name , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 				
	end

end

function modifier_graveyard_keeper:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), 
									caster:GetAbsOrigin(),
									nil,
									350,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	if #heroes == 0 then
		return
	end
	
	local hero = heroes[1]
	
	if hero:HasModifier("modifier_first_spawn_respawn") then
		hero:RemoveModifierByName("modifier_first_spawn_respawn")
		hero:RemoveModifierByName("modifier_first_spawn_dire")
		hero:RemoveModifierByName("modifier_first_spawn_radiant")
		keys = {}
		keys.caster = hero
		keys.class_name = "basic_creep"
		ChangeClass(keys)
		GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 2 )
		local player_id = hero:GetPlayerID()
		hero = PlayerResource:GetSelectedHeroEntity(player_id)
		hero:SetTeam(DOTA_TEAM_GOODGUYS)
		PlayerResource:SetCustomTeamAssignment(player_id,DOTA_TEAM_GOODGUYS)
		hero:RespawnHero(false, false)
	end
	
	
end
