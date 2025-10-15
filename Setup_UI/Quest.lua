

function WoWTools_ChineseMixin.Frames:QuestMapFrame()
    

    self:SetLabel(QuestScrollFrame.SearchBox.Instructions)
    self:SetLabel(QuestScrollFrame.NoSearchResultsText)
    
    
    self:SetLabel(QuestMapFrame.MapLegend.TitleText)
    self:SetFrame(QuestInfoRewardsFrame)
	if QuestMapFrame.QuestsFrame then
		self:SetButton(QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.BackButton)
		self:SetLabel(QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice.Text)
		QuestMapFrame.QuestsFrame.DetailsFrame.BackFrame.AccountCompletedNotice.Text:SetTextColor(0,1,0)
		QuestMapFrame.QuestsFrame.DetailsFrame.AbandonButton:SetText('放弃')
	end

	if QuestMapFrame.DetailsFrame then
		self:SetButton(QuestMapFrame.DetailsFrame.ShareButton)--:SetText('共享')
		self:SetLabel(QuestMapFrame.DetailsFrame.BackFrame.BackButton)
		self:SetButton(QuestMapFrame.DetailsFrame.AbandonButton)--:SetText('放弃')
		self:HookButton(QuestMapFrame.DetailsFrame.TrackButton)
		self:SetFrame(QuestMapFrame.DetailsFrame.RewardsFrame)--, '奖励')
		self:SetLabel(QuestMapFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame.Label)
	end
    
    self:SetLabel(QuestInfoRequiredMoneyText)--:SetText('需要金钱：')

    self:HookButton(QuestLogPopupDetailFrame.TrackButton)

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















function WoWTools_ChineseMixin.Frames:QuestFrame()
	self:HookLabel(QuestFrame.AccountCompletedNotice.Text)
	self:SetLabel(QuestFrameAcceptButton)--:SetText('接受')
	self:SetLabel(QuestFrameGreetingGoodbyeButton)--:SetText('再见')
	self:SetLabel(QuestFrameCompleteQuestButton)--:SetText('完成任务')
	self:SetLabel(QuestFrameCompleteButton)--:SetText('继续')
	self:SetLabel(QuestFrameGoodbyeButton)--:SetText('再见')
	self:SetLabel(QuestFrameDeclineButton)--:SetText('拒绝')
	self:SetLabel(QuestLogPopupDetailFrameAbandonButton)--:SetText('放弃')
	self:SetLabel(QuestLogPopupDetailFrameShareButton)--:SetText('共享')
	self:SetLabel(QuestLogPopupDetailFrame.ShowMapButton.Text)--:SetText('显示地图')
	self:SetFrame(MapQuestInfoRewardsFrame, false, true)
	self:SetFrame(QuestInfoRewardsFrame, false, true)
	self:HookLabel(QuestInfoObjectivesHeader)
	self:HookLabel(QuestInfoDescriptionHeader)

	self:SetLabel(QuestInfoXPFrame.ReceiveText)
	self:HookLabel(QuestInfoAccountCompletedNotice)

	hooksecurefunc('QuestFrame_SetPortrait', function()
		local name= self:GetUnitName('questnpc') or self:CN(UnitName("questnpc"))
		if name then
			QuestFrame:SetTitle(name)
		end
	end)
	--[[QuestFrame:HookScript('OnShow', function(frame)
		if UnitExists('questnpc') then
			local name= self:GetUnitName('questnpc')
			if name then
				frame:SetTitle(name)
			end
		end
	end)]]

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
		spellName = self:GetSpellName(spellID) or self:CN(spellName)
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

	hooksecurefunc('QuestFrameProgressItems_Update', function()
		local data= self:GetQuestData(GetQuestID())
		if data then
			if data.T then
				QuestProgressTitleText:SetText(data.T..'|n'..GetTitleText())
			end
			if data.O then
				QuestProgressText:SetText(data.O..'|n'..GetProgressText())
			end
		end
	end)

end
















function WoWTools_ChineseMixin.Frames:GossipFrame()
	hooksecurefunc(GossipFrame, 'SetGossipTitle', function(frame, title)
		local name= WoWTools_ChineseMixin:GetUnitName("npc") or self:CN(title)
		if name then
			frame:SetTitle(name)
		end
	end)
	GossipFrame.GreetingPanel.GoodbyeButton:SetText('再见')
    --自定义，对话，文本
    if WoWTools_SC_Gossip and not WoWTools_GossipMixin then
        hooksecurefunc(GossipOptionButtonMixin, 'Setup', function(btn, info)
            if info and info.gossipOptionID then
                local text= WoWTools_SC_Gossip[info.gossipOptionID]
                if text then
                    btn:SetText(text)
                end
            end
        end)
    end

	
    --可接任务,多个任务GossipFrameShared.lua questInfo.questID, questInfo.title, questInfo.isIgnored, questInfo.isTrivial
    hooksecurefunc(GossipSharedAvailableQuestButtonMixin, 'Setup', function(btn, info)-- questID, titleText, isIgnored, isTrivial)
		local name= WoWTools_ChineseMixin:GetQuestName(info.questID) or self:SetText(info.title)
        if name then
			if info.isIgnored then
				btn:SetFormattedText('|cff000000%s（忽略）|r', name)
			elseif info.isTrivial then
				btn:SetFormattedText('|cff000000%s （低等级）|r', name)
			else
				btn:SetFormattedText('|cff000000%s|r', name)
			end
			btn:Resize()
		end
    end)

    --已激活任务,多个任务GossipFrameShared.lua
    hooksecurefunc(GossipSharedActiveQuestButtonMixin, 'Setup', function(btn, info)
        local name= WoWTools_ChineseMixin:GetQuestName(info.questID) or self:SetText(info.title)
        if name then
			if info.isIgnored then
				btn:SetFormattedText('|cff000000%s（忽略）|r', name)
			elseif info.isTrivial then
				btn:SetFormattedText('|cff000000%s （低等级）|r', name)
			else
				btn:SetFormattedText('|cff000000%s|r', name)
			end
			btn:Resize()
		end
    end)

end

