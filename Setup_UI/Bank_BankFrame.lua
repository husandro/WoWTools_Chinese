local e= select(2, ...)


--银行
--BankFrame.lua
WoWTools_ChineseMixin:SetLabelText(BankFrameTab1.Text)--:SetText('银行')
WoWTools_ChineseMixin:SetLabelText(BankFrameTab2.Text)--:SetText('材料')
WoWTools_ChineseMixin:SetLabelText(BankFrameTab3.Text)
WoWTools_ChineseMixin:SetLabelText(BankFramePurchaseButton)
WoWTools_ChineseMixin:SetLabelText(ReagentBankFrameUnlockInfoPurchaseButton)
WoWTools_ChineseMixin:SetLabelText(ReagentBankFrameUnlockInfoTitle)
WoWTools_ChineseMixin:SetLabelText(ReagentBankFrameUnlockInfoText)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.LockPrompt.PromptText)
WoWTools_ChineseMixin:SetLabelText(ReagentBankFrameUnlockInfoTabCost)

WoWTools_ChineseMixin:HookLabel(BankFrameTitleText)
--BANK_PANELS[2].SetTitle=function() BankFrame:SetTitle('材料银行') end
WoWTools_ChineseMixin:SetLabelText(ReagentBankFrame.DespositButton)--:SetText('存放各种材料')
WoWTools_ChineseMixin:SetRegions(BankFramePurchaseInfo)
--BankItemSearchBox.Instructions:SetText('搜索')
WoWTools_ChineseMixin:SetRegions(BankSlotsFrame)
WoWTools_ChineseMixin:SetRegions(CombatConfigSettingsNameEditBox)--过滤名称




--战团
WoWTools_ChineseMixin:SetRegions( AccountBankPanel.PurchasePrompt)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.PurchasePrompt.TabCostFrame.TabCost)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.MoneyFrame.WithdrawButton)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.MoneyFrame.DepositButton)


WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.ItemDepositFrame.DepositButton)
AccountBankPanel.ItemDepositFrame:HookScript('OnShow', function(self)
    WoWTools_ChineseMixin:SetLabelText(self.IncludeReagentsCheckbox.Text)
end)
WoWTools_ChineseMixin:SetLabelText(BankItemSearchBox.Instructions)


WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignSettingsHeader)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignExpansionHeader)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.CleanUpSettingsHeader)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.TabSettingsMenu.BorderBox.OkayButton)
WoWTools_ChineseMixin:SetLabelText(AccountBankPanel.TabSettingsMenu.BorderBox.CancelButton)

AccountBankPanel.TabSettingsMenu.DepositSettingsMenu:HookScript('OnShow', function (self)
    WoWTools_ChineseMixin:SetLabelText(self.AssignEquipmentCheckbox.Text)
    WoWTools_ChineseMixin:SetLabelText(self.AssignConsumablesCheckbox.Text)
    WoWTools_ChineseMixin:SetLabelText(self.AssignProfessionGoodsCheckbox.Text)
    WoWTools_ChineseMixin:SetLabelText(self.AssignReagentsCheckbox.Text)
    WoWTools_ChineseMixin:SetLabelText(self.AssignJunkCheckbox.Text)
    WoWTools_ChineseMixin:SetLabelText(self.IgnoreCleanUpCheckbox.Text)
end)

