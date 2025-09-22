

--预创建队伍











local function LFGListUtil_GetDecoratedCategoryName(categoryName, filter, useColors)
    categoryName= WoWTools_ChineseMixin:CN(categoryName) or categoryName
	if ( filter == 0 ) then
		return categoryName;
	end

	local colorStart = "";
	local colorEnd = "";
	if ( useColors ) then
		colorStart = "|cffffffff";
		colorEnd = "|r";
	end

	local extraName = "";
	if ( filter == Enum.LFGListFilter.NotRecommended ) then
		extraName = '经典旧世';
	elseif ( filter == Enum.LFGListFilter.Recommended ) then
		local exp = LFGListUtil_GetCurrentExpansion();
		extraName = WoWTools_ChineseMixin:CN(_G["EXPANSION_NAME"..exp])
	end

	if extraName and extraName ~= "" then
		return string.format('%s - %s%s%s', categoryName, colorStart, extraName, colorEnd);
	else
		return categoryName;
	end
end




















LFGListFrame.CategorySelection.Label:SetText('预创建队伍')


hooksecurefunc('LFGListCategorySelection_AddButton', function(self, btnIndex, categoryID, filters)--LFGList.lua
    local baseFilters = self:GetParent().baseFilters
    local allFilters = bit.bor(baseFilters, filters)
    if ( filters ~= 0 and #C_LFGList.GetAvailableActivities(categoryID, nil, allFilters) == 0) then
        return
    end
    local categoryInfo = C_LFGList.GetLfgCategoryInfo(categoryID)
    local text=LFGListUtil_GetDecoratedCategoryName(categoryInfo.name, filters, true)
    
    local btn= self.CategoryButtons[btnIndex]
    if text and btn then
        WoWTools_ChineseMixin:SetCNFont(btn:GetFontString())
        local name= text:match('%- (.+)')
        local cnName= name and WoWTools_ChineseMixin:CN(name)
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

        WoWTools_ChineseMixin:SetCNFont(LFGListFrame.ApplicationViewer.ItemLevelColumnHeader.Label)
        WoWTools_ChineseMixin:SetCNFont(LFGListFrame.ApplicationViewer.RoleColumnHeader.Label)
        WoWTools_ChineseMixin:SetCNFont(LFGListFrame.ApplicationViewer.NameColumnHeader.Label)
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

local function LFGListUtil_GetQuestObjectTextription(questID)
    local descriptionFormat = '完成任务[%s]。'
    if ( QuestUtils_IsQuestWorldQuest(questID) ) then
        descriptionFormat = '完成世界任务[%s]。'
    end
    return format(descriptionFormat, QuestUtils_GetQuestName(questID))
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
            self.Description.EditBox.Instructions:SetText(LFGListUtil_GetQuestObjectTextription(activeEntryInfo.questID))
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
    if not activeEntryInfo or not activeEntryInfo.activityID then
        return
    end
    local activityInfo = C_LFGList.GetActivityInfoTable(activeEntryInfo.activityID)
    local categoryInfo = activityInfo and C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID)
    if not categoryInfo then
        return
    end

    WoWTools_ChineseMixin:SetLabel(self.EntryName, activeEntryInfo.name)

    local activityName= WoWTools_ChineseMixin:CN(self.DescriptionFrame.activityName)
    if ( activeEntryInfo.comment == "" ) then
        WoWTools_ChineseMixin:SetLabel(self.DescriptionFrame.Text, activityName)
    else
        local comment= WoWTools_ChineseMixin:CN(activeEntryInfo.comment)
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
    elseif self.SignUpButton.tooltip and WoWTools_ChineseMixin:CN(self.SignUpButton.tooltip) then
        self.SignUpButton.tooltip= WoWTools_ChineseMixin:CN(self.SignUpButton.tooltip)
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
        if WoWTools_ChineseMixin:CN(searchResultInfo.voiceChat) then
            self.VoiceChat.tooltip = WoWTools_ChineseMixin:CN(searchResultInfo.voiceChat)
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
    WoWTools_ChineseMixin:SetLabel(self.Label,categoryInfo.name)
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






hooksecurefunc('LFGListInviteDialog_Show', function(self, resultID, kstringGroupName)
    local searchResultInfo = C_LFGList.GetSearchResultInfo(resultID) or {}
    local activityName = C_LFGList.GetActivityFullName(searchResultInfo.activityID, nil, searchResultInfo.isWarMode)
    local _, status, _, _, role = C_LFGList.GetApplicationInfo(resultID)
    local name= kstringGroupName or searchResultInfo.name
    if WoWTools_ChineseMixin:CN(name) then
        self.GroupName:SetText(WoWTools_ChineseMixin:CN(name))
    end
    if WoWTools_ChineseMixin:CN(activityName) then
        self.ActivityName:SetText(WoWTools_ChineseMixin:CN(activityName))
    end
    role= _G[role]
    if WoWTools_ChineseMixin:CN(role) then
        self.Role:SetText(WoWTools_ChineseMixin:CN(role))
    end
    self.Label:SetText(status ~= "invited" and '你已经加入了一支队伍：' or '你收到了一支队伍的邀请：')
end)
LFGListInviteDialog.Label:SetText('你收到了一支队伍的邀请：')
LFGListInviteDialog.RoleDescription:SetText('你的职责')
LFGListInviteDialog.OfflineNotice:SetText('有一名队伍成员处于离线状态，将无法收到邀请。')
LFGListInviteDialog.AcceptButton:SetText('接受')
LFGListInviteDialog.DeclineButton:SetText('拒绝')
LFGListInviteDialog.AcknowledgeButton:SetText('确定')


LFGListFrame.ApplicationViewer.ScrollBox.NoApplicants:SetText('你的队伍已经加入列表。|n申请者将出现在此处。')

--自定义，副本，创建，更多...
LFGListFrame.EntryCreation.ActivityFinder.Dialog.SelectButton:SetText('选取')
LFGListFrame.EntryCreation.ActivityFinder.Dialog.CancelButton:SetText('取消')

hooksecurefunc('LFGListEntryCreationActivityFinder_InitButton', function(btn)
	local activityInfo = C_LFGList.GetActivityInfoTable(btn.activityID) or {}
    local fullName= activityInfo and activityInfo.fullName
    if not fullName then
        return
    end
    local name= WoWTools_ChineseMixin:CN(fullName)
    if not name then
        local str= fullName:match('(.-) %(')
        local cn= str and WoWTools_ChineseMixin:CN(str)
        if cn then
            name= fullName:gsub(str, cn)
        end
        local shortName= activityInfo.shortName
        if name and shortName and name:find(shortName) then
            local s= WoWTools_ChineseMixin:CN(shortName)
            if s then
                name= name:gsub(shortName, s)
            elseif shortName:find(' (.+)') then--(10 英雄)
                local sh1= shortName:match(' (.+)')
                local cnSh1= WoWTools_ChineseMixin:CN(sh1)
                if cnSh1 then
                    name= name:gsub(sh1, cnSh1)
                end
            end
        end
    end
    if name then
        btn:SetText(name)
    end
end)
--LFGListFrame.EntryCreation.ActivityFinder.Dialog.ScrollBox
















--LFGList.lua
hooksecurefunc('LFGListSearchPanel_SetCategory', function(self)--, categoryID, filters)
	local categoryInfo = C_LFGList.GetLfgCategoryInfo(self.categoryID);
	self.SearchBox.Instructions:SetText(WoWTools_ChineseMixin:CN(categoryInfo.searchPromptOverride) or '过滤器');
	local name = LFGListUtil_GetDecoratedCategoryName(categoryInfo.name, self.filters, false);
	self.CategoryName:SetText(name)
end)