



--ZoneText.lua
--ZoneTextFrame
--SubZoneTextFrame
--屏幕，上方区域提示
ZoneTextFrame:HookScript('OnEvent', function()--ZoneText_OnEvent
    WoWTools_ChineseMixin:SetLabel(SubZoneTextString)
    WoWTools_ChineseMixin:SetLabel(ZoneTextString)
end)
hooksecurefunc('SetZoneText', function()
    local pvpType, isSubZonePvP, factionName = C_PvP.GetZonePVPInfo()
    local pvpTextString = PVPInfoTextString
    if ( isSubZonePvP ) then
        pvpTextString = PVPArenaTextString
    end
    if ( pvpType == "sanctuary" ) then
        pvpTextString:SetText('（安全区域）')
    elseif ( pvpType == "arena" ) then
        pvpTextString:SetText('（PvP区域）')
    elseif ( pvpType == "friendly" or  pvpType == "hostile" ) then
        if (factionName and factionName ~= "") then
            pvpTextString:SetFormattedText('（%s领地）', WoWTools_ChineseMixin:CN(factionName) or factionName)
        end
    elseif ( pvpType == "contested" ) then
        pvpTextString:SetText('（争夺中的领土）')
    elseif ( pvpType == "combat" ) then
        PVPArenaTextString:SetText('（战斗区域）')
    end
end)


--local label = WoWTools_ChineseMixin:Cstr(MinimapCluster.ZoneTextButton, {name='MinimapZoneText2', copyFont= MinimapZoneText})
hooksecurefunc('Minimap_Update', function()
    local name= WoWTools_ChineseMixin:CN(GetMinimapZoneText())
    if name then
        MinimapZoneText:SetText(name)
    end
end)






--ZoneText.lua
hooksecurefunc('AutoFollowStatus_OnEvent', function(self, event, ...)
    if ( event == "AUTOFOLLOW_BEGIN" ) then
        AutoFollowStatusText:SetFormattedText('正在跟随%s', self.unit)
    end
    if ( event == "AUTOFOLLOW_END" ) then
        AutoFollowStatusText:SetFormattedText('已停止跟随%s。', self.unit)
    end
end)
