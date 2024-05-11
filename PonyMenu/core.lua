local mod = PonyMenu

if not mod.Config.Enabled then return end

local function setupMainData()
	mod.CurrentLocale = GetLanguage()
	mod.Locale = setmetatable({}, {
		__index = function(_, k)
			return mod.GetLanguageString(k)
		end
	})

	mod.BoonData = {
		ZeusUpgrade = {},
		PoseidonUpgrade = {},
		AphroditeUpgrade = {},
		ApolloUpgrade = {},
		DemeterUpgrade = {},
		HephaestusUpgrade = {},
		HestiaUpgrade = {},
		ArtemisUpgrade = {},
		HermesUpgrade = {},
		HeraUpgrade = {},
		TrialUpgrade = {},
		SpellDrop = {},
		WeaponUpgrade = {},
		NPC_Arachne_01 = {},
		NPC_Narcissus_01 = {},
		NPC_Echo_01 = {},
		NPC_LordHades_01 = {},
	}
end

function mod.UpdateScreenData()
	if mod.CurrentLocale ~= GetLanguage() then
		mod.CurrentLocale = GetLanguage()
		mod.setupScreenData()
		mod.setupCommandData()
	end
end

-- Is it possible this could be done with ModUtil.Path.Context.Wrap?
ModUtil.Path.Override("InventoryScreenDisplayCategory", function(screen, categoryIndex, args)
	args = args or {}
	local components = screen.Components

	-- Cleanup prev category
	local prevCategory = screen.ItemCategories[screen.ActiveCategoryIndex]
	--Mod start
	if prevCategory == nil then
		prevCategory = screen.ItemCategories[1]
	end
	-- Mod end
	if prevCategory.CloseFunctionName ~= nil then
		CallFunctionName(prevCategory.CloseFunctionName, screen)
	else
		for i, resourceName in ipairs(prevCategory) do
			if components[resourceName] ~= nil then
				Destroy({ Id = components[resourceName].Id })
			end
		end
	end

	ModifyTextBox({ Id = components.InfoBoxName.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDescription.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDetails.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxFlavor.Id, FadeTarget = 0.0, })
	if screen.Components["Category" .. prevCategory.Name] ~= nil then
		StopAnimation({
			DestinationId = screen.Components["Category" .. prevCategory.Name].Id,
			Name =
			"InventoryTabHighlightActiveCategory"
		})
	end

	local category = screen.ItemCategories[categoryIndex]
	if category.Locked then
		return
	end
	local slotName = category.Name

	-- Highlight new category
	CreateAnimation({
		DestinationId = screen.Components["Category" .. slotName].Id,
		Name =
		"InventoryTabHighlightActiveCategory",
		Group = "Combat_Menu_TraitTray"
	})
	--Mod Start
	if category.Name == "PONYMENU" or category.Name == "Pony Menu" then
		ModifyTextBox({ Id = screen.Components.CategoryTitleText.Id, Text = mod.Locale.PonyMenuCategoryTitle })
	else
		ModifyTextBox({ Id = screen.Components.CategoryTitleText.Id, Text = category.Name })
	end
	--Mod end

	screen.ActiveCategoryIndex = categoryIndex

	SetAnimation({
		DestinationId = components.Background.Id,
		Name = category.Background or
			screen.ComponentData.Background.AnimationName
	})

	if category.GamepadNavigation ~= nil then
		SetGamepadNavigation(category)
	else
		SetGamepadNavigation(screen)
	end

	if category.OpenFunctionName ~= nil then
		CallFunctionName(category.OpenFunctionName, screen)
		return
	end

	local resourceLocation = { X = screen.GridStartX, Y = screen.GridStartY }
	local columnNum = 1
	-- Mod start
	if category.Name ~= "PONYMENU" and category.Name ~= "Pony Menu" then
		for i, resourceName in ipairs(category) do
			local resourceData = ResourceData[resourceName]
			if (GameState.LifetimeResourcesGained[resourceName] or 0) > 0 or (resourceData.RevealGameStateRequirements ~= nil and IsGameStateEligible(CurrentRun, resourceData, resourceData.RevealGameStateRequirements)) then
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
						textLines = GetRandomEligibleTextLines(screen.Args.GiftTarget,
							screen.Args.GiftTarget.GiftTextLineSets,
							GetNarrativeDataValue(screen.Args.GiftTarget, "GiftTextLinePriorities"),
							{ Spending = spending })
						if textLines ~= nil then
							canBeGifted = true
						end
					end
				end

				local button = CreateScreenComponent({
					Name = "ButtonInventoryItem",
					Scale = resourceData.IconScale or
						1.0,
					Sound = "/SFX/Menu Sounds/GodBoonMenuClose",
					Group = "Combat_Menu_Overlay",
					X = resourceLocation.X,
					Y =
						resourceLocation.Y
				})
				AttachLua({ Id = button.Id, Table = button })
				button.Screen = screen
				button.ResourceData = resourceData
				components[resourceName] = button
				SetAnimation({ DestinationId = button.Id, Name = resourceData.IconPath or resourceData.Icon })

				if canBePlanted then
					if HasResource(resourceName, 1) then
						button.ContextualAction = "Menu_Plant"
						button.OnPressedFunctionName = "GardenPlantSeed"
					else
						SetColor({ Id = button.Id, Color = Color.Black })
						button.Description = "InventoryScreen_SeedNotAvailable"
					end
				elseif canBeGifted then
					if HasResource(resourceName, 1) then
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

				CreateTextBoxWithScreenFormat(screen, button, "ResourceCountFormat",
					{ Text = GameState.Resources[resourceName] or 0 })

				button.MouseOverSound = "/SFX/Menu Sounds/DialoguePanelOutMenu"
				button.OnMouseOverFunctionName = "MouseOverResourceItem"
				button.OnMouseOffFunctionName = "MouseOffResourceItem"

				if (resourceName == args.InitialSelection) or (args.InitialSelection == nil and resourceName == GameState.UnviewedLastResourceGained) then
					UnviewedLastResourceGainedPresentation(screen, button)
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
		-- Pony Menu
		for index, k in ipairs(mod.CommandData) do
			-- for the clean up to work
			table.insert(category, index)

			local itemData = mod.CommandData[index]
			local button = CreateScreenComponent({
				Name = "ButtonInventoryItem",
				Scale = itemData.IconScale or 1.0,
				Sound =
				"/SFX/Menu Sounds/GodBoonMenuClose",
				Group = "Combat_Menu_Overlay",
				X = resourceLocation.X,
				Y =
					resourceLocation.Y
			})
			AttachLua({ Id = button.Id, Table = button })
			button.Screen = screen
			button.ItemData = itemData
			components[index] = button
			SetAnimation({ DestinationId = button.Id, Name = itemData.IconPath or itemData.Icon })

			-- CreateTextBoxWithScreenFormat( screen, button, "ResourceCountFormat", { Text = itemData.Name or "WIP" } )

			button.MouseOverSound = "/SFX/Menu Sounds/DialoguePanelOutMenu"
			button.OnMouseOverFunctionName = mod.mouseOverCommandItem
			button.OnMouseOffFunctionName = mod.mouseOffCommandItem
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
end, mod)

function mod.mouseOverCommandItem(button)
	local screen = button.Screen
	if screen.Closing then
		return
	end

	GenericMouseOverPresentation(button)

	local components = screen.Components
	local buttonHighlight = CreateScreenComponent({
		Name = "InventorySlotHighlight",
		Scale = 1.0,
		Group =
		"Combat_Menu_Overlay",
		DestinationId = button.Id
	})
	components.InventorySlotHighlight = buttonHighlight
	button.HighlightId = buttonHighlight.Id
	Attach({ Id = buttonHighlight.Id, DestinationId = button.Id })
	ModifyTextBox({
		Id = components.InfoBoxName.Id,
		Text = button.ItemData.Name,
		UseDescription = false,
		FadeTarget = 1.0,
		ScaleTarget = 0.8
	})
	ModifyTextBox({
		Id = components.InfoBoxDescription.Id,
		Text = button.ItemData.Description or " ",
		UseDescription = false,
		FadeTarget = 1.0,
	})

	SetScale({ Id = button.Id, Fraction = (button.ItemData.IconScale or 1.0) * screen.IconMouseOverScale, Duration = 0.1, EaseIn = 0.9, EaseOut = 1.0, SkipGeometryUpdate = true })
	--StopFlashing({ Id = button.Id })
	UpdateResourceInteractionText(screen, button)
end

function mod.mouseOffCommandItem(button)
	Destroy({ Id = button.HighlightId })
	local components = button.Screen.Components
	components.InventorySlotHighlight = nil
	ModifyTextBox({ Id = components.InfoBoxName.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDescription.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxDetails.Id, FadeTarget = 0.0, })
	ModifyTextBox({ Id = components.InfoBoxFlavor.Id, FadeTarget = 0.0, })
	SetScale({ Id = button.Id, Fraction = button.ItemData.IconScale or 1.0, Duration = 0.1, SkipGeometryUpdate = true })
	StopFlashing({ Id = button.Id })
	UpdateResourceInteractionText(button.Screen)
end

function mod.Command(screen, button)
	local command = button.ItemData
	local triggerArgs = {}
	if command.Type == "Boon" then
		mod.OpenBoonSelector(screen, button)
	elseif command.Type == "Command" then
		CloseInventoryScreen(screen, screen.ComponentData.ActionBar.Children.CloseButton)
		_G[command.Function]()
	end
end

function mod.PopulateBoonData(upgradeName)
	local godName = string.gsub(upgradeName, 'Upgrade', '')
	local index = 0

	if LootSetData[godName] ~= nil and LootSetData[godName][upgradeName].WeaponUpgrades ~= nil then
		for k, v in pairs(LootSetData[godName][upgradeName].WeaponUpgrades) do
			index = index + 1
			mod.BoonData[upgradeName][index] = v
		end
	end

	if LootSetData[godName] ~= nil and LootSetData[godName][upgradeName].Traits ~= nil then
		for k, v in pairs(LootSetData[godName][upgradeName].Traits) do
			index = index + 1
			mod.BoonData[upgradeName][index] = v
		end
	end

	if mod.BoonData[upgradeName] == nil or IsEmpty(mod.BoonData[upgradeName]) then
		if upgradeName == "SpellDrop" then
			for k, v in pairs(QuestData.QuestDarkSorceries.CompleteGameStateRequirements[1].HasAll) do
				index = index + 1
				mod.BoonData[upgradeName][index] = v
			end
		elseif upgradeName == "WeaponUpgrade" then
			local wp = GetEquippedWeapon()
			for k, v in pairs(LootSetData.Loot[upgradeName].Traits) do
				local boon = TraitData[v]
				if boon.RequiredWeapon == GetEquippedWeapon() then
					index = index + 1
					mod.BoonData.WeaponUpgrade[index] = v
				end
			end
		elseif upgradeName == "TrialUpgrade" then
			for k, v in pairs(LootSetData.Chaos.TrialUpgrade.PermanentTraits) do
				index = index + 1
				mod.BoonData[upgradeName][index] = v
			end
		elseif upgradeName == "NPC_Arachne_01" then
			for k, v in pairs(PresetEventArgs.ArachneCostumeChoices.UpgradeOptions) do
				index = index + 1
				mod.BoonData[upgradeName][index] = v.ItemName
			end
		elseif upgradeName == "ArtemisUpgrade" then
			for k, v in pairs(UnitSetData.NPC_Artemis.NPC_Artemis_Field_01.Traits) do
				index = index + 1
				mod.BoonData[upgradeName][index] = v
			end
		elseif upgradeName == "NPC_Narcissus_01" then
			for k, v in pairs(UnitSetData.NPC_Narcissus.NPC_Narcissus_01.Traits) do
				index = index + 1
				mod.BoonData[upgradeName][index] = v
			end
		elseif upgradeName == "NPC_Echo_01" then
			for k, v in pairs(UnitSetData.NPC_Echo.NPC_Echo_01.Traits) do
				index = index + 1
				mod.BoonData[upgradeName][index] = v
			end
		elseif upgradeName == "NPC_LordHades_01" then
			for k, v in pairs(UnitSetData.NPC_Hades.NPC_Hades_Field_01.Traits) do
				index = index + 1
				mod.BoonData[upgradeName][index] = v
			end
		end
	end
end

function mod.GetLootColor(upgradeName)
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
	elseif upgradeName == "NPC_Arachne_01" then
		color = Color.ArachneVoice
	elseif upgradeName == "ArtemisUpgrade" then
		color = UnitSetData.NPC_Artemis.NPC_Artemis_Field_01.LootColor
	elseif upgradeName == "NPC_Echo_01" then
		color = Color.EchoVoice
	elseif upgradeName == "NPC_Narcissus_01" then
		color = Color.NarcissusVoice
	elseif upgradeName == "NPC_LordHades_01" then
		color = UnitSetData.NPC_Hades.NPC_Hades_Field_01.LootColor
	end
	return color
end

function mod.GetLootColorFromTrait(traitName)
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

function mod.RemoveAllTraits()
	local removedTraitData = {}
	for i, traitData in pairs(CurrentRun.Hero.Traits) do
		table.insert(removedTraitData, { Name = traitData.Name, Rarity = traitData.Rarity })
	end

	for i, traitData in pairs(removedTraitData) do
		RemoveTrait(CurrentRun.Hero, traitData.Name)
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

function mod.IsBoonTrait(traitName)
	for i, lootset in pairs(LootSetData) do
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

ModUtil.LoadOnce(function()
	for key, value in pairs(mod.BoonData) do
		mod.PopulateBoonData(key)
	end
end)

mod.Internal = ModUtil.UpValues(function()
	return setupMainData, mod.mouseOverCommandItem, mod.mouseOffCommandItem
end)

setupMainData()
