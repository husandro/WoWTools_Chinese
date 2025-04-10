local e= select(2, ...)

e.set(QuestFrameAcceptButton)--:SetText('接受')
e.set(QuestFrameGreetingGoodbyeButton)--:SetText('再见')
e.set(QuestFrameCompleteQuestButton)--:SetText('完成任务')
e.set(QuestFrameCompleteButton)--:SetText('继续')
e.set(QuestFrameGoodbyeButton)--:SetText('再见')
e.set(QuestFrameDeclineButton)--:SetText('拒绝')
e.set(QuestLogPopupDetailFrameAbandonButton)--:SetText('放弃')
e.set(QuestLogPopupDetailFrameShareButton)--:SetText('共享')
e.set(QuestLogPopupDetailFrame.ShowMapButton.Text)--:SetText('显示地图')

e.set(QuestMapFrame.DetailsFrame.BackButton)--:SetText('返回')
e.set(QuestMapFrame.DetailsFrame.AbandonButton)--:SetText('放弃')]]
QuestMapFrame.DetailsFrame.ShareButton:SetText('共享')
QuestMapFrame.DetailsFrame.DestinationMapButton.tooltipText= '显示最终目的地'
QuestMapFrame.DetailsFrame.WaypointMapButton.tooltipText= '显示旅行路径'

e.region(QuestMapFrame.DetailsFrame.RewardsFrame)--, '奖励')
e.region(MapQuestInfoRewardsFrame, false, true)
e.region(QuestInfoRewardsFrame, false, true)
e.hookLabel(QuestInfoObjectivesHeader)
e.hookLabel(QuestInfoDescriptionHeader)

e.set(QuestInfoXPFrame.ReceiveText)
e.hookLabel(QuestInfoAccountCompletedNotice)




hooksecurefunc('QuestMapFrame_UpdateQuestDetailsButtons', function()
    local questID = C_QuestLog.GetSelectedQuest()
    local isWatched = QuestUtils_IsQuestWatched(questID)
    if isWatched then
        QuestMapFrame.DetailsFrame.TrackButton:SetText('取消追踪')
        QuestLogPopupDetailFrame.TrackButton:SetText('取消追踪')
    else
        QuestMapFrame.DetailsFrame.TrackButton:SetText('追踪')
        QuestLogPopupDetailFrame.TrackButton:SetText('追踪')
    end
end)


--QuestFrame.lua
QuestFrame:HookScript('OnShow', function()
    if not UnitExists('questnpc') then
       return
    end
    local name, name2= e.Get_Unit_Name('questnpc', nil, true)
    if name then
       QuestFrame:SetTitle(name..(name2 and ' - '..name2 or ''))
    end
end)



























--任务，目标
local function set_objectives(questID)
	questID= questID or e.Get_QuestID()
	if not questID then
		return
	end

	local numObjectives = GetNumQuestLeaderBoards() or 0
	local objective
	local text, type, finished
	local objectivesTable = QuestInfoObjectivesFrame.Objectives
	local numVisibleObjectives = 0

	local waypointText = C_QuestLog.GetNextWaypointText(questID)
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1
		objective = objectivesTable[numVisibleObjectives]
		if objective then
			objective:SetFormattedText('0/1 %s （可选）', e.cn(waypointText))
		end
	end
	
	for i = 1, numObjectives do
		text, type, finished = GetQuestLogLeaderBoard(i)
		if (type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
			numVisibleObjectives = numVisibleObjectives+1
			objective = objectivesTable[numVisibleObjectives]
			if objective then
				local name
				if ( not text or strlen(text) == 0 ) then
					name= e.cn(type)
					text= type
				else
					local new= e.Get_Quest_Object(questID, i)--无法找到
					if new then
						name= text:gsub('%d+/%d+ (.+)', new)
					end
					name= name or e.cn(text)
				end
				if ( finished ) then
					name = name.." （完成）"
				end
				if text~=name then
					objective:SetText(name)
				end
				--GetQuestLogItemLink(type, index)
			end
		end
	end
end
















local function set_quest_item(questID)
	local rewardsFrame = QuestInfoFrame.rewardsFrame
	questID= questID or e.Get_QuestID()
	if not rewardsFrame:IsShown() or not questID then
		return
	end

	local skillName
	local skillPoints

	if ( QuestInfoFrame.questLog ) then
		if C_QuestLog.ShouldShowQuestRewards(questID) then
			skillName, _, skillPoints = GetQuestLogRewardSkillPoints()
		end
	else
		if ( QuestFrameRewardPanel:IsShown() or C_QuestLog.ShouldShowQuestRewards(questID) ) then
			skillName, _, skillPoints = GetRewardSkillPoints()
		end
	end

	for frame in rewardsFrame.spellRewardPool:EnumerateActive() do
		local name= e.Get_Spell_Name(frame.rewardSpellID)
		if name then
			frame.Name:SetText(name)
		end
	end

	for frame in rewardsFrame.reputationRewardPool:EnumerateActive() do
		local name= e.strText[frame.factionName]
		if name then
			frame.Name:SetFormattedText('%s声望', name)
		end
	end

	skillName= skillName and e.strText[skillName]
	if skillName and skillPoints then
		rewardsFrame.SkillPointFrame.Name:SetFormattedText('%s技能', skillName)
		rewardsFrame.SkillPointFrame.tooltip = format('+%d %s技能点数', skillPoints, skillName)
	end

	for _, btn in pairs(rewardsFrame.RewardButtons) do
		if btn:IsShown() then
			local name
			if btn.type == "reward" and  btn.objectType == "questSessionBonusReward" then
				name= e.Get_Item_Name(171305)--一箱回收的物资
			elseif btn.objectType == 'currency' then
				name= btn.currencyInfo and e.strText[btn.currencyInfo.name]
			else
				local itemID
				if QuestInfoFrame.questLog then
					if btn.type=='choice'then
						itemID = select(6, GetQuestLogChoiceInfo(btn:GetID()))
					else
						itemID = select(6, GetQuestLogRewardInfo(btn:GetID()))
					end
				else
					itemID = select(6, GetQuestItemInfo(btn.type, btn:GetID()))
				end
				name= e.Get_Item_Name(itemID)
			end
			if name then
				btn.Name:SetText(name)
			end
		end
	end

	e.set(rewardsFrame.HonorFrame.Name)
	e.set(rewardsFrame.TitleFrame.Name)
end




















local function set_quest_info()
	local questID= e.Get_QuestID()
	if not questID then
		return
	end

    local data= e.Get_Quest_Info(questID)
	local title, object, desc

	if data then
		title= data["Title"]
		object= data["Objectives"]
		desc= data["Description"]
	end

    if title then
		if QuestInfoFrame.questLog and IsCurrentQuestFailed() then
			title = format('%s-(失败)', title)
		end
		QuestInfoTitleHeader:SetText(title)
    end

    if object then
       QuestInfoObjectivesText:SetText(object)
    end

	set_objectives(questID)

    if desc then
       QuestInfoDescriptionText:SetText(desc)
    end

	set_quest_item(questID)
end


hooksecurefunc('QuestInfo_ShowRewards', set_quest_info)
hooksecurefunc('QuestInfo_Display', set_quest_info)
















































hooksecurefunc('QuestInfo_ShowTitle', function()
	local title= e.Get_Quest_Info(e.Get_QuestID(), true, false, false)
	if not title then
	   return
	end
	 if QuestInfoFrame.questLog and IsCurrentQuestFailed() then
		 title = format('%s-(|cnRED_FONT_COLOR:失败|r)', title)
	 end
	 QuestInfoTitleHeader:SetText(title)
 end)



 hooksecurefunc('QuestInfo_ShowDescriptionText', function()
	local desc=  e.Get_Quest_Info(e.Get_QuestID(), false, false, true)
	if desc then
	   QuestInfoDescriptionText:SetText(desc)
	end
 end)

 hooksecurefunc('QuestInfoTimerFrame_OnUpdate', function(self, elapsed)
	 if self.timeLeft then
		 self.timeLeft = max(self.timeLeft - elapsed, 0)
		 QuestInfoTimerText:SetText("剩余时间："..SecondsToTime(self.timeLeft))
	 end
 end)


 hooksecurefunc('QuestInfo_ShowObjectives', function()
	 set_objectives()
 end)


 hooksecurefunc('QuestInfo_ShowSpecialObjectives', function()
	if not QuestInfoSpellObjectiveFrame:IsShown() then
	   return
	end
	local spellID, finished, spellName
	if ( QuestInfoFrame.questLog) then
	   spellID, spellName, _, finished = GetQuestLogCriteriaSpell()
	else
	   spellID, spellName, _, finished = GetCriteriaSpell()
	end
	if not spellID then
	   return
	end
	spellName = e.strText[spellName] or e.Get_Spell_Name(spellID)
	if spellName then
	   QuestInfoSpellObjectiveFrame.Name:SetText(spellName)
	end

	if (finished and QuestInfoFrame.questLog) then -- don't show as completed for the initial offer, as it won't update properly
	   QuestInfoSpellObjectiveLearnLabel:SetText("学习法术：(完成)")
	else
	   QuestInfoSpellObjectiveLearnLabel:SetText('学习法术：')
	end
 end)


 hooksecurefunc('QuestInfo_ShowTimer', function()
	 local timeLeft= QuestInfoTimerFrame.timeLeft
	 if timeLeft then
		 QuestInfoTimerText:SetText("剩余时间："..SecondsToTime(timeLeft))
	 end
 end)


 hooksecurefunc('QuestInfo_ShowGroupSize', function()
	if not QuestInfoGroupSize:IsShown() then
	   return
	end
	local groupNum
	 if QuestInfoFrame.questLog then
		 groupNum = C_QuestLog.GetSuggestedGroupSize(C_QuestLog.GetSelectedQuest())
	 else
		 groupNum = GetSuggestedGroupSize()
	 end
	 if groupNum and groupNum > 0 then
		 QuestInfoGroupSize:SetFormattedText('建议玩家人数：[%d]', groupNum)
	 end
 end)


