if not BankFrameTab1 then--11.2 没有了
    return
end


--银行
--BankFrame.lua
WoWTools_ChineseMixin:SetLabel(BankFrameTab1.Text)--:SetText('银行')
WoWTools_ChineseMixin:SetLabel(BankFrameTab2.Text)--:SetText('材料')
WoWTools_ChineseMixin:SetLabel(BankFrameTab3.Text)
WoWTools_ChineseMixin:SetLabel(BankFramePurchaseButton)
WoWTools_ChineseMixin:SetLabel(ReagentBankFrameUnlockInfoPurchaseButton)
WoWTools_ChineseMixin:SetLabel(ReagentBankFrameUnlockInfoTitle)
WoWTools_ChineseMixin:SetLabel(ReagentBankFrameUnlockInfoText)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.LockPrompt.PromptText)
WoWTools_ChineseMixin:SetLabel(ReagentBankFrameUnlockInfoTabCost)

WoWTools_ChineseMixin:HookLabel(BankFrameTitleText)
--BANK_PANELS[2].SetTitle=function() BankFrame:SetTitle('材料银行') end
WoWTools_ChineseMixin:SetLabel(ReagentBankFrame.DespositButton)--:SetText('存放各种材料')
WoWTools_ChineseMixin:SetRegions(BankFramePurchaseInfo)
--BankItemSearchBox.Instructions:SetText('搜索')
WoWTools_ChineseMixin:SetRegions(BankSlotsFrame)
WoWTools_ChineseMixin:SetRegions(CombatConfigSettingsNameEditBox)--过滤名称




--战团
WoWTools_ChineseMixin:SetRegions( AccountBankPanel.PurchasePrompt)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.PurchasePrompt.TabCostFrame.TabCost)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.MoneyFrame.WithdrawButton)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.MoneyFrame.DepositButton)


WoWTools_ChineseMixin:SetLabel(AccountBankPanel.ItemDepositFrame.DepositButton)
AccountBankPanel.ItemDepositFrame:HookScript('OnShow', function(self)
    WoWTools_ChineseMixin:SetLabel(self.IncludeReagentsCheckbox.Text)
end)
WoWTools_ChineseMixin:SetLabel(BankItemSearchBox.Instructions)


WoWTools_ChineseMixin:SetLabel(AccountBankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignSettingsHeader)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.AssignExpansionHeader)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.TabSettingsMenu.DepositSettingsMenu.CleanUpSettingsHeader)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.TabSettingsMenu.BorderBox.OkayButton)
WoWTools_ChineseMixin:SetLabel(AccountBankPanel.TabSettingsMenu.BorderBox.CancelButton)

AccountBankPanel.TabSettingsMenu.DepositSettingsMenu:HookScript('OnShow', function (self)
    WoWTools_ChineseMixin:SetLabel(self.AssignEquipmentCheckbox.Text)
    WoWTools_ChineseMixin:SetLabel(self.AssignConsumablesCheckbox.Text)
    WoWTools_ChineseMixin:SetLabel(self.AssignProfessionGoodsCheckbox.Text)
    WoWTools_ChineseMixin:SetLabel(self.AssignReagentsCheckbox.Text)
    WoWTools_ChineseMixin:SetLabel(self.AssignJunkCheckbox.Text)
    WoWTools_ChineseMixin:SetLabel(self.IgnoreCleanUpCheckbox.Text)
end)

