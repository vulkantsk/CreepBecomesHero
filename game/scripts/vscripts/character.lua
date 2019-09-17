local xpToUpLevel = {
	50,
	400,
	1000,
	2000,
	2500
}

Character = Character or class( {} )

function Character:constructor( id, pos, forward )
	self.id = id

	self.xp = 0
	self.level = 1

	self:SetUnit( "npc_cbh_character_soul", pos, forward )

	local upgrade = Dynamic_Wrap( Character, "Upgrade" )
	CustomGameEventManager:RegisterListener( "character_upgrade_" .. id, function( _, keys )
		upgrade( self, keys )
	end )
end

function Character:SetUnit( unitName, pos, forward )
	if self.unit then
		self.unit:Destroy()
	end

	self.data = NPC_UNITS_CUSTOM[unitName]

	if not self.data then
		error( "gg unit " .. unitName )
	end

	self.unit = CreateUnitByName( unitName, pos, true, nil, nil, DOTA_TEAM_GOODGUYS )
	self.unit:SetControllableByPlayer( self.id, true )
	self.unit:SetForwardVector( forward )
	self.unit:SetUnitCanRespawn( true )
	self.unit.character = self

	self:UpdateNetTable()
end

function Character:AddXP( xp )
	if self.xp then
		self.xp = self.xp + xp

		local xp_to_up = xpToUpLevel[self.level]

		if self.xp >= xp_to_up then
			self:LevelUp()
		end

		self:UpdateNetTable()
	end
end

function Character:LevelUp()
	self.level = self.level + 1

	if not xpToUpLevel[self.level] then
		self.xp = nil
	else
		local xp_to_next_level = self.xp - xpToUpLevel[self.level - 1]

		self.xp = 0
		self:AddXP( xp_to_next_level )
	end
end

function Character:Upgrade( keys )
	local upgrade = self.data.Upgrades[tostring( keys.upgrade )]

	if self.id ~= keys.PlayerID then
		return
	elseif not upgrade then
		return
	elseif self.level < self.data.LevelToUpgrade then
		return
	end

	self:SetUnit( upgrade, self.unit:GetAbsOrigin(), self.unit:GetForwardVector() )
end

function Character:Respawn()
	self.unit:RespawnUnit()
end

function Character:UpdateNetTable()
	local t = {
		upgrades = self.data.Upgrades,
		level_to_upgrade = self.data.LevelToUpgrade,
		unit = self.unit and self.unit:GetEntityIndex() or -1,
		level = self.level,
		xp_to_up_level = xpToUpLevel[self.level],
		xp = self.xp
	}

	CustomNetTables:SetTableValue( "characters", tostring( self.id ), t )
end