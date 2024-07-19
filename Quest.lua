local e= select(2, ...)

QuestFrameAcceptButton:SetText('接受')
QuestFrameGreetingGoodbyeButton:SetText('再见')
QuestFrameCompleteQuestButton:SetText('完成任务')
QuestFrameCompleteButton:SetText('继续')
QuestFrameGoodbyeButton:SetText('再见')
QuestFrameDeclineButton:SetText('拒绝')
QuestLogPopupDetailFrameAbandonButton:SetText('放弃')
QuestLogPopupDetailFrameShareButton:SetText('共享')
QuestLogPopupDetailFrame.ShowMapButton.Text:SetText('显示地图')

e.hookLabel(QuestInfoObjectivesHeader)
e.hookLabel(QuestInfoRewardsFrame.Header)
e.hookLabel(QuestInfoRewardsFrame.ItemReceiveText)

e.set(QuestMapFrame.DetailsFrame.BackButton)--:SetText('返回')
e.set(QuestMapFrame.DetailsFrame.AbandonButton)--:SetText('放弃')]]

QuestMapFrame.DetailsFrame.ShareButton:SetText('共享')
QuestMapFrame.DetailsFrame.DestinationMapButton.tooltipText= '显示最终目的地'
QuestMapFrame.DetailsFrame.WaypointMapButton.tooltipText= '显示旅行路径'

e.region(QuestMapFrame.DetailsFrame.RewardsFrame)--, '奖励')
e.hookLabel(MapQuestInfoRewardsFrame.ItemChooseText)--:SetText('你可以从这些奖励品中选择一件：')
MapQuestInfoRewardsFrame.PlayerTitleText:SetText('新头衔： %s')
e.hookLabel(MapQuestInfoRewardsFrame.QuestSessionBonusReward)--'在小队同步状态下完成此任务有可能获得奖励：')











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















local function set_quest_item()
	local rewardsFrame = QuestInfoFrame.rewardsFrame
	local questID= e.Get_QuestID()
	if not rewardsFrame:IsShown() or not questID then
		return
	end

	local skillName;
	local skillPoints;

	if ( QuestInfoFrame.questLog ) then
		if C_QuestLog.ShouldShowQuestRewards(questID) then
			skillName, _, skillPoints = GetQuestLogRewardSkillPoints()			
		end
	else
		if ( QuestFrameRewardPanel:IsShown() or C_QuestLog.ShouldShowQuestRewards(questID) ) then
			skillName, _, skillPoints = GetRewardSkillPoints();
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
		rewardsFrame.SkillPointFrame.Name:SetFormattedText('%s技能', skillName);
		rewardsFrame.SkillPointFrame.tooltip = format('+%d %s技能点数', skillPoints, skillName)
	end

	for _, btn in pairs(rewardsFrame.RewardButtons) do
		if btn:IsShown() then
			local name
			if btn.type == "reward" and  btn.objectType == "questSessionBonusReward" then
				name=  e.Get_Item_Name(171305)--一箱回收的物资
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
    local data= e.Get_Quest_Info(e.Get_QuestID())
    if not data then
       return
    end
    local title= data["Title"]
    if title and title~='' then
       QuestInfoTitleHeader:SetText(title)
    end
    local object= data["Objectives"]
    if object then
       QuestInfoObjectivesText:SetText(object)
    end
    local desc= data["Description"]
    if desc and desc~='' then
       QuestInfoDescriptionText:SetText(desc)
    end

	set_quest_item()
end












--QuestInfo






hooksecurefunc('QuestInfo_ShowRewards', set_quest_info)
hooksecurefunc('QuestInfo_Display', set_quest_info)