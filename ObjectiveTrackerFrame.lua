if not ObjectiveTrackerContainerMixin then--11版本
    return
end

local e= select(2, ...)




local function set_objective_header(self)
    if self.Header then
        e.set(self.Header.Text, self.headerText)
    end
end







--ObjectiveTrackerFrame
hooksecurefunc(ObjectiveTrackerFrame, 'Init', set_objective_header)



























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

    local find
    local height= block.HeaderText:GetHeight()
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
                else
                    text= e.strText[description]
                end
            end
            if text then
                find=true
                local textHeight = block:SetStringText(line.Text, text, nil, colorStyle, block.isHighlighted)
	            line:SetHeight(textHeight)
            end
        end
        height= height+ line:GetHeight()
    end
    if find then
        block.height = height+ block.parentModule.lineSpacing
        block:SetHeight(block.height)
    end
end)

