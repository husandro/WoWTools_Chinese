local e= select(2, ...)


--银行
--BankFrame.lua
WoWTools_ChineseMixin:Set_Label_Text(BankFrameTab1.Text)--:SetText('银行')
WoWTools_ChineseMixin:Set_Label_Text(BankFrameTab2.Text)--:SetText('材料')
WoWTools_ChineseMixin:Set_Label_Text(BankFrameTab3.Text)
WoWTools_ChineseMixin:Set_Label_Text(BankFramePurchaseButton)
WoWTools_ChineseMixin:Set_Label_Text(ReagentBankFrameUnlockInfoPurchaseButton)
WoWTools_ChineseMixin:Set_Label_Text(ReagentBankFrameUnlockInfoTitle)
WoWTools_ChineseMixin:Set_Label_Text(ReagentBankFrameUnlockInfoText)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.LockPrompt.PromptText)
WoWTools_ChineseMixin:Set_Label_Text(ReagentBankFrameUnlockInfoTabCost)

WoWTools_ChineseMixin:HookLabel(BankFrameTitleText)
--BANK_PANELS[2].SetTitle=function() BankFrame:SetTitle('材料银行') end
WoWTools_ChineseMixin:Set_Label_Text(ReagentBankFrame.DespositButton)--:SetText('存放各种材料')
WoWTools_ChineseMixin:SetRegions(BankFramePurchaseInfo)
--BankItemSearchBox.Instructions:SetText('搜索')
WoWTools_ChineseMixin:SetRegions(BankSlotsFrame)
WoWTools_ChineseMixin:SetRegions(CombatConfigSettingsNameEditBox)--过滤名称




--战团
WoWTools_ChineseMixin:SetRegions( AccountBankPanel.PurchasePrompt)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.PurchasePrompt.TabCostFrame.TabCost)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.MoneyFrame.WithdrawButton)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.MoneyFrame.DepositButton)


WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.ItemDepositFrame.DepositButton)
AccountBankPanel.ItemDepositFrame:HookScript('OnShow', function(self)
    WoWTools_ChineseMixin:Set_Label_Text(self.IncludeReagentsCheckbox.Text)
end)
WoWTools_ChineseMixin:Set_Label_Text(BankItemSearchBox.Instructions)


WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignSettingsHeader)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignExpansionHeader)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.CleanUpSettingsHeader)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.TabSettingsMenu.BorderBox.OkayButton)
WoWTools_ChineseMixin:Set_Label_Text(AccountBankPanel.TabSettingsMenu.BorderBox.CancelButton)

AccountBankPanel.TabSettingsMenu.DepositSettingsMenu:HookScript('OnShow', function (self)
    WoWTools_ChineseMixin:Set_Label_Text(self.AssignEquipmentCheckbox.Text)
    WoWTools_ChineseMixin:Set_Label_Text(self.AssignConsumablesCheckbox.Text)
    WoWTools_ChineseMixin:Set_Label_Text(self.AssignProfessionGoodsCheckbox.Text)
    WoWTools_ChineseMixin:Set_Label_Text(self.AssignReagentsCheckbox.Text)
    WoWTools_ChineseMixin:Set_Label_Text(self.AssignJunkCheckbox.Text)
    WoWTools_ChineseMixin:Set_Label_Text(self.IgnoreCleanUpCheckbox.Text)
end)

