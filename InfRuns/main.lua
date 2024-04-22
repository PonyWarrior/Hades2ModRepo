if InfRuns.Config.Enabled then
    local mod = InfRuns
    OnAnyLoad { "Hub_PreRun", function (triggerArgs)
        if GameState.ClearedRunsCache >= 5 then
            GameState.ClearedRunsCache = 4
        end
        if GameState.ClearedUnderworldRunsCache >= 5 then
            GameState.ClearedUnderworldRunsCache = 4
        end
        if GameState.ClearedSurfaceRunsCache >= 5 then
            GameState.ClearedUnderworldRunsCache = 4
        end
    end}

    ModUtil.Path.Override("EndEarlyAccessPresentation", function ()
        thread( Kill, CurrentRun.Hero )
    end, mod)
end