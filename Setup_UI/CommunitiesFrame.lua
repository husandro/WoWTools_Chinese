
--公会和社区





function WoWTools_ChineseMixin.Events:Blizzard_Communities()



    CommunitiesFrameTitleText:SetText('公会与社区')
    CommunitiesFrame.AddToChatButton.Label:SetText('添加至聊天窗口')
    CommunitiesFrame.CommunitiesControlFrame.GuildRecruitmentButton:SetText('公会招募')
    CommunitiesFrame.InviteButton:SetText('邀请成员')
    CommunitiesFrame.CommunitiesControlFrame.GuildControlButton:SetText('公会设置')
    hooksecurefunc(CommunitiesFrame.CommunitiesControlFrame, 'Update', function(frame)
        if frame.CommunitiesSettingsButton:IsShown() then
            local communitiesFrame = frame:GetCommunitiesFrame()
            local clubId = communitiesFrame:GetSelectedClubId()
            if clubId then
                local clubInfo = C_Club.GetClubInfo(clubId)
                if clubInfo then
                    frame.CommunitiesSettingsButton:SetText(clubInfo.clubType == Enum.ClubType.BattleNet and '群组设置' or '社区设置')
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

    hooksecurefunc(CommunitiesFrame, 'UpdateCommunitiesButtons', function(frame)--CommunitiesFrameMixin
        local clubId = frame:GetSelectedClubId()
        local inviteButton = frame.InviteButton
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
                local privileges = frame:GetPrivilegesForClub(clubId)
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

    hooksecurefunc(CommunitiesFrame.TicketFrame, 'DisplayTicket', function(frame, ticketInfo)--CommunitiesTicketFrameMixin
        local clubInfo = ticketInfo.clubInfo
        frame.Type:SetText(clubInfo.clubType == Enum.ClubType.Character and '《魔兽世界》社区' or '暴雪群组')
        frame.MemberCount:SetFormattedText('成员：|cffffffff%d|r', clubInfo.memberCount or 1)
    end)
    hooksecurefunc(CommunitiesFrame.InvitationFrame, 'DisplayInvitation', function(frame)--CommunitiesInvitationFrame.lua
        local clubInfo = frame.invitationInfo.club
        local inviterInfo = frame.invitationInfo.inviter
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
        frame.InvitationText:SetFormattedText('%s邀请你加入', inviterText)
        frame.Type:SetText(isCharacterClub and '《魔兽世界》社区' or '暴雪群组')
        local leadersText = ""
        for i, leader in ipairs(frame.invitationInfo.leaders) do
            if leader.name then
                leadersText = leadersText..leader.name
                if i ~= #frame.invitationInfo.leaders then
                    leadersText = leadersText..', '
                end
            end
        end
        frame.Leader:SetFormattedText('管理员：|cffffffff%s|r', leadersText)
        frame.MemberCount:SetFormattedText('成员：|cffffffff%d|r', clubInfo.memberCount or 1)
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
        hooksecurefunc(ClubFinderGuildFinderFrame.InsetFrame.CommunityCards, 'BuildCardList', function(frame)--ClubFinderCommunitiesCardsMixin
            self:SetLabel(frame:GetParent().InsetFrame.GuildDescription)--('未发现结果。请修改你的搜索条件。')
        end)
        hooksecurefunc(ClubFinderGuildFinderFrame.InsetFrame.PendingCommunityCards, 'BuildCardList', function(frame)
            self:SetLabel(frame:GetParent().InsetFrame.GuildDescription)--('未发现结果。请修改你的搜索条件。')
        end)
    end

    hooksecurefunc(ClubFinderGuildFinderFrame, 'UpdateType', function(frame)-- ClubFinderGuildAndCommunityMixin:UpdateType()
        if (frame.isGuildType) then
            frame.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。\n\n使用此工具来寻找与你志同道合的公会吧。')
            if (#frame.PendingGuildCards.CardList > 0) then
                frame.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #frame.PendingGuildCards.CardList)
            else
                frame.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', 0)
            end
        else
            frame.InsetFrame.GuildDescription:SetText('选择搜索条件，然后按下“搜索”')
            if (#frame.PendingCommunityCards.CardList > 0) then
                frame.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #frame.PendingCommunityCards.CardList)
            else
                frame.ClubFinderPendingTab.tooltip = '等待确认中（0）'
            end
        end
    end)

    CommunitiesSettingsDialog:HookScript('OnShow', function(frame)
        if frame:GetClubType() == Enum.ClubType.BattleNet then
            frame.DialogLabel:SetText('创建暴雪群组')
        else
            frame.DialogLabel:SetText('创建《魔兽世界》社区')
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

    hooksecurefunc(CommunitiesFrame.ClubFinderInvitationFrame, 'DisplayInvitation', function(frame, clubInfo)--ClubFinderInvitationsFrameMixin
        if clubInfo then
            local isGuild = clubInfo.isGuild
            --frame.isLinkInvitation = isLinkInvitation
            if	(isGuild) then
                frame.Type:SetText('公会')
            else
                frame.Type:SetText('社区')
            end
            frame.Leader:SetFormattedText('管理员：|cffffffff%s|r', clubInfo.guildLeader)
            frame.MemberCount:SetFormattedText('成员：|cffffffff%d|r', clubInfo.numActiveMembers or 1)
            frame.InvitationText:SetFormattedText('%s邀请你加入', clubInfo.guildLeader)
        end
    end)

    hooksecurefunc(CommunitiesListEntryMixin, 'SetFindCommunity', function(frame)
        frame.Name:SetText('寻找社区')
    end)

        self:SetLabel(ClubFinderCommunityAndGuildFinderFrame.OptionsList.ClubFilterDropdown.Label)
        self:SetLabel(ClubFinderCommunityAndGuildFinderFrame.OptionsList.SortByDropdown.Label)
        self:HookLabel(ClubFinderCommunityAndGuildFinderFrame.OptionsList.ClubFilterDropdown.Text)
        self:HookLabel(ClubFinderCommunityAndGuildFinderFrame.OptionsList.SortByDropdown.Text)


        ClubFinderCommunityAndGuildFinderFrame.OptionsList.Search:SetText('搜索')
        ClubFinderGuildFinderFrame.OptionsList.Search:SetText('搜索')
        hooksecurefunc(ClubFinderCommunityAndGuildFinderFrame, 'UpdateType', function(frame)-- ClubFinderGuildAndCommunityMixin:UpdateType()
            if (frame.isGuildType) then
                frame.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。\n\n使用此工具来寻找与你志同道合的公会吧。')
                if (#frame.PendingGuildCards.CardList > 0) then
                    frame.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #frame.PendingGuildCards.CardList)
                else
                    frame.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', 0)
                end
            else
                frame.InsetFrame.GuildDescription:SetText('选择搜索条件，然后按下“搜索”')
                if (#frame.PendingCommunityCards.CardList > 0) then
                    frame.ClubFinderPendingTab.tooltip = format('等待确认中（%d）', #frame.PendingCommunityCards.CardList)
                else
                    frame.ClubFinderPendingTab.tooltip = '等待确认中（0）'
                end
            end
        end)
        hooksecurefunc(ClubFinderCommunityAndGuildFinderFrame.CommunityCards, 'BuildCardList', function(frame)
            frame:GetParent().InsetFrame.GuildDescription:SetText('未发现结果。请修改你的搜索条件。')
        end)
        ClubFinderCommunityAndGuildFinderFrame.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。|n|n使用此工具来寻找与你志同道合的公会吧。')
        self:SetLabel(ClubFinderGuildFinderFrame.InsetFrame.GuildDescription, '公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。|n|n使用此工具来寻找与你志同道合的公会吧。')
        self:SetLabel(ClubFinderGuildFinderFrame.OptionsList.ClubFilterDropdown.Label)
        ClubFinderGuildFinderFrame.OptionsList.ClubSizeDropdown.Label:SetText('规模')

        hooksecurefunc(ClubFinderCommunityAndGuildFinderFrame, 'GetDisplayModeBasedOnSelectedTab', function(frame)
            if (frame.isGuildType) then
                frame.InsetFrame.GuildDescription:SetText('公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。\n\n使用此工具来寻找与你志同道合的公会吧。')
            else
                frame.InsetFrame.GuildDescription:SetText('选择搜索条件，然后按下“搜索”')
            end
        end)
        ClubFinderGuildFinderFrame.InsetFrame:HookScript('OnShow', function(frame)--ClubFinder.xml
            local disabledReason = C_ClubFinder.GetClubFinderDisableReason()
            if disabledReason == Enum.ClubFinderDisableReason.Muted then
                frame.ErrorDescription:SetText(RED_FONT_COLOR:WrapTextInColorCode('因为你的战网账号的家长监控设定或者隐私设定，此功能处于关闭状态'))
            elseif disabledReason == Enum.ClubFinderDisableReason.Silenced then
                frame.ErrorDescription:SetText(RED_FONT_COLOR:WrapTextInColorCode('由于您的角色在游戏中存在发布不当内容的行为，导致您的账号受到了禁言处罚。被禁言期间，您无法使用此功能。'))
            end
        end)





    hooksecurefunc(CommunitiesListEntryMixin, 'SetAddCommunity', function(frame)
        frame.Name:SetText('加入或创建社区')
    end)
    hooksecurefunc(CommunitiesListEntryMixin, 'SetGuildFinder', function(frame)
        frame.Name:SetText('公会查找器')
    end)

    CommunitiesFrame.ClubFinderInvitationFrame.WarningDialog.Accept:SetText('接受')
    CommunitiesFrame.ClubFinderInvitationFrame.WarningDialog.Cancel:SetText('取消')
    CommunitiesFrame.ClubFinderInvitationFrame.WarningDialog:HookScript('OnShow', function(frame)
        if (IsInGuild()) then
            frame.DialogLabel:SetText('加入此公会时，你会|cnRED_FONT_COLOR:离开当前的公会|r。')
        else
            frame.DialogLabel:SetText('你只能加入一个公会。|n加入此公会时，|cnRED_FONT_COLOR:其他公会邀请会被移除。|r')
        end
    end)

    local function ClubFinderGetTotalNumSpecializations()
        local numClasses = GetNumClasses();
        local count = 0;
        for i = 1, numClasses do
            local _, _, classID = GetClassInfo(i);
            for i2 = 1, C_SpecializationInfo.GetNumSpecializationsForClassID(classID) do
                count = count + 1
            end
        end
        return count;
    end
    local function set_ClubFinderRequestToJoin(frame)
        if (not frame.info) then
            return
        end
        for check in pairs(frame.SpecsPool.activeObjects or {}) do
            self:SetLabel(check.SpecName)
        end

        local specIds = ClubFinderGetPlayerSpecIds()
        local matchingSpecNames = { }
        for _, specId in ipairs(specIds) do
            local _, name = GetSpecializationInfoForSpecID(specId)
            if (frame.card.recruitingSpecIds[specId]) then
                table.insert(matchingSpecNames, self:CN(name) or name)
            end
        end
        local classDisplayName = UnitClass("player")
        classDisplayName= self:CN(classDisplayName) or classDisplayName
        local isRecruitingAllSpecs = #frame.info.recruitingSpecIds == 0 or #frame.info.recruitingSpecIds == ClubFinderGetTotalNumSpecializations()
        if(isRecruitingAllSpecs) then
            if(frame.info.isGuild) then
                frame.RecruitingSpecDescriptions:SetText('此公会正在招募所有的专精类型。')
            else
                frame.RecruitingSpecDescriptions:SetText('此社区正在招募所有的专精类型。')
            end
        elseif (#matchingSpecNames == 1) then
            frame.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s %s。你玩的是哪个专精？', matchingSpecNames[1], classDisplayName)
        elseif (#matchingSpecNames == 2) then
            frame.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s和%s %s。你玩的是哪个专精？', matchingSpecNames[1], matchingSpecNames[2], classDisplayName)
        elseif (#matchingSpecNames == 3) then
            frame.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s %s和%s %s。你玩的是哪个专精？', matchingSpecNames[1], matchingSpecNames[2], matchingSpecNames[3], classDisplayName)
        elseif (#matchingSpecNames == 4) then
            frame.RecruitingSpecDescriptions:SetFormattedText('此公会正在寻找%s %s %s和%s %s。你玩的是哪个专精？', matchingSpecNames[1], matchingSpecNames[2], matchingSpecNames[3], matchingSpecNames[4], classDisplayName)
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


    hooksecurefunc(ClubsFinderJoinClubWarningMixin, 'OnShow', function(frame)--没测试
        if (IsInGuild()) then
            frame.DialogLabel:SetText('加入此公会时，你会离开当前的公会。')
        else
            frame.DialogLabel:SetText('你只能加入一个公会。加入此公会时，其他公会邀请会被移除。')
        end
    end)










    --奖励, 物品，GuildRewards.lua
    hooksecurefunc(CommunitiesGuildRewardsButtonMixin, 'Init', function(frame)
        local achievementID, itemID, itemName, _, repLevel = GetGuildRewardInfo(frame.index)
        local name= self:GetItemName(itemID) or self:CN(itemName)
        if name then
            frame.Name:SetText(name);
        end

        if ( achievementID and achievementID > 0 ) then
            name = select(2, GetAchievementInfo(achievementID))
            name= self:CN(name)
            if name then
                frame.SubText:SetText('需要：'..COMMUNITIES_GUILD_REWARDS_ACHIEVEMENT_ICON..YELLOW_FONT_COLOR_CODE..name..FONT_COLOR_CODE_CLOSE);
            end
        else
            local guildFactionData = C_Reputation.GetGuildFactionData()
            if guildFactionData and repLevel and repLevel > guildFactionData.reaction then
                local factionStandingtext = GetText("FACTION_STANDING_LABEL"..repLevel, gender)
                frame.SubText:SetFormattedText('需要：|cffff0000%s|r', self:CN(factionStandingtext) or factionStandingtext)
            end
        end
    end)

    --奖励, 法术，GuildPerks.lua
    hooksecurefunc(CommunitiesGuildPerksButtonMixin, 'Init', function(frame, data)
        local name= self:GetSpellName(frame.spellID) or self:CN(GetGuildPerkInfo(data.index))
        if name then
            frame.Name:SetText('|cff00adef'..name..'|r')
        end
    end)













    --信息 GuildNews.lua
    --GuildUtil.lua
    CommunitiesFrameGuildDetailsFrameInfo.TitleText:SetText('信息')
    self:SetLabel(CommunitiesFrameGuildDetailsFrameInfoHeader1Label)
    self:SetLabel(CommunitiesFrameGuildDetailsFrameInfo.Header2Label)

    for i=1, 4 do
        local btn= _G['CommunitiesFrameGuildDetailsFrameInfoChallenge'..i]
        self:HookLabel(btn and btn.label)
    end

    --self:SetLabel(CommunitiesFrameGuildDetailsFrameNews.TitleText)--公会新闻
    self:SetLabel(CommunitiesFrameGuildDetailsFrameNews.SetFiltersButton)
    self:SetRegions(CommunitiesFrameGuildDetailsFrameNews)
    --公会新闻过滤
    if CommunitiesGuildNewsFiltersFrame then--CommunitiesGuildNewsFiltersFrame_OnLoad
        self:SetLabel(CommunitiesGuildNewsFiltersFrame.Title)
        for _, filterButton in pairs(CommunitiesGuildNewsFiltersFrame.GuildNewsFilterButtons) do
            local name= self:CN(_G["GUILD_NEWS_FILTER"..filterButton:GetID()])
            if name then
                filterButton.Text:SetText(name);
            end
        end
    end

    --查看日志
    self:SetLabel(CommunitiesGuildLogFrameTitle)
    self:SetLabel(CommunitiesGuildLogFrameCloseButtonText)




--没测试
hooksecurefunc('GuildNewsButton_SetText', function(button, _, text, a, b, c, ...)
    text= self:CN(text) or text
    a, b, c= self:CN(a) or a, self:CN(b) or b, self:CN(c) or c
    button.text:SetFormattedText(text, a, b, c, ...)
end)




self:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.RemoveButton)
self:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.GroupInviteButton)
self:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.ZoneLabel)
self:HookLabel(CommunitiesFrame.GuildMemberDetailFrame.ZoneText)
self:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.RankLabel)
self:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.OnlineLabel)
self:SetLabel(CommunitiesFrame.GuildMemberDetailFrame.NoteLabel)
self:HookLabel(CommunitiesFrame.GuildMemberDetailFrame.NoteBackground.PersonalNoteText)
self:HookLabel(CommunitiesFrame.GuildBenefitsFrame.FactionFrame.Bar.Label)

--成员列表，标题 CommunitiesMemberListEntryMixin
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Owner] = '拥有者'
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Leader] = '管理员'
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Moderator] = '协管员'
    COMMUNITY_MEMBER_ROLE_NAMES[Enum.ClubRoleIdentifier.Member] = '成员'
    hooksecurefunc(CommunitiesFrame.MemberList, 'UpdateMemberCount', function(frame)
        local numOnlineMembers = 0
        for i, memberInfo in ipairs(frame.allMemberList) do
            if memberInfo.presence == Enum.ClubMemberPresence.Online or
                memberInfo.presence == Enum.ClubMemberPresence.Away or
                memberInfo.presence == Enum.ClubMemberPresence.Busy then
                numOnlineMembers = numOnlineMembers + 1
            end
        end
        frame.MemberCount:SetFormattedText('%s/%s人在线', AbbreviateNumbers(numOnlineMembers), AbbreviateNumbers(#frame.allMemberList))
    end)

    CommunitiesFrame.MemberList.ShowOfflineButton.Text:SetText('显示离线成员')

    self:HookLabel(CommunitiesFrame.PostingExpirationText.ExpiredText)--11.2没有了
    self:HookLabel(CommunitiesFrame.PostingExpirationText.ExpirationTimeText)
    self:HookLabel(ClubFinderGuildFinderFrame.OptionsList.PendingTextFrame.Text)
    self:HookLabel(ClubFinderGuildFinderFrame.InsetFrame.GuildDescription)
    self:HookLabel(ClubFinderGuildFinderFrame.OptionsList.ClubFilterDropdown.Text)
    self:HookLabel(ClubFinderGuildFinderFrame.OptionsList.ClubSizeDropdown.Text)
    self:SetLabel(ClubFinderGuildFinderFrame.OptionsList.SearchBox.Instructions)
    self:SetLabel(ClubFinderCommunityAndGuildFinderFrame.OptionsList.SearchBox.Instructions)



    CommunitiesFrame.MemberList.ColumnDisplay:HookScript('OnShow', function(frame)
        self:SetFrames(frame)
    end)






    self:HookLabel(CommunitiesFrame.StreamDropdown.Text)



end

