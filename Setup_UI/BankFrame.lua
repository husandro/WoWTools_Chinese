if BankFrameTab1 then--11.2
    return
end


--公会银行
function WoWTools_ChineseMixin.Frames:BankFrame(f)
    f:SetFrame(BankPanel.PurchasePrompt, nil, true)
    f:SetLabel(BankPanel.PurchasePrompt.TabCostFrame.TabCost)
    f:SetButton(BankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)
    f:SetButton(BankPanel.MoneyFrame.WithdrawButton)
    f:SetButton(BankPanel.MoneyFrame.DepositButton)
    f:HookButton(BankPanel.AutoDepositFrame.DepositButton)
    f:HookLabel(BankPanel.AutoDepositFrame.IncludeReagentsCheckbox.Text)

    f:SetFrame(BankPanel.TabSettingsMenu.DepositSettingsMenu)
    f:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignEquipmentCheckbox.Text)
    f:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignConsumablesCheckbox.Text)
    f:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignProfessionGoodsCheckbox.Text)
    f:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignReagentsCheckbox.Text)
    f:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignJunkCheckbox.Text)
    f:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.IgnoreCleanUpCheckbox.Text)

    f:HookLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription)
    f:SetLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
    f:HookLabel(BankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)

    f:SetButton(BankPanel.TabSettingsMenu.BorderBox.OkayButton)
    f:SetButton(BankPanel.TabSettingsMenu.BorderBox.CancelButton)

    f:HookLabel(BankCleanUpConfirmationPopup.Text)
    f:SetLabel(BankCleanUpConfirmationPopup.HidePopupCheckbox.Label)
    f:SetButton(BankCleanUpConfirmationPopup.AcceptButton)
    f:SetButton(BankCleanUpConfirmationPopup.CancelButton)


    if WoWTools_BankMixin then
        return
    end

    f:SetLabel(BankPanel.TabSettingsMenu.BorderBox.IconSelectionText)


    for _, btn in pairs(BankFrame.TabSystem.tabs) do--TabSystemMixin
       f:SetButton(btn)
    end
    f:HookLabel(BankFrameTitleText)
end


