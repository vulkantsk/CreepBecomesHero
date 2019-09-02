LinkLuaModifier("modifier_neutral_animal", "ai/ai_neutral_animal", LUA_MODIFIER_MOTION_NONE)

modifier_neutral_animal = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_BLIND] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		} end,
})

function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier(thisEntity, nil, "modifier_neutral_animal", nil)
	thisEntity:SetContextThink( "NeutralAnimalThink", NeutralAnimalThink, 0.25 )
end

function NeutralAnimalThink()
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
									250,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	local current_time = GameRules:GetGameTime()
	local unit = units[1]
	if unit then
		local unit_point = unit:GetAbsOrigin()
		local self_point = npc:GetAbsOrigin()
		local forward_vector = 	self_point - unit_point
		local point_arrive = self_point + forward_vector
		npc:MoveToPosition(point_arrive)
		if npc.last_cry == nil or current_time - npc.last_cry > 2 then
			npc.last_cry = current_time
			AnimalCry(npc)
		end
		return 0.25
	end
	
	if npc.last_move == nil or current_time - npc.last_move > RandomFloat(3,6) then
		local self_point = npc:GetAbsOrigin()
		local point_arrive = self_point + RandomVector(RandomInt(50,350))
		npc.last_move = current_time
		npc:MoveToPosition(point_arrive)
	end
		
	return 0.25
end

function AnimalCry(npc)
	print("cry baba")
	local sound_name = "animal_cry.frog"
	local unit_name = npc:GetUnitName()
	
	if unit_name == "npc_animal_sheep" then
		sound_name = "animal_cry.sheep"
	elseif unit_name == "npc_animal_pig" then
		sound_name = "animal_cry.pig"
	elseif unit_name == "npc_animal_chicken" then
		sound_name = "animal_cry.chicken"
	elseif unit_name == "npc_animal_frog" then
		sound_name = "animal_cry.frog"
	end
	print(sound_name)
	EmitSoundOn( sound_name, npc)

end

