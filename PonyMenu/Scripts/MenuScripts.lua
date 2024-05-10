local mod = PonyMenu

if not mod.Config.Enabled then return end

-- BOON SELECTOR

function mod.OpenBoonSelector(screen, button)
	if IsScreenOpen("BoonSelector") then
		return
	end
	mod.UpdateScreenData()
	CloseInventoryScreen(screen, screen.ComponentData.ActionBar.Children.CloseButton)

	screen = DeepCopyTable(ScreenData.BoonSelector)
	screen.Upgrade = button.ItemData.Name

	if screen.Upgrade == "WeaponUpgrade" then
		mod.BoonData.WeaponUpgrade = {}
		mod.PopulateBoonData("WeaponUpgrade")
	end

	local itemData = button.ItemData
	local components = screen.Components
	local children = screen.ComponentData.Background.Children
	local boons = mod.BoonData[itemData.Name]
	local lColor = mod.GetLootColor(itemData.Name) or Color.White
	-- Boon buttons

	for index, boon in ipairs(boons) do
		local purchaseButtonKey = "PurchaseButton" .. index
		local rowoffset = 100
		local columnoffset = 400
		local numperrow = 4
		local offsetX = screen.RowStartX + columnoffset * ((index - 1) % numperrow)
		local offsetY = screen.RowStartY + rowoffset * (math.floor((index - 1) / numperrow))
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
					ShadowBlur = 0,
					ShadowColor = { 0, 0, 0, 1 },
					ShadowOffset = { 0, 2 },
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
					ShadowBlur = 0,
					ShadowColor = { 0, 0, 0, 1 },
					ShadowOffset = { 0, 2 },
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
	if itemData.NoSpawn then
		children.SpawnButton = nil
	end

	OnScreenOpened(screen)
	CreateScreenFromData(screen, screen.ComponentData)

	SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
	wait(0.3)

	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
	screen.KeepOpen = true
	HandleScreenInput(screen)
end

function mod.CloseBoonSelector(screen)
	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
	OnScreenCloseStarted(screen)
	CloseScreen(GetAllIds(screen.Components), 0.15)
	OnScreenCloseFinished(screen)
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
	ModifyTextBox({ Id = button.Id, Text = ">>" .. button.Rarity .. "<<" })
end

function mod.GiveBoonToPlayer(screen, button)
	local boon = button.Boon
	if not HeroHasTrait(boon) then
		AddTraitToHero({
			TraitData = GetProcessedTraitData({
				Unit = CurrentRun.Hero,
				TraitName = boon,
				Rarity = screen.Rarity
			})
		})
		mod.LockChoice(screen.Components, button)
	end
end

function mod.LockChoice(components, button)
	local purchaseButtonKeyLock = tostring(button) .. "Lock"

	components[purchaseButtonKeyLock] = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray", Scale = 0.3 })
	CreateTextBox({
		Id = components[purchaseButtonKeyLock].Id,
		Text = button.Boon,
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.DarkGray,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})
	if button.DuoScreen then
		components[purchaseButtonKeyLock].Boon = button.Boon
	end
	Attach({
		Id = components[purchaseButtonKeyLock].Id,
		DestinationId = components.Background.Id,
		OffsetX = button
			.OffsetX,
		OffsetY = button.OffsetY
	})
	Destroy({ Id = button.Id })
	SetAnimation({ DestinationId = components[purchaseButtonKeyLock].Id, Name = "BoonSlotLocked" })
end

-- RESOURCE MENU

function mod.OpenResourceMenu(screen, button)
	if IsScreenOpen("BoonSelector") then
		return
	end
	mod.UpdateScreenData()

	screen = DeepCopyTable(ScreenData.ResourceMenu)
	screen.Resource = "None"
	screen.Amount = 0
	screen.FirstPage = 0
	screen.LastPage = 0
	screen.CurrentPage = screen.FirstPage
	local components = screen.Components

	OnScreenOpened(screen)
	CreateScreenFromData(screen, screen.ComponentData)
	--Display
	local displayedResources = {}
	local index = 0
	screen.ResourceList = {}
	for _, category in ipairs(ScreenData.InventoryScreen.ItemCategories) do
		for k, resource in ipairs(category) do
			if type(resource) == 'string' and not Contains(displayedResources, resource) then
				table.insert(displayedResources, resource)
				local rowOffset = 100
				local columnOffset = 400
				local boonsPerRow = 4
				local rowsPerPage = 4
				local rowIndex = math.floor(index / boonsPerRow)
				local pageIndex = math.floor(rowIndex / rowsPerPage)
				local offsetX = screen.RowStartX + columnOffset * (index % boonsPerRow)
				local offsetY = screen.RowStartY + rowOffset * (rowIndex % rowsPerPage)
				index = index + 1
				screen.LastPage = pageIndex
				if screen.ResourceList[pageIndex] == nil then
					screen.ResourceList[pageIndex] = {}
				end
				table.insert(screen.ResourceList[pageIndex], {
					index = index,
					name = resource,
					pageIndex = pageIndex,
					offsetX = offsetX,
					offsetY = offsetY,
				})
			end
		end
	end
	mod.ResourceMenuLoadPage(screen)
	--

	components.ResourceTextbox = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
	Attach({ Id = components.ResourceTextbox.Id, DestinationId = components.Background.Id, OffsetX = -450, OffsetY = 450 })
	CreateTextBox({
		Id = components.ResourceTextbox.Id,
		Text = screen.Resource,
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.White,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})
	components.ResourceAmountTextbox = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
	Attach({ Id = components.ResourceAmountTextbox.Id, DestinationId = components.Background.Id, OffsetX = -300, OffsetY = 450 })
	CreateTextBox({
		Id = components.ResourceAmountTextbox.Id,
		Text = screen.Amount,
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.White,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})

	SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
	wait(0.3)

	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
	screen.KeepOpen = true
	HandleScreenInput(screen)
end

function mod.CloseResourceMenu(screen)
	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
	OnScreenCloseStarted(screen)
	CloseScreen(GetAllIds(screen.Components), 0.15)
	OnScreenCloseFinished(screen)
	notifyExistingWaiters("ResourceMenu")
end

function mod.ChangeTargetResource(screen, button)
	screen.Resource = button.Resource
	ModifyTextBox({ Id = screen.Components.ResourceTextbox.Id, Text = button.Resource })
end

function mod.ChangeTargetResourceAmount(screen, button)
	local amount = screen.Amount + button.Amount
	if amount < 0 then
		amount = 0
	end
	screen.Amount = amount
	ModifyTextBox({ Id = screen.Components.ResourceAmountTextbox.Id, Text = screen.Amount })
end

function mod.SpawnResource(screen, button)
	if screen.Resource == "None" or screen.Amount == 0 then
		return
	end

	AddResource(screen.Resource, screen.Amount)
end

function mod.ResourceMenuLoadPage(screen)
	mod.BoonManagerPageButtons(screen, screen.Name)
	local displayedResources = {}
	local pageResources = screen.ResourceList[screen.CurrentPage]
	if pageResources then
		for i, resourceData in pairs(pageResources) do
			if displayedResources[resourceData] or displayedResources[resourceData] then
				--Skip
			else
				local purchaseButtonKey = "PurchaseButton" .. resourceData.index
				screen.Components[purchaseButtonKey] = CreateScreenComponent({
					Name = "ButtonDefault",
					Group =
					"Combat_Menu_TraitTray",
					Scale = 1.2,
					ScaleX = 1.15,
				})
				screen.Components[purchaseButtonKey].OnPressedFunctionName = mod.ChangeTargetResource
				screen.Components[purchaseButtonKey].Resource = resourceData.name
				screen.Components[purchaseButtonKey].Index = resourceData.index
				Attach({
					Id = screen.Components[purchaseButtonKey].Id,
					DestinationId = screen.Components.Background.Id,
					OffsetX = resourceData.offsetX,
					OffsetY = resourceData.offsetY
				})
				CreateTextBox({
					Id = screen.Components[purchaseButtonKey].Id,
					Text = resourceData.name,
					FontSize = 22,
					OffsetX = 0,
					OffsetY = -5,
					Width = 720,
					Color = Color.White,
					Font = "P22UndergroundSCMedium",
					ShadowBlur = 0,
					ShadowColor = { 0, 0, 0, 1 },
					ShadowOffset = { 0, 2 },
					Justification = "Center"
				})
			end
		end
	end
end

-- BOON MANAGER

function mod.OpenBoonManager(screen, button)
	if IsScreenOpen("BoonManager") then
		return
	end
	-- mod.UpdateScreenData()

	screen = DeepCopyTable(ScreenData.BoonSelector)
	screen.Name = "BoonManager"
	screen.FirstPage = 0
	screen.LastPage = 0
	screen.CurrentPage = screen.FirstPage
	local components = screen.Components
	local children = screen.ComponentData.Background.Children
	screen.ComponentData.Background.Text = mod.Locale.BoonManagerTitle

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
		if not Contains(displayedTraits, boon.Name) and mod.IsBoonManagerValid(boon.Name) then
			table.insert(displayedTraits, boon.Name)
			local rowOffset = 100
			local columnOffset = 400
			local boonsPerRow = 4
			local rowsPerPage = 4
			local rowIndex = math.floor(index / boonsPerRow)
			local pageIndex = math.floor(rowIndex / rowsPerPage)
			local offsetX = screen.RowStartX + columnOffset * (index % boonsPerRow)
			local offsetY = screen.RowStartY + rowOffset * (rowIndex % rowsPerPage)
			boon.Level = boon.StackNum or 1
			index = index + 1
			screen.LastPage = pageIndex
			if screen.BoonsList[pageIndex] == nil then
				screen.BoonsList[pageIndex] = {}
			end
			table.insert(screen.BoonsList[pageIndex], {
				index = index,
				boon = boon,
				pageIndex = pageIndex,
				offsetX = offsetX,
				offsetY = offsetY,
			})
		end
	end
	mod.BoonManagerLoadPage(screen)
	--Instructions
	components.ModeDisplay = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
	Attach({ Id = components.ModeDisplay.Id, DestinationId = components.Background.Id, OffsetX = 0, OffsetY = 200 })
	CreateTextBox({
		Id = components.ModeDisplay.Id,
		Text = mod.Locale.BoonManagerModeSelection,
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.White,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})
	CreateTextBox({
		Id = components.ModeDisplay.Id,
		Text = mod.Locale.BoonManagerSubtitle,
		FontSize = 19,
		OffsetX = 0,
		OffsetY = -(ScreenCenterY * 0.95),
		Width = 840,
		Color = Color.SubTitle,
		Font = "CaesarDressing",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 1 },
		Justification = "Center"
	})
	--Mode Buttons
	components.LevelModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0 })
	components.LevelModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.LevelModeButton.Mode = "Level"
	components.LevelModeButton.Text = mod.Locale.BoonManagerLevelMode
	components.LevelModeButton.Add = true
	components.LevelModeButton.Substract = false
	components.LevelModeButton.Icon = "(+)"
	Attach({ Id = components.LevelModeButton.Id, DestinationId = components.Background.Id, OffsetX = -450, OffsetY = 300 })
	CreateTextBox({
		Id = components.LevelModeButton.Id,
		Text = components.LevelModeButton.Text .. "(+)",
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.White,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})
	components.RarityModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0 })
	components.RarityModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.RarityModeButton.Mode = "Rarity"
	components.RarityModeButton.Text = mod.Locale.BoonManagerRarityMode
	components.RarityModeButton.Add = true
	components.RarityModeButton.Substract = false
	components.RarityModeButton.Icon = "(+)"
	Attach({ Id = components.RarityModeButton.Id, DestinationId = components.Background.Id, OffsetX = -150, OffsetY = 300 })
	CreateTextBox({
		Id = components.RarityModeButton.Id,
		Text = components.RarityModeButton.Text .. "(+)",
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.White,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})
	components.DeleteModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0 })
	components.DeleteModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.DeleteModeButton.Mode = "Delete"
	components.DeleteModeButton.Text = mod.Locale.BoonManagerDeleteMode
	Attach({ Id = components.DeleteModeButton.Id, DestinationId = components.Background.Id, OffsetX = 150, OffsetY = 300 })
	CreateTextBox({
		Id = components.DeleteModeButton.Id,
		Text = components.DeleteModeButton.Text,
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.White,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})
	components.AllModeButton = CreateScreenComponent({ Name = "ButtonDefault", Group = "Combat_Menu_TraitTray", Scale = 1.0 })
	components.AllModeButton.OnPressedFunctionName = mod.ChangeBoonManagerMode
	components.AllModeButton.Mode = "All"
	components.AllModeButton.Text = mod.Locale.BoonManagerAllModeOff
	Attach({ Id = components.AllModeButton.Id, DestinationId = components.Background.Id, OffsetX = 450, OffsetY = 300 })
	CreateTextBox({
		Id = components.AllModeButton.Id,
		Text = components.AllModeButton.Text,
		FontSize = 22,
		OffsetX = 0,
		OffsetY = 0,
		Width = 720,
		Color = Color.BoonPatchEpic,
		Font = "P22UndergroundSCMedium",
		ShadowBlur = 0,
		ShadowColor = { 0, 0, 0, 1 },
		ShadowOffset = { 0, 2 },
		Justification = "Center"
	})
	--End

	SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
	SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })
	wait(0.3)

	SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
	screen.KeepOpen = true
	HandleScreenInput(screen)
end

function mod.ChangeBoonManagerMode(screen, button)
	if button.Mode == "All" then
		if screen.AllMode == nil or not screen.AllMode then
			screen.AllMode = true
			ModifyTextBox({ Id = button.Id, Text = mod.Locale.BoonManagerAllModeOn, Color = Color.BoonPatchHeroic })
		else
			screen.AllMode = false
			ModifyTextBox({ Id = button.Id, Text = mod.Locale.BoonManagerAllModeOff, Color = Color.BoonPatchEpic })
		end
		return
	end
	if screen.LockedModeButton ~= nil and screen.LockedModeButton ~= button then
		ModifyTextBox({
			Id = screen.LockedModeButton.Id,
			Text = screen.LockedModeButton.Text .. (screen.LockedModeButton.Icon or "")
		})
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
	ModifyTextBox({ Id = button.Id, Text = ">>" .. button.Text .. (button.Icon or "") .. "<<" })
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
				if numTraits < 100 and IsGodTrait(traitData.Name) and TraitData[traitData.Name] and IsGameStateEligible(CurrentRun, TraitData[traitData.Name]) and traitData.Rarity ~= "Legendary" then
					upgradableTraits[traitData.Name] = true
				end
			end
			if not IsEmpty(upgradableTraits) then
				for _, levelbutton in pairs(screen.Components) do
					if not levelbutton.IsBackground and levelbutton.Boon ~= nil then
						levelbutton.Boon.Level = levelbutton.Boon.Level + 1
						ModifyTextBox({ Id = levelbutton.Background.Id, Text = mod.Locale.BoonManagerLevelDisplay .. levelbutton.Boon.Level })
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
				if numTraits > 1 and IsGodTrait(traitData.Name) and TraitData[traitData.Name] and IsGameStateEligible(CurrentRun, TraitData[traitData.Name]) and traitData.Rarity ~= "Legendary" then
					upgradableTraits[traitData.Name] = true
				end
			end
			if not IsEmpty(upgradableTraits) then
				for _, levelbutton in pairs(screen.Components) do
					if not levelbutton.IsBackground and levelbutton.Boon ~= nil then
						levelbutton.Boon.Level = levelbutton.Boon.Level - 1
						ModifyTextBox({ Id = levelbutton.Background.Id, Text = mod.Locale.BoonManagerLevelDisplay .. levelbutton.Boon.Level })
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
			for i, traitData in pairs(CurrentRun.Hero.Traits) do
				if IsGodTrait(traitData.Name, { ForShop = true }) then
					if TraitData[traitData.Name] and traitData.Rarity ~= nil and GetUpgradedRarity(traitData.Rarity) ~= nil and traitData.RarityLevels ~= nil and traitData.RarityLevels[GetUpgradedRarity(traitData.Rarity)] ~= nil then
						if Contains(upgradableTraits, traitData) or traitData.Rarity == "Legendary" then
						else
							table.insert(upgradableTraits, traitData)
						end
					end
				end
			end
			for _, colorButton in pairs(screen.Components) do
				if colorButton.IsBackground == true and colorButton.Boon.Rarity ~= "Legendary" then
					SetColor({ Id = colorButton.Id, Color = Color.BoonPatchHeroic })
				end
			end
			while not IsEmpty(upgradableTraits) do
				local traitData = RemoveRandomValue(upgradableTraits)
				upgradedTraits[traitData.Name] = true
				RemoveTrait(CurrentRun.Hero, traitData.Name)
				AddTraitToHero({
					TraitData = GetProcessedTraitData({
						Unit = CurrentRun.Hero,
						TraitName = traitData.Name,
						Rarity =
						"Heroic",
						StackNum = traitData.StackNum
					})
				})
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
			if GetTraitCount(CurrentRun.Hero, button.Boon.Name) < 100 and IsGodTrait(button.Boon.Name) and TraitData[button.Boon.Name] and IsGameStateEligible(CurrentRun, TraitData[button.Boon.Name]) and button.Boon.Rarity ~= "Legendary" then
				local traitData = GetHeroTrait(button.Boon.Name)
				local stacks = GetTraitCount(CurrentRun.Hero, button.Boon.Name)
				stacks = stacks + 1
				IncreaseTraitLevel(traitData, stacks)
				button.Boon.Level = button.Boon.Level + 1
				ModifyTextBox({ Id = button.Background.Id, Text = mod.Locale.BoonManagerLevelDisplay .. button.Boon.Level })
			end
			return
		elseif screen.Mode == "Level" and screen.LockedModeButton.Substract == true then
			if GetTraitCount(CurrentRun.Hero, button.Boon) > 1 and IsGodTrait(button.Boon.Name) and TraitData[button.Boon.Name] and IsGameStateEligible(CurrentRun, TraitData[button.Boon.Name]) and button.Boon.Rarity ~= "Legendary" then
				local traitData = GetHeroTrait(button.Boon.Name)
				local stacks = GetTraitCount(button.Boon.Name)
				stacks = stacks - 1
				IncreaseTraitLevel(traitData, stacks)
				button.Boon.Level = button.Boon.Level - 1
				ModifyTextBox({ Id = button.Background.Id, Text = mod.Locale.BoonManagerLevelDisplay .. button.Boon.Level })
			end
			return
		elseif screen.Mode == "Rarity" and screen.LockedModeButton.Add == true then
			if IsGodTrait(button.Boon.Name, { ForShop = true }) then
				if TraitData[button.Boon.Name] and button.Boon.Rarity ~= nil and GetUpgradedRarity(button.Boon.Rarity) ~= nil and button.Boon.RarityLevels[GetUpgradedRarity(button.Boon.Rarity)] ~= nil then
					local count = GetTraitCount(CurrentRun.Hero, button.Boon)
					button.Boon.Rarity = GetUpgradedRarity(button.Boon.Rarity)
					SetColor({ Id = button.Background.Id, Color = Color["BoonPatch" .. button.Boon.Rarity] })
					RemoveTrait(CurrentRun.Hero, button.Boon.Name)
					AddTraitToHero({
						TraitData = GetProcessedTraitData({
							Unit = CurrentRun.Hero,
							TraitName = button.Boon
								.Name,
							Rarity = button.Boon.Rarity,
							StackNum = count
						})
					})
				end
			end
			return
		elseif screen.Mode == "Rarity" and screen.LockedModeButton.Substract == true then
			if IsGodTrait(button.Boon.Name, { ForShop = true }) then
				if TraitData[button.Boon.Name] and button.Boon.Rarity ~= nil and GetDowngradedRarity(button.Boon.Rarity) ~= nil and button.Boon.RarityLevels[GetDowngradedRarity(button.Boon.Rarity)] ~= nil then
					local count = GetTraitCount(CurrentRun.Hero, button.Boon)
					button.Boon.Rarity = GetDowngradedRarity(button.Boon.Rarity)
					SetColor({ Id = button.Background.Id, Color = Color["BoonPatch" .. button.Boon.Rarity] })
					RemoveTrait(CurrentRun.Hero, button.Boon.Name)
					AddTraitToHero({
						TraitData = GetProcessedTraitData({
							Unit = CurrentRun.Hero,
							TraitName = button.Boon
								.Name,
							Rarity = button.Boon.Rarity,
							StackNum = count
						})
					})
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
		if component.Resource ~= nil or component.Boon ~= nil then
			table.insert(ids, component.Id)
		end
	end
	Destroy({ Ids = ids })
	if button.Menu == "ResourceMenu" then
		mod.ResourceMenuLoadPage(screen)
	elseif button.Menu == "BoonManager" then
		mod.BoonManagerLoadPage(screen)
	end
end

function mod.BoonManagerLoadPage(screen)
	mod.BoonManagerPageButtons(screen, screen.Name)
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
				local purchaseButtonKeyBG = "PurchaseButtonBG" .. boonData.index
				screen.Components[purchaseButtonKeyBG] = CreateScreenComponent({
					Name = "rectangle01",
					Group =
					"Combat_Menu_TraitTray",
					Scale = 0.38,
					ScaleX = 2.2
				})
				screen.Components[purchaseButtonKeyBG].IsBackground = true
				screen.Components[purchaseButtonKeyBG].Boon = boonData.boon
				CreateTextBox({
					Id = screen.Components[purchaseButtonKeyBG].Id,
					Text = mod.Locale.BoonManagerLevelDisplay .. boonData.boon.Level,
					FontSize = 15,
					OffsetX = 95,
					OffsetY = 16,
					Width = 720,
					Color = Color.White,
					Font = "P22UndergroundSCMedium",
					ShadowBlur = 0,
					ShadowColor = { 0, 0, 0, 1 },
					ShadowOffset = { 0, 2 },
					Justification = "Center"
				})
				SetColor({
					Id = screen.Components[purchaseButtonKeyBG].Id,
					Color = Color
						["BoonPatch" .. boonData.boon.Rarity]
				})
				local purchaseButtonKey = "PurchaseButton" .. boonData.index
				screen.Components[purchaseButtonKey] = CreateScreenComponent({
					Name = "ButtonDefault",
					Group =
					"Combat_Menu_TraitTray",
					Scale = 1.2,
					ScaleX = 1.15,
					Color = color
				})
				screen.Components[purchaseButtonKey].OnPressedFunctionName = mod.HandleBoonManagerClick
				screen.Components[purchaseButtonKey].Boon = boonData.boon
				screen.Components[purchaseButtonKey].Index = boonData.index
				screen.Components[purchaseButtonKey].Background = screen.Components[purchaseButtonKeyBG]
				Attach({
					Id = screen.Components[purchaseButtonKey].Id,
					DestinationId = screen.Components.Background.Id,
					OffsetX =
						boonData.offsetX,
					OffsetY = boonData.offsetY
				})
				Attach({
					Id = screen.Components[purchaseButtonKeyBG].Id,
					DestinationId = screen.Components
						[purchaseButtonKey].Id
				})
				CreateTextBox({
					Id = screen.Components[purchaseButtonKey].Id,
					Text = boonData.boon.Name,
					FontSize = 22,
					OffsetX = 0,
					OffsetY = -5,
					Width = 720,
					Color = Color.White,
					Font = "P22UndergroundSCMedium",
					ShadowBlur = 0,
					ShadowColor = { 0, 0, 0, 1 },
					ShadowOffset = { 0, 2 },
					Justification = "Center"
				})
			end
		end
	end
end

function mod.BoonManagerPageButtons(screen, menu)
	local components = screen.Components
	if components.LeftPageButton then
		Destroy({ Ids = { components.LeftPageButton.Id } })
	end
	if components.RightPageButton then
		Destroy({ Ids = { components.RightPageButton.Id } })
	end
	if screen.CurrentPage ~= screen.FirstPage then
		components.LeftPageButton = CreateScreenComponent({
			Name = "ButtonCodexLeft",
			Scale = 0.8,
			Sound =
			"/SFX/Menu Sounds/GeneralWhooshMENU",
			Group = "Combat_Menu_TraitTray"
		})
		Attach({ Id = components.LeftPageButton.Id, DestinationId = components.Background.Id, OffsetX = -480, OffsetY = -350 })
		components.LeftPageButton.OnPressedFunctionName = mod.BoonManagerChangePage
		components.LeftPageButton.Menu = menu
		components.LeftPageButton.Direction = "Left"
		components.LeftPageButton.ControlHotkeys = { "MenuLeft", "Left" }
	end
	if screen.CurrentPage ~= screen.LastPage then
		components.RightPageButton = CreateScreenComponent({
			Name = "ButtonCodexRight",
			Scale = 0.8,
			Sound =
			"/SFX/Menu Sounds/GeneralWhooshMENU",
			Group = "Combat_Menu_TraitTray"
		})
		Attach({ Id = components.RightPageButton.Id, DestinationId = components.Background.Id, OffsetX = 720, OffsetY = -350 })
		components.RightPageButton.OnPressedFunctionName = mod.BoonManagerChangePage
		components.RightPageButton.Menu = menu
		components.RightPageButton.Direction = "Right"
		components.RightPageButton.ControlHotkeys = { "MenuRight", "Right" }
	end
end

function mod.IsBoonManagerValid(traitName)
	if traitName == "GodModeTrait" or traitName == "AltarBoon" then
		return false
	elseif TraitData[traitName] ~= nil then
		local trait = TraitData[traitName]
		if
			trait.MetaUpgrade
			or trait.Hidden
			or trait.AddResources ~= nil
			or trait.Slot == "Aspect"
			or trait.Slot == "Familiar"
			or trait.Slot == "Keepsake"
		then
			return false
		end
	end
	return true
end
