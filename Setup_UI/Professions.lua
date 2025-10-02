local FailValidationReason = EnumUtil.MakeEnum("Cooldown", "InsufficientReagents", "PrerequisiteReagents", "Disabled", "Requirement", "LockedReagentSlot", "RecraftOptionalReagentLimit")
local FailValidationTooltips = {
    [FailValidationReason.Cooldown] = '配方冷却中。',
    [FailValidationReason.InsufficientReagents] = '你的材料不足。',
    [FailValidationReason.PrerequisiteReagents] = '一种或多种附加材料不满足必要条件。',
    [FailValidationReason.Requirement] = '你不满足一个或更多的条件，不能制作此配方。',
    [FailValidationReason.LockedReagentSlot] = '你尚未解锁必需的附加材料栏位。',
    [FailValidationReason.RecraftOptionalReagentLimit] = '你尝试再造的物品有装备唯一限制。需要先脱下该装备后进行再造。',
}


local function SetTextToFit(fontString, text, maxWidth, multiline)
	fontString:SetHeight(200)
	fontString:SetText(text)
	fontString:SetWidth(maxWidth)
	if not multiline then
		fontString:SetWidth(fontString:GetStringWidth())
	end
	fontString:SetHeight(fontString:GetStringHeight())
end


local RequirementTypeToString =
{
	[Enum.RecipeRequirementType.SpellFocus] = "SpellFocusRequirement",
	[Enum.RecipeRequirementType.Totem] = "TotemRequirement",
	[Enum.RecipeRequirementType.Area] = "AreaRequirement",
}
local function FormatRequirements(requirements)
	local formattedRequirements = {}
	for _, recipeRequirement in ipairs(requirements) do
        local name= WoWTools_ChineseMixin:CN(recipeRequirement.name) or recipeRequirement.name
		table.insert(formattedRequirements, LinkUtil.FormatLink(RequirementTypeToString[recipeRequirement.type], name))
		table.insert(formattedRequirements, recipeRequirement.met)
	end
	return formattedRequirements
end






















local function Init_CraftingPage(self)
    ProfessionsFrame.CraftingPage.ViewGuildCraftersButton:SetText('查看工匠')

    hooksecurefunc(ProfessionsFrame.CraftingPage, 'Init', function(frame)--Blizzard_ProfessionsCrafting.lua
        local minimized = ProfessionsUtil.IsCraftingMinimized()
        if minimized and frame.MinimizedSearchBox:IsCurrentTextValidForSearch() then
            frame.MinimizedSearchResults:GetTitleText():SetFormattedText('搜索结果\"%s\"(%d)', frame.MinimizedSearchBox:GetText(), frame.searchDataProvider:GetSize())
        end
    end)

    hooksecurefunc(ProfessionsFrame.CraftingPage, 'ValidateControls', function(frame)--Blizzard_ProfessionsCrafting.lua
        local currentRecipeInfo = frame.SchematicForm:GetRecipeInfo()
        local isRuneforging = C_TradeSkillUI.IsRuneforging()
        if currentRecipeInfo ~= nil and currentRecipeInfo.learned and (Professions.InLocalCraftingMode() or C_TradeSkillUI.IsNPCCrafting() or isRuneforging)
            and not currentRecipeInfo.isRecraft
            and not currentRecipeInfo.isDummyRecipe and not currentRecipeInfo.isGatheringRecipe then

            local transaction = frame.SchematicForm:GetTransaction()
            local isEnchant = transaction:IsRecipeType(Enum.TradeskillRecipeType.Enchant)

            local countMax = frame:GetCraftableCount()

            if isEnchant then
                frame.CreateButton:SetTextToFit('附魔')
                local quantity = math.max(1, countMax)
                frame.CreateAllButton:SetTextToFit(format('%s [%d]', '附魔所有', quantity))
            else
                if currentRecipeInfo.abilityVerb then
                    -- abilityVerb is recipe-level override
                    --frame.CreateButton:SetTextToFit(currentRecipeInfo.abilityVerb)
                elseif currentRecipeInfo.alternateVerb then
                    -- alternateVerb is profession-level override
                    --frame.CreateButton:SetTextToFit(currentRecipeInfo.alternateVerb)
                elseif frame.SchematicForm.recraftSlot and frame.SchematicForm.recraftSlot.InputSlot:IsVisible() then
                    frame.CreateButton:SetTextToFit('再造')
                else
                    frame.CreateButton:SetTextToFit('制造')
                end

                local createAllFormat
                if currentRecipeInfo.abilityAllVerb then
                    -- abilityAllVerb is recipe-level override
                    createAllFormat = currentRecipeInfo.abilityAllVerb
                else
                    createAllFormat = '全部制造'
                end
                frame.CreateAllButton:SetTextToFit(format('%s [%d]', createAllFormat, countMax))
            end

            local enabled = true
            if PartialPlayTime() then
                local reasonText = format('你的在线时间已经超过3小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏下线休息。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                frame:SetCreateButtonTooltipText(reasonText)
                enabled = false
            elseif NoPlayTime() then
                local reasonText = format('你的在线时间已经超过5小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏，下线休息和运动。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                frame:SetCreateButtonTooltipText(reasonText)
                enabled = false
            end

            if enabled then
                local failValidationReason = frame:ValidateCraftRequirements(currentRecipeInfo, transaction, isRuneforging, countMax)
                frame:SetCreateButtonTooltipText(FailValidationTooltips[failValidationReason])
            end

        end
    end)





    --专业，技能点 ProfessionsRankBarMixin
    local function GenerateRankText(professionName, skillLevel, maxSkillLevel, skillModifier)
        local rankText
        if skillModifier > 0  then
            rankText = format('%s %d (|cff20ff20+%d|r ) /%d', professionName, skillLevel, skillModifier, maxSkillLevel)
        else
            rankText = format('%s %d/%d', professionName, skillLevel, maxSkillLevel)
        end
        if GameLimitedMode_IsActive() then
            local professionCap = select(3, GetRestrictedAccountData())
            if skillLevel >= professionCap and professionCap > 0 then
                return format("%s %s%s|r", rankText, RED_FONT_COLOR_CODE, '已达免费试玩上限。')
            end
        end
        return rankText
    end
    hooksecurefunc(ProfessionsFrame.CraftingPage.RankBar, 'Update', function(frame, professionInfo)
        local name= self:CN(professionInfo.professionName)
        if name then
            local rankText = GenerateRankText(name, professionInfo.skillLevel, professionInfo.maxSkillLevel, professionInfo.skillModifier)
            frame.Rank.Text:SetText(rankText)
        end
    end)




    hooksecurefunc(ProfessionsFrame.CraftingPage, 'ValidateControls', function(frame)
        local currentRecipeInfo = frame.SchematicForm:GetRecipeInfo()
        local isRuneforging = C_TradeSkillUI.IsRuneforging()
        if currentRecipeInfo ~= nil and currentRecipeInfo.learned and (Professions.InLocalCraftingMode() or C_TradeSkillUI.IsNPCCrafting() or isRuneforging)
            and not currentRecipeInfo.isRecraft
            and not currentRecipeInfo.isDummyRecipe and not currentRecipeInfo.isGatheringRecipe
        then
            local transaction = frame.SchematicForm:GetTransaction()
            local isEnchant = transaction:IsRecipeType(Enum.TradeskillRecipeType.Enchant)
            local countMax = frame:GetCraftableCount()
            if isEnchant then
                frame.CreateButton:SetTextToFit('附魔')
                local quantity = math.max(1, countMax)
                frame.CreateAllButton:SetTextToFit(format('"%s [%d]', '附魔所有', quantity))
            elseif not currentRecipeInfo.abilityVerb and not currentRecipeInfo.alternateVerb then
                if frame.SchematicForm.recraftSlot and frame.SchematicForm.recraftSlot.InputSlot:IsVisible() then
                    frame.CreateButton:SetTextToFit('再造')
                else
                    frame.CreateButton:SetTextToFit('制造')
                end
                if not currentRecipeInfo.abilityAllVerb then
                    frame.CreateAllButton:SetTextToFit(format('%s [%d]', '全部制造', countMax))
                end
            end
            local enabled = true
            if PartialPlayTime() then
                local reasonText = format('你的在线时间已经超过3小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏下线休息。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                frame:SetCreateButtonTooltipText(reasonText)
                enabled = false
            elseif NoPlayTime() then
                local reasonText = format('你的在线时间已经超过5小时。在目前阶段下，你不能这么做。在下线休息%d小时后，你的防沉迷时间将会清零。请退出游戏，下线休息和运动。', REQUIRED_REST_HOURS - math.floor(GetBillingTimeRested() / 60))
                frame:SetCreateButtonTooltipText(reasonText)
                enabled = false
            end
            if enabled then
                local failValidationReason = frame:ValidateCraftRequirements(currentRecipeInfo, transaction, isRuneforging, countMax)
                if failValidationReason and FailValidationTooltips[failValidationReason] then
                    frame:SetCreateButtonTooltipText(FailValidationTooltips[failValidationReason])
                end
            end
        end
    end)
end

























local function Init_CraftingPage_SchematicForm(self)
    local frame= ProfessionsFrame.CraftingPage.SchematicForm

    self:HookLabel(frame.RecraftingDescription)
    if frame.AllocateBestQualityCheckbox then
        frame:HookScript('OnShow', function(f)
            f.AllocateBestQualityCheckbox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('使用最高品质材料'))
            f.TrackRecipeCheckbox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('追踪配方'))
        end)
    end

    self:HookLabel(frame.Reagents.Label)
    self:SetLabel(frame.FirstCraftBonus.Text)
    self:HookLabel(frame.RecipeSourceButton.Text)--未学习的配方

    self:SetLabel(frame.FinishingReagents.Label)
    self:SetLabel(frame.Concentrate.Label)
    self:SetLabel(frame.Details.CraftingChoicesContainer.FinishingReagentSlotContainer.Label)
    self:SetLabel(frame.Details.CraftingChoicesContainer.ConcentrateContainer.Label)

    frame.QualityDialog.AcceptButton:SetText('接受')
    frame.QualityDialog.CancelButton:SetText('取消')
    frame.QualityDialog:SetTitle('材料品质')


    frame.RecipeSourceButton:HookScript('OnEnter', function(f)

        local recipeInfo= f:GetParent().currentRecipeInfo
        if not recipeInfo or not recipeInfo.recipeID then
            return
        end
        local sourceText
        if not recipeInfo.learned then
            sourceText = self:GetRecipeSource(recipeInfo.recipeID) or self:CN(C_TradeSkillUI.GetRecipeSourceText(recipeInfo.recipeID))
        elseif recipeInfo.nextRecipeID then
            sourceText =  self:GetRecipeSource(recipeInfo.nextRecipeID) or self:CN(C_TradeSkillUI.GetRecipeSourceText(recipeInfo.nextRecipeID))
        end
        if sourceText then
            GameTooltip:AddLine(' ')
            GameTooltip_AddHighlightLine(GameTooltip, sourceText)
            GameTooltip:Show()
        end
    end)

    frame.FavoriteButton:HookScript("OnEnter", function(button)
        GameTooltip_AddHighlightLine(GameTooltip, button:GetChecked() and '从偏好中移除' or '设置为偏好')
        GameTooltip:Show()
    end)
    frame.FavoriteButton:HookScript("OnClick", function(button)
        GameTooltip_AddHighlightLine(GameTooltip, button:GetChecked() and '从偏好中移除' or '设置为偏好')
        GameTooltip:Show()
    end)
    frame.FirstCraftBonus:SetScript("OnEnter", function()
        GameTooltip_AddNormalLine(GameTooltip, '首次制造此配方会教会你某种新东西。')
        GameTooltip:Show()
    end)


    hooksecurefunc(frame, 'Init', function(f, recipeInfo)--ProfessionsRecipeSchematicFormMixin
        if not recipeInfo then
            return
        end

        local name
        local isRecraft
        local recipeID = recipeInfo.recipeID
        f.recipeID= recipeID
        local minimized = ProfessionsUtil.IsCraftingMinimized()

        local reagents = f.transaction:CreateCraftingReagentInfoTbl()
        local outputItemInfo = C_TradeSkillUI.GetRecipeOutputItemData(recipeID, reagents, f.transaction:GetAllocationItemGUID()) or {}


        if outputItemInfo.hyperlink then
            name = self:GetRecipeName(recipeInfo, outputItemInfo.hyperlink)
        else
            name= self:CN(f.recipeSchematic.name) or self:GetRecipeName(recipeInfo)
            name= name and WrapTextInColor(name, NORMAL_FONT_COLOR)
            isRecraft= true
        end
        if name then
            local maxWidth = minimized and 250 or 800
            local multiline = minimized
            if f.RecraftingOutputText:IsShown() then
                if isRecraft then
                    SetTextToFit(f.RecraftingOutputText, format(name), maxWidth, multiline)
                else
                    SetTextToFit(f.RecraftingOutputText, format('再造：%s', name), maxWidth, multiline)
                end
            else
                SetTextToFit(f.OutputText, name, maxWidth, multiline)
            end
        end

        local isEnchant = (f.recipeSchematic.recipeType == Enum.TradeskillRecipeType.Enchant) and not C_TradeSkillUI.IsRuneforging()
        if isEnchant then
            f.OptionalReagents:SetText('可选目标：')
        else
            f.OptionalReagents:SetText('附加材料：')
        end

        if f.RecipeSourceButton:IsShown() then
            local sourceText--, sourceTextIsForNextRank
            if not recipeInfo.learned then
                sourceText= self:GetRecipeSource(recipeID) or self:CN(C_TradeSkillUI.GetRecipeSourceText(recipeID))
            elseif recipeInfo.nextRecipeID then
                sourceText= self:GetRecipeSource(recipeInfo.nextRecipeID) or self:CN(C_TradeSkillUI.GetRecipeSourceText(recipeInfo.nextRecipeID))
            end
            if sourceText then
                f.RecipeSourceButton:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(f.RecipeSourceButton.Text, "ANCHOR_RIGHT")
                    GameTooltip:SetCustomWordWrapMinWidth(350)
                    GameTooltip_AddHighlightLine(GameTooltip, sourceText)
                    GameTooltip:Show()
                end)
            end
        end

        if not f.isInspection then
            if #C_TradeSkillUI.GetRecipeRequirements(recipeID) > 0 then
                local fontString = isRecraft and f.RecraftingRequiredTools or f.RequiredTools
                f.UpdateRequiredTools = function()
                    local requirements = C_TradeSkillUI.GetRecipeRequirements(recipeID)
                    if (#requirements > 0) then
                        
                        local requirementsText = BuildColoredListString(unpack(FormatRequirements(requirements)))
                        local maxWidth = minimized and 250 or 800
                        local multiline = minimized
                        SetTextToFit(fontString, format('|cnNORMAL_FONT_COLOR:需要：|r %s', requirementsText), maxWidth, multiline)
                    else
                        fontString:SetText("")
                    end
                end
                f.UpdateRequiredTools()
            end
        end
    end)









    hooksecurefunc(frame, 'UpdateRecipeDescription', function(f)
        if not f.Description:IsShown() then
            return
        end
        local spell = Spell:CreateFromSpellID(f.currentRecipeInfo.recipeID)
        local spellID= spell:GetSpellID()
        if spellID then
            local desc= select(2, self:GetSpellName())
            if desc then
                f.Description:SetText(desc)
                local h= math.mix(600, f.Description:GetStringHeight())
                f.Description:SetHeight(h)
                f.Description:SetHeight(f.Description:GetStringHeight() + 1)
            end
        end
    end)

    

    Init_CraftingPage_SchematicForm=function()end
end





























local function Init_SpecPage(self)
    --Blizzard_ProfessionsSpecializations.lua
    self:AddDialogs("PROFESSIONS_SPECIALIZATION_CONFIRM_PURCHASE_TAB", {button1 = '是', button2 = '取消'})
    self:HookDialog("PROFESSIONS_SPECIALIZATION_CONFIRM_PURCHASE_TAB", 'OnShow', function(f, info)
        local specName= self:CN(info.specName) or info.specName
        local headerText = HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(format('学习%s？', pecName).."\n\n")
        local bodyKey = info.hasAnyConfigChanges and '所有待定的改动都会在解锁此专精后进行应用。您确定要学习%s副专精吗？' or '您确定想学习%s专精吗？您将来可以在%s专业里更加精进后选择额外的专精。'
        local bodyText = NORMAL_FONT_COLOR:WrapTextInColorCode(format(bodyKey, specName, self:CN(info.profName) or info.profName))
        local t= f.text or f:GetTextFontString()
        t:SetText(headerText..bodyText)
       StaticPopup_Resize(f, "PROFESSIONS_SPECIALIZATION_CONFIRM_PURCHASE_TAB")
    end)
    --Blizzard_ProfessionsFrame.lua
    self:AddDialogs("PROFESSIONS_SPECIALIZATION_CONFIRM_CLOSE", {text = '你想在离开前应用改动吗？', button1 = '是', button2 = '否',})


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

    ProfessionsFrame.SpecPage.DetailedView.SpendPointsButton:HookScript("OnEnter", function(frame)
        local f= ProfessionsFrame.SpecPage
        local spendCurrency = C_ProfSpecs.GetSpendCurrencyForPath(f:GetDetailedPanelNodeID())
        if not spendCurrency then
            return
        end
        local currencyTypesID = f:GetSpendCurrencyTypesID()
        if not currencyTypesID then
            return
        end
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyTypesID)
        if f.treeCurrencyInfoMap[spendCurrency] ~= nil and f.treeCurrencyInfoMap[spendCurrency].quantity == 0 and currencyInfo.name then
            local name= '|T'..(currencyInfo.iconFileID or 0)..':0|t'..(self:CN(currencyInfo.name) or currencyInfo.name)
            GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 0, 0)
            GameTooltip_AddErrorLine(GameTooltip, format('你没有可以消耗的|n%s', name))
            GameTooltip:Show()
        end
    end)

    --ProfessionsSpecFrameMixin
    hooksecurefunc(ProfessionsFrame.SpecPage, 'UpdateDetailedPanel', function(f)
        local name=self:GetProfessionNodeName(f:GetDetailedPanelNodeID())
                    or self:CN(f:GetDetailedPanelPath():GetName())
        if name then
            f.DetailedView.PathName:SetText(name)
        end
    end)


    --专精，技能，提示
    local function on_enter(f)
        local name=self:GetProfessionNodeName(f.nodeID)
        local desc= self:GetProfessionNodeDesc(f.nodeID)

        if name then
            GameTooltipTextLeft1:SetText(name)
        end
        local currRank, maxRank = f:GetRanks()
        if currRank and maxRank then
            GameTooltipTextLeft5:SetText('等级 '..currRank..'/'..maxRank)
        end
        if desc then
            GameTooltipTextLeft5:SetText(desc)
        end
        GameTooltip:Show()
    end

    ProfessionsFrame.SpecPage.DetailedView.Path:HookScript('OnEnter', function(f)
        on_enter(f)
    end)
    hooksecurefunc(ProfessionsSpecPathMixin, 'OnEnter', function(f)
        on_enter(f)
    end)



    hooksecurefunc(ProfessionSpecTabMixin, 'OnLoad', function(f)
        f.StateIcon:SetScript("OnEnter", function(frame)
            GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
            local name= f:GetParent().professionInfo.professionName
            name= self:CN(name) or name
            GameTooltip_AddNormalLine(GameTooltip, format('你可以选择一个新的专精|n|cnGREEN_FONT_COLOR:%s|r', name))
            GameTooltip:Show()
        end)
    end)

    hooksecurefunc(ProfessionSpecTabMixin, 'SetState', function(f, state)
        local name= self:CN(f.tabInfo.name)
        if name then
            name = (state ~= Enum.ProfessionsSpecTabState.Locked) and name or DISABLED_FONT_COLOR:WrapTextInColorCode(name)
            f.Text:SetText(name)
        end
    end)
end























local function Init_OrdersPage(self)
    local frame= ProfessionsFrame.OrdersPage
    frame.BrowseFrame.SearchButton:SetText('搜索')
    frame.OrderView.OrderInfo.BackButton:SetText('返回')

    frame.BrowseFrame.PublicOrdersButton.Text:SetText('公开')
    self:SetCNFont(frame.BrowseFrame.PublicOrdersButton.Text)
    frame.BrowseFrame.PersonalOrdersButton.Text:SetText('个人')
    self:SetCNFont(frame.BrowseFrame.PersonalOrdersButton.Text)

    ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.SearchBox.Instructions:SetText('搜索')
    --ProfessionsFrame.OrdersPage.BrowseFrame.RecipeList.FilterButton:SetText('过滤器')

    frame.BrowseFrame.OrdersRemainingDisplay:HookScript('OnEnter', function()
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
        [Enum.CraftingOrderType.Personal] = '个人',
    }
    local function SetTabTitleWithCount(tabButton, type, count)
        local title = orderTypeTabTitles[type]
        if tabButton and title then
            if type == Enum.CraftingOrderType.Public then
                tabButton.Text:SetText(title)
            else
                tabButton.Text:SetFormattedText("%s (%s)", title, count)
            end
        end
    end
    --ProfessionsCraftingOrderPageMixin
    hooksecurefunc(frame, 'InitOrderTypeTabs', function(f)
        for _, typeTab in ipairs(f.BrowseFrame.orderTypeTabs) do
            SetTabTitleWithCount(typeTab, typeTab.orderType, 0)
        end
    end)
    frame:HookScript('OnEvent', function(f, event, ...)
        if event == "CRAFTINGORDERS_UPDATE_ORDER_COUNT" then
            local type, count = ...
            local tabButton
            if type == Enum.CraftingOrderType.Guild then
                tabButton = f.BrowseFrame.GuildOrdersButton
            elseif type == Enum.CraftingOrderType.Personal then
                tabButton = f.BrowseFrame.PersonalOrdersButton
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

    hooksecurefunc(frame, 'StartDefaultSearch', function(f)
        if f.BrowseFrame.OrderList.ResultsText:IsShown() then
            f.BrowseFrame.OrderList.ResultsText:SetText('小窍门：右键点击配方可以设置偏好。偏好的配方会在你打开你的公开订单时立即出现。')
        end
    end)
    hooksecurefunc(frame, 'UpdateOrdersRemaining', function(f)
        if f.professionInfo then
            local isPublic = f.orderType == Enum.CraftingOrderType.Public
            if isPublic and f.professionInfo and f.professionInfo.profession then
                self:SetLabel(f.BrowseFrame.OrdersRemainingDisplay.OrdersRemaining, format('剩余订单：%s', C_CraftingOrders.GetOrderClaimInfo(f.professionInfo.profession).claimsRemaining))
            end
        end
    end)
    hooksecurefunc(frame, 'ShowGeneric', function(f)
        if f.BrowseFrame.OrderList.ResultsText:IsShown() then
            f.BrowseFrame.OrderList.ResultsText:SetText('没有发现订单')
        end
    end)

    frame.OrderView.OrderInfo.PostedByTitle:SetText('订单发布人：')
    frame.OrderView.OrderInfo.CommissionTitle:SetText('佣金：')
    frame.OrderView.OrderInfo.ConsortiumCutTitle:SetText('财团分成：')
    frame.OrderView.OrderInfo.FinalTipTitle:SetText('你的分成：')
    frame.OrderView.OrderInfo.TimeRemainingTitle:SetText('剩余时间：')
    frame.OrderView.OrderInfo.NoteBox.NoteTitle:SetText('给制作者的信息：')
    frame.OrderView.OrderInfo.StartOrderButton:SetText('开始接单')
    frame.OrderView.OrderInfo.DeclineOrderButton:SetText('拒绝订单')
    frame.OrderView.OrderInfo.ReleaseOrderButton:SetText('取消订单')

    frame.OrderView.OrderDetails.SchematicForm.OptionalReagents.Label:SetText('附加材料：')
    frame.OrderView.OrderDetails.SchematicForm.OptionalReagents.labelText= '附加材料：'--Blizzard_ProfessionsRecipeSchematicForm.xml


    hooksecurefunc(frame.OrderView, 'UpdateStartOrderButton', function(f)--Blizzard_ProfessionsCrafterOrderView.lua
        local errorReason
        local recipeInfo = C_TradeSkillUI.GetRecipeInfo(f.order.spellID)
        local profession = C_TradeSkillUI.GetChildProfessionInfo().profession
        local claimInfo = profession and C_CraftingOrders.GetOrderClaimInfo(profession)
        if f.order.customerGuid == UnitGUID("player") then
            errorReason = '你不能认领你自己的订单。'
        elseif claimInfo and f.order.orderType == Enum.CraftingOrderType.Public and claimInfo.claimsRemaining <= 0 and Professions.GetCraftingOrderRemainingTime(f.order.expirationTime) > Constants.ProfessionConsts.PUBLIC_CRAFTING_ORDER_STALE_THRESHOLD then
            errorReason = format('你目前无法认领更多的公开订单。%s后才有更多可用的订单。', SecondsToTime(claimInfo.secondsToRecharge))
        elseif not recipeInfo or not recipeInfo.learned or (f.order.isRecraft and not C_CraftingOrders.OrderCanBeRecrafted(f.order.orderID)) then
            errorReason = '你还没有学会此配方。'
        elseif not f.hasOptionalReagentSlots then
            errorReason = '你尚未解锁完成此订单所需的附加材料栏位。'
        end

        if errorReason then
            f.OrderInfo.StartOrderButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(f.OrderInfo.StartOrderButton, "ANCHOR_RIGHT")
                GameTooltip_AddErrorLine(GameTooltip, errorReason)
                GameTooltip:Show()
            end)
        else
            f.OrderInfo.StartOrderButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(f.OrderInfo.StartOrderButton, "ANCHOR_RIGHT")
                GameTooltip_AddHighlightLine(GameTooltip, '此订单开始后，你有30分钟的时间来完成此订单。')
                GameTooltip:Show()
            end)
        end
    end)


    frame.OrderView.OrderDetails.FulfillmentForm.NoteEditBox.ScrollingEditBox.defaultText= '在此输入消息'

    frame.OrderView.CompleteOrderButton:SetText('完成订单')
    frame.OrderView.StartRecraftButton:SetText('再造')
    frame.OrderView.StopRecraftButton:SetText('取消再造')
    frame.OrderView.DeclineOrderDialog.ConfirmationText:SetText('你确定想拒绝此订单吗？')
    frame.OrderView.DeclineOrderDialog.NoteEditBox.TitleBox.Title:SetText('拒绝原因：')
    frame.OrderView.DeclineOrderDialog.CancelButton:SetText('否')
    frame.OrderView.DeclineOrderDialog.ConfirmButton:SetText('是')

    --frame.OrderView.OrderDetails.SchematicForm.AllocateBestQualityCheckBox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('使用最高品质材料'))



    hooksecurefunc(frame.OrderView, 'InitRegions', function(f)
        f.OrderDetails.FulfillmentForm.OrderCompleteText:SetText('订单完成！')
        f.DeclineOrderDialog:SetTitle('拒绝订单')
    end)

    frame.OrderView:HookScript('OnEvent', function(f, event, ...)
        if event == "CRAFTINGORDERS_CLAIM_ORDER_RESPONSE" then
            local result, orderID = ...
            if orderID == f.order.orderID then
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
            if orderID == f.order.orderID then
                local success = result == Enum.CraftingOrderResult.Ok
                if not success then
                    UIErrorsFrame:AddExternalErrorMessage('制造订单运行失败。请稍后重试。')
                end
            end
        elseif event == "CRAFTINGORDERS_FULFILL_ORDER_RESPONSE" then
            local result, orderID = ...
            if orderID == f.order.orderID then
                local success = result == Enum.CraftingOrderResult.Ok
                if not success then
                    UIErrorsFrame:AddExternalErrorMessage('制造订单运行失败。请稍后重试。')
                end
            end
        elseif event == "CRAFTINGORDERS_UNEXPECTED_ERROR" then
            UIErrorsFrame:AddExternalErrorMessage('制造订单运行失败。请稍后重试。')
        end
    end)

    hooksecurefunc(frame.OrderView, 'UpdateCreateButton', function(f)
        self:SetLabel(f.CreateButton)
        local transaction = f.OrderDetails.SchematicForm.transaction
        local errorReason
        if Professions.IsRecipeOnCooldown(f.order.spellID) then
            errorReason = '配方冷却中。'
        elseif not transaction:HasMetAllRequirements() then
            errorReason = '你的材料不足。'
        elseif f.order.minQuality and f.OrderDetails.SchematicForm.Details:GetProjectedQuality() and f.order.minQuality > f.OrderDetails.SchematicForm.Details:GetProjectedQuality() then
            local smallIcon = true
            errorReason = format('此订单要求的最低品质是%s', Professions.GetChatIconMarkupForQuality(f.order.minQuality, smallIcon))
        end
        if errorReason then
            f.CreateButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(f.CreateButton, "ANCHOR_RIGHT")
                GameTooltip_AddErrorLine(GameTooltip, errorReason)
                GameTooltip:Show()
            end)
        end
    end)


    hooksecurefunc(frame.OrderView, 'SetOrder', function(f)
        local warningText
        if f.order.reagentState == Enum.CraftingOrderReagentsType.All then
            warningText = '所有材料都由顾客提供。'
        elseif f.order.reagentState == Enum.CraftingOrderReagentsType.Some then
            warningText = '将由你来提供某些材料。'
        elseif f.order.reagentState == Enum.CraftingOrderReagentsType.None then
            warningText = '将由你来提供全部材料。'
        end
        if warningText then
            f.OrderInfo.OrderReagentsWarning.Text:SetText(warningText)
        end
    end)








end






























--Blizzard_ProfessionsCraftingOutputLog.lua
local function Init_CraftingOutputLog(self)
    ProfessionsFrame.CraftingPage.CraftingOutputLog:SetTitle('制作成果')
    hooksecurefunc(ProfessionsCraftingOutputLogElementMixin, 'OnLoad', function(f)
        f.Multicraft.Text:SetText('"产能！')
        f.Resources.Text:SetText('节约了材料！')
        f.BonusCraft.Text:SetText('首次制造！')
    end)

    hooksecurefunc(ProfessionsCraftingOutputLogElementMixin, 'Init', function(f)
        local resultData = f:GetElementData()
        if not resultData then
            return
        end

        self:SetLabel(f.ItemContainer.Text)

        if resultData.hasIngenuityProc and resultData.ingenuityRefund > 0 then
            f.ItemContainer.CritText:SetScript("OnEnter", function(text)
                GameTooltip:SetOwner(text, "ANCHOR_RIGHT")
                GameTooltip_AddHighlightLine(GameTooltip, '奇思')
                GameTooltip_AddNormalLine(GameTooltip, format('你获得了一次奇思突破，此次制造返还了|cnGREEN_FONT_COLOR:%d|r点专注。', resultData.ingenuityRefund))
                GameTooltip:Show()
            end)
        end

        if resultData.multicraft > 0 then
            f.Multicraft.Text:SetScript("OnEnter", function(text)
                GameTooltip:SetOwner(text, "ANCHOR_RIGHT")
                GameTooltip_AddHighlightLine(GameTooltip, '产能')
                local tooltipText = format('你的产能技能使你额外制作了|cnGREEN_FONT_COLOR:%d|r个物品。', resultData.multicraft)
                GameTooltip_AddNormalLine(GameTooltip, tooltipText)
                GameTooltip:Show()
            end)
        end

        f.Resources.Text:SetScript("OnEnter", function(text)
            GameTooltip:SetOwner(text, "ANCHOR_RIGHT")
            GameTooltip_AddHighlightLine(GameTooltip, '充裕')
            GameTooltip_AddNormalLine(GameTooltip, '你的充裕属性给了回报，你节约了一些材料。')
            GameTooltip:Show()
        end)
    end)
end













--Blizzard_ProfessionsRecipeCrafterDetails.lua
local function Init_Details_Stat(self)

    --ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.DifficultyStatLine.LeftLabel
    self:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.Label)--制做详情
    self:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.DifficultyStatLine.LeftLabel)--配方难度：
    self:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.SkillStatLine.LeftLabel)--技能：
    hooksecurefunc(ProfessionsCrafterDetailsStatLineMixin, 'SetLabel', function(f, label)
        self:SetLabel(f.LeftLabel, label)
    end)
    --self:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.FinishingReagentSlotContainer.Label)--成品材料：

    --预期品质
    ProfessionsFrame.CraftingPage.SchematicForm.Details.QualityMeter.Center:SetScript("OnEnter", function(fill)
        local f= ProfessionsFrame.CraftingPage.SchematicForm.Details
		if not f.operationInfo then
			return
		end
		GameTooltip:SetOwner(fill, "ANCHOR_RIGHT")
		local atlasSize = 25
		local atlasMarkup = CreateAtlasMarkup(Professions.GetIconForQuality(f.QualityMeter.craftingQuality), atlasSize, atlasSize)
		local applyConcentration = f.transaction.IsApplyingConcentration and f.transaction:IsApplyingConcentration()
		local hasNextQuality = f.operationInfo.upperSkillTreshold > f.operationInfo.lowerSkillThreshold
		if hasNextQuality then
			atlasSize = 20
			local nextAtlasMarkup = CreateAtlasMarkup(Professions.GetIconForQuality(f.QualityMeter.craftingQuality + 1), atlasSize, atlasSize)
			if applyConcentration then
				GameTooltip_AddNormalLine(GameTooltip, format('|cnHIGHLIGHT_FONT_COLOR:预期品质：|r %s|n|n以目前的方式应用专注的话，可以确保你获得下一级品质：%s', nextAtlasMarkup, nextAtlasMarkup))
			else
				GameTooltip_AddNormalLine(GameTooltip, format('|cnHIGHLIGHT_FONT_COLOR:预期品质：|r%s|n|n根据当前的配方难度，达到%d点技能才能保证获得品质：%s', atlasMarkup, f.operationInfo.upperSkillTreshold, nextAtlasMarkup))
			end
		else
			GameTooltip_AddNormalLine(GameTooltip, format('|cnHIGHLIGHT_FONT_COLOR:期望品质：|r%s', atlasMarkup))
		end
        GameTooltip:Show()
    end)
end
























--Blizzard_ProfessionsRecipeReagentSlot.lua
local function Init_ReagentSlot(self)
    hooksecurefunc(ProfessionsReagentSlotMixin, 'UpdateAllocationText', function(f)
        local reagentSlotSchematic = f:GetReagentSlotSchematic()
        if not reagentSlotSchematic or not ProfessionsUtil.IsReagentSlotRequired(reagentSlotSchematic) then
            return
        end
        local foundIndex
        if ProfessionsUtil.IsReagentSlotModifyingRequired(reagentSlotSchematic) then
            if f:GetTransaction():IsModificationUnchangedAtSlotIndex(f:GetSlotIndex()) then
                return
            end
            for _, allocation in f:GetTransaction():EnumerateAllocations(reagentSlotSchematic.slotIndex) do
                assert(foundIndex == nil, "Cannot have multiple allocations within a modifying-required slot.")
                foundIndex = FindInTableIf(reagentSlotSchematic.reagents, function(reagent)
                    return Professions.CraftingReagentMatches(reagent, allocation.reagent)
                end)
            end

            if foundIndex == nil then
                return
            end
        else
             foundIndex = select(2, f:GetAllocationDetails())
        end

        local reagent = reagentSlotSchematic.reagents[foundIndex or 1]
        local reagentName
        if reagent.currencyID then
            local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(reagent.currencyID)
            if currencyInfo and currencyInfo.name then
                reagentName= self:CN(currencyInfo.name)
            else
                reagentName= '未知'
            end
        else
            reagentName= self:GetItemName(reagent.itemID)
            if not reagentName then
                local item = Item:CreateFromItemID(reagent.itemID)
                local itemName= item:GetItemName()
                if itemName then
                    reagentName= self:CN(itemName)
                else
                    reagentName= '未知'
                end
            end
        end

        if reagentName then
            local quantity
            if f.overrideQuantity then
                quantity = f.overrideQuantity
            else
                if foundMultiple then
                    quantity = '*'
                else
                    if foundIndex then
                        quantity = ProfessionsUtil.GetReagentQuantityInPossession(reagent)
                    else
                        quantity = ProfessionsUtil.AccumulateReagentsInPossession(reagentSlotSchematic.reagents)
                    end
                end
            end
            local quantityText = f.showOnlyRequired and reagentSlotSchematic.quantityRequired or ((quantity or 0)..'/'..(reagentSlotSchematic.quantityRequired or ''))
            f:SetNameText(format("%s %s", quantityText, reagentName))
        end
    end)
end

























local function Init_InspectRecipe()

end



















function WoWTools_ChineseMixin.Events:Blizzard_Professions()
    Init_CraftingPage(self)
    Init_CraftingPage_SchematicForm(self)
    Init_SpecPage(self)
    Init_OrdersPage(self)
    Init_CraftingOutputLog(self)
    Init_Details_Stat(self)
    Init_ReagentSlot(self)
    hooksecurefunc(ProfessionsFrame, 'SetTitle', function(frame, skillLineName)
        if self:CN(skillLineName) then
            skillLineName= self:CN(skillLineName)
            if C_TradeSkillUI.IsTradeSkillGuild() then
                frame:SetTitleFormatted('公会%s"', skillLineName)
            else
                local linked, linkedName = C_TradeSkillUI.IsTradeSkillLinked()
                if linked and linkedName then
                    frame:SetTitleFormatted("%s %s[%s]|r", format('%s', skillLineName), HIGHLIGHT_FONT_COLOR_CODE, linkedName)
                else
                    frame:SetTitleFormatted('%s', skillLineName)
                end
            end
        elseif C_TradeSkillUI.IsTradeSkillGuild() then
            frame:SetTitleFormatted('公会%s"', skillLineName)
        end
    end)



    self:SetTabButton(ProfessionsFrame)
    hooksecurefunc(ProfessionsFrame, 'UpdateTabs', function(frame)
        self:SetTabButton(frame)
    end)


     --目录，列表，标题
     ProfessionsFrame.CraftingPage.RecipeList.SearchBox.Instructions:SetText('搜索')
     --ProfessionsFrame.CraftingPage.RecipeList.FilterDropdown.Text:SetText('过滤器')
     hooksecurefunc(ProfessionsRecipeListCategoryMixin, 'Init', function(frame, node)
        local info= node:GetData().categoryInfo
        if info then
            local name= self:GetTradeSkillCategoryName(info.categoryID) or self:CN(info.name)
            if name then
                frame.Label:SetText(name)
            end
        end
    end)


    --列表，目录
    hooksecurefunc(ProfessionsRecipeListRecipeMixin, 'Init', function(frame, node)
        local elementData = node:GetData()
        local recipeInfo = Professions.GetHighestLearnedRecipe(elementData.recipeInfo) or elementData.recipeInfo
        local name= self:GetRecipeName(recipeInfo, nil)
        if name then
            frame.Label:SetText(name)
        end
    end)


    --Blizzard_ProfessionsInspectRecipe.lua InspectRecipeMixin
    self:SetLabel(InspectRecipeFrame.SchematicForm.Reagents.Label)
    hooksecurefunc(InspectRecipeFrame, 'Open', function(frame, recipeID)
        local data = C_TradeSkillUI.GetProfessionInfoByRecipeID(recipeID) or {}
        local name
        if data.professionName then
            name= self:GetTradeSkillCategoryName(data.professionID) or self:CN(data.professionName)
        elseif data.parentProfessionName then
            name= self:GetTradeSkillCategoryName(data.parentProfessionID) or self:CN(data.parentProfessionName)
        end
        if name then
            frame:SetTitle(name)
        end
    end)
end



--Blizzard_ProfessionsRecipeFlyout.lua
--ProfessionsItemFlyoutMixin:OnLoad()
