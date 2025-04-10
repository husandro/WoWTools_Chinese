local e = select(2, ...)




hooksecurefunc(DragonridingPanelSkillsButtonMixin, 'OnLoad', function(self)--Blizzard_DragonflightLandingPage.lua
    WoWTools_ChineseMixin:Set_Label_Text(self)
end)
















--页数 Blizzard_PagingControls.lua
if PagingControlsMixin then
    hooksecurefunc(PagingControlsMixin, 'UpdateControls', function(self)
        local shouldHideControls = self.hideWhenSinglePage and self.maxPages <= 1
        if not shouldHideControls then
            if self.displayMaxPages then
                local name= e.strText[self.currentPageWithMaxText]
                if name then
                    self.PageText:SetFormattedText(name, self.currentPage, self.maxPages)
                end
            else
                local name=self.currentPageOnlyText
                if name then
                    self.PageText:SetFormattedText(name, self.currentPage)
                end
            end
        end
    end)
end








--就绪
--ReadyCheck.lua
ReadyCheckListenerFrame.TitleContainer.TitleText:SetText('就位确认')
ReadyCheckFrameYesButton:SetText('就绪')--:SetText(GetText("READY", UnitSex("player")))
ReadyCheckFrameNoButton:SetText('未就绪')--:SetText(GetText("NOT_READY", UnitSex("player")))



--拾取
GroupLootHistoryFrameTitleText:SetText('战利品掷骰')
GroupLootHistoryFrame.NoInfoString:SetText('地下城和团队副本的战利品掷骰在此显示')

hooksecurefunc('GuildChallengeAlertFrame_SetUp', function(frame, challengeType)--AlertFrameSystems.lua
    local name= _G["GUILD_CHALLENGE_TYPE"..challengeType]
    if name then
        WoWTools_ChineseMixin:Set_Label_Text(frame.Type, name)
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
    local name= C_TradeSkillUI.GetTradeSkillDisplayName(skillLineID)
    self.Name:SetFormattedText('%s专精', name)
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


QuestInfoRequiredMoneyText:SetText('需要金钱：')
QuestInfoRewardsFrame.ItemChooseText:SetText('你可以从这些奖励品中选择一件：')
QuestInfoRewardsFrame.PlayerTitleText:SetText('新头衔： %s')
QuestInfoRewardsFrame.QuestSessionBonusReward:SetText('在小队同步状态下完成此任务有可能获得奖励：')




hooksecurefunc('MinimapMailFrameUpdate', function()
    local senders = { GetLatestThreeSenders() }
    local headerText = #senders >= 1 and '未读邮件来自：' or '你有未阅读的邮件'
    for i, sender in ipairs(senders) do
        headerText = headerText.."\n"..(e.strText[sender] or sender)
    end
    GameTooltip:SetText(headerText)
    GameTooltip:Show()
end)

--WoWTools_ChineseMixin:HookLabel(MinimapZoneText)

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
    WoWTools_ChineseMixin:Set_Label_Text(self.Text, categoryName)
end)
ReportFrame.ThankYouText:SetText('感谢您的举报！')
ReportFrame.TitleText:SetText('《魔兽世界》客户支持')
ReportFrame.ReportButton:SetText('举报')




























--ButtonTrayUtil.lua
if ButtonTrayUtil.TestCheckboxTraySetup then
    hooksecurefunc(ButtonTrayUtil, 'TestCheckboxTraySetup', function(button, labelText)--ButtonTrayUtil.lua
        WoWTools_ChineseMixin:Set_Label_Text(button.Label, labelText)
    end)
end

hooksecurefunc(ButtonTrayUtil, 'TestButtonTraySetup', function(button, label)
    label= e.strText[label]
    if label then
        button:SetText(label)
    end
end)
hooksecurefunc(ResizeCheckButtonMixin, 'SetLabelText', function(self, labelText)
    WoWTools_ChineseMixin:Set_Label_Text(self.Label, labelText)
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




































--MovieFrame.xml
WoWTools_ChineseMixin:SetRegions(MovieFrame.CloseDialog)--, '你确定想要跳过这段过场动画吗？', 1)
MovieFrame.CloseDialog.ConfirmButton:SetText('是')
MovieFrame.CloseDialog.ResumeButton:SetText('否')








--SharedUIPanelTemplates.lua
hooksecurefunc(SliderControlFrameMixin, 'SetupSlider', function(self, _, _, _, _, label)
    WoWTools_ChineseMixin:Set_Label_Text(self.Label, label)
end)

hooksecurefunc('SearchBoxTemplate_OnLoad', function(self)--SharedUIPanelTemplates.lua
    self.Instructions:SetText('搜索')
end)
if _G['Main_HelpPlate_Button_ShowTooltip'] then--11.1.5 无
    hooksecurefunc('Main_HelpPlate_Button_ShowTooltip', function(self)
        HelpPlateTooltip.Text:SetText(self.MainHelpPlateButtonTooltipText or '点击这里打开/关闭本窗口的帮助系统。')
    end)
end
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
    WoWTools_ChineseMixin:Set_Label_Text(self.Label, text)
end)]]








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
    local text= e.strText[msg]
    if text and msg~=text then
        self:AddMessage(text, ...)
    end
end)


--团队
CompactRaidFrameManager.displayFrame.label:SetText(IsInRaid() and '团员' or '队员')
hooksecurefunc('CompactRaidFrameManager_UpdateLabel', function()
    CompactRaidFrameManager.displayFrame.label:SetText(IsInRaid() and '团员' or '队员')
end)
--WoWTools_ChineseMixin:Set_Label_Text(parentBottomButtonsLeavePartyButton)
parentBottomButtonsLeavePartyButton:SetText('离开队伍')
--WoWTools_ChineseMixin:Set_Label_Text(parentBottomButtonsLeaveInstanceGroupButton)
WoWTools_ChineseMixin:HookLabel(parentBottomButtonsLeaveInstanceGroupButton)--:SetText('离开副本队伍')

WoWTools_ChineseMixin:Set_Label_Text(CompactRaidFrameManagerDisplayFrame.RestrictPingsLabel.Label)
WoWTools_ChineseMixin:Set_Label_Text(CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerUnitTab)
WoWTools_ChineseMixin:Set_Label_Text(CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerGroundTab)
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

WoWTools_ChineseMixin:SetRegions(RolePollPopup)--, '选择你的职责', 1)
RolePollPopupAcceptButtonText:SetText('接受')

--HelpTipTemplateMixin:ApplyText()
hooksecurefunc(HelpTipTemplateMixin, 'ApplyText', function(frame)
    local text= e.strText[frame.info.text]
    if text then
        frame.info.text= text
        frame.Text:SetText(text)
    end
end)
if _G['HelpPlate_Button_OnEnter'] then--11.1.5无
    hooksecurefunc('HelpPlate_Button_OnEnter', function(self)
        local text= e.strText[self.toolTipText]
        if text then
            self.toolTipText= text
            HelpPlateTooltip.Text:SetText(text)
        end
    end)
end




--PlayerCastingBarFrame
hooksecurefunc(PlayerCastingBarFrame, 'HandleInterruptOrSpellFailed', function(self, _, event, ...)
    -- self.barType == "interrupted" and self.Text then
    --    self.Text:SetText(event == "UNIT_SPELLCAST_FAILED" and '失败' or '被打断')
    WoWTools_ChineseMixin:Set_Label_Text(self.Text)
end)

PlayerCastingBarFrame:HookScript('OnEvent', function(self, event, _, _, spellID)
    if self:IsShown() then
        if event== "UNIT_SPELLCAST_START" or event== "UNIT_SPELLCAST_CHANNEL_START" or event== "UNIT_SPELLCAST_EMPOWER_START" then
            local name= WoWTools_ChineseMixin:Setup(self.Text:GetText(), {spellID=spellID, isName=true})
            if name then
                self.Text:SetText(name)
            end
        else
            WoWTools_ChineseMixin:Set_Label_Text(self.Text)            
        end
    end
end)


hooksecurefunc(OverlayPlayerCastingBarFrame, 'HandleInterruptOrSpellFailed', function(self, _, event, ...)
    -- self.barType == "interrupted" and self.Text then
    --    self.Text:SetText(event == "UNIT_SPELLCAST_FAILED" and '失败' or '被打断')
    WoWTools_ChineseMixin:Set_Label_Text(self.Text)
end)
OverlayPlayerCastingBarFrame:HookScript('OnEvent', function(self, event, _, _, spellID)
    if self:IsShown() then
        if event== "UNIT_SPELLCAST_START" or event== "UNIT_SPELLCAST_CHANNEL_START" or event== "UNIT_SPELLCAST_EMPOWER_START" then
            local name= WoWTools_ChineseMixin:Setup(self.Text:GetText(), {spellID=spellID, isName=true})
            if name then
                self.Text:SetText(name)
            end
        else
            WoWTools_ChineseMixin:Set_Label_Text(self.Text)            
        end
    end
end)



C_Timer.After(4, function()
    AddonCompartmentFrame:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_LEFT")
        GameTooltip_SetTitle(GameTooltip, '插件')
        GameTooltip:Show()
    end)



    for i=1, 12 do
        WoWTools_ChineseMixin:Set_Label_Text(_G['ChatMenuButton'..i])
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





    
    --[[Blizzard_FrameXMLBase/Constants.lua
    local function set_table(data)
        for index, name in pairs(_G[data] or {}) do
            local cnName= e.strText[name]
            if cnName then
                _G[data][index]= cnName
            end
        end
    end
    local tab={
        'SCHOOL_STRINGS',
        'CALENDAR_WEEKDAY_NAMES',
        'CALENDAR_FULLDATE_MONTH_NAMES',
        'LFG_CATEGORY_NAMES',
    }
    for _, name in pairs(tab) do
        set_table(name)
    end]]
end)











--EventToastManager.lua EventToastManagerFrame
--没有全部测试
hooksecurefunc(EventToastScenarioBaseToastMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:Set_Label_Text(self.Title, toastInfo.title)
    WoWTools_ChineseMixin:Set_Label_Text(self.SubTitle, toastInfo.subtitle)
    WoWTools_ChineseMixin:Set_Label_Text(self.Description, toastInfo.instructionText)
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
    WoWTools_ChineseMixin:Set_Label_Text(self.Contents.Title, toastInfo.title)
    WoWTools_ChineseMixin:Set_Label_Text(self.Contents.SubTitle, e.strText[toastInfo.subtitle])
end)
hooksecurefunc(EventToastWithIconBaseMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:Set_Label_Text(self.Title, toastInfo.title)
    WoWTools_ChineseMixin:Set_Label_Text(self.SubTitle, toastInfo.subtitle)
    if not self.isSideDisplayToast then
        WoWTools_ChineseMixin:Set_Label_Text(self.InstructionalText, toastInfo.instructionText)
    end
end)
hooksecurefunc(EventToastWithIconWithRarityMixin, 'Setup', function(self, toastInfo)
    if (toastInfo.qualityString) then
        WoWTools_ChineseMixin:Set_Label_Text(self.RarityValue, toastInfo.qualityString)
    end
end)
hooksecurefunc(EventToastChallengeModeToastMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:Set_Label_Text(self.Title, toastInfo.title)
    if (toastInfo.time) then
        if e.strText[toastInfo.subtitle] then
            self.SubTitle:SetFormattedText(e.strText[toastInfo.subtitle], SecondsToClock(toastInfo.time/1000, true))
        end
    else
        WoWTools_ChineseMixin:Set_Label_Text(self.SubTitle, toastInfo.subtitle)
    end
end)
hooksecurefunc(EventToastManagerNormalTitleAndSubtitleMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:Set_Label_Text(self.Title, toastInfo.title)
    WoWTools_ChineseMixin:Set_Label_Text(self.SubTitle, toastInfo.subtitle)
end)
hooksecurefunc(EventToastManagerNormalSingleLineMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:Set_Label_Text(self.Title, toastInfo.title)
end)
hooksecurefunc(EventToastManagerNormalBlockTextMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:Set_Label_Text(self.Title, toastInfo.title)
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



