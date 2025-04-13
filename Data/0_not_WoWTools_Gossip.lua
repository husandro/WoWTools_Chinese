WoWToolsChinese_GossipDataMixin= {
}




EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner)
    if not WoWToolsSave or not WoWToolsSave['Plus_Gossip'] or WoWToolsSave['Plus_Gossip'].disabled then
        WoWToolsChinese_GossipDataMixin=nil
    end
    EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
end)
