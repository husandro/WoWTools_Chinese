local e= select(2, ...)




--Constants.lua
-- LFG


for index, name in pairs(LFG_CATEGORY_NAMES) do
    local cnName= e.strText[name]
    if cnName then
        LFG_CATEGORY_NAMES[index]= cnName        
    end
end













--LFD PVEFrame.lua
--地下城和团队副本
GroupFinderFrame:HookScript('OnShow', function()
    PVEFrame:SetTitle('地下城和团队副本')
end)



--[[GroupFinderFrameGroupButton1Name:SetText('地下城查找器')
--GroupFinderFrameGroupButton2Name:SetText('团队查找器')
--GroupFinderFrameGroupButton3Name:SetText('预创建队伍')
e.hookButton(GroupFinderFrameGroupButton1)
e.hookButton(GroupFinderFrameGroupButton2)
e.hookButton(GroupFinderFrameGroupButton3)

e.hookLabel(RaidFinderQueueFrameScrollFrameChildFrameTitle)
e.hookLabel(RaidFinderQueueFrameScrollFrameChildFrameDescription)]]

PVEFrameTab1:SetText('地下城和团队副本')
PVEFrameTab2:SetText('PvP')
PVEFrameTab3:SetText('史诗钥石地下城')

GroupFinderFrame.groupButton1.name:SetText('地下城查找器')
    e.set(LFDQueueFrameTypeDropdownName)
    e.set(RaidFinderQueueFrameSelectionDropdownName)

    GroupFinderFrame.groupButton2.name:SetText('团队查找器')
        hooksecurefunc('RaidFinderFrameFindRaidButton_Update', function()--RaidFinder.lua
            local mode = GetLFGMode(LE_LFG_CATEGORY_RF, RaidFinderQueueFrame.raid)
            --Update the text on the button
            if ( mode == "queued" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
                RaidFinderFrameFindRaidButton:SetText('离开队列')--LEAVE_QUEUE
            else
                if ( IsInGroup() and GetNumGroupMembers() > 1 ) then
                    RaidFinderFrameFindRaidButton:SetText('小队加入')--:SetText(JOIN_AS_PARTY)
                else
                    RaidFinderFrameFindRaidButton:SetText('寻找组队')--:SetText(FIND_A_GROUP)
                end
            end
        end)

    GroupFinderFrame.groupButton3.name:SetText('预创建队伍')
    LFGListFrame.CategorySelection.Label:SetText('预创建队伍')
    hooksecurefunc('LFGListCategorySelection_AddButton', function(self, btnIndex, categoryID, filters)--LFGList.lua
        local baseFilters = self:GetParent().baseFilters
        local allFilters = bit.bor(baseFilters, filters)
        if ( filters ~= 0 and #C_LFGList.GetAvailableActivities(categoryID, nil, allFilters) == 0) then
            return
        end
        local categoryInfo = C_LFGList.GetLfgCategoryInfo(categoryID)
        local text=LFGListUtil_GetDecoratedCategoryName(e.cn(categoryInfo.name), filters, true)
        local btn= self.CategoryButtons[btnIndex]
        if text and btn then
            e.font(btn:GetFontString())
            local name= text:match('%- (.+)')
            local cnName= name and e.strText[name]
            if cnName then
                text= text:gsub(name, cnName)
            end
            btn:SetText(text)
        end
    end)
    LFGListFrame.CategorySelection.StartGroupButton:SetText('创建队伍')
    LFGListFrame.CategorySelection.FindGroupButton:SetText('寻找队伍')
    LFGListFrame.CategorySelection.Label:SetText('预创建队伍')
        LFGListFrame.EntryCreation.NameLabel:SetText('名称')
        LFGListFrame.EntryCreation.DescriptionLabel:SetText('详细信息')

        LFGListFrame.EntryCreation.PlayStyleLabel:SetText('目标')
        LFGListFrame.EntryCreation.MythicPlusRating.Label:SetText('最低史诗钥石评分')
        LFGListFrame.EntryCreation.ItemLevel.Label:SetText('最低物品等级')
        LFGListFrame.EntryCreation.PvpItemLevel.Label:SetText('最低PvP物品等级')
        LFGListFrame.EntryCreation.VoiceChat.Label:SetText('语音聊天')

        LFGListFrame.EntryCreation.PrivateGroup.Label:SetText('个人')
        LFGListFrame.EntryCreation.PrivateGroup.tooltip= '仅对已在队伍中的好友和公会成员可见。'

        LFGListFrame.ApplicationViewer.NameColumnHeader.Label:SetText('名称', nil, true)
        LFGListFrame.ApplicationViewer.RoleColumnHeader.Label:SetText('职责', nil, true)
        LFGListFrame.ApplicationViewer.ItemLevelColumnHeader.Label:SetText('装等', nil, true)
        LFGApplicationViewerRatingColumnHeader.Label:SetText('分数', nil, true)
LFGListApplicationDialog.Label:SetText('选择你的角色')
LFGListApplicationDialogDescription.EditBox.Instructions:SetText('给队长留言（可选）')
LFGListApplicationDialog.SignUpButton:SetText('申请')
LFGListApplicationDialog.CancelButton:SetText('取消')
local function GetFindGroupRestriction()
    if ( C_SocialRestrictions.IsSilenced() ) then
        return "SILENCED", RED_FONT_COLOR:WrapTextInColorCode('帐号禁言期间不能这样做')
    elseif ( C_SocialRestrictions.IsSquelched() ) then
        return "SQUELCHED", RED_FONT_COLOR:WrapTextInColorCode('我们已经暂时禁止了你的聊天和邮件权限。请参考您的邮件以获得更详细的信息。')
    end
    return nil, nil
end
local function GetStartGroupRestriction()
    return GetFindGroupRestriction()
end
local function LFGListUtil_GetActiveQueueMessage(isApplication)--LFGList.lua
    if ( not isApplication and select(2,C_LFGList.GetNumApplications()) > 0 ) then
        return '你不能在拥有有效的预创建队伍申请时那样做。'
    end
    if ( isApplication and C_LFGList.HasActiveEntryInfo() ) then
        return '你不能在你的队伍出现在预创建队伍列表中时那样做。'
    end
    for category=1, NUM_LE_LFG_CATEGORYS do
        local mode = GetLFGMode(category)
        if ( mode ) then
            if ( mode == "lfgparty" ) then
                return '你不能在自动匹配队伍中那样做。'
            elseif ( mode == "rolecheck" or (mode and not isApplication) ) then
                return '你不能在地下城、团队副本或场景战役队列中那样做。'
            end
        end
    end
    local inProgress, _, _, _, _, isBattleground = GetLFGRoleUpdate()
    if ( inProgress ) then
        return isBattleground and '你不能在战场或竞技场队列中那样做。' or '你不能在地下城、团队副本或场景战役队列中那样做。'
    end
    for i=1, GetMaxBattlefieldID() do
        local status, _, _, _, _, _, _, _, _, _, _, isSoloQueue = GetBattlefieldStatus(i)
        if ( status and status ~= "none" ) then
            if not isSoloQueue or status == "active" then
                return '你不能在战场或竞技场队列中那样做，也不能在进入战场或竞技场后那样做。'
            end
        end
    end
end
hooksecurefunc('LFGListCategorySelection_UpdateNavButtons', function(self)--LFGList.lua
    if ( not self.selectedCategory ) then
        self.FindGroupButton.tooltip = '做出选择。'
        self.StartGroupButton.tooltip = '做出选择。'
    end
    if ( IsInGroup(LE_PARTY_CATEGORY_HOME) and not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) ) then
        self.StartGroupButton.tooltip = '只有队长才能这么做。'
    end
    local messageStart = LFGListUtil_GetActiveQueueMessage(false)
    if ( messageStart ) then
        self.StartGroupButton.tooltip = messageStart
    end
    local findError, findErrorText = GetFindGroupRestriction()
    if ( findError ~= nil ) then
        self.FindGroupButton.tooltip = findErrorText
        self.StartGroupButton.tooltip = findErrorText
    end
end)

hooksecurefunc('LFGListNothingAvailable_Update', function(self)--LFGList.lua
    if ( IsRestrictedAccount() ) then
        self.Label:SetText('免费试玩账号无法使用此功能。')
    elseif ( C_LFGList.HasActivityList() ) then
        self.Label:SetText('你无法加入任何队伍。')
    else
        self.Label:SetText('加载中…')
    end
end)

hooksecurefunc('LFGListEntryCreation_Select', function(self, filters, categoryID, groupID, activityID)
    filters, categoryID, groupID, activityID = LFGListUtil_AugmentWithBest(bit.bor(self.baseFilters or 0, filters or 0), categoryID, groupID, activityID)
    local activityInfo = C_LFGList.GetActivityInfoTable(activityID)
    if(not activityInfo) then
        return
    end
    --local groupName = C_LFGList.GetActivityGroupInfo(groupID)
    local englishFaction, localizedFaction  = UnitFactionGroup("player")
    local faction= englishFaction=='Alliance' and '联盟'
                or (englishFaction=="Horde" and '部落')
                or (englishFaction=="Neutral" and '中立')
                or localizedFaction
    self.CrossFactionGroup.Label:SetFormattedText('仅限%s', faction)
    self.CrossFactionGroup.tooltip = format('只有%s玩家会看到你的队伍。|n|n这可能会减少你收到的申请人数量。', faction)
    self.CrossFactionGroup.disableTooltip = format('这项活动不支持跨阵营队伍。|n|n你的队伍将只对%s玩家显示。', faction)
    if ( activityInfo.ilvlSuggestion ~= 0 ) then
        self.ItemLevel.EditBox.Instructions:SetFormattedText('推荐%d级', activityInfo.ilvlSuggestion)
    else
        self.ItemLevel.EditBox.Instructions:SetText('物品等级')
    end
end)

hooksecurefunc('LFGListEntryCreation_SetPlaystyleLabelTextFromActivityInfo', function(self, activityInfo)--LFGList.lua
    if(not activityInfo) then
        return
    end
    local labelText
    if(activityInfo.isRatedPvpActivity) then
        labelText = '目标'--LFG_PLAYSTYLE_LABEL_PVP
    elseif (activityInfo.isMythicPlusActivity) then
        labelText = '目标'--LFG_PLAYSTYLE_LABEL_PVE
    else
        labelText = '游戏风格'--LFG_PLAYSTYLE_LABEL_PVE_MYTHICZERO
    end
    self.PlayStyleLabel:SetText(labelText)
end)

hooksecurefunc('LFGListEntryCreation_UpdateValidState', function(self)
    local errorText
    local activityInfo = C_LFGList.GetActivityInfoTable(self.selectedActivity)
    local maxNumPlayers = activityInfo and  activityInfo.maxNumPlayers or 0
    local mythicPlusDisableActivity = not C_LFGList.IsPlayerAuthenticatedForLFG(self.selectedActivity) and (activityInfo.isMythicPlusActivity and not C_LFGList.GetKeystoneForActivity(self.selectedActivity))
    if ( maxNumPlayers > 0 and GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) >= maxNumPlayers ) then
        errorText = string.format('针对此项活动，你的队伍人数已满（%d）。', maxNumPlayers)
    elseif (mythicPlusDisableActivity) then
        errorText = '|cffff0000你只有给自己的账号添加战网安全令和短信安全保护功能后才能在没有钥石时发布一个史诗钥石队伍|r|n|cff1eff00<点击显示更多信息>|r'
    elseif ( LFGListEntryCreation_GetSanitizedName(self) == "" ) then
        errorText = '你必须为你的队伍输入一个名字。'
    elseif  not self.ItemLevel.warningText
        and not self.PvpItemLevel.warningText
        and not self.MythicPlusRating.warningText
        and not self.PVPRating.warningText
    then
        errorText = LFGListUtil_GetActiveQueueMessage(false)
    end
    if errorText then
        self.ListGroupButton.errorText = errorText
    end
end)

local function LFGListUtil_GetQuestDescription(questID)
    local descriptionFormat = '完成任务[%s]。'
    if ( QuestUtils_IsQuestWorldQuest(questID) ) then
        descriptionFormat = '完成世界任务[%s]。'
    end
    return descriptionFormat:format(QuestUtils_GetQuestName(questID))
end
hooksecurefunc('LFGListEntryCreation_SetEditMode', function(self)--LFGList.lua
    local descInstructions = nil
    local isAccountSecured = C_LFGList.IsPlayerAuthenticatedForLFG(self:GetParent().selectedActivity)
    if (not isAccountSecured) then
        descInstructions = '给自己的账号添加安全令和和短信安全保护功能后才能解锁此栏'
    end
    if self.editMode then
        local activeEntryInfo = C_LFGList.GetActiveEntryInfo()
        assert(activeEntryInfo)
        if ( activeEntryInfo.questID ) then
            self.Description.EditBox.Instructions:SetText(LFGListUtil_GetQuestDescription(activeEntryInfo.questID))
        else
            self.Description.EditBox.Instructions:SetText(descInstructions or '关于你的队伍的更多细节（可选）')
        end
        self.ListGroupButton:SetText('编辑完毕')
    else
        self.Description.EditBox.Instructions:SetText(descInstructions or '关于你的队伍的更多细节（可选）')
        self.ListGroupButton:SetText('列出队伍')
    end
end)

hooksecurefunc('LFGListApplicationViewer_UpdateInfo', function(self)
    local activeEntryInfo = C_LFGList.GetActiveEntryInfo()
    assert(activeEntryInfo)
    local activityInfo = C_LFGList.GetActivityInfoTable(activeEntryInfo.activityID)
    if not activityInfo then
        return
    end
    local categoryInfo = C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID)

    if not categoryInfo then
        return
    end
    e.set(self.EntryName, activeEntryInfo.name)

    local activityName= e.strText[self.DescriptionFrame.activityName]
    if ( activeEntryInfo.comment == "" ) then
        e.set(self.DescriptionFrame.Text, activityName)
    else
        local comment= e.strText[activeEntryInfo.comment]
        if comment or activityName then
            self.DescriptionFrame.Text:SetFormattedText("%s |cff888888- %s|r", activityName or self.DescriptionFrame.activityName, comment or self.DescriptionFrame.comment)
        end
    end
    if activityInfo.isPvpActivity then
        if activeEntryInfo.requiredItemLevel ~= 0 then
            self.ItemLevel:SetFormattedText('PvP物品等级：%d', activeEntryInfo.requiredItemLevel)
        end
    else
        if activeEntryInfo.requiredItemLevel ~= 0 then
            self.ItemLevel:SetFormattedText('物品等级：|cffffffff%d|r', activeEntryInfo.requiredItemLevel)
        end
    end
    if activeEntryInfo.privateGroup then
        self.PrivateGroup:SetText('个人')
    end
end)
LFGListFrame.ApplicationViewer.RefreshButton:HookScript('OnEnter', function()
    GameTooltip:SetText('刷新', HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end)

hooksecurefunc('LFGListApplicationViewer_UpdateAvailability', function(self)
    if IsRestrictedAccount() then
        self.EditButton.tooltip = '免费试玩账号无法使用此功能。'
    end
end)

hooksecurefunc('LFGListApplicationViewer_UpdateApplicant', function(button, applicantID)
    local applicantInfo = C_LFGList.GetApplicantInfo(applicantID) or {}
    if not ( applicantInfo or applicantInfo.applicationStatus == "applied" ) then
        if ( applicantInfo.applicationStatus == "invited" ) then
            button.Status:SetText('已邀请')
        elseif ( applicantInfo.applicationStatus == "failed" or applicantInfo.applicationStatus == "cancelled" ) then
            button.Status:SetText('|cffff0000已取消|r')
        elseif ( applicantInfo.applicationStatus == "declined" or applicantInfo.applicationStatus == "declined_full" or applicantInfo.applicationStatus == "declined_delisted" ) then
            button.Status:SetText('已拒绝')
        elseif ( applicantInfo.applicationStatus == "timedout" ) then
            button.Status:SetText('已过期')
        elseif ( applicantInfo.applicationStatus == "inviteaccepted" ) then
            button.Status:SetText('已加入')
        elseif ( applicantInfo.applicationStatus == "invitedeclined" ) then
            button.Status:SetText('拒绝邀请')
        end
    end
end)

hooksecurefunc('LFGListSearchPanel_UpdateButtonStatus', function(self)
    local resultID = self.selectedResult
    local _, numActiveApplications = C_LFGList.GetNumApplications()
    local messageApply = LFGListUtil_GetActiveQueueMessage(true)
    local availTank, availHealer, availDPS = C_LFGList.GetAvailableRoles()
    if not messageApply then
        if ( not LFGListUtil_IsAppEmpowered() ) then
            self.SignUpButton.tooltip = '你不是队长。'
        elseif ( IsInGroup(LE_PARTY_CATEGORY_HOME) and C_LFGList.IsCurrentlyApplying() ) then
            self.SignUpButton.tooltip = '你正在申请加入另一支队伍。'
        elseif ( numActiveApplications >= MAX_LFG_LIST_APPLICATIONS ) then
            self.SignUpButton.tooltip = string.format('你只能同时发出%d份有效申请。', MAX_LFG_LIST_APPLICATIONS)
        elseif ( GetNumGroupMembers(LE_PARTY_CATEGORY_HOME) > MAX_PARTY_MEMBERS + 1 ) then
            self.SignUpButton.tooltip = '你的队伍中队员太多，无法申请。\n（最多不能超过5个）'
        elseif ( not (availTank or availHealer or availDPS) ) then
            self.SignUpButton.tooltip = '你必须有至少一项专精才能申请加入该队伍。'
        elseif ( GroupHasOfflineMember(LE_PARTY_CATEGORY_HOME) ) then
            self.SignUpButton.tooltip = '有一个或更多的队员处于离线状态。'
        elseif not ( resultID ) then
            self.SignUpButton.tooltip = '选择一个搜索结果。'
        end
    elseif self.SignUpButton.tooltip and e.strText[self.SignUpButton.tooltip] then
        self.SignUpButton.tooltip= e.strText[self.SignUpButton.tooltip]
    end
    local isPartyLeader = UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME)
    local canBrowseWhileQueued = C_LFGList.HasActiveEntryInfo() and isPartyLeader
    if ( IsInGroup(LE_PARTY_CATEGORY_HOME) and not isPartyLeader ) then
        self.ScrollBox.StartGroupButton:Disable()
        self.ScrollBox.StartGroupButton.tooltip = '只有队长才能这么做。'
    else
        local messageStart = LFGListUtil_GetActiveQueueMessage(false)
        local startError, errorText = GetStartGroupRestriction()
        if ( messageStart ) then
            self.ScrollBox.StartGroupButton.tooltip = messageStart
        elseif ( startError ~= nil ) then
            self.ScrollBox.StartGroupButton.tooltip = errorText
        elseif (canBrowseWhileQueued) then
            self.ScrollBox.StartGroupButton.tooltip = '你不能在你的队伍出现在预创建队伍列表中时那样做。'
        end
    end

end)

hooksecurefunc('LFGListSearchEntry_Update', function(self)
    if not C_LFGList.HasSearchResultInfo(self.resultID) then
        return
    end
    local _, appStatus, pendingStatus = C_LFGList.GetApplicationInfo(self.resultID)
    local isApplication = (appStatus ~= "none" or pendingStatus)
    if not LFGListUtil_IsAppEmpowered() then
        self.CancelButton.tooltip = '你不是队长。'
        if ( pendingStatus == "applied" and C_LFGList.GetRoleCheckInfo() ) then
            self.PendingLabel:SetText('职责确认')
        elseif ( pendingStatus == "cancelled" or appStatus == "cancelled" or appStatus == "failed" ) then
            self.PendingLabel:SetText('|cffff0000已取消|r')
        elseif ( appStatus == "declined" or appStatus == "declined_full" or appStatus == "declined_delisted" ) then
            self.PendingLabel:SetText(appStatus == "declined_full" and ' "满"' or '已拒绝')
        elseif ( appStatus == "timedout" ) then
            self.PendingLabel:SetText('已过期')
        elseif ( appStatus == "invited" ) then
            self.PendingLabel:SetText('已邀请')
        elseif ( appStatus == "inviteaccepted" ) then
            self.PendingLabel:SetText('已加入')
        elseif ( appStatus == "invitedeclined" ) then
            self.PendingLabel:SetText('拒绝邀请')
        elseif ( isApplication and pendingStatus ~= "applied" ) then
            self.PendingLabel:SetText('待定|cff40bf40-|r')
        end
        local searchResultInfo = C_LFGList.GetSearchResultInfo(self.resultID)
        if e.strText[searchResultInfo.voiceChat] then
            self.VoiceChat.tooltip = e.strText[searchResultInfo.voiceChat]
        end
    end
end)

hooksecurefunc('LFGListInviteDialog_UpdateOfflineNotice', function(self)
    if ( GroupHasOfflineMember(LE_PARTY_CATEGORY_HOME) ) then
        self.OfflineNotice:SetText('有一名队伍成员处于离线状态，将无法收到邀请。')
    else
        self.OfflineNotice:SetText('所有队伍成员都为在线状态。')
    end
end)

hooksecurefunc('LFGListEntryCreation_Show', function(self, _, selectedCategory)
    local categoryInfo = C_LFGList.GetLfgCategoryInfo(selectedCategory)
    e.set(self.Label,categoryInfo.name)
end)

LFGListFrame.ApplicationViewer.AutoAcceptButton.Label:SetText('自动邀请')
LFGListFrame.ApplicationViewer.BrowseGroupsButton:SetText('浏览队伍')
LFGListFrame.ApplicationViewer.RemoveEntryButton:SetText('移除')
LFGListFrame.ApplicationViewer.EditButton:SetText('编辑')
LFGListFrame.ApplicationViewer.UnempoweredCover.Label:SetText('你的队伍正在组建中。')
LFGListFrame.SearchPanel.SearchBox.Instructions:SetText('搜索')
LFGListFrame.SearchPanel.FilterButton:SetText('过滤器')
LFGListFrame.SearchPanel.BackToGroupButton:SetText('回到队伍')
LFGListFrame.SearchPanel.SignUpButton:SetText('申请')
LFGListFrame.SearchPanel.BackButton:SetText('后退')
LFGListFrame.SearchPanel.ScrollBox.StartGroupButton:SetText('创建队伍')
LFGListFrame.SearchPanel.RefreshButton:HookScript('OnEnter', function()
    GameTooltip:SetText('重新搜索', HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
end)
hooksecurefunc('LFGListSearchPanel_UpdateResults', function(self)
    if self.ScrollBox.NoResultsFound:IsShown() and self.totalResults == 0 then
        self.ScrollBox.NoResultsFound:SetText(self.searchFailed and '搜索失败。请稍后再试。' or '未找到队伍。如果你找不到想要的队伍，可以自己创建一支。')
    end
end)

LFGListFrame.EntryCreation.CancelButton:SetText('后退')
LFGListFrame.EntryCreation.VoiceChat.EditBox.Instructions:SetText('语音聊天程序')

LFGListCreationDescription.EditBox.Instructions:SetText('关于你的队伍的更多细节（可选）')
LFGListFrame.EntryCreation.Name.Instructions:SetText('你的队伍在列表中显示的描述性名称')
LFGListCreationDescription:HookScript('OnShow', function(self)--LFGListCreationDescriptionMixin
    local isAccountSecured = C_LFGList.IsPlayerAuthenticatedForLFG(self:GetParent().selectedActivity)
    self.EditBox.Instructions:SetText(isAccountSecured and '关于你的队伍的更多细节（可选）' or '给自己的账号添加安全令和和短信安全保护功能后才能解锁此栏')
end)
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
    e.set(LFGDungeonReadyDialogInstanceInfoFrame.name, name)
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
            GameTooltip:AddDoubleLine('|A:common-icon-redx:0:0|a'.. e.cn(bossName), '|cnRED_FONT_COLOR:已消灭')
        else
            GameTooltip:AddDoubleLine(format('|A:%s:0:0|a', e.Icon.select)..e.cn(bossName), '|cnGREEN_FONT_COLOR:可消灭')
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
            e.set(LFGDungeonReadyDialogRoleLabel, role)
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


hooksecurefunc('LFGListInviteDialog_Show', function(self, resultID, kstringGroupName)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID) or {}
    local activityName = C_LFGList.GetActivityFullName(searchResultInfo.activityID, nil, searchResultInfo.isWarMode)
    local _, status, _, _, role = C_LFGList.GetApplicationInfo(resultID)
    local name= kstringGroupName or searchResultInfo.name
    if e.strText[name] then
        self.GroupName:SetText(e.strText[name])
    end
    if e.strText[activityName] then
        self.ActivityName:SetText(e.strText[activityName])
    end
    role= _G[role]
    if e.strText[role] then
        self.Role:SetText(e.strText[role])
    end
    self.Label:SetText(status ~= "invited" and '你已经加入了一支队伍：' or '你收到了一支队伍的邀请：')
end)
LFGListInviteDialog.Label:SetText('你收到了一支队伍的邀请：')
LFGListInviteDialog.RoleDescription:SetText('你的职责')
LFGListInviteDialog.OfflineNotice:SetText('有一名队伍成员处于离线状态，将无法收到邀请。')
LFGListInviteDialog.AcceptButton:SetText('接受')
LFGListInviteDialog.DeclineButton:SetText('拒绝')
LFGListInviteDialog.AcknowledgeButton:SetText('确定')


hooksecurefunc('LFGListSearchPanel_SetCategory', function(self, categoryID, filters)--LFGList.lua
    local categoryInfo = C_LFGList.GetLfgCategoryInfo(categoryID) or {} --if categoryInfo.searchPromptOverride then e.set(self.SearchBox.Instructions, e.strText[categoryInfo.searchPromptOverride])
    self.SearchBox.Instructions:SetText('过滤器')
    local name = LFGListUtil_GetDecoratedCategoryName(categoryInfo.name, filters, false)
    if name then
        if e.strText[name] then
            e.set(self.CategoryName, name)
        else
            local t1, t2 = name:match('(.-) %- (.+)')
            if t1 and t2 then
                local a1, b2= e.strText[t1], e.strText[t2]
                if a1 or b2 then
                    self.CategoryName:SetText((a1 or t1)..' - '..(b2 or t2))
                end
            end
        end
    end
end)


_G['LFDQueueFrameFollowerTitle']:SetText('追随者地下城')
_G['LFDQueueFrameFollowerDescription']:SetText('与NPC队友一起完成地下城')
--set(LFDQueueFrameRandomScrollFrameChildFrameTitle, '')
hooksecurefunc('LFGRewardsFrame_UpdateFrame', function(parentFrame, dungeonID)--LFGFrame.lua
    if ( not dungeonID ) then
        return
    end
    local _, _, subtypeID,_,_,_,_,_,_,_,_,_,_,_, isHoliday, _, _, isTimewalker = GetLFGDungeonInfo(dungeonID)
    local isScenario = (subtypeID == LFG_SUBTYPEID_SCENARIO)
    local doneToday = GetLFGDungeonRewards(dungeonID)
    if ( isTimewalker ) then
        parentFrame.rewardsDescription:SetText('你将获得该奖励：')
        parentFrame.title:SetText('随机时空漫游地下城')
        parentFrame.description:SetText('时空漫游将让你回到低级地下城中，并将你的角色实力降低到与之相适应程度，但首领会掉落与你当前等级相符的战利品。')
    elseif ( isHoliday ) then
        if ( doneToday ) then
            parentFrame.rewardsDescription:SetText('每天继首次胜利之后的每次胜利将为你赢得：')
        else
            parentFrame.rewardsDescription:SetText('你每天取得的首次胜利将为你赢得：')
        end
        --parentFrame.title:SetText(dungeonName)
        --parentFrame.description:SetText(dungeonDescription)
    elseif ( subtypeID == LFG_SUBTYPEID_RAID ) then
        if ( doneToday ) then --May not actually be today, but whatever this reset period is.
            parentFrame.rewardsDescription:SetText('当你完成每周的首次副本之后，每次胜利都可为你赢得：')
        else
            parentFrame.rewardsDescription:SetText('每周第一次完成可获得：')
        end
        --parentFrame.title:SetText(dungeonName)
        --parentFrame.description:SetText(dungeonDescription)
    else
        local numCompletions, isWeekly = LFGRewardsFrame_EstimateRemainingCompletions(dungeonID)
        if ( numCompletions <= 0 ) then
            parentFrame.rewardsDescription:SetText('你将获得该奖励：')
        elseif ( isWeekly ) then
            parentFrame.rewardsDescription:SetText(format('本周你还能获取此奖励%d|4次:次：', numCompletions))
        else
            parentFrame.rewardsDescription:SetText(format('今天你还能获取此奖励%d|4次:次：', numCompletions))
        end
        if ( isScenario ) then
            if ( LFG_IsHeroicScenario(dungeonID) ) then
                parentFrame.title:SetText('随机英雄场景战役')
                parentFrame.description:SetText('使用随机英雄场景战役排队可获得额外奖励。但你需要组满队伍')
            else
                parentFrame.title:SetText('随机场景战役')
                parentFrame.description:SetText('使用随机场景战役排队，会获得额外奖励哦！')
            end
        else
            parentFrame.title:SetText('随机地下城')
            parentFrame.description:SetText('使用地下城查找器前往随机地下城，会有额外奖励哦！')
        end
    end
end)

LFGListFrame.ApplicationViewer.ScrollBox.NoApplicants:SetText('你的队伍已经加入列表。|n申请者将出现在此处。')



























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