
--好友列表
function WoWTools_ChineseMixin.Events:Blizzard_FriendsFrame()

    --屏蔽列表 FriendsIgnoreListMixin
    self:SetButton(FriendsFrame.IgnoreListWindow.UnignorePlayerButton)
    FriendsFrame.IgnoreListWindow:SetTitle('屏蔽列表')


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
        FriendsFrameBattlenetFrame.BroadcastFrame.EditBox.PromptText:SetText('通告')
        FriendsFrameBattlenetFrame.BroadcastFrame.UpdateButton:SetText('更新')
        FriendsFrameBattlenetFrame.BroadcastFrame.CancelButton:SetText('取消')
        FriendsFrameAddFriendButton:SetText('添加好友')
    --添加好友
        if AddFriendEntryFrameTopTitle then--11.2没了
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
        else
            self:SetLabel(AddFriendInfoFrame.InfoContainer.LeftTextContainer.Description)
            self:SetLabel(AddFriendInfoFrame.InfoContainer.RightTextContainer.Description)
            self:SetButton(AddFriendInfoFrame.ContinueButton)

            self:SetLabel(AddFriendEntryFrame.TitleContainer.Title)
            self:HookLabel(AddFriendNameEditBoxFill)
            self:HookLabel(AddFriendEntryFrame.OptionsContainer.LeftTextContainer.Description)
            self:HookLabel(AddFriendEntryFrame.OptionsContainer.RightTextContainer.Description)
            self:HookButton(AddFriendEntryFrameAcceptButton)
            self:SetLabel(AddFriendEntryFrameCancelButtonText)
        end


            for _, btn in pairs(FriendsTabHeader.TabSystem.tabs) do--TabSystemMixin
                self:SetButton(btn)
            end

            

 

            hooksecurefunc(RecruitAFriendRecruitmentFrame.GenerateOrCopyLinkButton, 'Update', function(frame, recruitmentInfo)
                recruitmentInfo= recruitmentInfo or frame.recruitmentInfo
                if recruitmentInfo then
                    RecruitAFriendRecruitmentFrameText:SetText('复制链接')
                else
                    RecruitAFriendRecruitmentFrameText:SetText('创建链接')
                end
            end)

            self:SetLabel(FriendsFriendsFrame.SendRequestButton)
            self:SetLabel(FriendsFriendsFrame.CloseButton)

            hooksecurefunc('FriendsFriendsFrame_Show', function(bnetIDAccount)
                local accountInfo = C_BattleNet.GetAccountInfoByID(bnetIDAccount)
                if accountInfo then
                    FriendsFriendsFrameTitle:SetFormattedText('%s的好友', FRIENDS_BNET_NAME_COLOR_CODE..accountInfo.accountName..FONT_COLOR_CODE_CLOSE);
                end
            end)




    --FriendsFrame.xml
    BattleTagInviteFrame.InfoText:SetText('当他们接受你的好友请求后，就会被加入你的好友名单。')



    FriendsFrameTab2:SetText('查询')
    FriendsFrameTab3:SetText('团队')
    FriendsFrameSendMessageButton:SetText('发送信息')
    hooksecurefunc('FriendsFrame_UpdateQuickJoinTab', function(numGroups)--FriendsFrame.lua
        if numGroups then
            FriendsFrameTab4:SetText('快速加入'.. (numGroups>0 and '|cnGREEN_FONT_COLOR:' or '')..numGroups)
        end
    end)



    WhoFrameWhoButton:SetText('刷新')
    WhoFrameAddFriendButton:SetText('添加好友')
    WhoFrameGroupInviteButton:SetText('组队邀请')

    if WhoFrameEditBox then--11.2
        self:SetLabel(WhoFrameEditBox.Instructions)
        self:SetLabel(WhoFrameDropdown.Text)
    end





    RaidFrameAllAssistCheckButtonText:SetText('所有|TInterface\\GroupFrame\\UI-Group-AssistantIcon:12:12:0:1|t')
    RaidFrameAllAssistCheckButton:HookScript('OnEnter', function(frame)
        GameTooltip:AddLine('钩选此项可使所有团队成员都获得团队助理权限', nil, nil, nil, true)
        if ( not frame:IsEnabled() ) then
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
            name= self:CN(name)
            if extended or locked then
                self:SetLabel(button.name, name)
            else
                button.reset:SetFormattedText("|cff808080%s|r", '已过期')
                if name then
                    button.name:SetFormattedText("|cff808080%s|r", name)
                end
            end

            local difficultyText = difficultyId and WoWTools_MapMixin and WoWTools_MapMixin:GetDifficultyColor(difficulty, difficultyId) or self:CN(difficulty)
            if difficultyText then
                button.difficulty:SetText(difficultyText)
            end

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
            InitButton(extended, locked, name, RAID_INFO_WORLD_BOSS)
        end
    end)
    hooksecurefunc('RaidFrame_OnShow', function(frame)
        frame:GetParent():GetTitleText():SetText('团队')
    end)
    RaidInfoCancelButton:SetText('关闭')
    RaidFrameConvertToRaidButton:SetText('转化为团队')

    if RaidFrameRaidDescription then--11.2
        self:SetLabel(RaidFrameRaidDescription)
    else
        RaidFrameNotInRaid.ScrollingDescription:SetText('团队是超过5个人的队伍，这是为了击败高等级的特定挑战而准备的大型队伍模式。\n\n|cffffffff- 团队成员无法获得非团队任务所需的物品或者杀死怪物的纪录。\n\n- 在团队中，你通过杀死怪物获得的经验值相对普通小队要少。\n\n- 团队让你可以赢得用其它方法根本无法通过的挑战。|r')
    end






    hooksecurefunc(QuickJoinFrame, 'UpdateJoinButtonState', function(frame)--QuickJoin.lua
        frame.JoinQueueButton:SetText('申请加入')
        if ( IsInGroup(LE_PARTY_CATEGORY_HOME) ) then
            frame.JoinQueueButton.tooltip = '你已在一个队伍中。你必须离开队伍才能加入此队列。'
        elseif  frame:GetSelectedGroup() ~= nil then
            local queues = C_SocialQueue.GetGroupQueues(frame:GetSelectedGroup())
            if ( queues and queues[1] and queues[1].queueData.queueType == "lfglist" ) then
                frame.JoinQueueButton:SetText('申请')
            end
        end
    end)

    C_Timer.After(2, function()
        self:SetRegions(FriendsFrameBattlenetFrame.BroadcastFrame)--, '通告', 1)
        self:SetRegions(BattleTagInviteFrame)--, '发送一个|cff82c5ff战网昵称|r请求给：', 1)
    end)

end





































--好友召募
function WoWTools_ChineseMixin.Events:Blizzard_RecruitAFriend()
    local function set_UpdateRAFInfo(frame, rafInfo)
        if frame.rafEnabled and rafInfo and #rafInfo.versions > 0 then
            local latestRAFVersionInfo = frame:GetLatestRAFVersionInfo()
            if (latestRAFVersionInfo.numRecruits == 0) and (latestRAFVersionInfo.monthCount.lifetimeMonths == 0) then
                frame.RewardClaiming.MonthCount:SetText('招募战友即可开始！')
            else
                frame.RewardClaiming.MonthCount:SetFormattedText('招募战友已奖励%d个月', latestRAFVersionInfo.monthCount.lifetimeMonths)
            end
        end
    end
    hooksecurefunc(RecruitAFriendFrame, 'UpdateRAFInfo', set_UpdateRAFInfo)
    set_UpdateRAFInfo(RecruitAFriendFrame, RecruitAFriendFrame.rafInfo)

    local function set_UpdateNextReward(frame, nextReward)--C_RecruitAFriend.GetRAFInfo()
        if not nextReward then
            return
        end
        if nextReward.canClaim then
            frame.RewardClaiming.EarnInfo:SetText('你获得了：')
        elseif nextReward.monthCost > 1 then
            frame.RewardClaiming.EarnInfo:SetFormattedText('下一个奖励 (|cnGREEN_FONT_COLOR:%d|r/%d个月)：', nextReward.monthCost - nextReward.availableInMonths, nextReward.monthCost)
        elseif nextReward.monthsRequired == 0 then
            frame.RewardClaiming.EarnInfo:SetText('第一个奖励：')
        else
            frame.RewardClaiming.EarnInfo:SetText('下一个奖励：')
        end

        if not nextReward.petInfo and not nextReward.appearanceInfo and not nextReward.appearanceSetInfo and not nextReward.illusionInfo then
            if nextReward.titleInfo then
                local titleName = TitleUtil.GetNameFromTitleMaskID(nextReward.titleInfo.titleMaskID)
                if titleName then
                    frame:SetNextRewardName(format('新头衔：|cnGREEN_FONT_COLOR:%s|r', titleName), nextReward.repeatableClaimCount, nextReward.rewardType)
                end
            else
                frame:SetNextRewardName('30天免费游戏时间', nextReward.repeatableClaimCount, nextReward.rewardType)
            end
        end
        local name= WoWTools_ChineseMixin:GetItemName(nextReward.itemID)
        if name then
            frame.RewardClaiming.NextRewardName.Text:SetText(name)
        else
            self:SetLabel(frame.RewardClaiming.NextRewardName.Text)
        end
    end
    hooksecurefunc(RecruitAFriendFrame, 'UpdateNextReward', function(...) set_UpdateNextReward(...) end)
    if RecruitAFriendFrame.rafEnabled and RecruitAFriendFrame.rafInfo and #RecruitAFriendFrame.rafInfo.versions > 0 then
        local latestRAFVersionInfo = RecruitAFriendFrame:GetLatestRAFVersionInfo() or {}
        set_UpdateNextReward(RecruitAFriendFrame, latestRAFVersionInfo.nextReward)
    end

    hooksecurefunc(RecruitAFriendFrame.RewardClaiming.ClaimOrViewRewardButton, 'Update', function(frame)
        if frame.haveUnclaimedReward then
            frame:SetText('获取奖励')
        else
            frame:SetText('查看所有奖励')
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
    self:SetLabel(RecruitAFriendRewardsFrame.Description)
    hooksecurefunc(RecruitAFriendRewardsFrame, 'UpdateDescription', function(frame, selectedRAFVersionInfo)
        frame.Description:SetText((selectedRAFVersionInfo.rafVersion == frame:GetRecruitAFriendFrame():GetLatestRAFVersion()) and '每名拥有可用的游戏时间的被招募者|n每30天可以为你提供一份月度奖励。' or '不能再为旧版招募活动再招募新的战友，但是旧版现有的被招募的战友还会继续提供战友招募奖励。')
    end)


    RecruitAFriendRewardsFrame.VersionInfoButton:HookScript('OnEnter', function(frame)
        local recruitAFriendFrame = frame:GetRecruitAFriendFrame()
        local selectedVersionInfo = recruitAFriendFrame:GetSelectedRAFVersionInfo()
        local helpText = recruitAFriendFrame:IsLegacyRAFVersion(selectedVersionInfo.rafVersion) and '当前激活的旧版招募战友：|cnHIGHLIGHT_FONT_COLOR:%d|r|n尚未领取的奖励：|cnHIGHLIGHT_FONT_COLOR:%d|r' or '当前激活的招募战友：|cnHIGHLIGHT_FONT_COLOR:%d|r|n尚未领取的奖励：|cnHIGHLIGHT_FONT_COLOR:%d|r'
        GameTooltip_AddNormalLine(GameTooltip, ' ')
        GameTooltip_AddNormalLine(GameTooltip, helpText:format(selectedVersionInfo.numRecruits, selectedVersionInfo.numAffordableRewards))
        GameTooltip:Show()
    end)

    RecruitAFriendRecruitmentFrame.Title:SetText('招募')

    hooksecurefunc(RecruitAFriendRecruitmentFrame, 'UpdateRecruitmentInfo', function(frame, recruitmentInfo, recruitsAreMaxed)
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

            frame.Description:SetFormattedText('招募战友，与你一起游玩《魔兽世界》！|n你每%2$d天可以邀请%1$d个战友。', recruitmentInfo.totalUses, daysInCycle)

            if recruitmentInfo.sourceFaction ~= "" then
                local region= e.Get_Region(recruitmentInfo.sourceRealm)
                local reaml= (region and region.col or '')..(recruitmentInfo.sourceRealm or '')
                frame.FactionAndRealm:SetFormattedText('我们会鼓励你的战友在%2$s服务器创建一个%1$s角色，从而加入你的冒险。', self:CN(recruitmentInfo.sourceFaction) or recruitmentInfo.sourceFaction, reaml)
            end
        else
            local PLAYER_FACTION_NAME= UnitFactionGroup('player')=='Alliance' and PLAYER_FACTION_COLOR_ALLIANCE:WrapTextInColorCode('联盟') or (UnitFactionGroup('player')=='Horde' and PLAYER_FACTION_COLOR_HORDE:WrapTextInColorCode('部落')) or '中立'
            frame.Description:SetFormattedText('招募战友，与你一起游玩《魔兽世界》！|n你每%2$d天可以邀请%1$d个战友。', maxRecruitLinkUses, daysInCycle)
            frame.FactionAndRealm:SetFormattedText('我们会鼓励你的战友在%2$s服务器创建一个%1$s角色，从而加入你的冒险。', PLAYER_FACTION_NAME, GetRealmName())
        end

        if recruitsAreMaxed then
            frame.InfoText1:SetFormattedText('"%d/%d 已招募的战友。已达到最大招募数量。', maxRecruits, maxRecruits)
        elseif recruitmentInfo then
            if recruitmentInfo.remainingUses > 0 then
                frame.InfoText:SetFormattedText('此链接会在|cnGREEN_FONT_COLOR:%s|r后过期', recruitmentInfo.expireDateString)
            else
                frame.InfoText1:SetFormattedText('你在|cnGREEN_FONT_COLOR:%s|r后即可创建一个新链接', recruitmentInfo.expireDateString)
            end


            local timesUsed = recruitmentInfo.totalUses - recruitmentInfo.remainingUses
            frame.InfoText2:SetFormattedText('%d/%d 名朋友已经使用了这个链接。', timesUsed, recruitmentInfo.totalUses)
        end
    end)


end