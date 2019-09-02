LinkLuaModifier("modifier_graveyard_ghost_creep", "ai/ai_graveyard_ghost", LUA_MODIFIER_MOTION_NONE)

modifier_graveyard_ghost_creep = class({
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
			[MODIFIER_STATE_INVISIBLE] = true,
		} end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
})

function modifier_graveyard_ghost_creep:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		caster.ghost = true
		
		local effect = "particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
		self:AddParticle(pfx, false, false, 100, true, false)
		
	end
end

function modifier_graveyard_ghost_creep:GetPriority()
	return 100
end
function modifier_graveyard_ghost_creep:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_graveyard_ghost_creep:GetModifierInvisibilityLevel()
	return 0.45
end
function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	thisEntity:AddNewModifier(thisEntity, nil, "modifier_graveyard_ghost_creep", nil)
	thisEntity:SetContextThink( "GraveyardGhostThink", GraveyardGhostThink, 0.25 )
end

function GraveyardGhostThink()
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
