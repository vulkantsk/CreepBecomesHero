LinkLuaModifier("modifier_quest_golden_mine", "abilities/part_1/quest_golden_mine", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golden_mine", "abilities/part_1/quest_golden_mine", LUA_MODIFIER_MOTION_NONE)

quest_golden_mine = class({})

function quest_golden_mine:GetIntrinsicModifierName()
	return "modifier_quest_golden_mine"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_quest_golden_mine = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
})

function modifier_quest_golden_mine:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_quest_golden_mine:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()
	local value_required = ability:GetSpecialValueFor("value_required")
	local reward_exp = ability:GetSpecialValueFor("reward_exp")
	local reward_gold = ability:GetSpecialValueFor("reward_gold")
	local quest_item = "item_quest_gold"
	local reward_item1 = "item_quest_helm"
	local reward_item2 = "item_quest_armor"
	local reward_item3 = "item_quest_boots"
	
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
					caster:DropQuestItem( hero, reward_item1 )
					caster:DropQuestItem( hero, reward_item2 )
					caster:DropQuestItem( hero, reward_item3 )
					hero:AddExperience(reward_exp, 0, false, true )
					hero:ModifyGold(reward_gold, false, 0)
					
					caster:RemoveAbility(ability:GetName())
				end
			end
		end
	end
end

function modifier_quest_golden_mine:GetEffectName()
	return "particles/generic_gameplay/generic_has_quest.vpcf"
end

function modifier_quest_golden_mine:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

golden_mine = class({})

function golden_mine:GetIntrinsicModifierName()
	return "modifier_golden_mine"
end
--------------------------------------------------------
------------------------------------------------------------

modifier_golden_mine = class({
	IsHidden 				= function(self) return true end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return false end,
	DeclareFunctions		= function(self) return 
		{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		} end,
})
function modifier_golden_mine:OnAttackLanded( params )
	if IsServer() then
		local target = params.target
		local caster = self:GetCaster()
		local attacker = params.attacker
		print("gg")
		if target == caster and attacker:IsRealHero() and attacker:HasModifier("modifier_quest_rusty_kirk")  then
			local unit = target			
			local spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( "item_quest_gold", nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 150, 250 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.75, spawnPoint + RandomVector( dropRadius ) )
		end
	end

	return 0
end
