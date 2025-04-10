local e= select(2, ...)


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
    local header= e.strText[data.header] or e.Get_Spell_Name(data.spellID)
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
    local name= e.strText[self.optionInfo.subHeader]
    if name then
        self.SubHeader.Text:SetText(name)
    end
end

local function set_optionText(self)
    local data= self.optionInfo
    if not data or not self.OptionText:IsShown() then
        return
    end
    local desc= e.strText[data.description] or e.Get_Spell_Desc(data.spellID)
    local quality= rarityToString[data.rarity]
    if desc or quality then
        desc= (quality or '')..(desc or '')
        self.OptionText:SetText(desc)
    end
end









local function Init()
    e.dia("CONFIRM_PLAYER_CHOICE", {button1 = '确定', button2 = '取消'})
    e.dia("CONFIRM_PLAYER_CHOICE_WITH_CONFIRMATION_STRING", {button1 = '接受', button2 = '拒绝'})


    --Blizzard_PlayerChoice.lua
    hooksecurefunc(PlayerChoiceFrame, 'TryShow', function(self)
        local choiceInfo = self.choiceInfo--C_PlayerChoice.GetCurrentPlayerChoiceInfo();
        local name= choiceInfo and e.strText[choiceInfo.questionText]
        if name then
            self.Title.Text:SetText(name)
        end
    end)



    hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, 'SetupHeader', set_header)
    hooksecurefunc(PlayerChoiceNormalOptionTemplateMixin, 'SetupHeader', set_header)


    hooksecurefunc(PlayerChoiceNormalOptionTemplateMixin, 'SetupSubHeader', set_sub_header)

    hooksecurefunc(PlayerChoiceFrame, 'SetupOptions', function(self)
        for frame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
            set_optionText(frame)
        end
    end)

    hooksecurefunc(PlayerChoiceNormalOptionTemplateMixin, 'SetupOptionText', set_optionText)
    hooksecurefunc(PlayerChoiceGenericPowerChoiceOptionTemplateMixin, 'SetupOptionText', set_optionText)






    hooksecurefunc(PlayerChoiceBaseOptionButtonTemplateMixin, 'Setup', function(self, buttonInfo)
        e.set(self, buttonInfo.text)
        local tooltip= e.strText[buttonInfo.tooltip]
        if tooltip then
            self.tooltip = tooltip
        end
    end)

    --隐藏，显示，按钮
    e.hookLabel(TorghastPlayerChoiceToggleButton.Text)
    e.hookLabel(CypherPlayerChoiceToggleButton.Text)
    e.hookLabel(GenericPlayerChoiceToggleButton.Text)

    --剩余时间 Blizzard_PlayerChoiceTimer.lua PlayerChoiceTimeRemainingMixin
    hooksecurefunc(PlayerChoiceTimeRemaining, 'OnUpdate', function(self)
        local remainingTime = C_PlayerChoice.GetRemainingTime();
        if remainingTime ~= nil then
            self.TimerText:SetText("剩余时间："..SecondsToClock(remainingTime))
        end
    end)
end

















EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_PlayerChoice' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)
