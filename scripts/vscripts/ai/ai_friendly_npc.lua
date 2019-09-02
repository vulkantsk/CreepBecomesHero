LinkLuaModifier("modifier_friendly_npc", "ai/ai_friendly_npc", LUA_MODIFIER_MOTION_NONE)

modifier_friendly_npc = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_DISARMED] = true,
		} end,
})

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	thisEntity:SetContextThink( "FriendlyNPCThink", FriendlyNPCThink, 0.25 )
	
	thisEntity:AddNewModifier(thisEntity, nil, "modifier_friendly_npc", nil)
	Timers:CreateTimer(1,function()
		
		local unit_name = thisEntity:GetUnitName()
		local ability = nil
		if unit_name == "npc_graveyard_keeper" then
			ability = thisEntity:AddAbility("graveyard_ghost")
		elseif unit_name == "npc_village_farmer" then
			ability = thisEntity:AddAbility("quest_meat_gathering")
		elseif unit_name == "npc_village_warden" then
			ability = thisEntity:AddAbility("quest_golden_mine")
		elseif unit_name == "npc_village_doctor" then
			ability = thisEntity:AddAbility("quest_herbs")
		end
		if ability then
			ability:SetLevel(1)
		end
	end)

end

function FriendlyNPCThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if GameRules:IsGamePaused() == true then
		return 1
	end
	local npc = thisEntity
	
	
	local units = FindUnitsInRadius(npc:GetTeamNumber(), 
									npc:GetAbsOrigin(),
									nil,
									350,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	local current_time = GameRules:GetGameTime()
	local unit = units[1]
	if unit then
		local unit_point = unit:GetAbsOrigin()
		local self_point = npc:GetAbsOrigin()
		local forward_vector = 	unit_point - self_point 
		npc:SetForwardVector(forward_vector)

	end
		
	return 0.05
end


