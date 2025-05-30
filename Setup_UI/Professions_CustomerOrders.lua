function WoWTools_ChineseMixin.Events:Blizzard_ProfessionsCustomerOrders()

    hooksecurefunc(ProfessionsCustomerOrdersCategoryButtonMixin, 'Init', function(frame, categoryInfo, _, isRecraftCategory)
        if isRecraftCategory then
            frame:SetText('开始再造订单')
        elseif categoryInfo then
            local text= WoWTools_ChineseMixin:CN(categoryInfo.categoryName)
            if text then
                frame:SetText(text)
            end
        end
    end)
    ProfessionsCustomerOrdersFrameBrowseTab:SetText('发布订单')
    ProfessionsCustomerOrdersFrameOrdersTab:SetText('我的订单')
    --ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.FilterButton:SetText('过滤器')

    ProfessionsCustomerOrdersFrame.BrowseOrders:HookScript('OnEvent', function (frame, event)
        if event == "CRAFTINGORDERS_CUSTOMER_OPTIONS_PARSED" and not C_CraftingOrders.HasFavoriteCustomerOptions() then
            frame.RecipeList.ResultsText:SetText('小窍门：右键点击配方可以设置偏好。偏好的配方会在你打开商盟时立即出现。')
        end
    end)
    hooksecurefunc(ProfessionsCustomerOrdersFrame.BrowseOrders, 'StartSearch', function (frame)
        if frame.RecipeList.ResultsText:IsShown() then
            frame.RecipeList.ResultsText:SetText('未找到配方')
        end
    end)
    ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.SearchButton:SetText('搜索')
    ProfessionsCustomerOrdersFrame.BrowseOrders.SearchBar.FavoritesSearchButton:HookScript("OnEnter", function(frame)
        GameTooltip:SetText('|cffffffff收藏')
        if not C_CraftingOrders.HasFavoriteCustomerOptions() then
            GameTooltip_AddNormalLine(GameTooltip, '你的偏好列表是空的。右键点击订单列表的一个物品可以将其添加到偏好中。')
        end
        GameTooltip:Show()
     end)






    ProfessionsCustomerOrdersFrame.Form.BackButton:SetText('返回' )
    ProfessionsCustomerOrdersFrame.Form.MinimumQuality.Text:SetText('最低品质：')
    ProfessionsCustomerOrdersFrame.Form.ReagentContainer.RecraftInfoText:SetText('再造使你可以改变某些制造装备的附加材料和品质。')
    --ProfessionsCustomerOrdersFrame.Form.AllocateBestQualityCheckBox.Text:SetText('使用最高品质材料')

    ProfessionsCustomerOrdersFrame.Form.OrderRecipientDisplay.Crafter:SetText('制作者：')
    --[[hooksecurefunc(ProfessionsCustomerOrdersFrame.Form, 'SetupDurationDropDown', function(frame)
        frame.PaymentContainer.Duration:SetText('持续时间')
    end)]]

    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.Tip:SetText('佣金')
    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.NoteEditBox.TitleBox.Title:SetText('给制作者的信息：')
    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.NoteEditBox.ScrollingEditBox.defaultText= '在此输入消息'
    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.TimeRemaining:SetText('过期时间')
    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.PostingFee:SetText('发布费')
    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.TotalPrice:SetText('总价')
    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.ListOrderButton:SetText('发布订单')
    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.CancelOrderButton:SetText('取消订单')

    ProfessionsCustomerOrdersFrame.Form.FavoriteButton:HookScript('OnEnter', function (frame)
        local isFavorite = frame:GetChecked()
        if not isFavorite and C_CraftingOrders.GetNumFavoriteCustomerOptions() >= Constants.CraftingOrderConsts.MAX_CRAFTING_ORDER_FAVORITE_RECIPES then
            GameTooltip_AddErrorLine(GameTooltip, '你的偏好列表已满。取消偏好一个配方后才能添加此配方。')
        else
            GameTooltip_AddHighlightLine(GameTooltip, isFavorite and '从偏好中移除' or '设置为偏好')
        end
        GameTooltip:Show()
    end)
    ProfessionsCustomerOrdersFrame.Form.RecraftSlot.InputSlot:HookScript('OnEnter', function()
        local frame= ProfessionsCustomerOrdersFrame.Form
        local itemGUID = ProfessionsCustomerOrdersFrame.Form.transaction and frame.transaction:GetRecraftAllocation()
        if itemGUID then
            if not frame.committed then
                GameTooltip_AddInstructionLine(GameTooltip, '|cnDISABLED_FONT_COLOR:左键点击替换此装备|r')
                GameTooltip:Show()
            end
        elseif not frame.order.recraftItemHyperlink then
            GameTooltip_AddInstructionLine(GameTooltip, '左键点击选择一件可用的装备来再造')
            GameTooltip:Show()
        end
    end)


    hooksecurefunc(ProfessionsCustomerOrdersFrame.Form, 'UpdateListOrderButton', function(frame)
        if frame.committed or frame.pendingOrderPlacement then
            return
        end
        local errorText
        if frame.order.isRecraft and not frame.order.skillLineAbilityID then
            errorText = '你必须选择一个此订单要再造的物品'
        elseif frame.order.isRecraft and frame:GetPendingRecraftItemQuality() == #frame.minQualityIDs and not frame:AnyModifyingReagentsChanged() then
            errorText = '"你不能在不改变任何附加材料的情况下发布最高品质的物品的再造订单。'
        elseif not frame:AreRequiredReagentsProvided() then
            errorText = '你没有发布此订单所需的材料。'
        elseif not frame.transaction:HasMetPrerequisiteRequirements() then
            errorText = '一种或多种附加材料不满足必要条件。'
        elseif frame.order.orderType == Enum.CraftingOrderType.Personal and frame.OrderRecipientTarget:GetText() == "" then
            errorText = '你必须指定收件人才能发布个人订单。'
        elseif frame.PaymentContainer.TipMoneyInputFrame:GetAmount() <= 0 then
            errorText = '你必须提供佣金。'
        elseif frame.PaymentContainer.TotalPriceMoneyDisplayFrame:GetAmount() > GetMoney() then
            errorText = '金币不足，无法购买建筑。'
        end
        if errorText then
            local listOrderButton = frame.PaymentContainer.ListOrderButton
            listOrderButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(listOrderButton, "ANCHOR_RIGHT")
                GameTooltip_AddErrorLine(GameTooltip, errorText)
                GameTooltip:Show()
            end)
        end
    end)

    ProfessionsCustomerOrdersFrame.Form:HookScript('OnEvent', function(frame, event, ...)
        if event == "CRAFTINGORDERS_ORDER_PLACEMENT_RESPONSE" or event == "CRAFTINGORDERS_ORDER_CANCEL_RESPONSE" then
            local result = ...
            local success = (result == Enum.CraftingOrderResult.Ok)
            if not success then
                local errorText
                if event == "CRAFTINGORDERS_ORDER_PLACEMENT_RESPONSE" then
                    if result == Enum.CraftingOrderResult.InvalidTarget then
                        errorText = '该玩家不存在。'
                    elseif result == Enum.CraftingOrderResult.TargetCannotCraft then
                        errorText = '该玩家没有所需的专业来制作此订单。'
                    elseif result == Enum.CraftingOrderResult.MaxOrdersReached then
                        errorText = '订单数量已达上限。'
                    else
                        errorText = '制造订单生成失败。请稍后重试。'
                    end
                elseif event == "CRAFTINGORDERS_ORDER_CANCEL_RESPONSE" then
                    errorText = (result == Enum.CraftingOrderResult.AlreadyClaimed) and '取消订单失败。订单被认领后就无法再取消。' or '取消订单失败。请稍后再试。'
                end
                UIErrorsFrame:AddExternalErrorMessage(errorText)
            end
        end
    end)

    ProfessionsCustomerOrdersFrame.Form.PaymentContainer.ViewListingsButton:SetScript("OnEnter", function(frame)
        GameTooltip_AddHighlightLine(GameTooltip, '查看类似的订单。')
        GameTooltip:Show()
     end)

    --ProfessionsCustomerOrdersFrame.Form.TrackRecipeCheckBox.Text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('追踪配方'))

    --[[ProfessionsCustomerOrdersFrame.Form.AllocateBestQualityCheckBox:HookScript("OnEnter", function(button)
        local checked = button:GetChecked()
        if checked then
            GameTooltip_AddNormalLine(GameTooltip, '取消勾选后，总会使用可用的最低品质的材料。')
        else
            GameTooltip_AddNormalLine(GameTooltip, '勾选后，总会使用可用的最高品质的材料。')
        end
        GameTooltip:Show()
    end)]]


    hooksecurefunc(ProfessionsCustomerOrdersFrame.Form, 'InitSchematic', function(frame)
        local professionName = C_TradeSkillUI.GetProfessionNameForSkillLineAbility(frame.order.skillLineAbilityID)
        frame.ProfessionText:SetFormattedText('%s 配方', WoWTools_ChineseMixin:CN(professionName) or professionName)
    end)

    hooksecurefunc(ProfessionsCustomerOrdersFrame.Form, 'Init', function(frame, order)
        if not frame.committed then
            frame.ReagentContainer.Reagents.Label:SetText('提供材料：')
            frame.ReagentContainer.OptionalReagents.Label:SetText('提供附加材料：')
        else
            if frame.order.orderState ~= Enum.CraftingOrderState.Created then
                local remainingTime = Professions.GetCraftingOrderRemainingTime(order.expirationTime)
                local seconds = remainingTime >= 60 and remainingTime or 60 -- Never show < 1min
                local timeRemainingText = Professions.OrderTimeLeftFormatter:Format(seconds)
                timeRemainingText = format('%s （等待中）', timeRemainingText)
                WoWTools_ChineseMixin:SetLabel(frame.PaymentContainer.TimeRemainingDisplay.Text, timeRemainingText)
            end

            if not order.crafterName then
                local crafterText
                if frame.order.orderState == Enum.CraftingOrderState.Created then
                    crafterText = '尚未被认领'
                else
                    crafterText = '未领取'
                end
                WoWTools_ChineseMixin:SetLabel(frame.OrderRecipientDisplay.CrafterValue, crafterText)
            end

            local orderTypeText
            if frame.order.orderType == Enum.CraftingOrderType.Public then
                orderTypeText = '公开订单'
            elseif frame.order.orderType == Enum.CraftingOrderType.Guild then
                orderTypeText = '公会订单'
            elseif frame.order.orderType == Enum.CraftingOrderType.Personal then
                orderTypeText = '个人订单'
            end
            WoWTools_ChineseMixin:SetLabel(frame.OrderRecipientDisplay.PostedTo, orderTypeText)

            local orderStateText
            if frame.order.orderState == Enum.CraftingOrderState.Created then
                orderStateText = '未领取'
            elseif frame.order.orderState == Enum.CraftingOrderState.Expired then
                orderStateText = '订单过期'
            elseif frame.order.orderState == Enum.CraftingOrderState.Canceled then
                orderStateText = '订单取消'
            elseif frame.order.orderState == Enum.CraftingOrderState.Rejected then
                orderStateText = '订单被拒绝'
            elseif frame.order.orderState == Enum.CraftingOrderState.Claimed then
                orderStateText = '订单正在进行中'
            else
                orderStateText = '|cnGREEN_FONT_COLOR:订单完成！|r'
            end
            WoWTools_ChineseMixin:SetLabel(frame.OrderStateText, orderStateText)

            frame.ReagentContainer.Reagents.Label:SetText('提供的材料：')
            frame.ReagentContainer.OptionalReagents.Label:SetText('提供的附加材料：')
        end
    end)


    hooksecurefunc(ProfessionsCustomerOrdersFrame.Form, 'DisplayCurrentListings', function(frame)
        local orders = C_CraftingOrders.GetCustomerOrders()
        if #orders == 0 then
            frame.CurrentListings.OrderList.ResultsText:SetText('没有发现订单')
        end
    end)
    ProfessionsCustomerOrdersFrame.Form.CurrentListings:SetTitle('当前列表')
    ProfessionsCustomerOrdersFrame.Form.CurrentListings.CloseButton:SetText('关闭')


    hooksecurefunc(ProfessionsCustomerOrdersFrame, 'SelectMode', function(frame, mode)
        if mode== ProfessionsCustomerOrdersMode.Browse then
            frame:SetTitle('发布制造订单')
        elseif mode== ProfessionsCustomerOrdersMode.Orders then
            frame:SetTitle('我的订单')
        end
    end)
    ProfessionsCustomerOrdersFrame.MyOrdersPage.OrderList.ResultsText:SetText('没有发现订单')

    --商品，目录
    hooksecurefunc(ProfessionsCustomerOrdersFrame.BrowseOrders.RecipeList.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            if btn.cells and btn.cells[1] then
                local data= btn:GetData()
                local option= data and data.option
                if  option then
                    local name= WoWTools_ChineseMixin:GetItemName(option.itemID) or WoWTools_ChineseMixin:CN(option.itemName)
                    if name then
                        local hex= option.quality and select(4, C_Item.GetItemQualityColor(option.quality))
                        if hex then
                            name= '|c'..hex..name..'|r'
                        end
                        btn.cells[1].Text:SetText(name)
                    end
                end
            end
        end
    end)
end