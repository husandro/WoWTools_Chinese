




local function set_objective_header(self)
    if self.Header then
        WoWTools_ChineseMixin:SetLabel(self.Header.Text, self.headerText)
    end
end



local function Get_Block(self, index)
    if self.usedBlocks[self.blockTemplate] then
        return self.usedBlocks[self.blockTemplate][index]
    end
end













local function set_quest(_, block)
    local questID= block.id and tonumber(block.id)
    if questID then
        local name= WoWTools_ChineseMixin:GetQuestName(questID)
        if name then
            block:SetHeader(name)
        end
    end
end




--[[
hooksecurefunc(QuestObjectiveTracker, 'UpdateSingle', set_quest)
local questID = quest:GetID()
local block = Get_Block(self, questID)    
local name= WoWTools_ChineseMixin:GetQuestName(questID)
if block and name then
    block:SetHeader(name)
end
]]

--任务 QuestObjectiveTracker QuestObjectiveTrackerMixin
hooksecurefunc(QuestObjectiveTracker, 'LayoutContents', set_objective_header)
--QuestObjectiveTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(QuestObjectiveTracker, 'AddBlock', set_quest)


hooksecurefunc(AutoQuestPopupBlockMixin, 'Update', function(self, questTitle, questID, popUpType)
    local contents = self.Contents
    if self.popUpType == "COMPLETE" then
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
hooksecurefunc(AchievementObjectiveTracker, 'AddAchievement', function(self, achievementID, achievementName, description)
    local block = self.usedBlocks[self.blockTemplate] and self.usedBlocks[self.blockTemplate][achievementID]

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
hooksecurefunc(ScenarioObjectiveTracker, 'LayoutContents', function(self)
    if not self.scenarioID or not self.currentStage then
        return
    end

	local scenarioName, _, _, _, _, _, _, _, _, scenarioType, _, _, scenarioID = C_Scenario.GetInfo()
    local name
	if scenarioType == LE_SCENARIO_TYPE_CHALLENGE_MODE then
        name= WoWTools_ChineseMixin:GetScenarioName(scenarioID) or WoWTools_ChineseMixin:CN(scenarioName)

	elseif scenarioType == LE_SCENARIO_TYPE_PROVING_GROUNDS or self.ProvingGroundsBlock:IsActive() then
		name= '试炼场'
	elseif scenarioType == LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY then
		name= '地下城'
	elseif ShouldShowMawBuffs() and not IsInJailersTower() then
		name= WoWTools_ChineseMixin:CN(GetZoneText())
	else
		name= WoWTools_ChineseMixin:GetScenarioName(scenarioID) or WoWTools_ChineseMixin:CN(scenarioName)
	end
    if name then
        self.Header.Text:SetText(name)
    end
end)

--ScenarioObjectiveTrackerStageMixin
--内容
ScenarioObjectiveTracker.StageBlock.Name:SetPoint('RIGHT', -20, 0)
hooksecurefunc(ScenarioObjectiveTracker.StageBlock, 'UpdateStageBlock', function(self, _, _, _, _, flags, currentStage, _, numStages)
    if bit.band(flags, SCENARIO_FLAG_SUPRESS_STAGE_TEXT) == SCENARIO_FLAG_SUPRESS_STAGE_TEXT then
        WoWTools_ChineseMixin:SetLabel(self.Stage)
	else
		if currentStage == numStages then
			self.Stage:SetText('|cnGREEN_FONT_COLOR:最终阶段|r')
		else
			self.Stage:SetFormattedText('阶段 %d', currentStage)
		end
	end
    WoWTools_ChineseMixin:SetLabel(self.Name)
end)

hooksecurefunc(ScenarioObjectiveTracker.StageBlock, 'SetupStageTransition', function(self, hasNewStage, scenarioCompleted)
    if self.WidgetContainer:IsShown() then
        return
    end
    if scenarioCompleted then
        local scenarioType = select(10, C_Scenario.GetInfo())
        local dungeonDisplay = (scenarioType == LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY)
        if dungeonDisplay then
            self.CompleteLabel:SetText('|cnGREEN_FONT_COLOR:地下城完成！|r')
        else
            self.CompleteLabel:SetText('|cnGREEN_FONT_COLOR:完成！|r')
        end
    else
        self.CompleteLabel:SetText('|cnGREEN_FONT_COLOR:阶段完成|r')
    end
end)









--奖励目标
hooksecurefunc(BonusObjectiveTracker, 'LayoutContents',  set_objective_header)
























--专业技能 ProfessionsRecipeTracker
--ProfessionsRecipeTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(ProfessionsRecipeTracker, 'LayoutContents', set_objective_header)
hooksecurefunc(ProfessionsRecipeTracker,'AddRecipe', function(self, recipeID, isRecraft)
    local blockID = NegateIf(recipeID, isRecraft)
    local block = Get_Block(self, blockID)
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













hooksecurefunc(AdventureObjectiveTracker, 'LayoutContents', set_objective_header)








--ObjectiveTrackerFrame
hooksecurefunc(ObjectiveTrackerFrame, 'Init', set_objective_header)



hooksecurefunc(UIWidgetObjectiveTracker, 'OnEvent', function(self)
    local block = self.Block
	if block:IsShown() then
        local name= WoWTools_ChineseMixin:CN(GetRealZoneText())
        if name then
		    self:SetHeader(name)
        end
	end
end)

--UIWidgetObjectiveTracker
hooksecurefunc(UIWidgetObjectiveTracker, 'LayoutContents', function(self)
    local block = self.Block
	if block and block:IsShown() then
        local name= WoWTools_ChineseMixin:CN(GetRealZoneText())
        if name then
		    self:SetHeader(name)
        end
	end
end)