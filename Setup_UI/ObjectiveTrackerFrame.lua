--Blizzard_ObjectiveTrackerBlock.lua

local function Get_Quest_Obbjective(obj)
    if obj then
        return obj:match('(%d+/%d+ )'), obj:match('( %(%d+%%)%)')
    end
end



local function set_objective_header(frame)
    if frame.Header then
        WoWTools_ChineseMixin:SetLabel(frame.Header.Text, frame.headerText)
    end
end



local function Get_Block(frame, index)
    if frame.usedBlocks[frame.blockTemplate] then
        return frame.usedBlocks[frame.blockTemplate][index]
    end
end













local function set_quest(_, block)
    local questID= block.id and tonumber(block.id)
    local data= WoWTools_ChineseMixin:GetQuestData(questID)
    if not data or not data.T then
        return
    end

    block:SetHeader(data.T)


end





--任务 QuestObjectiveTracker QuestObjectiveTrackerMixin
hooksecurefunc(QuestObjectiveTracker, 'LayoutContents', set_objective_header)
--QuestObjectiveTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(QuestObjectiveTracker, 'AddBlock', set_quest)

--[[hooksecurefunc(QuestObjectiveLineMixin, 'UpdateModule', function(...)

end)]]

hooksecurefunc(QuestObjectiveTracker, 'DoQuestObjectives', function(_, block, questCompleted)--, questSequenced, isExistingBlock, useFullHeight)
    local questID = block.id
    if questCompleted then
        local obj= select(3, WoWTools_ChineseMixin:GetQuestName(questID))
        if obj then
            block:ForEachUsedLine(function(line)--, objectiveKey) --objectiveKey=='QuestComplete'
                C_Timer.After(0.3, function()
                    line.Text:SetText(obj)
                    line:SetHeight(line.Text:GetStringHeight())
                end)
            end)
        end
    else
        local questLogIndex = C_QuestLog.GetLogIndexForQuestID(questID)
	    local numObjectives = GetNumQuestLeaderBoards(questLogIndex) or 0
        local data= WoWTools_ChineseMixin:GetQuestObject(questID)
        if not data or not data[1] then
            return
        end

	    for objectiveIndex = 1, numObjectives do
            local text= GetQuestLogLeaderBoard(objectiveIndex, questLogIndex, true)-- local suppressProgressPercentageInObjectiveText = true
            local line = text and block:GetExistingLine(objectiveIndex)
            local obj= line and data[objectiveIndex]
            if obj then
                local num, per= Get_Quest_Obbjective(text)
                if num then
                    obj= num..obj
                elseif per then
                    obj= obj..per
                end
                line.Text:SetText(obj)
                line:SetHeight(line.Text:GetStringHeight())
            end
        end        
    end
end)

--[[hooksecurefunc(QuestObjectiveTracker, 'UpdateSingle', function(frame, quest)
		local questID = quest:GetID();
	    local isComplete = quest:IsComplete()
       -- local block, isExistingBlock = frame:GetBlock(questID);


    local obj= isComplete and WoWTools_ChineseMixin:GetQuestObjectText(questID)
    if obj then
        block:ForEachUsedLine(function(line, objectiveKey)

            line.Text:SetText(obj)
            line:SetHeight(line.Text:GetStringHeight())
        end)
    end
end)]]

hooksecurefunc(AutoQuestPopupBlockMixin, 'Update', function(frame, questTitle, questID, popUpType)
    local contents = frame.Contents
    if frame.popUpType == "COMPLETE" then
        if C_QuestLog.IsQuestTask(questID) then
            contents.TopText:SetText('点击完成')
        else
            contents.TopText:SetText('点击以完成任务')
        end
    elseif popUpType == "OFFER" then
        contents.TopText:SetText('发现任务！')
        contents.BottomText:SetText('点击以查看任务')
    end
    local title= WoWTools_ChineseMixin:GetQuestName(questID) or WoWTools_ChineseMixin:CN(questTitle)
    if title then
        contents.QuestName:SetText(title)
    end
end)







--战役，任务 CampaignQuestObjectiveTracker
--CampaignQuestObjectiveTracker:HookScript('OnShow', set_objective_header)
--hooksecurefunc(CampaignQuestObjectiveTracker, 'UpdateSingle', set_quest)
hooksecurefunc(CampaignQuestObjectiveTracker, 'LayoutContents', set_objective_header)
hooksecurefunc(CampaignQuestObjectiveTracker, 'AddBlock', set_quest)







--世界，任务 WorldQuestObjectiveTracker
--WorldQuestObjectiveTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(WorldQuestObjectiveTracker, 'LayoutContents', set_objective_header)
hooksecurefunc(WorldQuestObjectiveTracker, 'AddBlock', set_quest)








--旅行者日志 MonthlyActivitiesObjectiveTracker
--MonthlyActivitiesObjectiveTracker:HookScript('OnShow', )
hooksecurefunc(MonthlyActivitiesObjectiveTracker, 'LayoutContents', set_objective_header)
hooksecurefunc(MonthlyActivitiesObjectiveTracker, 'AddBlock', function(_, block)
    local data= WoWTools_ChineseMixin:GetPerksActivityData(block.id)
    if data and data[1] then
        block:SetHeader(data[1])
    end
end)



--成就
--AchievementObjectiveTracker
--AchievementObjectiveTrackerMixin
--AchievementObjectiveTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(AchievementObjectiveTracker, 'LayoutContents', set_objective_header)
hooksecurefunc(AchievementObjectiveTracker, 'AddAchievement', function(frame, achievementID, achievementName, description)
    local block = frame.usedBlocks[frame.blockTemplate] and frame.usedBlocks[frame.blockTemplate][achievementID]

    if not block then
         return
    end

    achievementName= WoWTools_ChineseMixin:CN(achievementName)
    if achievementName then
	    block:SetHeader(achievementName)
    end


    --local height= block.height--HeaderText:GetHeight()
    local numCriteria = GetAchievementNumCriteria(achievementID)
    if numCriteria>0 then
        --local find
        for criteriaIndex, line in pairs(block.usedLines or {}) do
            if type(criteriaIndex)=='number' then
                local criteriaString, criteriaType, _, _, _, _, flags, assetID, quantityString = GetAchievementCriteriaInfo(achievementID, criteriaIndex, true)
                local text= WoWTools_ChineseMixin:CN(criteriaString)
                if description and bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR then
                    local desc= WoWTools_ChineseMixin:CN(description)

                    if desc then-- progress bar                    
                        if string.find(strlower(quantityString), "interface\\moneyframe") then	-- no easy way of telling it's a money progress bar
                            text = quantityString.."\n"..desc
                        else
                            text = string.gsub(quantityString, " / ", "/").." "..desc-- remove spaces so it matches the quest look, x/y
                        end
                    end
                else
                    if ( criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID ) then --for meta criteria look up the achievement name
                        text = WoWTools_ChineseMixin:CN(select(2, GetAchievementInfo(assetID)))
                    end

                end
                if text then
                    block:SetStringText(line.Text, text, nil, colorStyle, block.isHighlighted)
                end
            end
        end

    else
        local desc= WoWTools_ChineseMixin:CN(description)
        if desc then
            local colorStyle = (not timerFailed and IsAchievementEligible(achievementID)) and OBJECTIVE_TRACKER_COLOR["Normal"] or OBJECTIVE_TRACKER_COLOR["Failed"]
            local line= block.usedLines[1]
            if line then
                block:SetStringText(line.Text, desc, nil, colorStyle, block.isHighlighted)
            end
        end
    end
end)

















--场景
--标题
hooksecurefunc(ScenarioObjectiveTracker, 'LayoutContents', function(frame)
    if not frame.scenarioID or not frame.currentStage then
        return
    end

	local scenarioName, _, _, _, _, _, _, _, _, scenarioType, _, _, scenarioID = C_Scenario.GetInfo()
    local name
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
        name= WoWTools_ChineseMixin:GetScenarioName(scenarioID) or WoWTools_ChineseMixin:CN(scenarioName)

	elseif scenarioType == LE_SCENARIO_TYPE_PROVING_GROUNDS or frame.ProvingGroundsBlock:IsActive() then
		name= '试炼场'
	elseif scenarioType == LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY then
		name= '地下城'
	elseif ShouldShowMawBuffs() and not IsInJailersTower() then
		name= WoWTools_ChineseMixin:CN(GetZoneText())
	else
		name= WoWTools_ChineseMixin:GetScenarioName(scenarioID) or WoWTools_ChineseMixin:CN(scenarioName)
	end
    if name then
        frame.Header.Text:SetText(name)
    end
end)

--ScenarioObjectiveTrackerStageMixin
--内容
ScenarioObjectiveTracker.StageBlock.Name:SetPoint('RIGHT', -20, 0)
hooksecurefunc(ScenarioObjectiveTracker.StageBlock, 'UpdateStageBlock', function(frame, _, _, _, _, flags, currentStage, _, numStages)
    if bit.band(flags, SCENARIO_FLAG_SUPRESS_STAGE_TEXT) == SCENARIO_FLAG_SUPRESS_STAGE_TEXT then
        WoWTools_ChineseMixin:SetLabel(frame.Stage)
	else
		if currentStage == numStages then
			frame.Stage:SetText('|cnGREEN_FONT_COLOR:最终阶段|r')
		else
			frame.Stage:SetFormattedText('阶段 %d', currentStage)
		end
	end
    WoWTools_ChineseMixin:SetLabel(frame.Name)
end)

hooksecurefunc(ScenarioObjectiveTracker.StageBlock, 'SetupStageTransition', function(frame, hasNewStage, scenarioCompleted)
    if frame.WidgetContainer:IsShown() then
        return
    end
    if scenarioCompleted then
        local scenarioType = select(10, C_Scenario.GetInfo())
        local dungeonDisplay = (scenarioType == LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY)
        if dungeonDisplay then
            frame.CompleteLabel:SetText('|cnGREEN_FONT_COLOR:地下城完成！|r')
        else
            frame.CompleteLabel:SetText('|cnGREEN_FONT_COLOR:完成！|r')
        end
    else
        frame.CompleteLabel:SetText('|cnGREEN_FONT_COLOR:阶段完成|r')
    end
end)









--奖励目标
hooksecurefunc(BonusObjectiveTracker, 'LayoutContents',  set_objective_header)
























--专业技能 ProfessionsRecipeTracker
--ProfessionsRecipeTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(ProfessionsRecipeTracker, 'LayoutContents', set_objective_header)
hooksecurefunc(ProfessionsRecipeTracker,'AddRecipe', function(frame, recipeID, isRecraft)
    local blockID = NegateIf(recipeID, isRecraft)
    local block = Get_Block(frame, blockID)
    local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, isRecraft)
    if not block then
        return
    end

    if not recipeSchematic then
        return
    end


    local blockName= WoWTools_ChineseMixin:GetRecipeName(C_TradeSkillUI.GetRecipeInfo(recipeID), nil) or WoWTools_ChineseMixin:CN(recipeSchematic.name)

    if blockName then
        blockName = isRecraft and format('再造：%s', blockName) or blockName
        block:SetHeader(blockName)
    end


    if not recipeSchematic.reagentSlotSchematics then
        return
    end

    for index, line in pairs(block.usedLines or {}) do
        local name
        if type(index)=='number' then
            local reagentSlotSchematic= recipeSchematic.reagentSlotSchematics[index]
            if reagentSlotSchematic then
                local reagent = reagentSlotSchematic.reagents[1] or {}
                if reagent.itemID then
                    name= WoWTools_ChineseMixin:GetItemName(reagent.itemID)
                    if not name then
                        local item = Item:CreateFromItemID(reagent.itemID)
                        name= WoWTools_ChineseMixin:CN(item:GetItemName())
                    end
                elseif reagent.currencyID then
                    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(reagent.currencyID)
                    if currencyInfo then
                        name= WoWTools_ChineseMixin:CN(currencyInfo.name)
                    end
                end
                if name then
                    local quantityRequired = reagentSlotSchematic.quantityRequired
			        local quantity = ProfessionsUtil.AccumulateReagentsInPossession(reagentSlotSchematic.reagents)
                    local text = format('%s %s', format('%s/%d', quantity, quantityRequired), name)

                    local metQuantity = quantity >= quantityRequired
                    local colorStyle = OBJECTIVE_TRACKER_COLOR[metQuantity and "Complete" or "Normal"]

                    block:SetStringText(line.Text, text, nil, colorStyle, block.isHighlighted)
                end
            end
        end
    end
end)





















--ObjectiveTrackerFrame
hooksecurefunc(ObjectiveTrackerFrame, 'Init', set_objective_header)



hooksecurefunc(UIWidgetObjectiveTracker, 'OnEvent', function(frame)
    local block = frame.Block
	if block:IsShown() then
        local name= WoWTools_ChineseMixin:CN(GetRealZoneText())
        if name then
		    frame:SetHeader(name)
        end
	end
end)

--UIWidgetObjectiveTracker
hooksecurefunc(UIWidgetObjectiveTracker, 'LayoutContents', function(frame)
    local block = frame.Block
	if block and block:IsShown() then
        local name= WoWTools_ChineseMixin:CN(GetRealZoneText())
        if name then
		    frame:SetHeader(name)
        end
	end
end)


hooksecurefunc(AdventureObjectiveTracker, 'LayoutContents', set_objective_header)

--[[hooksecurefunc(AdventureObjectiveTracker, 'ProcessTrackingEntry', function(frame, trackableType, trackableID)
    local targetType, targetID = C_ContentTracking.GetCurrentTrackingTarget(trackableType, trackableID);
   
	local block = targetType and frame:GetBlock(ContentTrackingUtil.MakeCombinedID(trackableType, trackableID))
    if not block then
        return
    end

    local title = C_ContentTracking.GetTitle(trackableType, trackableID)
    local cn= WoWTools_ChineseMixin:CN(title)
    if cn then
        --block.name = cn
       -- block:SetHeader(cn)
        
        print(cn, block.HeaderText:GetText(), block:IsShown())
    end
end)]]
