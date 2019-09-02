LinkLuaModifier("modifier_quest_herbs", "abilities/part_1/quest_herbs", LUA_MODIFIER_MOTION_NONE)

quest_herbs = class({})

function quest_herbs:GetIntrinsicModifierName()
	return "modifier_quest_herbs"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_quest_herbs = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_quest_herbs:OnCreated()
	self:StartIntervalThink(0.1)

	local points = Entities:FindAllByName("herbs_point")

	for i=1,8 do
		local point = points[i]
		point = point:GetAbsOrigin() + RandomVector(RandomInt(50,100))
		local newItem = CreateItem( "item_quest_herbs", nil, nil )
		local drop = CreateItemOnPositionSync( point, newItem )
	end
end

function modifier_quest_herbs:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local value_required = ability:GetSpecialValueFor("value_required")
	local reward_exp = ability:GetSpecialValueFor("reward_exp")
	local reward_gold = ability:GetSpecialValueFor("reward_gold")
	local quest_item = "item_quest_herbs"
	local reward_item = "item_quest_rusty_kirk_part_1"
	
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

function modifier_quest_herbs:GetEffectName()
	return "particles/generic_gameplay/generic_has_quest.vpcf"
end

function modifier_quest_herbs:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
