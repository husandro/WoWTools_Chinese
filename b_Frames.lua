
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

    self:HookLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconDescription)
    self:SetLabel(BankPanel.TabSettingsMenu.BorderBox.SelectedIconArea.SelectedIconText.SelectedIconHeader)
    self:HookLabel(BankPanel.TabSettingsMenu.BorderBox.EditBoxHeaderText)

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
    self:SetButton(CatalogShopFrame.CatalogShopDetailsFrame.ButtonContainer.DetailsButton)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.ProductType)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.ProductName)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.ProductDescription)
    self:HookLabel(CatalogShopFrame.CatalogShopDetailsFrame.LegalDisclaimerText)

    self:HookLabel(CatalogShopFrame.ProductDetailsContainerFrame.DetailsProductContainerFrame.ProductsHeader.ProductName)
    self:HookLabel(CatalogShopFrame.ProductDetailsContainerFrame.DetailsProductContainerFrame.ProductsHeader.ProductDescription)
    self:HookLabel(CatalogShopFrame.ProductDetailsContainerFrame.DetailsProductContainerFrame.ProductsHeader.LegalDisclaimerText)

    --[[if CatalogShopFrame.HeaderFrame.CatalogShopNavBar.NavButtonScrollBox:GetView() then
    
        for _, frame in pairs(CatalogShopFrame.HeaderFrame.CatalogShopNavBar.NavButtonScrollBox:GetFrames() or {}) do
            if frame.sectionInfo and frame.sectionInfo.ID then
                local info= C_CatalogShop.GetCategoryInfo(frame.sectionInfo.ID)
                local name = info and info.displayName
                local cn = name and (name:sub(1, 1):upper() .. name:sub(2):lower())
                cn = self:CN(cn)
                if cn then
                    info= frame.Label
                    for k, v in pairs(info or {}) do if v and type(v)=='table' then print('|cff00ff00---',k, '---STAR|r') for k2,v2 in pairs(v) do print('|cffffff00',k2,v2, '|r') end print('|cffff0000---',k, '---END|r') else print(k,v) end end print('|cffff00ff——————————|r')
                    print(cn , frame.Label)

                    --frame.Label:SetText(cn)
                end
            end
        end]]
end




--[[
function CatalogShopProductContainerFrameMixin:SetupProductHeaderFrame(headerData)
	-- Set up ProductsHeader
	if headerData.Name then
		self.ProductsHeader.ProductName:Show();
		self.ProductsHeader.ProductName:SetText(headerData.Name);
	else
		self.ProductsHeader.ProductName:Hide();
	end
	if headerData.Type then
		self.ProductsHeader.ProductType:Show();
		self.ProductsHeader.ProductType:SetText(headerData.Type);
	else
		self.ProductsHeader.ProductType:Hide();
	end
	if headerData.Description then
		self.ProductsHeader.ProductDescription:Show();
		self.ProductsHeader.ProductDescription:SetText(headerData.Description);
	else
		self.ProductsHeader.ProductDescription:Hide();
	end
	self.ProductsHeader.LegalDisclaimerText:SetShown(headerData.showLegal or false);

end

]]

EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function(owner)
    for name, func in pairs(WoWTools_ChineseMixin.Frames) do
        do
            if _G[name] then
                func(WoWTools_ChineseMixin)
            end
        end
        WoWTools_ChineseMixin.Frames[name]= nil
    end
    EventRegistry:UnregisterCallback('PLAYER_ENTERING_WORLD', owner)
end)

