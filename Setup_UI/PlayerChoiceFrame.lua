


local rarityToString ={
    [Enum.PlayerChoiceRarity.Common] = "|cffffffff普通|r|n|n",
    [Enum.PlayerChoiceRarity.Uncommon] = "|cff1eff00优秀|r|n|n",
    [Enum.PlayerChoiceRarity.Rare] = "|cff0070dd精良|r|n|n",
    [Enum.PlayerChoiceRarity.Epic] = "|cffa335ee史诗|r|n|n",
}





local function set_header(self)
    local data= self.optionInfo
    if not data and data.header and data.header~='' then
        return
    end
    local header= WoWTools_ChineseMixin:CN(data.header) or WoWTools_ChineseMixin:GetSpellName(data.spellID)
    if header then
        local label= self.Header.Contents and self.Header.Contents.Text or  self.Header.Text
        if label then
            label:SetText(header)
        end
    end
end

local function set_sub_header(self)
    if not self.SubHeader:IsShown() then
        return
    end
    local name= WoWTools_ChineseMixin:CN(self.optionInfo.subHeader)
    if name then
        self.SubHeader.Text:SetText(name)
    end
end

local function set_optionText(self)
    local data= self.optionInfo
    if not data or not self.OptionText:IsShown() then
        return
    end
    local desc= WoWTools_ChineseMixin:CN(data.description) or WoWTools_ChineseMixin:GetSpellDesc(data.spellID)
    local quality= rarityToString[data.rarity]
    if desc or quality then
        desc= (quality or '')..(desc or '')
        self.OptionText:SetText(desc)
    end
end









function WoWTools_ChineseMixin.Events:Blizzard_PlayerChoice()
    WoWTools_ChineseMixin:AddDialogs("CONFIRM_PLAYER_CHOICE", {button1 = '确定', button2 = '取消'})
    WoWTools_ChineseMixin:AddDialogs("CONFIRM_PLAYER_CHOICE_WITH_CONFIRMATION_STRING", {button1 = '接受', button2 = '拒绝'})


    --Blizzard_PlayerChoice.lua
    hooksecurefunc(PlayerChoiceFrame, 'TryShow', function(frame)
        local choiceInfo = frame.choiceInfo--C_PlayerChoice.GetCurrentPlayerChoiceInfo();
        local name= choiceInfo and WoWTools_ChineseMixin:CN(choiceInfo.questionText)
        if name then
            frame.Title.Text:SetText(name)
        end
    end)



    hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, 'SetupHeader', set_header)
    hooksecurefunc(PlayerChoiceNormalOptionTemplateMixin, 'SetupHeader', set_header)


    hooksecurefunc(PlayerChoiceNormalOptionTemplateMixin, 'SetupSubHeader', set_sub_header)

    hooksecurefunc(PlayerChoiceFrame, 'SetupOptions', function(frame)
        for f in frame.optionPools:EnumerateActiveByTemplate(frame.optionFrameTemplate) do
            set_optionText(f)
        end
    end)

    hooksecurefunc(PlayerChoiceNormalOptionTemplateMixin, 'SetupOptionText', set_optionText)
    hooksecurefunc(PlayerChoiceGenericPowerChoiceOptionTemplateMixin, 'SetupOptionText', set_optionText)






    hooksecurefunc(PlayerChoiceBaseOptionButtonTemplateMixin, 'Setup', function(frame, buttonInfo)
        WoWTools_ChineseMixin:SetLabel(frame, buttonInfo.text)
        local tooltip= WoWTools_ChineseMixin:CN(buttonInfo.tooltip)
        if tooltip then
            frame.tooltip = tooltip
        end
    end)

    --隐藏，显示，按钮
    WoWTools_ChineseMixin:HookLabel(TorghastPlayerChoiceToggleButton.Text)
    WoWTools_ChineseMixin:HookLabel(CypherPlayerChoiceToggleButton.Text)
    WoWTools_ChineseMixin:HookLabel(GenericPlayerChoiceToggleButton.Text)

    --剩余时间 Blizzard_PlayerChoiceTimer.lua PlayerChoiceTimeRemainingMixin
    hooksecurefunc(PlayerChoiceTimeRemaining, 'OnUpdate', function(frame)
        local remainingTime = C_PlayerChoice.GetRemainingTime();
        if remainingTime ~= nil then
            frame.TimerText:SetText("剩余时间："..SecondsToClock(remainingTime))
        end
    end)
end

