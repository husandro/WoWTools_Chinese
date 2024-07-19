local e= select(2, ...)

if QuestScrollFrame.SearchBox then--11版本
    e.set(QuestMapFrame.DetailsFrame.BackFrame.BackButton)
    e.set(QuestMapFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame.Label)
    e.set(QuestScrollFrame.SearchBox.Instructions)
    e.set(QuestMapFrame.MapLegend.TitleText)
    e.set(QuestMapFrame.MapLegend.BackButton)
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
e.font(WorldMapFrameHomeButtonText)
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
    e.set(line.ButtonText)
    if line.Text then
        local name =  e.Get_Quest_Info(line.questID, true, false, false)
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
       e.set(line.ButtonText)
    end

    for line in QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
       e.set(line.Text)
       e.set(line.Progress)
    end

    for line in QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do--没测试
        set_text(line)
    end
 end)