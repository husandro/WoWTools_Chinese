local e= select(2, ...)
--商人
MerchantFrameTab1:SetText('商人')
MerchantFrameTab2:SetText('购回')
MerchantPageText:SetText('')
e.hookLabel(MerchantFrameTitleText)

--卖
hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function()
    if not MerchantFrame:IsShown() then
        return
    end
    MerchantPageText:SetFormattedText('页数 %s/%s', MerchantFrame.page, math.ceil(GetMerchantNumItems() / MERCHANT_ITEMS_PER_PAGE))
    for i = 1, MERCHANT_ITEMS_PER_PAGE do
        local btn= _G['MerchantItem'..i]
        local label= _G['MerchantItem'..i..'Name']
        if btn and btn.ItemButton.hasItem and label then
            local itemID= GetMerchantItemID(btn.ItemButton:GetID())
            local itemName= e.Get_Item_Name(itemID)
            if itemName then
                itemName= itemName:match('^|c........(.+)|r$') or itemName                
                label:SetText(itemName)
            end
        end
    end
end)

--回购
hooksecurefunc('MerchantFrame_UpdateBuybackInfo', function()
    if not MerchantFrame:IsShown() then
        return
    end
    for i = 1, BUYBACK_ITEMS_PER_PAGE do
        local btn= _G['MerchantItem'..i]
        local label= _G['MerchantItem'..i..'Name']
        if btn and btn.ItemButton.hasItem and label then
            local itemID= C_MerchantFrame.GetBuybackItemID(btn.ItemButton:GetID())
            local itemName= e.Get_Item_Name(itemID)
            if itemName then
                itemName= itemName:match('^|c........(.+)|r$') or itemName
                label:SetText(itemName)
            end
        end
    end
end)










--StackSplitFrame.lua
hooksecurefunc(StackSplitFrame, 'ChooseFrameType', function(self, splitAmount)
    if splitAmount ~= 1 then
        self.StackSplitText:SetFormattedText('%d 堆', self.split/self.minSplit)
        self.StackItemCountText:SetFormattedText('总计%d', self.split)
    end
end)
hooksecurefunc(StackSplitFrame, 'UpdateStackText', function(self)
    if self.isMultiStack then
        self.StackSplitText:SetFormattedText('%d 堆', self.split/self.minSplit)
        self.StackItemCountText:SetFormattedText('总计%d', self.split)
    end
end)



StackSplitFrame.OkayButton:SetText('确定')
StackSplitFrame.CancelButton:SetText('取消')