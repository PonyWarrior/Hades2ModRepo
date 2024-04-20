local mod = PonyMenu

ModUtil.Path.Wrap( "SetupMap", function(baseFunc)
    LoadPackages({Names = {
        "ZeusUpgrade",
        "AphroditeUpgrade",
        "ApolloUpgrade",
        "DemeterUpgrade",
        "HephaestusUpgrade",
        "HestiaUpgrade",
        "PoseidonUpgrade",
    }})
    return baseFunc()
end)

local mouseOverCommandItem, mouseOffCommandItem

local function setupData()

	mod.BoonData = {
		ZeusUpgrade = {},
		PoseidonUpgrade = {},
		AphroditeUpgrade = {},
		ApolloUpgrade = {},
		DemeterUpgrade = {},
		HephaestusUpgrade = {},
		HestiaUpgrade = {},
		ArtemisUpgrade = {},
		SpellDrop = {},
		WeaponUpgrade = {},
		Arachne = {},
	}

	mod.CommandData = {
		{
			Icon = "BoonSymbolZeusIcon",
			IconScale = 0.6,
			Name = "ZeusUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolPoseidonIcon",
			IconScale = 0.6,
			Name = "PoseidonUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolAphroditeIcon",
			IconScale = 0.6,
			Name = "AphroditeUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolApolloIcon",
			IconScale = 0.6,
			Name = "ApolloUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolDemeterIcon",
			IconScale = 0.6,
			Name = "DemeterUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolHephaestusIcon",
			IconScale = 0.6,
			Name = "HephaestusUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonDropHestiaPreview",
			IconScale = 0.6,
			Name = "HestiaUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolArtemisIcon",
			IconScale = 0.6,
			Name = "ArtemisUpgrade",
			Type = "Boon"
		},
        {
			Icon = "SpellDropPreview",
			IconScale = 0.6,
			Name = "SpellDrop",
			Type = "Boon",
			NoRarity = true
		},
        {
			Icon = "WeaponUpgradeSymbol",
			IconScale = 0.6,
			Name = "WeaponUpgrade",
			Type = "Boon",
            NoRarity = true
		},
		{
			Icon = "ArmorBoost",
			IconScale = 0.6,
			Name = "Arachne",
			Type = "Boon",
		},
		{
			Icon = "TrashButtonFlash",
			IconScale = 0.6,
			Name = "Clear all boons",
			Description = "Removes all equipped boons.",
			Type = "Command",
			Function = mod.ClearAllBoons
		},
		{
			Icon = "CharonPointsDrop",
			IconScale = 0.6,
			Name = "Boon Manager",
			Description = "Opens the boon manager. Let's you manage your boons. You can delete and upgrade any boon you have.",
			Type = "Command",
			Function = mod.OpenBoonManager
		},
		{
			IconPath = "GUI\\Screens\\Inventory\\Icon-Resources",
			IconScale = 0.6,
			Name = "Resource Menu",
			Description = "Spawn any resource in any amount.",
			Type = "Command",
			Function = mod.OpenResourceMenu
		},
		-- {
		--     IconPath = "GUI\\HUD\\RefreshIcon",
		--     IconScale = 0.8,
		--     Name = "Reload room",
		--     Description = "Reloads the room, resetting mostly everything.",
		--     Type = "Command",
		--     Function = mod.ReloadRoom
		-- },
		-- {
		--     IconPath = "GUI\\Screens\\MetaUpgrade\\CardTypeIcon_Death",
		--     IconScale = 0.8,
		--     Name = "Kill Player",
		--     Description = "Kills the player.",
		--     Type = "Command",
		--     Function = mod.KillPlayer
		-- },
        -- {
		--     IconPath = "GUI\\Screens\\MetaUpgrade\\CardTypeIcon_Death",
		--     IconScale = 0.8,
		--     Name = "Toggle Child/Adult",
		--     Description = "Switches between child and adult Melinoe, applies after leaving the room.",
		--     Type = "Command",
		--     Function = mod.ToggleChildForm
		-- },

	}

	ModUtil.Table.Merge(ScreenData, { 
		BoonSelector = {
			Components = {},
			OpenSound = "/SFX/Menu Sounds/HadesLocationTextAppear",
			Name = "BoonSelector",
			Rarity = "Common",
			RowStartX = - (ScreenCenterX * 0.65),
			RowStartY = - (ScreenCenterY * 0.5),
			ComponentData =
			{
				DefaultGroup = "Combat_Menu_TraitTray_Backing",
				UseNativeScreenCenter = true,

				BackgroundTint =
				{
					Graphic = "rectangle01",
					GroupName = "Combat_Menu_TraitTray_Backing",
					Scale = 10,
					X = ScreenCenterX,
					Y = ScreenCenterY,
				},

				Background = 
				{
					AnimationName = "Box_FullScreen",
					GroupName = "Combat_Menu_TraitTray",
					X = ScreenCenterX,
					Y = ScreenCenterY,
					Scale = 1.15,
					Text = "Boon Selector",
					TextArgs =
					{
						FontSize = 32,
						Width = 750,
						OffsetY = - (ScreenCenterY * 0.825),
						Color = Color.White,
						Font = "P22UndergroundSCHeavy",
						ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 3},
					},

					Children =
					{
                        SpawnButton = 
						{
                            Name = "ButtonDefault",
                            Group = "Combat_Menu_TraitTray",
                            Scale = 1.2,
                            ScaleX = 1.15,
                            OffsetX = 0,
                            OffsetY = 200,
                            Text = "Spawn regular boon",
                            TextArgs =
                            {
                                FontSize = 22,
                                Width = 720,
                                Color = Color.White,
                                Font = "P22UndergroundSCMedium",
                                ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                                Justification = "Center"
                            },
                            Data = {
                                OnPressedFunctionName = mod.SpawnBoon,
                            },
						},
                        --Rarity buttons
                        CommonButton =
						{
                            Name = "ButtonDefault",
                            Group = "Combat_Menu_TraitTray",
                            Scale = 1.2,
                            ScaleX = 0.8,
                            OffsetX = -450,
                            OffsetY = 300,
                            Text = "Common",
                            TextArgs =
                            {
                                FontSize = 22,
                                Width = 720,
                                Color = Color.BoonPatchCommon,
                                Font = "P22UndergroundSCMedium",
                                ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                                Justification = "Center"
                            },
                            Data = {
                                OnPressedFunctionName = mod.ChangeBoonSelectorRarity,
                                Rarity = "Common",
                            },
						},
                        RareButton =
						{
                            Name = "ButtonDefault",
                            Group = "Combat_Menu_TraitTray",
                            Scale = 1.2,
                            ScaleX = 0.8,
                            OffsetX = -150,
                            OffsetY = 300,
                            Text = "Rare",
                            TextArgs =
                            {
                                FontSize = 22,
                                Width = 720,
                                Color = Color.BoonPatchRare,
                                Font = "P22UndergroundSCMedium",
                                ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                                Justification = "Center"
                            },
                            Data = {
                                OnPressedFunctionName = mod.ChangeBoonSelectorRarity,
                                Rarity = "Rare",
                            },
						},
                        EpicButton =
						{
                            Name = "ButtonDefault",
                            Group = "Combat_Menu_TraitTray",
                            Scale = 1.2,
                            ScaleX = 0.8,
                            OffsetX = 150,
                            OffsetY = 300,
                            Text = "Epic",
                            TextArgs =
                            {
                                FontSize = 22,
                                Width = 720,
                                Color = Color.BoonPatchEpic,
                                Font = "P22UndergroundSCMedium",
                                ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                                Justification = "Center"
                            },
                            Data = {
                                OnPressedFunctionName = mod.ChangeBoonSelectorRarity,
                                Rarity = "Epic",
                            },
						},
                        HeroicButton =
						{
                            Name = "ButtonDefault",
                            Group = "Combat_Menu_TraitTray",
                            Scale = 1.2,
                            ScaleX = 0.8,
                            OffsetX = 450,
                            OffsetY = 300,
                            Text = "Heroic",
                            TextArgs =
                            {
                                FontSize = 22,
                                Width = 720,
                                Color = Color.BoonPatchHeroic,
                                Font = "P22UndergroundSCMedium",
                                ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                                Justification = "Center"
                            },
                            Data = {
                                OnPressedFunctionName = mod.ChangeBoonSelectorRarity,
                                Rarity = "Heroic",
                            },
						},
						CloseButton = 
						{
							Graphic = "ButtonClose",
							GroupName = "Combat_Menu_TraitTray",
                            Scale = 0.7,
							OffsetX = 0,
							OffsetY = ScreenCenterY - 70,
							Data =
							{
								OnPressedFunctionName = mod.CloseBoonSelector,
								ControlHotkeys = { "Cancel", },
							},
						},
					}
				},
			}
		},

		ResourceMenu = {
			Components = {},
			OpenSound = "/SFX/Menu Sounds/HadesLocationTextAppear",
			Name = "ResourceMenu",
			Rarity = "None",
			Amount = 0,
			RowStartX = - (ScreenCenterX * 0.65),
			RowStartY = - (ScreenCenterY * 0.5),
			ComponentData =
			{
				DefaultGroup = "Combat_Menu_TraitTray_Backing",
				UseNativeScreenCenter = true,

				BackgroundTint =
				{
					Graphic = "rectangle01",
					GroupName = "Combat_Menu_TraitTray_Backing",
					Scale = 10,
					X = ScreenCenterX,
					Y = ScreenCenterY,
				},

				Background = 
				{
					AnimationName = "Box_FullScreen",
					GroupName = "Combat_Menu_TraitTray",
					X = ScreenCenterX,
					Y = ScreenCenterY,
					Scale = 1.15,
					Text = "Resource Menu",
					TextArgs =
					{
						FontSize = 32,
						Width = 750,
						OffsetY = - (ScreenCenterY * 0.825),
						Color = Color.White,
						Font = "P22UndergroundSCHeavy",
						ShadowBlur = 0, ShadowColor = {0,0,0,0}, ShadowOffset={0, 3},
					},

					Children =
					{
						-- Resource buttons
						NectarButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -450,
							OffsetY = -390,
							Text = "Nectar",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "GiftPoints",
								ResourceDisplay = "Nectar"
							},
						},
						BoneButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -180,
							OffsetY = -390,
							Text = "Bones",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "MetaCurrency",
								ResourceDisplay = "Bones"
							},
						},
						AshButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 90,
							OffsetY = -390,
							Text = "Ashes",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "MetaCardPointsCommon",
								ResourceDisplay = "Ashes"
							},
						},
						PsycheButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 360,
							OffsetY = -390,
							Text = "Psyche",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "MemPointsCommon",
								ResourceDisplay = "Psyche"
							},
						},
						FabricButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -450,
							OffsetY = -320,
							Text = "Fate Fabric",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "MetaFabric",
								ResourceDisplay = "Fate Fabric"
							},
						},
						SilverButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -180,
							OffsetY = -320,
							Text = "Silver",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "OreFSilver",
								ResourceDisplay = "Silver"
							},
						},
						CinderButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 90,
							OffsetY = -320,
							Text = "Cinder",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "MixerFBoss",
								ResourceDisplay = "Cinder"
							},
						},
						MolyButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 360,
							OffsetY = -320,
							Text = "Moly",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "PlantFMoly",
								ResourceDisplay = "Moly"
							},
						},
						NightShadeButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -450,
							OffsetY = -250,
							Text = "Nightshade",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "PlantFNightshade",
								ResourceDisplay = "Nightshade"
							},
						},
						NightShadeSeedsButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -180,
							OffsetY = -250,
							Text = "Nightshade Seeds",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "PlantFNightshadeSeed",
								ResourceDisplay = "Nightshade Seeds"
							},
						},
						DeathcapButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 90,
							OffsetY = -250,
							Text = "Deathcap",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "PlantMoney",
								ResourceDisplay = "Deathcap"
							},
						},
						MysterySeedButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 360,
							OffsetY = -250,
							Text = "Mystery Seeds",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResource,
								Resource = "SeedMystery",
								ResourceDisplay = "Mystery Seeds"
							},
						},
						-- Amount Buttons
						IncreaseButton1 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -450,
							OffsetY = -40,
							Text = "+1",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = 1
							},
						},
						IncreaseButton2 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -180,
							OffsetY = -40,
							Text = "+10",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = 10
							},
						},
						IncreaseButton3 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 90,
							OffsetY = -40,
							Text = "+100",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = 100
							},
						},
						IncreaseButton4 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 360,
							OffsetY = -40,
							Text = "+1000",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = 1000
							},
						},

						DecreaseButton1 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -450,
							OffsetY = 30,
							Text = "-1",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = -1
							},
						},
						DecreaseButton2 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = -180,
							OffsetY = 30,
							Text = "-10",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = -10
							},
						},
						DecreaseButton3 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 90,
							OffsetY = 30,
							Text = "-100",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = -100
							},
						},
						DecreaseButton4 = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.0,
							ScaleX = 0.8,
							OffsetX = 360,
							OffsetY = 30,
							Text = "-1000",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.ChangeTargetResourceAmount,
								Amount = -1000
							},
						},
						-- Spawn button
						SpawnButton = {
							Name = "ButtonDefault",
							Group = "Combat_Menu_TraitTray",
							Scale = 1.2,
							ScaleX = 1.15,
							OffsetX = -50,
							OffsetY = 350,
							Text = "Spawn Resource",
							TextArgs =
							{
								FontSize = 22,
								Width = 720,
								Color = Color.White,
								Font = "P22UndergroundSCMedium",
								ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
								Justification = "Center"
							},
							Data = {
								OnPressedFunctionName = mod.SpawnResource,
							},
						},
						CloseButton = 
						{
							Graphic = "ButtonClose",
							GroupName = "Combat_Menu_TraitTray",
                            Scale = 0.7,
							OffsetX = 0,
							OffsetY = ScreenCenterY - 70,
							Data =
							{
								OnPressedFunctionName = mod.CloseBoonSelector,
								ControlHotkeys = { "Cancel", },
							},
						},
					}
				},
			}
		}
	})
	
end

-- Is it possible this could be done with ModUtil.Path.Context.Wrap?
ModUtil.Path.Override("InventoryScreenDisplayCategory", function (screen, categoryIndex, args )

	args = args or {}
	local components = screen.Components

	-- Cleanup prev category
	local prevCategory = screen.ItemCategories[screen.ActiveCategoryIndex]
	if prevCategory.CloseFunctionName ~= nil then
		CallFunctionName( prevCategory.CloseFunctionName, screen )
	else
		for i, resourceName in ipairs( prevCategory ) do
			if components[resourceName] ~= nil then
				Destroy({ Id = components[resourceName].Id })
			end
		end
	end

	ModifyTextBox({ Id = components.InfoBoxName.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDescription.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDetails.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxFlavor.Id, FadeTarget = 0.0, })
	if screen.Components["Category"..prevCategory.Name] ~= nil then
		StopAnimation({ DestinationId = screen.Components["Category"..prevCategory.Name].Id, Name = "InventoryTabHighlightActiveCategory" })
	end

	local category = screen.ItemCategories[categoryIndex]
	if category.Locked then
		return
	end
	local slotName = category.Name

	-- Highlight new category
	CreateAnimation({ DestinationId = screen.Components["Category"..slotName].Id, Name = "InventoryTabHighlightActiveCategory", Group = "Combat_Menu_TraitTray" })
	ModifyTextBox({ Id = screen.Components.CategoryTitleText.Id, Text = category.Name })

	screen.ActiveCategoryIndex = categoryIndex

	SetAnimation({ DestinationId = components.Background.Id, Name = category.Background or screen.ComponentData.Background.AnimationName })

	if category.GamepadNavigation ~= nil then
		SetGamepadNavigation( category )
	else
		SetGamepadNavigation( screen )
	end

	if category.OpenFunctionName ~= nil then
		CallFunctionName( category.OpenFunctionName, screen )
		return
	end
	
	local resourceLocation = { X = screen.GridStartX, Y = screen.GridStartY }
	local columnNum = 1
    -- Mod start
    if category.Name ~= "Pony Menu" then
        for i, resourceName in ipairs( category ) do

            local resourceData = ResourceData[resourceName]
            if (GameState.LifetimeResourcesGained[resourceName] or 0) > 0 or ( resourceData.RevealGameStateRequirements ~= nil and IsGameStateEligible( CurrentRun, resourceData, resourceData.RevealGameStateRequirements ) ) then
    
                local textLines = nil
                local canBeGifted = false
                local canBePlanted = false
                if screen.Args.PlantTarget ~= nil then
                    if GardenData.Seeds[resourceName] then
                        canBePlanted = true
                    end
                elseif screen.Args.GiftTarget ~= nil then
                    if screen.Args.GiftTarget.UnlimitedGifts ~= nil and screen.Args.GiftTarget.UnlimitedGifts[resourceName] then
                        canBeGifted = true
                    else
                        local spending = {}
                        spending[resourceName] = 1
                        textLines = GetRandomEligibleTextLines( screen.Args.GiftTarget, screen.Args.GiftTarget.GiftTextLineSets, GetNarrativeDataValue( screen.Args.GiftTarget, "GiftTextLinePriorities" ), { Spending = spending } )
                        if textLines ~= nil then
                            canBeGifted = true
                        end
                    end
                end
    
                local button = CreateScreenComponent({ Name = "ButtonInventoryItem", Scale = resourceData.IconScale or 1.0, Sound = "/SFX/Menu Sounds/GodBoonMenuClose", Group = "Combat_Menu_Overlay", X = resourceLocation.X, Y = resourceLocation.Y })
                AttachLua({ Id = button.Id, Table = button })
                button.Screen = screen
                button.ResourceData = resourceData
                components[resourceName] = button
                SetAnimation({ DestinationId = button.Id, Name = resourceData.IconPath or resourceData.Icon })
            
                if canBePlanted then
                    if HasResource( resourceName, 1 ) then
                        button.ContextualAction = "Menu_Plant"
                        button.OnPressedFunctionName = "GardenPlantSeed"
                    else
                        SetColor({ Id = button.Id, Color = Color.Black })
                        button.Description = "InventoryScreen_SeedNotAvailable"
                    end
                elseif canBeGifted then
                    if HasResource( resourceName, 1 ) then
                        button.ContextualAction = "Menu_Gift"
                        button.OnPressedFunctionName = "GiveSelectedGift"
                        button.TextLines = textLines
                    else
                        SetColor({ Id = button.Id, Color = Color.Black })
                        button.Description = "InventoryScreen_GiftNotAvailable"
                    end				
                elseif screen.Args.PlantTarget ~= nil then
                    SetColor({ Id = button.Id, Color = Color.Black })
                    button.Description = "InventoryScreen_SeedNotWanted"
                elseif screen.Args.GiftTarget ~= nil then
                    SetColor({ Id = button.Id, Color = Color.Black })
                    button.Description = "InventoryScreen_GiftNotWanted"
                end
    
                CreateTextBoxWithScreenFormat( screen, button, "ResourceCountFormat", { Text = GameState.Resources[resourceName] or 0 } )
    
                button.MouseOverSound = "/SFX/Menu Sounds/DialoguePanelOutMenu"
                button.OnMouseOverFunctionName = "MouseOverResourceItem"
                button.OnMouseOffFunctionName = "MouseOffResourceItem"
    
                if (resourceName == args.InitialSelection) or (args.InitialSelection == nil and resourceName == GameState.UnviewedLastResourceGained) then
                    UnviewedLastResourceGainedPresentation( screen, button )
                    GameState.UnviewedLastResourceGained = nil
                    TeleportCursor({ OffsetX = resourceLocation.X, OffsetY = resourceLocation.Y, ForceUseCheck = true })
                    screen.CursorSet = true
                end
    
                if columnNum < screen.GridWidth then
                    columnNum = columnNum + 1
                    resourceLocation.X = resourceLocation.X + screen.GridSpacingX
                else
                    resourceLocation.Y = resourceLocation.Y + screen.GridSpacingY
                    resourceLocation.X = screen.GridStartX
                    columnNum = 1
                end
            end
            
        end
    else
        -- CloseInventoryScreen(screen, screen.ComponentData.ActionBar.Children.CloseButton)
        -- Pony Menu
        for index, k in ipairs( mod.CommandData ) do
            -- for the clean up to work
            table.insert(category, index)

            local itemData = mod.CommandData[index]
            local button = CreateScreenComponent({ Name = "ButtonInventoryItem", Scale = itemData.IconScale or 1.0, Sound = "/SFX/Menu Sounds/GodBoonMenuClose", Group = "Combat_Menu_Overlay", X = resourceLocation.X, Y = resourceLocation.Y })
            AttachLua({ Id = button.Id, Table = button })
            button.Screen = screen
            button.ItemData = itemData
            components[index] = button
            SetAnimation({ DestinationId = button.Id, Name = itemData.IconPath or itemData.Icon })

            -- CreateTextBoxWithScreenFormat( screen, button, "ResourceCountFormat", { Text = itemData.Name or "WIP" } )

            button.MouseOverSound = "/SFX/Menu Sounds/DialoguePanelOutMenu"
            button.OnMouseOverFunctionName = mouseOverCommandItem
            button.OnMouseOffFunctionName = mouseOffCommandItem
            button.OnPressedFunctionName = mod.Command

            if columnNum < screen.GridWidth then
                columnNum = columnNum + 1
                resourceLocation.X = resourceLocation.X + screen.GridSpacingX
            else
                resourceLocation.Y = resourceLocation.Y + screen.GridSpacingY
                resourceLocation.X = screen.GridStartX
                columnNum = 1
            end
        end
    end
    -- Mod end
end, mod )

function mouseOverCommandItem( button )

	local screen = button.Screen
	if screen.Closing then
		return
	end

	GenericMouseOverPresentation( button )

	local components = screen.Components
    local buttonHighlight = CreateScreenComponent({ Name = "InventorySlotHighlight", Scale = 1.0, Group = "Combat_Menu_Overlay", DestinationId = button.Id })
    components.InventorySlotHighlight = buttonHighlight
    button.HighlightId = buttonHighlight.Id
    Attach({ Id = buttonHighlight.Id, DestinationId = button.Id })
    ModifyTextBox({ Id = components.InfoBoxName.Id,
        Text = button.ItemData.Name,
        UseDescription = false,
        FadeTarget = 1.0,
    })
    ModifyTextBox({ Id = components.InfoBoxDescription.Id,
        Text = button.ItemData.Description or " ",
        UseDescription = false,
        FadeTarget = 1.0,
    })

	SetScale({ Id = button.Id, Fraction = (button.ItemData.IconScale or 1.0) * screen.IconMouseOverScale, Duration = 0.1, EaseIn = 0.9, EaseOut = 1.0, SkipGeometryUpdate = true })
	--StopFlashing({ Id = button.Id })
	UpdateResourceInteractionText( screen, button )
end

function mouseOffCommandItem( button )
	Destroy({ Id = button.HighlightId })
	local components = button.Screen.Components
	components.InventorySlotHighlight = nil
	ModifyTextBox({ Id = components.InfoBoxName.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDescription.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDetails.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxFlavor.Id, FadeTarget = 0.0, })
	SetScale({ Id = button.Id, Fraction = button.ItemData.IconScale or 1.0, Duration = 0.1, SkipGeometryUpdate = true })
	StopFlashing({ Id = button.Id })
	UpdateResourceInteractionText( button.Screen )
end

function mod.Command (screen, button)
    local command = button.ItemData
    local triggerArgs = {}
    if command.Type == "Boon" then
        mod.OpenBoonSelector(screen, button)
    elseif command.Type == "Command" then
        CloseInventoryScreen(screen, screen.ComponentData.ActionBar.Children.CloseButton)
        _G[command.Function]()
    end
end

function mod.PopulateBoonData (upgradeName)
    local godName = string.gsub(upgradeName, 'Upgrade', '')
    local index = 0

    if LootSetData[godName] ~= nil and LootSetData[godName][upgradeName].WeaponUpgrades ~= nil then
        for k, v in pairs (LootSetData[godName][upgradeName].WeaponUpgrades) do
            index = index + 1
            mod.BoonData[upgradeName][index] = v
        end
    end

    if LootSetData[godName] ~= nil and LootSetData[godName][upgradeName].Traits ~= nil then
		for k, v in pairs (LootSetData[godName][upgradeName].Traits) do
			index = index + 1
			mod.BoonData[upgradeName][index] = v
		end
    end

    if mod.BoonData[upgradeName] == nil or IsEmpty(mod.BoonData[upgradeName]) then
        if upgradeName == "SpellDrop" then
            for k, v in pairs (QuestData.QuestDarkSorceries.CompleteGameStateRequirements[1].HasAll) do
                index = index + 1
                mod.BoonData[upgradeName][index] = v
            end
		elseif upgradeName == "WeaponUpgrade" then
			local wp = GetEquippedWeapon()
			for k, v in pairs (LootSetData.Loot[upgradeName].Traits) do
				index = index + 1
				local boon = TraitData[v]
				if boon.RequiredWeapon == wp then
					mod.BoonData[upgradeName][index] = v
				end
			end
		elseif upgradeName == "Arachne" then
			for k, v in pairs (PresetEventArgs.ArachneCostumeChoices.UpgradeOptions) do
                index = index + 1
                mod.BoonData[upgradeName][index] = v.ItemName
            end
		elseif upgradeName == "ArtemisUpgrade" then
			for k, v in pairs (UnitSetData.NPC_Artemis.NPC_Artemis_Field_01.Traits) do
                index = index + 1
                mod.BoonData[upgradeName][index] = v
            end
        end
    end

end

function mod.GetLootColor (upgradeName)
    local godName = string.gsub(upgradeName, 'Upgrade', '')
    local color = Color.Black
    if mod.Config.ColorblindMode == true then
        return color
    end
    if LootSetData[godName] ~= nil then
        color = LootSetData[godName][upgradeName].LootColor
    elseif upgradeName == "SpellDrop" then
        color = LootSetData.Selene[upgradeName].LootColor
    elseif upgradeName == "WeaponUpgrade" then
        color = LootSetData.Loot[upgradeName].LootColor
    elseif upgradeName == "Arachne" then
        color = Color.ArachneVoice
    elseif upgradeName == "ArtemisUpgrade" then
        color = UnitSetData.NPC_Artemis.NPC_Artemis_Field_01.LootColor
    end
    return color
end

function mod.GetLootColorFromTrait (traitName)
    local color = Color.Red
    if mod.Config.ColorblindMode == true then
        return color
    end
	for upgradeName, boonData in pairs(mod.BoonData) do
		if ArrayContains(boonData, traitName) then
			color = mod.GetLootColor(upgradeName)
		end
	end
    return color
end

function mod.OpenBoonSelector(screen, button)
    if IsScreenOpen("BoonSelector") then
		return
	end
	CloseInventoryScreen(screen, screen.ComponentData.ActionBar.Children.CloseButton)

    screen = DeepCopyTable(ScreenData.BoonSelector)
    screen.Upgrade = button.ItemData.Name
    local itemData = button.ItemData
	local components = screen.Components
    local children = screen.ComponentData.Background.Children
    local boons = mod.BoonData[itemData.Name]
    local lColor = mod.GetLootColor(itemData.Name) or Color.White
    -- Boon buttons

    for index, boon in ipairs (boons) do
        local purchaseButtonKey = "PurchaseButton"..index
        local rowoffset = 100
        local columnoffset = 400
        local numperrow = 4
        local offsetX = screen.RowStartX + columnoffset*((index-1) % numperrow)
        local offsetY = screen.RowStartY + rowoffset*(math.floor((index-1)/numperrow))
        local color = lColor
        local lockColor = Color.White
        if HeroHasTrait(boon) then
            children[purchaseButtonKey] = {
                AnimationName = "BoonSlotLocked",
                Name = "BlankObstacle",
                Group = "Combat_Menu_TraitTray",
                Scale = 0.3,
                OffsetX = offsetX,
                OffsetY = offsetY,
                Text = boon,
                TextArgs =
                {
                    FontSize = 22,
                    Width = 720,
                    Color = Color.DarkGray,
                    Font = "P22UndergroundSCMedium",
                    ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                    Justification = "Center"
                },
            }
        else
            children[purchaseButtonKey] = {
                Name = "ButtonDefault",
                Group = "Combat_Menu_TraitTray",
                Scale = 1.2,
                ScaleX = 1.15,
                OffsetX = offsetX,
                OffsetY = offsetY,
                Text = boon,
                Color = lColor,
                TextArgs =
                {
                    FontSize = 22,
                    Width = 720,
                    Color = Color.White,
                    Font = "P22UndergroundSCMedium",
                    ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2},
                    Justification = "Center"
                },
                Data = {
                    OnPressedFunctionName = mod.GiveBoonToPlayer,
                    Boon = boon,
                },
            }
        end
    end
    --
    if itemData.NoRarity then
		children.CommonButton = nil
		children.RareButton = nil
		children.EpicButton = nil
		children.HeroicButton = nil
    end

    OnScreenOpened(screen)
	CreateScreenFromData(screen, screen.ComponentData)

    SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
	wait(0.3)

	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
	screen.KeepOpen = true
	HandleScreenInput( screen )
end

function mod.CloseBoonSelector( screen )
	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
	OnScreenCloseStarted( screen )
	CloseScreen( GetAllIds( screen.Components ), 0.15 )
	OnScreenCloseFinished( screen )
	notifyExistingWaiters("BoonSelector")
end

function mod.SpawnBoon(screen, button)
    CreateLoot({ Name = screen.Upgrade, OffsetX = 100, SpawnPoint = CurrentRun.Hero.ObjectId })
end

function mod.ChangeBoonSelectorRarity(screen, button)
    if screen.LockedRarityButton ~= nil and screen.LockedRarityButton ~= button then
		ModifyTextBox({ Id = screen.LockedRarityButton.Id, Text = screen.LockedRarityButton.Rarity })
	end
	screen.Rarity = button.Rarity
	screen.LockedRarityButton = button
	ModifyTextBox({ Id = button.Id, Text = ">>"..button.Rarity.."<<" })
end

function mod.GiveBoonToPlayer(screen, button)
    local boon = button.Boon
	if not HeroHasTrait(boon) then
        AddTraitToHero({TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = boon, Rarity = screen.Rarity})})
        mod.LockChoice(screen.Components, button)
    end
end

function mod.LockChoice(components, button)
	local purchaseButtonKeyLock = tostring(button).."Lock"

	components[purchaseButtonKeyLock] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray", Scale = 0.3 })
	CreateTextBox({ Id = components[purchaseButtonKeyLock].Id, Text = button.Boon,
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.DarkGray, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
    if button.DuoScreen then
        components[purchaseButtonKeyLock].Boon = button.Boon
    end
	Attach({Id = components[purchaseButtonKeyLock].Id, DestinationId = components.Background.Id, OffsetX = button.OffsetX, OffsetY = button.OffsetY })
	Destroy({Id = button.Id})
	SetAnimation({ DestinationId = components[purchaseButtonKeyLock].Id, Name = "BoonSlotLocked" })
end

function mod.RemoveAllTraits()
	local removedTraitData = {}
	for i, traitData in pairs( CurrentRun.Hero.Traits ) do
		table.insert(removedTraitData, { Name = traitData.Name, Rarity = traitData.Rarity })
	end

	for i, traitData in pairs(removedTraitData) do
		RemoveTrait( CurrentRun.Hero, traitData.Name )
	end
end

function mod.ReloadEquipment()
	EquipWeaponUpgrade(CurrentRun.Hero)
	EquipKeepsake(CurrentRun.Hero)
	EquipAssist(CurrentRun.Hero)
end

function mod.ClearAllBoons()
	mod.RemoveAllTraits()
	mod.ReloadEquipment()
    ClearUpgrades()
end

function mod.ReloadRoom()
    if CurrentRun.Hero.IsDead then
        -- local doorId = GetRandomValue(GetIdsByType({Name = "ExitDoor"}))
        -- local door = {
        --     Room = CurrentHubRoom,
        --     ObjectId = doorId
        -- }

        -- LeaveRoom( CurrentRun, door )
        DeathAreaRoomTransition(CurrentHubRoom)
    end
end

function mod.KillPlayer()
    KillHero({},{},{})
end

function mod.OpenResourceMenu(screen, button)
    if IsScreenOpen("BoonSelector") then
		return
	end

    screen = DeepCopyTable(ScreenData.ResourceMenu)
    screen.Resource = "None"
    screen.Amount = 0
	local components = screen.Components

    OnScreenOpened(screen)
	CreateScreenFromData(screen, screen.ComponentData)

    components.ResourceTextbox = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
	Attach({ Id = components.ResourceTextbox.Id, DestinationId = components.Background.Id, OffsetX = -150, OffsetY = 250 })
	CreateTextBox({ Id = components.ResourceTextbox.Id, Text = screen.Resource,
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = lColor, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	components.ResourceAmountTextbox = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
	Attach({ Id = components.ResourceAmountTextbox.Id, DestinationId = components.Background.Id, OffsetX = 100, OffsetY = 250 })
	CreateTextBox({ Id = components.ResourceAmountTextbox.Id, Text = screen.Amount,
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = lColor, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})

    SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
	wait(0.3)

	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
	screen.KeepOpen = true
	HandleScreenInput( screen )
end

function mod.CloseResourceMenu( screen )
	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
	OnScreenCloseStarted( screen )
	CloseScreen( GetAllIds( screen.Components ), 0.15 )
	OnScreenCloseFinished( screen )
	notifyExistingWaiters("ResourceMenu")
end

function mod.ChangeTargetResource(screen, button)
	screen.Resource = button.Resource
	ModifyTextBox({Id = screen.Components.ResourceTextbox.Id, Text = button.ResourceDisplay} )
end

function mod.ChangeTargetResourceAmount(screen, button)
	local amount = screen.Amount + button.Amount
	if amount < 0 then
		amount = 0
	end
	screen.Amount = amount
	ModifyTextBox({Id = screen.Components.ResourceAmountTextbox.Id, Text = screen.Amount} )
end

function mod.SpawnResource(screen, button)
	if screen.Resource == "None" or screen.Amount == 0 then
		return
	end

	AddResource(screen.Resource, screen.Amount)
end

function mod.ToggleChildForm(screen, button)
    SetThingProperty({ Property = "GrannyTexture", Value = "null", DestinationId = CurrentRun.Hero.ObjectId })
	SetupCostume( true )

end

function mod.OpenBoonManager(screen, button)
    if IsScreenOpen("BoonSelector") then
		return
	end

    screen = DeepCopyTable(ScreenData.BoonSelector)
	screen.FirstPage = 0
	screen.LastPage = 0
	screen.CurrentPage = screen.FirstPage
	local components = screen.Components
	local children = screen.ComponentData.Background.Children
	screen.ComponentData.Background.Text = "Boon Manager"

    -- Display
	children.CommonButton = nil
	children.RareButton = nil
	children.EpicButton = nil
	children.HeroicButton = nil
	children.SpawnButton = nil

    OnScreenOpened(screen)
	CreateScreenFromData(screen, screen.ComponentData)

	local displayedTraits = {}
	local index = 0
	screen.BoonsList = {}
	for i, boon in pairs(CurrentRun.Hero.Traits) do
		if Contains(displayedTraits, boon.Name) or boon.Name == "GodModeTrait" then
		else
			if not mod.IsDummyWeaponTrait(boon.Name) then
				table.insert(displayedTraits, boon.Name)
				local rowOffset = 100
				local columnOffset = 400
				local boonsPerRow = 4
				local rowsPerPage = 4
				local rowIndex = math.floor(index/boonsPerRow)
				local pageIndex = math.floor(rowIndex/rowsPerPage)
				local offsetX = screen.RowStartX + columnOffset*(index % boonsPerRow)
				local offsetY = screen.RowStartY + rowOffset*(rowIndex % rowsPerPage)
				boon.Level = boon.StackNum or 1
				index = index + 1
				screen.LastPage = pageIndex
				if screen.BoonsList[pageIndex] == nil then
					screen.BoonsList[pageIndex] = {}
				end
				table.insert(screen.BoonsList[pageIndex],{
					index = index,
					boon = boon,
					pageIndex = pageIndex,
					offsetX = offsetX,
					offsetY = offsetY,
				})
			end
		end
	end
	-- print(ModUtil.ToString.Deep( displayedTraits, nil, nil, '\t' ))
	mod.BoonManagerLoadPage(screen)
	--Instructions
	components.ModeDisplay = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
	Attach({ Id = components.ModeDisplay.Id, DestinationId = components.Background.Id, OffsetX = 0, OffsetY = 200 })
	CreateTextBox({ Id = components.ModeDisplay.Id, Text = "Choose a mode",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.White, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	CreateTextBox({ Id = components.ModeDisplay.Id, Text = "Click Level Mode or Rarity Mode again to switch Add(+) and Substract(-) submodes",
	FontSize = 19, OffsetX = 0, OffsetY = - (ScreenCenterY * 0.95), Width = 840, Color = Color.SubTitle, Font = "CrimsonTextItalic",
	ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 1}, Justification = "Center" })
	--Mode Buttons
	components.LevelModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0})
	components.LevelModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.LevelModeButton.Mode = "Level"
	components.LevelModeButton.Add = true
	components.LevelModeButton.Substract = false
	components.LevelModeButton.Icon = "(+)"
	Attach({ Id = components.LevelModeButton.Id, DestinationId = components.Background.Id, OffsetX = -450, OffsetY = 300 })
	CreateTextBox({ Id = components.LevelModeButton.Id, Text = "Level Mode(+)",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.White, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	components.RarityModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0 })
	components.RarityModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.RarityModeButton.Mode = "Rarity"
	components.RarityModeButton.Add = true
	components.RarityModeButton.Substract = false
	components.RarityModeButton.Icon = "(+)"
	Attach({ Id = components.RarityModeButton.Id, DestinationId = components.Background.Id, OffsetX = -150, OffsetY = 300 })
	CreateTextBox({ Id = components.RarityModeButton.Id, Text = "Rarity Mode(+)",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.White, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	components.DeleteModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0 })
	components.DeleteModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.DeleteModeButton.Mode = "Delete"
	Attach({ Id = components.DeleteModeButton.Id, DestinationId = components.Background.Id, OffsetX = 150, OffsetY = 300 })
	CreateTextBox({ Id = components.DeleteModeButton.Id, Text = "Delete Mode",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.White, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	components.AllModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0 })
	components.AllModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.AllModeButton.Mode = "All"
	Attach({ Id = components.AllModeButton.Id, DestinationId = components.Background.Id, OffsetX = 450, OffsetY = 300 })
	CreateTextBox({ Id = components.AllModeButton.Id, Text = "All Mode : OFF",
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.BoonPatchEpic, Font = "P22UndergroundSCMedium",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	--End

    SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
	wait(0.3)

	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
	screen.KeepOpen = true
	HandleScreenInput( screen )
end

function mod.ChangeBoonManagerMode(screen, button)
	if button.Mode == "All" then
		if screen.AllMode == nil or not screen.AllMode then
			screen.AllMode = true
			ModifyTextBox({ Id = button.Id, Text = "All Mode : ON", Color = Color.BoonPatchHeroic })
		else
			screen.AllMode = false
			ModifyTextBox({ Id = button.Id, Text = "All Mode : OFF", Color = Color.BoonPatchEpic })
		end
		return
	end
	if screen.LockedModeButton ~= nil and screen.LockedModeButton ~= button then
		ModifyTextBox({ Id = screen.LockedModeButton.Id, Text = screen.LockedModeButton.Mode.." Mode"..(screen.LockedModeButton.Icon or "") })
	elseif screen.LockedModeButton ~= nil and screen.LockedModeButton == button then
		-- Switch add or subtract submode (does nothing for Delete mode)
		if button.Add == false then
			button.Substract = false
			button.Add = true
			button.Icon = "(+)"
		else
			button.Add = false
			button.Substract = true
			button.Icon = "(-)"
		end
	end
	screen.Mode = button.Mode
	screen.LockedModeButton = button
	ModifyTextBox({ Id = button.Id, Text = ">>"..button.Mode.." Mode"..(button.Icon or "").."<<" })
end

function mod.HandleBoonManagerClick(screen, button)
	if button.Boon == nil or screen.Mode == nil then
		return
	end
	--All mode
	if screen.AllMode ~= nil and screen.AllMode then
		if screen.Mode == "Level" and screen.LockedModeButton.Add == true then
			local upgradableTraits = {}
			local upgradedTraits = {}
			for i, traitData in pairs(CurrentRun.Hero.Traits) do
				screen.Traits = CurrentRun.Hero.Traits
				local numTraits = traitData.StackNum or 1
				if numTraits < 100 and IsGodTrait(traitData.Name) and TraitData[traitData.Name] and IsGameStateEligible(CurrentRun, TraitData[traitData.Name]) and traitData.Rarity ~= "Legendary" and not mod.IsDummyWeaponTrait(traitData.Name) then
					upgradableTraits[traitData.Name] = true
				end
			end
			if not IsEmpty(upgradableTraits) then
				for _, levelbutton in pairs(screen.Components) do
					if not levelbutton.IsBackground and levelbutton.Boon ~= nil then
						levelbutton.Boon.Level = levelbutton.Boon.Level + 1
						ModifyTextBox({Id = levelbutton.Background.Id, Text = "Lv. "..levelbutton.Boon.Level})
					end
				end
				while not IsEmpty(upgradableTraits) do
					local name = RemoveRandomKey(upgradableTraits)
					upgradedTraits[name] = true
					local traitData = GetHeroTrait(name)
					local stacks = GetTraitCount(name)
					stacks = stacks + 1
					IncreaseTraitLevel(traitData, stacks)
				end
			end
			return
		elseif screen.Mode == "Level" and screen.LockedModeButton.Substract == true then
			local upgradableTraits = {}
			local upgradedTraits = {}
			for i, traitData in pairs(CurrentRun.Hero.Traits) do
				screen.Traits = CurrentRun.Hero.Traits
				local numTraits = traitData.StackNum or 1
				if numTraits > 1 and IsGodTrait(traitData.Name) and TraitData[traitData.Name] and IsGameStateEligible(CurrentRun, TraitData[traitData.Name]) and traitData.Rarity ~= "Legendary" and not mod.IsDummyWeaponTrait(traitData.Name) then
					upgradableTraits[traitData.Name] = true
				end
			end
			if not IsEmpty(upgradableTraits) then
				for _, levelbutton in pairs(screen.Components) do
					if not levelbutton.IsBackground and levelbutton.Boon ~= nil then
						levelbutton.Boon.Level = levelbutton.Boon.Level - 1
						ModifyTextBox({Id = levelbutton.Background.Id, Text = "Lv. "..levelbutton.Boon.Level})
					end
				end
				while not IsEmpty(upgradableTraits) do
					local name = RemoveRandomKey(upgradableTraits)
					upgradedTraits[name] = true
					local traitData = GetHeroTrait(name)
					local stacks = GetTraitCount(name)
					stacks = stacks - 1
					IncreaseTraitLevel(traitData, stacks)
				end
			end
			return
		elseif screen.Mode == "Rarity" and screen.LockedModeButton.Add == true then
			local upgradableTraits = {}
			local upgradedTraits = {}
			for i, traitData in pairs( CurrentRun.Hero.Traits ) do
				if IsGodTrait(traitData.Name, { ForShop = true }) and not mod.IsDummyWeaponTrait(traitData.Name) then
					if TraitData[traitData.Name] and traitData.Rarity ~= nil and GetUpgradedRarity(traitData.Rarity) ~= nil and traitData.RarityLevels ~= nil and traitData.RarityLevels[GetUpgradedRarity(traitData.Rarity)] ~= nil then
						if Contains(upgradableTraits, traitData) or traitData.Rarity == "Legendary" then
						else
							table.insert(upgradableTraits, traitData )
						end
					end
				end
			end
			for _, colorButton in pairs(screen.Components) do
				if colorButton.IsBackground == true and colorButton.Boon.Rarity ~= "Legendary" then
					SetColor({Id = colorButton.Id, Color = Color.BoonPatchHeroic})
				end
			end
			while not IsEmpty(upgradableTraits) do
				local traitData = RemoveRandomValue(upgradableTraits)
				upgradedTraits[traitData.Name] = true
				RemoveTrait(CurrentRun.Hero, traitData.Name)
				AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = traitData.Name, Rarity = "Heroic", StackNum = traitData.StackNum }) })
			end
			return
		elseif screen.Mode == "Delete" then
				mod.ClearAllBoons()
				mod.CloseBoonSelector(screen)
			return
		end
	else
		--Individual mode
		if screen.Mode == "Level" and screen.LockedModeButton.Add == true then
			if GetTraitCount(CurrentRun.Hero, button.Boon.Name) < 100 and IsGodTrait(button.Boon.Name) and TraitData[button.Boon.Name] and IsGameStateEligible(CurrentRun, TraitData[button.Boon.Name]) and button.Boon.Rarity ~= "Legendary" and not mod.IsDummyWeaponTrait(button.Boon.Name) then
				local traitData = GetHeroTrait(button.Boon.Name)
				local stacks = GetTraitCount(CurrentRun.Hero, button.Boon.Name)
				stacks = stacks + 1
				IncreaseTraitLevel(traitData, stacks)
				button.Boon.Level = button.Boon.Level + 1
				ModifyTextBox({Id = button.Background.Id, Text = "Lv. "..button.Boon.Level})
			end
			return
		elseif screen.Mode == "Level" and screen.LockedModeButton.Substract == true then
			if GetTraitCount(CurrentRun.Hero, button.Boon) > 1 and IsGodTrait(button.Boon.Name) and TraitData[button.Boon.Name] and IsGameStateEligible(CurrentRun, TraitData[button.Boon.Name]) and button.Boon.Rarity ~= "Legendary" and not mod.IsDummyWeaponTrait(button.Boon.Name) then
				local traitData = GetHeroTrait(button.Boon.Name)
				local stacks = GetTraitCount(button.Boon.Name)
				stacks = stacks - 1
				IncreaseTraitLevel(traitData, stacks)
				button.Boon.Level = button.Boon.Level - 1
				ModifyTextBox({Id = button.Background.Id, Text = "Lv. "..button.Boon.Level})
			end
			return
		elseif screen.Mode == "Rarity" and screen.LockedModeButton.Add == true then
			if IsGodTrait(button.Boon.Name, { ForShop = true }) and not mod.IsDummyWeaponTrait(button.Boon.Name) then
				if TraitData[button.Boon.Name] and button.Boon.Rarity ~= nil and GetUpgradedRarity(button.Boon.Rarity) ~= nil and button.Boon.RarityLevels[GetUpgradedRarity(button.Boon.Rarity)] ~= nil then
					local count = GetTraitCount(CurrentRun.Hero, button.Boon)
					button.Boon.Rarity = GetUpgradedRarity(button.Boon.Rarity)
					SetColor({Id = button.Background.Id, Color = Color["BoonPatch"..button.Boon.Rarity]})
					RemoveTrait(CurrentRun.Hero, button.Boon.Name)
					AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = button.Boon.Name, Rarity = button.Boon.Rarity,  StackNum = count }) })
				end
			end
			return
		elseif screen.Mode == "Rarity" and screen.LockedModeButton.Substract == true then
			if IsGodTrait(button.Boon.Name, { ForShop = true }) and not mod.IsDummyWeaponTrait(button.Boon.Name) then
				if TraitData[button.Boon.Name] and button.Boon.Rarity ~= nil and GetDowngradedRarity(button.Boon.Rarity) ~= nil and button.Boon.RarityLevels[GetDowngradedRarity(button.Boon.Rarity)] ~= nil then
					local count = GetTraitCount(CurrentRun.Hero, button.Boon)
					button.Boon.Rarity = GetDowngradedRarity(button.Boon.Rarity)
					SetColor({Id = button.Background.Id, Color = Color["BoonPatch"..button.Boon.Rarity]})
					RemoveTrait(CurrentRun.Hero, button.Boon.Name)
					AddTraitToHero({ TraitData = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = button.Boon.Name, Rarity = button.Boon.Rarity, StackNum = count }) })
				end
			end
			return
		elseif screen.Mode == "Delete" then
			screen.BoonsList[screen.CurrentPage][button.Index] = nil
			RemoveTrait(CurrentRun.Hero, button.Boon.Name)
			Destroy({ Ids = { button.Id, button.Background.Id } })
			return
		end
	end
end

function mod.BoonManagerChangePage(screen, button)
	if button.Direction == "Left" and screen.CurrentPage > screen.FirstPage then
		screen.CurrentPage = screen.CurrentPage - 1
	elseif button.Direction == "Right" and screen.CurrentPage < screen.LastPage then
		screen.CurrentPage = screen.CurrentPage + 1
	else
		return
	end
	local ids = {}
	for i, component in pairs(screen.Components) do
		if component.Boon ~= nil then
			table.insert(ids, component.Id)
		end
	end
	Destroy({ Ids = ids})
	mod.BoonManagerLoadPage(screen)
end

function mod.BoonManagerLoadPage(screen)
	mod.BoonManagerPageButtons(screen)
    local displayedTraits = {}
    local pageBoons = screen.BoonsList[screen.CurrentPage]
    if pageBoons then
		for i, boonData in pairs(pageBoons) do
			if displayedTraits[boonData.boon.Name] or displayedTraits[boonData.boon] then
				--Skip
			else
				local color = mod.GetLootColorFromTrait(boonData.boon.Name)
				if boonData.boon.Rarity == nil then
					boonData.boon.Rarity = "Common"
				end
				displayedTraits[boonData.boon.Name] = true
				local purchaseButtonKeyBG = "PurchaseButtonBG"..boonData.index
				screen.Components[purchaseButtonKeyBG] = CreateScreenComponent({ Name = "rectangle01", Group = "Combat_Menu_TraitTray", Scale = 0.38, ScaleX = 2.2 })
				screen.Components[purchaseButtonKeyBG].IsBackground = true
				screen.Components[purchaseButtonKeyBG].Boon = boonData.boon
				CreateTextBox({ Id = screen.Components[purchaseButtonKeyBG].Id, Text = "Lv. "..boonData.boon.Level,
					FontSize = 15, OffsetX = 95, OffsetY = 16, Width = 720, Color = Color.White, Font = "P22UndergroundSCMedium",
					ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
				})
				SetColor({ Id = screen.Components[purchaseButtonKeyBG].Id, Color = Color["BoonPatch"..boonData.boon.Rarity]})
				local purchaseButtonKey = "PurchaseButton"..boonData.index
				screen.Components[purchaseButtonKey] = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.2, ScaleX = 1.15, Color = color })
				screen.Components[purchaseButtonKey].OnPressedFunctionName = mod.HandleBoonManagerClick
				screen.Components[purchaseButtonKey].Boon = boonData.boon
				screen.Components[purchaseButtonKey].Index = boonData.index
				screen.Components[purchaseButtonKey].Background = screen.Components[purchaseButtonKeyBG]
				Attach({ Id = screen.Components[purchaseButtonKey].Id, DestinationId = screen.Components.Background.Id, OffsetX = boonData.offsetX, OffsetY = boonData.offsetY })
				Attach({ Id = screen.Components[purchaseButtonKeyBG].Id, DestinationId = screen.Components[purchaseButtonKey].Id })
				CreateTextBox({ Id = screen.Components[purchaseButtonKey].Id, Text = boonData.boon.Name,
				FontSize = 22, OffsetX = 0, OffsetY = -5, Width = 720, Color = Color.White, Font = "P22UndergroundSCMedium",
				ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
				})
			end
		end
  	end
end

function mod.BoonManagerPageButtons(screen)
	local components = screen.Components
	if components.LeftPageButton then
		Destroy({ Ids = {components.LeftPageButton.Id}})
	end
	if components.RightPageButton then
		Destroy({ Ids = {components.RightPageButton.Id}})
	end
	if screen.CurrentPage ~= screen.FirstPage then
		components.LeftPageButton = CreateScreenComponent({ Name = "ButtonCodexLeft", Scale = 0.8, Sound = "/SFX/Menu Sounds/GeneralWhooshMENU", Group = "Combat_Menu_TraitTray" })
		Attach({ Id = components.LeftPageButton.Id, DestinationId = components.Background.Id, OffsetX = -480, OffsetY = -350 })
		components.LeftPageButton.OnPressedFunctionName = mod.BoonManagerChangePage
		components.LeftPageButton.Direction = "Left"
		components.LeftPageButton.ControlHotkeys = { "MenuLeft", "Left" }
	end
	if screen.CurrentPage ~= screen.LastPage then
		components.RightPageButton = CreateScreenComponent({ Name = "ButtonCodexRight", Scale = 0.8, Sound = "/SFX/Menu Sounds/GeneralWhooshMENU", Group = "Combat_Menu_TraitTray" })
		Attach({ Id = components.RightPageButton.Id, DestinationId = components.Background.Id, OffsetX = 720, OffsetY = -350 })
		components.RightPageButton.OnPressedFunctionName = mod.BoonManagerChangePage
		components.RightPageButton.Direction = "Right"
		components.RightPageButton.ControlHotkeys = { "MenuRight", "Right" }
	end
end

function mod.IsBoonTrait(traitName)
	for i, lootset in pairs (LootSetData) do
		for k, loot in pairs(lootset) do
			if loot.Icon == "BoonSymbolHermes" and loot.TraitIndex[traitName] then
				return true
			elseif loot.Icon == "BoonSymbolChaos" and Contains(loot.PermanentTraits, traitName) then
				return true
			elseif loot.Icon == "BoonSymbolChaos" and Contains(loot.TemporaryTraits, traitName) then
				return true
			elseif loot.Icon == "WeaponUpgradeSymbol" and loot.TraitIndex[traitName] then
				return true
			end
		end
	end
end

function mod.IsDummyWeaponTrait(traitName)
	if TraitSetData.DummyWeapons[traitName] then
		return true
	end
	return false
end

ModUtil.LoadOnce(function ()
    for key, value in pairs(mod.BoonData) do
		mod.PopulateBoonData(key)
	end
end)

mod.Internal = ModUtil.UpValues( function() 
	return setupData, mouseOverCommandItem, mouseOffCommandItem
end )

setupData()