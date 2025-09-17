function WoWTools_ChineseMixin.Events:Blizzard_FrameXML()
    --boss掉落，物品, 可能，会留下 StaticPopup1 框架
    hooksecurefunc('BossBanner_ConfigureLootFrame', function(lootFrame, data)--LevelUpDisplay.lua data= { itemID = itemID, quantity = quantity, playerName = playerName, className = className, itemLink = itemLink }
        --local itemName, itemLink, itemRarity, _, _, _, _, _, _, itemTexture, _, _, _, _, _, setID = C_Item.GetItemInfo(data.itemLink)
        local itemName= self:GetItemName(data.itemID)
        if itemName then
	        lootFrame.ItemName:SetText(itemName);
        end
    end)

--拾取时, 弹出, 物品提示，信息, 战利品
    hooksecurefunc('DungeonCompletionAlertFrameReward_SetRewardItem', function(frame, itemLink)
        WoWTools_ItemMixin:SetItemStats(frame, frame.itemLink or itemLink , {point=frame.texture})
    end)

    hooksecurefunc('LegendaryItemAlertFrame_SetUp', function(frame)
        WoWTools_ItemMixin:SetItemStats(frame, frame.hyperlink, {point= frame.Icon})
    end)

    hooksecurefunc(LootItemExtendedMixin, 'Init', function(frame, itemLink2, originalQuantity, _, isCurrency)--ItemDisplay.lua
        local _, _, _, _, itemLink = ItemUtil.GetItemDetails(itemLink2, originalQuantity, isCurrency)
        WoWTools_ItemMixin:SetItemStats(frame, itemLink, {point= frame.Icon})
    end)

--新, 选项面板，常用
    hooksecurefunc(NewFeatureLabelMixin, 'OnLoad', function(frame)
        local cn= self:CN(frame.label)
        if cn then
            frame.label= cn
        	frame.BGLabel:SetTextToFit(frame.label);
            frame.Label:SetTextToFit(frame.label);
        end
    end)

--AchievementDisplayFrame.lua
    hooksecurefunc(AchievementDisplayMixin, 'SetTitle', function(frame, title)
        self:SetLabel(frame.Title, title)
    end)

    hooksecurefunc(AchievementDisplayMixin, 'SetAchievements', function(frame)
        for btn in frame.bulletPool:EnumerateActive() do
            self:SetLabel(btn.Text)
        end
    end)

    hooksecurefunc(AchievementDisplayOverviewBulletMixin, 'Setup', function(frame)
        self:SetLabel(frame.Text)
    end)
end
