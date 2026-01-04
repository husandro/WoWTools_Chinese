

--[[12.0没有了
hooksecurefunc(DragonridingPanelSkillsButtonMixin, 'OnLoad', function(self)--Blizzard_DragonflightLandingPage.lua
    WoWTools_ChineseMixin:SetLabel(self)
end)
]]






--页数 Blizzard_PagingControls.lua
hooksecurefunc(PagingControlsMixin, 'UpdateControls', function(self)
    local shouldHideControls = self.hideWhenSinglePage and self.maxPages <= 1
    if not shouldHideControls then
        if self.displayMaxPages then
            local name= WoWTools_ChineseMixin:SetText(self.currentPageWithMaxText)
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
        WoWTools_ChineseMixin:SetLabel(frame.Type, name)
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












QuestInfoRequiredMoneyText:SetText('需要金钱：')
QuestInfoRewardsFrame.ItemChooseText:SetText('你可以从这些奖励品中选择一件：')
QuestInfoRewardsFrame.PlayerTitleText:SetText('新头衔： %s')
QuestInfoRewardsFrame.QuestSessionBonusReward:SetText('在小队同步状态下完成此任务有可能获得奖励：')








--背包
BagItemSearchBox.Instructions:SetText('搜索')

--SharedReportFrame.xml
ReportFrame.TitleText:SetText('《魔兽世界》客户支持')
hooksecurefunc(ReportFrame, 'InitiateReportInternal', function(self, reportInfo, playerName, playerLocation, isBnetReport, sendReportWithoutDialog)--SharedReportFrame.lua
    self.ReportString:SetFormattedText('举报 %s', playerName)
end)
ReportFrame.ReportingMajorCategoryDropdown.Label:SetText('选择理由')

ReportFrame.MinorReportDescription:SetText('提供详细信息（选择所有适合的项目）')
ReportFrame.Comment.EditBox.Instructions:SetText('补充更多关于这次举报的细节（可选）')
hooksecurefunc(ReportingFrameMinorCategoryButtonMixin, 'SetupButton', function(self, minorCategory)
    local categoryName = minorCategory and _G[C_ReportSystem.GetMinorCategoryString(minorCategory)]
    WoWTools_ChineseMixin:SetLabel(self.Text, categoryName)
end)
ReportFrame.ThankYouText:SetText('感谢您的举报！')
ReportFrame.TitleText:SetText('《魔兽世界》客户支持')
ReportFrame.ReportButton:SetText('举报')




























--ButtonTrayUtil.lua
hooksecurefunc(ButtonTrayUtil, 'TestCheckboxTraySetup', function(button, labelText)--ButtonTrayUtil.lua
    WoWTools_ChineseMixin:SetLabel(button.Label, labelText)
end)

hooksecurefunc(ButtonTrayUtil, 'TestButtonTraySetup', function(button, label)
    label= WoWTools_ChineseMixin:SetText(label)
    if label then
        button:SetText(label)
    end
end)
hooksecurefunc(ResizeCheckButtonMixin, 'SetLabelText', function(self, labelText)
    WoWTools_ChineseMixin:SetLabel(self.Label, labelText)
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








































--MovieFrame.xml
WoWTools_ChineseMixin:SetFrame(MovieFrame.CloseDialog)--, '你确定想要跳过这段过场动画吗？', 1)
MovieFrame.CloseDialog.ConfirmButton:SetText('是')
MovieFrame.CloseDialog.ResumeButton:SetText('否')












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
    local text= WoWTools_ChineseMixin:SetText(msg)
    if text and msg~=text then
        self:AddMessage(text, ...)
    end
end)


--团队
CompactRaidFrameManager.displayFrame.label:SetText(IsInRaid() and '团员' or '队员')
hooksecurefunc('CompactRaidFrameManager_UpdateLabel', function()
    CompactRaidFrameManager.displayFrame.label:SetText(IsInRaid() and '团员' or '队员')
end)
--WoWTools_ChineseMixin:SetLabel(parentBottomButtonsLeavePartyButton)
if parentBottomButtonsLeavePartyButton then--11.2没有了
    parentBottomButtonsLeavePartyButton:SetText('离开队伍')
else
    WoWTools_ChineseMixin:SetLabel(CompactRaidFrameManagerDisplayFrame.RestrictPingsLabel)
    WoWTools_ChineseMixin:SetLabel(CompactRaidFrameManagerLeavePartyButtonText)
    WoWTools_ChineseMixin:HookButton(CompactRaidFrameManagerLeaveInstanceGroupButton)
end

--WoWTools_ChineseMixin:SetLabel(parentBottomButtonsLeaveInstanceGroupButton)
WoWTools_ChineseMixin:HookLabel(parentBottomButtonsLeaveInstanceGroupButton)--:SetText('离开副本队伍')

WoWTools_ChineseMixin:SetLabel(CompactRaidFrameManagerDisplayFrame.RestrictPingsLabel.Label)
WoWTools_ChineseMixin:SetLabel(CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerUnitTab)
WoWTools_ChineseMixin:SetLabel(CompactRaidFrameManagerDisplayFrameRaidMarkersRaidMarkerGroundTab)
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

WoWTools_ChineseMixin:SetFrame(RolePollPopup)--, '选择你的职责', 1)
RolePollPopupAcceptButtonText:SetText('接受')

--HelpTipTemplateMixin:ApplyText()
hooksecurefunc(HelpTipTemplateMixin, 'ApplyText', function(frame)
    local text= WoWTools_ChineseMixin:SetText(frame.info.text)
    if text then
        frame.info.text= text
        frame.Text:SetText(text)
    end
end)
if _G['HelpPlate_Button_OnEnter'] then--11.1.5无
    hooksecurefunc('HelpPlate_Button_OnEnter', function(self)
        local text= WoWTools_ChineseMixin:SetText(self.toolTipText)
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
    WoWTools_ChineseMixin:SetLabel(self.Text)
end)

PlayerCastingBarFrame:HookScript('OnEvent', function(self, event, _, _, spellID)
    if self:IsShown() then
        if event== "UNIT_SPELLCAST_START" or event== "UNIT_SPELLCAST_CHANNEL_START" or event== "UNIT_SPELLCAST_EMPOWER_START" then
            local name= WoWTools_ChineseMixin:GetData(self.Text:GetText(), {spellID=spellID, isName=true})
            if name then
                self.Text:SetText(name)
            end
        else
            WoWTools_ChineseMixin:SetLabel(self.Text)
        end
    end
end)


hooksecurefunc(OverlayPlayerCastingBarFrame, 'HandleInterruptOrSpellFailed', function(self, _, event, ...)
    -- self.barType == "interrupted" and self.Text then
    --    self.Text:SetText(event == "UNIT_SPELLCAST_FAILED" and '失败' or '被打断')
    WoWTools_ChineseMixin:SetLabel(self.Text)
end)
OverlayPlayerCastingBarFrame:HookScript('OnEvent', function(self, event, _, _, spellID)
    if self:IsShown() then
        if event== "UNIT_SPELLCAST_START" or event== "UNIT_SPELLCAST_CHANNEL_START" or event== "UNIT_SPELLCAST_EMPOWER_START" then
            local name= WoWTools_ChineseMixin:GetData(self.Text:GetText(), {spellID=spellID, isName=true})
            if name then
                self.Text:SetText(name)
            end
        else
            WoWTools_ChineseMixin:SetLabel(self.Text)
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
        WoWTools_ChineseMixin:SetLabel(_G['ChatMenuButton'..i])
    end

    if _G['VoiceMacroMenu'] then
        local w= _G['VoiceMacroMenu']:GetWidth()
        _G['VoiceMacroMenu']:SetWidth(w*1.6)
        for i=1, 23 do
            local btn= _G['VoiceMacroMenuButton'..i]
            local name= btn and btn:GetText()
            local text= name and WoWTools_ChineseMixin:SetText(name)
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
            local text= name and WoWTools_ChineseMixin:SetText(name)
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
            local cnName= WoWTools_ChineseMixin:SetText(name)
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
    WoWTools_ChineseMixin:SetLabel(self.Title, toastInfo.title)
    WoWTools_ChineseMixin:SetLabel(self.SubTitle, toastInfo.subtitle)
    WoWTools_ChineseMixin:SetLabel(self.Description, toastInfo.instructionText)
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
    WoWTools_ChineseMixin:SetLabel(self.Contents.Title, toastInfo.title)
    WoWTools_ChineseMixin:SetLabel(self.Contents.SubTitle, WoWTools_ChineseMixin:SetText(toastInfo.subtitle))
end)
hooksecurefunc(EventToastWithIconBaseMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:SetLabel(self.Title, toastInfo.title)
    WoWTools_ChineseMixin:SetLabel(self.SubTitle, toastInfo.subtitle)
    if not self.isSideDisplayToast then
        WoWTools_ChineseMixin:SetLabel(self.InstructionalText, toastInfo.instructionText)
    end
end)
hooksecurefunc(EventToastWithIconWithRarityMixin, 'Setup', function(self, toastInfo)
    if (toastInfo.qualityString) then
        WoWTools_ChineseMixin:SetLabel(self.RarityValue, toastInfo.qualityString)
    end
end)
hooksecurefunc(EventToastChallengeModeToastMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:SetLabel(self.Title, toastInfo.title)
    if (toastInfo.time) then
        if WoWTools_ChineseMixin:CN(toastInfo.subtitle) then
            self.SubTitle:SetFormattedText(WoWTools_ChineseMixin:CN(toastInfo.subtitle), SecondsToClock(toastInfo.time/1000, true))
        end
    else
        WoWTools_ChineseMixin:SetLabel(self.SubTitle, toastInfo.subtitle)
    end
end)
hooksecurefunc(EventToastManagerNormalTitleAndSubtitleMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:SetLabel(self.Title, toastInfo.title)
    WoWTools_ChineseMixin:SetLabel(self.SubTitle, toastInfo.subtitle)
end)
hooksecurefunc(EventToastManagerNormalSingleLineMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:SetLabel(self.Title, toastInfo.title)
end)
hooksecurefunc(EventToastManagerNormalBlockTextMixin, 'Setup', function(self, toastInfo)
    WoWTools_ChineseMixin:SetLabel(self.Title, toastInfo.title)
end)



-- PVP
for index, en in pairs(CONQUEST_SIZE_STRINGS) do
    local cn= WoWTools_ChineseMixin:SetText(en)
    if cn then
        CONQUEST_SIZE_STRINGS[index]= cn
    end
end
for index, en in pairs(CONQUEST_TYPE_STRINGS) do
    local cn= WoWTools_ChineseMixin:SetText(en)
    if cn then
        CONQUEST_TYPE_STRINGS[index]= cn
    end
end

--光环 AuraUtil.lua
if DebuffTypeSymbol then
    DebuffTypeSymbol["Magic"] = '魔'
    DebuffTypeSymbol["Curse"] ='诅'
    DebuffTypeSymbol["Disease"] = '疾'
    DebuffTypeSymbol["Poison"] = '毒'
end




--公会，签名
WoWTools_ChineseMixin:HookLabel(PetitionFrameInstructions)
WoWTools_ChineseMixin:HookLabel(PetitionFrameCharterTitle)
WoWTools_ChineseMixin:HookLabel(PetitionFrameMasterTitle)
WoWTools_ChineseMixin:HookLabel(PetitionFrameRenameButton)
WoWTools_ChineseMixin:SetLabel(PetitionFrameRequestButtonText)
WoWTools_ChineseMixin:SetLabel(PetitionFrameCancelButtonText)
WoWTools_ChineseMixin:SetLabel(PetitionFrameMemberTitle)
PetitionFrameNpcNameText:SetParent(PetitionFrame.TitleContainer)

hooksecurefunc('PetitionFrame_Update', function()
	local petitionType, title, _, _, _, _, _ = GetPetitionInfo();

	if ( petitionType == "guild" ) then
		PetitionFrameNpcNameText:SetFormattedText('%s公会登记表', title)
	end
	local memberText;
	local numNames = GetNumPetitionNames();

	for i=1, minSignatures do
		memberText = _G["PetitionFrameMemberName"..i];
		if ( i > numNames ) then
			memberText:SetText('<未被签名>');
		end
	end
end)


--TabSystem/TabSystemTemplates.lua
hooksecurefunc(TabSystemButtonMixin, 'Init', function(btn, _, tabText)
     WoWTools_ChineseMixin:SetTabButton(btn, tabText)
end)

hooksecurefunc(PanelTabButtonMixin, 'OnLoad', function(btn)
    WoWTools_ChineseMixin:SetTabButton(btn)
end)

