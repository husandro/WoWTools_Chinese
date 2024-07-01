local id, e = ...





local function Init_Event(arg1)
    if arg1=='Blizzard_ClassTalentUI' then
         for _, tabID in pairs(ClassTalentFrame:GetTabSet() or {}) do
            local btn= ClassTalentFrame:GetTabButton(tabID)
            if tabID==1 then
                btn:SetText('专精')
            elseif tabID==2 then
                btn:SetText('天赋')
            end
        end

        --Blizzard_ClassTalentTalentsTab.lua
        ClassTalentFrame.TalentsTab.ApplyButton:SetText('应用改动')
        ClassTalentFrame.TalentsTab.SearchBox.Instructions:SetText('搜索')
        hooksecurefunc(ClassTalentFrame.TalentsTab.ApplyButton, 'SetDisabledTooltip', function(self, canChangeError)
            if canChangeError then
                if canChangeError ==  TALENT_FRAME_REFUND_INVALID_ERROR  then
                    self.disabledTooltip = '你必须修复所有错误。忘却天赋来释放点数，并在其他地方花费这些点数来构建可用的配置。'
                elseif canChangeError== ERR_TALENT_FAILED_UNSPENT_TALENT_POINTS then
                    self.disabledTooltip= '你必须花费所有可用的天赋点才能应用改动'
                end
            end
        end)
        ClassTalentFrame.TalentsTab.ApplyButton:HookScript('OnEnter', function()
        end)
        hooksecurefunc(ClassTalentFrame.TalentsTab.ClassCurrencyDisplay, 'SetPointTypeText', function(self, text)
            self.CurrencyLabel:SetFormattedText('%s 可用点数', e.strText[ClassTalentFrame.TalentsTab:GetClassName()] or text)
        end)
        hooksecurefunc(ClassTalentFrame.TalentsTab.SpecCurrencyDisplay, 'SetPointTypeText', function(self, text)
            self.CurrencyLabel:SetFormattedText('%s 可用点数', e.strText[ClassTalentFrame.TalentsTab:GetSpecName()] or text)
        end)
        ClassTalentFrame.TalentsTab.InspectCopyButton:SetTextToFit('复制配置代码')

        if ClassTalentFrame.SpecTab.numSpecs and ClassTalentFrame.SpecTab.numSpecs>0 and ClassTalentFrame.SpecTab.SpecContentFramePool then
            local sex= UnitSex("player")
            local SPEC_STAT_STRINGS = {
                [LE_UNIT_STAT_STRENGTH] = '力量',
                [LE_UNIT_STAT_AGILITY] = '敏捷',
                [LE_UNIT_STAT_INTELLECT] = '智力',
            }
            for frame in pairs(ClassTalentFrame.SpecTab.SpecContentFramePool.activeObjects or {}) do
                frame.ActivatedText:SetText('激活')
                frame.ActivateButton:SetText('激活')
                if frame.RoleName then
                    e.set(frame.RoleName, frame.RoleName:GetText())
                end
                frame.SampleAbilityText:SetText('典型技能')
                if frame.specIndex then
                    local specID, name, description, _, _, primaryStat = GetSpecializationInfo(frame.specIndex, false, false, nil, sex)
                    if specID and primaryStat and primaryStat ~= 0 then
                        e.set(frame.Description, (e.cn(description) or '').."|n"..format('主要属性：%s', SPEC_STAT_STRINGS[primaryStat]))
                    end
                    if frame.SpecName then
                        e.set(frame.SpecName, name)
                    end
                end

            end
        end

        ClassTalentFrame.TalentsTab.UndoButton.tooltipText= '取消待定改动'
        --Blizzard_WarmodeButtonTemplate.lua
        ClassTalentFrame.TalentsTab.WarmodeButton:HookScript('OnEnter', function(self)
            --GameTooltip:SetOwner(self, "ANCHOR_LEFT", 14, 0)
            GameTooltip:AddLine(' ')
            GameTooltip:AddLine('战争模式')
            --GameTooltip_SetTitle(GameTooltip, '战争模式')
            if C_PvP.IsWarModeActive() or self:GetWarModeDesired() then
                GameTooltip_AddInstructionLine(GameTooltip, '|cnGREEN_FONT_COLOR:开启')
            end
            local wrap = true
            local warModeRewardBonus = C_PvP.GetWarModeRewardBonus()
            GameTooltip_AddNormalLine(GameTooltip, format('加入战争模式即可激活世界PvP，使任务的奖励和经验值提高%1$d%%，并可以在野外使用PvP天赋。', warModeRewardBonus), wrap)
            local canToggleWarmode = C_PvP.CanToggleWarMode(true)
            local canToggleWarmodeOFF = C_PvP.CanToggleWarMode(false)

            if(not canToggleWarmode or not canToggleWarmodeOFF) then
                if (not C_PvP.ArePvpTalentsUnlocked()) then
                    GameTooltip_AddErrorLine(GameTooltip, format('|cnRED_FONT_COLOR:在%d级解锁', C_PvP.GetPvpTalentsUnlockedLevel()), wrap)
                else
                    local warmodeErrorText
                    if(not C_PvP.CanToggleWarModeInArea()) then
                        if(self:GetWarModeDesired()) then
                            if(not canToggleWarmodeOFF and not IsResting()) then
                                warmodeErrorText = UnitFactionGroup("player") == PLAYER_FACTION_GROUP[0] and '战争模式可以在任何休息区域关闭，但只能在奥格瑞玛或瓦德拉肯开启。' or '战争模式可以在任何休息区域关闭，但只能在暴风城或瓦德拉肯开启。'
                            end
                        else
                            if(not canToggleWarmode) then
                                warmodeErrorText = UnitFactionGroup("player") == PLAYER_FACTION_GROUP[0] and '只能在奥格瑞玛或瓦德拉肯进入战争模式。' or '只能在暴风城或瓦德拉肯进入战争模式。'
                            end
                        end
                    end
                    if(warmodeErrorText) then
                        GameTooltip_AddErrorLine(GameTooltip, '|cnRED_FONT_COLOR:'..warmodeErrorText, wrap)
                    elseif (UnitAffectingCombat("player")) then
                        GameTooltip_AddErrorLine(GameTooltip, '|cnRED_FONT_COLOR:你正处于交战状态', wrap)
                    end
                end
            end
            GameTooltip:Show()
        end)

        e.dia("CONFIRM_LEARN_SPEC", {button1 = '是', button2 = '否',})
        e.hookDia("CONFIRM_LEARN_SPEC", 'OnShow', function(self)
            if (self.data.previewSpecCost and self.data.previewSpecCost > 0) then
                self.text:SetFormattedText('激活此专精需要花费%s。确定要学习此专精吗？', GetMoneyString(self.data.previewSpecCost))
            else
                self.text:SetText('你确定要学习这种天赋专精吗？')
            end
        end)

        e.dia("CONFIRM_EXIT_WITH_UNSPENT_TALENT_POINTS", {text = '你还有未分配的天赋。你确定要关闭这个窗口？', button1 = '是', button2 = '否'})

        hooksecurefunc(ClassTalentFrame, 'UpdateFrameTitle', function(self)
            local tabID = self:GetTab()
            if self:IsInspecting() then
                local inspectUnit = self:GetInspectUnit()
                if inspectUnit then
                    self:SetTitle(format('天赋 - %s', UnitName(self:GetInspectUnit())))
                else
                    self:SetTitle(format('天赋链接 (%s %s)', self:GetSpecName(), self:GetClassName()))
                end
            elseif tabID == self.specTabID then
                self:SetTitle('专精')
            else -- tabID == self.talentTabID
                self:SetTitle('天赋')
            end
        end)

        --Blizzard_ClassTalentLoadoutEditDialog.lua
        e.dia("LOADOUT_CONFIRM_DELETE_DIALOG", {text = '你确定要删除配置%s吗？', button1 = '删除', button2 = '取消'})
        e.dia("LOADOUT_CONFIRM_SHARED_ACTION_BARS", {text = '此配置的动作条会被你共享的动作条替换。', button1 = '接受', button2 = '取消'})
        ClassTalentLoadoutEditDialog.UsesSharedActionBars:HookScript('OnEnter', function()
            GameTooltip:AddLine(' ')
            GameTooltip_AddNormalLine(GameTooltip, '默认条件下，每个配置都有自己保存的一套动作条。\n\n所有开启此选项的配置都会共享同样的动作条。')
            GameTooltip:Show()
        end)

        --Blizzard_ClassTalentLoadoutImportDialog.xml
        ClassTalentLoadoutImportDialog.Title:SetText('导入配置')
        ClassTalentLoadoutImportDialog.ImportControl.Label:SetText('导入文本')
        ClassTalentLoadoutImportDialog.ImportControl.InputContainer.EditBox.Instructions:SetText('在此粘贴配置代码')
        ClassTalentLoadoutImportDialog.NameControl.Label:SetText('新配置名称')
        ClassTalentLoadoutImportDialog.AcceptButton:SetText('导入')
        ClassTalentLoadoutImportDialog.CancelButton:SetText('取消')
        ClassTalentLoadoutImportDialog.AcceptButton.disabledTooltip = '输入可用的配置代码'

        --Blizzard_ClassTalentLoadoutEditDialog.xml
        ClassTalentLoadoutEditDialog.Title:SetText('配置设定')
        ClassTalentLoadoutEditDialog.NameControl.Label:SetText('名字')
        ClassTalentLoadoutEditDialog.UsesSharedActionBars.Label:SetText('使用共享的动作条')
        ClassTalentLoadoutEditDialog.AcceptButton:SetText('接受')
        ClassTalentLoadoutEditDialog.DeleteButton:SetText('删除')
        ClassTalentLoadoutEditDialog.CancelButton:SetText('取消')

        --Blizzard_ClassTalentLoadoutCreateDialog.xml
        ClassTalentLoadoutCreateDialog.Title:SetText('新配置')
        ClassTalentLoadoutCreateDialog.NameControl.Label:SetText('名字')
        ClassTalentLoadoutCreateDialog.AcceptButton:SetText('保存')
        ClassTalentLoadoutCreateDialog.CancelButton:SetText('取消')



























    elseif arg1=='Blizzard_MacroUI' then
        MacroFrameTab1:SetText('通用宏')
        MacroFrameTab2:SetText('专用宏', 0.3)
        MacroSaveButton:SetText('保存')
        MacroCancelButton:SetText('取消')
        MacroDeleteButton:SetText('删除')
        MacroNewButton:SetText('新建')
        MacroExitButton:SetText('退出')

        e.dia("CONFIRM_DELETE_SELECTED_MACRO", {text= '确定要删除这个宏吗？', button1= '是', button2= '取消'})










    elseif arg1=='Blizzard_Communities' then--公会和社区
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
        ClubFinderClubFocusDropdown.Label:SetText('活动倾向')

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
        CommunitiesFrame.GuildBenefitsFrame.Rewards.TitleText:SetText('公会奖励')
        CommunitiesFrame.GuildBenefitsFrame.GuildRewardsTutorialButton:HookScript('OnEnter', function()--GuildRewards.xml
            GameTooltip:SetText('访问任一主城中的公会商人以购买奖励', nil, nil, nil, nil, true)
            GameTooltip:Show()
        end)
        CommunitiesFrame.GuildBenefitsFrame.GuildAchievementPointDisplay:HookScript('OnEnter', function()--GuildRewards.lua
            GameTooltip_SetTitle(GameTooltip, '公会成就')
	        GameTooltip:Show()
        end)

        CommunitiesFrameGuildDetailsFrameInfo.TitleText:SetText('信息')

        hooksecurefunc(ClubFinderGuildFinderFrame.InsetFrame.CommunityCards, 'BuildCardList', function(self)--ClubFinderCommunitiesCardsMixin
            self:GetParent().InsetFrame.GuildDescription:SetText('未发现结果。请修改你的搜索条件。')
        end)
        hooksecurefunc(ClubFinderGuildFinderFrame.InsetFrame.PendingCommunityCards, 'BuildCardList', function(self)
            self:GetParent().InsetFrame.GuildDescription:SetText('未发现结果。请修改你的搜索条件。')
        end)
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
            e.set(ClubFinderSizeDropdown.Label)
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
            --set(ClubFinderGuildFinderFrame.InsetFrame.GuildDescription, '公会是由许多关系紧密，想要一起享受游戏乐趣的玩家组成的群体。加入公会后，你可以享受许多福利，包括分享公会银行，以及公会聊天频道。|n|n使用此工具来寻找与你志同道合的公会吧。')

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
                e.set(check.SpecName)
            end

            local specIds = ClubFinderGetPlayerSpecIds()
            local matchingSpecNames = { }
            for i, specId in ipairs(specIds) do
                local _, name = GetSpecializationInfoForSpecID(specId)
                if (self.card.recruitingSpecIds[specId]) then
                    table.insert(matchingSpecNames, e.cn(name))
                end
            end
            local classDisplayName = UnitClass("player")
            classDisplayName= e.cn(classDisplayName)
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











    elseif arg1=="Blizzard_GuildBankUI" then--公会银行
        GuildBankFrameTab1:SetText('公会银行')
            GuildItemSearchBox.Instructions:SetText('搜索')
            GuildBankFrame.WithdrawButton:SetText('提取')
            GuildBankFrame.DepositButton:SetText('存放')
            GuildBankMoneyLimitLabel:SetText('可用数量：')
            hooksecurefunc(GuildBankFrame, 'UpdateTabs', function(self)--Blizzard_GuildBankUI.lua
                local name, isViewable, canDeposit, numWithdrawals, remainingWithdrawals, disableAll, titleText, withdrawalText
                local numTabs = GetNumGuildBankTabs()
                local currentTab = GetCurrentGuildBankTab()
                -- Set buyable tab
                local tabToBuyIndex
                if ( numTabs < MAX_BUY_GUILDBANK_TABS ) then
                    tabToBuyIndex = numTabs + 1
                end
                -- Disable and gray out all tabs if in the moneyLog since the tab is irrelevant
                if ( self.mode == "moneylog" ) then
                    disableAll = 1
                end
                for i=1, MAX_GUILDBANK_TABS do
                    local tab = self.BankTabs[i]
                    local tabButton = tab.Button
                    name, _, isViewable = GetGuildBankTabInfo(i)
                    if ( not name or name == "" ) then
                        name = format('标签%d', i)
                    end
                    if ( i == tabToBuyIndex and IsGuildLeader() ) then
                        tabButton.tooltip = '购买新的公会银行标签'
                        if ( disableAll or self.mode == "log" or self.mode == "tabinfo" ) then
                        else
                            if ( i == currentTab ) then
                                titleText = '购买新的公会银行标签'
                            end
                        end
                    elseif ( i > numTabs ) then
                    else
                        if ( isViewable ) then
                            if ( i == currentTab ) then
                                withdrawalText = name
                                titleText =  name
                            end
                        end
                    end
                end

                -- Set Title
                if ( self.mode == "moneylog" ) then
                    titleText = '金币记录'
                    withdrawalText = nil
                elseif ( self.mode == "log" ) then
                    if ( titleText ) then
                        titleText = format('%s 记录', titleText)
                    end
                elseif ( self.mode == "tabinfo" ) then
                    withdrawalText = nil
                    if ( titleText ) then
                        titleText = format('%s 信息', titleText)
                    end
                end
                -- Get selected tab info
                name, _, _, canDeposit, numWithdrawals, remainingWithdrawals = GetGuildBankTabInfo(currentTab)
                if ( titleText and (self.mode ~= "moneylog" and titleText ~= BUY_GUILDBANK_TAB) ) then
                    local access
                    if ( not canDeposit and numWithdrawals == 0 ) then
                        access = '|cffff2020（锁定）|r'
                    elseif ( not canDeposit ) then
                        access = '|cffff2020（只能提取）|r'
                    elseif ( numWithdrawals == 0 ) then
                        access = '|cffff2020（只能存放）|r'
                    else
                        access = '|cff20ff20（全部权限）|r'
                    end
                    titleText = titleText.."  "..access
                end
                if ( titleText ) then
                    self.TabTitle:SetText(titleText)
                end
                if ( withdrawalText ) then
                    local stackString
                    if ( remainingWithdrawals > 0 ) then
                        stackString = format('%d 堆', remainingWithdrawals)
                    elseif ( remainingWithdrawals == 0 ) then
                        stackString = '无'
                    else
                        stackString = '无限'
                    end
                    self.LimitLabel:SetText(format('%s的每日提取额度剩余：|cffffffff%s|r', withdrawalText, stackString))
                end
            end)
        GuildBankFrameTab2:SetText('记录')
        GuildBankFrameTab3:SetText('金币记录')
        GuildBankFrameTab4:SetText('信息')
            GuildBankInfoSaveButton:SetText('保存改变')














    elseif arg1=='Blizzard_InspectUI' then--玩家, 观察角色, 界面
        InspectFrameTab1:SetText('角色')
        --pvp
            hooksecurefunc('InspectPVPFrame_Update', function()
                local _, _, _, _, lifetimeHKs, _, honorLevel = GetInspectHonorData()
                InspectPVPFrame.HKs:SetFormattedText('|cffffd200荣誉消灭：|r %d', lifetimeHKs or 0)
                if C_SpecializationInfo.CanPlayerUsePVPTalentUI() then
                    InspectPVPFrame.HonorLevel:SetFormattedText('荣誉等级：%d', honorLevel)
                end
            end)
        InspectFrameTab3:SetText('公会')




















    elseif arg1=='Blizzard_PVPUI' then--地下城和团队副本, PVP
        hooksecurefunc('PVPQueueFrame_UpdateTitle', function()--Blizzard_PVPUI.lua
            if ConquestFrame.seasonState == 2 then--SEASON_STATE_PRESEASON
                PVEFrame:SetTitle('PvP（季前赛）')
            elseif ConquestFrame.seasonState == 1 then--SEASON_STATE_OFFSEASON
                PVEFrame:SetTitle('玩家VS玩家（休赛期）')
            else
                local expName = _G["EXPANSION_NAME"..GetExpansionLevel()]
                PVEFrame:SetTitleFormatted('玩家VS玩家 '..(e.strText[expName] or expName)..' 第 %d 赛季', PVPUtil.GetCurrentSeasonNumber())
            end
        end)
        PVPQueueFrameCategoryButton1.Name:SetText('快速比赛')
            hooksecurefunc('HonorFrameBonusFrame_Update', function()--Blizzard_PVPUI.lua
                HonorFrame.BonusFrame.RandomBGButton.Title:SetText('随机战场')
                HonorFrame.BonusFrame.RandomEpicBGButton.Title:SetText('随机史诗战场')
                HonorFrame.BonusFrame.Arena1Button.Title:SetText('竞技场练习赛')
            end)
        PVPQueueFrameCategoryButton2.Name:SetText('评级')
        PVPQueueFrameCategoryButton3.Name:SetText('预创建队伍')
        PVPQueueFrame.NewSeasonPopup.Leave:SetText('关闭')

        hooksecurefunc('HonorFrame_UpdateQueueButtons', function()
            local HonorFrame = HonorFrame
            local canQueue
            local arenaID
            local isBrawl
            local isSpecialBrawl
            if ( HonorFrame.type == "specific" ) then
                if ( HonorFrame.SpecificScrollBox.selectionID ) then
                    canQueue = true
                end
            elseif ( HonorFrame.type == "bonus" ) then
                if ( HonorFrame.BonusFrame.selectedButton ) then
                    canQueue = HonorFrame.BonusFrame.selectedButton.canQueue
                    arenaID = HonorFrame.BonusFrame.selectedButton.arenaID
                    isBrawl = HonorFrame.BonusFrame.selectedButton.isBrawl
                    isSpecialBrawl = HonorFrame.BonusFrame.selectedButton.isSpecialBrawl
                end
            end

            local disabledReason

            if arenaID then
                local battlemasterListInfo = C_PvP.GetSkirmishInfo(arenaID)
                if battlemasterListInfo then
                    local groupSize = GetNumGroupMembers()
                    local minPlayers = battlemasterListInfo.minPlayers
                    local maxPlayers = battlemasterListInfo.maxPlayers
                    if groupSize > maxPlayers then
                        canQueue = false
                        disabledReason = format('要进入该竞技场，你的团队需要减少%d名玩家。', groupSize - maxPlayers)
                    elseif groupSize < minPlayers then
                        canQueue = false
                        disabledReason = format('要进入该竞技场，你的团队需要增加%d名玩家。', minPlayers - groupSize)
                    end
                end
            end

            if (isBrawl or isSpecialBrawl) and not canQueue then
                if IsInGroup(LE_PARTY_CATEGORY_HOME) then
                    local brawlInfo = isSpecialBrawl and C_PvP.GetSpecialEventBrawlInfo() or C_PvP.GetAvailableBrawlInfo() or {}
                    if brawlInfo then
                        disabledReason = format('你的小队未满足最低等级要求（%s）。', isSpecialBrawl and brawlInfo.minLevel or GetMaxLevelForPlayerExpansion())
                    end
                else
                    disabledReason = '你的级别不够。'
                end
            end

            if isBrawl or isSpecialBrawl and canQueue then
                local brawlInfo = isSpecialBrawl and C_PvP.GetSpecialEventBrawlInfo() or C_PvP.GetAvailableBrawlInfo() or {}
                local brawlHasMinItemLevelRequirement = brawlInfo and brawlInfo.brawlType == Enum.BrawlType.SoloRbg
                if (IsInGroup(LE_PARTY_CATEGORY_HOME)) then
                    if(brawlInfo and not brawlInfo.groupsAllowed) then
                        canQueue = false
                        disabledReason = '你不能在队伍中那样做。'
                    end
                    if (brawlHasMinItemLevelRequirement and brawlInfo.groupsAllowed) then
                        local brawlMinItemLevel = brawlInfo.minItemLevel
                        local partyMinItemLevel, playerWithLowestItemLevel = C_PartyInfo.GetMinItemLevel(Enum.AvgItemLevelCategories.PvP)
                        if (UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) and partyMinItemLevel < brawlMinItemLevel) then
                            canQueue = false
                            disabledReason = format('"%1$s需要更高的平均装备物品等级。（需要：%2$d。当前%3$d。）', playerWithLowestItemLevel, brawlMinItemLevel, partyMinItemLevel)
                        end
                    end
                end
                local _, _, playerPvPItemLevel = GetAverageItemLevel()
                if (brawlHasMinItemLevelRequirement and playerPvPItemLevel < brawlInfo.minItemLevel) then
                    canQueue = false
                    disabledReason = format('你需要更高的PvP装备物品平均等级才能加入队列。|n（需要 %2$d，当前%3$d。）', brawlInfo.minItemLevel, playerPvPItemLevel)
                end
            end
            if not disabledReason then
                if ( select(2,C_LFGList.GetNumApplications()) > 0 ) then
                    disabledReason = '你不能在拥有有效的预创建队伍申请时那样做。'
                    canQueue = false
                elseif ( C_LFGList.HasActiveEntryInfo() ) then
                    disabledReason = '你不能在你的队伍出现在预创建队伍列表中时那样做。'
                    canQueue = false
                end
            end
            local isInCrossFactionGroup = C_PartyInfo.IsCrossFactionParty()
            if ( canQueue ) then
                if ( IsInGroup(LE_PARTY_CATEGORY_HOME) ) then
                    HonorFrame.QueueButton:SetText('小队加入')
                    if (not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME)) then
                        disabledReason = '你现在不是队长'
                    elseif(isInCrossFactionGroup) then
                        if isBrawl or isSpecialBrawl then
                            local brawlInfo = isSpecialBrawl and C_PvP.GetSpecialEventBrawlInfo() or C_PvP.GetAvailableBrawlInfo()
                            local allowCrossFactionGroups = brawlInfo and brawlInfo.brawlType == Enum.BrawlType.SoloRbg
                            if (not allowCrossFactionGroups) then
                                disabledReason ='在跨阵营队伍中无法这么做。你可以参加竞技场或者评级战场。'
                            end
                        end
                    end
                else
                    HonorFrame.QueueButton:SetText('加入战斗')
                end
            else
                if (HonorFrame.type == "bonus" and HonorFrame.BonusFrame.selectedButton and HonorFrame.BonusFrame.selectedButton.queueID) then
                    if not disabledReason then
                        disabledReason = LFGConstructDeclinedMessage(HonorFrame.BonusFrame.selectedButton.queueID)
                    end
                end
            end
            HonorFrame.QueueButton.tooltip = disabledReason
        end)

        hooksecurefunc('PVPConquestLockTooltipShow', function()
            GameTooltip:SetText(string.format('该功能将在%d级开启。', GetMaxLevelForLatestExpansion()))
            GameTooltip:Show()
        end)

        PVPQueueFrame.HonorInset.CasualPanel:HookScript('OnShow', function(self)
            if self.HKLabel:IsShown() then
                self.HKLabel:SetText('宏伟宝库')
            end
        end)
        PVPQueueFrame.HonorInset.CasualPanel.HKLabel:SetText('宏伟宝库')
        PVPQueueFrame.HonorInset.CasualPanel.WeeklyChest:HookScript('OnEnter', function()
            if not ConquestFrame_HasActiveSeason() then
                GameTooltip_SetTitle(GameTooltip, '宏伟宝库奖励')
                GameTooltip_AddDisabledLine(GameTooltip, '无效会阶')
                GameTooltip_AddNormalLine(GameTooltip, '征服点数只能在PvP赛季开启期间获得。')
                GameTooltip:Show()
            else
                local weeklyProgress = C_WeeklyRewards.GetConquestWeeklyProgress()
                local unlocksCompleted = weeklyProgress.unlocksCompleted or 0
                local maxUnlocks = weeklyProgress.maxUnlocks or 3
                local description
                if unlocksCompleted > 0 then
                    description = format('通过评级PvP获得获得荣誉点数以解锁宏伟宝库的奖励。你的奖励的物品等级会以你本周胜场的最高段位为基准。\n\n%s/%s奖励已解锁。', unlocksCompleted, maxUnlocks)
                else
                    description = format('通过评级PvP获得获得荣誉点数以解锁宏伟宝库的奖励。你的奖励的物品等级会以你本周胜场的最高段位为基准。\n\n%s/%s奖励已解锁。', unlocksCompleted, maxUnlocks)
                end
                GameTooltip_SetTitle(GameTooltip, '宏伟宝库奖励')
                local hasRewards = C_WeeklyRewards.HasAvailableRewards()
                if hasRewards then
                    GameTooltip_AddColoredLine(GameTooltip, '宏伟宝库里有奖励在等待着你。', GREEN_FONT_COLOR)
                    GameTooltip_AddBlankLineToTooltip(GameTooltip)
                end
                GameTooltip_AddNormalLine(GameTooltip, description)
                GameTooltip_AddInstructionLine(GameTooltip, '点击预览宏伟宝库')
                GameTooltip:Show()
            end
        end)

        hooksecurefunc(PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay, 'Update', function(self)
            local honorLevel = UnitHonorLevel("player")
	        self.LevelLabel:SetFormattedText('荣誉等级 %d', honorLevel)
        end)
        PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay:HookScript('OnEnter', function()
            GameTooltip_SetTitle(GameTooltip, '生涯荣誉')
            GameTooltip_AddColoredLine(GameTooltip, '所有角色获得的荣誉。', NORMAL_FONT_COLOR)
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            local currentHonor = UnitHonor("player")
            local maxHonor = UnitHonorMax("player")
            GameTooltip_AddColoredLine(GameTooltip, string.format('%d / %d', currentHonor, maxHonor), HIGHLIGHT_FONT_COLOR)
            GameTooltip:Show()
        end)
        PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay.NextRewardLevel:HookScript('OnEnter', function(self)
            local honorLevel = UnitHonorLevel("player")
            local nextHonorLevelForReward = C_PvP.GetNextHonorLevelForReward(honorLevel)
            local rewardInfo = nextHonorLevelForReward and C_PvP.GetHonorRewardInfo(nextHonorLevelForReward)
            if rewardInfo then
                local rewardText = select(11, GetAchievementInfo(rewardInfo.achievementRewardedID))
                if rewardText and rewardText ~= "" then
                    GameTooltip:SetText(format('到达荣誉等级%d级后可获得下一个奖励', nextHonorLevelForReward))
                    local WRAP = true
                    GameTooltip_AddColoredLine(GameTooltip, rewardText, HIGHLIGHT_FONT_COLOR, WRAP)
                    GameTooltip:Show()
                end
            end
        end)

        BONUS_BUTTON_TOOLTIPS.RandomBG.func= function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText('随机战场', 1, 1, 1)
            GameTooltip:AddLine('在随机战场上与敌对阵营竞争。', nil, nil, nil, true)
            GameTooltip:Show()
        end
        BONUS_BUTTON_TOOLTIPS.EpicBattleground.func = function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip:SetText('随机史诗战场', 1, 1, 1)
            GameTooltip:AddLine('在40人的大型战场上与敌对阵营竞争。', nil, nil, nil, true)
            GameTooltip:Show()
        end

        --role_tooltips('HonorFrame')
        ConquestJoinButton:SetText('加入战斗')



        local function conquestFrameButton_OnEnter(self)--hooksecurefunc('ConquestFrameButton_OnEnter', function(self)--Blizzard_PVPUI.lua
            local tooltip = ConquestTooltip
            local rating, seasonBest, weeklyBest, seasonPlayed, seasonWon, weeklyPlayed, weeklyWon, lastWeeksBest, hasWon, pvpTier, ranking, roundsSeasonPlayed, roundsSeasonWon, roundsWeeklyPlayed, roundsWeeklyWon = GetPersonalRatedInfo(self.bracketIndex)
            tooltip.Title:SetText(e.strText[self.toolTipTitle] or self.toolTipTitle)
            local isSoloShuffle = self.id == 1
            local tierInfo = pvpTier and C_PvP.GetPvpTierInfo(pvpTier)
            local tierName = tierInfo and tierInfo.pvpTierEnum and PVPUtil.GetTierName(tierInfo.pvpTierEnum)
            local hasSpecRank = tierName and ranking and isSoloShuffle
            tierName= e.strText[tierName]
            if tierName then
                if ranking and not hasSpecRank then
                    tooltip.Tier:SetFormattedText(PVP_TIER_WITH_RANK_AND_RATING, tierName, ranking, rating)
                else
                    tooltip.Tier:SetFormattedText(PVP_TIER_WITH_RATING, tierName, rating)
                end
            end
            local specName= PlayerUtil.GetSpecName()
            tooltip.SpecRank:SetFormattedText(hasSpecRank and format('%s: 等级 #%d', e.cn(specName), ranking) or "")
            tooltip.WeeklyBest:SetText('最高等级：'..weeklyBest)
            tooltip.WeeklyWon:SetText(isSoloShuffle and ('胜利回合：' .. roundsWeeklyWon) or ('赢得比赛：' .. weeklyWon))
            tooltip.WeeklyPlayed:SetText(isSoloShuffle and ('已完成回合：' .. roundsWeeklyPlayed) or ('比赛场次：' .. weeklyPlayed))
            tooltip.SeasonBest:SetText('最高等级：'..seasonBest)
            tooltip.SeasonWon:SetText(isSoloShuffle and ('胜利回合：' .. roundsSeasonWon) or ('赢得比赛：' .. seasonWon))
            tooltip.SeasonPlayed:SetText(isSoloShuffle and ('已完成回合：' .. roundsSeasonPlayed) or ('比赛场次：' .. seasonPlayed))
            local specStats = isSoloShuffle and C_PvP.GetPersonalRatedSoloShuffleSpecStats()
            if specStats then
                tooltip.WeeklyMostPlayedSpec:SetFormattedText('使用最多：%s (%d)', PlayerUtil.GetSpecNameBySpecID(specStats.weeklyMostPlayedSpecID), specStats.weeklyMostPlayedSpecRounds)
                tooltip.SeasonMostPlayedSpec:SetFormattedText('使用最多：%s (%d)',PlayerUtil.GetSpecNameBySpecID(specStats.seasonMostPlayedSpecID), specStats.seasonMostPlayedSpecRounds)
            end
            e.set(self.modeDescription, self.modeDescription)
        end
        if ConquestFrame.Arena2v2 then
            ConquestFrame.Arena2v2:HookScript('OnEnter', conquestFrameButton_OnEnter)
        end
        if ConquestFrame.Arena3v3 then
            ConquestFrame.Arena3v3:HookScript('OnEnter', conquestFrameButton_OnEnter)
        end
        if ConquestFrame.RatedBG then
            ConquestFrame.RatedBG:HookScript('OnEnter', conquestFrameButton_OnEnter)
        end


        hooksecurefunc('LFGInvitePopup_Update', function(inviter, _, _, _, _, isQuestSessionActive)
            local titleMarkup = isQuestSessionActive and CreateAtlasMarkup("QuestSharing-QuestLog-Replay", 19, 16) or ""
            local playerName= e.GetPlayerInfo({name=inviter, reName=true, reRealm=true})
            playerName= playerName=='' and inviter or playerName
            LFGInvitePopupText:SetFormattedText(titleMarkup ..'%s邀请你加入队伍', inviter)
            local tankButton = LFGInvitePopupRoleButtonTank
            if tankButton.disabledTooltip and e.strText[tankButton.disabledTooltip] then
                tankButton.disabledTooltip = e.strText[tankButton.disabledTooltip]
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
--hooksecurefunc('HonorFrame_UpdateQueueButtons', function()









































    elseif arg1=='Blizzard_ArtifactUI' then
        --Blizzard_ArtifactUI.lua
        e.dia("CONFIRM_ARTIFACT_RESPEC", {text = '确定要重置你的神器专长吗？|n|n这将消耗%s点|cffe6cc80神器能量|r。', button1 = '是', button2 = '否'})
        e.dia("NOT_ENOUGH_POWER_ARTIFACT_RESPEC", {text = '你没有足够的|cffe6cc80神器能量|r来重置你的专长。|n|n需要%s点|cffe6cc80神器能量|r。', button1 = '确定'})

        --Blizzard_ArtifactPerks.lua
        e.dia("CONFIRM_RELIC_REPLACE", {text = '你确定要替换此圣物吗？已有的圣物将被摧毁。', button1 = '接受', button2 = '取消'})

    elseif arg1=='Blizzard_Soulbinds' then
        e.dia("SOULBIND_DIALOG_MOVE_CONDUIT", {text = '一个导灵器只能同时被放置在一个插槽内，所以之前插槽里的该导灵器已被移除。', button1 = '接受'})
        e.dia("SOULBIND_DIALOG_INSTALL_CONDUIT_UNUSABLE", {text = '此插槽目前未激活。你确定想在此添加一个导灵器吗？', button1 = '接受', button2 = '取消'})

    elseif arg1=='Blizzard_AnimaDiversionUI' then--Blizzard_AnimaDiversionUI.lua
        e.dia("ANIMA_DIVERSION_CONFIRM_CHANNEL", {text = '你确定想引导心能到%s吗？|n|n|cffffd200%s|r', button1 = '是', button2 = '取消'})
        e.dia("ANIMA_DIVERSION_CONFIRM_REINFORCE", {text = '你确定想强化%s吗？|n|n|cffffd200这样会永久激活此地点，而且无法撤销。|r', button1 = '是', button2 = '取消'})

        e.dia("SOULBIND_CONDUIT_NO_CHANGES_CONFIRMATION", {text = '你对你的导灵器进行了改动，但并没有应用这些改动。你确定想要离开吗？', button1 = '离开', button2 = '取消'})

    elseif arg1=='Blizzard_CovenantSanctum' then--Blizzard_CovenantSanctumUpgrades.lua
        e.dia("CONFIRM_ARTIFACT_RESPEC", {button1 = '是', button2 = '否'})
        e.hookDia("CONFIRM_ARTIFACT_RESPEC", 'OnShow', function(self, data)
            if data then
                local costString = GetGarrisonTalentCostString(data.talent)
                self.text:SetFormattedText('把|cff20ff20%s|r升到%d级会花费|n%s', data.talent.name, data.talent.tier + 1, costString)
            end
        end)




    elseif arg1=='Blizzard_WeeklyRewards' then--Blizzard_WeeklyRewards.lua
        e.font(WeeklyRewardsFrame.HeaderFrame.Text)
        hooksecurefunc(WeeklyRewardsFrame, 'UpdateTitle', function(self)
            local canClaimRewards = C_WeeklyRewards.CanClaimRewards()
            if canClaimRewards then
                self.HeaderFrame.Text:SetText('你只能从宏伟宝库选择一件奖励。')
            elseif not C_WeeklyRewards.HasInteraction() and C_WeeklyRewards.HasAvailableRewards() then
                self.HeaderFrame.Text:SetText('返回宏伟宝库，获取你的奖励')
            else
                self.HeaderFrame.Text:SetText('每周完成活动可以将物品添加到宏伟宝库中。|n你每周可以选择一件奖励。')
            end
        end)

        e.dia("CONFIRM_SELECT_WEEKLY_REWARD", {text = '你一旦选好奖励就不能变更了。|n|n你确定要选择这件物品吗？', button1 = '是', button2 = '取消'})

    elseif arg1=='Blizzard_ChallengesUI' then--挑战, 钥匙插入， 界面
        hooksecurefunc(ChallengesFrame, 'UpdateTitle', function()
            local currentDisplaySeason =  C_MythicPlus.GetCurrentUIDisplaySeason()
            if ( not currentDisplaySeason ) then
                PVEFrame:SetTitle('史诗钥石地下城')
            else
                local expName = _G["EXPANSION_NAME"..GetExpansionLevel()]
                local title = format('史诗钥石地下城 %s 赛季 %d', e.strText[expName] or expName, currentDisplaySeason)
                PVEFrame:SetTitle(title)
            end
        end)
        ChallengesFrame.WeeklyInfo.Child.SeasonBest:SetText('赛季最佳')
        ChallengesFrame.WeeklyInfo.Child.ThisWeekLabel:SetText('本周')
        ChallengesFrame.WeeklyInfo.Child.Description:SetText('在史诗难度下，你每完成一个地下城，都会提升下一个地下城的难度和奖励。\n\n每周你都会根据完成的史诗地下城获得一系列奖励。\n\n要想开始挑战，把你的地下城难度设置为史诗，然后前往任意下列地下城吧。')

        hooksecurefunc(ChallengesFrame.WeeklyInfo.Child.WeeklyChest, 'Update', function(self, bestMapID, dungeonScore)
            if C_WeeklyRewards.HasAvailableRewards() then
                self.RunStatus:SetText('拜访宏伟宝库获取你的奖励！')
            elseif self:HasUnlockedRewards(Enum.WeeklyRewardChestThresholdType.Activities)  then
                self.RunStatus:SetText('完成史诗钥石地下城即可获得：')
            elseif C_MythicPlus.GetOwnedKeystoneLevel() or (dungeonScore and dungeonScore > 0) then
                self.RunStatus:SetText('完成史诗钥石地下城即可获得：')
            end
        end)


        ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript('OnEnter', function(self)
            GameTooltip_SetTitle(GameTooltip, '宏伟宝库奖励')
            if self.state == 4 then--CHEST_STATE_COLLECT
                GameTooltip_AddColoredLine(GameTooltip, '宏伟宝库里有奖励在等待着你。', GREEN_FONT_COLOR)
                GameTooltip_AddBlankLineToTooltip(GameTooltip)
            end
            local lastCompletedActivityInfo, nextActivityInfo = WeeklyRewardsUtil.GetActivitiesProgress()
            if not lastCompletedActivityInfo then
                GameTooltip_AddNormalLine(GameTooltip, '在本周内完成一个满级英雄或史诗地下城可以解锁一个宏伟宝库奖励。时空漫游地下城算作英雄地下城。|n|n你的奖励的物品等级会以你本周最高等级的成绩为依据。')
            else
                if nextActivityInfo then
                    local globalString = (lastCompletedActivityInfo.index == 1) and '再完成%1$d个满级英雄或史诗地下城可以解锁第二个宏伟宝库奖励。时空漫游地下城算作英雄地下城。' or '再完成%1$d个满级英雄或史诗地下城可以解锁第三个宏伟宝库奖励。时空漫游地下城算作英雄地下城。'
                    GameTooltip_AddNormalLine(GameTooltip, globalString:format(nextActivityInfo.threshold - nextActivityInfo.progress))
                else
                    GameTooltip_AddNormalLine(GameTooltip, '你已经解锁了本周可提供的所有奖励。在下周开始时拜访宏伟宝库，从你解锁的奖励里进行选择！')
                    GameTooltip_AddBlankLineToTooltip(GameTooltip)
                    GameTooltip_AddColoredLine(GameTooltip, '提升你的奖励', GREEN_FONT_COLOR)
                    local level, count = WeeklyRewardsUtil.GetLowestLevelInTopDungeonRuns(lastCompletedActivityInfo.threshold)
                    if level == WeeklyRewardsUtil.HeroicLevel then
                        GameTooltip_AddNormalLine(GameTooltip, format('完成%1$d次史诗难度的地下城，提升你的奖励。', count))
                    else
                        local nextLevel = WeeklyRewardsUtil.GetNextMythicLevel(level)
                        GameTooltip_AddNormalLine(GameTooltip, format('完成%1$d个%2$d级或更高的史诗地下城可以提升你的奖励。', count, nextLevel))
                    end
                end
            end
            GameTooltip_AddInstructionLine(GameTooltip, '点击预览宏伟宝库')
            GameTooltip:Show()
        end)

        ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo.Title:SetText('史诗钥石评分')
        ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo:HookScript('OnEnter', function()
            GameTooltip_SetTitle(GameTooltip, '史诗钥石评分')
            GameTooltip_AddNormalLine(GameTooltip, '基于你在每个地下城的最佳成绩得出的总体评分。你可以通过更迅速地完成地下城或者完成更高难度的地下城来提高你的评分。|n|n提升你的史诗地下城评分后，你就能把你的地下城装备升级到最高等级。|n|cff1eff00<Shift+点击以链接到聊天栏>|r')
            GameTooltip:Show()
        end)


        CHALLENGE_MODE_EXTRA_AFFIX_INFO["dmg"].name= '额外伤害'
        CHALLENGE_MODE_EXTRA_AFFIX_INFO["dmg"].desc = '敌人的伤害值提高%d%%'
        CHALLENGE_MODE_EXTRA_AFFIX_INFO["health"].name= '额外生命值'
        CHALLENGE_MODE_EXTRA_AFFIX_INFO["health"].desc = '敌人的生命值提高%d%%'
        ChallengesKeystoneFrame.StartButton:SetText('激活')
        ChallengesKeystoneFrame.Instructions:SetText('插入史诗钥石')
            hooksecurefunc(ChallengesKeystoneFrame, 'OnKeystoneSlotted', function(self)
                local mapID, _, powerLevel= C_ChallengeMode.GetSlottedKeystoneInfo()
                if mapID ~= nil then
                    local name= C_ChallengeMode.GetMapUIInfo(mapID)
                    e.set(self.DungeonName, name)
                    self.PowerLevel:SetFormattedText('%d级', powerLevel)
                end
            end)

        ChallengesFrame.SeasonChangeNoticeFrame.NewSeason:SetText('全新赛季！')
        ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription:SetText('地下城奖励的物品等级已经提升！')
        ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription2:SetText('史诗地下城的敌人变得更强了！')

        ChallengesFrame.SeasonChangeNoticeFrame.Leave:SetText('离开')











    elseif arg1=='Blizzard_PlayerChoice' then
        e.dia("CONFIRM_PLAYER_CHOICE", {button1 = '确定', button2 = '取消'})
        e.dia("CONFIRM_PLAYER_CHOICE_WITH_CONFIRMATION_STRING", {button1 = '接受', button2 = '拒绝'})
        hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, 'SetupHeader', function (self)
            if self.Header:IsShown() then
                e.set(self.Header.Text,self.optionInfo.header)
            end
        end)
        local rarityToString ={
            [Enum.PlayerChoiceRarity.Common] = "|cffffffff普通|r|n|n",
            [Enum.PlayerChoiceRarity.Uncommon] = "|cff1eff00优秀|r|n|n",
            [Enum.PlayerChoiceRarity.Rare] = "|cff0070dd精良|r|n|n",
            [Enum.PlayerChoiceRarity.Epic] = "|cffa335ee史诗|r|n|n",
        }
        hooksecurefunc(PlayerChoiceFrame, 'SetupOptions', function(self)----Blizzard_PlayerChoice.lua
            for optionFrame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
                optionFrame.OptionText:SetText((rarityToString[optionFrame.optionInfo.rarity] or "")..e.cn(optionFrame.optionInfo.description))
            end
        end)
        hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, 'OnEnter', function(self)
            if self.optionInfo and not self.optionInfo.spellID then
                local header= e.cn(self.optionInfo.header)
                if self.optionInfo.rarityColor then
                    header= self.optionInfo.rarityColor:WrapTextInColorCode(header)
                end
                GameTooltip_SetTitle(GameTooltip, header)
                if self.optionInfo.rarity and self.optionInfo.rarityColor then
                    local rarityStringIndex = self.optionInfo.rarity + 1
                    GameTooltip_AddColoredLine(GameTooltip, e.cn(_G["ITEM_QUALITY"..rarityStringIndex.."_DESC"]), self.optionInfo.rarityColor)
                end
                GameTooltip_AddNormalLine(GameTooltip, e.cn(self.optionInfo.description))
                GameTooltip:Show()
            end
        end)

        hooksecurefunc(GenericPlayerChoiceToggleButton, 'UpdateButtonState', function(self)--PlayerChoiceToggleButtonMixin
            if self:IsShown() then
                local choiceFrameShown = PlayerChoiceFrame:IsShown()
                local choiceInfo = C_PlayerChoice.GetCurrentPlayerChoiceInfo() or {}
                self.Text:SetText(choiceFrameShown and '隐藏' or e.cn(choiceInfo.pendingChoiceText))
            end
        end)








    elseif arg1=='Blizzard_GarrisonTemplates' then--Blizzard_GarrisonSharedTemplates.lua
        e.dia("CONFIRM_FOLLOWER_UPGRADE", {button1 = '是', button2 = '否'})
        e.dia("CONFIRM_FOLLOWER_ABILITY_UPGRADE", {button1 = '是', button2 = '否'})
        e.dia("CONFIRM_FOLLOWER_TEMPORARY_ABILITY", {text = '确定要赋予%s这个临时技能吗？', button1 = '是', button2 = '否'})
        e.dia("CONFIRM_FOLLOWER_EQUIPMENT", {button1 = '是', button2 = '否'})

    elseif arg1=='Blizzard_ClassTrial' then--Blizzard_WeeklyRewards.lua
        e.dia("CLASS_TRIAL_CHOOSE_BOOST_TYPE", {text = '你希望使用哪种角色直升？', button1 = '接受', button2 = '接受', button3 = '取消'})
        e.dia("CLASS_TRIAL_CHOOSE_BOOST_LOGOUT_PROMPT", {text = '要使用此角色直升服务，请登出游戏，返回角色选择界面。', button1 = '立刻返回角色选择画面', button2 = '取消'})

    elseif arg1=='Blizzard_GarrisonUI' then--要塞
        e.dia("DEACTIVATE_FOLLOWER", {button1 = '是', button2 = '否'})
        e.hookDia("DEACTIVATE_FOLLOWER", 'OnShow', function(self)
            local quality = C_Garrison.GetFollowerQuality(self.data)
            local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data)..FONT_COLOR_CODE_CLOSE
            local cost = GetMoneyString(C_Garrison.GetFollowerActivationCost())
            local uses = C_Garrison.GetNumFollowerDailyActivations()
            self.text:SetFormattedText('确定要遣散|n%s吗？|n|n重新激活一名追随者需要花费%s。|n你每天可重新激活%d名追随者。', name, cost, uses)
        end)

        e.dia("ACTIVATE_FOLLOWER", {button1 = '是', button2 = '否'})
        e.hookDia("ACTIVATE_FOLLOWER", 'OnShow', function(self)
            local quality = C_Garrison.GetFollowerQuality(self.data)
            local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data)..FONT_COLOR_CODE_CLOSE
            local cost = GetMoneyString(C_Garrison.GetFollowerActivationCost())
            local uses = C_Garrison.GetNumFollowerDailyActivations()
            self.text:SetFormattedText('确定要激活|n%s吗？|n|n你今天还能激活%d名追随者，这将花费：', name, cost, uses)
        end)

        e.dia("CONFIRM_RECRUIT_FOLLOWER", {text  = '确定要招募%s吗？', button1 = '是', button2 = '否'})

        e.dia("DANGEROUS_MISSIONS", {button1 = '确定', button2 = '取消'})
        e.hookDia("DANGEROUS_MISSIONS", 'OnShow', function(self)
            local warningIconText = "|T" .. STATICPOPUP_TEXTURE_ALERT .. ":15:15:0:-2|t"
            self.text:SetFormattedText('|n %s |cffff2020警告！|r %s |n|n你即将执行一项高危行动。如果行动失败，所有参与任务的舰船都有一定几率永久损毁。', warningIconText, warningIconText)
        end)

        e.dia("GARRISON_SHIP_RENAME", {text  = '输入你想要的名字：', button1 = '接受', button2 = '取消', button3= '默认'})

        e.dia("GARRISON_SHIP_DECOMMISSION", {button1 = '是', button2 = '否'})
        e.hookDia("GARRISON_SHIP_DECOMMISSION", 'OnShow', function(self)
            local quality = C_Garrison.GetFollowerQuality(self.data.followerID)
            local name = FOLLOWER_QUALITY_COLORS[quality].hex..C_Garrison.GetFollowerName(self.data.followerID)..FONT_COLOR_CODE_CLOSE
            self.text:SetFormattedText('你确定要永久报废|n%s吗？|n|n你将无法重新获得这艘舰船。', name)
        end)

        e.dia("GARRISON_CANCEL_UPGRADE_BUILDING", {text  = '确定要取消这次建筑升级吗？升级的费用将被退还。', button1 = '是', button2 = '否'})
        e.dia("GARRISON_CANCEL_BUILD_BUILDING", {text  = '确定要取消建造这座建筑吗？建造的费用将被退还。', button1 = '是', button2 = '否'})
        e.dia("COVENANT_MISSIONS_CONFIRM_ADVENTURE", {text  = '开始冒险？', button1 = '确认', button2 = '取消'})
        e.dia("COVENANT_MISSIONS_HEAL_CONFIRMATION", {text  = '你确定要彻底治愈这名追随者吗？', button1 = '确认', button2 = '取消'})
        e.dia("COVENANT_MISSIONS_HEAL_ALL_CONFIRMATION", {text  = '你确定要付出%s，治疗所有受伤的伙伴？', button1 = '治疗全部', button2 = '取消'})

    elseif arg1=='Blizzard_RuneforgeUI' then--Blizzard_RuneforgeCreateFrame.lua
        e.dia("CONFIRM_RUNEFORGE_LEGENDARY_CRAFT", {button1 = '是', button2 = '否'})
        e.hookDia("CONFIRM_RUNEFORGE_LEGENDARY_CRAFT", 'OnShow', function(self, data)
            self.text:SetText(data.title)
            local text= data and data.title or ''
            local a= text:match(e.Magic(RUNEFORGE_LEGENDARY_UPGRADING_CONFIRMATION))
            local b= text:match(e.Magic(RUNEFORGE_LEGENDARY_CRAFTING_CONFIRMATION))
            if a then
                self.text:SetFormattedText('你确定要花费%s给这件传说装备升级吗？', a)
            elseif b then
                self.text:SetFormattedText('你确定要花费%s打造这件传说装备吗？', b)
            end
        end)
        --set_GameTooltip_func(RuneforgeFrameResultTooltip)

    elseif arg1=='Blizzard_ClickBindingUI' then
        e.dia("CONFIRM_LOSE_UNSAVED_CLICK_BINDINGS", {text  = '你有未保存的点击施法按键绑定。如果你现在关闭，会丢失所有改动。', button1 = '确定', button2 = '取消'})
        e.dia("CONFIRM_RESET_CLICK_BINDINGS", {text  = '确定将所有点击施法按键绑定重置为默认值吗？\n', button1 = '确定', button2 = '取消'})


        ClickBindingFrameTitleText:SetText('关于点击施法按键绑定')
        ClickBindingFrame.TutorialFrame:SetTitle('关于点击施法按键绑定')

        ClickBindingFrame.SaveButton:SetText('保存')
        ClickBindingFrame.AddBindingButton:SetText('添加绑定')
        ClickBindingFrame.ResetButton:SetText('恢复默认设置')
        ClickBindingFrame.EnableMouseoverCastCheckbox.Label:SetText('鼠标悬停施法')
        ClickBindingFrame.EnableMouseoverCastCheckbox:HookScript('OnEnter', function()
            GameTooltip:SetText('启用后，鼠标悬停到一个单位框体并使用一个键盘快捷键施放法术时，会直接对该单位施法，无需将该单位设为目标。', nil, nil, nil, nil, true)

        end)
        ClickBindingFrame.MouseoverCastKeyDropDown.Label:SetText('鼠标悬停施法按键')
        ClickBindingFrame.TutorialFrame.SummaryText:SetText('将法术和宏绑定到鼠标点击')
        ClickBindingFrame.TutorialFrame.InfoText:SetText('通过点击单位框体施放绑定的法术和宏')
        ClickBindingFrame.TutorialFrame.AlternateText:SetText('可以使用Shift键、Ctrl键或者Alt键来设定其他的点击绑定')
        ClickBindingFrame.TutorialFrame.ThrallName:SetText('萨尔')
        ClickBindingFrame.SpellbookPortrait:HookScript('OnEnter', function()
            GameTooltip_SetTitle(GameTooltip, MicroButtonTooltipText('法术书和专业', "TOGGLESPELLBOOK"))
            GameTooltip:Show()
        end)
        ClickBindingFrame.MacrosPortrait:HookScript('OnEnter', function()
            GameTooltip_SetTitle(GameTooltip, '宏')
            GameTooltip:Show()
        end)

        local function NameAndIconFromElementData(elementData)
            if elementData.bindingInfo then
                local bindingInfo = elementData.bindingInfo
                local type = bindingInfo.type
                local actionID = bindingInfo.actionID

                local actionName
                if type == Enum.ClickBindingType.Spell or type == Enum.ClickBindingType.PetAction then
                    local overrideID = FindSpellOverrideByID(actionID)
                    actionName = C_Spell.GetSpellName(overrideID)
                elseif type == Enum.ClickBindingType.Macro then
                    local macroName
                    macroName = GetMacroInfo(actionID)
                    actionName = format('%s (宏)', macroName)
                elseif type == Enum.ClickBindingType.Interaction then
                    if actionID == Enum.ClickBindingInteraction.Target then
                        actionName = '目标单位框架 (默认)'
                    elseif actionID == Enum.ClickBindingInteraction.OpenContextMenu then
                        actionName = '打开上下文菜单 (默认)'
                    end
                end
                return actionName
            elseif elementData.elementType == 1 then
                return '默认鼠标绑定'
            elseif elementData.elementType == 3 then
                return '自定义鼠标绑定'
            elseif elementData.elementType == 5 then
                return '空'
            end
        end
        hooksecurefunc(ClickBindingFrame, 'SetUnboundText', function(self, elementData)
            self.UnboundText:SetFormattedText('%s 解除绑定', NameAndIconFromElementData(elementData))
        end)

        local ButtonStrings = {
            LeftButton = '左键',
            Button1 = '左键',
            RightButton = '右键',
            Button2 = '右键',
            MiddleButton = '中键',
            Button3 = '中键',
            Button4 = '按键4',
            Button5 = '按键5',
            Button6 = '按键6',
            Button7 = '按键7',
            Button8 = '按键8',
            Button9 = '按键9',
            Button10 = '按键10',
            Button11 = '按键11',
            Button12 = '按键12',
            Button13 = '按键13',
            Button14 = '按键14',
            Button15 = '按键15',
            Button16 = '按键16',
            Button17 = '按键17',
            Button18 = '按键18',
            Button19 = '按键19',
            Button20 = '按键20',
            Button21 = '按键21',
            Button22 = '按键22',
            Button23 = '按键23',
            Button24 = '按键24',
            Button25 = '按键25',
            Button26 = '按键26',
            Button27 = '按键27',
            Button28 = '按键28',
            Button29 = '按键29',
            Button30 = '按键30',
            Button31 = '按键31',
        }

        local function BindingTextFromElementData(elementData)
            if elementData.elementType == 5 then
                local bindingText = elementData.bindingInfo and '鼠标移到该位置并点击一个鼠标按键来进行绑定' or '点击一个法术或宏以开始'
                return GREEN_FONT_COLOR:WrapTextInColorCode(bindingText)
            end

            local bindingInfo = elementData.bindingInfo
            if not bindingInfo or not bindingInfo.button then
                return RED_FONT_COLOR:WrapTextInColorCode('解除绑定 - 把鼠标移到目标上并点击来设置')
            end

            local buttonString = ButtonStrings[bindingInfo.button]
            local modifierText = C_ClickBindings.GetStringFromModifiers(bindingInfo.modifiers)
            if modifierText ~= "" then
                return format('%s-%s', modifierText, buttonString)
            else
                return buttonString
            end
        end
        local function ColoredNameAndIconFromElementData(elementData)
            local name = NameAndIconFromElementData(elementData)
            local isDisabled
            if elementData.elementType == 5 then
                isDisabled = (elementData.bindingInfo == nil)
            else
                isDisabled = elementData.unbound
            end
            if isDisabled then
                name = DISABLED_FONT_COLOR:WrapTextInColorCode(name)
            end
            return name
        end
        hooksecurefunc(ClickBindingLineMixin, 'Init', function(self, elementData)
            e.set(self.BindingText, BindingTextFromElementData(elementData))

            e.set(self.Name, ColoredNameAndIconFromElementData(elementData))
        end)
        hooksecurefunc(ClickBindingHeaderMixin, 'Init', function(self, elementData)
	        e.set(self.Name, ColoredNameAndIconFromElementData(elementData))
        end)

    elseif arg1=='Blizzard_ProfessionsTemplates' then
        e.dia("PROFESSIONS_RECRAFT_REPLACE_OPTIONAL_REAGENT", {button1 = '接受', button2 = '取消'})
        e.hookDia("PROFESSIONS_RECRAFT_REPLACE_OPTIONAL_REAGENT", 'OnShow', function(self, data)
            self.text:SetFormattedText('你想替换%s吗？\n它会在再造时被摧毁。', data.itemName)
        end)

    elseif arg1=='Blizzard_BlackMarketUI' then
        e.dia("BID_BLACKMARKET", {text = '确定要出价%s竞拍以下物品吗？', button1 = '确定', button2 = '取消'})

    elseif arg1=='Blizzard_TrainerUI' then--专业，训练师
        e.dia("CONFIRM_PROFESSION", {text = format('你只能学习两个专业。你要学习|cffffd200%s|r作为你的第一个专业吗？', "XXX"), button1 = '接受', button2 = '取消'})
        e.hookDia("CONFIRM_PROFESSION", 'OnShow', function(self)
            local prof1, prof2 = GetProfessions()
            if ( prof1 and not prof2 ) then
                self.text:SetFormattedText('你只能学习两个专业。你要学习|cffffd200%s|r作为你的第二个专业吗？', GetTrainerServiceSkillLine(ClassTrainerFrame.selectedService))
            elseif ( not prof1 ) then
                self.text:SetFormattedText('你只能学习两个专业。你要学习|cffffd200%s|r作为你的第一个专业吗？', GetTrainerServiceSkillLine(ClassTrainerFrame.selectedService))
            end
        end)
        ClassTrainerTrainButton:SetText('训练')

    elseif arg1=='Blizzard_DeathRecap' then
        DeathRecapFrame.CloseButton:SetText('关闭')
        DeathRecapFrame.Title:SetText('死亡摘要')


    elseif arg1=='Blizzard_CombatLog' then--聊天框，战斗记录
        local function set_filter(self)
            if not self then
                return
            end
            for index, tab in pairs(self) do
                if type(tab)=='table' then
                    local name= tab.name
                    local quickButtonName= tab.quickButtonName
                    local tooltip= tab.tooltip
                    name= name and e.strText[name]
                    quickButtonName= quickButtonName and e.strText[quickButtonName]
                    tooltip= tooltip and e.strText[tooltip]
                    if name then
                        self[index].name= name
                    end
                    if quickButtonName then
                        self[index].quickButtonName= quickButtonName
                    end
                    if tooltip then
                        self[index].tooltip= tooltip
                    end
                end
            end
        end
        set_filter(Blizzard_CombatLog_Filter_Defaults.filters)
        set_filter(Blizzard_CombatLog_Filters.filters )

    elseif arg1=='Blizzard_ItemUpgradeUI' then--装备升级,界面
        ItemUpgradeFrameTitleText:SetText('物品升级')
        ItemUpgradeFrame.UpgradeButton:SetText('升级')
        ItemUpgradeFrame.ItemInfo.MissingItemText:SetText('将物品拖曳至此处升级。')
        ItemUpgradeFrame.MissingDescription:SetText('许多可装备的物品都可以进行升级，从而提高其物品等级。不同来源的物品升级所需的货币也各不相同。')
        ItemUpgradeFrame.ItemInfo.UpgradeTo:SetText('升级至：')
        ItemUpgradeFrame.UpgradeCostFrame.Label:SetText('总花费：')
        hooksecurefunc(ItemUpgradeFrame, 'PopulatePreviewFrames', function(self)
            if self.FrameErrorText:IsShown() then
                e.set(self.FrameErrorText)--该物品已经升到满级了
            end
        end)


    elseif arg1=='Blizzard_Settings' then--Blizzard_SettingsPanel.lua 
        local label2= e.Cstr(SettingsPanel.CategoryList)
        label2:SetPoint('RIGHT', SettingsPanel.ClosePanelButton, 'LEFT', -2, 0)
        label2:SetText(id..' 语言翻译 提示：请要不在战斗中修改选项')

        SettingsPanel.Container.SettingsList.Header.DefaultsButton:SetText('默认设置')
        e.dia('GAME_SETTINGS_APPLY_DEFAULTS', {text= '你想要将所有用户界面和插件设置重置为默认状态，还是只重置这个界面或插件的设置？', button1= '所有设置', button2= '取消', button3= '这些设置'})--Blizzard_Dialogs.lua
        SettingsPanel.GameTab.Text:SetText('游戏')
        SettingsPanel.AddOnsTab.Text:SetText('插件')
        SettingsPanel.NineSlice.Text:SetText('选项')
        SettingsPanel.CloseButton:SetText('关闭')
        SettingsPanel.ApplyButton:SetText('应用')

        SettingsPanel.NineSlice.Text:SetText('选项')
        SettingsPanel.SearchBox.Instructions:SetText('搜索')

    elseif arg1=='Blizzard_TimeManager' then--小时图，时间
        TimeManagerStopwatchFrameText:SetText('显示秒表')
        TimeManagerAlarmTimeLabel:SetText('提醒时间')
        TimeManagerAlarmMessageLabel:SetText('提醒信息')
        TimeManagerAlarmEnabledButtonText:SetText('开启提醒')
        TimeManagerMilitaryTimeCheckText:SetText('24小时模式')
        TimeManagerLocalTimeCheckText:SetText('使用本地时间')
        StopwatchTitle:SetText('秒表')

        hooksecurefunc('GameTime_UpdateTooltip', function()--GameTime.lua
            GameTooltip:SetText('时间信息', HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
            GameTooltip:AddDoubleLine( '服务器时间：', GameTime_GetGameTime(true), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
            GameTooltip:AddDoubleLine( '本地时间：', GameTime_GetLocalTime(true), NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b)
        end)

    elseif arg1=='Blizzard_ArchaeologyUI' then
        ArchaeologyFrameTitleText:SetText('考古学')
        ArchaeologyFrameSummaryPageTitle:SetText('种族')
        ArchaeologyFrameCompletedPage.infoText:SetText('你还没有完成任何神器。寻找碎片及钥石以完成神器。')
        ArchaeologyFrameCompletedPage.titleBig:SetText('已完成神器')
        ArchaeologyFrameCompletedPage.titleMid:SetText('已完成的普通神器')

        ArchaeologyFrameCompletedPage.titleTop:SetText('已完成的普通神器')

        ArchaeologyFrameArtifactPage.historyTitle:SetText('历史')
        ArchaeologyFrameArtifactPage.raceRarity:SetText('种族')
        ArchaeologyFrame.backButton:SetText('后退')
        ArchaeologyFrameArtifactPageSolveFrameSolveButton:SetText('解密')

        hooksecurefunc(ArchaeologyFrame.summaryPage, 'UpdateFrame', function(self)
            self.pageText:SetFormattedText('第%d页', self.currentPage)
        end)
        hooksecurefunc(ArchaeologyFrame.completedPage, 'UpdateFrame', function(self)
            self.pageText:SetFormattedText('第%d页', self.currentPage)
            self.titleTop:SetText(self.currData.onRare and '已完成的精良神器' or '已完成的普通神器')
        end)
        hooksecurefunc('ArchaeologyFrame_CurrentArtifactUpdate', function(self)
            local RaceName, _, RaceitemID	= GetArchaeologyRaceInfo(self.raceID, true)

            local runeName
            if RaceitemID and RaceitemID > 0 then
                runeName = C_Item.GetItemInfo(RaceitemID)
            end
            if runeName then
                for i=1, ARCHAEOLOGY_MAX_STONES do
                    local slot= self.solveFrame["keystone"..i]
                    if slot and slot:IsShown() then
                        if ItemAddedToArtifact(i) then
                            self.solveFrame["keystone"..i].tooltip = format('点此以移除 |cnGREEN_FONT_COLOR:%s|r 。', runeName)
                        else
                            self.solveFrame["keystone"..i].tooltip = format('点此以从你的背包中选择一块 |cnGREEN_FONT_COLOR:%s|r 来降低完成该神器所需要的碎片数量。', runeName)
                        end
                    end
                end
            end

            if select(3, GetSelectedArtifactInfo()) == 0 then --Common Item
                self.raceRarity:SetText(RaceName.." - |cffffffff普通|r")
            else
                self.raceRarity:SetText(RaceName.." - |cff0070dd精良|r")
            end
        end)

        ArchaeologyFrame.rankBar:HookScript('OnEnter', function()
            GameTooltip:SetText('考古学技能', HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
			GameTooltip:Show()
        end)

        ArchaeologyFrameArtifactPageSolveFrameStatusBar:HookScript('OnEnter', function()
            local _, _, _, _, _, maxCount = GetArchaeologyRaceInfo(ArchaeologyFrame.artifactPage.raceID)
            GameTooltip:SetText(format('拼出该神器所需的碎片数量。\n\n每个种族的碎片最多只能保存%d块。', maxCount), HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b, true)
			GameTooltip:Show()
        end)
        ArchaeologyFrameHelpPageTitle:SetText('考古学')
        ArchaeologyFrameHelpPageHelpScrollHelpText:SetText('你需要搜集散落在世界各处的神器碎片来将它们复原为完整的神器。你能够在挖掘场里找到这些碎片，挖掘场的位置会标记在你的地图上。在挖掘场使用调查技能，你的调查工具就会显示出神器碎片大致的埋藏方向和位置。在前往一个新的挖掘地址前你可以在一个挖掘场中收集六次碎片。当你拥有了足够的碎片之后，你就可以破译隐藏在神器中的秘密，了解更多关于艾泽拉斯昔日的历史和传说。寻宝愉快！')
        ArchaeologyFrameHelpPageDigTitle:SetText('考古学地图位置标记')

        ArchaeologyFrameSummarytButton:HookScript('OnEnter', function()
            GameTooltip:SetText('当前神器')
        end)
        ArchaeologyFrameCompletedButton:HookScript('OnEnter', function()
            GameTooltip:SetText('已完成神器')
        end)

    elseif arg1=='Blizzard_ItemInteractionUI' then--套装, 转换
        ItemInteractionFrame.CurrencyCost.Costs:SetText('花费：')
        e.dia("ITEM_INTERACTION_CONFIRMATION_DELAYED", {button2 = '取消'})
        e.dia("ITEM_INTERACTION_CONFIRMATION_DELAYED_WITH_CHARGE_INFO", {button2 = '取消'})
         --[[
        hooksecurefunc(ItemInteractionFrame, 'LoadInteractionFrameData', function(self, frameData)
            local title= e.strText[frameData.titleText]
            if title then
                self:SetTitle(title);
            end
            local name= e.strText[frameData.buttonText]
            if name then
                self.ButtonFrame.ActionButton:SetText(name)
            end
            info= frameData
            for k, v in pairs(info) do if v and type(v)=='table' then print('|cff00ff00---',k, '---STAR') for k2,v2 in pairs(v) do print(k2,v2) end print('|cffff0000---',k, '---END') else print(k,v) end end print('|cffff00ff——————————')
        end)
       
        需要内容
    hooksecurefunc(ItemInteractionFrame, 'UpdateDescription', function(self, description)
        local desc= e.strText[description]
        if desc then
            self.Description:SetText(desc)
        end
    end]]
        

    elseif arg1=='Blizzard_MajorFactions' then
        hooksecurefunc(MajorFactionButtonUnlockedStateMixin, 'Refresh', function(self, majorFactionData)--Blizzard_MajorFactionsLandingTemplates.lua
            e.set(self.Title, majorFactionData.name)
            self.RenownLevel:SetFormattedText('%d级', majorFactionData.renownLevel or 0)
        end)
        hooksecurefunc(MajorFactionWatchFactionButtonMixin, 'OnLoad', function(self)
            self.Label:SetText('显示为经验条')
        end)

        --Blizzard_MajorFactionRenown.lua
        hooksecurefunc(MajorFactionRenownFrame, 'SetUpMajorFactionData', function(self)
            local majorFactionData = C_MajorFactions.GetMajorFactionData(self.majorFactionID) or {}
---@diagnostic disable-next-line: undefined-field
            if majorFactionData.name and majorFactionData.currentFactionID ~= self.majorFactionID then
                e.set(self.TrackFrame.Title, majorFactionData.name)
            end
        end)



    elseif arg1=='Blizzard_CharacterCustomize' then--飞龙，制定界面
        CharCustomizeFrame.RandomizeAppearanceButton.simpleTooltipLine= '随机外观'

    elseif arg1=='Blizzard_DebugTools' then--FSTACK
        TableAttributeDisplay.VisibilityButton.Label:SetText('显示')
        TableAttributeDisplay.HighlightButton.Label:SetText('高亮')
        TableAttributeDisplay.DynamicUpdateButton.Label:SetText('动态更新')



    elseif arg1=='Blizzard_EventTrace' then--ETRACE
        EventTraceTitleText:SetText('事件记录')

        EventTrace.SubtitleBar.ViewLog.Label:SetText('查看日志')
        EventTrace.SubtitleBar.ViewFilter.Label:SetText('过滤器')
        EventTrace.Log.Bar.Label:SetText('记录')
        hooksecurefunc(EventTrace, 'DisplayEvents', function(self)
            self.Log.Bar.Label:SetText('记录')
        end)
        hooksecurefunc(EventTrace, 'OnSearchDataProviderChanged', function(self)
            self.Log.Bar.Label:SetFormattedText('结果：%d', self.searchDataProvider:GetSize() or 0)
        end)
        EventTrace.Log.Bar.DiscardAllButton.Label:SetText('全部清除')
        EventTrace.Log.Bar.PlaybackButton.Label:SetText(EventTrace:IsLoggingPaused() and '|cnRED_FONT_COLOR:开始' or '|cnGREEN_FONT_COLOR:暂停')
        hooksecurefunc(EventTrace, 'UpdatePlaybackButton', function(self)
            self.Log.Bar.PlaybackButton.Label:SetText(self:IsLoggingPaused() and '|cnRED_FONT_COLOR:开始' or '|cnGREEN_FONT_COLOR:暂停')
        end)
        EventTrace.Log.Bar.MarkButton.Label:SetText('标记')

        EventTrace.Filter.Bar.Label:SetText('过滤')
        EventTrace.Filter.Bar.DiscardAllButton.Label:SetText('全部删除')
        EventTrace.Filter.Bar.UncheckAllButton.Label:SetText('全部取消')
        EventTrace.Filter.Bar.CheckAllButton.Label:SetText('全部选取')

    elseif arg1=='Blizzard_ScrappingMachineUI' then--分解
        ScrappingMachineFrame.ScrapButton:SetText('拆解')
        C_Timer.After(0.3, function() ScrappingMachineFrameTitleText:SetText('拆解大师Mk1型') end)
    end
end
























--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(_, _, arg1)
    Init_Event(arg1)
end)
