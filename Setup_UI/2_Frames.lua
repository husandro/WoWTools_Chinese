



EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner)
    for name, func in pairs(WoWTools_ChineseMixin.Frames) do
        do
            if _G[name] then
                func(_, WoWTools_ChineseMixin)
            end
        end
        WoWTools_MoveMixin.Frames[name]= nil
    end
    EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
end)
