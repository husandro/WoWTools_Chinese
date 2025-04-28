

WoWTools_ChineseMixin:SetLabel(QuestFrameAcceptButton)--:SetText('接受')
WoWTools_ChineseMixin:SetLabel(QuestFrameGreetingGoodbyeButton)--:SetText('再见')
WoWTools_ChineseMixin:SetLabel(QuestFrameCompleteQuestButton)--:SetText('完成任务')
WoWTools_ChineseMixin:SetLabel(QuestFrameCompleteButton)--:SetText('继续')
WoWTools_ChineseMixin:SetLabel(QuestFrameGoodbyeButton)--:SetText('再见')
WoWTools_ChineseMixin:SetLabel(QuestFrameDeclineButton)--:SetText('拒绝')
WoWTools_ChineseMixin:SetLabel(QuestLogPopupDetailFrameAbandonButton)--:SetText('放弃')
WoWTools_ChineseMixin:SetLabel(QuestLogPopupDetailFrameShareButton)--:SetText('共享')
WoWTools_ChineseMixin:SetLabel(QuestLogPopupDetailFrame.ShowMapButton.Text)--:SetText('显示地图')

WoWTools_ChineseMixin:SetLabel(QuestMapFrame.DetailsFrame.BackButton)--:SetText('返回')
WoWTools_ChineseMixin:SetLabel(QuestMapFrame.DetailsFrame.AbandonButton)--:SetText('放弃')]]
QuestMapFrame.DetailsFrame.ShareButton:SetText('共享')
QuestMapFrame.DetailsFrame.DestinationMapButton.tooltipText= '显示最终目的地'
QuestMapFrame.DetailsFrame.WaypointMapButton.tooltipText= '显示旅行路径'

WoWTools_ChineseMixin:SetRegions(QuestMapFrame.DetailsFrame.RewardsFrame)--, '奖励')
WoWTools_ChineseMixin:SetRegions(MapQuestInfoRewardsFrame, false, true)
WoWTools_ChineseMixin:SetRegions(QuestInfoRewardsFrame, false, true)
WoWTools_ChineseMixin:HookLabel(QuestInfoObjectivesHeader)
WoWTools_ChineseMixin:HookLabel(QuestInfoDescriptionHeader)

WoWTools_ChineseMixin:SetLabel(QuestInfoXPFrame.ReceiveText)
WoWTools_ChineseMixin:HookLabel(QuestInfoAccountCompletedNotice)




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
    local name, name2= WoWTools_ChineseMixin:GetUnitName('questnpc', nil, true)
    if name then
       QuestFrame:SetTitle(name..(name2 and ' - '..name2 or ''))
    end
end)



























--任务，目标
local function set_objectives(questID)
	questID= questID or WoWTools_ChineseMixin:GetQuestID()
	
	if not questID then
		return
	end

	local numObjectives = GetNumQuestLeaderBoards() or 0
	local objective
	local desc, obType, finished
	local objectivesTable = QuestInfoObjectivesFrame.Objectives
	local numVisibleObjectives = 0

	local waypointText = C_QuestLog.GetNextWaypointText(questID)
	if waypointText then
		numVisibleObjectives = numVisibleObjectives + 1
		objective = objectivesTable[numVisibleObjectives]
		if objective then
			local cn=  WoWTools_ChineseMixin:SetText(waypointText)
			if not cn then
				local mapID= C_QuestLog.GetNextWaypoint(questID)
				local mapInfo= C_Map.GetMapInfo(mapID)
				cn= WoWTools_ChineseMixin:CN(mapInfo and mapInfo.name)
				if cn then
					cn= '前往|A:common-icon-rotateright:0:0|a'..cn..'|A:common-icon-rotateleft:0:0|a'
				end
			end

			objective:SetFormattedText('0/1 %s （可选）', cn or waypointText)
		end
	end
	
	for i = 1, numObjectives do
		desc, obType, finished = GetQuestLogLeaderBoard(i)
		if (obType ~= "spell" and obType ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
			numVisibleObjectives = numVisibleObjectives+1
			objective = objectivesTable[numVisibleObjectives]
			if objective then
				local name
				if ( not desc or strlen(desc) == 0 ) then
					name= WoWTools_ChineseMixin:SetText(obType) or obType
					desc= obType
				else
					--[[local new= WoWTools_ChineseMixin:GetQuestIndexObject(questID, i)--无法找到
					if new then
						name= desc:gsub('%d+/%d+ (.+)', new)
					end]]
					name= name or WoWTools_ChineseMixin:SetText(desc) or desc
				end
				if ( finished ) then
					name = name.." （完成）"
				end
				if desc~=name then
					objective:SetText(name)
				end
			end
		end
	end
end
















local function set_quest_item(questID)
	local rewardsFrame = QuestInfoFrame.rewardsFrame
	questID= questID or WoWTools_ChineseMixin:GetQuestID()
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
		local name= WoWTools_ChineseMixin:GetSpellName(frame.rewardSpellID)
		if name then
			frame.Name:SetText(name)
		end
	end

	for frame in rewardsFrame.reputationRewardPool:EnumerateActive() do
		local name= WoWTools_ChineseMixin:SetText(frame.factionName)
		if name then
			frame.Name:SetFormattedText('%s声望', name)
		end
	end

	skillName= skillName and WoWTools_ChineseMixin:SetText(skillName)
	if skillName and skillPoints then
		rewardsFrame.SkillPointFrame.Name:SetFormattedText('%s技能', skillName)
		rewardsFrame.SkillPointFrame.tooltip = format('+%d %s技能点数', skillPoints, skillName)
	end

	for _, btn in pairs(rewardsFrame.RewardButtons) do
		if btn:IsShown() then
			local name
			if btn.type == "reward" and  btn.objectType == "questSessionBonusReward" then
				name= WoWTools_ChineseMixin:GetItemName(171305)--一箱回收的物资
			elseif btn.objectType == 'currency' then
				name= btn.currencyInfo and WoWTools_ChineseMixin:SetText(btn.currencyInfo.name)
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
				name= WoWTools_ChineseMixin:GetItemName(itemID)
			end
			if name then
				btn.Name:SetText(name)
			end
		end
	end

	WoWTools_ChineseMixin:SetLabel(rewardsFrame.HonorFrame.Name)
	WoWTools_ChineseMixin:SetLabel(rewardsFrame.TitleFrame.Name)
end




















local function set_quest_info()
	local questID= WoWTools_ChineseMixin:GetQuestID()
	if not questID then
		return
	end

    local data= WoWTools_ChineseMixin:GetQuestData(questID)
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
	local title= WoWTools_ChineseMixin:GetQuestName(WoWTools_ChineseMixin:GetQuestID())
	if not title then
	   return
	end
	 if QuestInfoFrame.questLog and IsCurrentQuestFailed() then
		 title = format('%s-(|cnRED_FONT_COLOR:失败|r)', title)
	 end
	 QuestInfoTitleHeader:SetText(title)
 end)



 hooksecurefunc('QuestInfo_ShowDescriptionText', function()
	local desc=  WoWTools_ChineseMixin:GetQuestDesc(WoWTools_ChineseMixin:GetQuestID())
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
	spellName = WoWTools_ChineseMixin:CN(spellName) or WoWTools_ChineseMixin:GetSpellName(spellID)
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


