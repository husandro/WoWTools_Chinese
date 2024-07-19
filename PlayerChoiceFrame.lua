local e= select(2, ...)

local function Init()

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
        for frame in self.optionPools:EnumerateActiveByTemplate(self.optionFrameTemplate) do
            frame.OptionText:SetText((rarityToString[frame.optionInfo.rarity] or "")..e.cn(frame.optionInfo.description))
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

    e.hookButton(GenericPlayerChoiceToggleButton)
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
        local name= e.strTexts[currencyRewardInfo.name]
        if name then
            self.Name:SetText(name)
        end
        print('PlayerChoiceBaseOptionCurrencyRewardMixin')
    end)

    hooksecurefunc(PlayerChoiceBaseOptionItemRewardMixin, 'Setup', function(self, ...)
        print('PlayerChoiceBaseOptionItemRewardMixin', ...)
    end)

    hooksecurefunc(PlayerChoiceBaseOptionButtonTemplateMixin, 'Setup', function(self, buttonInfo, optionInfo)
        e.set(self, buttonInfo.text)
    end)


    --[[hooksecurefunc(PlayerChoiceBaseOptionButtonsContainerMixin, 'Setup', function(self, optionInfo, numColumns)
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