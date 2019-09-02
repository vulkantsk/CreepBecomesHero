LinkLuaModifier("modifier_first_spawn", "abilities/part_1/first_spawn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_first_spawn_dire", "abilities/part_1/first_spawn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_first_spawn_radiant", "abilities/part_1/first_spawn", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_first_spawn_respawn", "abilities/part_1/first_spawn", LUA_MODIFIER_MOTION_NONE)


first_spawn = class({})

function first_spawn:GetIntrinsicModifierName()
	return "modifier_first_spawn"
end


modifier_first_spawn = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{   MODIFIER_EVENT_ON_DEATH} end,
})

function modifier_first_spawn:OnCreated()
	if IsServer() then
		local caster = self:GetCaster()
		local ability = self:GetAbility()
		local dire_modifier = "modifier_first_spawn_dire"
		local radiant_modifier = "modifier_first_spawn_radiant"
		
		caster:AddNewModifier(caster, ability, dire_modifier, nil)
		caster:AddNewModifier(caster, ability, radiant_modifier, nil)
	end
end
function modifier_first_spawn:OnDeath(data)
	if IsServer() then
		local caster = self:GetCaster()
		local killer = data.attacker
		local killed_unit = data.unit
 
		if killer == caster and killed_unit:GetTeam() ~= killer:GetTeam() and killed_unit.ghost == true then
			local ability = self:GetAbility()
			local unit_name = killed_unit:GetUnitName()			
			local souls_need = ability:GetSpecialValueFor("souls_need") 
			local soul_per_lil = ability:GetSpecialValueFor("soul_per_lil") 
			local soul_per_big = ability:GetSpecialValueFor("soul_per_big") 
		
			EmitSoundOn("n_creep_fellbeast.Death", killed_unit)
			
--			Timers:CreateTimer(1, function()
				ProjectileManager:CreateTrackingProjectile ({
					Target = killer,
					Source = killed_unit,
					Ability = ability,
					EffectName = "particles/units/heroes/hero_rubick/rubick_spell_steal.vpcf",
					bDodgeable = false,
					bProvidesVision = false,
					iMoveSpeed = 300, 
					iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1, 
					vSpawnOrigin = killer:GetAbsOrigin()
				})
--			end)
--			local effect = "particles/econ/items/rubick/rubick_arcana/rubick_arc_spell_steal_default.vpcf"
--			local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, killer)
--			ParticleManager:SetParticleControl(pfx, 0, killer:GetAbsOrigin()) -- Origin
--			ParticleManager:SetParticleControl(pfx, 1, killed_unit:GetAbsOrigin()) -- Origin
--			ParticleManager:ReleaseParticleIndex(pfx)

			local respawn_modifier = "modifier_first_spawn_respawn"
			local dire_modifier = "modifier_first_spawn_dire"
			local radiant_modifier = "modifier_first_spawn_radiant"
			dire_modifier = caster:FindModifierByName(dire_modifier)
			radiant_modifier = caster:FindModifierByName(radiant_modifier)
			
			local modifier = nil
			local souls = 0
			
			if unit_name == "npc_graveyard_ghost_dire_lil" then
				modifier = dire_modifier
				souls = soul_per_lil
			elseif unit_name == "npc_graveyard_ghost_radiant_lil" then
				modifier = radiant_modifier
				souls = soul_per_lil
			elseif unit_name == "npc_graveyard_ghost_dire_big" then
				modifier = dire_modifier
				souls = soul_per_big
			elseif unit_name == "npc_graveyard_ghost_radiant_big" then
				modifier = radiant_modifier
				souls = soul_per_big
			end
			
			local stack_count = modifier:GetStackCount()
			modifier:SetStackCount(stack_count + souls)
			
			local souls_total = dire_modifier:GetStackCount() + radiant_modifier:GetStackCount()
			if souls_total >= souls_need then
				caster:AddNewModifier(caster, ability, respawn_modifier, nil)
			end
		end
	end
end

function modifier_first_spawn:GetEffectName()
	return 0--"particles/units/heroes/hero_skeletonking/wraith_king_ambient.vpcf"
end
function modifier_first_spawn:IsAura()
	return true
end
function modifier_first_spawn:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_first_spawn:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_first_spawn:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_first_spawn:GetAuraRadius()
	return 500
end
function modifier_first_spawn:GetModifierAura()
	return "modifier_truesight"
end

modifier_first_spawn_respawn = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})
function modifier_first_spawn_respawn:GetEffectName()
	return "particles/units/heroes/hero_legion_commander/legion_commander_press_owner.vpcf"
end

modifier_first_spawn_dire = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})
function modifier_first_spawn_dire:GetTexture()
	return "quest/part_1/dire_power"
end

modifier_first_spawn_radiant = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})
function modifier_first_spawn_radiant:GetTexture()
	return "quest/part_1/radiant_power"
end


