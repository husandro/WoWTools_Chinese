

























local function Init_Blizzard_PerksProgramElements()
    --Blizzard_PerksProgramElements.lua
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CONFIRM_PURCHASE", {text= '用%s%s 交易下列物品？', button1 = '购买', button2 = '取消'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CONFIRM_REFUND", {text= '退还下列物品，获得退款%s%s？', button1 = '退款', button2 = '取消'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_SERVER_ERROR", {text= '商栈与服务器交换数据时出现困难，请稍后再试。', button1 = '确定'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_ITEM_PROCESSING_ERROR", {text= '正在处理一件物品。请稍后再试。。', button1 = '确定'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CONFIRM_OVERRIDE_FROZEN_ITEM", {text= '你确定想替换当前的冻结物品吗？现在的冻结物品有可能已经下架了。', button1 = '确认', button2 = '取消'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_SLOW_PURCHASE", {text= '处理您的本次购买所花费的时间比正常情况更长。购买过程会在后台继续进行。', button1= '回到商栈'})

    --PerksProgramProductDetailsFrameMixin
    --PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.DetailsFrame.CategoryText
    WoWTools_ChineseMixin:SetRegions(PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.SetDetailsScrollBoxContainer)
    hooksecurefunc(PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.DetailsFrame, 'Refresh', function(self)
        if not self.data then
            return;
        end

        local itemData= WoWTools_ChineseMixin:Get_Item_Info(self.data.itemID)
        local name= WoWTools_ChineseMixin:SetCN(self.data.name) or (itemData and WoWTools_ChineseMixin:ReplaceText(itemData[1]))
        if name then
            self.ProductNameText:SetText(name)
        end

        local descriptionText
        if self.data.speciesID and self.data.speciesID>0 then
            local petData= WoWTools_ChineseMixin:GetPetDesc(self.data.speciesID)
            if petData then
                descriptionText= petData[1]
            end

        elseif itemData then
            table.remove(itemData, 1)
            for _, desc in pairs(itemData) do
                descriptionText= (descriptionText and descriptionText..'|n' or '')..WoWTools_ChineseMixin:ReplaceText(desc)
            end
        end
        if descriptionText then
            self.DescriptionText:SetText(descriptionText);
        end

        local categoryText = WoWTools_ChineseMixin:GetData(PerksProgramFrame:GetCategoryText(self.data.perksVendorCategoryID))
        if self.data.perksVendorCategoryID == Enum.PerksVendorCategoryType.Mount then
            categoryText = format('%s %s', WoWTools_ChineseMixin:GetData(self.data.mountTypeName), categoryText);
        end
        self.CategoryText:SetText(categoryText);

        if self.TimeRemaining:IsShown() then
            local timeRemainingText;
            if self.data.isFrozen then
                timeRemainingText = format(WHITE_FONT_COLOR:WrapTextInColorCode('剩余时间：%s'), '|cffffffff冻结|r|n');
            elseif self.data.purchased then
                timeRemainingText = CreateAtlasMarkup("perks-owned-small", 18, 18).." "..GRAY_FONT_COLOR:WrapTextInColorCode('你拥有此物品');
            else
                local timeToShow = PerksProgramFrame:FormatTimeLeft(self.data.timeRemaining, PerksProgramFrame.TimeLeftDetailsFormatter);
                local timeTextColor = self.timeTextColor or WHITE_FONT_COLOR;
                local timeValueColor = self.timeValueColor or WHITE_FONT_COLOR;
                timeRemainingText = format(timeTextColor:WrapTextInColorCode('剩余时间：%s'), timeValueColor:WrapTextInColorCode(timeToShow));
            end
            self.TimeRemaining:SetText(timeRemainingText);
        end
    end)






    --PerksProgramSetDetailsItemMixin 
    hooksecurefunc(PerksProgramSetDetailsItemMixin, 'InitItem', function(self, elementData)
        --self.elementData = elementData;
        local itemSlot = elementData.itemSlot;
        local leftText = itemSlot.leftText and WoWTools_ChineseMixin:CN(itemSlot.leftText)
        local rightText = itemSlot.rightText and WoWTools_ChineseMixin:CN(itemSlot.rightText)
        
        if leftText then
            local wrapLeftInColor = itemSlot.leftColor and not itemSlot.leftColor:IsRGBEqualTo(WHITE_FONT_COLOR);
            if wrapLeftInColor then
                leftText = leftColor:WrapTextInColorCode(leftText);
            end
            self.ItemSlotLeft:SetText(leftText);
        end
        if rightText then
            local wrapRightInColor = itemSlot.rightColor and not itemSlot.rightColor:IsRGBEqualTo(WHITE_FONT_COLOR);
            if wrapRightInColor then
                rightText = rightColor:WrapTextInColorCode(rightText);
            end
            self.ItemSlotRight:SetText(rightText)
        end
    end)

    hooksecurefunc(PerksProgramSetDetailsItemMixin, 'Refresh', function(self)
        local name= WoWTools_ChineseMixin:CN(self.elementData.itemName) or WoWTools_ChineseMixin:Get_Item_Name(self.elementData.itemID)
        if name then
            self.ItemName:SetText(name)
        end
    end)
end

--PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.SetDetailsScrollBoxContainer.1d910d3e5b0















local function set_item(self)
    if not self.itemInfo then
        return
    end
    local itemName= WoWTools_ChineseMixin:Get_Item_Name(self.itemInfo.itemID)
    if itemName then
        self.ContentsContainer.Label:SetText(itemName)
    end
end








function WoWTools_ChineseMixin.Events:Blizzard_PerksProgram()
    Init_Blizzard_PerksProgramElements()


    hooksecurefunc(PerksProgramProductButtonMixin, 'SetItemInfo', set_item)
    hooksecurefunc(PerksProgramFrozenProductButtonMixin, 'SetItemInfo', set_item)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.ProductsFrame.ProductsScrollBoxContainer.NameSortButton.Label)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.ProductsFrame.ProductsScrollBoxContainer.PriceSortButton.Label)




    -- Blizzard_PerksProgramFooter.lua
    --PerksProgramFooterFrameMixin
    WoWTools_ChineseMixin:HookLabel(PerksProgramFrame.FooterFrame.PurchaseButton)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.FooterFrame.RefundButton)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.FooterFrame.TogglePlayerPreview.Text)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.FooterFrame.ToggleMountSpecial.Text)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.FooterFrame.ToggleHideArmor.Text)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.FooterFrame.ToggleAttackAnimation.Text)
    WoWTools_ChineseMixin:SetLabelText(PerksProgramFrame.FooterFrame.PurchasedHistoryFrame.PurchasedText)
    PerksProgramFrame.FooterFrame.LeaveButton:HookScript('OnShow', function(frame)
        frame:SetFormattedText('%s 离开', CreateAtlasMarkup("perks-backarrow", 8, 13, 0, 0))
    end)
    hooksecurefunc(PerksProgramFrame.FooterFrame, 'OnProductSelected', function(frame, data)
        if frame.selectedProductInfo.refundable then
            local refundTimeLeft = format('此物品退款剩余时间：%s', PerksProgramFrame:FormatTimeLeft(C_PerksProgram.GetVendorItemInfoRefundTimeLeft(frame.selectedProductInfo.perksVendorItemID), PerksProgramFrame.TimeLeftFooterFormatter))
            frame.PurchasedHistoryFrame.RefundText:SetText(refundTimeLeft);
        end
    end)
end












