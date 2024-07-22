if ObjectiveTrackerContainerMixin then--11版本
    return
end


local e= select(2, ...)


local function font(lable)
    if lable then
        local fontName2, size2, fontFlag2= lable:GetFont()
        if e.onlyChinese then
            fontName2= 'Fonts\\ARHei.ttf'--黑体字
        end
        lable:SetFont(fontName2, size2, fontFlag2 or 'OUTLINE')
    end
end


local function set(self, text, affer, setFont)
    if self and text and text~='' and (not self.IsForbidden or not self:IsForbidden()) and self.SetText then--CanAccessObject(self) then
        if setFont then
            font(self)
        end
        if affer then
            C_Timer.After(affer, function() self:SetText(text) end)
        else
            self:SetText(text)
        end
    end
end

local function setLabel(lable, text)
    if lable and lable.SetText then
        set(lable, e.strText[text or lable:GetText()])
    end
end

local function reg(self, text, index)
    if not self then
        return
    end
    for i, region in pairs({self:GetRegions()}) do
        if region:GetObjectType()=='FontString' and (index==i or not index) then
            text= index==i and text or e.strText[region:GetText()]
            set(region, text)
            if index then
                return
            end
        end
    end
end









hooksecurefunc(ObjectiveTrackerBlocksFrame.QuestHeader, 'UpdateHeader', function(self)
    set(self.Text, '任务')
end)

ScenarioChallengeModeBlock.DeathCount:HookScript('OnEnter', function(self)--ScenarioChallengeDeathCountMixin
    GameTooltip:SetText(format('%d次死亡', self.count), 1, 1, 1)
    GameTooltip:AddLine(format('时间损失：|cffffffff%s|r', SecondsToClock(self.timeLost)))
    GameTooltip:Show()
end)

ScenarioChallengeModeBlock.TimesUpLootStatus:HookScript('OnEnter', function(self)--Scenario_ChallengeMode_TimesUpLootStatus_OnEnter
    GameTooltip:SetText('时间结束', 1, 1, 1)
    local line
    if (self:GetParent().wasDepleted) then
        if (UnitIsGroupLeader("player")) then
            line = '你的钥石无法升级，且你在完成此地下城后将无法获得战利品宝箱。你可以右键点击头像并选择“重置史诗地下城”来重新开始挑战。'
        else
            line = '你的钥石无法升级，且你在完成此地下城后将无法获得战利品宝箱。小队队长可以右键点击头像并选择“重置史诗地下城”来重新开始挑战。'
        end
    else
        line = '你的钥石无法升级。但你完成此地下城后仍可获得战利品宝箱'
    end
    GameTooltip:AddLine(line, nil, nil, nil, true)
    GameTooltip:Show()
end)



hooksecurefunc('ScenarioBlocksFrame_SetupStageBlock', function(scenarioCompleted)
    if not ScenarioStageBlock.WidgetContainer:IsShown() then
        if ( scenarioCompleted ) then
            local scenarioType = select(10, C_Scenario.GetInfo())
            local dungeonDisplay = (scenarioType == LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY)
            if( dungeonDisplay ) then
                set(ScenarioStageBlock.CompleteLabel, '地下城完成！')
            else
                set(ScenarioStageBlock.CompleteLabel, '完成！')
            end
        else
            set(ScenarioStageBlock.CompleteLabel, '阶段完成')
        end
    end
end)
hooksecurefunc('Scenario_ChallengeMode_ShowBlock', function()
    local level= C_ChallengeMode.GetActiveKeystoneInfo()
    if level then
        set(ScenarioChallengeModeBlock.Level, format('%d级', level))
    end
end)

--出现Bug SCENARIO_CONTENT_TRACKER_MODULE:SetHeader(ObjectiveTrackerFrame.BlocksFrame.ScenarioHeader, '场景战役', nil)
--Blizzard_ScenarioObjectiveTracker.lua
hooksecurefunc(SCENARIO_CONTENT_TRACKER_MODULE, 'Update', function()
    local scenarioName, currentStage, numStages, flags, _, _, _, _, _, scenarioType, _, _, scenarioID= C_Scenario.GetInfo()

    local shouldShowMawBuffs = ShouldShowMawBuffs()
    local isInScenario = numStages > 0
    if ( not isInScenario and (not shouldShowMawBuffs or IsOnGroundFloorInJailersTower()) ) then
        return
    end

    local BlocksFrame = SCENARIO_TRACKER_MODULE.BlocksFrame

    local stageBlock = ScenarioStageBlock
    local stageName = C_Scenario.GetStepInfo()

    local inChallengeMode = (scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE)
    local inProvingGrounds = (scenarioType == LE_SCENARIO_TYPE_PROVING_GROUNDS)
    local dungeonDisplay = (scenarioType == LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY)
    local scenariocompleted = currentStage > numStages
    


    if ( not isInScenario ) then
    elseif ( scenariocompleted ) then
    elseif ( inChallengeMode ) then
    elseif ( ScenarioProvingGroundsBlock.timerID ) then
        
    else
        --if ( BlocksFrame.currentStage ~= currentStage or BlocksFrame.scenarioName ~= scenarioName or BlocksFrame.stageName ~= stageName) then
            local data= e.Get_Scenario_Step_Info(scenarioID, currentStage) or {}
            if ( bit.band(flags, SCENARIO_FLAG_SUPRESS_STAGE_TEXT) == SCENARIO_FLAG_SUPRESS_STAGE_TEXT ) then
                
                local name= data[2] or e.strText[stageName]
                if name then
                    stageBlock.Stage:SetText(name)
                end
                
            else
                if ( currentStage == numStages ) then
                    set(stageBlock.Stage, '|cnGREEN_FONT_COLOR:最终阶段|r')
                else
                    set(stageBlock.Stage, format('阶段%d', currentStage))
                end
                local name= data[1] or e.strText[stageName]
                if name then
                    stageBlock.Name:SetText(name)
                end
            end
            
    end

    if ( BlocksFrame.currentBlock ) then
        if ( inChallengeMode ) then-- header
            local name= e.strText[BlocksFrame.scenarioName]
            if name then
                SCENARIO_CONTENT_TRACKER_MODULE.Header.Text:SetText(name)
            end
        elseif ( inProvingGrounds or ScenarioProvingGroundsBlock.timerID ) then
            set(SCENARIO_CONTENT_TRACKER_MODULE.Header.Text, '试炼场')

        elseif( dungeonDisplay ) then
            set(SCENARIO_CONTENT_TRACKER_MODULE.Header.Text, '地下城')

        elseif ( shouldShowMawBuffs and not IsInJailersTower() ) then
            set(SCENARIO_CONTENT_TRACKER_MODULE.Header.Text, e.strText[GetZoneText()])
        else
            local name= e.Get_Scenario_Name(scenarioID) or e.strText[BlocksFrame.scenarioName]
            if name then
                SCENARIO_CONTENT_TRACKER_MODULE.Header.Text:SetText(name)
            end
        end
    end
end)

ScenarioStageBlock:HookScript('OnEnter', function(self)
    local _, currentStage, _, _, _, _, _, _, _, _, _, _, scenarioID= C_Scenario.GetInfo()
    
    local data= e.Get_Scenario_Step_Info(scenarioID, currentStage)
    if data then
        GameTooltip:AddLine(' ')
        GameTooltip:AddLine(data[2], 1,1,1, true)
        GameTooltip:AddLine(data[1], nil,1,nil, true)
        GameTooltip:Show()
    end

    
end)

C_Timer.After(2, function()


   -- setLabel(SCENARIO_CONTENT_TRACKER_MODULE.Header.Text)
    set(ObjectiveTrackerFrame.HeaderMenu.Title, '追踪')
    set(ObjectiveTrackerBlocksFrame.CampaignQuestHeader.Text, '战役')
    set(ObjectiveTrackerBlocksFrame.ProfessionHeader.Text, '专业')
    set(ObjectiveTrackerBlocksFrame.MonthlyActivitiesHeader.Text, '旅行者日志')
    set(ObjectiveTrackerBlocksFrame.AchievementHeader.Text, '成就')

    reg(CombatConfigSettingsNameEditBox)--过滤名称
end)