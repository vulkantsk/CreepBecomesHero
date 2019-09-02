LinkLuaModifier("modifier_graveyard_ghost", "abilities/part_1/graveyard_ghost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graveyard_ghost_1", "abilities/part_1/graveyard_ghost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graveyard_ghost_2", "abilities/part_1/graveyard_ghost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graveyard_ghost_3", "abilities/part_1/graveyard_ghost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graveyard_ghost_4", "abilities/part_1/graveyard_ghost", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_graveyard_ghost_5", "abilities/part_1/graveyard_ghost", LUA_MODIFIER_MOTION_NONE)

graveyard_ghost = class({})

function graveyard_ghost:GetIntrinsicModifierName()
	return "modifier_graveyard_ghost"
end

modifier_graveyard_ghost = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	CheckState		= function(self) return 
		{
			[MODIFIER_STATE_INVISIBLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_BLIND] = true,
			[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
			[MODIFIER_STATE_DISARMED] = true,
			[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		} end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
})

function modifier_graveyard_ghost:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		caster.ghost = true
		
		local effect = "particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf"
		local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(pfx, 0, caster:GetAbsOrigin()) -- Origin
		self:AddParticle(pfx, false, false, 100, true, false)
		
	end
end

function modifier_graveyard_ghost:GetPriority()
	return 100
end
function modifier_graveyard_ghost:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end

function modifier_graveyard_ghost:GetModifierInvisibilityLevel()
	return 0.45
end

graveyard_ghost_1 = class({})

function graveyard_ghost_1:GetIntrinsicModifierName()
	return "modifier_graveyard_ghost_1"
end

modifier_graveyard_ghost_1 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
})
function modifier_graveyard_ghost_1:GetPriority()
	return 100
end
function modifier_graveyard_ghost_1:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_graveyard_ghost_1:GetModifierInvisibilityLevel()
	return 0.2
end

graveyard_ghost_2 = class({})

function graveyard_ghost_2:GetIntrinsicModifierName()
	return "modifier_graveyard_ghost_2"
end

modifier_graveyard_ghost_2 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
})
function modifier_graveyard_ghost_2:GetPriority()
	return 100
end
function modifier_graveyard_ghost_2:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_graveyard_ghost_2:GetModifierInvisibilityLevel()
	return 0.4
end

graveyard_ghost_3 = class({})

function graveyard_ghost_3:GetIntrinsicModifierName()
	return "modifier_graveyard_ghost_3"
end

modifier_graveyard_ghost_3 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
})
function modifier_graveyard_ghost_3:GetPriority()
	return 100
end
function modifier_graveyard_ghost_3:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_graveyard_ghost_3:GetModifierInvisibilityLevel()
	return 0.6
end

graveyard_ghost_4 = class({})

function graveyard_ghost_4:GetIntrinsicModifierName()
	return "modifier_graveyard_ghost_4"
end

modifier_graveyard_ghost_4 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
})
function modifier_graveyard_ghost_4:GetPriority()
	return 100
end
function modifier_graveyard_ghost_4:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_graveyard_ghost_4:GetModifierInvisibilityLevel()
	return 0.8
end
graveyard_ghost_5 = class({})

function graveyard_ghost_5:GetIntrinsicModifierName()
	return "modifier_graveyard_ghost_5"
end

modifier_graveyard_ghost_5 = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_PROPERTY_INVISIBILITY_LEVEL} end,
})
function modifier_graveyard_ghost_5:GetPriority()
	return 100
end
function modifier_graveyard_ghost_5:GetStatusEffectName()
	return "particles/status_fx/status_effect_ghost.vpcf"
end
function modifier_graveyard_ghost_5:GetModifierInvisibilityLevel()
	return 1
end
