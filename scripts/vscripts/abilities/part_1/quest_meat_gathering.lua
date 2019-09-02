LinkLuaModifier("modifier_quest_meat_gathering", "abilities/part_1/quest_meat_gathering", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_meat_gathering", "abilities/part_1/quest_meat_gathering", LUA_MODIFIER_MOTION_NONE)

quest_meat_gathering = class({})

function quest_meat_gathering:GetIntrinsicModifierName()
	return "modifier_quest_meat_gathering"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_quest_meat_gathering = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_quest_meat_gathering:OnCreated()
	self:StartIntervalThink(0.1)
	local animals = {"npc_animal_pig", "npc_animal_chicken", "npc_animal_sheep"}

	local points = Entities:FindAllByName("gathering_meat_point")

	for i=1,25 do
		local point = points[RandomInt(1,#points)]
		point = point:GetAbsOrigin() + RandomVector(RandomInt(100,250))
		local unit_name = animals[RandomInt(1,#animals)]
		local unit = CreateUnitByName( unit_name , point, true, nil, nil, DOTA_TEAM_NEUTRALS ) 				
		unit:AddNewModifier(unit, nil, "modifier_meat_gathering", nil)
	end

end

function modifier_quest_meat_gathering:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local value_required = ability:GetSpecialValueFor("value_required")
	local reward_exp = ability:GetSpecialValueFor("reward_exp")
	local reward_gold = ability:GetSpecialValueFor("reward_gold")
	local quest_item = "item_quest_meat"
	local reward_item = "item_quest_rusty_kirk_part_2"
	
	local heroes = FindUnitsInRadius(caster:GetTeamNumber(), 
									caster:GetAbsOrigin(),
									nil,
									350,
									DOTA_UNIT_TARGET_TEAM_FRIENDLY,
									DOTA_UNIT_TARGET_HERO, 
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS,
									FIND_CLOSEST, 
									false)
	for i = 1, #heroes do
		local hero = heroes[1]
		for j = 0,8 do 
			local item = hero:GetItemInSlot(j)
			if item and item:GetName() == quest_item then
				local item_charges = item:GetCurrentCharges()
				if item_charges >= value_required then
					hero:RemoveItem( item )
					caster:DropQuestItem( hero, reward_item )
					hero:AddExperience(reward_exp, 0, false, true )
					hero:ModifyGold(reward_gold, false, 0)
					
					caster:RemoveAbility(ability:GetName())
				end
			end
		end
	end
end

function modifier_quest_meat_gathering:GetEffectName()
	return "particles/generic_gameplay/generic_has_quest.vpcf"
end

function modifier_quest_meat_gathering:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

meat_gathering = class({})

function meat_gathering:GetIntrinsicModifierName()
	return "modifier_meat_gathering"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_meat_gathering = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_EVENT_ON_DEATH,
		} end,
})
function modifier_meat_gathering:OnDeath( params )
	if IsServer() then
		local unit = params.unit
		local parent = self:GetParent()
		
		if unit == parent  then
			local point = unit:GetAbsOrigin()
			local newItem = CreateItem( "item_quest_meat", nil, nil )
			CreateItemOnPositionSync( point, newItem )
		end
	end

	return 0
end

function GoToZagon(keys)
	local unit = keys.activator
    if (unit:IsOwnedByAnyPlayer() ) and unit  then
 
	else
		local points = Entities:FindAllByName("gathering_meat_point")
		local point = points[RandomInt(1,#points)]:GetAbsOrigin()
		unit:MoveToPosition(point)
    end
end