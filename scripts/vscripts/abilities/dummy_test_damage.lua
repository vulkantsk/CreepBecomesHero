
function ShowDamageTaken( event )
	-- Variables
	local damage = math.floor(event.DamageTaken)
	local caster = event.caster
--[[	
	if not caster.jinguPfx then
		caster.jinguPfx = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_quad_tap_stack.vpcf", PATTACH_OVERHEAD_FOLLOW, caster)
		ParticleManager:SetParticleControl(caster.jinguPfx, 0, caster:GetAbsOrigin())
	end
	ParticleManager:SetParticleControl(caster.jinguPfx, 1, Vector(0,damage,0))
]]
	PopupRedDamage(caster, damage)
--	caster:SetMaxHealth(caster:GetMaxHealth() + damage)
	caster:SetBaseMaxHealth(caster:GetMaxHealth() + damage)
	caster:SetHealth(caster:GetMaxHealth())


end

function ClearDamageFilter( event )
	local caster = event.caster
	caster:SetMaxHealth(1)
	caster:SetBaseMaxHealth(1)
	caster:SetHealth(1)
end
