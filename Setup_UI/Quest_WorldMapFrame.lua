

WoWTools_ChineseMixin:SetLabel(QuestMapFrame.DetailsFrame.BackFrame.BackButton)
WoWTools_ChineseMixin:SetLabel(QuestMapFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame.Label)
WoWTools_ChineseMixin:SetLabel(QuestScrollFrame.SearchBox.Instructions)
if  QuestMapFrame.QuestsFrame.DetailsFrame and QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame and QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice then--11.1
    WoWTools_ChineseMixin:SetLabel(QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice.Text)
    QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice.Text:SetTextColor(0,1,0)
end

--地图图例
WoWTools_ChineseMixin:SetLabel(QuestMapFrame.MapLegend.TitleText)
if MapLegendScrollFrame then
    for _, layout in pairs(MapLegendScrollFrame.ScrollChild:GetLayoutChildren() or {}) do
        WoWTools_ChineseMixin:SetLabel(layout.TitleText)
        for _, text in pairs(layout:GetLayoutChildren() or {}) do
            WoWTools_ChineseMixin:SetLabel(text, text.nameText)
        end
    end
end

hooksecurefunc(WorldMapFrame, 'SetupTitle', function(self)
    self.BorderFrame:SetTitle('地图和任务日志')
end)
hooksecurefunc(WorldMapFrame, 'SynchronizeDisplayState', function(self)
    if self:IsMaximized() then
        self.BorderFrame:SetTitle('地图')
    else
        self.BorderFrame:SetTitle('地图和任务日志')
    end
end)
WoWTools_ChineseMixin:SetCNFont(WorldMapFrameHomeButtonText)
WorldMapFrameHomeButtonText:SetText('世界')

local optionButton=WorldMapFrame.overlayFrames[2]
if optionButton then
    optionButton:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '地图筛选')
        GameTooltip:Show()
    end)
end
local pingButton= WorldMapFrame.overlayFrames[3]
if pingButton then
    pingButton:HookScript('OnEnter', function(self)--WorldMapTrackingPinButtonMixin:OnEnter()
        GameTooltip_SetTitle(GameTooltip, '地图标记')
        local mapID = self:GetParent():GetMapID()
        if C_Map.CanSetUserWaypointOnMap(mapID) then
            GameTooltip_AddNormalLine(GameTooltip, '在地图上放置一个位置标记，此标记可以追踪，也可以分享给其他玩家。')
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            GameTooltip_AddInstructionLine(GameTooltip, '点击这个按钮，然后在地图上点击来放置一个标记，或者直接<按住Ctrl点击地图>。')
        else
            GameTooltip_AddErrorLine(GameTooltip, '你不能在这张地图上放置标记。')
        end
        GameTooltip:Show()
    end)
end
local threatButton=  WorldMapFrame.overlayFrames[7]
if threatButton then
    GameTooltip_SetTitle(GameTooltip, '恩佐斯突袭')
    GameTooltip_AddColoredLine(GameTooltip, '点击浏览被恩佐斯的军队突袭的地区。', GREEN_FONT_COLOR)
    GameTooltip:Show()
end





--[[
QuestScrollFrame.headerFramePool,
QuestScrollFrame.campaignHeaderFramePool,
QuestScrollFrame.campaignHeaderMinimalFramePool,
QuestScrollFrame.covenantCallingsHeaderFramePool
]]

local function set_text(line)
    WoWTools_ChineseMixin:SetLabel(line.ButtonText)
    if line.Text then
        
        local name =  WoWTools_ChineseMixin:GetQuestData(line.questID, true, false, false)
        print(line.questID, name)
        if name then
            line.Text:SetText(name)
        end
   end
end
hooksecurefunc("QuestLogQuests_Update", function()
    for line in QuestScrollFrame.headerFramePool:EnumerateActive() do
        set_text(line)
    end

    for line in QuestScrollFrame.titleFramePool:EnumerateActive() do
        set_text(line)
       WoWTools_ChineseMixin:SetLabel(line.ButtonText)
    end

    for line in QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
       WoWTools_ChineseMixin:SetLabel(line.Text)
       WoWTools_ChineseMixin:SetLabel(line.Progress)
    end

    for line in QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do--没测试
        set_text(line)
    end
 end)














 











--MapLegendMixin
local QuestsCategoryData = {
{Name = MAP_LEGEND_CAMPAIGN,   Tooltip = MAP_LEGEND_CAMPAIGN_TOOLTIP},
{Name = MAP_LEGEND_IMPORTANT,  Tooltip = MAP_LEGEND_IMPORTANT_TOOLTIP},
{Name = MAP_LEGEND_LEGENDARY,  Tooltip = MAP_LEGEND_LEGENDARY_TOOLTIP},
{Name = MAP_LEGEND_META,       Tooltip = MAP_LEGEND_META_TOOLTIP},
{Name = MAP_LEGEND_REPEATABLE, Tooltip = MAP_LEGEND_REPEATABLE_TOOLTIP},
{Name = MAP_LEGEND_LOCALSTORY, Tooltip = MAP_LEGEND_LOCALSTORY_TOOLTIP},
{Name = MAP_LEGEND_INPROGRESS, Tooltip = MAP_LEGEND_INPROGRESS_TOOLTIP},
{Name = MAP_LEGEND_TURNIN,     Tooltip = MAP_LEGEND_TURNIN_TOOLTIP}
}
local LimitedCategoryData = {
{Name = MAP_LEGEND_WORLDQUEST,     Tooltip = MAP_LEGEND_WORLDQUEST_TOOLTIP},
{Name = MAP_LEGEND_WORLDBOSS,      Tooltip = MAP_LEGEND_WORLDBOSS_TOOLTIP},
{Name = MAP_LEGEND_BONUSOBJECTIVE, Tooltip = MAP_LEGEND_BONUSOBJECTIVE_TOOLTIP},
{Name = MAP_LEGEND_EVENT,          Tooltip = MAP_LEGEND_EVENT_TOOLTIP},
{Name = MAP_LEGEND_RARE,           Tooltip = MAP_LEGEND_RARE_TOOLTIP},
{Name = MAP_LEGEND_RAREELITE,      Tooltip = MAP_LEGEND_RAREELITE_TOOLTIP},
}
local ActivitiesCategoryData = {
{Name = MAP_LEGEND_DUNGEON,   Tooltip = MAP_LEGEND_DUNGEON_TOOLTIP},
{Name = MAP_LEGEND_RAID,      Tooltip = MAP_LEGEND_RAID_TOOLTIP},
{Name = MAP_LEGEND_HUB,       Tooltip = MAP_LEGEND_HUB_TOOLTIP},
{Name = MAP_LEGEND_DIGSITE,   Tooltip = MAP_LEGEND_DIGSITE_TOOLTIP},
{Name = MAP_LEGEND_PETBATTLE, Tooltip = MAP_LEGEND_PETBATTLE_TOOLTIP},
{Name = MAP_LEGEND_DELVE,		Tooltip = MAP_LEGEND_DELVE_TOOLTIP},
}
local MovementCategoryData = {
{Name = MAP_LEGEND_TELEPORT,     Tooltip = MAP_LEGEND_TELEPORT_TOOLTIP,},
{Name = MAP_LEGEND_CAVE,         Tooltip = MAP_LEGEND_CAVE_TOOLTIP},
{Name = MAP_LEGEND_FLIGHTPOINT,  Tooltip = MAP_LEGEND_FLIGHTPOINT_TOOLTIP},
}
local MapLegendData = {
{CategoryTitle = MAP_LEGEND_CATEGORY_QUESTS,      CategoryData = QuestsCategoryData},
{CategoryTitle = MAP_LEGEND_CATEGORY_LTA,         CategoryData = LimitedCategoryData},
{CategoryTitle = MAP_LEGEND_CATEGORY_ACTIVITIES,  CategoryData = ActivitiesCategoryData},
{CategoryTitle = MAP_LEGEND_CATEGORY_MOVEMENT,    CategoryData = MovementCategoryData},
}







do
    for _, data in pairs(MapLegendData) do
        local frame=_G[data.CategoryTitle]
        if frame then
            WoWTools_ChineseMixin:SetLabel(frame.TitleText, data.CategoryTitle)
        end
        for _, categoryData in ipairs(data.CategoryData) do
            local btn=_G[categoryData.Name]
            if btn then
                WoWTools_ChineseMixin:SetLabel(btn, categoryData.Name)
                local tooltip= WoWTools_ChineseMixin:CN(categoryData.Tooltip)
                if tooltip then
                    btn.tooltipText= tooltip
                end
            end
        end
    end
end
QuestsCategoryData = nil
LimitedCategoryData = nil
ActivitiesCategoryData = nil
MovementCategoryData = nil
MapLegendData = nil