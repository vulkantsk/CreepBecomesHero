var localId = Players.GetLocalPlayer()
var characterUnit = null
var characterUpgradeBar = null
var xpToUpLevel = 0

function LoadHud() {
	if ( !characterUpgradeBar ) {
		characterUpgradeBar = new CharacterUpgradeBar()
		characterUpgradeBar.SetCanBeUpgrade( false )
	}
}

function UpdateCharacterData( data ) {
	if ( data.unit !== characterUnit ) {
		characterUnit = data.unit

		LoadHud()
	}

	characterUpgradeBar.UpdateUpgrades( data.upgrades )
	characterUpgradeBar.SetCanBeUpgrade( data.level_to_upgrade <= data.level )

	$( "#Level" ).text = data.level

	var max_width = $( "#XPBar" ).actuallayoutwidth

	$( "#Progress" ).style.width = max_width * ( data.xp / data.xp_to_up_level ) + "px"
}

function OnUpdateSelectedUnit() {
	if ( characterUnit && characterUnit !== Players.GetLocalPlayerPortraitUnit() ) {
		GameUI.SelectUnit( characterUnit, false )
	}
}

function ToggleVisibilityBox( box ) {
	if ( box ) {
		box.ToggleVisibilityBox()
	}
}

SubscribeNetTable( "characters", localId.toString(), UpdateCharacterData )

GameEvents.Subscribe( "dota_player_update_selected_unit", OnUpdateSelectedUnit )