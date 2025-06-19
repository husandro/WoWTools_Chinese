
--公会和社区









    CommunitiesFrameTitleText:SetText('公会与社区')
    CommunitiesFrame.AddToChatButton.Label:SetText('添加至聊天窗口')
    CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton:SetText('公会招募')
    CommunitiesFrame.InviteButton:SetText('邀请成员')
    CommunitiesFrame.CommunitiesControlFrame.GuildControlButton:SetText('公会设置')
    hooksecurefunc(CommunitiesFrame.CommunitiesControlFrame, 'Update', function(self)
        if self.CommunitiesSettingsButton:IsShown() then
            local communitiesFrame = self:GetCommunitiesFrame()
            local clubId = communitiesFrame:GetSelectedClubId()
            if clubId then
                local clubInfo = C_Club.GetClubInfo(clubId)
                if clubInfo then
                    self.CommunitiesSettingsButton:SetText(clubInfo.clubType == Enum.ClubType.BattleNet and '群组设置' or '社区设置')
                end
            end
        end
        CommunitiesFrame.CommunitiesControlFrame.CommunitiesSettingsButton:SetText('社区设置')
    end)

    CommunitiesFrame.RecruitmentDialog.DialogLabel:SetText('招募')
    CommunitiesFrame.RecruitmentDialog.ShouldListClub.Label:SetText('在公会查找器里列出我的公会')
    --ClubFinderClubFocusDropdown.Label:SetText('活动倾向')

    CommunitiesFrame.RecruitmentDialog.RecruitmentMessageFrame.Label:SetText('招募信息')
    CommunitiesFrame.RecruitmentDialog.RecruitmentMessageFrame.RecruitmentMessageInput.EditBox.Instructions:SetText('在此介绍你的公会以及你们需要什么样的玩家。')
    CommunitiesFrame.RecruitmentDialog.MinIlvlOnly.EditBox.Text:SetText('物品等级')
    CommunitiesFrame.RecruitmentDialog.MaxLevelOnly.Label:SetText('只限满级')
    CommunitiesFrame.RecruitmentDialog.MinIlvlOnly.Label:SetText('最低物品等级')
    CommunitiesFrame.RecruitmentDialog.Accept:SetText('接受')
    CommunitiesFrame.RecruitmentDialog.Cancel:SetText('取消')

    CommunitiesFrame.GuildBenefitsFrame.FactionFrame.Label:SetText('公会声望：')

    CommunitiesFrame.NotificationSettingsDialog.TitleLabel:SetText('通知设置')--CommunitiesStreams.xml
    CommunitiesFrame.NotificationSettingsDialog.ScrollFrame.Child.SettingsLabel:SetText('通知')
    CommunitiesFrame.NotificationSettingsDialog.ScrollFrame.Child.QuickJoinButton.Text:SetText('快速加入通知')
    CommunitiesFrame.NotificationSettingsDialog.ScrollFrame.Child.NoneButton:SetText('无')
    CommunitiesFrame.NotificationSettingsDialog.ScrollFrame.Child.AllButton:SetText('全部')

    CommunitiesFrame.NotificationSettingsDialog.Selector.OkayButton:SetText('确定')
    CommunitiesFrame.NotificationSettingsDialog.Selector.CancelButton:SetText('取消')

    hooksecurefunc(CommunitiesFrame, 'UpdateCommunitiesButtons', function(self)--CommunitiesFrameMixin
        local clubId = self:GetSelectedClubId()
        local inviteButton = self.InviteButton
        if clubId ~= nil then
            local clubInfo = C_Club.GetClubInfo(clubId)
            local isClubAtCapacity = clubInfo and clubInfo.memberCount and clubInfo.memberCount >= C_Club.GetClubCapacity()
            if clubInfo and clubInfo.clubType == Enum.ClubType.Guild then
                local hasGuildPermissions = CanGuildInvite()
                local isButtonEnabled = inviteButton:IsEnabled()
                if(hasGuildPermissions and not isButtonEnabled) then
                    if(isClubAtCapacity) then
                        inviteButton.disabledTooltip = '你无法邀请新成员，你的公会已满。'
                    end
                elseif(not isButtonEnabled) then
                    inviteButton.disabledTooltip = '你没有邀请的权限。'
                end
            elseif clubInfo and (clubInfo.clubType == Enum.ClubType.Character or clubInfo.clubType == Enum.ClubType.BattleNet) then
                local privileges = self:GetPrivilegesForClub(clubId)
                inviteButton:SetEnabled(not isClubAtCapacity and privileges.canSendInvitation)
                local isButtonEnabled = inviteButton:IsEnabled()
                if(privileges.canSendInvitation and not isButtonEnabled) then
                    if(isClubAtCapacity) then
                        inviteButton.disabledTooltip = '你无法邀请新成员，你的社区已满。'
                    end
                elseif(not isButtonEnabled) then
                    inviteButton.disabledTooltip = '你没有邀请的权限。'
                end
            end
        end
    end)

    hooksecurefunc(CommunitiesFrame.TicketFrame, 'DisplayTicket', function(self, ticketInfo)--CommunitiesTicketFrameMixin
        local clubInfo = ticketInfo.clubInfo
        self.Type:SetText(clubInfo.clubType == Enum.ClubType.Character and '《魔兽世界》社区' or '暴雪群组')
        self.MemberCount:SetFormattedText('成员：|cffffffff%d|r', clubInfo.memberCount or 1)
    end)
    hooksecurefunc(CommunitiesFrame.InvitationFrame, 'DisplayInvitation', function(self)--CommunitiesInvitationFrame.lua
        local clubInfo = self.invitationInfo.club
        local inviterInfo = self.invitationInfo.inviter
        local isCharacterClub = clubInfo.clubType == Enum.ClubType.Character
        local inviterName = inviterInfo.name or ""
        local classInfo = inviterInfo.classID and C_CreatureInfo.GetClassInfo(inviterInfo.classID)
        local inviterText
        if isCharacterClub and classInfo then
            local classColorInfo = RAID_CLASS_COLORS[classInfo.classFile]
            inviterText = GetPlayerLink(inviterName, ("[%s]"):format(WrapTextInColorCode(inviterName, classColorInfo.colorStr)))
        elseif isCharacterClub then
            inviterText = GetPlayerLink(inviterName, ("[%s]"):format(inviterName))
        else
            inviterText = inviterName
        end
        self.InvitationText:SetFormattedText('%s邀请你加入', inviterText)
        self.Type:SetText(isCharacterClub and '《魔兽世界》社区' or '暴雪群组')
        local leadersText = ""
        for i, leader in ipairs(self.invitationInfo.leaders) do
            if leader.name then
                leadersText = leadersText..leader.name
                if i ~= #self.invitationInfo.leaders then
                    leadersText = leadersText..', '
                end
            end
        end
        self.Leader:SetFormattedText('管理员：|cffffffff%s|r', leadersText)
        self.MemberCount:SetFormattedText('成员：|cffffffff%d|r', clubInfo.memberCount or 1)
    end)


    CommunitiesFrame.GuildBenefitsFrame.Rewards.TitleText:SetText('公会奖励')
    CommunitiesFrame.GuildBenefitsFrame.GuildRewardsTutorialButton:HookScript('OnEnter', function()--GuildRewards.xml
        GameTooltip:SetText('访问任一主城中的公会商人以购买奖励', nil, nil, nil, nil, true)
        GameTooltip:Show()
    end)
    CommunitiesFrame.GuildBenefitsFrame.GuildAchievementPointDisplay:HookScript('OnEnter', function()--GuildRewards.lua
        GameTooltip_SetTitle(GameTooltip, '公会成就')
        GameTooltip:Show()
    end)




    if ClubFinderGuildFinderFrame.InsetFrame.CommunityCards then
        hooksecurefunc(ClubFinderGuildFinderFrame.InsetFrame.CommunityCards, 'BuildCardList', function(self)--ClubFinderCommunitiesCardsMixin
            WoWTools_ChineseMixin:SetLabel(self:GetParent().InsetFrame.GuildDescription)--('未发现结果。请修改你的搜索条件。')
        end)
        hooksecurefunc(ClubFinderGuildFinderFrame.InsetFrame.PendingCommunityCards, 'BuildCardList', function(self)
            WoWTools_ChineseMixin:SetLabel(self:GetParent().InsetFrame.GuildDescription)--('未发现结果。请修改你的搜索条件。')
        end)
    end

    hooksecurefunc(ClubFinderGuildFinderFrame, 'UpdateType', function(self)-- ClubFinderGuildAndCommunityMixin:UpdateType()
        if (self.isGuildType) then
            self.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。\n\n使用此工具来寻找与你志同道合的公会吧。')
            if (#self.PendingGuildCards.CardList > 0) then
                self.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #self.PendingGuildCards.CardList)
            else
                self.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', 0)
            end
        else
            self.InsetFrame.GuildDescription:SetText('选择搜索条件，然后按下“搜索”')
            if (#self.PendingCommunityCards.CardList > 0) then
                self.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #self.PendingCommunityCards.CardList)
            else
                self.ClubFinderPendingTab.tooltip = '等待确认中（0）'
            end
        end
    end)

    CommunitiesSettingsDialog:HookScript('OnShow', function(self)
        if self:GetClubType() == Enum.ClubType.BattleNet then
            self.DialogLabel:SetText('创建暴雪群组')
        else
            self.DialogLabel:SetText('创建《魔兽世界》社区')
        end
    end)
    CommunitiesSettingsDialog.NameLabel:SetText('名称')--CommunitiesSettings.xml
    CommunitiesSettingsDialog.ShortNameLabel:SetText('简称')
    CommunitiesSettingsDialog.DescriptionLabel:SetText('介绍')
    CommunitiesSettingsDialog.MessageOfTheDayLabel:SetText('今日信息')
    CommunitiesSettingsDialog.ChangeAvatarButton:SetText('更换')
    CommunitiesSettingsDialog.CrossFactionToggle.Label:SetText('跨阵营')
    CommunitiesSettingsDialog.ShouldListClub.Label:SetText('在社区查找器里列出')
    CommunitiesSettingsDialog.AutoAcceptApplications.Label:SetText('自动接受申请者')
    CommunitiesSettingsDialog.MaxLevelOnly.Label:SetText('只限满级')
    CommunitiesSettingsDialog.MinIlvlOnly.EditBox.Text:SetText('物品等级')
    CommunitiesSettingsDialog.MinIlvlOnly.Label:SetText('最低物品等级')
    CommunitiesSettingsDialog.LookingForDropdown.Label:SetText('寻找：')
    CommunitiesSettingsDialog.LanguageDropdown.Label:SetText('语言')
    CommunitiesSettingsDialog.Description.instructions= '介绍一下你的社区（可选）。'
    CommunitiesSettingsDialog.Delete:SetText('删除')
    CommunitiesSettingsDialog.Accept:SetText('接受')
    CommunitiesSettingsDialog.Cancel:SetText('取消')




    CommunitiesFrame.GuildLogButton:SetText('查看日志')
    CommunitiesGuildLogFrameCloseButton:SetText('关闭')

    CommunitiesFrame.ClubFinderInvitationFrame.AcceptButton:SetText('接受')
    CommunitiesFrame.ClubFinderInvitationFrame.DeclineButton:SetText('拒绝')
    CommunitiesFrame.ClubFinderInvitationFrame.InvitationText:SetText('')

    hooksecurefunc(CommunitiesFrame.ClubFinderInvitationFrame, 'DisplayInvitation', function(self, clubInfo)--ClubFinderInvitationsFrameMixin
        if clubInfo then
            local isGuild = clubInfo.isGuild
            --self.isLinkInvitation = isLinkInvitation
            if	(isGuild) then
                self.Type:SetText('公会')
            else
                self.Type:SetText('社区')
            end
            self.Leader:SetFormattedText('管理员：|cffffffff%s|r', clubInfo.guildLeader)
            self.MemberCount:SetFormattedText('成员：|cffffffff%d|r', clubInfo.numActiveMembers or 1)
            self.InvitationText:SetFormattedText('%s邀请你加入', clubInfo.guildLeader)
        end
    end)

    hooksecurefunc(CommunitiesListEntryMixin, 'SetFindCommunity', function(self)
        self.Name:SetText('寻找社区')
    end)



        --set(ClubFinderFilterDropdown.Label, '过滤器')
        --set(ClubFinderSortByDropdown.Label, '排序')
        --WoWTools_ChineseMixin:SetLabel(ClubFinderSizeDropdown.Label)
        WoWTools_ChineseMixin:SetLabel(ClubFinderCommunityAndGuildFinderFrame.OptionsList.ClubFilterDropdown.Label)
        WoWTools_ChineseMixin:SetLabel(ClubFinderCommunityAndGuildFinderFrame.OptionsList.SortByDropdown.Label)
        ClubFinderCommunityAndGuildFinderFrame.OptionsList.Search:SetText('搜索')
        ClubFinderGuildFinderFrame.OptionsList.Search:SetText('搜索')
        hooksecurefunc(ClubFinderCommunityAndGuildFinderFrame, 'UpdateType', function(self)-- ClubFinderGuildAndCommunityMixin:UpdateType()
            if (self.isGuildType) then
                self.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。\n\n使用此工具来寻找与你志同道合的公会吧。')
                if (#self.PendingGuildCards.CardList > 0) then
                    self.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #self.PendingGuildCards.CardList)
                else
                    self.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', 0)
                end
            else
                self.InsetFrame.GuildDescription:SetText('选择搜索条件，然后按下“搜索”')
                if (#self.PendingCommunityCards.CardList > 0) then
                    self.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #self.PendingCommunityCards.CardList)
                else
                    self.ClubFinderPendingTab.tooltip = '等待确认中（0）'
                end
            end
        end)
        hooksecurefunc(ClubFinderCommunityAndGuildFinderFrame.CommunityCards, 'BuildCardList', function(self)
            self:GetParent().InsetFrame.GuildDescription:SetText('未发现结果。请修改你的搜索条件。')
        end)
        ClubFinderCommunityAndGuildFinderFrame.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。|n|n使用此工具来寻找与你志同道合的公会吧。')
        WoWTools_ChineseMixin:SetLabel(ClubFinderGuildFinderFrame.InsetFrame.GuildDescription, '公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。|n|n使用此工具来寻找与你志同道合的公会吧。')
        WoWTools_ChineseMixin:SetLabel(ClubFinderGuildFinderFrame.OptionsList.ClubFilterDropdown.Label)
        ClubFinderGuildFinderFrame.OptionsList.ClubSizeDropdown.Label:SetText('规模')

        hooksecurefunc(ClubFinderCommunityAndGuildFinderFrame, 'GetDisplayModeBasedOnSelectedTab', function(self)
            if (self.isGuildType) then
                self.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。\n\n使用此工具来寻找与你志同道合的公会吧。')
            else
                self.InsetFrame.GuildDescription:SetText('选择搜索条件，然后按下“搜索”')
            end
        end)
        ClubFinderGuildFinderFrame.InsetFrame:HookScript('OnShow', function(self)--ClubFinder.xml
            local disabledReason = C_ClubFinder.GetClubFinderDisableReason()
            if disabledReason == Enum.ClubFinderDisableReason.Muted then
                self.ErrorDescription:SetText(RED_FONT_COLOR:WrapTextInColorCode('因为你的战网账号的家长监控设定或者隐私设定，此功能处于关闭状态'))
            elseif disabledReason == Enum.ClubFinderDisableReason.Silenced then
                self.ErrorDescription:SetText(RED_FONT_COLOR:WrapTextInColorCode('由于您的角色在游戏中存在发布不当内容的行为，导致您的账号受到了禁言处罚。被禁言期间，您无法使用此功能。'))
            end
        end)





    hooksecurefunc(CommunitiesListEntryMixin, 'SetAddCommunity', function(self)
        self.Name:SetText('加入或创建社区')
    end)
    hooksecurefunc(CommunitiesListEntryMixin, 'SetGuildFinder', function(self)
        self.Name:SetText('公会查找器')
    end)

    CommunitiesFrame.ClubFinderInvitationFrame.WarningDialog.Accept:SetText('接受')
    CommunitiesFrame.ClubFinderInvitationFrame.WarningDialog.Cancel:SetText('取消')
    CommunitiesFrame.ClubFinderInvitationFrame.WarningDialog:HookScript('OnShow', function(self)
        if (IsInGuild()) then
            self.DialogLabel:SetText('加入此公会时，你会|cnRED_FONT_COLOR:离开当前的公会|r。')
        else
            self.DialogLabel:SetText('你只能加入一个公会。|n加入此公会时，|cnRED_FONT_COLOR:其他公会邀请会被移除。|r')
        end
    end)

    local function ClubFinderGetTotalNumSpecializations()
        local numClasses = GetNumClasses();
        local count = 0;
        for i = 1, numClasses do
            local _, _, classID = GetClassInfo(i);
            for i2 = 1, GetNumSpecializationsForClassID(classID) do
                count = count + 1
            end
        end
        return count;
    end
    local function set_ClubFinderRequestToJoin(self)
        if (not self.info) then
            return
        end
        for check in pairs(self.SpecsPool.activeObjects or {}) do
            WoWTools_ChineseMixin:SetLabel(check.SpecName)
        end

        local specIds = ClubFinderGetPlayerSpecIds()
        local matchingSpecNames = { }
        for _, specId in ipairs(specIds) do
            local _, name = GetSpecializationInfoForSpecID(specId)
            if (self.card.recruitingSpecIds[specId]) then
                table.insert(matchingSpecNames, WoWTools_ChineseMixin:CN(name) or name)
            end
        end
        local classDisplayName = UnitClass("player")
        classDisplayName= WoWTools_ChineseMixin:CN(classDisplayName) or classDisplayName
        local isRecruitingAllSpecs = #self.info.recruitingSpecIds == 0 or #self.info.recruitingSpecIds == ClubFinderGetTotalNumSpecializations()
        if(isRecruitingAllSpecs) then
            if(self.info.isGuild) then
                self.RecruitingSpecDescriptions:SetText('此公会正在招募所有的专精类型。')
            else
                self.RecruitingSpecDescriptions:SetText('此社区正在招募所有的专精类型。')
            end
        elseif (#matchingSpecNames == 1) then
            self.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s %s。你玩的是哪个专精？', matchingSpecNames[1], classDisplayName)
        elseif (#matchingSpecNames == 2) then
            self.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s和%s %s。你玩的是哪个专精？', matchingSpecNames[1], matchingSpecNames[2], classDisplayName)
        elseif (#matchingSpecNames == 3) then
            self.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s %s和%s %s。你玩的是哪个专精？', matchingSpecNames[1], matchingSpecNames[2], matchingSpecNames[3], classDisplayName)
        elseif (#matchingSpecNames == 4) then
            self.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s %s %s和%s %s。你玩的是哪个专精？', matchingSpecNames[1], matchingSpecNames[2], matchingSpecNames[3], matchingSpecNames[4], classDisplayName)
        end
    end
    hooksecurefunc(ClubFinderGuildFinderFrame.RequestToJoinFrame, 'Initialize', set_ClubFinderRequestToJoin)
    hooksecurefunc(ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame, 'Initialize', set_ClubFinderRequestToJoin)
    ClubFinderGuildFinderFrame.RequestToJoinFrame.Apply:SetText('申请')
    ClubFinderGuildFinderFrame.RequestToJoinFrame.Cancel:SetText('取消')
    ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame.Apply:SetText('申请')
    ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame.Cancel:SetText('取消')
    ClubFinderGuildFinderFrame.RequestToJoinFrame.DialogLabel:SetText('申请加入')
    ClubFinderCommunityAndGuildFinderFrame.RequestToJoinFrame.DialogLabel:SetText('申请加入')


    hooksecurefunc(ClubsFinderJoinClubWarningMixin, 'OnShow', function(self)--没测试
        if (IsInGuild()) then
            self.DialogLabel:SetText('加入此公会时，你会离开当前的公会。')
        else
            self.DialogLabel:SetText('你只能加入一个公会。加入此公会时，其他公会邀请会被移除。')
        end
    end)










    --奖励, 物品，GuildRewards.lua
    hooksecurefunc(CommunitiesGuildRewardsButtonMixin, 'Init', function(self)
        local achievementID, itemID, itemName, _, repLevel = GetGuildRewardInfo(self.index)
        local name= WoWTools_ChineseMixin:GetItemName(itemID) or WoWTools_ChineseMixin:CN(itemName)
        if name then
            self.Name:SetText(name);
        end

        if ( achievementID and achievementID > 0 ) then
            name = select(2, GetAchievementInfo(achievementID))
            name= WoWTools_ChineseMixin:CN(name)
            if name then
                self.SubText:SetText('需要：'..COMMUNITIES_GUILD_REWARDS_ACHIEVEMENT_ICON..YELLOW_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE);
            end
        else
            local guildFactionData = C_Reputation.GetGuildFactionData()
            if guildFactionData and repLevel and repLevel > guildFactionData.reaction then
                local factionStandingtext = GetText("FACTION_STANDING_LABEL"..repLevel, gender)
                self.SubText:SetFormattedText('需要：|cffff0000%s|r', WoWTools_ChineseMixin:CN(factionStandingtext) or factionStandingtext)
            end
        end
    end)

    --奖励, 法术，GuildPerks.lua
    hooksecurefunc(CommunitiesGuildPerksButtonMixin, 'Init', function(self, data)
        local name= WoWTools_ChineseMixin:GetSpellName(self.spellID) or WoWTools_ChineseMixin:CN(GetGuildPerkInfo(data.index))
        if name then
            self.Name:SetText('|cff00adef'..name..'|r')
        end
    end)













    --信息 GuildNews.lua
    --GuildUtil.lua
    CommunitiesFrameGuildDetailsFrameInfo.TitleText:SetText('信息')
    WoWTools_ChineseMixin:SetLabel(CommunitiesFrameGuildDetailsFrameInfoHeader1Label)
    WoWTools_ChineseMixin:SetLabel(CommunitiesFrameGuildDetailsFrameInfo.Header2Label)

    for i=1, 4 do
        local btn= _G['CommunitiesFrameGuildDetailsFrameInfoChallenge'..i]
        WoWTools_ChineseMixin:HookLabel(btn and btn.label)
    end

    --WoWTools_ChineseMixin:SetLabel(CommunitiesFrameGuildDetailsFrameNews.TitleText)--公会新闻
    WoWTools_ChineseMixin:SetLabel(CommunitiesFrameGuildDetailsFrameNews.SetFiltersButton)
    WoWTools_ChineseMixin:SetRegions(CommunitiesFrameGuildDetailsFrameNews)
    --公会新闻过滤
    if CommunitiesGuildNewsFiltersFrame then--CommunitiesGuildNewsFiltersFrame_OnLoad
        WoWTools_ChineseMixin:SetLabel(CommunitiesGuildNewsFiltersFrame.Title)
        for _, filterButton in pairs(CommunitiesGuildNewsFiltersFrame.GuildNewsFilterButtons) do
            local name= WoWTools_ChineseMixin:CN(_G["GUILD_NEWS_FILTER"..filterButton:GetID()])
            if name then
                filterButton.Text:SetText(name);
            end
        end
    end

    --查看日志
    WoWTools_ChineseMixin:SetLabel(CommunitiesGuildLogFrameTitle)
    WoWTools_ChineseMixin:SetLabel(CommunitiesGuildLogFrameCloseButtonText)




--没测试
hooksecurefunc('GuildNewsButton_SetText', function(button, _, text, a, b, c, ...)
    text= WoWTools_ChineseMixin:CN(text) or text
    a, b, c= WoWTools_ChineseMixin:CN(a) or a, WoWTools_ChineseMixin:CN(b) or b, WoWTools_ChineseMixin:CN(c) or c
    button.text:SetFormattedText(text, a, b, c, ...)
end)




WoWTools_ChineseMixin:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.RemoveButton)
WoWTools_ChineseMixin:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.GroupInviteButton)
WoWTools_ChineseMixin:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.ZoneLabel)
WoWTools_ChineseMixin:HookLabel(CommunitiesFrame.GuildMemberDetailFrame.ZoneText)
WoWTools_ChineseMixin:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.RankLabel)
WoWTools_ChineseMixin:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.OnlineLabel)
WoWTools_ChineseMixin:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.NoteLabel)
WoWTools_ChineseMixin:HookLabel(CommunitiesFrame.GuildMemberDetailFrame.NoteBackground.PersonalNoteText)
WoWTools_ChineseMixin:HookLabel(CommunitiesFrame.GuildBenefitsFrame.FactionFrame.Bar.Label)

--成员列表，标题 CommunitiesMemberListEntryMixin
--[[hooksecurefunc(CommunitiesMemberListEntryMixin, 'Init', function(frame, elementData, expanded)
    local cn= WoWTools_ChineseMixin:CN(text)
    print(f, text)
    if cn then
        f.NameFrame.Name:SetText(cn)
    end
end)]]

--CommunitiesMemberList.lua
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Owner] = '拥有者'
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Leader] = '管理员'
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Moderator] = '协管员'
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Member] = '成员'
    hooksecurefunc(CommunitiesFrame.MemberList, 'UpdateMemberCount', function(self)
        local numOnlineMembers = 0
        for i, memberInfo in ipairs(self.allMemberList) do
            if memberInfo.presence == Enum.ClubMemberPresence.Online or
                memberInfo.presence == Enum.ClubMemberPresence.Away or
                memberInfo.presence == Enum.ClubMemberPresence.Busy then
                numOnlineMembers = numOnlineMembers + 1
            end
        end
        self.MemberCount:SetFormattedText('%s/%s人在线', AbbreviateNumbers(numOnlineMembers), AbbreviateNumbers(#self.allMemberList))
    end)

    CommunitiesFrame.MemberList.ShowOfflineButton.Text:SetText('显示离线成员')
    WoWTools_ChineseMixin:HookLabel(CommunitiesFrame.PostingExpirationText.ExpiredText)

CommunitiesFrame.MemberList.ColumnDisplay:HookScript('OnShow', function(frame)
    WoWTools_ChineseMixin:SetFrames(frame)
end)






WoWTools_ChineseMixin:SetLabel(CommunitiesFrame.StreamDropdown.Text)