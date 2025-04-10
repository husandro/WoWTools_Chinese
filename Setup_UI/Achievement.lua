local e = select(2, ...)




--InGuildView() 是否，查看，公会
--local achievementFunctions = ACHIEVEMENT_FUNCTIONS
local function InGuildView()
	--return achievementFunctions == GUILD_ACHIEVEMENT_FUNCTIONS
    return AchievementFrame.selectedTab==2
end
--[[local function set_index(tabIndex)--InGuildView()
    if tabIndex == AchievementCategoryIndex then
        achievementFunctions = ACHIEVEMENT_FUNCTIONS
    elseif tabIndex == GuildCategoryIndex then
        achievementFunctions = GUILD_ACHIEVEMENT_FUNCTIONS
    elseif tabIndex == StatisticsCategoryIndex then
        achievementFunctions = STAT_FUNCTIONS
    end
end]]
--hooksecurefunc('AchievementFrameBaseTab_OnClick', set_index)
--hooksecurefunc('AchievementFrameComparisonTab_OnClick', set_index)

local function Init()
    AchievementFrameTab1:SetText('成就')
    AchievementFrameTab2:SetText('公会')
    AchievementFrameTab3:SetText('统计')
    AchievementFrame.SearchBox.Instructions:SetText('搜索')
    AchievementFrameSummaryAchievementsHeaderTitle:SetText('近期成就')
    AchievementFrameSummaryCategoriesHeaderTitle:SetText('进展总览')
    WoWTools_ChineseMixin:Set_Label_Text(AchievementFrameSummaryCategoriesStatusBarTitle)

    --标题
    AchievementFrame.Header.Title:SetText('成就点数')
    hooksecurefunc('AchievementFrame_RefreshView', function()--Blizzard_AchievementUI.lua
        WoWTools_ChineseMixin:Set_Label_Text(AchievementFrame.Header.Title)
    end)

    --近期成就
    hooksecurefunc('AchievementFrameSummary_UpdateAchievements', function(...)
        local numAchievements = select("#", ...)
        if not AchievementFrameSummaryAchievements.buttons or not numAchievements then
            return
        end

        local name, completed, description, achievementID
        local defaultAchievementCount = 1
        for i=1, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do--4
            local button = AchievementFrameSummaryAchievements.buttons[i]
            if  button then
                if ( i <= numAchievements ) then
                    achievementID = select(i, ...)
                    if achievementID then
                        _, name, _, _, _, _, _, description = GetAchievementInfo(achievementID)
                        WoWTools_ChineseMixin:Set_Label_Text(button.Label, name)
                        WoWTools_ChineseMixin:Set_Label_Text(button.Description, description)
                    end
                else
                    local tAchievements
                    if ( InGuildView() ) then
                        tAchievements = ACHIEVEMENTUI_DEFAULTGUILDSUMMARYACHIEVEMENTS
                    else
                        tAchievements = ACHIEVEMENTUI_DEFAULTSUMMARYACHIEVEMENTS
                    end
                    for i=defaultAchievementCount, ACHIEVEMENTUI_MAX_SUMMARY_ACHIEVEMENTS do
                        achievementID = tAchievements[defaultAchievementCount]
                        if ( not achievementID ) then
                            break
                        end
                        _, name, _, completed, _, _, _, description = GetAchievementInfo(achievementID)
                        if ( completed ) then
                            defaultAchievementCount = defaultAchievementCount+1
                        else
                            WoWTools_ChineseMixin:Set_Label_Text(button.Label, name)
                            WoWTools_ChineseMixin:Set_Label_Text(button.Description, description)
                            defaultAchievementCount = defaultAchievementCount+1
                            button.tooltipTitle = "未获得的成就"
                            button.tooltip = "达到每个成就所要求的条件，赢取成就点数、奖励和荣耀！"
                            break
                        end
                    end
                end
            end
        end
    end)
    hooksecurefunc('AchievementFrameSummary_UpdateSummaryProgressBars', function(categories)
        for i = 1, 12 do
            local statusBar = _G["AchievementFrameSummaryCategoriesCategory"..i]
            if statusBar and i <= #categories then
                local categoryName = GetCategoryInfo(categories[i])
                WoWTools_ChineseMixin:Set_Label_Text(statusBar.Label, categoryName)
            end
        end
    end)

    --列表
    hooksecurefunc(AchievementFrameCategories.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            if btn.Button then
                WoWTools_ChineseMixin:Set_Label_Text(btn.Button.Label, btn.Button.name)
                --print(btn.Button.Label:GetText(), WoWTools_ChineseMixin:Setup(btn.Button.name))
            end
        end
    end)
    hooksecurefunc(AchievementCategoryTemplateMixin, 'Init', function(self, info)
        if info.id == 81 then
            self.Button.text = "对于许多玩家来说，“光辉事迹”中的成就几乎不可能完成，至少是极端困难的。它们并不奖励成就点数，而是你在艾泽拉斯世界曾经创下的丰功伟绩的纪录。"
        elseif info.id == 15093 then
            self.Button.text = "对于许多公会来说，“光辉事迹”几乎不可能完成，至少是极端困难的。它们并不奖励点数，而是见证了这个公会在艾泽拉斯世界曾经创下的丰功伟绩的纪录。"
        end
    end)
    hooksecurefunc('AchievementFrameCategories_OnCategoryChanged', function(category)
        if AchievementFrameAchievementsFeatOfStrengthText:IsShown() then
            AchievementFrameAchievementsFeatOfStrengthText:SetText(
                InGuildView() and '对于许多公会来说，“光辉事迹”几乎不可能完成，至少是极端困难的。它们并不奖励点数，而是见证了这个公会在艾泽拉斯世界曾经创下的丰功伟绩的纪录。'
                or '对于许多玩家来说，“光辉事迹”中的成就几乎不可能完成，至少是极端困难的。它们并不奖励成就点数，而是你在艾泽拉斯世界曾经创下的丰功伟绩的纪录。'
            )
        end
    end)

    --成就
    hooksecurefunc(AchievementTemplateMixin, 'Init', function(self, elementData)
        local _, name, description,rewardText
        if self.index then
            _, name, _, _, _, _, _, description, _, _, rewardText = GetAchievementInfo(elementData.category, self.index)
        else
            _, name, _, _, _, _, _, description, _, _, rewardText = GetAchievementInfo(self.id)--Social
        end
        WoWTools_ChineseMixin:Set_Label_Text(self.Label, name)
        WoWTools_ChineseMixin:Set_Label_Text(self.Description, description)
        WoWTools_ChineseMixin:Set_Label_Text(self.HiddenDescription, description)
        WoWTools_ChineseMixin:Set_Label_Text(self.Reward, rewardText)
        if self.Tracked:IsShown() and not self.Tracked.is_set then
            for _, region in pairs({self.Tracked:GetRegions()}) do
                if region:GetObjectType()=='FontString' then
                    WoWTools_ChineseMixin:Set_Label_Text(region)
                end
            end
            self.Tracked.is_set= true
        end
    end)

    hooksecurefunc('AchievementObjectives_DisplayCriteria', function(objectivesFrame, ID)--条件
        if not objectivesFrame or not ID then
            return
        end
        local requiresRep, repLevel, _
        if ( not objectivesFrame.completed ) then
            requiresRep, _, repLevel = GetAchievementGuildRep(ID)
            if ( requiresRep and repLevel) then
                local factionStandingtext = GetText("FACTION_STANDING_LABEL"..repLevel, UnitSex("player"))
                objectivesFrame.RepCriteria:SetFormattedText('|cffffffff需要公会声望：|r %s', WoWTools_ChineseMixin:Setup(factionStandingtext) or '')
            end
        end
        local numCriteria = GetAchievementNumCriteria(ID) or 0
        if numCriteria==0 and not requiresRep then
            return
        end
        local textStrings, metas = 0, 0
        for i = 1, numCriteria do
            local criteriaString, criteriaType, completed, _, _, _, flags, assetID = GetAchievementCriteriaInfo(ID, i)
            if ( criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID ) then
                metas = metas + 1
                local achievementName = e.strText[select(2, GetAchievementInfo(assetID))]
                local metaCriteria = objectivesFrame:GetMeta(metas)
                if achievementName and metaCriteria then
                    metaCriteria.Label:SetText(achievementName)
                end

            elseif not (flags and bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR) then
                textStrings = textStrings + 1
                criteriaString= e.strText[criteriaString]
                if criteriaString then
                    local criteria = objectivesFrame:GetCriteria(textStrings)
                    if criteria then
                        criteria.Name:SetText("- "..criteriaString)
                    end
                end
            end
        end
    end)



    --搜索
    hooksecurefunc('AchievementFrame_ShowSearchPreviewResults', function()
        local numResults = GetNumFilteredAchievements() or 0
        if numResults == 0 then
            return
        end
        local searchPreviewContainer = AchievementFrame.SearchPreviewContainer
        local searchPreviews = searchPreviewContainer.searchPreviews
        for index = 1, 5 do
            local searchPreview = searchPreviews[index]
            if ( index <= numResults ) then
                local achievementID = GetFilteredAchievementID(index)
                local name= achievementID and select(2, GetAchievementInfo(achievementID))
                WoWTools_ChineseMixin:Set_Label_Text(searchPreview.Name, name)
            end
        end

        if numResults > 5 then
            searchPreviewContainer.ShowAllSearchResults.Text:SetFormattedText('显示全部|cnGREEN_FONT_COLOR:%d|r个结果', numResults)
        end
    end)
    hooksecurefunc(AchievementFullSearchResultsButtonMixin, 'Init', function(self)
        local _, name, _, completed = GetAchievementInfo(self.achievementID)
        WoWTools_ChineseMixin:Set_Label_Text(self.Name, name)

        if ( completed ) then
            self.ResultType:SetText('已获得')
        else
            self.ResultType:SetText('未完成')
        end

        local categoryID = GetAchievementCategory(self.achievementID)
        local categoryName, parentCategoryID = GetCategoryInfo(categoryID)

        local path = WoWTools_ChineseMixin:Setup(categoryName)
        while ( not (parentCategoryID == -1) ) do
            categoryName, parentCategoryID = GetCategoryInfo(parentCategoryID)
            path = WoWTools_ChineseMixin:Setup(categoryName).." > "..path
        end
        self.Path:SetText(path)
    end)
    hooksecurefunc('AchievementFrame_UpdateFullSearchResults', function()
        local numResults = GetNumFilteredAchievements() or 0
	    AchievementFrame.SearchResults.TitleText:SetFormattedText('搜索|cffff00ff%s|r 结果|cnGREEN_FONT_COLOR:%d|r', AchievementFrame.SearchBox:GetText(), numResults)
    end)

    --统计
    hooksecurefunc(AchievementStatTemplateMixin, 'Init', function(self, elementData)
        if elementData then
            local category = elementData.id
            local colorIndex = elementData.colorIndex
            if elementData.header then
                local text
                if ( category == ACHIEVEMENT_COMPARISON_STATS_SUMMARY_ID ) then
                    text = '总览'
                else
                    text = e.strText[GetCategoryInfo(category)]
                end
                if text then
                    self.Title:SetText(text)
                end
            else
                local name= select(2, GetAchievementInfo(category))
                WoWTools_ChineseMixin:Set_Label_Text(self.Text, name)
            end
        end
    end)




    --比较
    hooksecurefunc(AchievementComparisonTemplateMixin, 'Init', function(self, elementData)
        local _, name, _, _, _, _, _, description = GetAchievementInfo(elementData.category, elementData.index)
        WoWTools_ChineseMixin:Set_Label_Text(self.Player.Label, name)
        WoWTools_ChineseMixin:Set_Label_Text(self.Player.Description, description)
        if not GetAchievementComparisonInfo(self.id) then
            self.Friend.Status:SetText('未完成')
        end
    end)
    hooksecurefunc('AchievementFrameComparison_UpdateStatusBars', function(ID)
        local name
        if ID == ACHIEVEMENT_COMPARISON_SUMMARY_ID then-- -1
            name = '总览'
        else
            name= e.strText[GetCategoryInfo(ID)]
        end
        if name then
            AchievementFrameComparison.Summary.Player.StatusBar.Title:SetFormattedText('已获得 %s 项成就', name)
        end
    end)
    hooksecurefunc(AchivementComparisonStatMixin, 'Init', function(self, elementData)--比较, 统计        
        if not elementData then return end
        local category = elementData.id
        local colorIndex = elementData.colorIndex
        if elementData.header then
            local title= e.strText[GetCategoryInfo(category)]
            if title then
                self.Title:SetText(title)
            end

        else
            local name= select(2, GetAchievementInfo(category))
            WoWTools_ChineseMixin:Set_Label_Text(self.Text, name)
        end
    end)

end
















EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_AchievementUI' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)