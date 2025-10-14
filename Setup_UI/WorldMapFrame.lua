function WoWTools_ChineseMixin.Events:Blizzard_WorldMap()
    for _, frame in ipairs(WorldMapFrame.overlayFrames or {}) do
        self:HookLabel(frame.Text)
    end
    self:HookLabel(WorldMapFrameTitleText)
    self:SetCNFont(WorldMapFrameHomeButtonText)
    WorldMapFrameHomeButtonText:SetText('世界')
end















function WoWTools_ChineseMixin.Frames:QuestMapFrame()
    self:SetLabel(QuestMapFrame.DetailsFrame.BackFrame.BackButton)

    self:SetLabel(QuestScrollFrame.SearchBox.Instructions)
    self:SetLabel(QuestScrollFrame.NoSearchResultsText)
    self:SetLabel(QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice.Text)
    QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice.Text:SetTextColor(0,1,0)
    self:SetLabel(QuestMapFrame.MapLegend.TitleText)
    self:SetFrame(QuestInfoRewardsFrame)
    self:SetButton(QuestMapFrame.DetailsFrame.BackButton)--:SetText('返回')
    self:SetButton(QuestMapFrame.DetailsFrame.AbandonButton)--:SetText('放弃')]]
    self:SetButton(QuestMapFrame.DetailsFrame.ShareButton)--:SetText('共享'))
    --QuestMapFrame.DetailsFrame.DestinationMapButton.tooltipText= '显示最终目的地'
    --QuestMapFrame.DetailsFrame.WaypointMapButton.tooltipText= '显示旅行路径'
    self:SetLabel(QuestInfoRequiredMoneyText)--:SetText('需要金钱：')
    self:HookButton(QuestMapFrame.DetailsFrame.TrackButton)
    self:HookButton(QuestLogPopupDetailFrame.TrackButton)

    self:SetRegions(QuestMapFrame.DetailsFrame.RewardsFrame)--, '奖励')
    self:SetLabel(QuestMapFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame.Label)

    local function set_text(line)
        self:SetLabel(line.ButtonText)
        if line.Text then
            local name = self:GetQuestName(line.questID)
            if name then
                line.Text:SetText(name)
            else
                self:SetLabel(line.Text)
            end
        end
    end

    hooksecurefunc("QuestLogQuests_Update", function()
        for line in QuestScrollFrame.titleFramePool:EnumerateActive() do
            set_text(line)
        end

        for line in QuestScrollFrame.headerFramePool:EnumerateActive() do
            set_text(line)
        end

        local Lines= {}

        for line in QuestScrollFrame.objectiveFramePool:EnumerateActive() do
            Lines[line.questID]= Lines[line.questID] or {}
            table.insert(Lines[line.questID], line)
        end

        for questID, lines in pairs(Lines) do
            local isComplete = C_QuestLog.IsComplete(questID)
            if not isComplete then
                local data= self:GetQuestObject(questID)
                if data then
                    local questLogIndex= C_QuestLog.GetLogIndexForQuestID(questID)
                    local numObjectives = GetNumQuestLeaderBoards(questLogIndex) or 0
                    for i= 1, numObjectives do
                        local text= GetQuestLogLeaderBoard(i, questLogIndex)
                        if text  then
                            local name= data[i]
                            local line= lines[i]
                            if name and line then
                                local num= text:match('(%d+/%d+ )')
                                local per= text:match('( %(%d+%%)%)')
                                if num then
                                    name= num..name
                                elseif per then
                                    name= name..per
                                end
                                line.Text:SetText(name)
                                line:SetHeight(line.Text:GetStringHeight())
                            else
                                break
                            end
                        end
                    end
                end
            else
                local obj= select(3, self:GetQuestName(questID))
                local line= lines[1]
                if obj and line then
                    line.Text:SetText(obj)
                    line:SetHeight(line.Text:GetStringHeight())
                end
            end
        end

        for line in QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
        self:SetLabel(line.Text)
        self:SetLabel(line.Progress)
        end

        for line in QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do--没测试
            set_text(line)
        end

        local mapID = QuestMapFrame:GetParent():GetMapID()
        local storyAchievementID, storyMapID = C_QuestLog.GetZoneStoryInfo(mapID)
        if storyAchievementID then
            local mapInfo = C_Map.GetMapInfo(storyMapID)
            local map= mapInfo and self:CN(mapInfo.name) or nil
            if map then
                QuestScrollFrame.Contents.StoryHeader.Text:SetText(amp)
            end

            local numCriteria = GetAchievementNumCriteria(storyAchievementID)
            local completedCriteria = 0
            for i = 1, numCriteria do
                local _, _, completed = GetAchievementCriteriaInfo(storyAchievementID, i)
                if ( completed ) then
                    completedCriteria = completedCriteria + 1
                end
            end
            QuestScrollFrame.Contents.StoryHeader.Progress:SetFormattedText('|cffffd200故事进度：|r %d/%d章', completedCriteria, numCriteria)
        end
    end)
end

