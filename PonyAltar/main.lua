local mod = PonyAltar

if not mod.Config.Enabled then return end

table.insert(HubRoomData.Hub_PreRun.StartUnthreadedEvents,
{
    FunctionName = "PonyAltar.SpawnAltar"
})

 mod.Data.Portraits = {
    "Codex_Portrait_Zeus",
    "Codex_Portrait_Poseidon",
    "Codex_Portrait_Apollo",
    "Codex_Portrait_Aphrodite",
    "Codex_Portrait_Demeter",
    "Codex_Portrait_Hephaestus",
    "Codex_Portrait_Hestia",
}

ModUtil.Table.Merge(ScreenData, {
    PonyAltar = {
        Components = {},
        OpenSound = "/SFX/Menu Sounds/HadesLocationTextAppear",
        Name = "PonyAltar",
        RowStartX = 145,
        RowStartY = ScreenCenterY,
        IncrementX = 190,
        ItemOrder = {
            "ZeusGift01",
            "PoseidonGift01",
            "ApolloGift01",
            "AphroditeGift01",
            "DemeterGift01",
            "HephaestusGift01",
            "HestiaGift01"
        },

        ComponentData =
        {
            DefaultGroup = "Combat_Menu_TraitTray",
            UseNativeScreenCenter = true,
            Order = {
                "BackgroundTint",
                "Background"
            },

            BackgroundTint =
            {
                Graphic = "rectangle01",
                GroupName = "Combat_Menu",
                Scale = 10,
                X = ScreenCenterX,
                Y = ScreenCenterY,
            },

            Background =
            {
                AnimationName = "Box_FullScreen",
                GroupName = "Combat_Menu",
                X = ScreenCenterX,
                Y = ScreenCenterY,
                Scale = 1.15,
                Text = "Altar of the Gods",
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
                    CloseButton =
                    {
                        Graphic = "ButtonClose",
                        GroupName = "Combat_Menu_TraitTray",
                        Scale = 0.7,
                        OffsetX = 0,
                        OffsetY = ScreenCenterY - 70,
                        Data =
                        {
                            OnPressedFunctionName = "PonyAltar.ClosePonyAltar",
                            ControlHotkeys = { "Cancel", },
                        },
                    },
                }
            },
        }
    }
})

function mod.SpawnAltar()
    local unlocked = true
    if unlocked then
        -- Card altar
        local spawnId = 589766
        local altar = DeepCopyTable( ObstacleData.GiftRack )
        altar.OnUsedFunctionName = "PonyAltar.OpenAltarMenu"
        altar.ObjectId = SpawnObstacle({ Name = "GiftRack", Group = "FX_Terrain", DestinationId = spawnId, AttachedTable = altar, OffsetX = 1050, OffsetY = 300 })
        altar.ActivateIds = { altar.ObjectId }
        SetScale({ Id = altar.ObjectId, Fraction = 0.1 })
        SetupObstacle( altar )
        AddToGroup({Id = altar.ObjectId, Name = "PonyAltar.Altar"})
    end
end

function mod.OpenAltarMenu()
    if IsScreenOpen("PonyAltar") then
        return
    end

    local screen = DeepCopyTable(ScreenData.PonyAltar)
    screen.SelectedGod = mod.Data.SelectedGod or "No God selected"
    local components = screen.Components
    local children = screen.ComponentData.Background.Children
    HideCombatUI( screen.Name )
    OnScreenOpened(screen)
    CreateScreenFromData(screen, screen.ComponentData)

    components.GodTextbox = CreateScreenComponent({ Name = "BlankObstacle", Group = "Combat_Menu_TraitTray" })
    Attach({ Id = components.GodTextbox.Id, DestinationId = components.Background.Id, OffsetX = 0, OffsetY = 250 })
    CreateTextBox({ Id = components.GodTextbox.Id, Text = screen.SelectedGod,
        FontSize = 22, OffsetX = 0, OffsetY = 0, Width = 720, Color = Color.White, Font = "P22UndergroundSCMedium",
        ShadowBlur = 0, ShadowColor = {0,0,0,1}, ShadowOffset={0, 2}, Justification = "Center"
    })

    -- SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.0, Duration = 0 })
    SetColor({ Id = components.BackgroundTint.Id, Color = Color.Black })
    SetAlpha({ Id = components.BackgroundTint.Id, Fraction = 0.9, Duration = 0.3 })

    -- wait(0.3)

    --Display
    for index, value in ipairs(screen.ItemOrder) do
        if GameState.TextLinesRecord[value] then
            local godName = string.gsub(value, "Gift01", "")
            local upgradeName = godName.."Upgrade"
            local key = "God"..index
            local buttonKey = "Button"..index
            local fraction = 0.1
            local keepsakeTraitName = "Force"..godName.."BoonKeepsake"
            local level = GetKeepsakeLevel(keepsakeTraitName)
            
            components[buttonKey] = CreateScreenComponent({ Name = "ButtonDefault", X = screen.RowStartX+200, Y = screen.RowStartY - 500, Scale = 1.0, Group = "Combat_Menu_TraitTray" })
            components[buttonKey].Image = key
            components[buttonKey].God = upgradeName
            components[buttonKey].Level = level
            components[buttonKey].Index = index
            SetScaleX({ Id = components[buttonKey].Id, Fraction = 0.69})
            SetScaleY({ Id = components[buttonKey].Id, Fraction = 3.8})
            components[key] = CreateScreenComponent({ Name = "BlankObstacle", X = screen.RowStartX+200, Y = screen.RowStartY - 500, Scale = 1.2, Group = "Combat_Menu_TraitTray" })

            SetThingProperty({ Property = "Ambient", Value = 0.0, DestinationId = components[key].Id })
            components[buttonKey].OnPressedFunctionName = mod.SelectGod
            fraction = 1.0

            SetAlpha({ Ids = { components[key].Id, components[buttonKey].Id }, Fraction = 0 })
            SetAlpha({ Ids = { components[key].Id, components[buttonKey].Id }, Fraction = fraction, Duration = 0.9 })
            SetAnimation({ DestinationId = components[key].Id, Name = mod.Data.Portraits[index], Scale = 0.4 })
            Move({ Ids = { components[key].Id, components[buttonKey].Id }, OffsetX = screen.RowStartX, OffsetY = 500, Duration = index / 10 })

            screen.RowStartX = screen.RowStartX + screen.IncrementX
        end
    end
    --

    SetConfigOption({ Name = "ExclusiveInteractGroup", Value = "Combat_Menu_TraitTray" })
    screen.KeepOpen = true
    HandleScreenInput( screen )
end

function mod.ClosePonyAltar(screen)
    ShowCombatUI( screen.Name )
    SetConfigOption({ Name = "ExclusiveInteractGroup", Value = nil })
	OnScreenCloseStarted( screen )
	CloseScreen( GetAllIds( screen.Components ), 0.15 )
	OnScreenCloseFinished( screen )
	notifyExistingWaiters("PonyAltar")
end

local BoonColors = {
    Color.BoonPatchCommon,
    Color.BoonPatchRare,
    Color.BoonPatchEpic,
    Color.BoonPatchHeroic
}

function mod.SelectGod(screen, button)
    if mod.Data.SelectedGod ~= nil and mod.Data.SelectedGod == button.God then
        local color = BoonColors[1]
        ModifyTextBox({Id = screen.Components.GodTextbox.Id, Text = "No God selected", Color = color} )
        mod.UnequipAltarBoon()
        mod.Data.SelectedGod = nil
        mod.Data.RarifyLevel = nil
        mod.Data.RarifyUsesLeft = nil
        mod.Data.ForceBoonUsesLeft = nil
    else
        local color = BoonColors[button.Level]
        ModifyTextBox({Id = screen.Components.GodTextbox.Id, Text = button.God, Color = color} )
        mod.UnequipAltarBoon()
        mod.Data.SelectedGod = button.God
        mod.Data.RarifyLevel = button.Level
        mod.Data.RarifyUsesLeft = 1
        mod.Data.ForceBoonUsesLeft = 1
        mod.EquipAltarBoon()
    end
end

function mod.EquipAltarBoon()
    if mod.Data.SelectedGod ~= nil then
        local altarTrait = GetProcessedTraitData({ Unit = CurrentRun.Hero, TraitName = "AltarBoon" })
        altarTrait.ForceBoonName = mod.Data.SelectedGod
        altarTrait.RarityUpgradeData.LootName = mod.Data.SelectedGod
        altarTrait.RarityUpgradeData.MaxRarity = mod.Data.RarifyLevel
        AddTraitToHero({TraitData = altarTrait})
        if not CurrentRun.Hero.IsDead then
            CurrentRun.TraitCache[altarTrait.Name] = CurrentRun.TraitCache[altarTrait.Name] or 1
        end
        print("Equipped altar boon")
    end
end

function mod.UnequipAltarBoon()
    for key, trait in pairs(CurrentRun.Hero.Traits) do
        if trait.Slot ~= nil and trait.Slot == "Altar" then
            RemoveTrait(CurrentRun.Hero, trait.Name)
        end
    end
end

ModUtil.Path.Wrap("EquipLastAwardTrait", function (base, ...)
    base(...)
    mod.EquipAltarBoon()
end, mod)

ModUtil.Path.Wrap("BuildMetaupgradeCache", function (base, ...)
    base(...)
    mod.EquipAltarBoon()
end, mod)

ModUtil.Path.Override( "GetManaCost", function (weaponData, useRequiredMana, args)
    args = args or {}
	local weaponName = weaponData.Name
	local manaCost = 0
	local requiredMana = 0
	local isExWeapon = false
	if args.ManaCostOverride then
		isExWeapon = true
	end
	if WeaponData[weaponName] and WeaponData[weaponName].ManaCost and not Contains(WeaponSets.HeroSpellWeapons, weaponName) then
		isExWeapon = true
	end

	if useRequiredMana then
		requiredMana = weaponData.RequiredMana or 0
	end

	manaCost = args.ManaCostOverride or weaponData.ManaCost or requiredMana
	local manaModifiers = GetHeroTraitValues("ManaCostModifiers")
	local manaMultiplier = 1
	for i, data in pairs(manaModifiers) do
		local validWeapon = data.WeaponNamesLookup == nil or data.WeaponNamesLookup[weaponData.Name]
		local validEx = data.ExWeapons == nil or isExWeapon
		if validWeapon and validEx then
			if data.ManaCostAdd then
				manaCost = manaCost + data.ManaCostAdd
			end
			if data.ManaCostAddPerCast then
				manaCost = manaCost + data.ManaCostAddPerCast * MapState.ExCastCount
			end
			if data.ManaCostMultiplier then
				manaMultiplier = manaMultiplier * data.ManaCostMultiplier
			end
            --MOD START
            if data.ManaCostMultiplierWhilePrimed and CurrentRun.Hero.ReserveManaSources then
				manaMultiplier = manaMultiplier * data.ManaCostMultiplierWhilePrimed
            end
            if data.ManaCostMultiplierWhileLowHealth and (CurrentRun.Hero.Health / CurrentRun.Hero.MaxHealth) <= data.LowHealthThreshold  then
				manaMultiplier = manaMultiplier * data.ManaCostMultiplierWhileLowHealth
            end
            --MOD END
		end
	end
	manaCost = manaCost * manaMultiplier

	if useRequiredMana and requiredMana > manaCost then
		return round(requiredMana)
	end
	
	return round(manaCost)
end, mod)

ModUtil.Path.Context.Wrap("CheckMoneyDrop", function()
    ModUtil.Path.Wrap("GetTotalHeroTraitValue", function(base, a, ...)
        if a == "KillMoneyMultiplier" then
          return base(a, ...)
        end
        return base(a, ...) + GetTotalHeroTraitValue("KillMoneyMultiplier")
    end, mod)
end, mod)

ModUtil.Path.Context.Wrap("Damage", function()
    ModUtil.Path.Wrap("CalculateDamageMultipliers", function(base, a, ...)
        if a ~= nil and a == CurrentRun.Hero and HeroHasTrait("ForceHephaestusBoonKeepsake") and CurrentRun.Hero.HealthBuffer ~= nil and CurrentRun.Hero.HealthBuffer > 0 then
            local damageMult = 0
            for i, modifierData in pairs(a.OutgoingDamageModifiers) do
                if modifierData.ArmoredDamageMultiplier then
                    damageMult = (modifierData.ArmoredDamageMultiplier * CurrentRun.Hero.HealthBuffer) /100
                    if damageMult > 0.3 then
                        damageMult = 0.3
                    end
                end
            end
          return base(a, ...) + damageMult
        end
        return base(a, ...)
    end, mod)
end, mod)