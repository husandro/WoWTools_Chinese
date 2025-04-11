











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

























local function Init_CraftingPage()
    ProfessionsFrame.CraftingPage.ViewGuildCraftersButton:SetText('查看工匠')

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
    hooksecurefunc(ProfessionsFrame.CraftingPage.RankBar, 'Update', function(self, professionInfo)
        local name= WoWTools_ChineseMixin:CN(professionInfo.professionName)
        if name then
            local rankText = GenerateRankText(name, professionInfo.skillLevel, professionInfo.maxSkillLevel, professionInfo.skillModifier)
            self.Rank.Text:SetText(rankText)
        end
    end)




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
end























local function Init_CraftingPage_SchematicForm()
    local frame= ProfessionsFrame.CraftingPage.SchematicForm

    WoWTools_ChineseMixin:HookLabel(frame.RecraftingDescription)
    if frame.AllocateBestQualityCheckbox then
        frame:HookScript('OnShow', function(self)
            self.AllocateBestQualityCheckbox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('使用最高品质材料'));
            self.TrackRecipeCheckbox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('追踪配方'));
        end)
    end

    WoWTools_ChineseMixin:HookLabel(frame.Reagents.Label)
    WoWTools_ChineseMixin:SetLabelText(frame.FirstCraftBonus.Text)
    WoWTools_ChineseMixin:HookLabel(frame.RecipeSourceButton.Text)--未学习的配方

    frame.QualityDialog.AcceptButton:SetText('接受')
    frame.QualityDialog.CancelButton:SetText('取消')
    frame.QualityDialog:SetTitle('材料品质')


    frame.RecipeSourceButton:HookScript('OnEnter', function(self)

        local recipeInfo= self:GetParent().currentRecipeInfo
        if not recipeInfo or not recipeInfo.recipeID then
            return
        end
        local sourceText
        if not recipeInfo.learned then
            sourceText = WoWTools_ChineseMixin:GetRecipeSource(recipeInfo.recipeID) or WoWTools_ChineseMixin:CN(C_TradeSkillUI.GetRecipeSourceText(recipeInfo.recipeID))
        elseif recipeInfo.nextRecipeID then
            sourceText =  WoWTools_ChineseMixin:GetRecipeSource(recipeInfo.nextRecipeID) or WoWTools_ChineseMixin:CN(C_TradeSkillUI.GetRecipeSourceText(recipeInfo.nextRecipeID))
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


    hooksecurefunc(frame, 'Init', function(self, recipeInfo)--ProfessionsRecipeSchematicFormMixin
        if not recipeInfo then
            return
        end
        
        local name
        local isRecraft
        local recipeID = recipeInfo.recipeID
        self.recipeID= recipeID

        local reagents = self.transaction:CreateCraftingReagentInfoTbl()
        local outputItemInfo = C_TradeSkillUI.GetRecipeOutputItemData(recipeID, reagents, self.transaction:GetAllocationItemGUID()) or {}


        if outputItemInfo.hyperlink then
            name = WoWTools_ChineseMixin:GetRecipeName(recipeInfo, outputItemInfo.hyperlink)
        else
            name= WoWTools_ChineseMixin:CN(self.recipeSchematic.name) or WoWTools_ChineseMixin:GetRecipeName(recipeInfo)
            name= name and WrapTextInColor(name, NORMAL_FONT_COLOR)
            isRecraft= true
        end
        if name then
            local minimized = ProfessionsUtil.IsCraftingMinimized()
            local maxWidth = minimized and 250 or 800
            local multiline = minimized
            if self.RecraftingOutputText:IsShown() then
                if isRecraft then
                    SetTextToFit(self.RecraftingOutputText, format(name), maxWidth, multiline)
                else
                    SetTextToFit(self.RecraftingOutputText, format('再造：%s', name), maxWidth, multiline)
                end
            else
                SetTextToFit(self.OutputText, name, maxWidth, multiline)
            end
        end

        local isEnchant = (self.recipeSchematic.recipeType == Enum.TradeskillRecipeType.Enchant) and not C_TradeSkillUI.IsRuneforging()
        if isEnchant then
            self.OptionalReagents:SetText('可选目标：')
        else
            self.OptionalReagents:SetText('附加材料：')
        end

        if self.RecipeSourceButton:IsShown() then
            local sourceText--, sourceTextIsForNextRank
            if not recipeInfo.learned then
                sourceText= WoWTools_ChineseMixin:GetRecipeSource(recipeID) or WoWTools_ChineseMixin:CN(C_TradeSkillUI.GetRecipeSourceText(recipeID))
            elseif recipeInfo.nextRecipeID then
                sourceText= WoWTools_ChineseMixin:GetRecipeSource(recipeInfo.nextRecipeID) or WoWTools_ChineseMixin:CN(C_TradeSkillUI.GetRecipeSourceText(recipeInfo.nextRecipeID))
            end
            if sourceText then
                --[[if sourceTextIsForNextRank then
                    self.RecipeSourceButton.Text:SetText('下一级')
                else
                    self.RecipeSourceButton.Text:SetText('未学习的配方')
                end]]
                self.RecipeSourceButton:SetScript("OnEnter", function()
                    GameTooltip:SetOwner(self.RecipeSourceButton.Text, "ANCHOR_RIGHT")
                    GameTooltip:SetCustomWordWrapMinWidth(350)
                    print(sourceText, recipeID)
                    GameTooltip_AddHighlightLine(GameTooltip, sourceText)
                    GameTooltip:Show()
                end)
            end
        end
    end)



    --[[local RequirementTypeToString =
    {
        [Enum.RecipeRequirementType.SpellFocus] = "SpellFocusRequirement",
        [Enum.RecipeRequirementType.Totem] = "TotemRequirement",
        [Enum.RecipeRequirementType.Area] = "AreaRequirement",
    };
    local function FormatRequirements(requirements)
        local formattedRequirements = {};
        for _, recipeRequirement in ipairs(requirements) do
            table.insert(formattedRequirements, LinkUtil.FormatLink(RequirementTypeToString[recipeRequirement.type], recipeRequirement.name));
            table.insert(formattedRequirements, recipeRequirement.met);
        end
        return formattedRequirements;
    end
    local function Tools_Text(self, text)
        local recipeInfo= self:GetParent().currentRecipeInfo
        local recipeID= recipeInfo.recipeID
        if not recipeID or not self:IsShown() or text=='' then
            self.P_SetText(self, text)
            return
        end

        local requirements = C_TradeSkillUI.GetRecipeRequirements(recipeID)
        if (#requirements > 0) then
            local requirementsText = BuildColoredListString(unpack(FormatRequirements(requirements)));
            local minimized= ProfessionsUtil.IsCraftingMinimized()
            local maxWidth = minimized and 250 or 800;
            local multiline = minimized;
            print(requirementsText)
            SetTextToFit(self, PROFESSIONS_REQUIRED_TOOLS:format(requirementsText), maxWidth, multiline);
        else
            self.P_SetText(self, "")
        end
    end


    
    frame.RequiredTools.P_SetText= frame.RequiredTools.SetText
    frame.RecraftingRequiredTools.P_SetText= frame.RecraftingRequiredTools.SetText
    function frame.RequiredTools:SetText(...)
        Tools_Text(self, ...)
    end
    function frame.RecraftingRequiredTools:SetText(...)
        Tools_Text(self, ...)
    end]]












    hooksecurefunc(frame, 'UpdateRecipeDescription', function(self)
        if not self.Description:IsShown() then
            return
        end
        local spell = Spell:CreateFromSpellID(self.currentRecipeInfo.recipeID);
        local spellID= spell:GetSpellID()
        if spellID then
            local desc
            for i, text in pairs(WoWTools_ChineseMixin:GetSpellData(spellID) or {}) do
                if i>1 then
                    if not desc or #text> #desc then
                        desc= text
                    end
                end
            end
            desc= WoWTools_ChineseMixin:ReplaceText(desc)
            if desc and desc ~= "" then
                self.Description:SetText(desc);
                self.Description:SetHeight(600);
                self.Description:SetHeight(self.Description:GetStringHeight() + 1)
            end
        end
    end)
end
            --[[local reagents = self.transaction:CreateCraftingReagentInfoTbl();
            --local description = C_TradeSkillUI.GetRecipeDescription(spell:GetSpellID(), reagents, self.transaction:GetAllocationItemGUID());
    
            -- If an embedded icon is present, substitute a small vertical offset so the icon is centered with the adjacent text.
            local textureID, height = string.match(description, "|T(%d+):(%d+)|t");
            if textureID then
                local size = height or 24;
                local xOffset, yOffset = 0, 3;
                description = string.gsub(description, "|T.*|t", CreateSimpleTextureMarkup(textureID, size, size, xOffset, yOffset));
            end]]
































local function Init_SpecPage()
    --Blizzard_ProfessionsSpecializations.lua
    WoWTools_ChineseMixin:AddDialogs("PROFESSIONS_SPECIALIZATION_CONFIRM_PURCHASE_TAB", {button1 = '是', button2 = '取消'})
    WoWTools_ChineseMixin:HookDialog("PROFESSIONS_SPECIALIZATION_CONFIRM_PURCHASE_TAB", 'OnShow', function(self, info)
        local specName= WoWTools_ChineseMixin:GetData(info.specName)
        local headerText = HIGHLIGHT_FONT_COLOR:WrapTextInColorCode(format('学习%s？', WoWTools_ChineseMixin:GetData(specName)).."\n\n")
        local bodyKey = info.hasAnyConfigChanges and '所有待定的改动都会在解锁此专精后进行应用。您确定要学习%s副专精吗？' or '您确定想学习%s专精吗？您将来可以在%s专业里更加精进后选择额外的专精。'
        local bodyText = NORMAL_FONT_COLOR:WrapTextInColorCode(format(bodyKey, specName, WoWTools_ChineseMixin:GetData(info.profName)))
        self.text:SetText(headerText..bodyText)
        self.text:Show()
    end)
    --Blizzard_ProfessionsFrame.lua
    WoWTools_ChineseMixin:AddDialogs("PROFESSIONS_SPECIALIZATION_CONFIRM_CLOSE", {text = '你想在离开前应用改动吗？', button1 = '是', button2 = '否',})


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
        local self= ProfessionsFrame.SpecPage
        local spendCurrency = C_ProfSpecs.GetSpendCurrencyForPath(self:GetDetailedPanelNodeID())
        if not spendCurrency then
            return
        end
        local currencyTypesID = self:GetSpendCurrencyTypesID()
        if not currencyTypesID then
            return
        end
        local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(currencyTypesID)
        if self.treeCurrencyInfoMap[spendCurrency] ~= nil and self.treeCurrencyInfoMap[spendCurrency].quantity == 0 and currencyInfo.name then
            local name= '|T'..(currencyInfo.iconFileID or 0)..':0|t'..WoWTools_ChineseMixin:GetData(currencyInfo.name)
            GameTooltip:SetOwner(frame, "ANCHOR_RIGHT", 0, 0)
            GameTooltip_AddErrorLine(GameTooltip, format('你没有可以消耗的|n%s', name))
            GameTooltip:Show()
        end
    end)

    --ProfessionsSpecFrameMixin
    hooksecurefunc(ProfessionsFrame.SpecPage, 'UpdateDetailedPanel', function(self)
        local data= WoWTools_ChineseMixin:GetProfessionNodeDesc(self:GetDetailedPanelNodeID())
        local name= data and data[1]
        if not name then
            local detailedViewPath = self:GetDetailedPanelPath();
            name= WoWTools_ChineseMixin:CN(detailedViewPath:GetName())
        end
        if name then
            self.DetailedView.PathName:SetText(name)
        end
    end)


    --专精，技能，提示
    local function on_enter(self)
        local data= WoWTools_ChineseMixin:GetProfessionNodeDesc(self.nodeID)
        if data then
            if data[1] then
                GameTooltipTextLeft1:SetText(data[1])
            end
            local currRank, maxRank = self:GetRanks();
            if currRank and maxRank then
                GameTooltipTextLeft5:SetText('等级 '..currRank..'/'..maxRank)
            end
            if data[2] then
                GameTooltipTextLeft5:SetText(data[2])
            end
            GameTooltip:Show()
        end
    end
    --[[GameTooltip:AddLine(' ')
    GameTooltip:AddLine('|cff00ff00'..data[2]..'|r', nil,nil,nil,  true)
    GameTooltip:Show()]]
    ProfessionsFrame.SpecPage.DetailedView.Path:HookScript('OnEnter', on_enter)
    hooksecurefunc(ProfessionsSpecPathMixin, 'OnEnter', on_enter)


    
    hooksecurefunc(ProfessionSpecTabMixin, 'OnLoad', function(self)
        self.StateIcon:SetScript("OnEnter", function(frame)
            GameTooltip:SetOwner(frame, "ANCHOR_RIGHT")
            local name= WoWTools_ChineseMixin:GetData(self:GetParent().professionInfo.professionName)
            GameTooltip_AddNormalLine(GameTooltip, format('你可以选择一个新的专精|n|cnGREEN_FONT_COLOR:%s|r', name))
            GameTooltip:Show();
        end)       
    end)

    hooksecurefunc(ProfessionSpecTabMixin, 'SetState', function(self, state)
        local name= WoWTools_ChineseMixin:CN(self.tabInfo.name)
        if name then
            name = (state ~= Enum.ProfessionsSpecTabState.Locked) and name or DISABLED_FONT_COLOR:WrapTextInColorCode(name);
            self.Text:SetText(name);
        end
    end)


end


























local function Init_OrdersPage()
    local frame= ProfessionsFrame.OrdersPage
    frame.BrowseFrame.SearchButton:SetText('搜索')
    frame.OrderView.OrderInfo.BackButton:SetText('返回')

    frame.BrowseFrame.PublicOrdersButton.Text:SetText('公开')
    WoWTools_ChineseMixin:SetCNFont(frame.BrowseFrame.PublicOrdersButton.Text)
    frame.BrowseFrame.PersonalOrdersButton.Text:SetText('个人')
    WoWTools_ChineseMixin:SetCNFont(frame.BrowseFrame.PersonalOrdersButton.Text)

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
    hooksecurefunc(frame, 'InitOrderTypeTabs', function(self)
        for _, typeTab in ipairs(self.BrowseFrame.orderTypeTabs) do
            SetTabTitleWithCount(typeTab, typeTab.orderType, 0)
        end
    end)
    frame:HookScript('OnEvent', function(self, event, ...)
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

    hooksecurefunc(frame, 'StartDefaultSearch', function(self)
        if self.BrowseFrame.OrderList.ResultsText:IsShown() then
            self.BrowseFrame.OrderList.ResultsText:SetText('小窍门：右键点击配方可以设置偏好。偏好的配方会在你打开你的公开订单时立即出现。')
        end
    end)
    hooksecurefunc(frame, 'UpdateOrdersRemaining', function(self)
        if self.professionInfo then
            local isPublic = self.orderType == Enum.CraftingOrderType.Public
            if isPublic and self.professionInfo and self.professionInfo.profession then
                WoWTools_ChineseMixin:SetLabelText(self.BrowseFrame.OrdersRemainingDisplay.OrdersRemaining, format('剩余订单：%s', C_CraftingOrders.GetOrderClaimInfo(self.professionInfo.profession).claimsRemaining))
            end
        end
    end)
    hooksecurefunc(frame, 'ShowGeneric', function(self)
        if self.BrowseFrame.OrderList.ResultsText:IsShown() then
            self.BrowseFrame.OrderList.ResultsText:SetText('没有发现订单')
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


    hooksecurefunc(frame.OrderView, 'UpdateStartOrderButton', function(self)--Blizzard_ProfessionsCrafterOrderView.lua
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


    frame.OrderView.OrderDetails.FulfillmentForm.NoteEditBox.ScrollingEditBox.defaultText= '在此输入消息'

    frame.OrderView.CompleteOrderButton:SetText('完成订单')
    frame.OrderView.StartRecraftButton:SetText('再造')
    frame.OrderView.StopRecraftButton:SetText('取消再造')
    frame.OrderView.DeclineOrderDialog.ConfirmationText:SetText('你确定想拒绝此订单吗？')
    frame.OrderView.DeclineOrderDialog.NoteEditBox.TitleBox.Title:SetText('拒绝原因：')
    frame.OrderView.DeclineOrderDialog.CancelButton:SetText('否')
    frame.OrderView.DeclineOrderDialog.ConfirmButton:SetText('是')

    --frame.OrderView.OrderDetails.SchematicForm.AllocateBestQualityCheckBox.text:SetText(LIGHTGRAY_FONT_COLOR:WrapTextInColorCode('使用最高品质材料'))



    hooksecurefunc(frame.OrderView, 'InitRegions', function(self)
        self.OrderDetails.FulfillmentForm.OrderCompleteText:SetText('订单完成！')
        self.DeclineOrderDialog:SetTitle('拒绝订单')
    end)

    frame.OrderView:HookScript('OnEvent', function(self, event, ...)
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

    hooksecurefunc(frame.OrderView, 'UpdateCreateButton', function(self)
        WoWTools_ChineseMixin:SetLabelText(self.CreateButton)
        local transaction = self.OrderDetails.SchematicForm.transaction
        local errorReason
        if Professions.IsRecipeOnCooldown(self.order.spellID) then
            errorReason = '配方冷却中。'
        elseif not transaction:HasMetAllRequirements() then
            errorReason = '你的材料不足。'
        elseif self.order.minQuality and self.OrderDetails.SchematicForm.Details:GetProjectedQuality() and self.order.minQuality > self.OrderDetails.SchematicForm.Details:GetProjectedQuality() then
            local smallIcon = true
            errorReason = format('此订单要求的最低品质是%s', Professions.GetChatIconMarkupForQuality(self.order.minQuality, smallIcon))
        end
        if errorReason then
            self.CreateButton:SetScript("OnEnter", function()
                GameTooltip:SetOwner(self.CreateButton, "ANCHOR_RIGHT")
                GameTooltip_AddErrorLine(GameTooltip, errorReason)
                GameTooltip:Show()
            end)
        end
    end)


    hooksecurefunc(frame.OrderView, 'SetOrder', function(self)
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








end






























--Blizzard_ProfessionsCraftingOutputLog.lua
local function Init_CraftingOutputLog()
    ProfessionsFrame.CraftingPage.CraftingOutputLog:SetTitle('制作成果')
    hooksecurefunc(ProfessionsCraftingOutputLogElementMixin, 'OnLoad', function(self)
        self.Multicraft.Text:SetText('"产能！')
        self.Resources.Text:SetText('节约了材料！')
        self.BonusCraft.Text:SetText('首次制造！')
    end)

    hooksecurefunc(ProfessionsCraftingOutputLogElementMixin, 'Init', function(self)
        local resultData = self:GetElementData()
        if not resultData then
            return
        end

        WoWTools_ChineseMixin:SetLabelText(self.ItemContainer.Text)

        if resultData.hasIngenuityProc and resultData.ingenuityRefund > 0 then
            self.ItemContainer.CritText:SetScript("OnEnter", function(text)
                GameTooltip:SetOwner(text, "ANCHOR_RIGHT")
                GameTooltip_AddHighlightLine(GameTooltip, '奇思')
                GameTooltip_AddNormalLine(GameTooltip, format('你获得了一次奇思突破，此次制造返还了|cnGREEN_FONT_COLOR:%d|r点专注。', resultData.ingenuityRefund))
                GameTooltip:Show()
            end)
        end

        if resultData.multicraft > 0 then
            self.Multicraft.Text:SetScript("OnEnter", function(text)
                GameTooltip:SetOwner(text, "ANCHOR_RIGHT")
                GameTooltip_AddHighlightLine(GameTooltip, '产能')
                local tooltipText = format('你的产能技能使你额外制作了|cnGREEN_FONT_COLOR:%d|r个物品。', resultData.multicraft)
                GameTooltip_AddNormalLine(GameTooltip, tooltipText)
                GameTooltip:Show()
            end)
        end

        self.Resources.Text:SetScript("OnEnter", function(text)
            GameTooltip:SetOwner(text, "ANCHOR_RIGHT")
            GameTooltip_AddHighlightLine(GameTooltip, '充裕')
            GameTooltip_AddNormalLine(GameTooltip, '你的充裕属性给了回报，你节约了一些材料。')
            GameTooltip:Show()
        end)
    end)
end













--Blizzard_ProfessionsRecipeCrafterDetails.lua
local function Init_Details_Stat()

    --ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.DifficultyStatLine.LeftLabel
    WoWTools_ChineseMixin:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.Label)--制做详情
    WoWTools_ChineseMixin:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.DifficultyStatLine.LeftLabel)--配方难度：
    WoWTools_ChineseMixin:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.StatLines.SkillStatLine.LeftLabel)--技能：
    hooksecurefunc(ProfessionsCrafterDetailsStatLineMixin, 'SetLabel', function(self, label)
        WoWTools_ChineseMixin:SetLabelText(self.LeftLabel, label)
    end)
    --WoWTools_ChineseMixin:HookLabel(ProfessionsFrame.CraftingPage.SchematicForm.Details.FinishingReagentSlotContainer.Label)--成品材料：

    --预期品质
    ProfessionsFrame.CraftingPage.SchematicForm.Details.QualityMeter.Center:SetScript("OnEnter", function(fill)
        local self= ProfessionsFrame.CraftingPage.SchematicForm.Details
		if not self.operationInfo then
			return
		end
		GameTooltip:SetOwner(fill, "ANCHOR_RIGHT")
		local atlasSize = 25
		local atlasMarkup = CreateAtlasMarkup(Professions.GetIconForQuality(self.QualityMeter.craftingQuality), atlasSize, atlasSize)
		local applyConcentration = self.transaction.IsApplyingConcentration and self.transaction:IsApplyingConcentration()
		local hasNextQuality = self.operationInfo.upperSkillTreshold > self.operationInfo.lowerSkillThreshold
		if hasNextQuality then
			atlasSize = 20
			local nextAtlasMarkup = CreateAtlasMarkup(Professions.GetIconForQuality(self.QualityMeter.craftingQuality + 1), atlasSize, atlasSize)
			if applyConcentration then
				GameTooltip_AddNormalLine(GameTooltip, format('|cnHIGHLIGHT_FONT_COLOR:预期品质：|r %s|n|n以目前的方式应用专注的话，可以确保你获得下一级品质：%s', nextAtlasMarkup, nextAtlasMarkup))
			else
				GameTooltip_AddNormalLine(GameTooltip, format('|cnHIGHLIGHT_FONT_COLOR:预期品质：|r%s|n|n根据当前的配方难度，达到%d点技能才能保证获得品质：%s', atlasMarkup, self.operationInfo.upperSkillTreshold, nextAtlasMarkup))
			end
		else
			GameTooltip_AddNormalLine(GameTooltip, format('|cnHIGHLIGHT_FONT_COLOR:期望品质：|r%s', atlasMarkup))
		end
        GameTooltip:Show()
    end)


end
























--Blizzard_ProfessionsRecipeReagentSlot.lua
local function Init_ReagentSlot()
    hooksecurefunc(ProfessionsReagentSlotMixin, 'UpdateAllocationText', function(self)
        local reagentSlotSchematic = self:GetReagentSlotSchematic()
        if not reagentSlotSchematic or not ProfessionsUtil.IsReagentSlotRequired(reagentSlotSchematic) then
            return
        end
        local foundIndex
        if ProfessionsUtil.IsReagentSlotModifyingRequired(reagentSlotSchematic) then
            if self:GetTransaction():IsModificationUnchangedAtSlotIndex(self:GetSlotIndex()) then
                return
            end
            for _, allocation in self:GetTransaction():EnumerateAllocations(reagentSlotSchematic.slotIndex) do
                assert(foundIndex == nil, "Cannot have multiple allocations within a modifying-required slot.")
                foundIndex = FindInTableIf(reagentSlotSchematic.reagents, function(reagent)
                    return Professions.CraftingReagentMatches(reagent, allocation.reagent)
                end)
            end

            if foundIndex == nil then
                return
            end
        else
             foundIndex = select(2, self:GetAllocationDetails())
        end

        local reagent = reagentSlotSchematic.reagents[foundIndex or 1]
        local reagentName
        if reagent.currencyID then
            local currencyInfo = C_CurrencyInfo.GetCurrencyInfo(reagent.currencyID)
            if currencyInfo and currencyInfo.name then
                reagentName= WoWTools_ChineseMixin:CN(currencyInfo.name)
            else
                reagentName= '未知'
            end
        else
            reagentName= WoWTools_ChineseMixin:GetItemName(reagent.itemID)
            if not reagentName then
                local item = Item:CreateFromItemID(reagent.itemID)
                local itemName= item:GetItemName()
                if itemName then
                    reagentName= WoWTools_ChineseMixin:CN(itemName)
                else
                    reagentName= '未知'
                end
            end
        end

        if reagentName then
            local quantity
            if self.overrideQuantity then
                quantity = self.overrideQuantity
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
            local quantityText = self.showOnlyRequired and reagentSlotSchematic.quantityRequired or ((quantity or 0)..'/'..(reagentSlotSchematic.quantityRequired or ''))
            self:SetNameText(format("%s %s", quantityText, reagentName))
        end
    end)
end

























local function Init_InspectRecipe()
    
end




















local function Init()
    Init_CraftingPage()
    Init_CraftingPage_SchematicForm()
    Init_SpecPage()
    Init_OrdersPage()
    Init_CraftingOutputLog()
    Init_Details_Stat()
    Init_ReagentSlot()
    hooksecurefunc(ProfessionsFrame, 'SetTitle', function(self, skillLineName)
        if WoWTools_ChineseMixin:CN(skillLineName) then
            skillLineName= WoWTools_ChineseMixin:CN(skillLineName)
            if C_TradeSkillUI.IsTradeSkillGuild() then
                self:SetTitleFormatted('公会%s"', skillLineName)
            else
                local linked, linkedName = C_TradeSkillUI.IsTradeSkillLinked()
                if linked and linkedName then
                    self:SetTitleFormatted("%s %s[%s]|r", format('%s', skillLineName), HIGHLIGHT_FONT_COLOR_CODE, linkedName)
                else
                    self:SetTitleFormatted('%s', skillLineName)
                end
            end
        elseif C_TradeSkillUI.IsTradeSkillGuild() then
            self:SetTitleFormatted('公会%s"', skillLineName)
        end
    end)



    hooksecurefunc(ProfessionsFrame, 'UpdateTabs', function(self)
        local recipesTab = self:GetTabButton(self.recipesTabID)
        WoWTools_ChineseMixin:SetCNFont(recipesTab.Text)
        recipesTab.Text:SetText('配方')

        recipesTab = self:GetTabButton(self.specializationsTabID)
        WoWTools_ChineseMixin:SetCNFont(recipesTab.Text)
        recipesTab.Text:SetText('专精')

        recipesTab = self:GetTabButton(self.craftingOrdersTabID )
        WoWTools_ChineseMixin:SetCNFont(recipesTab.Text)
        recipesTab.Text:SetText('制造订单')
    end)


     --目录，列表，标题
     ProfessionsFrame.CraftingPage.RecipeList.SearchBox.Instructions:SetText('搜索')
     --ProfessionsFrame.CraftingPage.RecipeList.FilterDropdown.Text:SetText('过滤器')
     hooksecurefunc(ProfessionsRecipeListCategoryMixin, 'Init', function(self, node)
        local info= node:GetData().categoryInfo
        if info then
            local name= WoWTools_ChineseMixin:GetTradeSkillCategoryName(info.categoryID) or WoWTools_ChineseMixin:CN(info.name)
            if name then
                self.Label:SetText(name)
            end
        end
    end)


    --列表，目录
    hooksecurefunc(ProfessionsRecipeListRecipeMixin, 'Init', function(self, node)
        local elementData = node:GetData()
        local recipeInfo = Professions.GetHighestLearnedRecipe(elementData.recipeInfo) or elementData.recipeInfo
        local name= WoWTools_ChineseMixin:GetRecipeName(recipeInfo, nil)
        if name then
            self.Label:SetText(name)
        end
    end)


    --Blizzard_ProfessionsInspectRecipe.lua InspectRecipeMixin
    WoWTools_ChineseMixin:SetLabelText(InspectRecipeFrame.SchematicForm.Reagents.Label)
    hooksecurefunc(InspectRecipeFrame, 'Open', function(self, recipeID)
        local data = C_TradeSkillUI.GetProfessionInfoByRecipeID(recipeID) or {}
        local name
        if data.professionName then
            name= WoWTools_ChineseMixin:GetTradeSkillCategoryName(data.professionID) or WoWTools_ChineseMixin:CN(data.professionName)
        elseif data.parentProfessionName then
            name= WoWTools_ChineseMixin:GetTradeSkillCategoryName(data.parentProfessionID) or WoWTools_ChineseMixin:CN(data.parentProfessionName)
        end
        if name then
            self:SetTitle(name)
        end
    end)
end



--Blizzard_ProfessionsRecipeFlyout.lua
--ProfessionsItemFlyoutMixin:OnLoad()













 





EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_Professions' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)