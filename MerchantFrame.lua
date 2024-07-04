local e= select(2, ...)
--商人
MerchantFrameTab1:SetText('商人')
MerchantFrameTab2:SetText('购回')
MerchantPageText:SetText('')
hooksecurefunc('MerchantFrame_UpdateBuybackInfo', function ()
    MerchantFrame:SetTitle('从商人处购回')
end)
hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function()
    if not MerchantFrame:IsShown() then
        return
    end
    MerchantPageText:SetFormattedText('页数 %s/%s', MerchantFrame.page, math.ceil(GetMerchantNumItems() / MERCHANT_ITEMS_PER_PAGE))
end)

--卖
hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function()
    if not MerchantFrame:IsShown() then
        return
    end
    for i = 1, GetMerchantNumItems() do
        local btn= _G['MerchantItem'..i]
        local label= _G['MerchantItem'..i..'Name']
        if btn and label then
            local itemID= GetMerchantItemID(i)
            if itemID then
                local name= e.Get_Item_Search_Name(itemID) or e.strText[label:GetText()]
                if name then
                    label:SetText(name)
                end
            end
        end
    end
end)

--回购
hooksecurefunc('MerchantFrame_UpdateBuybackInfo', function()
    if not MerchantFrame:IsShown() then
        return
    end
    for i = 1, GetNumBuybackItems() do
        local btn= _G['MerchantItem'..i]
        local label= _G['MerchantItem'..i..'Name']
        if btn and label then
            local itemID= C_MerchantFrame.GetBuybackItemID(i)
            if itemID then
                local name= e.Get_Item_Search_Name(itemID) or e.strText[label:GetText()]
                if name then
                    label:SetText(name)
                end
            end
        end
    end
end)

hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function()
    local num = GetNumBuybackItems()
    if not MerchantFrame:IsShown() or num==0 then
        return
    end
    local itemID= C_MerchantFrame.GetBuybackItemID(num)
    if itemID then
        local itemName= GetBuybackItemInfo(num)
        local name= itemID and e.Get_Item_Search_Name(itemID) or e.strText[itemName]
        if name then
            MerchantBuyBackItemName:SetText(name)
        end
    end
end)