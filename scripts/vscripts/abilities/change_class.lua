LinkLuaModifier("modifier_class", "abilities/change_class.lua", LUA_MODIFIER_MOTION_NONE)

local HeroFile = LoadKeyValues("scripts/npc/evolution.txt")

function ChangeClass(keys) 
	local caster = keys.caster 
	local playerID = caster:GetPlayerID()
	local class_name = keys.class_name
	print("class_name = "..class_name)
  ------------------------------------------------------------
 -----------------------BASE PARAMS---------------------------
 -------------------------------------------------------------
	local model = HeroFile[class_name]["Model"] or "models/heroes/wisp/wisp.vmdl"
	local model_scale = HeroFile[class_name]["ModelScale"] or "models/heroes/wisp/wisp.vmdl"

	local armor = HeroFile[class_name]["ArmorPhysical"] or 0
	local mag_resist = HeroFile[class_name]["MagicalResistance"] or 0
	local night_vision = HeroFile[class_name]["VisionNighttimeRange"] or 0
	local day_vision = HeroFile[class_name]["VisionDaytimeRange"] or 0
	local move_speed = HeroFile[class_name]["MovementSpeed"] or 0
	local turn_rate = HeroFile[class_name]["MovementTurnRate"] or 0
	local max_health = HeroFile[class_name]["StatusHealth"]
	local health = HeroFile[class_name]["StatusHealth"] - HeroFile["basic"]["StatusHealth"]
	local health_regen = HeroFile[class_name]["StatusHealthRegen"] or 0
	local mana = HeroFile[class_name]["StatusMana"] - HeroFile["basic"]["StatusMana"]
	local mana_regen = HeroFile[class_name]["StatusManaRegen"] or 0
 ------------------------------------------------------------
 -----------------------ATTACK PARAMS------------------------
 ------------------------------------------------------------
	local attack_cap = HeroFile[class_name]["AttackCapabilities"] or 0
	local dmg_min = HeroFile[class_name]["AttackDamageMin"] or 0	
    local dmg_max = HeroFile[class_name]["AttackDamageMax"] or 0
    local attack_rate = HeroFile[class_name]["AttackRate"] or 0
    local attack_range = HeroFile[class_name]["AttackRange"] - HeroFile["basic"]["AttackRange"]
    local attack_anim = HeroFile[class_name]["AttackAnimationPoint"] or 0
    local projectile = HeroFile[class_name]["ProjectileModel"] or ""
    local projectile_speed = HeroFile[class_name]["ProjectileSpeed"] or 0
 ------------------------------------------------------------
 -----------------------ABILITIES----------------------------
 ------------------------------------------------------------
	local ability1 = HeroFile[class_name]["Ability1"] or ""
	local ability2 = HeroFile[class_name]["Ability2"] or ""
	local ability3 = HeroFile[class_name]["Ability3"] or ""
	local ability4 = HeroFile[class_name]["Ability4"] or ""
	local ability5 = HeroFile[class_name]["Ability5"] or ""
	local ability6 = HeroFile[class_name]["Ability6"] or ""

	local current_ability1 = caster:GetAbilityByIndex(0)
	local current_ability2 = caster:GetAbilityByIndex(1)
	local current_ability3 = caster:GetAbilityByIndex(2)
	local current_ability4 = caster:GetAbilityByIndex(3)
	local current_ability5 = caster:GetAbilityByIndex(4)
	local current_ability6 = caster:GetAbilityByIndex(5)
	if current_ability1 then
		caster:RemoveAbility(current_ability1:GetAbilityName())
	end 	
	if current_ability2 then
		caster:RemoveAbility(current_ability2:GetAbilityName())
	end 	
	if current_ability3 then
		caster:RemoveAbility(current_ability3:GetAbilityName())
	end 	
	if current_ability4 then
		caster:RemoveAbility(current_ability4:GetAbilityName())
	end 	
	if current_ability5 then
		caster:RemoveAbility(current_ability5:GetAbilityName())
	end 	
	if current_ability6 then
		caster:RemoveAbility(current_ability6:GetAbilityName())
	end 	
	
	caster:SetUnitName(class_name)
	caster:SetOriginalModel(model)
	caster:SetModelScale(model_scale)

    caster:SetPhysicalArmorBaseValue(armor)
	caster:SetBaseMagicalResistanceValue(mag_resist)
	caster:SetNightTimeVisionRange(night_vision)
	caster:SetDayTimeVisionRange(day_vision)
	caster:SetBaseMoveSpeed(move_speed)
	
	caster:SetBaseHealthRegen(health_regen)
	caster:SetBaseManaRegen(mana_regen)
	caster:SetHealth(max_health)

	if attack_cap == "DOTA_UNIT_CAP_NO_ATTACK" then
		caster:SetAttackCapability(0)
	elseif 	attack_cap == "DOTA_UNIT_CAP_MELEE_ATTACK" then
		caster:SetAttackCapability(1)
	elseif 	attack_cap == "DOTA_UNIT_CAP_RANGED_ATTACK" then
		caster:SetAttackCapability(2)
	end
	caster:SetBaseDamageMin(dmg_min)
	caster:SetBaseDamageMax(dmg_max)
	caster:SetRangedProjectileName(projectile)
		
	caster:AddAbility(ability1)
	caster:AddAbility(ability2)
	caster:AddAbility(ability3)
	caster:AddAbility(ability4)
	caster:AddAbility(ability5)
	caster:AddAbility(ability6)

	CustomNetTables:SetTableValue("creep", "health", { value = health})	
	CustomNetTables:SetTableValue("creep", "mana", { value = mana})	
	CustomNetTables:SetTableValue("creep", "attack_rate", { value = attack_rate})	
	CustomNetTables:SetTableValue("creep", "attack_anim", { value = attack_anim})	
	CustomNetTables:SetTableValue("creep", "attack_range", { value = attack_range})	

	caster:RemoveModifierByName("modifier_class")
	caster:AddNewModifier(caster, nil, "modifier_class", nil)
	caster:AddNewModifier(caster, nil, "modifier_phased", {duration = 0.01})
	
	caster:Stop()

end


-------------------------------------------------------------------
-------------------------------------------------------------------
modifier_class = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT,
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT} end,
})

function modifier_class:OnCreated( keys )
	print(CustomNetTables:GetTableValue("creep", "health").value)
	print(CustomNetTables:GetTableValue("creep", "mana").value)
	print(CustomNetTables:GetTableValue("creep", "attack_rate").value)
	print(CustomNetTables:GetTableValue("creep", "attack_anim").value)
	print(CustomNetTables:GetTableValue("creep", "attack_range").value)
	
	self.health = CustomNetTables:GetTableValue("creep", "health").value
	self.mana = CustomNetTables:GetTableValue("creep", "mana").value
	self.attack_rate = CustomNetTables:GetTableValue("creep", "attack_rate").value
	self.attack_anim = CustomNetTables:GetTableValue("creep", "attack_anim").value
	self.attack_range = CustomNetTables:GetTableValue("creep", "attack_range").value
	
end

function modifier_class:GetModifierHealthBonus(keys)
	return self.health
end

function modifier_class:GetModifierManaBonus(keys)
	return self.mana
end

function modifier_class:GetModifierBaseAttackTimeConstant(keys)
	return self.attack_rate
end

function modifier_class:GetModifierAttackPointConstant(keys)
	return self.attack_anim
end

function modifier_class:GetModifierAttackRangeBonus(keys)
	return self.attack_range
end
