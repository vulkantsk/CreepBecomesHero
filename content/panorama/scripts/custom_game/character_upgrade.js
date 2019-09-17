function CharacterUpgrade( parent, index ) {
	this.button = $.CreatePanel( "Button", parent, "" )
	this.button.AddClass( "CharacterUpgradeButton" )

	this.scenePanel = $.CreatePanel( "Panel", this.button, "" )
	this.scenePanel.AddClass( "CharacterUpgradeScene" )

	this.upgradeName = $.CreatePanel( "Label", this.button, "" )
	this.upgradeName.AddClass( "CharacterUpgradeName" )

	this.button.SetPanelEvent( "onactivate", function() {
		GameEvents.SendCustomGameEventToServer( "character_upgrade_" + localId, { upgrade: index } )
	} )

	this.SetUpgradeUnit = function( upgradeUnitName ) {
		if ( this.upgradeUnitName !== upgradeUnitName ) {
			this.scenePanel.RemoveAndDeleteChildren()
			this.scenePanel.BCreateChildren( '<DOTAScenePanel class="CharacterUpgradeScene" unit="' + upgradeUnitName + '"  light="global_light" antialias="true" renderdeferred="false" particleonly="false" />' )

			this.upgradeName.text = upgradeUnitName
			this.upgradeUnitName = upgradeUnitName
		}
	}

	this.SetVisible = function( visible ) {
		this.button.visible = visible
	}
}

function CharacterUpgradeBar() {
	this.box = $( "#CharacterUpgradeBox" )
	this.button = $( "#CharacterUpgradeButton" )
	this.characterUpgradesContainer = $( "#CharacterUpgradesContainer" )

	this.upgrades = []

	this.UpdateUpgrades = function( upgrades ) {
		var i = 0

		if ( upgrades ) {
			while ( true ) {
				var upgrade = upgrades[i.toString()]

				if ( !upgrade ) {
					break
				}

				if ( !this.upgrades[i] ) {
					this.upgrades[i] = new CharacterUpgrade( this.characterUpgradesContainer, i )
				}

				this.upgrades[i].SetUpgradeUnit( upgrade )

				i++
			}
		}

		for ( ; i < this.upgrades.length; i++ ) {
			this.upgrades[i].SetVisible( false )
		}
	}

	this.SetCanBeUpgrade = function( canBeUpgrade ) {
		if ( canBeUpgrade == 1 ) {
			this.box.visible = true
			this.button.visible = true
		} else {
			this.box.visible = false
			this.button.visible = false
		}
	}

	this.ToggleVisibilityBox = function() {
		this.box.ToggleClass( "Visible" )
	}
}