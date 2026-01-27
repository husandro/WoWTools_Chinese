
--公会银行
function WoWTools_ChineseMixin.Frames:BankFrame()

    self:SetFrame(BankPanel.PurchasePrompt, nil, true)
    self:SetLabel(BankPanel.PurchasePrompt.TabCostFrame.TabCost)
    self:SetButton(BankPanel.PurchasePrompt.TabCostFrame.PurchaseButton)
    self:SetButton(BankPanel.MoneyFrame.WithdrawButton)
    self:SetButton(BankPanel.MoneyFrame.DepositButton)
    self:HookButton(BankPanel.AutoDepositFrame.DepositButton)
    self:HookLabel(BankPanel.AutoDepositFrame.IncludeReagentsCheckbox.Text)

    self:SetFrame(BankPanel.TabSettingsMenu.DepositSettingsMenu)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignEquipmentCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignConsumablesCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignProfessionGoodsCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignReagentsCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.AssignJunkCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.IgnoreCleanUpCheckbox.Text)
    self:HookLabel(BankPanel.TabSettingsMenu.DepositSettingsMenu.ExpansionFilterDropdown.Text)

    self:HookLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription)
    self:SetLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
    self:HookLabel(BankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)
    self:SetLabel(BankPanel.TabSettingsMenu.BorderBox.IconDragArea.IconDragAreaContent.IconDragText)

    self:SetButton(BankPanel.TabSettingsMenu.BorderBox.OkayButton)
    self:SetButton(BankPanel.TabSettingsMenu.BorderBox.CancelButton)

    self:HookLabel(BankCleanUpConfirmationPopup.Text)
    self:SetLabel(BankCleanUpConfirmationPopup.HidePopupCheckbox.Label)
    self:SetButton(BankCleanUpConfirmationPopup.AcceptButton)
    self:SetButton(BankCleanUpConfirmationPopup.CancelButton)

    self:HookLabel(BankPanel.LockPrompt.PromptText)

    if WoWTools_BankMixin then
        return
    end

    self:SetLabel(BankPanel.TabSettingsMenu.BorderBox.IconSelectionText)


    for _, btn in pairs(BankFrame.TabSystem.tabs) do--TabSystemMixin
       self:SetButton(btn)
    end
    self:HookLabel(BankFrameTitleText)
end




--AlertFrameSystems.lua AlertFrames.xml
function WoWTools_ChineseMixin.Frames:AlertFrame()
    hooksecurefunc('GuildChallengeAlertFrame_SetUp', function(frame)
        self:SetLabe(frame.Type)
    end)
    hooksecurefunc('DungeonCompletionAlertFrame_SetUp', function(frame)
        self:SetLabe(frame.instanceName)
    end)
    hooksecurefunc('ScenarioAlertFrame_SetUp', function(frame)
        self:SetLabe(frame.dungeonName)
    end)
    hooksecurefunc('ScenarioLegionInvasionAlertFrame_SetUp', function(frame)
        self:SetLabe(frame.ZoneName)
    end)
    hooksecurefunc('AchievementAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Name)
        self:SetLabel(frame.Unlocked)
    end)
    hooksecurefunc('CriteriaAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Name)
    end)
    hooksecurefunc('LootUpgradeFrame_SetUp', function(frame)
        WoWTools_ItemMixin:SetItemStats(frame, frame.hyperlink, {point=frame.Icon})
    end)
    hooksecurefunc('LootWonAlertFrame_SetUp', function(frame, originalLink, originalQuantity, rollType, roll, specID, isCurrency, showFactionBG, lootSource)
        self:SetLabel(frame.Label)
	    local itemName, itemTexture, quantity, itemRarity, itemLink = ItemUtil.GetItemDetails(originalLink, originalQuantity, isCurrency, lootSource)
        local cn= self:GetItemName(nil, itemLink) or self:CN(itemName)
        if cn then
            frame.ItemName:SetText(cn)
        end
    end)
    hooksecurefunc('LootUpgradeFrame_SetUp', function(frame, itemLink, quantity, specID, baseQuality)
        local itemName, itemHyperLink, itemRarity, _, _, _, _, _, _, itemTexture = C_Item.GetItemInfo(itemLink)
        local cn= self:GetItemName(nil, itemLink) or self:CN(itemName)
        if cn then
            cn= cn:match('|c........(.-)|r') or cn
            frame.BaseQualityItemName:SetText(cn);
            frame.UpgradeQualityItemName:SetText(cn);
            frame.WhiteText:SetText(cn);
            frame.WhiteText2:SetText(cn);
        end
        if itemRarity then
            frame.TitleText:SetText(format('奖励升级为%s品质！', self:CN(_G["ITEM_QUALITY"..itemRarity.."_DESC"])))
        end
    end)

    hooksecurefunc('DigsiteCompleteToastFrame_SetUp', function(frame)
        self:SetLabel(frame.DigsiteType)
    end)
    hooksecurefunc('EntitlementDeliveredAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Title)
    end)
    hooksecurefunc('GarrisonMissionAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Name)
        self:SetLabel(frame.Title)
    end)
    hooksecurefunc('GarrisonCommonFollowerAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Name)
    end)
    hooksecurefunc('GarrisonFollowerAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Title)
    end)
    hooksecurefunc('GarrisonShipFollowerAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Title)
    end)
    hooksecurefunc('GarrisonTalentAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Title)
    end)
    hooksecurefunc('NewRecipeLearnedAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Title)
        self:SetLabel(frame.Name)
    end)
    hooksecurefunc('WorldQuestCompleteAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.QuestName)
        self:SetLabel(frame.ToastText)
    end)
    hooksecurefunc('LegendaryItemAlertFrame_SetUp', function(frame, itemLink)
        local cn= self:GetItemName(nil, itemLink)
        if cn then
             cn= cn:match('|c........(.-)|r') or cn
             frame.ItemName:SetText(cn)
        end
    end)
    hooksecurefunc('MonthlyActivityAlertFrame_SetUp', function(frame)
        self:SetLabel(frame.Name)
    end)
end





--AlertFrameSystems.lua
hooksecurefunc(ItemAlertFrameMixin, 'SetUpDisplay', function(frame, icon, itemQuality, name, label, overlayAtlas)
    local cn= self:GetItemName(frame.itemID, frame.itemLink) or self:CN(name)
    if cn then
        cn= cn:match('|c........(.-)|r') or cn
        local colorData = ColorManager.GetColorDataForItemQuality(itemQuality);
        if colorData then
            cn = colorData.hex..cn.."|r"
        end
        frame.Name:SetText(cn)
    else
        self:SetLabel(frame.Name)
    end
    self:SetLabel(frame.Label)
end)
hooksecurefunc(SkillLineSpecsUnlockedAlertFrameMixin, 'SetUp', function(frame)
    self:SetLabel(frame.Title)
end)










function WoWTools_ChineseMixin.Frames:CatalogShopFrame()--Blizzard_CatalogShop
    self:SetLabel(CatalogShopFrameTitleText)
    self:SetLabel(CatalogShopFrame.HeaderFrame.SearchBox.Instructions)

    self:SetButton(CatalogShopFrame.CatalogShopDetailsFrame.ButtonContainer.DetailsButton)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.ProductType)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.ProductName)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.ProductDescription)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.LegalDisclaimerText)
    self:SetButton(CatalogShopFrame.ProductDetailsContainerFrame.BackButton)

    self:HookLabel(CatalogShopFrame.ProductDetailsContainerFrame.DetailsProductContainerFrame.ProductsHeader.ProductName)
    self:HookLabel(CatalogShopFrame.ProductDetailsContainerFrame.DetailsProductContainerFrame.ProductsHeader.ProductDescription)
end




--屏幕，上方区域提示
function WoWTools_ChineseMixin.Frames:ZoneTextFrame()
    ZoneTextFrame:HookScript('OnEvent', function()--ZoneText_OnEvent
        WoWTools_ChineseMixin:SetLabel(SubZoneTextString)
        WoWTools_ChineseMixin:SetLabel(ZoneTextString)
    end)

    hooksecurefunc('SetZoneText', function()
        local pvpType, isSubZonePvP, factionName = C_PvP.GetZonePVPInfo()
        local pvpTextString = PVPInfoTextString
        if ( isSubZonePvP ) then
            pvpTextString = PVPArenaTextString
        end
        if ( pvpType == "sanctuary" ) then
            pvpTextString:SetText('（安全区域）')
        elseif ( pvpType == "arena" ) then
            pvpTextString:SetText('（PvP区域）')
        elseif ( pvpType == "friendly" or  pvpType == "hostile" ) then
            if (factionName and factionName ~= "") then
                pvpTextString:SetFormattedText('（%s领地）', WoWTools_ChineseMixin:CN(factionName) or factionName)
            end
        elseif ( pvpType == "contested" ) then
            pvpTextString:SetText('（争夺中的领土）')
        elseif ( pvpType == "combat" ) then
            PVPArenaTextString:SetText('（战斗区域）')
        end
    end)

--ZoneText.lua
    hooksecurefunc('AutoFollowStatus_OnEvent', function(self, event, ...)
        if ( event == "AUTOFOLLOW_BEGIN" ) then
            AutoFollowStatusText:SetFormattedText('正在跟随%s', self.unit)
        end
        if ( event == "AUTOFOLLOW_END" ) then
            AutoFollowStatusText:SetFormattedText('已停止跟随%s。', self.unit)
        end
    end)
end







--地图图例
function WoWTools_ChineseMixin.Frames:MapLegendScrollFrame()
    for _, layout in pairs(MapLegendScrollFrame.ScrollChild:GetLayoutChildren() or {}) do
        self:SetLabel(layout.TitleText)
        for _, text in pairs(layout:GetLayoutChildren() or {}) do
            self:SetLabel(text, text.nameText)
        end
    end

--MapLegendMixin
    local QuestsCategoryData = {
        {Name = MAP_LEGEND_CAMPAIGN,   Tooltip = MAP_LEGEND_CAMPAIGN_TOOLTIP},
        {Name = MAP_LEGEND_IMPORTANT,  Tooltip = MAP_LEGEND_IMPORTANT_TOOLTIP},
        {Name = MAP_LEGEND_LEGENDARY,  Tooltip = MAP_LEGEND_LEGENDARY_TOOLTIP},
        {Name = MAP_LEGEND_META,       Tooltip = MAP_LEGEND_META_TOOLTIP},
        {Name = MAP_LEGEND_REPEATABLE, Tooltip = MAP_LEGEND_REPEATABLE_TOOLTIP},
        {Name = MAP_LEGEND_LOCALSTORY, Tooltip = MAP_LEGEND_LOCALSTORY_TOOLTIP},
        {Name = MAP_LEGEND_INPROGRESS, Tooltip = MAP_LEGEND_INPROGRESS_TOOLTIP},
        {Name = MAP_LEGEND_TURNIN,     Tooltip = MAP_LEGEND_TURNIN_TOOLTIP}
    }
    local LimitedCategoryData = {
        {Name = MAP_LEGEND_WORLDQUEST,     Tooltip = MAP_LEGEND_WORLDQUEST_TOOLTIP},
        {Name = MAP_LEGEND_WORLDBOSS,      Tooltip = MAP_LEGEND_WORLDBOSS_TOOLTIP},
        {Name = MAP_LEGEND_BONUSOBJECTIVE, Tooltip = MAP_LEGEND_BONUSOBJECTIVE_TOOLTIP},
        {Name = MAP_LEGEND_EVENT,          Tooltip = MAP_LEGEND_EVENT_TOOLTIP},
        {Name = MAP_LEGEND_RARE,           Tooltip = MAP_LEGEND_RARE_TOOLTIP},
        {Name = MAP_LEGEND_RAREELITE,      Tooltip = MAP_LEGEND_RAREELITE_TOOLTIP},
    }
    local ActivitiesCategoryData = {
        {Name = MAP_LEGEND_DUNGEON,   Tooltip = MAP_LEGEND_DUNGEON_TOOLTIP},
        {Name = MAP_LEGEND_RAID,      Tooltip = MAP_LEGEND_RAID_TOOLTIP},
        {Name = MAP_LEGEND_HUB,       Tooltip = MAP_LEGEND_HUB_TOOLTIP},
        {Name = MAP_LEGEND_DIGSITE,   Tooltip = MAP_LEGEND_DIGSITE_TOOLTIP},
        {Name = MAP_LEGEND_PETBATTLE, Tooltip = MAP_LEGEND_PETBATTLE_TOOLTIP},
        {Name = MAP_LEGEND_DELVE,		Tooltip = MAP_LEGEND_DELVE_TOOLTIP},
    }
    local MovementCategoryData = {
        {Name = MAP_LEGEND_TELEPORT,     Tooltip = MAP_LEGEND_TELEPORT_TOOLTIP,},
        {Name = MAP_LEGEND_CAVE,         Tooltip = MAP_LEGEND_CAVE_TOOLTIP},
        {Name = MAP_LEGEND_FLIGHTPOINT,  Tooltip = MAP_LEGEND_FLIGHTPOINT_TOOLTIP},
    }
    local MapLegendData = {
        {CategoryTitle = MAP_LEGEND_CATEGORY_QUESTS,      CategoryData = QuestsCategoryData},
        {CategoryTitle = MAP_LEGEND_CATEGORY_LTA,         CategoryData = LimitedCategoryData},
        {CategoryTitle = MAP_LEGEND_CATEGORY_ACTIVITIES,  CategoryData = ActivitiesCategoryData},
        {CategoryTitle = MAP_LEGEND_CATEGORY_MOVEMENT,    CategoryData = MovementCategoryData},
    }
    do
        for _, data in pairs(MapLegendData) do
            local frame=_G[data.CategoryTitle]
            if frame then
                self:SetLabel(frame.TitleText, data.CategoryTitle)
            end
            for _, categoryData in ipairs(data.CategoryData) do
                local btn=_G[categoryData.Name]
                if btn then
                    self:SetLabel(btn, categoryData.Name)
                    local tooltip= self:CN(categoryData.Tooltip)
                    if tooltip then
                        btn.tooltipText= tooltip
                    end
                end
            end
        end
    end
    QuestsCategoryData = nil
    LimitedCategoryData = nil
    ActivitiesCategoryData = nil
    MovementCategoryData = nil
    MapLegendData = nil
end



function WoWTools_ChineseMixin.Frames:DressUpFrame()
    self:HookLabel(DressUpFrameCustomSetDropdown.Text)
    self:SetLabel(DressUpFrameTitleText)
    self:SetButton(DressUpFrameCustomSetDropdown.SaveButton)
    self:SetButton(DressUpFrame.LinkButton)
    self:SetButton(DressUpFrameResetButton)
    self:SetButton(DressUpFrameCancelButton)

    hooksecurefunc(DressUpCustomSetDetailsSlotMixin, 'SetDetails', function(frame, transmogID)--, icon, name, useSmallIcon, slotState, isHiddenVisual)
        local itemID= frame.item and frame.item:GetItemID()
        local cn= itemID and WoWTools_ChineseMixin:GetItemName(itemID)

        if not cn and transmogID then
            local illusionInfo = C_TransmogCollection.GetIllusionInfo(transmogID)
            if illusionInfo then
                local name= self:CN(C_TransmogCollection.GetIllusionStrings(illusionInfo.sourceID))
                if name then
                    cn= format('幻象：%s', name)
                end
            end
        end
        if cn then
            cn= cn:gsub('|c........', '')
            cn= cn:gsub('|r', '')
            frame.Name:SetText(cn)
        else
            self:SetLabel(frame.Name)
        end
    end)

    hooksecurefunc(DressUpCustomSetDetailsSlotMixin, 'SetAppearance', function(frame, slotID, transmogID, isSecondary)
        local itemID = C_TransmogCollection.GetSourceItemID(transmogID);
        if not itemID then
            if isSecondary then
                return
            end
            local slotName = TransmogUtil.GetSlotName(slotID);
            local cn= self:CN(_G[slotName])
            if cn then
                frame.Name:SetFormattedText('(%s)', cn);
            end
        end
    end)
end