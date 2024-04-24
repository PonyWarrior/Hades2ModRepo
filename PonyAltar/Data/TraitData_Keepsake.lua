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
}


OverwriteTableKeys( TraitData, TraitSetData.Keepsakes )