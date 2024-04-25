if not PonyAltar.Config.Enabled then return end

TraitSetData.Keepsakes = {
    AltarBoon = {
        InheritFrom = { "BaseBoonUpgradeKeepsake" },
        Icon = "GUI\\Screens\\Codex\\Icon-Unseen",
        Slot = "Altar",
        ForceBoonName = "",
        RarityUpgradeData =
        {
            LootName = "",
            Uses = 1,
            MaxRarity = 1,
            ReportValues =
            { 
                ReportedMaxRarity = "MaxRarity",
                ReportedUpgrades = "Uses",
            },
        },
        Uses = 1,
        ExtractValues =
        {
            {
                Key = "ReportedUpgrades",
                ExtractAs = "Uses",
            },
            {
                Key = "ReportedMaxRarity",
                ExtractAs = "RarityLevel",
                Format = "Rarity",
            }
        },
    },
    ForceZeusBoonKeepsake =
	{
		InheritFrom = { "BaseBoonUpgradeKeepsake" },
		Icon = "Keepsake_12",
		EquipSound = "/SFX/Menu Sounds/KeepsakeZeusRing",
		InRackTitle = "ForceZeusBoonKeepsake_Rack",
        ManaCostModifiers =
		{
			WeaponNames = WeaponSets.HeroAllWeapons,
			ManaCostMultiplierWhilePrimed = { BaseValue = 0.9} ,
			ReportValues = { ReportedManaCost = "ManaCostMultiplierWhilePrimed" }
		},
		ExtractValues =
		{
			{
				Key = "ReportedManaCost",
				ExtractAs = "ManaDelta",
				Format = "PercentDelta",
			},
		},
        RarityLevels =
		{
			Common =
			{
				Multiplier = 1.0,
			},
			Rare =
			{
				Multiplier = 0.89,
			},
			Epic =
			{
				Multiplier = 0.78,
			},
			Heroic =
			{
				Multiplier = 0.78,
			}
		},
		EquipVoiceLines =
		{
			{
				PreLineWait = 0.3,
				BreakIfPlayed = true,
				SuccessiveChanceToPlay = 0.2,
				Cooldowns =
				{
					{ Name = "MelinoeAnyQuipSpeech" },
				},

				{ Cue = "/VO/Melinoe_3190", Text = "The Bangle." },
			},
			{
				PreLineWait = 0.3,
				BreakIfPlayed = true,
				RandomRemaining = true,
				ChanceToPlay = 0.25,
				Source = { LineHistoryName = "NPC_Zeus_01", SubtitleColor = Color.ZeusVoice },
				GameStateRequirements =
				{
					{
						PathTrue = { "GameState", "TextLinesRecord", "ZeusGift03" },
					},
				},
				Cooldowns =
				{
					{ Name = "KeepsakeGiverSpeechPlayedRecently", Time = 90 },
				},
				{ Cue = "/VO/ZeusKeepsake_0184", Text = "Young lady." },
				{ Cue = "/VO/ZeusKeepsake_0185", Text = "Melinoë." },
			},
			[3] = GlobalVoiceLines.AwardSelectedVoiceLines,
		},
		SignOffData =
		{
		  {
			Text = "SignoffZeus",
		  },
		},
	},
    ForcePoseidonBoonKeepsake =
	{
		InheritFrom = { "BaseBoonUpgradeKeepsake" },
		Icon = "Keepsake_14",
		EquipSound = "/SFX/Menu Sounds/KeepsakePoseidonShell",
		InRackTitle = "ForcePoseidonBoonKeepsake_Rack",
		KillMoneyMultiplier = { BaseValue = 1 },
		ExtractValues =
		{
			{
				Key = "KillMoneyMultiplier",
				ExtractAs = "TooltipHeal",
				Format = "Percent"
			},
		},
		EquipVoiceLines =
		{
			{
				PreLineWait = 0.3,
				BreakIfPlayed = true,
				SuccessiveChanceToPlay = 0.2,
				Cooldowns =
				{
					{ Name = "MelinoeAnyQuipSpeech" },
				},

				{ Cue = "/VO/Melinoe_3192", Text = "The Sea." },
			},
			[2] = GlobalVoiceLines.AwardSelectedVoiceLines,
		},
		SignOffData =
		{
		  {
			Text = "SignoffPoseidon",
		  },
		},
	},
    ForceApolloBoonKeepsake =
    {
        InheritFrom = { "BaseBoonUpgradeKeepsake" },
        Icon = "Keepsake_15",
        EquipSound = "/SFX/Menu Sounds/KeepsakeDionysusCup",
        InRackTitle = "ForceApolloBoonKeepsake_Rack",
		TooltipMultiplier = { BaseValue = 1.2 },
        PropertyChanges = {
            {
                WeaponName = "WeaponBlink",
                EffectName = "RushWeaponInvulnerable",
                EffectProperty = "Duration",
                BaseValue = 1.2,
                ChangeType = "Multiply",
                ExcludeLinked = true,
            },
            {
                WeaponName = "WeaponBlink",
                EffectName = "RushWeaponInvulnerableCharge",
                EffectProperty = "Duration",
                BaseValue = 1.2,
                ChangeType = "Multiply",
                ExcludeLinked = true,
            },
        },
        ExtractValues =
        {
			{
				Key = "TooltipMultiplier",
				ExtractAs = "TooltipMultiplier",
				Format = "PercentDelta",
			},
        },
		RarityLevels =
		{
			Common =
			{
				Multiplier = 1.0,
			},
			Rare =
			{
				Multiplier = 1.125,
			},
			Epic =
			{
				Multiplier = 1.25,
			},
			Heroic =
			{
				Multiplier = 1.25,
			}
		},
        EquipVoiceLines =
        {
            {
                PreLineWait = 0.3,
                BreakIfPlayed = true,
                SuccessiveChanceToPlay = 0.2,
                Cooldowns =
                {
                    { Name = "MelinoeAnyQuipSpeech" },
                },

                { Cue = "/VO/Melinoe_3193", Text = "The Hope." },
            },
            [2] = GlobalVoiceLines.AwardSelectedVoiceLines,
        },
        SignOffData =
        {
          {
            Text = "SignoffApollo",
          },
        },
    },
	ForceHestiaBoonKeepsake =
	{
		InheritFrom = { "BaseBoonUpgradeKeepsake" },
		Icon = "Keepsake_18",
		EquipSound = "/SFX/Menu Sounds/KeepsakeAthenaOwl",
		InRackTitle = "ForceHestiaBoonKeepsake_Rack",
		MaxHealthMultiplier = 0.80,
		AddOutgoingDamageModifiers =
		{
			ValidWeapons = WeaponSets.HeroAllWeapons,
			ValidWeaponMultiplier = {BaseValue = 1.05},
			ReportValues =
			{
				ReportedDamageBonus = "ValidWeaponMultiplier",
			}
		},
		PropertyChanges =
		{
			{
				LuaProperty = "MaxHealth",
				ChangeValue = 0.80,
				ChangeType = "Multiply",
				SourceIsMultiplier = true,
				MaintainDelta = true,
				ReportValues = { ReportedHealthPenalty = "ChangeValue"}
			},
		},
		ExtractValues =
		{
			{
				Key = "ReportedDamageBonus",
				ExtractAs = "TooltipDamage",
				Format = "PercentDelta",
			},
			{
				Key = "ReportedHealthPenalty",
				ExtractAs = "HealthPenalty",
				Format = "PercentDelta",
				SkipAutoExtract = true,
			},
		},
		RarityLevels =
		{
			Common =
			{
				Multiplier = 1.0,
			},
			Rare =
			{
				Multiplier = 1.05,
			},
			Epic =
			{
				Multiplier = 1.1,
			},
			Heroic =
			{
				Multiplier = 1.1,
			}
		},
		EquipVoiceLines =
		{
			{
				PreLineWait = 0.3,
				BreakIfPlayed = true,
				SuccessiveChanceToPlay = 0.2,
				Cooldowns =
				{
					{ Name = "MelinoeAnyQuipSpeech" },
				},

				{ Cue = "/VO/Melinoe_3197", Text = "The Ember." },
			},
			[2] = GlobalVoiceLines.AwardSelectedVoiceLines,
		},
		SignOffData =
		{
		  {
			Text = "SignoffHestia",
		  },
		},
	},
	ForceHephaestusBoonKeepsake =
	{
		InheritFrom = { "BaseBoonUpgradeKeepsake" },
		Icon = "Keepsake_17",
		EquipSound = "/SFX/Menu Sounds/KeepsakeZeusRing",
		InRackTitle = "ForceHephaestusBoonKeepsake_Rack",
		TooltipDamage = { BaseValue = 25 },
		AddOutgoingDamageModifiers = {
			ArmoredDamageMultiplier =
			{
				BaseValue = 0.25,
				SourceIsMultiplier = true,
			},
			ValidWeapons = WeaponSets.HeroAllWeapons,
		},
		ExtractValues = 
		{
			{
				Key = "TooltipDamage",
				ExtractAs = "TooltipDamage",
			},
		},
		EquipVoiceLines =
		{
			{
				PreLineWait = 0.3,
				BreakIfPlayed = true,
				SuccessiveChanceToPlay = 0.2,
				Cooldowns =
				{
					{ Name = "MelinoeAnyQuipSpeech" },
				},

				{ Cue = "/VO/Melinoe_3196", Text = "The Shard." },
			},
			[2] = GlobalVoiceLines.AwardSelectedVoiceLines,
		},
		SignOffData =
		{
		  {
			Text = "SignoffHephaestus",
		  },
		},
	},
}


OverwriteTableKeys( TraitData, TraitSetData.Keepsakes )