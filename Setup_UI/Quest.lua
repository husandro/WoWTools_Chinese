
function WoWTools_ChineseMixin.Frames:QuestFrame()
	--任务对话框
	GossipFrame.GreetingPanel.GoodbyeButton:SetText('再见')

	self:SetLabel(QuestFrameAcceptButton)--:SetText('接受')
	self:SetLabel(QuestFrameGreetingGoodbyeButton)--:SetText('再见')
	self:SetLabel(QuestFrameCompleteQuestButton)--:SetText('完成任务')
	self:SetLabel(QuestFrameCompleteButton)--:SetText('继续')
	self:SetLabel(QuestFrameGoodbyeButton)--:SetText('再见')
	self:SetLabel(QuestFrameDeclineButton)--:SetText('拒绝')
	self:SetLabel(QuestLogPopupDetailFrameAbandonButton)--:SetText('放弃')
	self:SetLabel(QuestLogPopupDetailFrameShareButton)--:SetText('共享')
	self:SetLabel(QuestLogPopupDetailFrame.ShowMapButton.Text)--:SetText('显示地图')
	self:SetRegions(MapQuestInfoRewardsFrame, false, true)
	self:SetRegions(QuestInfoRewardsFrame, false, true)
	self:HookLabel(QuestInfoObjectivesHeader)
	self:HookLabel(QuestInfoDescriptionHeader)

	self:SetLabel(QuestInfoXPFrame.ReceiveText)
	self:HookLabel(QuestInfoAccountCompletedNotice)

	QuestFrame:HookScript('OnShow', function()
		if not UnitExists('questnpc') then
		return
		end
		local name, name2= self:GetUnitName('questnpc', nil, true)
		if name then
		QuestFrame:SetTitle(name..(name2 and ' - '..name2 or ''))
		end
	end)

	--任务，目标 QuestInfo_ShowObjectives()
	local function set_objectives(questID, obs)
		local objectivesTable = QuestInfoObjectivesFrame.Objectives or {}
		local numObjectives = GetNumQuestLeaderBoards() or #objectivesTables
		local objective
		local desc, obType, finished
		local numVisibleObjectives = 0

		local waypointText = C_QuestLog.GetNextWaypointText(questID)
		if waypointText then
			numVisibleObjectives = numVisibleObjectives + 1
			objective = objectivesTable[numVisibleObjectives]

			if objective then
				local cn=  self:SetText(waypointText)
				if not cn then
					local mapID= C_QuestLog.GetNextWaypoint(questID)
					local mapInfo= C_Map.GetMapInfo(mapID) or {}
					cn= self:CN(mapInfo.name)
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
						name= self:SetText(obType) or obType
						desc= obType
					else
						local new= obs and obs[i]--无法找到
						if new then
							local num= desc:match('(%d+/%d+ )')
							local per= desc:match(' %((%d+%%)%)')
							if num then
								name= num..new
							elseif per then
								name= per..' '..new
							else
								name= desc..' '..new
							end
						end
						name= name or self:SetText(desc) or desc
					end
					if ( finished ) then
						name = name.."|cnGREEN_FONT_COLOR:（完成）"
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

		questID= questID or self:GetQuestID()

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
			local name= self:GetSpellName(frame.rewardSpellID)
			if name then
				frame.Name:SetText(name)
			end
		end

		for frame in rewardsFrame.reputationRewardPool:EnumerateActive() do
			local name= self:SetText(frame.factionName)
			if name then
				frame.Name:SetFormattedText('%s声望', name)
			end
		end

		skillName= skillName and self:SetText(skillName)
		if skillName and skillPoints then
			rewardsFrame.SkillPointFrame.Name:SetFormattedText('%s技能', skillName)
			rewardsFrame.SkillPointFrame.tooltip = format('+%d %s技能点数', skillPoints, skillName)
		end

		for _, btn in pairs(rewardsFrame.RewardButtons) do
			if btn:IsShown() then
				local name
				if btn.type == "reward" and  btn.objectType == "questSessionBonusReward" then
					name= self:GetItemName(171305)--一箱回收的物资
				elseif btn.objectType == 'currency' then
					name= btn.currencyInfo and self:SetText(btn.currencyInfo.name)
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
					name= self:GetItemName(itemID)
				end
				if name then
					btn.Name:SetText(name)
				end
			end
		end

		self:SetLabel(rewardsFrame.HonorFrame.Name)
		self:SetLabel(rewardsFrame.TitleFrame.Name)

		for header in rewardsFrame.spellHeaderPool:EnumerateActive() do
			self:SetLabel(header)
		end
	end




















	local function set_quest_info()
		local questID= self:GetQuestID()
		if not questID then
			return
		end
		local data= self:GetQuestData(questID)
		local title, objects, obj
		if data then
			title= data["T"]
			obj= data["O"]
			objects= data["S"]
		end

		if title then
			if QuestInfoFrame.questLog and IsCurrentQuestFailed() then
				title = format('%s-(失败)', title)
			end
			QuestInfoTitleHeader:SetText(title)
		end
		set_objectives(questID, objects)
		if obj then
			QuestInfoObjectivesText:SetText(obj)
		end
		set_quest_item(questID)
	end


	hooksecurefunc('QuestInfo_ShowRewards', function()
		set_quest_info()
	end)

	hooksecurefunc('QuestInfo_Display', function()
		set_quest_info()
	end)

	hooksecurefunc('QuestInfo_ShowTitle', function()
		local title= self:GetQuestName(self:GetQuestID())
		if not title then
		return
		end
		if QuestInfoFrame.questLog and IsCurrentQuestFailed() then
			title = format('%s-(|cnRED_FONT_COLOR:失败|r)', title)
		end
		QuestInfoTitleHeader:SetText(title)
	end)



	hooksecurefunc('QuestInfo_ShowDescriptionText', function()
		local questID= self:GetQuestID()
		local desc= select(2,self:GetQuestName(questID))
		if desc then
		QuestInfoDescriptionText:SetText(desc)
		end
	end)

	hooksecurefunc('QuestInfoTimerFrame_OnUpdate', function(frame, elapsed)
		if frame.timeLeft then
			frame.timeLeft = max(frame.timeLeft - elapsed, 0)
			QuestInfoTimerText:SetText("剩余时间："..SecondsToTime(frame.timeLeft))
		end
	end)


	hooksecurefunc('QuestInfo_ShowObjectives', function()
		local questID= self:GetQuestID()
		if questID then
			local data= questID and self:GetQuestData(questID)
			set_objectives(questID, data and data.S)
		end
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
		spellName = self:CN(spellName) or self:GetSpellName(spellID)
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
end











 
