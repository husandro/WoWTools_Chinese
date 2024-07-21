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

    




    hooksecurefunc(PlayerChoiceBaseOptionButtonTemplateMixin, 'Setup', function(self, buttonInfo, optionInfo)
        e.set(self, buttonInfo.text)
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

    e.hookLabel(TorghastPlayerChoiceToggleButton.Text)
    e.hookLabel(CypherPlayerChoiceToggleButton.Text)
    e.hookLabel(GenericPlayerChoiceToggleButton.Text)
    --[[hooksecurefunc(GenericPlayerChoiceToggleButton, 'UpdateButtonState', function(self)--PlayerChoiceToggleButtonMixin
        if self:IsShown() then
            local choiceFrameShown = PlayerChoiceFrame:IsShown()
            local choiceInfo = C_PlayerChoice.GetCurrentPlayerChoiceInfo() or {}
            self.Text:SetText(choiceFrameShown and '隐藏' or e.cn(choiceInfo.pendingChoiceText))
            
        end
    end)]]





    hooksecurefunc(PlayerChoiceBaseOptionTemplateMixin, 'Setup', function(self, optionInfo, frameTextureKit, soloOption)
        print('PlayerChoiceBaseOptionTemplateMixin')
    end)

    hooksecurefunc(PlayerChoiceBaseOptionCurrencyRewardMixin, 'Setup', function(self, currencyRewardInfo)
        local name= e.strText[currencyRewardInfo.name]
        if name then
            self.Name:SetText(name)
        end
        print('PlayerChoiceBaseOptionCurrencyRewardMixin')
    end)

    hooksecurefunc(PlayerChoiceBaseOptionItemRewardMixin, 'Setup', function(self, ...)
        print('PlayerChoiceBaseOptionItemRewardMixin', ...)
    end)


   


 --[[hooksecurefunc(PlayerChoiceBaseOptionButtonsContainerMixin, 'Setup', function(self, optionInfo, numColumns)
    print('PlayerChoiceBaseOptionButtonsContainerMixin')
        for btn in self.buttonPool:EnumerateActiveByTemplate(self.buttonTemplate) do
            e.set(btn)
        end
    end)]]



    hooksecurefunc(PlayerChoiceBaseOptionCurrencyContainerRewardMixin, 'Setup', function(self, ...)
        print('PlayerChoiceBaseOptionCurrencyContainerRewardMixin',...)
    end)
    hooksecurefunc(PlayerChoiceBaseOptionReputationRewardMixin, 'Setup', function(self, ...)
        print('PlayerChoiceBaseOptionReputationRewardMixin',...)
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