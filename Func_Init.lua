local e = select(2, ...)




















hooksecurefunc(SettingsCategoryListButtonMixin, 'Init', function(self, initializer)--列表 Blizzard_CategoryList.lua
    local category = initializer.data.category
    if category then
        e.set(self.Label, category:GetName())
    end
end)
hooksecurefunc(SettingsCategoryListHeaderMixin, 'Init', function(self, initializer)
    e.set(self.Label, initializer.data.label)
end)

--选项
hooksecurefunc(SettingsPanel.Container.SettingsList.ScrollBox, 'Update', function(frame)
    if not frame:GetView() or not frame:IsVisible() then
        return
    end
    --标提
    e.set(SettingsPanel.Container.SettingsList.Header.Title)
    for _, btn in pairs(frame:GetFrames() or {}) do
        local lable
        if btn.Button then--按钮
            lable= btn.Button.Text or btn.Button
            if lable then
                e.set(lable)
            end
        end
        if btn.DropDown and btn.DropDown.Button and btn.DropDown.Button.SelectionDetails  then--下拉，菜单info= btn
            lable= btn.DropDown.Button.SelectionDetails.SelectionName
            if lable then
                e.set(lable)
            end
        end
        lable= btn.Text or btn.Label or btn.Title
        if lable then
            e.set(lable)
        elseif btn.Text and btn.data and btn.data.name and btn.data.name then
            e.set(btn.Text, btn.data.name)
        end
    end
end)
hooksecurefunc('BindingButtonTemplate_SetupBindingButton', function(_, button)--BindingUtil.lua
    local text= button:GetText()
    if text==GRAY_FONT_COLOR:WrapTextInColorCode(NOT_BOUND) then
        button:SetText(GRAY_FONT_COLOR:WrapTextInColorCode('未设置'))
    else
        e.set(button, text)
    end
end)
hooksecurefunc(KeyBindingFrameBindingTemplateMixin, 'Init', function(self, initializer)
    e.set(self.Label)
end)





















hooksecurefunc(DragonridingPanelSkillsButtonMixin, 'OnLoad', function(self)--Blizzard_DragonflightLandingPage.lua
    e.set(self)
end)





























--快速快捷键模式
--QuickKeybind.xml
QuickKeybindFrame.Header.Text:SetText('快速快捷键模式')
QuickKeybindFrame.InstructionText:SetText('你处于快速快捷键模式。将鼠标移到一个按钮上并按下你想要的按键，即可设置那个按钮的快捷键。')
QuickKeybindFrame.CancelDescriptionText:SetText('取消会使你离开快速快捷键模式。')
QuickKeybindFrame.OkayButton:SetText('确定')
QuickKeybindFrame.DefaultsButton:SetText('恢复默认设置')
QuickKeybindFrame.CancelButton:SetText('取消')
QuickKeybindFrame.UseCharacterBindingsButton.text:SetText('角色专用按键设置')









e.Cstr(nil, {changeFont= QuickKeybindFrame.OutputText, size=16})
local function set_SetOutputText(self, text)
    if not text then
        return
    end
    if text==KEYBINDINGFRAME_MOUSEWHEEL_ERROR then
        self.OutputText:SetText('|cnRED_FONT_COLOR:无法将鼠标滚轮的上下滚动状态绑定在动作条上|r')
    elseif text==KEY_BOUND then
        self.OutputText:SetText('|cnGREEN_FONT_COLOR:按键设置成功|r')
    else
        local a, b, c= e.Magic(PRIMARY_KEY_UNBOUND_ERROR), e.Magic(KEY_UNBOUND_ERROR), e.Magic(SETTINGS_BIND_KEY_TO_COMMAND_OR_CANCEL)
        local finda, findb= text:match(a), text:match(b)
        local findc1, findc2= text:match(c)
        if finda then
            self.OutputText:SetFormattedText('|cffff0000主要动作 |cffff00ff%s|r 现在没有绑定！|r', e.strText[finda] or finda)
        elseif findb then
            self.OutputText:SetFormattedText('|cffff0000动作 |cffff00ff%s|r 现在没有绑定！|r', e.strText[findb] or findb)
        elseif findc1 and findc2 then
            self.OutputText:SetFormattedText('设置 |cnGREEN_FONT_COLOR:%s|r 的快捷键，或者按 %s 取消', e.strText[findc1] or findc1, findc2)
        end
    end
end
hooksecurefunc(QuickKeybindFrame, 'SetOutputText', set_SetOutputText)
hooksecurefunc(SettingsPanel, 'SetOutputText', set_SetOutputText)

--快捷键
hooksecurefunc(KeyBindingFrameBindingTemplateMixin,'Init', function(self)
    local label= self.Text or self.Label
    if label then
        e.set(label, label:GetText())
    end
end)




--好友
hooksecurefunc('FriendsFrame_Update', function()
    local selectedTab = PanelTemplates_GetSelectedTab(FriendsFrame) or FRIEND_TAB_FRIENDS
    if selectedTab == FRIEND_TAB_FRIENDS then
        local selectedHeaderTab = PanelTemplates_GetSelectedTab(FriendsTabHeader) or FRIEND_HEADER_TAB_FRIENDS
        if selectedHeaderTab == FRIEND_HEADER_TAB_FRIENDS then
            FriendsFrame:SetTitle('好友名单')
        elseif selectedHeaderTab == FRIEND_HEADER_TAB_IGNORE then
            FriendsFrame:SetTitle('屏蔽列表')
        elseif selectedHeaderTab == FRIEND_HEADER_TAB_RAF then
            FriendsFrame:SetTitle('招募战友')
        end
    elseif ( selectedTab == FRIEND_TAB_WHO ) then
        FriendsFrameTitleText:SetText('名单列表')
    elseif ( selectedTab == FRIEND_TAB_RAID ) then
        FriendsFrameTitleText:SetText('团队')
    elseif ( selectedTab == FRIEND_TAB_QUICK_JOIN ) then
        FriendsFrameTitleText:SetText('快速加入')
    end
end)

FriendsFrameTab1:SetText('好友')
    e.reg(FriendsFrameBattlenetFrame.BroadcastFrame, '通告', 1)
    FriendsFrameBattlenetFrame.BroadcastFrame.EditBox.PromptText:SetText('通告')
    FriendsFrameBattlenetFrame.BroadcastFrame.UpdateButton:SetText('更新')
    FriendsFrameBattlenetFrame.BroadcastFrame.CancelButton:SetText('取消')
    FriendsFrameAddFriendButton:SetText('添加好友')
        AddFriendEntryFrameTopTitle:SetText('添加好友')
        AddFriendEntryFrameOrLabel:SetText('或')
        hooksecurefunc('AddFriendFrame_ShowEntry', function()
            if ( BNFeaturesEnabledAndConnected() ) then
                local _, battleTag, _, _, _, _, isRIDEnabled = BNGetInfo()
                if ( battleTag and isRIDEnabled ) then
                    AddFriendEntryFrameLeftTitle:SetText('实名')
                    AddFriendEntryFrameLeftDescription:SetText('输入电子邮件地址\n(或战网昵称)')
                    AddFriendNameEditBoxFill:SetText('输入：电子邮件地址、战网昵称、角色名')
                elseif ( isRIDEnabled ) then
                    AddFriendEntryFrameLeftTitle:SetText('实名')
                    AddFriendEntryFrameLeftDescription:SetText('输入电子邮件地址')
                    AddFriendNameEditBoxFill:SetText('输入：电子邮件地址、角色名')
                elseif ( battleTag ) then
                    AddFriendEntryFrameLeftTitle:SetText('战网昵称')
                    AddFriendEntryFrameLeftDescription:SetText('输入战网昵称')
                    AddFriendNameEditBoxFill:SetText('输入：战网昵称、角色名')
                end
            else
                AddFriendEntryFrameLeftDescription:SetText('暴雪游戏服务不可用')
            end
        end)
        AddFriendEntryFrameRightDescription:SetText('输入角色名')
        hooksecurefunc('AddFriendEntryFrame_Init', function()
            AddFriendEntryFrameAcceptButtonText:SetText('添加好友')
        end)
        AddFriendEntryFrameCancelButtonText:SetText('取消')
        AddFriendNameEditBox:ClearAllPoints()--移动，输入框
        AddFriendNameEditBox:SetPoint('BOTTOMLEFT', AddFriendEntryFrameAcceptButton, 'TOPLEFT', 0, 4)
        AddFriendInfoFrameContinueButton:SetText('继续')

    FriendsTabHeaderTab1:SetText('好友')
    FriendsTabHeaderTab2:SetText('屏蔽')
        FriendsFrameIgnorePlayerButton:SetText('添加')
        FriendsFrameUnsquelchButton:SetText('移除')
    FriendsTabHeaderTab3:SetText('招募战友')
        if RecruitAFriendFrame then
            local function set_UpdateRAFInfo(self, rafInfo)
                if self.rafEnabled and rafInfo and #rafInfo.versions > 0 then
                    local latestRAFVersionInfo = self:GetLatestRAFVersionInfo()
                    if (latestRAFVersionInfo.numRecruits == 0) and (latestRAFVersionInfo.monthCount.lifetimeMonths == 0) then
                        self.RewardClaiming.MonthCount:SetText('招募战友即可开始！')
                    else
                        self.RewardClaiming.MonthCount:SetFormattedText('招募战友已奖励%d个月', latestRAFVersionInfo.monthCount.lifetimeMonths)
                    end
                end
            end
            hooksecurefunc(RecruitAFriendFrame, 'UpdateRAFInfo', set_UpdateRAFInfo)
            set_UpdateRAFInfo(RecruitAFriendFrame, RecruitAFriendFrame.rafInfo)

            local function set_UpdateNextReward(self, nextReward)--C_RecruitAFriend.GetRAFInfo()
                if nextReward then
                    if nextReward.canClaim then
                        self.RewardClaiming.EarnInfo:SetText('你获得了：')
                    elseif nextReward.monthCost > 1 then
                        self.RewardClaiming.EarnInfo:SetFormattedText('下一个奖励 (|cnGREEN_FONT_COLOR:%d|r/%d个月)：', nextReward.monthCost - nextReward.availableInMonths, nextReward.monthCost)
                    elseif nextReward.monthsRequired == 0 then
                        self.RewardClaiming.EarnInfo:SetText('第一个奖励：')
                    else
                        self.RewardClaiming.EarnInfo:SetText('下一个奖励：')
                    end

                    if not nextReward.petInfo and not nextReward.appearanceInfo and not nextReward.appearanceSetInfo and not nextReward.illusionInfo then
                        if nextReward.titleInfo then
                            local titleName = TitleUtil.GetNameFromTitleMaskID(nextReward.titleInfo.titleMaskID)
                            if titleName then
                                self:SetNextRewardName(format('新头衔：|cnGREEN_FONT_COLOR:%s|r', titleName), nextReward.repeatableClaimCount, nextReward.rewardType)
                            end
                        else
                            self:SetNextRewardName('30天免费游戏时间', nextReward.repeatableClaimCount, nextReward.rewardType)
                        end
                    end
                end
            end
            hooksecurefunc(RecruitAFriendFrame, 'UpdateNextReward', set_UpdateNextReward)
            if RecruitAFriendFrame.rafEnabled and RecruitAFriendFrame.rafInfo and #RecruitAFriendFrame.rafInfo.versions > 0 then
                local latestRAFVersionInfo = RecruitAFriendFrame:GetLatestRAFVersionInfo() or {}
                set_UpdateNextReward(RecruitAFriendFrame, latestRAFVersionInfo.nextReward)
            end

            hooksecurefunc(RecruitAFriendFrame.RewardClaiming.ClaimOrViewRewardButton, 'Update', function(self)
                if self.haveUnclaimedReward then
                    self:SetText('获取奖励')
                else
                    self:SetText('查看所有奖励')
                end
            end)
            if RecruitAFriendFrame.RewardClaiming.ClaimOrViewRewardButton.haveUnclaimedReward then
                RecruitAFriendFrame.RewardClaiming.ClaimOrViewRewardButton:SetText('获取奖励')
            else
                RecruitAFriendFrame.RewardClaiming.ClaimOrViewRewardButton:SetText('查看所有奖励')
            end

            RecruitAFriendFrame.RecruitList.Header.RecruitedFriends:SetText('已招募的战友')
            RecruitAFriendFrame.RecruitList.NoRecruitsDesc:SetText('|cffffd200招募战友后，战友每充值一个月的游戏时间，你就能获得一次奖励。|n|n若战友一次充值的游戏时间超过一个月，奖励会逐月进行发放。|n|n一起游戏还能解锁额外奖励！|r|n|n更多信息：|n|HurlIndex:49|h|cff82c5ff访问我们的战友招募网站|r|h')
            RecruitAFriendFrame.RecruitmentButton:SetText('招募')
            RecruitAFriendFrame.RewardClaiming.NextRewardInfoButton:HookScript('OnEnter', function()
                GameTooltip_AddNormalLine(GameTooltip, '招募好友后，当好友开始订阅时，你就能开始获得奖励。')
                GameTooltip:Show()
            end)

            RecruitAFriendRewardsFrame.Title:SetText('战友招募奖励')
            hooksecurefunc(RecruitAFriendRewardsFrame, 'UpdateDescription', function(self, selectedRAFVersionInfo)
                self.Description:SetText((selectedRAFVersionInfo.rafVersion == self:GetRecruitAFriendFrame():GetLatestRAFVersion()) and '每名拥有可用的游戏时间的被招募者|n每30天可以为你提供一份月度奖励。' or '不能再为旧版招募活动再招募新的战友，但是旧版现有的被招募的战友还会继续提供战友招募奖励。')
            end)


            RecruitAFriendRewardsFrame.VersionInfoButton:HookScript('OnEnter', function(self)
                local recruitAFriendFrame = self:GetRecruitAFriendFrame()
                local selectedVersionInfo = recruitAFriendFrame:GetSelectedRAFVersionInfo()
                local helpText = recruitAFriendFrame:IsLegacyRAFVersion(selectedVersionInfo.rafVersion) and '当前激活的旧版招募战友：|cnHIGHLIGHT_FONT_COLOR:%d|r|n尚未领取的奖励：|cnHIGHLIGHT_FONT_COLOR:%d|r' or '当前激活的招募战友：|cnHIGHLIGHT_FONT_COLOR:%d|r|n尚未领取的奖励：|cnHIGHLIGHT_FONT_COLOR:%d|r'
                GameTooltip_AddNormalLine(GameTooltip, ' ')
                GameTooltip_AddNormalLine(GameTooltip, helpText:format(selectedVersionInfo.numRecruits, selectedVersionInfo.numAffordableRewards))
                GameTooltip:Show()
            end)

            RecruitAFriendRecruitmentFrame.Title:SetText('招募')

            hooksecurefunc(RecruitAFriendRecruitmentFrame, 'UpdateRecruitmentInfo', function(self, recruitmentInfo, recruitsAreMaxed)
                local maxRecruits = 0
                local maxRecruitLinkUses = 0
                local daysInCycle = 0
                local rafSystemInfo = C_RecruitAFriend.GetRAFSystemInfo()
                if rafSystemInfo then
                    maxRecruits = rafSystemInfo.maxRecruits
                    maxRecruitLinkUses = rafSystemInfo.maxRecruitmentUses
                    daysInCycle = rafSystemInfo.daysInCycle
                end

                if recruitmentInfo then
                    local expireDate = date("*t", recruitmentInfo.expireTime)
                    recruitmentInfo.expireDateString = FormatShortDate(expireDate.day, expireDate.month, expireDate.year)

                    self.Description:SetFormattedText('招募战友，与你一起游玩《魔兽世界》！|n你每%2$d天可以邀请%1$d个战友。', recruitmentInfo.totalUses, daysInCycle)

                    if recruitmentInfo.sourceFaction ~= "" then
                        local region= e.Get_Region(recruitmentInfo.sourceRealm)
                        local reaml= (region and region.col or '')..(recruitmentInfo.sourceRealm or '')
                        self.FactionAndRealm:SetFormattedText('我们会鼓励你的战友在%2$s服务器创建一个%1$s角色，从而加入你的冒险。', e.strText[recruitmentInfo.sourceFaction] or recruitmentInfo.sourceFaction, reaml)
                    end
                else
                    local PLAYER_FACTION_NAME= UnitFactionGroup('player')=='Alliance' and PLAYER_FACTION_COLOR_ALLIANCE:WrapTextInColorCode('联盟') or (UnitFactionGroup('player')=='Horde' and PLAYER_FACTION_COLOR_HORDE:WrapTextInColorCode('部落')) or '中立'
                    self.Description:SetFormattedText('招募战友，与你一起游玩《魔兽世界》！|n你每%2$d天可以邀请%1$d个战友。', maxRecruitLinkUses, daysInCycle)
                    self.FactionAndRealm:SetFormattedText('我们会鼓励你的战友在%2$s服务器创建一个%1$s角色，从而加入你的冒险。', PLAYER_FACTION_NAME, GetRealmName())
                end

                if recruitsAreMaxed then
                    self.InfoText1:SetFormattedText('"%d/%d 已招募的战友。已达到最大招募数量。', maxRecruits, maxRecruits)
                elseif recruitmentInfo then
                    if recruitmentInfo.remainingUses > 0 then
                        self.InfoText:SetFormattedText('此链接会在|cnGREEN_FONT_COLOR:%s|r后过期', recruitmentInfo.expireDateString)
                    else
                        self.InfoText1:SetFormattedText('你在|cnGREEN_FONT_COLOR:%s|r后即可创建一个新链接', recruitmentInfo.expireDateString)
                    end


                    local timesUsed = recruitmentInfo.totalUses - recruitmentInfo.remainingUses
                    self.InfoText2:SetFormattedText('%d/%d 名朋友已经使用了这个链接。', timesUsed, recruitmentInfo.totalUses)
                end
            end)
        end

        hooksecurefunc(RecruitAFriendRecruitmentFrame.GenerateOrCopyLinkButton, 'Update', function(self, recruitmentInfo)
            recruitmentInfo= recruitmentInfo or self.recruitmentInfo
            if recruitmentInfo then
                RecruitAFriendRecruitmentFrameText:SetText('复制链接')
            else
                RecruitAFriendRecruitmentFrameText:SetText('创建链接')
            end
        end)

FriendsFrameTab2:SetText('查询')
    WhoFrameWhoButton:SetText('刷新')
    WhoFrameAddFriendButton:SetText('添加好友')
    WhoFrameGroupInviteButton:SetText('组队邀请')
    FriendsFrameSendMessageButton:SetText('发送信息')
FriendsFrameTab3:SetText('团队')
    RaidFrameAllAssistCheckButtonText:SetText('所有|TInterface\\GroupFrame\\UI-Group-AssistantIcon:12:12:0:1|t')
    RaidFrameAllAssistCheckButton:HookScript('OnEnter', function(self)
        GameTooltip:AddLine('钩选此项可使所有团队成员都获得团队助理权限', nil, nil, nil, true)
        if ( not self:IsEnabled() ) then
            GameTooltip:AddLine('|cnRED_FONT_COLOR:只有团队领袖才能更改此项设置。', nil, nil, nil, true)
        end
        GameTooltip:Show()
    end)
    WhoFrameColumnHeader1:SetText('名称')
    WhoFrameColumnHeader4:SetText('职业')
    hooksecurefunc('WhoList_Update', function()
        local _, totalCount = C_FriendList.GetNumWhoResults()
        local displayedText = ""
        if ( totalCount > MAX_WHOS_FROM_SERVER ) then
            displayedText = format('（显示%d）', MAX_WHOS_FROM_SERVER)
        end
        WhoFrameTotals:SetText(format('找到%d个人', totalCount).."  "..displayedText)
    end)
    RaidFrameRaidInfoButton:SetText('团队信息')
        RaidInfoFrame.Header.Text:SetText('团队信息')
        RaidInfoInstanceLabel.text:SetText('副本')
        RaidInfoIDLabel.text:SetText('锁定过期')
        hooksecurefunc('RaidInfoFrame_UpdateButtons', function()
            if RaidInfoFrame.selectedIndex then
                if RaidInfoFrame.selectedIsInstance then
                    local _, _, _, _, locked, extended= GetSavedInstanceInfo(RaidInfoFrame.selectedIndex)
                    if extended then
                        RaidInfoExtendButton:SetText('移除副本锁定延长')
                    else
                        RaidInfoExtendButton:SetText(locked and '延长副本锁定' or '重新激活副本锁定')
                    end
                else
                    RaidInfoExtendButton:SetText('延长副本锁定')
                end
            else
                RaidInfoExtendButton:SetText('延长副本锁定')
            end
        end)
        hooksecurefunc('RaidInfoFrame_InitButton', function(button, elementData)--RaidFrame.lua
            local function InitButton(extended, locked, name, difficulty, difficultyId)
                name= e.strText[name]
                if extended or locked then
                    e.set(button.name, name)
                else
                    button.reset:SetFormattedText("|cff808080%s|r", '已过期')
                    if name then
                        button.name:SetFormattedText("|cff808080%s|r", name)
                    end
                end

                local difficultyText= difficultyId and e.GetDifficultyColor(difficulty, difficultyId) or e.strText[difficulty]
                button.difficulty:SetText(difficultyText)

                if button.extended:IsShown() then
                    button.extended:SetText('|cff00ff00已延长|r')
                end
            end

            local index = elementData.index
            if elementData.isInstance then
                local name, _, _, difficultyId, locked, extended, _, _, _, difficultyName = GetSavedInstanceInfo(index)
                InitButton(extended, locked, name, difficultyName, difficultyId)
            else
                local name = GetSavedWorldBossInfo(index)
                local locked = true
                local extended = false
                --[[if index==1 then--Sha della Rabbia
                    e.strText[name]= '怒之煞'
                elseif index==2 then --Galeone
                    e.strText[name]= '炮舰'
                elseif index==3 then--Nalak
                    e.strText[name]= '纳拉克'
                elseif index==4 then --Undasta
                    e.strText[name]= '乌达斯塔'
                elseif index==9 then--Rukhmar
                    e.strText[name]= '鲁克玛'
                end]]
                InitButton(extended, locked, name, RAID_INFO_WORLD_BOSS)
            end
        end)
        hooksecurefunc('RaidFrame_OnShow', function(self)
            self:GetParent():GetTitleText():SetText('团队')
        end)
        RaidInfoCancelButton:SetText('关闭')


    RaidFrameConvertToRaidButton:SetText('转化为团队')
    RaidFrameRaidDescription:SetText('团队是超过5个人的队伍，这是为了击败高等级的特定挑战而准备的大型队伍模式。\n\n|cffffffff- 团队成员无法获得非团队任务所需的物品或者杀死怪物的纪录。\n\n- 在团队中，你通过杀死怪物获得的经验值相对普通小队要少。\n\n- 团队让你可以赢得用其它方法根本无法通过的挑战。|r')



hooksecurefunc('FriendsFrame_UpdateQuickJoinTab', function(numGroups)--FriendsFrame.lua
    if numGroups then
        FriendsFrameTab4:SetText('快速加入'.. (numGroups>0 and '|cnGREEN_FONT_COLOR:' or '')..numGroups)
    end
end)
hooksecurefunc(QuickJoinFrame, 'UpdateJoinButtonState', function(self)--QuickJoin.lua
    self.JoinQueueButton:SetText('申请加入')
    if ( IsInGroup(LE_PARTY_CATEGORY_HOME) ) then
        self.JoinQueueButton.tooltip = '你已在一个队伍中。你必须离开队伍才能加入此队列。'
    elseif  self:GetSelectedGroup() ~= nil then
        local queues = C_SocialQueue.GetGroupQueues(self:GetSelectedGroup())
        if ( queues and queues[1] and queues[1].queueData.queueType == "lfglist" ) then
            self.JoinQueueButton:SetText('申请')
        end
    end
end)
--FriendsFrame.xml
BattleTagInviteFrame.InfoText:SetText('当他们接受你的好友请求后，就会被加入你的好友名单。')
e.reg(BattleTagInviteFrame, '发送一个|cff82c5ff战网昵称|r请求给：', 1)





--银行
--BankFrame.lua
BankFrameTab1.Text:SetText('银行')
BankFrameTab2.Text:SetText('材料')
BANK_PANELS[2].SetTitle=function() BankFrame:SetTitle('材料银行') end
if ReagentBankFrame.DespositButton:GetText()~='' then
    ReagentBankFrame.DespositButton:SetText('存放各种材料')
end
BankItemSearchBox.Instructions:SetText('搜索')
e.reg(BankSlotsFrame)




--就绪
--ReadyCheck.lua
ReadyCheckListenerFrame.TitleContainer.TitleText:SetText('就位确认')
ReadyCheckFrameYesButton:SetText('就绪')--:SetText(GetText("READY", UnitSex("player")))
ReadyCheckFrameNoButton:SetText('未就绪')--:SetText(GetText("NOT_READY", UnitSex("player")))


--插件
AddonListTitleText:SetText('插件列表')
e.reg(AddonListForceLoad, '加载过期插件', 1)

AddonListEnableAllButton:SetText('全部启用')
AddonListDisableAllButton:SetText('全部禁用')
hooksecurefunc('AddonList_Update', function()--AddonList.lua
    if ( not InGlue() ) then
        if ( AddonList_HasAnyChanged() ) then
            AddonListOkayButton:SetText('重新加载UI')
        else
            AddonListOkayButton:SetText('确定')
        end
    end
end)
AddonListCancelButton:SetText('取消')
hooksecurefunc('AddonList_InitButton', function(entry, addonIndex)
    local security = select(6, C_AddOns.GetAddOnInfo(addonIndex))
    -- Get the character from the current list (nil is all characters)
    local character = UIDropDownMenu_GetSelectedValue(AddonCharacterDropDown)
    if ( character == true ) then
        character = nil
    end
    local loadable, reason = C_AddOns.IsAddOnLoadable(addonIndex, character)
    local checkboxState = C_AddOns.GetAddOnEnableState(addonIndex, character)
    if (checkboxState == Enum.AddOnEnableState.Some ) then
        entry.Enabled.tooltip = '该插件只对某些角色启用。'
    end
    local name= _G["ADDON_"..security]
    if name then
        local text2= e.strText[name]
        if text2 then
            entry.Security.tooltip = text2
        end
        if ( not loadable and reason ) then
            e.set(entry.Status, name)
        end
    end
end)

--拾取
GroupLootHistoryFrameTitleText:SetText('战利品掷骰')
GroupLootHistoryFrame.NoInfoString:SetText('地下城和团队副本的战利品掷骰在此显示')

--邮箱 MailFrame.lua
--MailFrame:HookScript('OnShow', function(self)
InboxTooMuchMailText:SetText('你的收件箱已满。')
MailFrameTrialError:SetText('你需要升级你的账号才能开启这项功能。')
hooksecurefunc('MailFrameTab_OnClick', function(self, tabID)
    tabID = tabID or self:GetID()
    if tabID == 1  then
        MailFrame:SetTitle('收件箱')
    elseif tabID==2 then
        MailFrame:SetTitle('发件箱')
    end
end)
MailFrameTab1:SetText('收件箱')
    OpenAllMail:SetText('全部打开')
    hooksecurefunc(OpenAllMail,'StartOpening', function(self)
        self:SetText('正在打开……')
    end)
    hooksecurefunc(OpenAllMail,'StopOpening', function(self)
        self:SetText('全部打开')
    end)
    hooksecurefunc('InboxFrame_Update', function()
        local numItems = GetInboxNumItems()
        local index = ((InboxFrame.pageNum - 1) * INBOXITEMS_TO_DISPLAY) + 1
        for i=1, INBOXITEMS_TO_DISPLAY do
            if ( index <= numItems ) then
                local daysLeft = select(7, GetInboxHeaderInfo(index))
                if ( daysLeft >= 1 ) then
                    daysLeft = GREEN_FONT_COLOR_CODE..format('%d|4天:天', floor(daysLeft)).." "..FONT_COLOR_CODE_CLOSE
                else
                    daysLeft = RED_FONT_COLOR_CODE..SecondsToTime(floor(daysLeft * 24 * 60 * 60))..FONT_COLOR_CODE_CLOSE
                end
                local expireTime= _G["MailItem"..i.."ExpireTime"]
                if expireTime then
                    e.set(expireTime, daysLeft)
                    if ( InboxItemCanDelete(index) ) then
                        expireTime.tooltip = '信息保留时间'
                    else
                        expireTime.tooltip = '信息退回时间'
                    end
                end
            end
            index = index + 1
        end
    end)
    local region= InboxPrevPageButton:GetRegions()
    if region and region:GetObjectType()=='FontString' then
        region:SetText('上一页')
    end
    region= InboxNextPageButton:GetRegions()
    if region and region:GetObjectType()=='FontString' then
        region:SetText('下一页')
    end
    --[[region= select(3, SendMailNameEditBox:GetRegions())
    if region and region:GetObjectType()=='FontString' then
        region:SetText('收件人：')
    end]]
    region= select(3, SendMailSubjectEditBox:GetRegions())
    if region and region:GetObjectType()=='FontString' then
        region:SetText('主题：')
    end



MailFrameTab2:SetText('发件箱')
    SendMailMailButton:SetText('发送')
    SendMailCancelButton:SetText('取消')
    hooksecurefunc('SendMailRadioButton_OnClick', function(index)--MailFrame.lua
        if ( index == 1 ) then
            SendMailMoneyText:SetText('|cnRED_FONT_COLOR:寄送金额：')
        else
            SendMailMoneyText:SetText('|cnGREEN_FONT_COLOR:付款取信邮件的金额')
        end
    end)
    SendMailSendMoneyButtonText:SetText('|cnRED_FONT_COLOR:发送钱币')
    SendMailCODButtonText:SetText('|cnGREEN_FONT_COLOR:付款取信')
    hooksecurefunc('SendMailAttachment_OnEnter', function(self)
        local index = self:GetID()
        if ( not HasSendMailItem(index) ) then
            GameTooltip:SetText('将物品放在这里随邮件发送', 1.0, 1.0, 1.0)
        end
    end)


    OpenMailSenderLabel:SetText('来自：')
    OpenMailSubjectLabel:SetText('主题：')
    hooksecurefunc('OpenMail_Update', function()
        if not InboxFrame.openMailID then
            return
        end
        local _, _, _, _, isInvoice, isConsortium = GetInboxText(InboxFrame.openMailID)
        if ( isInvoice ) then
            local invoiceType, itemName, playerName, _, _, _, _, _, etaHour, etaMin, count, commerceAuction = GetInboxInvoiceInfo(InboxFrame.openMailID)
            if ( invoiceType ) then
                if ( playerName == nil ) then
                    playerName = (invoiceType == "buyer") and '多个卖家' or '多个买家'
                end
                local multipleSale = count and count > 1
                if ( multipleSale ) then
                    itemName = format(AUCTION_MAIL_ITEM_STACK, itemName, count)
                end
                OpenMailInvoicePurchaser:SetShown(not commerceAuction)
                if ( invoiceType == "buyer" ) then
                    OpenMailInvoicePurchaser:SetText("销售者： "..playerName)
                    OpenMailInvoiceAmountReceived:SetText('|cnRED_FONT_COLOR:付费金额：')
                elseif (invoiceType == "seller") then
                    OpenMailInvoiceItemLabel:SetText("物品售出： "..itemName)
                    OpenMailInvoicePurchaser:SetText("购买者： "..playerName)
                    OpenMailInvoiceAmountReceived:SetText('|cnGREEN_FONT_COLOR:收款金额：')

                elseif (invoiceType == "seller_temp_invoice") then
                    OpenMailInvoiceItemLabel:SetText("物品售出： "..itemName)
                    OpenMailInvoicePurchaser:SetText("购买者： "..playerName)
                    OpenMailInvoiceAmountReceived:SetText('等待发送的数量：')
                    OpenMailInvoiceMoneyDelay:SetFormattedText('预计投递时间%s', GameTime_GetFormattedTime(etaHour, etaMin, true))
                end
            end
        end

        if ( isConsortium ) then
            local info = C_Mail.GetCraftingOrderMailInfo(InboxFrame.openMailID) or {}
            if ( info.reason == Enum.RcoCloseReason.RcoCloseCancel ) then
                ConsortiumMailFrame.OpeningText:SetText('你的制造订单已被取消。')
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseExpire ) then
                ConsortiumMailFrame.OpeningText:SetText('你的制造订单已过期。')
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseFulfill ) then
                ConsortiumMailFrame.OpeningText:SetFormattedText('订单：%s',info.recipeName)
                ConsortiumMailFrame.CrafterText:SetFormattedText('完成者：|cnHIGHLIGHT_FONT_COLOR:%s|r', info.crafterName or "")
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseReject ) then
                ConsortiumMailFrame.OpeningText:SetFormattedText('订单：%s', info.recipeName)
                ConsortiumMailFrame.CrafterText:SetFormattedText('|cnHIGHLIGHT_FONT_COLOR:%s|r决定不完成此订单。', info.crafterName or "")
            elseif ( info.reason == Enum.RcoCloseReason.RcoCloseCrafterFulfill ) then
                ConsortiumMailFrame.OpeningText:SetFormattedText('订单：%s', info.recipeName)
                ConsortiumMailFrame.CrafterText:SetFormattedText('收件人：%s', info.customerName or "")
                ConsortiumMailFrame.ConsortiumNote:SetFormattedText('嗨，%1$s，你完成了%3$s的%2$s的订单，但还没寄给对方。因为你的订单即将过期，所以我们在没有收取额外费用的情况下帮你寄出去了！附上你的佣金。', UnitName("player"), info.recipeName, info.customerName or "")
            end
        end

        if (OpenMailFrame.itemButtonCount and OpenMailFrame.itemButtonCount > 0 ) then
            OpenMailAttachmentText:SetText('|cnGREEN_FONT_COLOR:拿取附件：')
        else
            OpenMailAttachmentText:SetText('无附件')
        end
        if InboxItemCanDelete(InboxFrame.openMailID) then
            OpenMailDeleteButton:SetText('删除')
        else
            OpenMailDeleteButton:SetText('退信')
        end
        OpenMailFrameTitleText:SetText('打开邮件')
    end)
    OpenMailReplyButton:SetText('回复')
    OpenMailCancelButton:SetText('关闭')
OpenMailInvoiceSalePrice:SetText('售价：')
OpenMailInvoiceDeposit:SetText('保证金：')
OpenMailInvoiceHouseCut:SetText('拍卖费：')
OpenMailInvoiceNotYetSent:SetText('未发送的数量')

OpenMailReportSpamButton:SetText('举报玩家')
ConsortiumMailFrame.CommissionReceived:SetText('附上佣金：')
ConsortiumMailFrame.CommissionPaidDisplay.CommissionPaidText:SetText('已支付佣金：')

hooksecurefunc('GuildChallengeAlertFrame_SetUp', function(frame, challengeType)--AlertFrameSystems.lua
    local name= _G["GUILD_CHALLENGE_TYPE"..challengeType]
    if name then
        e.set(frame.Type, name)
    end
end)

hooksecurefunc('AchievementAlertFrame_SetUp', function(frame, achievementID, alreadyEarned)
    --local _, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuildAch, wasEarnedByMe, earnedBy = select(12, GetAchievementInfo(achievementID)
    local unlocked = frame.Unlocked
    if select(12, GetAchievementInfo(achievementID)) then
        unlocked:SetText('获得公会成就')
    else
        unlocked:SetText('已获得成就')
    end
end)

hooksecurefunc('LootWonAlertFrame_SetUp', function(self, _, _, _, _, _, _, _, _, _, _, _, _, _, isSecondaryResult)
    if isSecondaryResult then
        self.Label:SetText('你获得了')--YOU_RECEIVED_LABEL
    end
end)

hooksecurefunc('HonorAwardedAlertFrame_SetUp', function(self, amount)
    self.Amount:SetFormattedText('%d点荣誉', amount)
end)
hooksecurefunc('GarrisonShipFollowerAlertFrame_SetUp', function(frame, _, _, _, _, _, _, isUpgraded)
    if ( isUpgraded ) then
        frame.Title:SetText('升级的舰船已加入你的舰队')
    else
        frame.Title:SetText('舰船已加入你的舰队')
    end
end)
hooksecurefunc('NewRecipeLearnedAlertFrame_SetUp', function(self, recipeID, recipeLevel)
    local tradeSkillID = C_TradeSkillUI.GetTradeSkillLineForRecipe(recipeID)
    if tradeSkillID then
        local recipeName = C_Spell.GetSpellName(recipeID)
        if recipeName then
            local rank = C_Spell.GetSpellSkillLineAbilityRank(recipeID)
            self.Title:SetText(rank and rank > 1 and '配方升级！' or '学会了新配方！')

            if recipeLevel ~= nil then
                recipeName = format('%s (等级 %i)', recipeName, recipeLevel)
                local rankTexture = NewRecipeLearnedAlertFrame_GetStarTextureFromRank(rank)
                if rankTexture then
                    self.Name:SetFormattedText("%s %s", recipeName, rankTexture)
                else
                    self.Name:SetText(recipeName)
                end
            end
        end
    end
end)

hooksecurefunc(SkillLineSpecsUnlockedAlertFrameMixin,'SetUp', function(self, skillLineID)
    self.Title:SetText('解锁新要素：')
    self.Name:SetFormattedText('%s专精', C_TradeSkillUI.GetTradeSkillDisplayName(skillLineID))
end)
hooksecurefunc('WorldQuestCompleteAlertFrame_SetUp', function(frame, questData)
    frame.ToastText:SetText(questData.displayAsObjective and '目标完成！' or '世界任务完成！')
end)

hooksecurefunc(ItemAlertFrameMixin, 'SetUpDisplay', function(self, _, _, _, label)
    if label== YOU_COLLECTED_LABEL then
        self.Label:SetText('你收集到了')
    end
end)

--死亡
GhostFrameContentsFrameText:SetText('返回墓地')

--宠物对战
if PetBattleFrame then
    PetBattleFrame.BottomFrame.TurnTimer.SkipButton:SetText('待命')
end

--任务对话框
GossipFrame.GreetingPanel.GoodbyeButton:SetText('再见')
QuestFrameAcceptButton:SetText('接受')
QuestFrameGreetingGoodbyeButton:SetText('再见')
QuestFrameCompleteQuestButton:SetText('完成任务')
QuestFrameCompleteButton:SetText('继续')
QuestFrameGoodbyeButton:SetText('再见')
QuestFrameDeclineButton:SetText('拒绝')
QuestLogPopupDetailFrameAbandonButton:SetText('放弃')
QuestLogPopupDetailFrameShareButton:SetText('共享')
QuestLogPopupDetailFrame.ShowMapButton.Text:SetText('显示地图')

--[[QuestMapFrame.DetailsFrame.BackButton:SetText('返回')
QuestMapFrame.DetailsFrame.AbandonButton:SetText('放弃')]]

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

QuestMapFrame.DetailsFrame.ShareButton:SetText('共享')
QuestMapFrame.DetailsFrame.DestinationMapButton.tooltipText= '显示最终目的地'
QuestMapFrame.DetailsFrame.WaypointMapButton.tooltipText= '显示旅行路径'

e.reg(QuestMapFrame.DetailsFrame.RewardsFrame, '奖励')
MapQuestInfoRewardsFrame.ItemChooseText:SetText('你可以从这些奖励品中选择一件：')
MapQuestInfoRewardsFrame.PlayerTitleText:SetText('新头衔： %s')
MapQuestInfoRewardsFrame.QuestSessionBonusReward:SetText('在小队同步状态下完成此任务有可能获得奖励：')
QuestInfoRequiredMoneyText:SetText('需要金钱：')
QuestInfoRewardsFrame.ItemChooseText:SetText('你可以从这些奖励品中选择一件：')
QuestInfoRewardsFrame.PlayerTitleText:SetText('新头衔： %s')
QuestInfoRewardsFrame.QuestSessionBonusReward:SetText('在小队同步状态下完成此任务有可能获得奖励：')


hooksecurefunc(WorldMapFrame, 'SetupTitle', function(self)
    self.BorderFrame:SetTitle('地图和任务日志')
end)
hooksecurefunc(WorldMapFrame, 'SynchronizeDisplayState', function(self)
    if self:IsMaximized() then
        self.BorderFrame:SetTitle('地图')
    else
        self.BorderFrame:SetTitle('地图和任务日志')
    end
end)
e.font(WorldMapFrameHomeButtonText)
WorldMapFrameHomeButtonText:SetText('世界')

local optionButton=WorldMapFrame.overlayFrames[2]
if optionButton then
    optionButton:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '地图筛选')
        GameTooltip:Show()
    end)
end
local pingButton= WorldMapFrame.overlayFrames[3]
if pingButton then
    pingButton:HookScript('OnEnter', function(self)--WorldMapTrackingPinButtonMixin:OnEnter()
        GameTooltip_SetTitle(GameTooltip, '地图标记')
        local mapID = self:GetParent():GetMapID()
        if C_Map.CanSetUserWaypointOnMap(mapID) then
            GameTooltip_AddNormalLine(GameTooltip, '在地图上放置一个位置标记，此标记可以追踪，也可以分享给其他玩家。')
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            GameTooltip_AddInstructionLine(GameTooltip, '点击这个按钮，然后在地图上点击来放置一个标记，或者直接<按住Ctrl点击地图>。')
        else
            GameTooltip_AddErrorLine(GameTooltip, '你不能在这张地图上放置标记。')
        end
        GameTooltip:Show()
    end)
end
local threatButton=  WorldMapFrame.overlayFrames[7]
if threatButton then
    GameTooltip_SetTitle(GameTooltip, '恩佐斯突袭')
    GameTooltip_AddColoredLine(GameTooltip, '点击浏览被恩佐斯的军队突袭的地区。', GREEN_FONT_COLOR)
    GameTooltip:Show()
end


hooksecurefunc('MinimapMailFrameUpdate', function()
    local senders = { GetLatestThreeSenders() }
    local headerText = #senders >= 1 and '未读邮件来自：' or '你有未阅读的邮件'
    for i, sender in ipairs(senders) do
        headerText = headerText.."\n"..(e.strText[sender] or sender)
    end
    GameTooltip:SetText(headerText)
    GameTooltip:Show()
end)

--e.hookLabel(MinimapZoneText)

--背包
BagItemSearchBox.Instructions:SetText('搜索')

--SharedReportFrame.xml
ReportFrame.TitleText:SetText('《魔兽世界》客户支持')
hooksecurefunc(ReportFrame, 'InitiateReportInternal', function(self, reportInfo, playerName, playerLocation, isBnetReport, sendReportWithoutDialog)--SharedReportFrame.lua
    local name
    local guid= playerLocation and playerLocation.guid
    if guid then
        name= e.GetPlayerInfo({guid=guid, reName=true, reRealm=true})
    end
    name= name and name~='' and name or playerName
    self.ReportString:SetFormattedText('举报 %s', name)
end)
ReportFrame.ReportingMajorCategoryDropdown.Label:SetText('选择理由')

ReportFrame.MinorReportDescription:SetText('提供详细信息（选择所有适合的项目）')
ReportFrame.Comment.EditBox.Instructions:SetText('补充更多关于这次举报的细节（可选）')
hooksecurefunc(ReportingFrameMinorCategoryButtonMixin, 'SetupButton', function(self, minorCategory)
    local categoryName = minorCategory and _G[C_ReportSystem.GetMinorCategoryString(minorCategory)]
    e.set(self.Text, categoryName)
end)
ReportFrame.ThankYouText:SetText('感谢您的举报！')
ReportFrame.TitleText:SetText('《魔兽世界》客户支持')
ReportFrame.ReportButton:SetText('举报')



























--编辑模式    
EditModeManagerFrame.Title:SetText('HUD编辑模式')
EditModeManagerFrame.Tutorial.MainHelpPlateButtonTooltipText= '点击这里打开/关闭编辑模式的帮助系统。'
EditModeManagerFrame.ShowGridCheckButton.Label:SetText('显示网格')
EditModeManagerFrame.EnableSnapCheckButton.Label:SetText('贴附到界面元素上')
EditModeManagerFrame.EnableAdvancedOptionsCheckButton.Label:SetText('高级选项')
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.FramesTitle.Title:SetText('框体')
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.CombatTitle.Title:SetText('战斗')
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.MiscTitle.Title:SetText('其它')
e.set(EditModeManagerFrame.LayoutLabel)--布局：
hooksecurefunc(EditModeManagerFrame.AccountSettings, 'SetExpandedState', function(self, expanded, isUserInput)
    self.Expander.Label:SetText(expanded and '收起选项 |A:editmode-up-arrow:16:11:0:3|a' or '展开选项 |A:editmode-down-arrow:16:11:0:-7|a')
end)
EditModeManagerFrame.AccountSettings.Expander.Label:SetText('展开选项 |A:editmode-down-arrow:16:11:0:-7|a')
EditModeManagerFrame.RevertAllChangesButton:SetText('撤销所有变更')
EditModeManagerFrame.SaveChangesButton:SetText('保存')

--EditModeDialogs.lua
EditModeUnsavedChangesDialog.CancelButton:SetText('取消')
hooksecurefunc(EditModeUnsavedChangesDialog, 'ShowDialog', function(self, selectedLayoutIndex)
    if selectedLayoutIndex then
        self.Title:SetText('如果你切换布局，你会丢失所有未保存的改动。|n你想继续吗？')
        self.SaveAndProceedButton:SetText('保存并切换')
        self.ProceedButton:SetText('切换')
    else
        self.Title:SetText('如果你现在退出，你会丢失所有未保存的改动。|n你想继续吗？')
        self.SaveAndProceedButton:SetText('保存并退出')
        self.ProceedButton:SetText('退出')
    end
end)

hooksecurefunc(EditModeSystemSettingsDialog, 'AttachToSystemFrame', function(self, systemFrame)
    local name= systemFrame:GetSystemName()
    e.set(self.Title, name)
end)

EditModeNewLayoutDialog.Title:SetText('给新布局起名')
EditModeNewLayoutDialog.CharacterSpecificLayoutCheckButton.Label:SetText('角色专用布局')
EditModeNewLayoutDialog.AcceptButton:SetText('保存')
EditModeNewLayoutDialog.CancelButton:SetText('取消')

EditModeImportLayoutDialog.Title:SetText('导入布局')
EditModeImportLayoutDialog.EditBoxLabel:SetText('导入文本：')
EditModeImportLayoutDialog.ImportBox.EditBox.Instructions:SetText('在此粘贴布局代码')
EditModeImportLayoutDialog.NameEditBoxLabel:SetText('新布局名称：')
EditModeImportLayoutDialog.CharacterSpecificLayoutCheckButton.Label:SetText('角色专用布局')
EditModeImportLayoutDialog.AcceptButton:SetText('导入')
EditModeImportLayoutDialog.CancelButton:SetText('取消')


EditModeImportLayoutDialog.AcceptButton.disabledTooltip= '输入布局的名称'
EditModeNewLayoutDialog.AcceptButton.disabledTooltip= '输入布局的名称'

local function CheckForMaxLayouts(acceptButton, charSpecificButton)
    if EditModeManagerFrame:AreLayoutsFullyMaxed() then
        acceptButton.disabledTooltip = format('最多允许%d种角色布局和%d种账号布局', Constants.EditModeConsts.EditModeMaxLayoutsPerType, Constants.EditModeConsts.EditModeMaxLayoutsPerType)
        return true
    end
    local layoutType = charSpecificButton:IsControlChecked() and Enum.EditModeLayoutType.Character or Enum.EditModeLayoutType.Account
    local areLayoutsMaxed = EditModeManagerFrame:AreLayoutsOfTypeMaxed(layoutType)
    if areLayoutsMaxed then
        acceptButton.disabledTooltip = (layoutType == Enum.EditModeLayoutType.Character) and format('只允许有%d个角色专用的布局。勾选以保存一种账号通用的布局', Constants.EditModeConsts.EditModeMaxLayoutsPerType) or format('只允许有%d个账号通用的布局。勾选以保存一种角色专用的布局', Constants.EditModeConsts.EditModeMaxLayoutsPerType)
        return true
    end
end
local function CheckForDuplicateLayoutName(acceptButton, editBox)
    local editBoxText = editBox:GetText()
    local editModeLayouts = EditModeManagerFrame:GetLayouts()
    for _, layout in ipairs(editModeLayouts) do
        if layout.layoutName == editBoxText then
            acceptButton.disabledTooltip = '该名称已被使用。'
            return true
        end
    end
end
hooksecurefunc(EditModeImportLayoutDialog, 'UpdateAcceptButtonEnabledState', function(self)
    if not CheckForMaxLayouts(self.AcceptButton, self.CharacterSpecificLayoutCheckButton)
        and not CheckForDuplicateLayoutName(self.AcceptButton, self.LayoutNameEditBox)  then
        self.AcceptButton.disabledTooltip = '输入布局的名称'
    end
end)
hooksecurefunc(EditModeNewLayoutDialog, 'UpdateAcceptButtonEnabledState', function(self)
    if not CheckForMaxLayouts(self.AcceptButton, self.CharacterSpecificLayoutCheckButton)
        and not CheckForDuplicateLayoutName(self.AcceptButton, self.LayoutNameEditBox)  then
        self.AcceptButton.disabledTooltip = '输入布局的名称'
    end
end)

--EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.CombatContainer

for _, frame in pairs(EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.BasicOptionsContainer:GetLayoutChildren() or {}) do
    e.set(frame.Label)
end

EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.FramesContainer:HookScript('OnShow', function(self)
    for _,frame in pairs(self:GetLayoutChildren() or {}) do
        e.set(frame.Label)
    end
end)
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.CombatContainer:HookScript('OnShow', function(self)
    for _,frame in pairs(self:GetLayoutChildren() or {}) do
        e.set(frame.Label)
    end
end)
EditModeManagerFrame.AccountSettings.SettingsContainer.ScrollChild.AdvancedOptionsContainer.MiscContainer:HookScript('OnShow', function(self)
    for _,frame in pairs(self:GetLayoutChildren() or {}) do
        local text= e.strText[frame.labelText]
        if text then
            frame:SetLabelText(text)
        end
        if frame.disabledTooltipText== HUD_EDIT_MODE_LOOT_FRAME_DISABLED_TOOLTIP then
            frame.disabledTooltipText= '你必须关闭位于：界面 > 控制菜单中的“鼠标位置打开拾取窗口”选项，才能自定义拾取窗口布局。'
        end
    end
end)
hooksecurefunc(EditModeManagerFrame.AccountSettings, 'SetupStatusTrackingBar2', function(self)
    self.settingsCheckButtons.StatusTrackingBar2:SetLabelText('状态栏 2')
end)


--EditModeTemplates.lua
hooksecurefunc(EditModeSettingCheckboxMixin, 'SetupSetting', function(self, settingData)
    e.set(self.Label, settingData.settingName)
end)
hooksecurefunc(EditModeSettingDropdownMixin, 'SetupSetting', function(self, settingData)
    e.set(self.Label, settingData.settingName)
end)
hooksecurefunc(EditModeSettingSliderMixin, 'SetupSetting', function(self, settingData)
    e.set(self.Label, settingData.settingName)
    if settingData.displayInfo.minText then
        e.set(self.Slider.MinText, settingData.displayInfo.minText)
    end
    if settingData.displayInfo.maxText then
        e.set(self.Slider.MaxText, settingData.displayInfo.maxText)
    end
end)


EditModeSystemSettingsDialog.Buttons.RevertChangesButton:SetText('撤销变更')
hooksecurefunc(EditModeSystemSettingsDialog, 'UpdateExtraButtons', function(self, systemFrame)
    if systemFrame == self.attachedToSystem then
        systemFrame.resetToDefaultPositionButton:SetText('重设到默认位置')
    end
end)
hooksecurefunc(EditModeSystemSettingsDialog, 'UpdateButtons', function(self, systemFrame)
    if systemFrame == self.attachedToSystem then
        if systemFrame.Selection then
            e.set(systemFrame.Selection.HorizontalLabel)
            e.set(systemFrame.Selection.Label)
            e.set(systemFrame.Selection.VerticalLabel)
        end
    end
end)







--ButtonTrayUtil.lua
if ButtonTrayUtil.TestCheckboxTraySetup then
    hooksecurefunc(ButtonTrayUtil, 'TestCheckboxTraySetup', function(button, labelText)--ButtonTrayUtil.lua
        e.set(button.Label, labelText)
    end)
end

hooksecurefunc(ButtonTrayUtil, 'TestButtonTraySetup', function(button, label)
    label= e.strText[label]
    if label then
        button:SetText(label)
    end
end)
hooksecurefunc(ResizeCheckButtonMixin, 'SetLabelText', function(self, labelText)
    e.set(self.Label, labelText)
end)




--Ping系统
PingSystemTutorialTitleText:SetText('信号系统')
PingSystemTutorial.Tutorial1.TutorialHeader:SetText('|cnTUTORIAL_BLUE_FONT_COLOR:按下|r信号键，在世界上放置快速信号。')
PingSystemTutorial.Tutorial2.TutorialHeader:SetText('|cnTUTORIAL_BLUE_FONT_COLOR:按下并按住|r信号键，选择一个特定的信号。')
PingSystemTutorial.Tutorial3.TutorialHeader:SetText('|cnTUTORIAL_BLUE_FONT_COLOR:直接|r向一名生物或角色发送信号。')
PingSystemTutorial.Tutorial4.TutorialHeader:SetText('|cnTUTORIAL_BLUE_FONT_COLOR:设置使用|r信号的宏。')
PingSystemTutorial.Tutorial4.ImageBounds.TutorialBody1:SetText('在聊天中|cnNORMAL_FONT_COLOR:输入/macro|r')
PingSystemTutorial.Tutorial4.ImageBounds.TutorialBody2:SetText('宏命令：')
PingSystemTutorial.Tutorial4.ImageBounds.TutorialBody3:SetText('|cnNORMAL_FONT_COLOR:/ping [@target] 信号类型|r')




--BNet.lua
hooksecurefunc(BNToastFrame, 'ShowToast', function(self)
    local toastType, toastData
    toastType, toastData = self.toastType or {}, self.toastData or {}
    if ( toastType == 5 ) then
        self.DoubleLine:SetText('你收到了一个新的好友请求。')
    elseif ( toastType == 4 ) then
        self.DoubleLine:SetFormattedText('你共有|cff82c5ff%d|r条好友请求。', toastData)
    elseif ( toastType == 1 ) then
        if C_BattleNet.GetAccountInfoByID(toastData) then
            self.BottomLine:SetText(FRIENDS_GRAY_COLOR:WrapTextInColorCode('已经|cff00ff00上线|r'))
        end
    elseif ( toastType == 2 ) then
        if C_BattleNet.GetAccountInfoByID(toastData) then
            self.BottomLine:SetText('已经|cffff0000下线|r。')
        end
    elseif ( toastType == 6 ) then
        local clubName

        if toastData.club.clubType == Enum.ClubType.BattleNet then
            clubName = BATTLENET_FONT_COLOR:WrapTextInColorCode(toastData.club.name)
        else
            clubName = NORMAL_FONT_COLOR:WrapTextInColorCode(toastData.club.name)
        end
        self.DoubleLine:SetFormattedText('你已受邀加入|n%s', clubName or '')
    elseif (toastType == 7) then
        local clubName = NORMAL_FONT_COLOR:WrapTextInColorCode(toastData.name)
        self.DoubleLine:SetFormattedText('你已受邀加入|n%s', clubName or '')
    end
end)



--StoreFrame.TitleContainer:SetText('商城')
























QuickJoinToastButton:HookScript('OnEnter', function(self)
    if ( not KeybindFrames_InQuickKeybindMode() ) then
        if ( self.displayedToast ) then
            local queues = C_SocialQueue.GetGroupQueues(self.displayedToast.guid)
            if ( queues ) then
                local knowsLeader = SocialQueueUtil_HasRelationshipWithLeader(self.displayedToast.guid)
                GameTooltip:SetOwner(self.Toast, self.isOnRight and "ANCHOR_LEFT" or "ANCHOR_RIGHT")
                SocialQueueUtil_SetTooltip(GameTooltip, SocialQueueUtil_GetHeaderName(self.displayedToast.guid), queues, true, knowsLeader)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine('|cnGREEN_FONT_COLOR:<点击加入>')
                GameTooltip:Show()
            end
        else
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip_SetTitle(GameTooltip, MicroButtonTooltipText('社交', "TOGGLESOCIAL"))
            GameTooltip:Show()
        end
    end
end)





MainMenuBarVehicleLeaveButton:HookScript('OnEnter', function()
    if UnitOnTaxi("player") then
        GameTooltip_SetTitle(GameTooltip, '请求终止')
        GameTooltip:AddLine('将在下一个可用的飞行管理员处着陆。', NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
        GameTooltip:Show()
    else
        GameTooltip_SetTitle(GameTooltip, '退出')
        GameTooltip:Show()
    end
end)

--主菜单，按钮
CharacterMicroButton.tooltipText = MicroButtonTooltipText('角色信息', "TOGGLECHARACTER0")--MainMenuBarMicroButtons.lua
CharacterMicroButton:HookScript('OnEvent', function(self, event)
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('角色信息', "TOGGLECHARACTER0")
    end
end)




GameMenuFrame.Header.Text:SetText('游戏菜单')
if GameMenuButtonHelp then--11版本
    GameMenuButtonHelp:SetText('帮助')
    GameMenuButtonStore:SetText('商店')
    GameMenuButtonWhatsNew:SetText('新内容')
    GameMenuButtonSettings:SetText('选项')
    GameMenuButtonEditMode:SetText('编辑模式')
    GameMenuButtonMacros:SetText('宏')
    GameMenuButtonAddons:SetText('插件')
    GameMenuButtonLogout:SetText('登出')
    GameMenuButtonQuit:SetText('退出游戏')
    GameMenuButtonContinue:SetText('返回游戏')
end


if ProfessionMicroButton then--11版本
    ProfessionMicroButton.tooltipText = MicroButtonTooltipText('专业', "TOGGLEPROFESSIONBOOK")
    ProfessionMicroButton:HookScript('OnEvent', function(self, event)
        if ( event == "UPDATE_BINDINGS" ) then
            self.tooltipText = MicroButtonTooltipText('专业', "TOGGLEPROFESSIONBOOK")
        end
    end)
    PlayerSpellsMicroButton.tooltipText = MicroButtonTooltipText('天赋和法术书', "TOGGLETALENTS")
    PlayerSpellsMicroButton:HookScript('OnEvent', function(self, event)
        if ( event == "UPDATE_BINDINGS" ) then
            self.tooltipText = MicroButtonTooltipText('天赋和法术书', "TOGGLETALENTS")
        end
    end)

else
    SpellbookMicroButton.tooltipText = MicroButtonTooltipText('法术书和专业', "TOGGLESPELLBOOK")
    SpellbookMicroButton:HookScript('OnEvent', function(self, event)
        if ( event == "UPDATE_BINDINGS" ) then
		    self.tooltipText = MicroButtonTooltipText('法术书和专业', "TOGGLESPELLBOOK")
        end
    end)

    TalentMicroButton.tooltipText = MicroButtonTooltipText('专精和天赋', "TOGGLETALENTS")
    TalentMicroButton.newbieText = '天赋的各种组合选择能够强化你的角色，并使你的角色与众不同。'
    TalentMicroButton:HookScript('OnEvent', function(self, event)
        if ( event == "UPDATE_BINDINGS" ) then
		    self.tooltipText = MicroButtonTooltipText('专精和天赋', "TOGGLETALENTS")
        end
    end)
end



AchievementMicroButton.tooltipText = MicroButtonTooltipText('成就', "TOGGLEACHIEVEMENT")
AchievementMicroButton.newbieText = '浏览有关你的成就和统计数据的信息。'
AchievementMicroButton:HookScript('OnEvent', function(self, event)
    if not Kiosk.IsEnabled() and event == "UPDATE_BINDINGS" then
        self.tooltipText = MicroButtonTooltipText('成就', "TOGGLEACHIEVEMENT")
    end
end)

hooksecurefunc(QuestLogMicroButton, 'UpdateTooltipText', function(self)
    self.tooltipText = MicroButtonTooltipText('任务日志', "TOGGLEQUESTLOG")
    self.newbieText = '你现在所拥有的任务。你最多可以同时拥有25条任务记录。'
end)

hooksecurefunc(GuildMicroButton, 'UpdateMicroButton', function(self)
    if ( IsCommunitiesUIDisabledByTrialAccount() or self.factionGroup == "Neutral" or Kiosk.IsEnabled() ) then
        if not Kiosk.IsEnabled() then
            self.disabledTooltip = '免费试玩账号无法进行此项操作'
        end
    elseif ( C_Club.IsEnabled() and not BNConnected() ) then
        self.disabledTooltip = '不可用|n|n暴雪游戏服务目前不可用。'
    elseif ( C_Club.IsEnabled() and C_Club.IsRestricted() ~= Enum.ClubRestrictionReason.None ) then
        self.disabledTooltip = '不可用'
    elseif not (( CommunitiesFrame and CommunitiesFrame:IsShown() ) or ( _G['GuildFrame'] and _G['GuildFrame']:IsShown() )) then

        if ( CommunitiesFrame_IsEnabled() ) then
            self.tooltipText = MicroButtonTooltipText('公会与社区', "TOGGLEGUILDTAB")
            --self.newbieText = NEWBIE_TOOLTIP_COMMUNITIESTAB
        elseif ( IsInGuild() ) then
            self.tooltipText = MicroButtonTooltipText('公会', "TOGGLEGUILDTAB")
            self.newbieText = '查看关于你所在的公会及其会员的信息。如果你是公会的管理人员，还可以在这个窗口中进行公会管理工作。'
        else
            self.tooltipText = MicroButtonTooltipText('公会查找器', "TOGGLEGUILDTAB")
            self.newbieText = '让您找到一个公会。'
        end
    end
end)

LFDMicroButton.tooltipText = MicroButtonTooltipText('队伍查找器', "TOGGLEGROUPFINDER")
LFDMicroButton.disabledTooltip = function()
    local canUse, failureReason = C_LFGInfo.CanPlayerUseGroupFinder()
    return canUse and '此功能在你选择阵营前不可用。' or (e.strText[failureReason] or failureReason)
end
hooksecurefunc(LFDMicroButton, 'UpdateMicroButton',function(self)
    if not ( PVEFrame and PVEFrame:IsShown() ) and not self:IsActive() then
        self.disabledTooltip = function()
            local canUse, failureReason = C_LFGInfo.CanPlayerUseGroupFinder()
            return canUse and '此功能在你选择阵营前不可用。' or (e.strText[failureReason] or failureReason)
        end
    end
end)
LFDMicroButton:HookScript('OnEvent', function(self, event)
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('队伍查找器', "TOGGLEGROUPFINDER")
    end
end)

CollectionsMicroButton.tooltipText = MicroButtonTooltipText('战团藏品', "TOGGLECOLLECTIONS")
CollectionsMicroButton:HookScript('OnEvent', function(self, event)
    if CollectionsJournal and CollectionsJournal:IsShown() then
        return
    end
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('战团藏品', "TOGGLECOLLECTIONS")
    end
end)

EJMicroButton.tooltipText = MicroButtonTooltipText('地下城手册', "TOGGLEENCOUNTERJOURNAL")
EJMicroButton.newbieText = '查看各个地下城及团队副本首领的资料，包括他们的技能和收藏的宝物。'
EJMicroButton:HookScript('OnEvent', function(self, event)
    if event == "UPDATE_BINDINGS" then
        self.tooltipText = MicroButtonTooltipText('冒险指南', "TOGGLEENCOUNTERJOURNAL")
        EJMicroButton.newbieText = '查看各个地下城及团队副本首领的资料，包括他们的技能和收藏的宝物。'
    end
end)
if not (EncounterJournal and EncounterJournal:IsShown() ) and not AdventureGuideUtil.IsAvailable() then
    EJMicroButton.disabledTooltip = Kiosk.IsEnabled() and (e.onlyChinese and '该系统目前已被禁用。' or ERR_SYSTEM_DISABLED) or (e.onlyChinese and '该功能尚不可用。' or FEATURE_NOT_YET_AVAILABLE)
end
hooksecurefunc(EJMicroButton, 'UpdateDisplay', function(self)
    if not ( EncounterJournal and EncounterJournal:IsShown() ) and not AdventureGuideUtil.IsAvailable() then
        self.disabledTooltip = Kiosk.IsEnabled() and (e.onlyChinese and '该系统目前已被禁用。' or ERR_SYSTEM_DISABLED) or (e.onlyChinese and '该功能尚不可用。' or FEATURE_NOT_YET_AVAILABLE)
    end
end)


StoreMicroButton.tooltipText = '商城'
hooksecurefunc(StoreMicroButton, 'UpdateMicroButton', function(self)
    if ( C_StorePublic.IsDisabledByParentalControls() ) then
        self.disabledTooltip = '家长监控已禁用了该功能。'
    elseif ( Kiosk.IsEnabled() ) then
        self.disabledTooltip = '该系统目前已被禁用。'
    elseif ( not C_StorePublic.IsEnabled() ) then
        if not ( GetCurrentRegionName() == "CN" ) then
            self.disabledTooltip = '商城当前不可用。'
        end
    end
end)












--MovieFrame.xml
e.reg(MovieFrame.CloseDialog, '你确定想要跳过这段过场动画吗？', 1)
MovieFrame.CloseDialog.ConfirmButton:SetText('是')
MovieFrame.CloseDialog.ResumeButton:SetText('否')




--StackSplitFrame.lua
hooksecurefunc(StackSplitFrame, 'ChooseFrameType', function(self, splitAmount)
    if splitAmount ~= 1 then
        self.StackSplitText:SetFormattedText('%d 堆', self.split/self.minSplit)
        self.StackItemCountText:SetFormattedText('总计%d', self.split)
    end
end)
hooksecurefunc(StackSplitFrame, 'UpdateStackText', function(self)
    if self.isMultiStack then
        self.StackSplitText:SetFormattedText('%d 堆', self.split/self.minSplit)
        self.StackItemCountText:SetFormattedText('总计%d', self.split)
    end
end)

--LootFrame.lua
LootFrameTitleText:SetText('物品')
hooksecurefunc(LootFrameItemElementMixin, 'Init', function(self)
    local elementData = self:GetElementData() or {}
    if elementData.quality then
        e.set(self.QualityText, _G[format("ITEM_QUALITY%s_DESC", elementData.quality)])
    end
end)




--SharedUIPanelTemplates.lua
hooksecurefunc(SliderControlFrameMixin, 'SetupSlider', function(self, _, _, _, _, label)
    e.set(self.Label, label)
end)

hooksecurefunc('SearchBoxTemplate_OnLoad', function(self)--SharedUIPanelTemplates.lua
    self.Instructions:SetText('搜索')
end)
hooksecurefunc('Main_HelpPlate_Button_ShowTooltip', function(self)
    HelpPlateTooltip.Text:SetText(self.MainHelpPlateButtonTooltipText or '点击这里打开/关闭本窗口的帮助系统。')
end)
hooksecurefunc(SearchBoxListMixin, 'UpdateSearchPreview', function(self, finished, dbLoaded, numResults)
    if finished and not self.searchButtons[numResults] then
        self.showAllResults.text:SetFormattedText('显示全部%d个结果', numResults)
    end
end)
hooksecurefunc(IconSelectorPopupFrameTemplateMixin, 'SetSelectedIconText', function(self)
    if ( self:GetSelectedIndex() ) then
        self.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription:SetText('点击在列表中浏览')
    else
        self.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription:SetText('此图标不在列表中')
    end
end)
--[[hooksecurefunc(LabeledEnumDropDownControlMixin, 'SetLabelText', function(self, text)
    e.set(self.Label, text)
end)]]








StackSplitFrame.OkayButton:SetText('确定')
StackSplitFrame.CancelButton:SetText('取消')

ColorPickerFrame.Footer.OkayButton:SetText('确定')
ColorPickerFrame.Footer.CancelButton:SetText('取消')
ColorPickerFrame.Header.Text:SetText('颜色选择器')



















hooksecurefunc('VoiceTranscriptionFrame_UpdateEditBox', function(self)--VoiceChatTranscriptionFrame.lua
    if  C_VoiceChat.IsMuted() then
        self.editBox.prompt:SetText('禁音 - 目前没有发送语音识别或文字转语音信息')
    elseif C_VoiceChat.IsSpeakForMeActive() then
        self.editBox.prompt:SetText('输入文字后，文字转语音功能会为其他玩家朗读文字。')
    end
end)



--UIErrorsFrame
hooksecurefunc(UIErrorsFrame, 'AddMessage', function(self, msg, ...)
    msg= e.strText[msg]
    if msg then
        self:AddMessage(msg, ...)
    end
end)


--团队
CompactRaidFrameManager.displayFrame.label:SetText(IsInRaid() and '团员' or '队员')
hooksecurefunc('CompactRaidFrameManager_UpdateLabel', function()
    CompactRaidFrameManager.displayFrame.label:SetText(IsInRaid() and '团员' or '队员')
end)
--[[hooksecurefunc(CompactRaidFrameManagerDisplayFrame.RestrictPingsButton, 'UpdateLabel', function(self)
    self.Text:SetText(IsInRaid() and '只限助手发送信号' or '只限领袖发送信号')
end)
CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButtonText:SetText('将所有人提升为助理')

CompactRaidFrameManagerDisplayFrameEditMode:SetText('编辑')
CompactRaidFrameManagerDisplayFrameConvertToRaid:SetText('转团')
hooksecurefunc('CompactRaidFrameManager_SetSetting', function(settingName, value)
    if ( settingName == "IsShown" ) then
        if EditModeManagerFrame:AreRaidFramesForcedShown() or (value and value ~= "0") then
            CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetText('隐藏')
        else
            CompactRaidFrameManagerDisplayFrameHiddenModeToggle:SetText('显示')
        end
    end
end)]]

e.reg(RolePollPopup, '选择你的职责', 1)
RolePollPopupAcceptButtonText:SetText('接受')

--HelpTipTemplateMixin:ApplyText()
hooksecurefunc(HelpTipTemplateMixin, 'ApplyText', function(frame)
    local text= e.strText[frame.info.text]
    if text then
        frame.info.text= text
        frame.Text:SetText(text)
    end
end)

hooksecurefunc('HelpPlate_Button_OnEnter', function(self)
    local text= e.strText[self.toolTipText]
    if text then
        self.toolTipText= text
        HelpPlateTooltip.Text:SetText(text)
    end
end)




--试衣间
DressUpFrameTitleText:SetText('试衣间')
--DressUpFrameOutfitDropdownText:SetText('保存')--11版本
if DressUpFrameOutfitDropdown then
    e.set(DressUpFrameOutfitDropdown.Text)
end
DressUpFrame.LinkButton:SetText('外观方案链接')
DressUpFrameResetButton:SetText('重置')
DressUpFrameCancelButton:SetText('关闭')
DressUpFrame.ToggleOutfitDetailsButton:HookScript('OnEnter', function()
    GameTooltip_SetTitle(GameTooltip, '外观列表')
    GameTooltip:Show()
end)

--local TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN_CHECKMARK = "|A:common-icon-checkmark:16:16:0:-1|a 你已经收藏过此外观了"
hooksecurefunc(DressUpOutfitDetailsSlotMixin, 'OnEnter', function(self)--DressUpFrames.lua
    if not self.transmogID or (self.item and not self.item:IsItemDataCached()) then
        return
    end
    local name= e.strText[self.name] or ' '
    if self.isHiddenVisual then
        GameTooltip_AddColoredLine(GameTooltip, name, NORMAL_FONT_COLOR)
    elseif not self.item then
        -- illusion
        GameTooltip_AddColoredLine(GameTooltip,name, NORMAL_FONT_COLOR)
        if self.slotState == 3 then
            GameTooltip_AddColoredLine(GameTooltip, '你尚未收藏过此外观', LIGHTBLUE_FONT_COLOR)
        else
            GameTooltip_AddColoredLine(GameTooltip, "|cnGREEN_FONT_COLOR:|A:common-icon-checkmark:16:16:0:-1|a 你已经收藏过此外观了", GREEN_FONT_COLOR)
        end
    elseif self.slotState == 1 then
        local hasData, canCollect = C_TransmogCollection.AccountCanCollectSource(self.transmogID)
        if not canCollect and (self.slotID == INVSLOT_MAINHAND or self.slotID == INVSLOT_OFFHAND) then
            local pairedTransmogID = C_TransmogCollection.GetPairedArtifactAppearance(self.transmogID)
            if pairedTransmogID then
                hasData, canCollect = C_TransmogCollection.AccountCanCollectSource(pairedTransmogID)
                if not hasData then
                    return
                end
            end
        end
        if canCollect then
            local nameColor = self.item:GetItemQualityColor().color
            GameTooltip_AddColoredLine(GameTooltip,name, nameColor)
            local slotName = TransmogUtil.GetSlotName(self.slotID)
            GameTooltip_AddColoredLine(GameTooltip, e.cn(_G[slotName]), HIGHLIGHT_FONT_COLOR)
            GameTooltip_AddErrorLine(GameTooltip, '你的角色无法使用此外观。')
        else
            local hideVendorPrice = true
            GameTooltip:SetHyperlink(self.item:GetItemLink(), nil, nil, hideVendorPrice)
            GameTooltip_AddErrorLine(GameTooltip, '该物品无法在幻化时使用，但可以视为装备穿戴。')
        end
    elseif self.slotState == 3 then
        if not C_TransmogCollection.PlayerKnowsSource(self.transmogID) then
            local nameColor = self.item:GetItemQualityColor().color
            GameTooltip_AddColoredLine(GameTooltip, name, nameColor)
            local slotName = TransmogUtil.GetSlotName(self.slotID)
            GameTooltip_AddColoredLine(GameTooltip, e.cn(_G[slotName]), HIGHLIGHT_FONT_COLOR)
            GameTooltip_AddColoredLine(GameTooltip, '|cnRED_FONT_COLOR:你尚未收藏过此外观', LIGHTBLUE_FONT_COLOR)
        end
    else
        local nameColor = self.item:GetItemQualityColor().color
        GameTooltip_AddColoredLine(GameTooltip, name, nameColor)
        local slotName = TransmogUtil.GetSlotName(self.slotID)
        GameTooltip_AddColoredLine(GameTooltip, e.cn(_G[slotName]), HIGHLIGHT_FONT_COLOR)
        GameTooltip_AddColoredLine(GameTooltip, '|cnGREEN_FONT_COLOR:|A:common-icon-checkmark:16:16:0:-1|a 你已经收藏过此外观了', GREEN_FONT_COLOR)
    end
    GameTooltip:Show()
end)

hooksecurefunc(DressUpOutfitDetailsSlotMixin, 'SetAppearance', function(self, slotID, transmogID, isSecondary)
    local itemID = C_TransmogCollection.GetSourceItemID(transmogID)
    if not itemID and not isSecondary then
        local name= _G[TransmogUtil.GetSlotName(slotID)]
        local slotName = e.strText[name]
        if slotName then
            self.Name:SetFormattedText('(%s)', slotName)
        end
    end
end)
hooksecurefunc(DressUpOutfitDetailsSlotMixin, 'RefreshAppearanceTooltip', function(self)
    GameTooltip_AddColoredLine(GameTooltip, '|cnRED_FONT_COLOR:你尚未收藏过此外观', LIGHTBLUE_FONT_COLOR)
    GameTooltip:Show()
end)
--[[hooksecurefunc(WardrobeOutfitFrame, 'Update', function(self)
    if self.Buttons then
        local btn=self.Buttons[#self.Buttons]
        if btn then
            btn:SetText('|cnGREEN_FONT_COLOR:新外观方案|r')
        end
    end
end)]]


--PlayerCastingBarFrame
hooksecurefunc(PlayerCastingBarFrame, 'HandleInterruptOrSpellFailed', function(self, _, event, ...)
    if self.barType == "interrupted" and self.Text then
        self.Text:SetText(event == "UNIT_SPELLCAST_FAILED" and '失败' or '被打断')
    end
end)
PlayerCastingBarFrame:HookScript('OnEvent', function(self, event)
    if event== "UNIT_SPELLCAST_START" or event== "UNIT_SPELLCAST_CHANNEL_START" or event== "UNIT_SPELLCAST_EMPOWER_START" then
        e.set(self.Text)
    end
end)


C_Timer.After(2, function()


    AddonCompartmentFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip_SetTitle(GameTooltip, '插件')
        GameTooltip:Show()
    end)



    for i=1, 12 do
        e.set(_G['ChatMenuButton'..i])
    end

    if _G['VoiceMacroMenu'] then
        local w= _G['VoiceMacroMenu']:GetWidth()
        _G['VoiceMacroMenu']:SetWidth(w*1.6)
        for i=1, 23 do
            local btn= _G['VoiceMacroMenuButton'..i]
            local name= btn and btn:GetText()
            local text= name and e.strText[name]
            if text then
                btn:SetText(text)
                local shortcutString = _G[btn:GetName().."ShortcutText"]
                if shortcutString then
                    shortcutString:SetText(name)
                    shortcutString:Show()
                end
                btn:SetWidth(w*1.4)
            end
        end
    end
    if _G['EmoteMenu'] then
        local w= _G['EmoteMenu']:GetWidth()
        _G['EmoteMenu']:SetWidth(w*1.6)
        for i=1, 21 do
            local btn= _G['EmoteMenuButton'..i]
            local name= btn and btn:GetText()
            local text= name and e.strText[name]
            if text then
                btn:SetText(text)
                local shortcutString = _G[btn:GetName().."ShortcutText"]
                if shortcutString then
                    shortcutString:SetText(name)
                    shortcutString:Show()
                end
                btn:SetWidth(w*1.4)
            end
        end
    end
end)

--EventToastManager.lua EventToastManagerFrame
--没有全部测试
hooksecurefunc(EventToastScenarioBaseToastMixin, 'Setup', function(self, toastInfo)
    e.set(self.Title, toastInfo.title)
    e.set(self.SubTitle, toastInfo.subtitle)
    e.set(self.Description, toastInfo.instructionText)
end)
hooksecurefunc(EventToastScenarioExpandToastMixin, 'Setup', function(self, toastInfo)
    self.Description:SetText('左键点击以查看详情')
end)
hooksecurefunc(EventToastScenarioExpandToastMixin, 'OnAnimFinished', function(self)
    self.Description:SetText('左键点击以查看详情')
end)
hooksecurefunc(EventToastScenarioExpandToastMixin, 'OnClick', function(self, button, ...)
    if (button == "LeftButton") then
        if(not self.expanded) then
            self.Description:SetText('左键点击以查看详情')
        else
            self.Description:SetText('左键点击以隐藏详情')
        end
    end
end)
hooksecurefunc(EventToastWeeklyRewardToastMixin, 'Setup', function(self, toastInfo)
    e.set(self.Contents.Title, toastInfo.title)
    e.set(self.Contents.SubTitle, e.strText[toastInfo.subtitle])
end)
hooksecurefunc(EventToastWithIconBaseMixin, 'Setup', function(self, toastInfo)
    e.set(self.Title, toastInfo.title)
    e.set(self.SubTitle, toastInfo.subtitle)
    if not self.isSideDisplayToast then
        e.set(self.InstructionalText, toastInfo.instructionText)
    end
end)
hooksecurefunc(EventToastWithIconWithRarityMixin, 'Setup', function(self, toastInfo)
    if (toastInfo.qualityString) then
        e.set(self.RarityValue, toastInfo.qualityString)
    end
end)
hooksecurefunc(EventToastChallengeModeToastMixin, 'Setup', function(self, toastInfo)
    e.set(self.Title, toastInfo.title)
    if (toastInfo.time) then
        if e.strText[toastInfo.subtitle] then
            self.SubTitle:SetFormattedText(e.strText[toastInfo.subtitle], SecondsToClock(toastInfo.time/1000, true))
        end
    else
        e.set(self.SubTitle, toastInfo.subtitle)
    end
end)
hooksecurefunc(EventToastManagerNormalTitleAndSubtitleMixin, 'Setup', function(self, toastInfo)
    e.set(self.Title, toastInfo.title)
    e.set(self.SubTitle, toastInfo.subtitle)
end)
hooksecurefunc(EventToastManagerNormalSingleLineMixin, 'Setup', function(self, toastInfo)
    e.set(self.Title, toastInfo.title)
end)
hooksecurefunc(EventToastManagerNormalBlockTextMixin, 'Setup', function(self, toastInfo)
    e.set(self.Title, toastInfo.title)
end)


--ZoneText.lua
hooksecurefunc('ZoneText_OnEvent', function(self, event, ...)
    local showZoneText = false
    local zoneText = GetZoneText()
    if ( (zoneText ~= self.zoneText) or (event == "ZONE_CHANGED_NEW_AREA") ) then
        e.set(ZoneTextString, zoneText)
        showZoneText = true
    end
    local subzoneText = GetSubZoneText()
    if ( subzoneText == "" and not showZoneText) then
        subzoneText = zoneText
    end
    if ( subzoneText == zoneText ) then
        if ( not self:IsShown() ) then
            e.set(SubZoneTextString, subzoneText)
        end
    else
        e.set(SubZoneTextString, subzoneText)
    end
end)
e.set(SubZoneTextString, GetSubZoneText())
hooksecurefunc('SetZoneText', function()
    local pvpType, isSubZonePvP, factionName = C_PvP.GetZonePVPInfo()
    local pvpTextString = PVPInfoTextString
    if ( isSubZonePvP ) then
        pvpTextString = PVPArenaTextString
    end
    if ( pvpType == "sanctuary" ) then
        pvpTextString:SetText('（安全区域）')
    elseif ( pvpType == "arena" ) then
        pvpTextString:SetText('（PvP区域）')
    elseif ( pvpType == "friendly" or  pvpType == "hostile" ) then
        if (factionName and factionName ~= "") then
            pvpTextString:SetFormattedText('（%s领地）', e.cn(factionName))
        end
    elseif ( pvpType == "contested" ) then
        pvpTextString:SetText('（争夺中的领土）')
    elseif ( pvpType == "combat" ) then
        PVPArenaTextString:SetText('（战斗区域）')
    end
end)
hooksecurefunc('AutoFollowStatus_OnEvent', function(self, event, ...)
    if ( event == "AUTOFOLLOW_BEGIN" ) then
        AutoFollowStatusText:SetFormattedText('正在跟随%s', self.unit)
    end
    if ( event == "AUTOFOLLOW_END" ) then
        AutoFollowStatusText:SetFormattedText('已停止跟随%s。', self.unit)
    end
end)


-- PVP
for index, en in pairs(CONQUEST_SIZE_STRINGS) do
    local cn= e.strText[en]
    if cn then
        CONQUEST_SIZE_STRINGS[index]= cn
    end
end
for index, en in pairs(CONQUEST_TYPE_STRINGS) do
    local cn= e.strText[en]
    if cn then
        CONQUEST_TYPE_STRINGS[index]= cn
    end
end
