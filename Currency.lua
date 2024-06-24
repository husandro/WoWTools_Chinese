local id, e = ...




local function Init()   
    hooksecurefunc(TokenFrame.ScrollBox, 'Update', function(f)
        for _, frame in pairs(f:GetFrames() or {}) do
            e.set(frame.Content and frame.Content.Name or frame.Name or Frame.Text)
        end
    end)

    
    CharacterFrameTab3:SetText('货币')

    CharacterFrameTab3:HookScript('OnEnter', function()
        GameTooltip:SetText(MicroButtonTooltipText('货币', "TOGGLECURRENCY"), 1.0,1.0,1.0 )
    end)
    TokenFramePopup.Title:SetText('货币设置')
    hooksecurefunc(TokenFrame, 'UpdatePopup', function()
        e.set(TokenFramePopup.InactiveCheckbox.Text)
	    e.set(TokenFramePopup.BackpackCheckbox.Text)
        e.setButton(TokenFramePopup.CurrencyTransferToggleButton)
    end)

    CurrencyTransferMenu:SetTitle('转移货币')
    CurrencyTransferMenu.SourceSelector.SourceLabel:SetText('寄送人')
    CurrencyTransferMenu.AmountSelector.TransferAmountLabel:SetText('转移量')

    hooksecurefunc(CurrencyTransferMenu.SourceBalancePreview, 'SetCharacterName', function(self, characterName)
        self.Label:SetFormattedText('%s |cnRED_FONT_COLOR:的新余额|r' , characterName or "")
    end)
    hooksecurefunc(CurrencyTransferMenu.PlayerBalancePreview, 'SetCharacterName', function(self, characterName)
        self.Label:SetFormattedText('%s |cnGREEN_FONT_COLOR:的新余额|r' , characterName or "")
    end)

    CurrencyTransferMenu.ConfirmButton:SetText('转移')
    CurrencyTransferMenu.CancelButton:SetText('取消')



end














--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then

        if C_AddOns.IsAddOnLoaded('Blizzard_TokenUI') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end
        
    elseif arg1=='Blizzard_TokenUI' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()

    end
end)