local id, e = ...









--专业，技能点 ProfessionsRankBarMixin
local function GenerateRankText(professionName, skillLevel, maxSkillLevel, skillModifier)
    local rankText;
    if skillModifier > 0  then
        rankText = format('%s %d (|cff20ff20+%d|r ) /%d', professionName, skillLevel, skillModifier, maxSkillLevel);
    else
        rankText = format('%s %d/%d', professionName, skillLevel, maxSkillLevel);
    end
    if GameLimitedMode_IsActive() then
        local professionCap = select(3, GetRestrictedAccountData());
        if skillLevel >= professionCap and professionCap > 0 then
            return format("%s %s%s|r", rankText, RED_FONT_COLOR_CODE, '已达免费试玩上限。');
        end
    end
    return rankText;
end













local function Init()    
    hooksecurefunc(ProfessionsFrame, 'SetTitle', function(self, skillLineName)
        if e.strText[skillLineName] then
            skillLineName= e.strText[skillLineName]
            if C_TradeSkillUI.IsTradeSkillGuild() then
                self:SetTitleFormatted('公会%s"', skillLineName)
            else
                local linked, linkedName = C_TradeSkillUI.IsTradeSkillLinked()
                if linked and linkedName then
                    self:SetTitleFormatted("%s %s[%s]|r", TRADE_SKILL_TITLE:format(skillLineName), HIGHLIGHT_FONT_COLOR_CODE, linkedName)
                else
                    self:SetTitleFormatted(TRADE_SKILL_TITLE, skillLineName)
                end
            end
        elseif C_TradeSkillUI.IsTradeSkillGuild() then
            self:SetTitleFormatted('公会%s"', skillLineName)
        end
    end)

    hooksecurefunc(ProfessionsFrame, 'UpdateTabs', function(self)
        local recipesTab = self:GetTabButton(self.recipesTabID)
        e.font(recipesTab.Text)
        recipesTab.Text:SetText('配方')

        recipesTab = self:GetTabButton(self.specializationsTabID)
        e.font(recipesTab.Text)
        recipesTab.Text:SetText('专精')

        recipesTab = self:GetTabButton(self.craftingOrdersTabID )
        e.font(recipesTab.Text)
        recipesTab.Text:SetText('制造订单')
    end)

    ProfessionsFrame.CraftingPage.RecipeList.SearchBox.Instructions:SetText('搜索')
    --ProfessionsFrame.CraftingPage.RecipeList.FilterDropdown.Text:SetText('过滤器')
    ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.SearchBox.Instructions:SetText('搜索')
    --ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.FilterButton:SetText('过滤器')

    --Blizzard_ProfessionsCrafting.lua
    ProfessionsFrame.CraftingPage.ViewGuildCraftersButton:SetText('查看工匠')

    local FailValidationReason = EnumUtil.MakeEnum("Cooldown", "InsufficientReagents", "PrerequisiteReagents", "Disabled", "Requirement", "LockedReagentSlot", "RecraftOptionalReagentLimit")
    local FailValidationTooltips = {
        [FailValidationReason.Cooldown] = '配方冷却中。',
        [FailValidationReason.InsufficientReagents] = '你的材料不足。',
        [FailValidationReason.PrerequisiteReagents] = '一种或多种附加材料不满足必要条件。',
        [FailValidationReason.Requirement] = '你不满足一个或更多的条件，不能制作此配方。',
        [FailValidationReason.LockedReagentSlot] = '你尚未解锁必需的附加材料栏位。',
        [FailValidationReason.RecraftOptionalReagentLimit] = '你尝试再造的物品有装备唯一限制。需要先脱下该装备后进行再造。',
    }
    hooksecurefunc(ProfessionsFrame.CraftingPage, 'ValidateControls', function(self)
        local currentRecipeInfo = self.SchematicForm:GetRecipeInfo()
        local isRuneforging = C_TradeSkillUI.IsRuneforging()
        if currentRecipeInfo ~= nil and currentRecipeInfo.learned and (Professions.InLocalCraftingMode() or C_TradeSkillUI.IsNPCCrafting() or isRuneforging)
            and not currentRecipeInfo.isRecraft
            and not currentRecipeInfo.isDummyRecipe and not currentRecipeInfo.isGatheringRecipe
        then
            local transaction = self.SchematicForm:GetTransaction()
            local isEnchant = transaction:IsRecipeType(Enum.TradeskillRecipeType.Enchant)
            local countMax = self:GetCraftableCount()
            if isEnchant then
                self.CreateButton:SetTextToFit('附魔')
                local quantity = math.max(1, countMax)
                self.CreateAllButton:SetTextToFit(format('"%s [%d]', '附魔所有', quantity))
            elseif not currentRecipeInfo.abilityVerb and not currentRecipeInfo.alternateVerb then
                if self.SchematicForm.recraftSlot and self.SchematicForm.recraftSlot.InputSlot:IsVisible() then
                    self.CreateButton:SetTextToFit('再造')
                else
                    self.CreateButton:SetTextToFit('制造')
                end
                if not currentRecipeInfo.abilityAllVerb then
                    self.CreateAllButton:SetTextToFit(format('%s [%d]', '全部制造', countMax))
                end
            end
            local enabled = true
            if PartialPlayTime() then
                local reasonText = format('你的在线时间已经超过3小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏下线休息。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                self:SetCreateButtonTooltipText(reasonText)
                enabled = false
            elseif NoPlayTime() then
                local reasonText = format('你的在线时间已经超过5小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏，下线休息和运动。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                self:SetCreateButtonTooltipText(reasonText)
                enabled = false
            end
            if enabled then
                local failValidationReason = self:ValidateCraftRequirements(currentRecipeInfo, transaction, isRuneforging, countMax)
                if failValidationReason and FailValidationTooltips[failValidationReason] then
                    self:SetCreateButtonTooltipText(FailValidationTooltips[failValidationReason])
                end
            end
        end
    end)


    ProfessionsFrame.CraftingPage.SchematicForm.QualityDialog.AcceptButton:SetText('接受')
    ProfessionsFrame.CraftingPage.SchematicForm.QualityDialog.CancelButton:SetText('取消')
    ProfessionsFrame.CraftingPage.SchematicForm.QualityDialog:SetTitle('材料品质')

    --ProfessionsFrame.CraftingPage.SchematicForm.AllocateBestQualityCheckBox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('使用最高品质材料'))
    --[[ProfessionsFrame.CraftingPage.SchematicForm.AllocateBestQualityCheckBox:HookScript("OnEnter", function(button)--Blizzard_ProfessionsRecipeSchematicForm.lua
        local checked = button:GetChecked()
        if checked then
            GameTooltip_AddNormalLine(GameTooltip, '取消勾选后，总会使用可用的最低品质的材料。')
        else
            GameTooltip_AddNormalLine(GameTooltip, '勾选后，总会使用可用的最高品质的材料。')
        end
        GameTooltip:Show()
    end)]]
    --ProfessionsFrame.CraftingPage.SchematicForm.TrackRecipeCheckBox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('追踪配方'))
    ProfessionsFrame.CraftingPage.SchematicForm.FavoriteButton:HookScript("OnEnter", function(button)
        GameTooltip_AddHighlightLine(GameTooltip, button:GetChecked() and '从偏好中移除' or '设置为偏好')
        GameTooltip:Show()
    end)
    ProfessionsFrame.CraftingPage.SchematicForm.FavoriteButton:HookScript("OnClick", function(button)
        GameTooltip_AddHighlightLine(GameTooltip, button:GetChecked() and '从偏好中移除' or '设置为偏好')
        GameTooltip:Show()
    end)
    ProfessionsFrame.CraftingPage.SchematicForm.FirstCraftBonus:SetScript("OnEnter", function()
        GameTooltip_AddNormalLine(GameTooltip, '首次制造此配方会教会你某种新东西。')
        GameTooltip:Show()
    end)

    hooksecurefunc(ProfessionsFrame.CraftingPage, 'Init', function(self)--Blizzard_ProfessionsCrafting.lua
        local minimized = ProfessionsUtil.IsCraftingMinimized()
        if minimized and self.MinimizedSearchBox:IsCurrentTextValidForSearch() then
            self.MinimizedSearchResults:GetTitleText():SetFormattedText('搜索结果\"%s\"(%d)', self.MinimizedSearchBox:GetText(), self.searchDataProvider:GetSize())
        end
    end)

    hooksecurefunc(ProfessionsFrame.CraftingPage, 'ValidateControls', function(self)--Blizzard_ProfessionsCrafting.lua
        local currentRecipeInfo = self.SchematicForm:GetRecipeInfo()
        local isRuneforging = C_TradeSkillUI.IsRuneforging()
        if currentRecipeInfo ~= nil and currentRecipeInfo.learned and (Professions.InLocalCraftingMode() or C_TradeSkillUI.IsNPCCrafting() or isRuneforging)
            and not currentRecipeInfo.isRecraft
            and not currentRecipeInfo.isDummyRecipe and not currentRecipeInfo.isGatheringRecipe then

            local transaction = self.SchematicForm:GetTransaction()
            local isEnchant = transaction:IsRecipeType(Enum.TradeskillRecipeType.Enchant)

            local countMax = self:GetCraftableCount()

            if isEnchant then
                self.CreateButton:SetTextToFit('附魔')
                local quantity = math.max(1, countMax)
                self.CreateAllButton:SetTextToFit(format('%s [%d]', '附魔所有', quantity))
            else
                if currentRecipeInfo.abilityVerb then
                    -- abilityVerb is recipe-level override
                    --self.CreateButton:SetTextToFit(currentRecipeInfo.abilityVerb)
                elseif currentRecipeInfo.alternateVerb then
                    -- alternateVerb is profession-level override
                    --self.CreateButton:SetTextToFit(currentRecipeInfo.alternateVerb)
                elseif self.SchematicForm.recraftSlot and self.SchematicForm.recraftSlot.InputSlot:IsVisible() then
                    self.CreateButton:SetTextToFit('再造')
                else
                    self.CreateButton:SetTextToFit('制造')
                end

                local createAllFormat
                if currentRecipeInfo.abilityAllVerb then
                    -- abilityAllVerb is recipe-level override
                    createAllFormat = currentRecipeInfo.abilityAllVerb
                else
                    createAllFormat = '全部制造'
                end
                self.CreateAllButton:SetTextToFit(format('%s [%d]', createAllFormat, countMax))
            end

            local enabled = true
            if PartialPlayTime() then
                local reasonText = format('你的在线时间已经超过3小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏下线休息。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                self:SetCreateButtonTooltipText(reasonText)
                enabled = false
            elseif NoPlayTime() then
                local reasonText = format('你的在线时间已经超过5小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏，下线休息和运动。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                self:SetCreateButtonTooltipText(reasonText)
                enabled = false
            end

            if enabled then
                local failValidationReason = self:ValidateCraftRequirements(currentRecipeInfo, transaction, isRuneforging, countMax)
                self:SetCreateButtonTooltipText(FailValidationTooltips[failValidationReason])
            end

        end
    end)

    ProfessionsFrame.SpecPage.ApplyButton:SetText('应用改动')
    ProfessionsFrame.SpecPage.UnlockTabButton:SetText('解锁专精')
    ProfessionsFrame.SpecPage.ViewTreeButton:SetText('解锁专精')
    ProfessionsFrame.SpecPage.BackToPreviewButton:SetText('后退')
    ProfessionsFrame.SpecPage.ViewPreviewButton:SetText('综述')
    ProfessionsFrame.SpecPage.BackToFullTreeButton:SetText('后退')
    ProfessionsFrame.SpecPage.UndoButton.tooltipText= '取消待定改动'
    ProfessionsFrame.SpecPage.DetailedView.SpendPointsButton:SetText('运用知识')
    ProfessionsFrame.SpecPage.DetailedView.UnlockPathButton:SetText('学习副专精')
    ProfessionsFrame.SpecPage.TreePreview.HighlightsHeader:SetText('专精特色：')

    ProfessionsFrame.SpecPage.DetailedView.SpendPointsButton:HookScript("OnEnter", function()
        local self= ProfessionsFrame.SpecPage
        local spendCurrency = C_ProfSpecs.GetSpendCurrencyForPath(self:GetDetailedPanelNodeID())
        if spendCurrency ~= nil then
            local currencyTypesID = self:GetSpendCurrencyTypesID()
            if currencyTypesID then
                local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyTypesID)
                if self.treeCurrencyInfoMap[spendCurrency] ~= nil and self.treeCurrencyInfoMap[spendCurrency].quantity == 0 then
                    GameTooltip:SetText(format('|cnRED_FONT_COLOR:你没有可以消耗的|r|n|cffffffff%s|r|r', currencyInfo.name), nil, nil, nil, nil, true)
                    GameTooltip:Show()
                end
            end
        end
    end)
    hooksecurefunc(ProfessionsFrame.SpecPage, 'ConfigureButtons', function(self)
        self.DetailedView.SpendPointsButton:SetScript("OnEnter", function()
            local spendCurrency = C_ProfSpecs.GetSpendCurrencyForPath(self:GetDetailedPanelNodeID())
            if spendCurrency ~= nil then
                local currencyTypesID = self:GetSpendCurrencyTypesID()
                if currencyTypesID then
                    local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyTypesID)
                    if self.treeCurrencyInfoMap[spendCurrency] ~= nil and self.treeCurrencyInfoMap[spendCurrency].quantity == 0 then
                        GameTooltip:SetOwner(self.DetailedView.SpendPointsButton, "ANCHOR_RIGHT", 0, 0)
                        GameTooltip_AddErrorLine(GameTooltip, format('你没有可以消耗的%s。', currencyInfo.name))

                        GameTooltip:Show()
                    end
                end
            end
        end)
    end)


    ProfessionsFrame.OrdersPage.BrowseFrame.SearchButton:SetText('搜索')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.BackButton:SetText('返回')

    ProfessionsFrame.OrdersPage.BrowseFrame.PublicOrdersButton.Text:SetText('公开')
    e.font(ProfessionsFrame.OrdersPage.BrowseFrame.PublicOrdersButton.Text)
    ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton.Text:SetText('个人')
    e.font(ProfessionsFrame.OrdersPage.BrowseFrame.PersonalOrdersButton.Text)
    ProfessionsFrame.OrdersPage.BrowseFrame.OrdersRemainingDisplay:HookScript('OnEnter', function()
        local claimInfo = C_CraftingOrders.GetOrderClaimInfo(ProfessionsFrame.OrdersPage.professionInfo.profession)
        local tooltipText
        if claimInfo.secondsToRecharge then
            tooltipText = format('你目前还能完成|cnGREEN_FONT_COLOR:%d|r份公开订单。|cnGREEN_FONT_COLOR:%s|r后才有更多可用的订单。', claimInfo.claimsRemaining, SecondsToTime(claimInfo.secondsToRecharge))
        else
            tooltipText = format('你目前还能完成|cnGREEN_FONT_COLOR:%d|r份公开订单。', claimInfo.claimsRemaining)
        end
        GameTooltip_AddNormalLine(GameTooltip, tooltipText)
        GameTooltip:Show()
    end)

    local orderTypeTabTitles ={
        [Enum.CraftingOrderType.Public] = '公开',
        [Enum.CraftingOrderType.Guild] = '公会',
        [Enum.CraftingOrderType.Personal] = '个人',}
    local function SetTabTitleWithCount(tabButton, type, count)
        local title = orderTypeTabTitles[type]
        if tabButton and e.strText[title] then
            if type == Enum.CraftingOrderType.Public then
                e.set(tabButton.Text, title)
            else
                tabButton.Text:SetFormattedText("%s (%s)", title, count)
            end
        end
    end
    hooksecurefunc(ProfessionsFrame.OrdersPage, 'InitOrderTypeTabs', function(self)
        for _, typeTab in ipairs(self.BrowseFrame.orderTypeTabs) do
            SetTabTitleWithCount(typeTab, typeTab.orderType, 0)
        end
    end)
    ProfessionsFrame.OrdersPage:HookScript('OnEvent', function(self, event, ...)
        if event == "CRAFTINGORDERS_UPDATE_ORDER_COUNT" then
            local type, count = ...
            local tabButton
            if type == Enum.CraftingOrderType.Guild then
                tabButton = self.BrowseFrame.GuildOrdersButton
            elseif type == Enum.CraftingOrderType.Personal then
                tabButton = self.BrowseFrame.PersonalOrdersButton
            end
            SetTabTitleWithCount(tabButton, type, count)
        elseif event == "CRAFTINGORDERS_REJECT_ORDER_RESPONSE" then
            local result = ...
            local success = (result == Enum.CraftingOrderResult.Ok)
            if not success then
                UIErrorsFrame:AddExternalErrorMessage('拒绝订单失败。请稍后再试。')
            end
        end
    end)

    hooksecurefunc(ProfessionsFrame.OrdersPage, 'StartDefaultSearch', function(self)
        if self.BrowseFrame.OrderList.ResultsText:IsShown() then
            self.BrowseFrame.OrderList.ResultsText:SetText('小窍门：右键点击配方可以设置偏好。偏好的配方会在你打开你的公开订单时立即出现。')
        end
    end)
    hooksecurefunc(ProfessionsFrame.OrdersPage, 'UpdateOrdersRemaining', function(self)
        if self.professionInfo then
            local isPublic = self.orderType == Enum.CraftingOrderType.Public
            if isPublic and self.professionInfo and self.professionInfo.profession then
                e.set(self.BrowseFrame.OrdersRemainingDisplay.OrdersRemaining, format('剩余订单：%s', C_CraftingOrders.GetOrderClaimInfo(self.professionInfo.profession).claimsRemaining))
            end
        end
    end)
    hooksecurefunc(ProfessionsFrame.OrdersPage, 'ShowGeneric', function(self)
        if self.BrowseFrame.OrderList.ResultsText:IsShown() then
            self.BrowseFrame.OrderList.ResultsText:SetText('没有发现订单')
        end
    end)

    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.PostedByTitle:SetText('订单发布人：')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.CommissionTitle:SetText('佣金：')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.ConsortiumCutTitle:SetText('财团分成：')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.FinalTipTitle:SetText('你的分成：')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.TimeRemainingTitle:SetText('剩余时间：')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.NoteBox.NoteTitle:SetText('给制作者的信息：')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.StartOrderButton:SetText('开始接单')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.DeclineOrderButton:SetText('拒绝订单')
    ProfessionsFrame.OrdersPage.OrderView.OrderInfo.ReleaseOrderButton:SetText('取消订单')

    ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.OptionalReagents.Label:SetText('附加材料：')
    ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.OptionalReagents.labelText= '附加材料：'--Blizzard_ProfessionsRecipeSchematicForm.xml
    --[[ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.AllocateBestQualityCheckBox:HookScript("OnEnter", function(button)
        local checked = button:GetChecked()
        if checked then
            GameTooltip:SetText('取消勾选后，总会使用可用的最低品质的材料。')
        else
            GameTooltip:SetText('勾选后，总会使用可用的最高品质的材料。')
        end
        GameTooltip:Show()
    end)]]


    hooksecurefunc(ProfessionsFrame.OrdersPage.OrderView, 'UpdateStartOrderButton', function(self)--Blizzard_ProfessionsCrafterOrderView.lua
        local errorReason
        local recipeInfo = C_TradeSkillUI.GetRecipeInfo(self.order.spellID)
        local profession = C_TradeSkillUI.GetChildProfessionInfo().profession
        local claimInfo = profession and C_CraftingOrders.GetOrderClaimInfo(profession)
        if self.order.customerGuid == UnitGUID("player") then
            errorReason = '你不能认领你自己的订单。'
        elseif claimInfo and self.order.orderType == Enum.CraftingOrderType.Public and claimInfo.claimsRemaining <= 0 and Professions.GetCraftingOrderRemainingTime(self.order.expirationTime) > Constants.ProfessionConsts.PUBLIC_CRAFTING_ORDER_STALE_THRESHOLD then
            errorReason = format('你目前无法认领更多的公开订单。%s后才有更多可用的订单。', SecondsToTime(claimInfo.secondsToRecharge))
        elseif not recipeInfo or not recipeInfo.learned or (self.order.isRecraft and not C_CraftingOrders.OrderCanBeRecrafted(self.order.orderID)) then
            errorReason = '你还没有学会此配方。'
        elseif not self.hasOptionalReagentSlots then
            errorReason = '你尚未解锁完成此订单所需的附加材料栏位。'
        end

        if errorReason then
            self.OrderInfo.StartOrderButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(self.OrderInfo.StartOrderButton, "ANCHOR_RIGHT")
                GameTooltip_AddErrorLine(GameTooltip, errorReason)
                GameTooltip:Show()
            end)
        else
            self.OrderInfo.StartOrderButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(self.OrderInfo.StartOrderButton, "ANCHOR_RIGHT")
                GameTooltip_AddHighlightLine(GameTooltip, '此订单开始后，你有30分钟的时间来完成此订单。')
                GameTooltip:Show()
            end)
        end
    end)


    ProfessionsFrame.OrdersPage.OrderView.OrderDetails.FulfillmentForm.NoteEditBox.ScrollingEditBox.defaultText= '在此输入消息'

    ProfessionsFrame.OrdersPage.OrderView.CompleteOrderButton:SetText('完成订单')
    ProfessionsFrame.OrdersPage.OrderView.StartRecraftButton:SetText('再造')
    ProfessionsFrame.OrdersPage.OrderView.StopRecraftButton:SetText('取消再造')
    ProfessionsFrame.OrdersPage.OrderView.DeclineOrderDialog.ConfirmationText:SetText('你确定想拒绝此订单吗？')
    ProfessionsFrame.OrdersPage.OrderView.DeclineOrderDialog.NoteEditBox.TitleBox.Title:SetText('拒绝原因：')
    ProfessionsFrame.OrdersPage.OrderView.DeclineOrderDialog.CancelButton:SetText('否')
    ProfessionsFrame.OrdersPage.OrderView.DeclineOrderDialog.ConfirmButton:SetText('是')

    --ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.AllocateBestQualityCheckBox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('使用最高品质材料'))



    hooksecurefunc(ProfessionsFrame.OrdersPage.OrderView, 'InitRegions', function(self)
        self.OrderDetails.FulfillmentForm.OrderCompleteText:SetText('订单完成！')
        self.DeclineOrderDialog:SetTitle('拒绝订单')
    end)

    ProfessionsFrame.OrdersPage.OrderView:HookScript('OnEvent', function(self, event, ...)
        if event == "CRAFTINGORDERS_CLAIM_ORDER_RESPONSE" then
            local result, orderID = ...
            if orderID == self.order.orderID then
                local success = result == Enum.CraftingOrderResult.Ok
                if not success then
                    if result == Enum.CraftingOrderResult.CannotClaimOwnOrder then
                        UIErrorsFrame:AddExternalErrorMessage('你不能认领你自己的制造订单。')
                    elseif result == Enum.CraftingOrderResult.OutOfPublicOrderCapacity then
                        UIErrorsFrame:AddExternalErrorMessage('你没有剩余的每日公开订单，现在只能完成即将过期的订单。')
                    else
                        UIErrorsFrame:AddExternalErrorMessage('此订单已不可用。')
                    end
                end
            end
        elseif event == "CRAFTINGORDERS_RELEASE_ORDER_RESPONSE" or event == "CRAFTINGORDERS_REJECT_ORDER_RESPONSE" then
            local result, orderID = ...
            if orderID == self.order.orderID then
                local success = result == Enum.CraftingOrderResult.Ok
                if not success then
                    UIErrorsFrame:AddExternalErrorMessage('制造订单运行失败。请稍后重试。')
                end
            end
        elseif event == "CRAFTINGORDERS_FULFILL_ORDER_RESPONSE" then
            local result, orderID = ...
            if orderID == self.order.orderID then
                local success = result == Enum.CraftingOrderResult.Ok
                if not success then
                    UIErrorsFrame:AddExternalErrorMessage('制造订单运行失败。请稍后重试。')
                end
            end
        elseif event == "CRAFTINGORDERS_UNEXPECTED_ERROR" then
            UIErrorsFrame:AddExternalErrorMessage('制造订单运行失败。请稍后重试。')
        end
    end)

    hooksecurefunc(ProfessionsFrame.OrdersPage.OrderView, 'UpdateCreateButton', function(self)
        local transaction = self.OrderDetails.SchematicForm.transaction
        local recipeInfo = C_TradeSkillUI.GetRecipeInfo(self.order.spellID)
        if transaction:IsRecipeType(Enum.TradeskillRecipeType.Enchant) then
            self.CreateButton:SetText('附魔')
        else
            if recipeInfo and recipeInfo.abilityVerb then
                --self.CreateButton:SetText(recipeInfo.abilityVerb)
            elseif recipeInfo and recipeInfo.alternateVerb then
                -- alternateVerb is profession-level override
                --self.CreateButton:SetText(recipeInfo.alternateVerb)
            elseif self:IsRecrafting() then
                self.CreateButton:SetText('再造')
            else
                self.CreateButton:SetText('制造')
            end
        end


        local errorReason
        if Professions.IsRecipeOnCooldown(self.order.spellID) then
            errorReason = '配方冷却中。'
        elseif not transaction:HasMetAllRequirements() then
            errorReason = '你的材料不足。'
        elseif self.order.minQuality and self.OrderDetails.SchematicForm.Details:GetProjectedQuality() and self.order.minQuality > self.OrderDetails.SchematicForm.Details:GetProjectedQuality() then
            local smallIcon = true
            errorReason = format('此订单要求的最低品质是%s', Professions.GetChatIconMarkupForQuality(self.order.minQuality, smallIcon))
        end
        if not errorReason then
            self.CreateButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(self.CreateButton, "ANCHOR_RIGHT")
                GameTooltip_AddErrorLine(GameTooltip, errorReason)
                GameTooltip:Show()
            end)
        end
    end)


    hooksecurefunc(ProfessionsFrame.OrdersPage.OrderView, 'SetOrder', function(self)
        local warningText
        if self.order.reagentState == Enum.CraftingOrderReagentsType.All then
            warningText = '所有材料都由顾客提供。'
        elseif self.order.reagentState == Enum.CraftingOrderReagentsType.Some then
            warningText = '将由你来提供某些材料。'
        elseif self.order.reagentState == Enum.CraftingOrderReagentsType.None then
            warningText = '将由你来提供全部材料。'
        end
        if warningText then
            self.OrderInfo.OrderReagentsWarning.Text:SetText(warningText)
        end
    end)



    ProfessionsFrame.CraftingPage.CraftingOutputLog:SetTitle('制作成果')

    --ProfessionsFrame.CraftingPage.SchematicForm.Details.FinishingReagentSlotContainer.Label:SetText('成品材料：')
    --ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.Details.FinishingReagentSlotContainer.Label:SetText('成品材料：')
    ProfessionsFrame.CraftingPage.SchematicForm.Details:HookScript('OnShow', function(self)
        self.Label:SetText('制作详情')
        self.StatLines.DifficultyStatLine.LeftLabel:SetText('配方难度：')
        self.StatLines.SkillStatLine.LeftLabel:SetText('技能：')
    end)

    ProfessionsFrame.OrdersPage.OrderView.OrderDetails.SchematicForm.Details:HookScript('OnShow', function(self)
        self.Label:SetText('制作详情')
        self.StatLines.DifficultyStatLine.LeftLabel:SetText('配方难度：')
        self.StatLines.SkillStatLine.LeftLabel:SetText('技能：')
    end)




    --set(ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.DifficultyStatLine.LeftLabel, '配方难度：')
    --set(ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.SkillStatLine.LeftLabel, '技能：')

    hooksecurefunc(ProfessionsCrafterDetailsStatLineMixin, 'SetLabel', function(self, label)--Blizzard_ProfessionsRecipeCrafterDetails.lua
        if label== PROFESSIONS_CRAFTING_STAT_TT_CRIT_HEADER then
            self.LeftLabel:SetText('灵感')
        elseif label== PROFESSIONS_CRAFTING_STAT_TT_RESOURCE_RETURN_HEADER then
            self.LeftLabel:SetText('充裕')
        elseif label== ITEM_MOD_CRAFTING_SPEED_SHORT then
            self.LeftLabel:SetText('制作速度')
        elseif label== PROFESSIONS_OUTPUT_MULTICRAFT_TITLE then
            self.LeftLabel:SetText('产能')
        end

    end)

    hooksecurefunc(ProfessionsRecipeListRecipeMixin, 'Init', function(self)
        e.set(self.Label)
    end)
    hooksecurefunc(ProfessionsRecipeListCategoryMixin, 'Init', function(self, node)
        e.set(self.Label)
    end)

    --Blizzard_ProfessionsSpecializations.lua
    e.dia("PROFESSIONS_SPECIALIZATION_CONFIRM_PURCHASE_TAB", {button1 = '是', button2 = '取消'})
    e.hookDia("PROFESSIONS_SPECIALIZATION_CONFIRM_PURCHASE_TAB", 'OnShow', function(self, info)
        local headerText = HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(format('学习%s？', info.specName).."\n\n")
        local bodyKey = info.hasAnyConfigChanges and '所有待定的改动都会在解锁此专精后进行应用。您确定要学习%s副专精吗？' or '您确定想学习%s专精吗？您将来可以在%s专业里更加精进后选择额外的专精。'
        local bodyText = NORMAL_FONT_COLOR:WrapTextInColorCode(bodyKey:format(info.specName, info.profName))
        self.text:SetText(headerText..bodyText)
        self.text:Show()
    end)

    --Blizzard_ProfessionsFrame.lua
    e.dia("PROFESSIONS_SPECIALIZATION_CONFIRM_CLOSE", {text = '你想在离开前应用改动吗？', button1 = '是', button2 = '否',})




    --列表，目录
    hooksecurefunc(ProfessionsRecipeListRecipeMixin, 'Init', function(self, node)
        e.set(self.Lable)
        --local elementData = node:GetData();
        --local recipeInfo = Professions.GetHighestLearnedRecipe(elementData.recipeInfo) or elementData.recipeInfo
        
    end)

    --专业，技能点 ProfessionsRankBarMixin
    hooksecurefunc(ProfessionsFrame.CraftingPage.RankBar, 'Update', function(self, professionInfo)
        local name= e.strText[professionInfo.professionName]
        if name then
            local rankText = GenerateRankText(name, professionInfo.skillLevel, professionInfo.maxSkillLevel, professionInfo.skillModifier);
            self.Rank.Text:SetText(rankText)
        end
    end)
end
















--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_Professions') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()            
        end

    elseif arg1=='Blizzard_Professions' then       
        self:UnregisterEvent('ADDON_LOADED')
        Init()
        
    end
end)
