LinkLuaModifier("modifier_main_unit", "/units.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mini_boss", "/units.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_area_activated", "/units.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_checker", "/units.lua", LUA_MODIFIER_MOTION_NONE)

forest_activator = false
area_clear_duration = 5
if units == nil then
	_G. 	units = class({})
end

function units:Init()
	FindAllPoints( forest_area1 )
	FindAllPoints( forest_area2 )
	FindAllPoints( forest_area3 )
end

forest_area1 = {
	["area_name"] = "forest_area",
	["point_name"] = "forest_pointI_",
	["points"] = 0,
	["boss_point_name"] = "forest_boss_pointI_",
	["boss_points"] = 0,
	["strong_pct"] = 30,
	["simple_units"] = {"npc_dota_troll1","npc_dota_wolf1"},
	["strong_units"] = {"npc_dota_troll2","npc_dota_wolf2"},
	["squad_stacks"] = {1,2,3},
	["boss_units"] = {"npc_dota_troll2","npc_dota_wolf2"},
	["boss"] = {"npc_dota_troll_mb"},
	["boss_squad"] = {2,4,6,8},
}
forest_area2 = {
	["area_name"] = "forest_area",
	["point_name"] = "forest_pointII_",
	["points"] = 0,
	["boss_point_name"] = "forest_boss_pointII_",
	["boss_points"] = 0,
	["strong_pct"] = 30,
	["simple_units"] = {"npc_dota_harpy1","npc_dota_kobold1","npc_dota_kobold2"},
	["strong_units"] = {"npc_dota_harpy2","npc_dota_kobold3"},
	["squad_stacks"] = {2,3,4,5},
	["boss_units"] = {"npc_dota_harpy2","npc_dota_kobold3"},
	["boss"] = {"npc_dota_kobold_mb"},
	["boss_squad"] = {2,4,6,8},
}
forest_area3 = {
	["area_name"] = "forest_area",
	["point_name"] = "forest_pointIII_",
	["points"] = 0,
	["boss_point_name"] = "forest_boss_pointIII_",
	["boss_points"] = 0,
	["strong_pct"] = 30,
	["simple_units"] = {"npc_dota_troll3","npc_dota_centaur1"},
	["strong_units"] = {"npc_dota_troll4","npc_dota_centaur2"},
	["squad_stacks"] = {2,3,4,5},
	["boss_units"] = {"npc_dota_troll4","npc_dota_centaur2"},
	["boss"] = {"npc_dota_centaur_mb"},
	["boss_squad"] = {2,4,6,8},
}
	 
function SpawnUnitsAnime( kv )
	print("anime")
	if forest_activator == false then
		print("forest_activator = false")
	else
		print("forest_activator = true")
	end
	
	local name = thisEntity:GetName()
	
	if name == "forest_spawner" and forest_activator == false then
		print("forest_spawner")
		forest_activator = true
--		LocationActivate("forest_activator")
		SpawnUnitsInArea( forest_area1 )		
		SpawnUnitsInArea( forest_area2 )		
		SpawnUnitsInArea( forest_area3 )		
	end
end

function LocationActivate( location_name )
	local dummy = Entities:FindByName(nil, location_name)
	dummy:AddNewModifier(dummy, nil, "modifier_area_activated",nil)
	
end

function SpawnUnitsInArea( area )
	local points = area["points"]
	print("points = "..points)	
	for i=1,points do
		SpawnUnits(area , i)		
	end
	
	SpawnBossUnits(area)
	
end

function SpawnUnits(area, point_number)
	local point_name = area["point_name"]
	local area_name = area["area_name"]
	local strong_pct =   area["strong_pct"]
	local simple_units = area["simple_units"]
	local strong_units = area["strong_units"]
	local squad_stacks = area["squad_stacks"]
	
	
	local point = Entities:FindByName( nil, point_name..point_number):GetAbsOrigin()
	local unit_number = squad_stacks[math.random(#squad_stacks)]	-- unit number in squad
	for i = 1,unit_number do
	
		local unit_name
		if RollPercentage(strong_pct) then
			unit_name = strong_units[math.random(#strong_units)]
		else
			unit_name = simple_units[math.random(#simple_units)]
		end
		
		local unit = CreateUnitByName( unit_name , point + RandomVector( RandomFloat( 50, 150 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
		unit.area = area_name
		if i == 1 then
			print("point_number = "..point_number)
			local modifier = unit:AddNewModifier(unit, nil, "modifier_main_unit", {})
			modifier.area = area
			modifier.point_number = point_number
		end
	end	
end

function SpawnBossUnits(area)
	local boss_points = area["boss_points"]
	local point_number =  math.random(boss_points)
	local boss_point_name = area["boss_point_name"]
	local area_name = area["area_name"]
	local boss = area["boss"]
	local boss_units = area["boss_units"]
	local boss_squad = area["boss_squad"]
	
	
	local point = Entities:FindByName( nil, boss_point_name..point_number):GetAbsOrigin()
	local unit_number = boss_squad[math.random(#boss_squad)]	-- unit number in squad

	local unit = CreateUnitByName( boss[1] , point + RandomVector( RandomFloat( 50, 150 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
	unit.area = area_name
	local modifier = unit:AddNewModifier(unit, nil, "modifier_mini_boss", {})
	modifier.area = area
	
	for i = 1,unit_number do
	
		local unit_name = boss_units[math.random(#boss_units)]

		local unit = CreateUnitByName( unit_name , point + RandomVector( RandomFloat( 50, 150 ) ), true, nil, nil, DOTA_TEAM_NEUTRALS )
		unit.area = area_name

	end	
end

function FindAllPoints( area )
	local point_name = area["point_name"]
	local boss_point_name = area["boss_point_name"]
	local index = 1
	print("point_name = "..point_name..index)
	
	local point = Entities:FindByName( nil, point_name..index):GetAbsOrigin()
	
	while point do
		index = index + 1
		point = Entities:FindByName( nil, point_name..index)
	end
	
	point = Entities:FindByName( nil, point_name..index+1)
	if point then
		print("break found in index = "..index)
	end
	area["points"] = index - 1
	print("points = "..index-1)

	index = 1
	local boss_point = Entities:FindByName( nil, boss_point_name..index):GetAbsOrigin()
	
	while boss_point do
		index = index + 1
		boss_point = Entities:FindByName( nil, boss_point_name..index)
	end
	
	boss_point = Entities:FindByName( nil, boss_point_name..index+1)
	if boss_point then
		print("break found in index = "..index)
	end
	area["boss_points"] = index - 1
	print("boss points = "..index-1)

end

-------------------------------------------------------------------
-------------------------------------------------------------------
modifier_main_unit = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH} end,
})

function modifier_main_unit:OnCreated( kv )
--DeepPrintTable(kv)
	if kv.point_number and kv.point_number then
--		 self.point_number = kv.point_number
--		 self.area = kv.area
--		 self.point_name = kv.point_name
		 print("point_number"..self.point_number.." point_name = "..self.point_name)
	end
		
end

function modifier_main_unit:OnDeath(keys)
	local parent = self:GetParent()
	local unit = keys.unit
	
	if parent == unit then
--[[		local area
		if 		self.point_name == "forest_pointI_" then area = forest_area1
		elseif	self.point_name == "forest_pointII_" then area = forest_area2
		elseif	self.point_name == "forest_pointIII_" then area = forest_area3
		end
]]
		Timers:CreateTimer(10, function()
			SpawnUnits(self.area , self.point_number)
		end)
	end
end

-------------------------------------------------------------------
-------------------------------------------------------------------
modifier_mini_boss = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH} end,
})

function modifier_mini_boss:OnCreated( kv )
--DeepPrintTable(kv)
	if kv.point_number and kv.point_number then
--		 self.point_number = kv.point_number
--		 self.area = kv.area
--		 self.point_name = kv.point_name
		 print("point_number"..self.point_number.." point_name = "..self.point_name)
	end
		
end

function modifier_mini_boss:OnDeath(keys)
	local parent = self:GetParent()
	local unit = keys.unit
	
	if parent == unit then
--[[		local area
		if 		self.point_name == "forest_pointI_" then area = forest_area1
		elseif	self.point_name == "forest_pointII_" then area = forest_area2
		elseif	self.point_name == "forest_pointIII_" then area = forest_area3
		end
]]
		Timers:CreateTimer(10, function()
			SpawnBossUnits(self.area)
		end)
	end
end

-------------------------------------------------------------------
-------------------------------------------------------------------

modifier_area_activated = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH} end,
})

function modifier_area_activated:OnCreated( kv )
--DeepPrintTable(kv)
	self:StartIntervalThink(1)

	local parent = self:GetParent()
	local radius = 1000
	local point = parent:GetAbsOrigin()
	local pid = ParticleManager:CreateParticle("particles/units/heroes/hero_witchdoctor/witchdoctor_voodoo_restoration.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)		

	ParticleManager:SetParticleControl(pid, 0, point)
	ParticleManager:SetParticleControl(pid, 1, Vector(radius,radius,radius))
	parent:AddNewModifier(parent, nil, "modifier_hero_checker", {duration = area_clear_duration})
		
end

function modifier_area_activated:OnIntervalThink()
	local parent = self:GetParent()
	local radius = 1000
	local point = parent:GetAbsOrigin()
	local enemies = FindUnitsInRadius( 
			DOTA_TEAM_NEUTRALS, 
			point, 
			nil, 
			radius, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, 
			FIND_CLOSEST, 
			false )
	local effect = "particles/units/heroes/hero_centaur/centaur_warstomp.vpcf"
	local pfx = ParticleManager:CreateParticle(effect, PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControl(pfx, 0, point) -- Origin
	ParticleManager:SetParticleControl(pfx, 1, Vector(radius, radius, radius)) -- Destination
			
	if #enemies > 0 then
		parent:AddNewModifier(parent, nil, "modifier_hero_checker", {duration = area_clear_duration})
		print("Heroes finded !")
	else
		print("Heroes NOT finded !!!")
	end
end

-------------------------------------------------------------------
-------------------------------------------------------------------

modifier_hero_checker = class({
	IsHidden 				= function(self) return false end,
	IsPurgable 				= function(self) return false end,
	IsDebuff 				= function(self) return false end,
	IsBuff                  = function(self) return true end,
	RemoveOnDeath 			= function(self) return true end,
--	GetAttributes 			= function(self) return MODIFIER_ATTRIBUTE_MULTIPLE end,
	DeclareFunctions		= function(self) return 
		{MODIFIER_EVENT_ON_DEATH} end,
})
function modifier_hero_checker:OnCreated( kv )
	print("modifier created !")
end

function modifier_hero_checker:OnDestroy( kv )
	local parent = self:GetParent()
	local name = parent:GetName()
	local area_name
	
	print("Apocalypse !!!")
	parent:RemoveModifierByName("modifier_area_activated")
	if name == "forest_activator" then
		area_name = "forest_area"
		forest_activator = false
		if forest_activator == false then
			print("forest_activator = false")
		else
			print("forest_activator = true")
		end
	end
	
    local creatures = Entities:FindAllByClassname('npc_dota_creature')
    for i = 1, #creatures do
        local creature = creatures[i]
		if creature.area == area_name then
			creature:RemoveSelf()
		end
    end	
	
	if forest_activator == false then
		print("forest_activator = false")
	else
		print("forest_activator = true")
	end
		
end

