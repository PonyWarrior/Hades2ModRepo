local mod = ModUtil.Mod.Register("PQOL2")

mod.Config = {
	Enabled = true,
	AllUnlockedToolsUsable = {
		-- Enable to be able to use any tool you've unlocked to harvest resources
		Enabled = true
	},
	AlwaysEncounterStoryRooms = {
		-- Enable to always encounter story rooms during your runs
		Enabled = true
	},
	GodMode =
	{
		-- Enable to set a fixed damage resistance value for god mode
		Enabled = false,
		FixedValue = 0.2, -- Percentage of damage resistance; 0 = 0%, 0.5 = 50%, 1.0 = 100%
	},
}
