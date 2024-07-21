local e= select(2, ...)


local rarityToString ={
    [Enum.PlayerChoiceRarity.Common] = "|cffffffff普通|r|n|n",
    [Enum.PlayerChoiceRarity.Uncommon] = "|cff1eff00优秀|r|n|n",
    [Enum.PlayerChoiceRarity.Rare] = "|cff0070dd精良|r|n|n",
    [Enum.PlayerChoiceRarity.Epic] = "|cffa335ee史诗|r|n|n",
}









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

    hooksecurefunc(PlayerChoiceFrame, 'SetupOptions', function(self)
        for frame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
            local data= frame.optionInfo
            local desc
            if data then
                desc= e.strText[data.description] or e.Get_Spell_Desc(data.spellID)
                local quality= rarityToString[data.rarity]
                if desc or quality then
                    desc= (quality or '')..(desc or '')
                end
            end
            if desc then
                frame.OptionText:SetText(desc)
            end
           
        end
    end)



    --标题, Power
    hooksecurefunc(PlayerChoicePowerChoiceTemplateMixin, 'SetupHeader', function (self)
        local data= self.optionInfo
        if not data then
            return
        end
        local name= e.cn(data.header, {spellID= data.spellID, isName=true})
        if name then
            self.Header.Text:SetText(name)
        end
        e.set(self.Header.Text, self.optionInfo.header)
    end)


    --Button
    hooksecurefunc(PlayerChoiceBaseOptionButtonTemplateMixin, 'Setup', function(self, buttonInfo, optionInfo)
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



















--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_PlayerChoice') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_PlayerChoice' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()

    end
end)