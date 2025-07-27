
--公会银行
function WoWTools_ChineseMixin.Frames:BankFrame()

    if BankFrameTab1 then--11.2没了
        return
    end

    self:SetFrame(BankPanel.PurchasePrompt, nil, true)
    self:SetLabel(BankPanel.PurchasePrompt.TabCostFrame.TabCost)
    self:SetButton(BankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)
    self:SetButton(BankPanel.MoneyFrame.WithdrawButton)
    self:SetButton(BankPanel.MoneyFrame.DepositButton)
    self:HookButton(BankPanel.AutoDepositFrame.DepositButton)
    self:HookLabel(BankPanel.AutoDepositFrame.IncludeReagentsCheckbox.Text)

    self:SetFrame(BankPanel.TabSettingsMenu.DepositSettingsMenu)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignEquipmentCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignConsumablesCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignProfessionGoodsCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignReagentsCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignJunkCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.IgnoreCleanUpCheckbox.Text)

    self:HookLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription)
    self:SetLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
    self:HookLabel(BankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)

    self:SetButton(BankPanel.TabSettingsMenu.BorderBox.OkayButton)
    self:SetButton(BankPanel.TabSettingsMenu.BorderBox.CancelButton)

    self:HookLabel(BankCleanUpConfirmationPopup.Text)
    self:SetLabel(BankCleanUpConfirmationPopup.HidePopupCheckbox.Label)
    self:SetButton(BankCleanUpConfirmationPopup.AcceptButton)
    self:SetButton(BankCleanUpConfirmationPopup.CancelButton)


    if WoWTools_BankMixin then
        return
    end

    self:SetLabel(BankPanel.TabSettingsMenu.BorderBox.IconSelectionText)


    for _, btn in pairs(BankFrame.TabSystem.tabs) do--TabSystemMixin
       self:SetButton(btn)
    end
    self:HookLabel(BankFrameTitleText)
end



EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function(owner)
    for name, func in pairs(WoWTools_ChineseMixin.Frames) do
        do
            if _G[name] then
                func(WoWTools_ChineseMixin)
            end
        end
        WoWTools_ChineseMixin.Frames[name]= nil
    end
    EventRegistry:UnregisterCallback('PLAYER_ENTERING_WORLD', owner)
end)
