




--Constants.lua
-- LFG




WoWTools_ChineseMixin:HookLabel(GroupFinderFrameGroupButton1Name)--地下城查找器 GroupFinderFrame.groupButton1.name
WoWTools_ChineseMixin:HookLabel(GroupFinderFrameGroupButton2Name)--团队查找器 GroupFinderFrame.groupButton2.name
WoWTools_ChineseMixin:HookLabel(GroupFinderFrameGroupButton3Name)--预创建队伍 GroupFinderFrame.groupButton3.name



--LFD PVEFrame.lua
--地下城和团队副本




PVEFrameTab1:SetText('地下城和团队副本')
PVEFrameTab2:SetText('PvP')
PVEFrameTab3:SetText('史诗钥石地下城')
PVEFrameTab4:SetText('地下堡')

WoWTools_ChineseMixin:SetLabel(LFDQueueFrameRandomScrollFrameChildFrameXPLabel)
hooksecurefunc('LFDQueueFrameFindGroupButton_Update', function()--LFDFrame.lua
    local mode = GetLFGMode(LE_LFG_CATEGORY_LFD)
    if ( mode == "queued" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
        LFDQueueFrameFindGroupButton:SetText('离开队列')
    else
        if ( IsInGroup() and GetNumGroupMembers() > 1 ) then
            LFDQueueFrameFindGroupButton:SetText('小队加入')
        else
            LFDQueueFrameFindGroupButton:SetText('寻找组队')
        end
    end
    if C_PlayerInfo.IsPlayerNPERestricted() then
        if not LFDQueueCheckRoleSelectionValid(LFGRole_GetChecked(LFDQueueFrameRoleButtonTank), LFGRole_GetChecked(LFDQueueFrameRoleButtonHealer), LFGRole_GetChecked(LFDQueueFrameRoleButtonDPS)) then
            -- the NPE restricted player needs to at least be a DPS role if nothing is selected
            LFDQueueFrameRoleButtonDPS.checkButton:SetChecked(true)
            LFDFrameRoleCheckButton_OnClick(LFDQueueFrameRoleButtonDPS.checkButton)
        end
    end
    if ( not LFDQueueCheckRoleSelectionValid( LFGRole_GetChecked(LFDQueueFrameRoleButtonTank),
                                                LFGRole_GetChecked(LFDQueueFrameRoleButtonHealer),
                                                LFGRole_GetChecked(LFDQueueFrameRoleButtonDPS)) ) then
        LFDQueueFrameFindGroupButton.tooltip = '该角色在某些地下城不可用。'
        return
    end
    if not ( LFD_IsEmpowered() and mode ~= "proposal" and mode ~= "listed"  ) and ( IsInGroup(LE_PARTY_CATEGORY_HOME) and not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) ) then
            LFDQueueFrameFindGroupButton.tooltip = '你现在不是队长'
    end
    local lfgListDisabled
    if ( C_LFGList.HasActiveEntryInfo() ) then
        lfgListDisabled = '你不能在你的队伍出现在预创建队伍列表中时那样做。'
    elseif(C_PartyInfo.IsCrossFactionParty()) then
        lfgListDisabled = '在跨阵营队伍中无法这么做。你可以参加非队列匹配模式的团队副本和地下城。'
    end
    if ( lfgListDisabled ) then
        LFDQueueFrameFindGroupButton.tooltip = lfgListDisabled
    end
end)

LFDRoleCheckPopupAcceptButton:SetText('接受')
LFDRoleCheckPopupDeclineButton:SetText('拒绝')
LFDRoleCheckPopup.Text:SetText('确定你的职责：')
hooksecurefunc('LFDRoleCheckPopup_UpdateAcceptButton', function()
    if not ( LFDPopupCheckRoleSelectionValid( LFGRole_GetChecked(LFDRoleCheckPopupRoleButtonTank),
                                        LFGRole_GetChecked(LFDRoleCheckPopupRoleButtonHealer),
                                        LFGRole_GetChecked(LFDRoleCheckPopupRoleButtonDPS)) ) then
        LFDRoleCheckPopupAcceptButton.tooltipText = '该角色在某些地下城不可用。'
    end
end)

hooksecurefunc('LFDRoleCheckPopup_Update', function()
    local slots, bgQueue = GetLFGRoleUpdate()
    local isLFGList, activityID = C_LFGList.GetRoleCheckInfo()
    local displayName
    if( isLFGList ) then
        displayName = C_LFGList.GetActivityFullName(activityID)
    elseif ( bgQueue ) then
        displayName = GetLFGRoleUpdateBattlegroundInfo()
    elseif ( slots == 1 ) then
        local dungeonID, _, dungeonSubType = GetLFGRoleUpdateSlot(1)
        if ( dungeonSubType == LFG_SUBTYPEID_HEROIC ) then
            displayName = format('英雄难度：%s', select(LFG_RETURN_VALUES.name, GetLFGDungeonInfo(dungeonID)))
        else
            displayName = select(LFG_RETURN_VALUES.name, GetLFGDungeonInfo(dungeonID))
        end
    else
        displayName = '多个地下城'
    end
    displayName = displayName and NORMAL_FONT_COLOR:WrapTextInColorCode(displayName) or ""

    if ( isLFGList ) then
        LFDRoleCheckPopupDescriptionText:SetFormattedText('申请加入%s', displayName)
    else
        LFDRoleCheckPopupDescriptionText:SetFormattedText('在等待%s的队列中', displayName)
    end

    local maxLevel, isLevelReduced = C_LFGInfo.GetRoleCheckDifficultyDetails()
    if isLevelReduced then
        local canDisplayLevel = maxLevel and maxLevel < UnitEffectiveLevel("player")
        if canDisplayLevel then
            LFDRoleCheckPopupDescription.SubText:SetFormattedText(bgQueue and '等级和技能限制为小队的最低等级范围（%s）。' or '等级和技能限制为地下城的最高等级（%s）。', maxLevel)
        else
            LFDRoleCheckPopupDescription.SubText:SetText('进入战场时，等级和技能可能会受到限制。')
        end
    end
end)


LFDParentFrame:HookScript('OnEvent', function(_, event, ...)
    if ( event == "LFG_ROLE_CHECK_SHOW" ) then
        local requeue = ...
        LFDRoleCheckPopup.Text:SetText(requeue and '你的队友已经将你加入另一场练习赛的队列。\n\n请确认你的角色：' or '确定你的职责：')
    elseif ( event == "LFG_READY_CHECK_SHOW" ) then
        local _, readyCheckBgQueue = GetLFGReadyCheckUpdate()
        local displayName
        if ( readyCheckBgQueue ) then
            displayName = GetLFGReadyCheckUpdateBattlegroundInfo()
        else
            displayName = '未知'
        end
        LFDReadyCheckPopup.Text:SetFormattedText('你的队长将你加入|cnGREEN_FONT_COLOR:%s|r的队列。准备好了吗？', displayName)
    end
end)

hooksecurefunc('LFDQueueFrameRandomCooldownFrame_Update', function()--LFDFrame.lua
    local cooldownFrame = LFDQueueFrameCooldownFrame
    local hasDeserter = false --If we have deserter, we want to show this over the specific frame as well as the random frame.

    local deserterExpiration = GetLFGDeserterExpiration()

    local myExpireTime
    if ( deserterExpiration ) then
        myExpireTime = deserterExpiration
        hasDeserter = true
    else
        myExpireTime = GetLFGRandomCooldownExpiration()
    end


    for i = 1, GetNumSubgroupMembers() do
        --local nameLabel = _G["LFDQueueFrameCooldownFrameName"..i]
        local statusLabel = _G["LFDQueueFrameCooldownFrameStatus"..i]

        --local _, classFilename = UnitClass("party"..i)
        --local classColor = classFilename and RAID_CLASS_COLORS[classFilename] or NORMAL_FONT_COLOR
        --nameLabel:SetFormattedText("|cff%.2x%.2x%.2x%s|r", classColor.r * 255, classColor.g * 255, classColor.b * 255, GetUnitName("party"..i, true))

        if ( UnitHasLFGDeserter("party"..i) ) then
            statusLabel:SetFormattedText(RED_FONT_COLOR_CODE.."%s|r", '逃亡者')
            hasDeserter = true
        elseif ( UnitHasLFGRandomCooldown("party"..i) ) then
            statusLabel:SetFormattedText(RED_FONT_COLOR_CODE.."%s|r", '冷却中')
        else
            statusLabel:SetFormattedText(GREEN_FONT_COLOR_CODE.."%s|r", '就绪')
        end
    end
    if ( myExpireTime and GetTime() < myExpireTime ) then
        if ( deserterExpiration ) then
            cooldownFrame.description:SetText('你刚刚逃离了随机队伍，在接下来的时间内无法再度排队：')
        else
            cooldownFrame.description:SetText('你近期加入过一个随机地下城队列。\n需要过一段时间才可加入另一个，等待时间为：')
        end
    else
        if ( hasDeserter ) then
            cooldownFrame.description:SetText('你的一名队伍成员刚刚逃离了随机副本队伍，在接下来的时间内无法再度排队。')
        else
            cooldownFrame.description:SetText('的一名队友近期加入过一个随机地下城队列，暂时无法加入另一个。')
        end
    end

end)

--LFGList.lua


hooksecurefunc('LFGDungeonReadyDialog_UpdateInstanceInfo', function(name, completedEncounters, totalEncounters)
    WoWTools_ChineseMixin:SetLabel(LFGDungeonReadyDialogInstanceInfoFrame.name, name)
    if ( totalEncounters > 0 ) then
        LFGDungeonReadyDialogInstanceInfoFrame.statusText:SetFormattedText('已消灭|cnGREEN_FONT_COLOR:%d/%d|r个首领', completedEncounters, totalEncounters)
    end
end)
LFGDungeonReadyDialogInstanceInfoFrame:HookScript('OnEnter', function()--LFGDungeonReadyDialogInstanceInfo_OnEnter
    local numBosses = select(9, GetLFGProposal())
    local isHoliday = select(13, GetLFGProposal())
    if ( numBosses == 0 or isHoliday) then
        return
    end
    GameTooltip:SetText('首领：')
    for i=1, numBosses do
        local bossName, _, isKilled = GetLFGProposalEncounter(i)
        if ( isKilled ) then
            GameTooltip:AddDoubleLine('|A:common-icon-redx:0:0|a'.. WoWTools_ChineseMixin:GetData(bossName), '|cnRED_FONT_COLOR:已消灭')
        else
            GameTooltip:AddDoubleLine(format('|A:%s:0:0|a', e.Icon.select)..WoWTools_ChineseMixin:GetData(bossName), '|cnGREEN_FONT_COLOR:可消灭')
        end
    end
    GameTooltip:Show()
end)
hooksecurefunc('LFGDungeonReadyPopup_Update', function()--LFGFrame.lua
    local proposalExists, _, typeID, subtypeID, _, _, role, hasResponded, _, _, numMembers, _, _, _, isSilent = GetLFGProposal()
    if ( not proposalExists ) then
        return
    elseif ( isSilent ) then
        return
    end

    if ( role == "NONE" ) then
        role = "DAMAGER"
    end

    local leaveText = '离开队列'
    if ( subtypeID == LFG_SUBTYPEID_RAID or subtypeID == LFG_SUBTYPEID_FLEXRAID ) then
        LFGDungeonReadyDialog.enterButton:SetText('进入')
    elseif ( subtypeID == LFG_SUBTYPEID_SCENARIO ) then
        if ( numMembers > 1 ) then
            LFGDungeonReadyDialog.enterButton:SetText('进入')
        else
            LFGDungeonReadyDialog.enterButton:SetText('接受')
            leaveText = '取消'
        end
    else
        LFGDungeonReadyDialog.enterButton:SetText('进入')
    end
    LFGDungeonReadyDialog.leaveButton:SetText(leaveText)

    if not hasResponded then
        local LFGDungeonReadyDialog = LFGDungeonReadyDialog
        if ( typeID == TYPEID_RANDOM_DUNGEON and subtypeID ~= LFG_SUBTYPEID_SCENARIO ) then
            LFGDungeonReadyDialog.label:SetText('你的随机地下城小队已经整装待发！')
        else
                if ( numMembers > 1 ) then
                LFGDungeonReadyDialog.label:SetText( '已经建好了一个队伍，准备前往：')
            else
                LFGDungeonReadyDialog.label:SetText('已经建好了一个副本，准备前往：')
            end
        end
        role= _G[role]
        if subtypeID ~= LFG_SUBTYPEID_SCENARIO and subtypeID ~= LFG_SUBTYPEID_FLEXRAID then
            WoWTools_ChineseMixin:SetLabel(LFGDungeonReadyDialogRoleLabel, role)
        end
    end
end)
LFGDungeonReadyDialogYourRoleDescription:SetText('你的职责')
LFGDungeonReadyDialogRoleLabel:SetText('治疗者')
LFGDungeonReadyDialogRewardsFrameLabel:SetText('奖励')
LFGDungeonReadyStatusLabel:SetText('就位确认')

LFGDungeonReadyDialogRandomInProgressFrameStatusText:SetText('该地下城正在进行中。')
RaidFinderQueueFrameScrollFrameChildFrameRewardsLabel:SetText('奖励')
LFDQueueFrameRandomScrollFrameChildFrameRewardsLabel:SetText('奖励')

RaidFinderQueueFrameScrollFrameChildFrameEncounterList:HookScript('OnEnter', function(self)
    if self.dungeonID then
        local numEncounters, numCompleted = GetLFGDungeonNumEncounters(self.dungeonID)
        if ( numCompleted > 0 ) then
            GameTooltip:AddLine(' ')
            GameTooltip:AddLine(format('|cnHIGHLIGHT_FONT_COLOR:物品已经被拾取（%d/%d）', numCompleted, numEncounters))
            GameTooltip:Show()
        end
    end
end)





hooksecurefunc('LFGInvitePopup_Update', function(inviter, _, _, _, _, isQuestSessionActive)
    local titleMarkup = isQuestSessionActive and CreateAtlasMarkup("QuestSharing-QuestLog-Replay", 19, 16) or ""
    local playerName= e.GetPlayerInfo({name=inviter, reName=true, reRealm=true})
    playerName= playerName=='' and inviter or playerName
    LFGInvitePopupText:SetFormattedText(titleMarkup ..'%s邀请你加入队伍', inviter)
    local tankButton = LFGInvitePopupRoleButtonTank
    if tankButton.disabledTooltip and WoWTools_ChineseMixin:CN(tankButton.disabledTooltip) then
        tankButton.disabledTooltip = WoWTools_ChineseMixin:CN(tankButton.disabledTooltip)
    end

    local text
    if WillAcceptInviteRemoveQueues() then
        text= '加入该队伍会将你从激活的队列中移除。'
    end
    if isQuestSessionActive then
        text= (text and text..'|n|n' or '')..'接受此邀请会激活小队同步。任务会与小队进行同步。'
    end
    if text then
        LFGInvitePopup.QueueWarningText:SetText(text)
    end
end)


C_Timer.After(2, function()
    WoWTools_ChineseMixin:HookLabel(RaidFinderQueueFrameSelectionDropDownName)
    WoWTools_ChineseMixin:HookLabel(LFGListFrame.ApplicationViewer.DescriptionFrame.Text)
end)

























--RaidFinder.lua
hooksecurefunc('RaidFinderFrame_UpdateAvailability', function()
    if not RaidFinderFrame.NoRaidsCover:IsShown() then
        return
    end

	local nextLevel = nil;
	local level = UnitLevel("player");
	for i=1, GetNumRFDungeons() do
		local _, _, _, _, minLevel, maxLevel = GetRFDungeonInfo(i);
		if ( level >= minLevel and level <= maxLevel ) then
			nextLevel = nil;
			break;
		elseif ( level < minLevel and (not nextLevel or minLevel < nextLevel ) ) then
			nextLevel = minLevel;
		end
	end

    if ( nextLevel ) then
        RaidFinderFrame.NoRaidsCover.Label:SetFormattedText('没有符合你当前等级的团队副本可用。下一个团队副本可在%d级时进入。', nextLevel);
    else
        RaidFinderFrame.NoRaidsCover.Label:SetText('没有符合你当前等级的团队副本可用。');
    end

end)



hooksecurefunc('RaidFinderQueueFrameIneligibleFrame_UpdateFrame', function(self)
    if ( self.queueRestriction ) then
		if ( self.queueRestriction == "lfd" ) then
			self.description:SetText('你无法在排队加入随机地下城时排队加入随机团队副本的队列。');
			self.leaveQueueButton:SetText('离开队列');
		else
			self.description:SetText('处于其他团队列表时无法加入团队副本队列。');
			if ( IsInGroup() ) then
				self.leaveQueueButton:SetText('不列出我的队伍');
			else
				self.leaveQueueButton:SetText('不列出我的名字');
			end
		end
	elseif ( self.ineligibleGroup ) then
		self.description:SetText('你的队伍不能通过团队查找器加入任何随机团队副本。');
		self.leaveQueueButton:Hide();
		self:Show();
		return true;
	elseif ( self.ineligiblePlayer ) then
		self.description:SetText('你不能通过团队查找器排队加入任何随机团队副本。');
	end
end)