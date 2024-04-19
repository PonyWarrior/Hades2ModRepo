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

	mod.BoonData = {}
	-- mod.BoonData.ZeusUpgrade = mod.MergeTables(LootSetData.Zeus.ZeusUpgrade.WeaponUpgrades, LootSetData.Zeus.ZeusUpgrade.Traits)
	mod.BoonData.ZeusUpgrade = {}
	mod.BoonData.PoseidonUpgrade = {}
	mod.BoonData.AphroditeUpgrade = {}
	mod.BoonData.ApolloUpgrade = {}
	mod.BoonData.DemeterUpgrade = {}
	mod.BoonData.HephaestusUpgrade = {}
	mod.BoonData.HestiaUpgrade = {}

    mod.ChildForm = false

	mod.CommandData = {
		{
			Icon = "BoonSymbolZeusIcon",
			IconScale = 0.4,
			Name = "ZeusUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolPoseidonIcon",
			IconScale = 0.4,
			Name = "PoseidonUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolAphroditeIcon",
			IconScale = 0.4,
			Name = "AphroditeUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolApolloIcon",
			IconScale = 0.4,
			Name = "ApolloUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolDemeterIcon",
			IconScale = 0.4,
			Name = "DemeterUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonSymbolHephaestusIcon",
			IconScale = 0.4,
			Name = "HephaestusUpgrade",
			Type = "Boon"
		},
		{
			Icon = "BoonDropHestiaPreview",
			IconScale = 0.4,
			Name = "HestiaUpgrade",
			Type = "Boon"
		},
		{
			Icon = "TrashButtonFlash",
			IconScale = 0.4,
			Name = "Clear all boons",
			Description = "Removes all equipped boons.",
			Type = "Command",
			Function = mod.ClearAllBoons
		},
		{
			IconPath = "GUI\\Screens\\Inventory\\Icon-Resources",
			IconScale = 0.4,
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
                                Font = "AlegreyaSansSCLight",
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
                                Font = "AlegreyaSansSCLight",
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
                                Font = "AlegreyaSansSCLight",
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
                                Font = "AlegreyaSansSCLight",
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
                                Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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
								Font = "AlegreyaSansSCLight",
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

    for k, v in pairs (LootSetData[godName][upgradeName].WeaponUpgrades) do
        index = index + 1
        mod.BoonData[upgradeName][index] = v
    end
    for k, v in pairs (LootSetData[godName][upgradeName].Traits) do
        index = index + 1
        mod.BoonData[upgradeName][index] = v
    end
end

function mod.GetLootColor (upgradeName)
    local godName = string.gsub(upgradeName, 'Upgrade', '')
    return LootSetData[godName][upgradeName].LootColor
end

function mod.OpenBoonSelector(screen, button)
    if IsScreenOpen("BoonSelector") then
		return
	end
	CloseInventoryScreen(screen, screen.ComponentData.ActionBar.Children.CloseButton)

    screen = DeepCopyTable(ScreenData.BoonSelector)
    screen.Upgrade = button.ItemData.Name
	local components = screen.Components
    local children = screen.ComponentData.Background.Children
    local boons = mod.BoonData[button.ItemData.Name]
    local lColor = mod.GetLootColor(button.ItemData.Name) or Color.White
    -- Boon buttons
    mod.PopulateBoonData(button.ItemData.Name)

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
                    Font = "AlegreyaSansSCLight",
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
                TextArgs =
                {
                    FontSize = 22,
                    Width = 720,
                    Color = color,
                    Font = "AlegreyaSansSCLight",
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
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.DarkGray, Font = "AlegreyaSansSCLight",
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
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = lColor, Font = "AlegreyaSansSCLight",
		ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
	})
	components.ResourceAmountTextbox = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
	Attach({ Id = components.ResourceAmountTextbox.Id, DestinationId = components.Background.Id, OffsetX = 100, OffsetY = 250 })
	CreateTextBox({ Id = components.ResourceAmountTextbox.Id, Text = screen.Amount,
		FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = lColor, Font = "AlegreyaSansSCLight",
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

-- ModUtil.Path.Wrap( "SetupHeroObject", function(baseFunc, room, applyLuaUpgrades)
--     if mod.ChildForm then
--         room.HeroUnitName = "PlayerMelFlashback"
--         room.HeroOverwrites = {
-- 			AttachedAnimationName = "LaurelCindersSpawner_Young",
-- 			Portrait = "Portrait_Mel_Child_01",
-- 		}
--     end
--     return baseFunc(room, applyLuaUpgrades)
-- end)

mod.Internal = ModUtil.UpValues( function() 
	return setupData, mouseOverCommandItem, mouseOffCommandItem
end )

setupData()