

function WoWTools_ChineseMixin.Frames:ReputationFrame()
    hooksecurefunc(ReputationBarMixin, 'TryShowReputationStandingText', function(frame)
        local text= frame.reputationStandingText
        if text then
            local cnName= self:CN(text)
            if not cnName and text:find('(.-) %d') then
                local name= text:match('(.-) %d')
                local name2= name and self:CN(name)
                if name and name2 then
                    cnName=text:gsub(name, name2)
                end
            end
            if cnName then
                frame.BarText:SetText(cnName)
            end
        end
    end)

    self:HookLabel(ReputationFrame.filterDropdown.Text)
    self:HookLabel(ReputationFrame.ReputationDetailFrame.Title)
    self:HookLabel(ReputationFrame.ReputationDetailFrame.ScrollingDescription)

    ReputationFrame.ReputationDetailFrame.ViewRenownButton:SetText('浏览名望')--ReputationFrame.xml
    ReputationFrame.ReputationDetailFrame.WatchFactionCheckbox.Label:SetText('显示为经验条')
    ReputationFrame.ReputationDetailFrame.MakeInactiveCheckbox.Label:SetText('隐藏')
    ReputationFrame.ReputationDetailFrame.AtWarCheckbox.Label:SetText('交战状态')

    hooksecurefunc(ReputationHeaderMixin, 'Initialize', function(frame)
        if frame.elementData.name then
            local cnName= self:CN(frame.elementData.name)
            if cnName then
                frame.Name:SetText(cnName)
            end
        end
    end)
    hooksecurefunc(ReputationEntryMixin, 'Initialize', function(frame)
        if frame.elementData.name then
            local cnName= self:CN(frame.elementData.name)
            if cnName then
                frame.Content.Name:SetText(cnName)
            end
        end
    end)
end











function WoWTools_ChineseMixin.Events:Blizzard_TokenUI()
    hooksecurefunc(TokenHeaderMixin, 'Initialize', function(frame)
        if frame.elementData.name then
            local name= self:CN(frame.elementData.name)
            if name then
                frame.Name:SetText(name)
            end
        end
    end)
    hooksecurefunc(TokenEntryMixin, 'Initialize', function(frame)
        if frame.elementData.name then
            local name= self:CN(frame.elementData.name)
            if not frame.Content.Name2 then--点击，不能，弹出对话框，所以加个
                frame.Content.Name2= frame.Content:CreateFontString(nil, 'BORDER', 'GameFontHighlightLeft')
                frame.Content.Name2:SetPoint('LEFT', frame.Content.AccountWideIcon, 'RIGHT')
                frame.Content.Name2:SetPoint('RIGHT', frame.Content.Count, 'LEFT', -10, 0)
            end
            frame.Content.Name2:SetText(name or '')
            frame.Content.Name:SetAlpha(name and 0 or 1)
        end
    end)
    hooksecurefunc(TokenSubHeaderMixin, 'Initialize', function(frame)
        if frame.elementData.name then
            local name= self:CN(frame.elementData.name)
            if name then
                frame.Text:SetText(HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(name))
            end
        end
    end)

    TokenFramePopup.Title:SetText('货币设置')
    TokenFramePopup.InactiveCheckbox.Text:SetText('未使用')
    TokenFramePopup.BackpackCheckbox.Text:SetText("在行囊上显示")
    TokenFramePopup.CurrencyTransferToggleButton:SetText('转移')

    hooksecurefunc(CurrencyTransferMenu, 'RefreshMenuTitle', function(frame)
        local name
        if frame.currencyInfo then
            name= self:CN(frame.currencyInfo.name) or frame.currencyInfo.name
            if name and frame.currencyInfo.iconFileID then
                name= '|T'..frame.currencyInfo.iconFileID..':0|t'..name
            end
        end
        frame:SetTitle(format('转移货币 - %s', name or ""));
    end)

    if CurrencyTransferMenu.SourceSelector then--11.2 没了
        CurrencyTransferMenu.SourceSelector.SourceLabel:SetText('寄送人')
        CurrencyTransferMenu.AmountSelector.TransferAmountLabel:SetText('转移量')
        CurrencyTransferMenu.ConfirmButton:SetText('转移')
        CurrencyTransferMenu.CancelButton:SetText('取消')
    else
        self:SetLabel(CurrencyTransferMenu.Content.SourceSelector.SourceLabel)
        self:SetLabel(CurrencyTransferMenu.Content.AmountSelector.TransferAmountLabel)
        self:SetButton(CurrencyTransferMenu.Content.AmountSelector.MaxQuantityButton)
        self:SetButton(CurrencyTransferMenu.Content.ConfirmButton)
        self:SetButton(CurrencyTransferMenu.Content.CancelButton)
    end
    self:SetLabel(CurrencyTransferLogTitleText)
    self:SetLabel(CurrencyTransferLog.EmptyLogMessage)
    self:HookLabel(TokenFrame.filterDropdown.Text)
end