LinkLuaModifier("basic_modifier", "/abilities/basic_modifier.lua", LUA_MODIFIER_MOTION_NONE)

basic_modifier = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
})
function basic_modifier:OnCreated(kv)
	if IsServer() then
		self.model = kv.Model
		self:SetSharedKey('MoveSpeed', kv.Slow)
	end
end
function basic_modifier:GetModifierModelChange() return self.model end 
function basic_modifier:GetModifierMoveSpeedBonus_Percentage() return self:GetSharedKey('MoveSpeed') end 
function basic_modifier:CheckState()
	return {
		[MODIFIER_STATE_HEXED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end

modifier_slow_movespeed = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return true end,
	IsDebuff 				= function(self) return true end,
	IsBuff                  = function(self) return false end,
	RemoveOnDeath 			= function(self) return true end,
	DeclareFunctions		= function(self) return {MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE} end,
})
function modifier_slow_movespeed:OnCreated(kv)
	if IsServer() then
		self:SetSharedKey('MoveSpeed', kv.Slow)
	end
end
function modifier_hex_bh:GetModifierMoveSpeedBonus_Percentage() return self:GetSharedKey('MoveSpeed') end 
