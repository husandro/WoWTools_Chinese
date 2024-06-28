local id, e= ...
    





local function Init()
    hooksecurefunc(AuctionHouseFrame, 'UpdateTitle', function(self)
        local tab = PanelTemplates_GetSelectedTab(self)
        local title = '浏览拍卖'
        if tab == 2 then
            title = '发布拍卖'
        elseif tab == 3 then
            title = '拍卖'
        end
        self:SetTitle(title)
    end)


    --目录，列表
    hooksecurefunc('AuctionHouseFilterButton_SetUp', function(btn, info)        
        e.set(btn, info.name)
    end)

    AuctionHouseFrameBuyTab.Text:SetText('购买')
    AuctionHouseFrame.SearchBar.FilterButton:SetText('过滤器')


    hooksecurefunc(AuctionHouseFrame.BrowseResultsFrame.ItemList, 'SetState', function(self, state)
        if state == 1 then
            local searchResultsText = self.searchStartedFunc and select(2, self.searchStartedFunc())
            if searchResultsText== AUCTION_HOUSE_BROWSE_FAVORITES_TIP then
                self.ResultsText:SetText('小窍门：右键点击物品可以设置偏好。偏好的物品会在你打开拍卖行时立即出现。')
            end
        elseif state == 2 then
            self.ResultsText:SetText('未发现物品')
        end
    end)

    AuctionHouseFrameSellTab.Text:SetText('出售')
    AuctionHouseFrameAuctionsTab.Text:SetText('拍卖')
    AuctionHouseFrameAuctionsFrame.CancelAuctionButton:SetText('取消拍卖')
    AuctionHouseFrameAuctionsFrameAuctionsTab.Text:SetText('拍卖')
    AuctionHouseFrameAuctionsFrameBidsTab.Text:SetText('竞标')
    AuctionHouseFrameAuctionsFrameBidsTab.Text:SetText('竞标')
    hooksecurefunc(AuctionHouseFrame.BrowseResultsFrame.ItemList, 'SetDataProvider', function(self)
        if self.ResultsText and self.ResultsText:IsShown() then
            self.ResultsText:SetText('小窍门：右键点击物品可以设置偏好。偏好的物品会在你打开拍卖行时立即出现。')
        end
    end)

    AuctionHouseFrame.SearchBar.SearchButton:SetText('搜索')

    AuctionHouseFrame.ItemSellFrame.CreateAuctionLabel:SetText('开始拍卖')
    AuctionHouseFrame.ItemSellFrame.PostButton:SetText('创建拍卖')
    AuctionHouseFrame.ItemSellFrame.QuantityInput.Label:SetText('数量')
    AuctionHouseFrame.ItemSellFrame.DurationDropDown.Label:SetText('持续时间')
    AuctionHouseFrame.ItemSellFrame.Deposit.Label:SetText('保证金')
    AuctionHouseFrame.ItemSellFrame.TotalPrice.Label:SetText('总价')
    AuctionHouseFrame.ItemSellFrame.QuantityInput.MaxButton:SetText('最大数量')
    AuctionHouseFrame.ItemSellFrame.PriceInput.PerItemPostfix:SetText('每个物品')
    AuctionHouseFrame.ItemSellFrame.SecondaryPriceInput.Label:SetText('竞标价格')

    --Blizzard_AuctionHouseUI
    hooksecurefunc(AuctionHouseFrame.ItemSellFrame, 'SetSecondaryPriceInputEnabled', function(self, enabled)
        self.PriceInput:set('一口价')--AUCTION_HOUSE_BUYOUT_LABEL)
        if enabled then
            self.PriceInput:SetSubtext('|cff777777(可选)|r')--AUCTION_HOUSE_BUYOUT_OPTIONAL_LABEL
        end
    end)

    AuctionHouseFrame.CommoditiesSellFrame.CreateAuctionLabel:SetText('开始拍卖')
    AuctionHouseFrame.CommoditiesSellFrame.PostButton:SetText('创建拍卖')
    AuctionHouseFrame.CommoditiesSellFrame.QuantityInput.Label:SetText('数量')
    AuctionHouseFrame.CommoditiesSellFrame.PriceInput.Label:SetText('一口价')
    AuctionHouseFrame.CommoditiesSellFrame.DurationDropDown.Label:SetText('持续时间')
    AuctionHouseFrame.CommoditiesSellFrame.Deposit.Label:SetText('保证金')
    AuctionHouseFrame.CommoditiesSellFrame.TotalPrice.Label:SetText('总价')
    AuctionHouseFrame.CommoditiesSellFrame.QuantityInput.MaxButton:SetText('最大数量')
    AuctionHouseFrame.CommoditiesSellFrame.PriceInput.PerItemPostfix:SetText('每个物品')
    AuctionHouseFrame.ItemSellFrame.BuyoutModeCheckButton.Text:SetText('一口价')
    AuctionHouseFrame.ItemSellFrame.BuyoutModeCheckButton:HookScript('OnEnter', function()
        GameTooltip_AddNormalLine(GameTooltip, '取消勾选此项以允许对你的拍卖品进行竞拍。', true)
        GameTooltip:Show()
    end)

    --刷新，列表
    AuctionHouseFrame.CommoditiesBuyFrame.BackButton:SetText('返回')
    AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.BuyButton:SetText('一口价')
    AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.QuantityInput.Label:SetText('数量')
    AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.UnitPrice.Label:SetText('单价')
    AuctionHouseFrame.CommoditiesBuyFrame.BuyDisplay.TotalPrice.Label:SetText('总价')

    AuctionHouseFrame.ItemBuyFrame.BackButton:SetText('返回')
    AuctionHouseFrame.ItemBuyFrame.BidFrame.BidButton:SetText('竞标')
    AuctionHouseFrame.ItemBuyFrame.BuyoutFrame.BuyoutButton:SetText('一口价')

    AuctionHouseFrame.CommoditiesSellList.RefreshFrame.RefreshButton:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '刷新')
        GameTooltip:Show()
    end)
    AuctionHouseFrame.ItemSellList.RefreshFrame.RefreshButton:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '刷新')
        GameTooltip:Show()
    end)


    --Blizzard_AuctionHouseSharedTemplates.lua
    hooksecurefunc(AuctionHouseFrame.ItemSellList.RefreshFrame, 'SetQuantity', function(self, totalQuantity)
        if totalQuantity ~= 0 then
            self.TotalQuantity:SetFormattedText('可购买数量：|cnGREEN_FONT_COLOR:%s|r', e.MK(totalQuantity, 0))
        end
    end)
    hooksecurefunc(AuctionHouseFrame.CommoditiesSellList.RefreshFrame, 'SetQuantity', function(self, totalQuantity)
        if totalQuantity ~= 0 then
            self.TotalQuantity:SetFormattedText('可购买数量：|cnGREEN_FONT_COLOR:%s|r', e.MK(totalQuantity, 0))
        end
    end)
    hooksecurefunc(AuctionHouseFrame.ItemBuyFrame.BidFrame, 'SetPrice', function(self, minBid, isOwnerItem, isPlayerHighBid)
        if not (isPlayerHighBid or minBid == 0) then
            if minBid > GetMoney() then
                self.BidButton:SetDisableTooltip('你的钱不够')
            elseif isOwnerItem then
                self.BidButton:SetDisableTooltip('你不能购买自己的拍卖品')
            end
        end
    end)

    --Blizzard_AuctionHouseSellFrame.lua
    hooksecurefunc(AuctionHouseFrame.CommoditiesSellFrame, 'UpdatePostButtonState', function(self)
        local canPostItem, reasonTooltip = self:CanPostItem()
        if not canPostItem and reasonTooltip then
            if reasonTooltip== AUCTION_HOUSE_SELL_FRAME_ERROR_ITEM then
                self.PostButton:SetTooltip('没有选择物品')
            elseif reasonTooltip== AUCTION_HOUSE_SELL_FRAME_ERROR_DEPOSIT then
                self.PostButton:SetTooltip('你没有足够的钱来支付保证金')
            elseif reasonTooltip== AUCTION_HOUSE_SELL_FRAME_ERROR_QUANTITY then
                self.PostButton:SetTooltip('数量必须大于0')
            elseif reasonTooltip== ERR_GENERIC_THROTTLE then
                self.PostButton:SetTooltip('你太快了')
            end
        end
    end)
    hooksecurefunc(AuctionHouseFrame.ItemSellFrame, 'UpdatePostButtonState', function(self)
        local canPostItem, reasonTooltip = self:CanPostItem()
        if not canPostItem and reasonTooltip then
            if reasonTooltip== AUCTION_HOUSE_SELL_FRAME_ERROR_ITEM then
                self.PostButton:SetTooltip('没有选择物品')
            elseif reasonTooltip== AUCTION_HOUSE_SELL_FRAME_ERROR_DEPOSIT then
                self.PostButton:SetTooltip('你没有足够的钱来支付保证金')
            elseif reasonTooltip== AUCTION_HOUSE_SELL_FRAME_ERROR_QUANTITY then
                self.PostButton:SetTooltip('数量必须大于0')
            elseif reasonTooltip== ERR_GENERIC_THROTTLE then
                self.PostButton:SetTooltip('你太快了')
            end
        end
    end)


    AuctionHouseFrame.WoWTokenResults.Buyout:SetText('一口价')
    AuctionHouseFrame.WoWTokenResults.BuyoutLabel:SetText('一口价')
    AuctionHouseFrame.WoWTokenResults.HelpButton:HookScript('OnEnter', function()
        GameTooltip:AddLine('关于魔兽世界时光徽章')
        GameTooltip:Show()
    end)


    AuctionHouseFrame.BuyDialog.BuyNowButton:SetText('立即购买')
    AuctionHouseFrame.BuyDialog.CancelButton:SetText('取消')





    --Blizzard_AuctionHouseFrame.lua
    e.dia("BUYOUT_AUCTION", {text = '以一口价购买：', button1 = '接受', button2 = '取消',})
    e.dia("BID_AUCTION", {text = '出价为：', button1 = '接受', button2 = '取消',})

    e.dia("PURCHASE_AUCTION_UNIQUE", {text = '出价为：', button1 = '确定', button2 = '取消',})
    e.hookDia("PURCHASE_AUCTION_UNIQUE", 'OnShow', function(self, data)
        self.text:SetFormattedText('|cffffd200此物品属于“%s”。|n|n你同时只能装备一件拥有此标签的装备。|r', data.categoryName)
    end)

    e.dia("CANCEL_AUCTION", {text = '取消拍卖将使你失去保证金。', button1 = '接受', button2 = '取消'})
    e.hookDia("CANCEL_AUCTION", 'OnShow', function(self)
        local cancelCost = C_AuctionHouse.GetCancelCost(self.data.auctionID)
        if cancelCost > 0 then
            self.text:SetText('取消拍卖会没收你所有的保证金和：')
        else
            self.text:SetText('取消拍卖将使你失去保证金。')
        end
    end)

    e.dia("AUCTION_HOUSE_POST_WARNING", {text = NORMAL_FONT_COLOR:WrapTextInColorCode('拍卖行即将在已经预定的每周维护时间段中进行重大更新。|n|n如果你的拍卖品到时还未售出，你的物品会被提前退回，而且你会失去你的保证金。'), button1 = '接受', button2 = '取消',})
    e.dia("AUCTION_HOUSE_POST_ERROR", {text =  NORMAL_FONT_COLOR:WrapTextInColorCode('目前无法拍卖物品。|n|n拍卖行即将进行重大更新。'), button1 = '确定'})

    --Blizzard_AuctionHouseWoWTokenFrame.lua
    e.dia("TOKEN_NONE_FOR_SALE", {text = '目前没有可售的魔兽世界时光徽章。请稍后再来查看。', button1 = '确定'})
    e.dia("TOKEN_AUCTIONABLE_TOKEN_OWNED", {text = '你必须先将从商城购得的魔兽世界时光徽章售出后才能从拍卖行中购买新的徽章。', button1 = '确定'})
    
end















--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_AuctionHouseUI') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_AuctionHouseUI' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)
