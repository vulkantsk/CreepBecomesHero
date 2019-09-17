NPC_UNITS_CUSTOM = LoadKeyValues( "scripts/npc/npc_units_custom.txt" )

Cbh = Cbh or {
	playerCharacters = {}
}

require( "character" )

function Cbh:Init()
	GameRules:SetCustomGameSetupAutoLaunchDelay( 0 )
	GameRules:SetPreGameTime( 15 )
	GameRules:SetShowcaseTime( 0 )

	local ent = GameRules:GetGameModeEntity()

	ent:SetCameraDistanceOverride( 1500 )
	ent:SetCustomGameForceHero( "npc_dota_hero_wisp" )
	ent:SetFogOfWarDisabled( true )

	CustomNetTables:SetTableValue( "items", "22", { 131 } )

	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( self, "OnNPCSpawned" ), self )
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( self, "OnEntityKilled" ), self )
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( self, "OnGameRulesStateChange" ), self )
end

function Cbh:OnEntityKilled( keys )
	local victim = EntIndexToHScript( keys.entindex_killed )
	local killer = EntIndexToHScript( keys.entindex_attacker or -1 )

	if killer.character then
		killer.character:AddXP( NPC_UNITS_CUSTOM[victim:GetUnitName()].BountyXP or 0 )
	end

	if victim.character then
		victim.character:Respawn()
	end
end

function Cbh:OnGameRulesStateChange( keys )
	local state = GameRules:State_Get()

	if state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self.playerCharacters[0]:AddXP( 1000 )
	end
end

function Cbh:OnNPCSpawned( keys )
	local npc = EntIndexToHScript( keys.entindex )

	if npc:IsRealHero() then
		local id = npc:GetPlayerID()

		self.playerCharacters[id] = Character( id, npc:GetAbsOrigin(), npc:GetForwardVector() )
	end
end