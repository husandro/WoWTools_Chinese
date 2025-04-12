

hooksecurefunc(TokenFrame.ScrollBox, 'Update', function(f)
    if not f:GetView() then
        return
    end
    for _, frame in pairs(f:GetFrames() or {}) do

    end
end)
hooksecurefunc(TokenHeaderMixin, 'Initialize', function(self)
        if self.elementData.name then
        local name= WoWTools_ChineseMixin:CN(self.elementData.name)
        if name then
            self.Name:SetText(name)
        end
    end
end)
hooksecurefunc(TokenEntryMixin, 'Initialize', function(self)
    if self.elementData.name then
        local name= WoWTools_ChineseMixin:CN(self.elementData.name)
        if not self.Content.Name2 then--点击，不能，弹出对话框，所以加个
            self.Content.Name2= self.Content:CreateFontString(nil, 'BORDER', 'GameFontHighlightLeft')
            self.Content.Name2:SetPoint('LEFT', self.Content.AccountWideIcon, 'RIGHT')
            self.Content.Name2:SetPoint('RIGHT', self.Content.Count, 'LEFT', -10, 0)
        end
        self.Content.Name2:SetText(name or '')
        self.Content.Name:SetAlpha(name and 0 or 1)
    end
end)
hooksecurefunc(TokenSubHeaderMixin, 'Initialize', function(self)
    if self.elementData.name then
        local name= WoWTools_ChineseMixin:CN(self.elementData.name)
        if name then
            self.Text:SetText(HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(name))
        end
    end
end)

TokenFramePopup.Title:SetText('货币设置')
TokenFramePopup.InactiveCheckbox.Text:SetText('未使用')
TokenFramePopup.BackpackCheckbox.Text:SetText("在行囊上显示")
TokenFramePopup.CurrencyTransferToggleButton:SetText('转移')
--hooksecurefunc(TokenFrame, 'UpdatePopup', function()

hooksecurefunc(CurrencyTransferMenu, 'RefreshMenuTitle', function(self)
    local name
    if self.currencyInfo then
        name= WoWTools_ChineseMixin:GetData(self.currencyInfo.name) or self.currencyInfo.name
        if name and self.currencyInfo.iconFileID then
            name= '|T'..self.currencyInfo.iconFileID..':0|t'..name
        end
    end
    self:SetTitle(format('转移货币 - %s', name or ""));
end)
--CurrencyTransferMenu:SetTitle('转移货币')
CurrencyTransferMenu.SourceSelector.SourceLabel:SetText('寄送人')
CurrencyTransferMenu.AmountSelector.TransferAmountLabel:SetText('转移量')

--[[hooksecurefunc(CurrencyTransferMenu.SourceBalancePreview, 'SetCharacterName', function(self, characterName)
    self.Label:SetFormattedText('%s |cnRED_FONT_COLOR:的新余额|r' , characterName or "")
end)
hooksecurefunc(CurrencyTransferMenu.PlayerBalancePreview, 'SetCharacterName', function(self, characterName)
    self.Label:SetFormattedText('%s |cnGREEN_FONT_COLOR:的新余额|r' , characterName or "")
end)]]

CurrencyTransferMenu.ConfirmButton:SetText('转移')
CurrencyTransferMenu.CancelButton:SetText('取消')

WoWTools_ChineseMixin:SetLabelText(CurrencyTransferLogTitleText)
WoWTools_ChineseMixin:SetLabelText(CurrencyTransferLog.EmptyLogMessage)

