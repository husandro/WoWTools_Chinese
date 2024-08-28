local e= select(2, ...)


--银行
--BankFrame.lua
e.set(BankFrameTab1.Text)--:SetText('银行')
e.set(BankFrameTab2.Text)--:SetText('材料')
e.set(BankFrameTab3.Text)
e.set(BankFramePurchaseButton)
e.set(ReagentBankFrameUnlockInfoPurchaseButton)
e.set(ReagentBankFrameUnlockInfoTitle)
e.set(ReagentBankFrameUnlockInfoText)
e.set(AccountBankPanel.LockPrompt.PromptText)
e.set(ReagentBankFrameUnlockInfoTabCost)

e.hookLabel(BankFrameTitleText)
--BANK_PANELS[2].SetTitle=function() BankFrame:SetTitle('材料银行') end
e.set(ReagentBankFrame.DespositButton)--:SetText('存放各种材料')
e.region(BankFramePurchaseInfo)
--BankItemSearchBox.Instructions:SetText('搜索')
e.region(BankSlotsFrame)
e.region(CombatConfigSettingsNameEditBox)--过滤名称




--战团
e.region( AccountBankPanel.PurchasePrompt)
e.set(AccountBankPanel.PurchasePrompt.TabCostFrame.TabCost)
e.set(AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)
e.set(AccountBankPanel.MoneyFrame.WithdrawButton)
e.set(AccountBankPanel.MoneyFrame.DepositButton)


e.set(AccountBankPanel.ItemDepositFrame.DepositButton)
AccountBankPanel.ItemDepositFrame:HookScript('OnShow', function(self)
    e.set(self.IncludeReagentsCheckbox.Text)
end)


e.set(AccountBankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)
e.set(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignSettingsHeader)
e.set(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignExpansionHeader)
e.set(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.CleanUpSettingsHeader)
e.set(AccountBankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
e.set(AccountBankPanel.TabSettingsMenu.BorderBox.OkayButton)
e.set(AccountBankPanel.TabSettingsMenu.BorderBox.CancelButton)

AccountBankPanel.TabSettingsMenu.DepositSettingsMenu:HookScript('OnShow', function (self)
    e.set(self.AssignEquipmentCheckbox.Text)
    e.set(self.AssignConsumablesCheckbox.Text)
    e.set(self.AssignProfessionGoodsCheckbox.Text)
    e.set(self.AssignReagentsCheckbox.Text)
    e.set(self.AssignJunkCheckbox.Text)
    e.set(self.IgnoreCleanUpCheckbox.Text)
end)

