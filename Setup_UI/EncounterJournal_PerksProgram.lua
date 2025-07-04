--Blizzard_PerksProgramElements.lua

local function Init_Blizzard_PerksProgramElements()

    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CONFIRM_PURCHASE", {text='用%s%s 交易下列物品？', button1='购买', button2='取消'})

    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CONFIRM_CART_PURCHASE", {text='你确定要使用%s兑换%d件物品吗', button1='购买', button2='取消'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CONFIRM_REFUND", {text= '退还下列物品，获得退款%s%s？', button1 = '退款', button2 = '取消'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_SERVER_ERROR", {text= '商栈与服务器交换数据时出现困难，请稍后再试。', button1 = '确定'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_ITEM_PROCESSING_ERROR", {text= '正在处理一件物品。请稍后再试。。', button1 = '确定'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CONFIRM_OVERRIDE_FROZEN_ITEM", {text= '你确定想替换当前的冻结物品吗？现在的冻结物品有可能已经下架了。', button1 = '确认', button2 = '取消'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_SLOW_PURCHASE", {text= '处理您的本次购买所花费的时间比正常情况更长。购买过程会在后台继续进行。', button1= '回到商栈'})
    WoWTools_ChineseMixin:AddDialogs("PERKS_PROGRAM_CLEAR_CART", {text='你确定要将%d件物品从购物车中移除吗？', button1='移除', button2='取消'})

    --PerksProgramProductDetailsFrameMixin
    --PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.DetailsFrame.CategoryText
    WoWTools_ChineseMixin:SetRegions(PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.SetDetailsScrollBoxContainer)

    hooksecurefunc(PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.DetailsFrame, 'Refresh', function(self)
        if not self.data then
            return;
        end


        local desc, name= WoWTools_ChineseMixin:GetItemDesc(self.data.itemID)
        name= name or WoWTools_ChineseMixin:CN(self.data.name)
        if name then
            self.ProductNameText:SetText(name)
        end

        if self.data.speciesID and self.data.speciesID>0 then
            local petData= WoWTools_ChineseMixin:GetPetDesc(self.data.speciesID)
            if petData and (petData[1] or petData[2]) then
                desc= (petData[1] or '')..(petData[2] and '|n|n'..petData[2] or '')
            end
        end
        if desc then
            self.DescriptionText:SetText(desc);
        end

        local categoryText = PerksProgramFrame:GetCategoryText(self.data.perksVendorCategoryID)
        categoryText= WoWTools_ChineseMixin:CN(categoryText) or categoryText
        if self.data.perksVendorCategoryID == Enum.PerksVendorCategoryType.Mount then
            categoryText = format('%s %s', WoWTools_ChineseMixin:CN(self.data.mountTypeName) or self.data.mountTypeName, categoryText);
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






    --Blizzard_PerksProgramElements.lua
    --PerksProgramSetDetailsItemMixin 
    hooksecurefunc(PerksProgramSetScrollItemDetailsMixin, 'InitItem', function(self, elementData)
        --self.elementData = elementData;
        local itemSlot = elementData.itemSlot;
        local leftText = itemSlot.leftText and WoWTools_ChineseMixin:CN(itemSlot.leftText)
        local rightText = itemSlot.rightText and WoWTools_ChineseMixin:CN(itemSlot.rightText)

        if leftText then
            local wrapLeftInColor = itemSlot.leftColor and not itemSlot.leftColor:IsRGBEqualTo(WHITE_FONT_COLOR);
            if wrapLeftInColor then
                leftText = leftColor:WrapTextInColorCode(leftText);
            end
            self.ItemSlotLeft:SetText(leftText)
        end

        if rightText then
            local wrapRightInColor = itemSlot.rightColor and not itemSlot.rightColor:IsRGBEqualTo(WHITE_FONT_COLOR);
            if wrapRightInColor then
                rightText = rightColor:WrapTextInColorCode(rightText);
            end
            self.ItemSlotRight:SetText(rightText)
        end
    end)

    hooksecurefunc(PerksProgramScrollItemDetailsMixin, 'Refresh', function(self)
        local name= WoWTools_ChineseMixin:CN(self.elementData.itemName) or WoWTools_ChineseMixin:GetItemName(self.elementData.itemID)
        if name then
            self.ItemName:SetText(name)
        end
    end)


    --PerksProgramShoppingCartMixin 
    --Blizzard_PerksProgramElements.lua
    hooksecurefunc(PerksProgramFrame.ProductsFrame.PerksProgramShoppingCartFrame, 'UpdateCart', function(frame, numCartItems)
        frame.Title:SetText(string.format('购物车预览（%d）', numCartItems))
    end)
end

--PerksProgramFrame.ProductsFrame.PerksProgramProductDetailsContainerFrame.SetDetailsScrollBoxContainer.1d910d3e5b0















local function set_item(self)
    local itemName= self.itemInfo and WoWTools_ChineseMixin:GetItemName(self.itemInfo.itemID)
    if itemName then
        self.ContentsContainer.Label:SetText(itemName)
    end
end








function WoWTools_ChineseMixin.Events:Blizzard_PerksProgram()
    Init_Blizzard_PerksProgramElements()

    hooksecurefunc(PerksProgramProductButtonMixin, 'SetItemInfo', set_item)
    hooksecurefunc(PerksProgramFrozenProductButtonMixin, 'SetItemInfo', set_item)

    self:SetLabel(PerksProgramFrame.ProductsFrame.ProductsScrollBoxContainer.NameSortButton.Label)
    self:SetLabel(PerksProgramFrame.ProductsFrame.ProductsScrollBoxContainer.PriceSortButton.Label)
    self:SetLabel(PerksProgramFrame.ProductsFrame.ProductsScrollBoxContainer.PerksProgramHoldFrame.FrozenProductContainer.ProductButton.FrozenContentContainer.InstructionsText)

    -- Blizzard_PerksProgramFooter.lua
    --PerksProgramFooterFrameMixin
    self:HookLabel(PerksProgramFrame.FooterFrame.PurchaseButton)
    self:SetLabel(PerksProgramFrame.FooterFrame.RefundButton)
    self:SetLabel(PerksProgramFrame.FooterFrame.TogglePlayerPreview.Text)
    self:SetLabel(PerksProgramFrame.FooterFrame.ToggleMountSpecial.Text)
    self:SetLabel(PerksProgramFrame.FooterFrame.ToggleHideArmor.Text)
    self:SetLabel(PerksProgramFrame.FooterFrame.ToggleAttackAnimation.Text)
    self:SetLabel(PerksProgramFrame.FooterFrame.PurchasedHistoryFrame.PurchasedText)
    self:SetButton(PerksProgramFrame.FooterFrame.AddToCartButton)
    self:SetButton(PerksProgramFrame.FooterFrame.RemoveFromCartButton)

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



--PerksProgramFrame.ProductsFrame.PerksProgramShoppingCartFrame.ItemList.ScrollBox.ScrollTarget.1b8bb8a8840.BackgroundTexture








