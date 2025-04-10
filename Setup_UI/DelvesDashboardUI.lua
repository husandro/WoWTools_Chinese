local e= select(2, ...)
--地下堡, 没加载
EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_DelvesDashboardUI' then
        e.set(DelvesDashboardFrame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel.CompanionConfigButton.ButtonText)
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)
