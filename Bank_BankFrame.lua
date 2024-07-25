local e= select(2, ...)


--银行
--BankFrame.lua
BankFrameTab1.Text:SetText('银行')
BankFrameTab2.Text:SetText('材料')
e.set(BankFrameTab3.Text)
e.set(BankFramePurchaseButton)
e.set(ReagentBankFrameUnlockInfoPurchaseButton)
e.set(ReagentBankFrameUnlockInfoTitle)
e.set(ReagentBankFrameUnlockInfoText)
e.set(AccountBankPanel.LockPrompt.PromptText)
e.set(ReagentBankFrameUnlockInfoTabCost)

BANK_PANELS[2].SetTitle=function() BankFrame:SetTitle('材料银行') end
if ReagentBankFrame.DespositButton:GetText()~='' then
    ReagentBankFrame.DespositButton:SetText('存放各种材料')
end
e.region(BankFramePurchaseInfo)
BankItemSearchBox.Instructions:SetText('搜索')
e.region(BankSlotsFrame)
e.region(CombatConfigSettingsNameEditBox)--过滤名称


