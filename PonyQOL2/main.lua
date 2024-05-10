local mod = PQOL2

if not mod.Config.Enabled then return end

if mod.Config.AllUnlockedToolsUsable.Enabled then
	ModUtil.Path.Override("HasAccessToTool", function(toolName)
		print("DEBUG " .. toolName)
		if GameState.WorldUpgrades[toolName] then
			return true
		end
		if HasFamiliarTool(toolName) then
			return true
		end

		return false
	end)
end

if mod.Config.AlwaysEncounterStoryRooms.Enabled then
	RoomSetData.F.F_Story01.ForceAtBiomeDepthMin = 1
	RoomSetData.F.F_Story01.ForceAtBiomeDepthMax = 8

	RoomSetData.G.G_Story01.ForceAtBiomeDepthMin = 1
	RoomSetData.G.G_Story01.ForceAtBiomeDepthMax = 6

	RoomSetData.N.N_Story01.ForceAtBiomeDepthMin = 0
	RoomSetData.N.N_Story01.ForceAtBiomeDepthMax = 1

	RoomSetData.O.O_Story01.ForceAtBiomeDepthMin = 1
	RoomSetData.O.O_Story01.ForceAtBiomeDepthMax = 5
end

if mod.Config.GodMode.Enabled then
	ModUtil.Path.Override("CalcEasyModeMultiplier", function(...)
		local easyModeMultiplier = 1 - mod.Config.GodMode.FixedValue
		return easyModeMultiplier
	end)
end
