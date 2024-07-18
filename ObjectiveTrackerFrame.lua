if not ObjectiveTrackerContainerMixin then--11版本
    return
end

local e= select(2, ...)




local function set_objective_header(self)
    if self.Header then
        e.set(self.Header.Text, self.headerText)
    end
end



local function Get_Block(self, index)
    if self.usedBlocks[self.blockTemplate] then
        return self.usedBlocks[self.blockTemplate][index]
    end
end













local function set_quest(_, block)
    local name= e.Get_Quest_Info(block.id, true, false, false)
    if name then
        block:SetHeader(name)
    end
end




--[[
hooksecurefunc(QuestObjectiveTracker, 'UpdateSingle', set_quest)
local questID = quest:GetID();
local block = Get_Block(self, questID);    
local name= e.Get_Quest_Info(questID, true, false, false)
if block and name then
    block:SetHeader(name)
end
]]

--任务 QuestObjectiveTracker QuestObjectiveTrackerMixin
QuestObjectiveTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(QuestObjectiveTracker, 'AddBlock', set_quest)










--战役，任务 CampaignQuestObjectiveTracker
CampaignQuestObjectiveTracker:HookScript('OnShow', set_objective_header)
--hooksecurefunc(CampaignQuestObjectiveTracker, 'UpdateSingle', set_quest)
hooksecurefunc(CampaignQuestObjectiveTracker, 'AddBlock', set_quest)







--世界，任务 WorldQuestObjectiveTracker
WorldQuestObjectiveTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(WorldQuestObjectiveTracker, 'AddBlock', set_quest)








--旅行者日志 MonthlyActivitiesObjectiveTracker
MonthlyActivitiesObjectiveTracker:HookScript('OnShow', set_objective_header)

hooksecurefunc(MonthlyActivitiesObjectiveTracker, 'AddBlock', function(_, block)
    local data= e.Get_PerksActivity_Info(block.id)
    if data and data[1] then
        block:SetHeader(data[1])
    end
end)



--成就
--AchievementObjectiveTracker
--AchievementObjectiveTrackerMixin
AchievementObjectiveTracker:HookScript('OnShow', set_objective_header)

hooksecurefunc(AchievementObjectiveTracker, 'AddAchievement', function(self, achievementID, achievementName, description)
    local block = self.usedBlocks[self.blockTemplate] and self.usedBlocks[self.blockTemplate][achievementID]
    
    if not block then
         return
    end

    achievementName= e.strText[achievementName]
    if achievementName then
	    block:SetHeader(achievementName)
    end

    
    --local height= block.height--HeaderText:GetHeight()
    local numCriteria = GetAchievementNumCriteria(achievementID);
    if numCriteria>0 then
        --local find
        for criteriaIndex, line in pairs(block.usedLines or {}) do
            if type(criteriaIndex)=='number' then
                local _, criteriaType, _, _, _, _, flags, assetID, quantityString = GetAchievementCriteriaInfo(achievementID, criteriaIndex, true)
                local text
                if description and bit.band(flags, EVALUATION_TREE_FLAG_PROGRESS_BAR) == EVALUATION_TREE_FLAG_PROGRESS_BAR then
                    local desc= e.strText[description]
                    if desc then-- progress bar                    
                        if string.find(strlower(quantityString), "interface\\moneyframe") then	-- no easy way of telling it's a money progress bar
                            text = quantityString.."\n"..desc
                        else
                            text = string.gsub(quantityString, " / ", "/").." "..desc-- remove spaces so it matches the quest look, x/y
                        end
                    end
                else
                    if ( criteriaType == CRITERIA_TYPE_ACHIEVEMENT and assetID ) then--for meta criteria look up the achievement name
                        text = e.strText[select(2, GetAchievementInfo(assetID))]
                    --else
                        --text= e.strText[description]
                    end
                end
                if text then
                    --find=true
                    block:SetStringText(line.Text, text, nil, colorStyle, block.isHighlighted)
                    --local textHeight = block:SetStringText(line.Text, text, nil, colorStyle, block.isHighlighted)
                    --line:SetHeight(textHeight)
                end
            end
            --block.height= block.height+ line:GetHeight()
        end
        --if find then
            --block.height = block.height+ block.parentModule.lineSpacing*2
            --block:SetHeight(block.height)
        --end
    else
        local desc= e.strText[description]
        if desc then
            local colorStyle = (not timerFailed and IsAchievementEligible(achievementID)) and OBJECTIVE_TRACKER_COLOR["Normal"] or OBJECTIVE_TRACKER_COLOR["Failed"];
            local line= block.usedLines[1]
            if line then
                block:SetStringText(line.Text, desc, nil, colorStyle, block.isHighlighted)            
                --local textHeight = block:SetStringText(line.Text, desc, nil, colorStyle, block.isHighlighted)            
                --line:SetHeight(textHeight)
               -- block.height = block.height+ textHeight + block.parentModule.lineSpacing*2
                --print(block.parentModule.lineSpacing)
                --block:SetHeight(block.height)
            end
        end
    end
end)













--专业技能 ProfessionsRecipeTracker
ProfessionsRecipeTracker:HookScript('OnShow', set_objective_header)
hooksecurefunc(ProfessionsRecipeTracker,'AddRecipe', function(self, recipeID, isRecraft)
    local blockID = NegateIf(recipeID, isRecraft);
    local block = Get_Block(self, blockID)
    local recipeSchematic = C_TradeSkillUI.GetRecipeSchematic(recipeID, isRecraft)
    if not block then
        return
    end   

    if not recipeSchematic then
        return
    end


    local blockName= e.Get_Recipe_Name(C_TradeSkillUI.GetRecipeInfo(recipeID), nil) or e.strText[recipeSchematic.name]

    if blockName then
        blockName = isRecraft and format('再造：%s', blockName) or blockName;
        block:SetHeader(blockName);
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
                    name= e.Get_Item_Name(reagent.itemID)
                    if not name then
                        local item = Item:CreateFromItemID(reagent.itemID)
                        name= e.strText[item:GetItemName()]
                    end
                elseif reagent.currencyID then
                    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(reagent.currencyID);
                    if currencyInfo then
                        name= e.strText[currencyInfo.name]
                    end
                end
                if name then
                    local quantityRequired = reagentSlotSchematic.quantityRequired;
			        local quantity = ProfessionsUtil.AccumulateReagentsInPossession(reagentSlotSchematic.reagents);
                    local text = format('%s %s', format('%s/%d', quantity, quantityRequired), name)

                    local metQuantity = quantity >= quantityRequired;                    
                    local colorStyle = OBJECTIVE_TRACKER_COLOR[metQuantity and "Complete" or "Normal"]
                
                    block:SetStringText(line.Text, text, nil, colorStyle, block.isHighlighted)
                end
            end
        end
    end
end)













--ObjectiveTrackerFrame
hooksecurefunc(ObjectiveTrackerFrame, 'Init', set_objective_header)



