if not AccountStoreFrame then
    return
end




hooksecurefunc(AccountStoreFrame.CategoryList.ScrollBox, 'Update', function(frame)
    if not frame:GetView() then
        return
    end

    for _, btn in pairs(frame:GetFrames() or {}) do
        local categoryInfo = btn.categoryID and C_AccountStore.GetCategoryInfo(btn.categoryID)
        if categoryInfo then
            local name= WoWTools_ChineseMixin:GetData(categoryInfo.name)
            if name then
                btn.Text:SetText(name)
            end
        end
    end
end)

--Blizzard_AccountStoreCardTemplates.lua
hooksecurefunc(AccountStoreBaseCardMixin, 'SetItemID', function(self)
    local itemInfo= self.itemInfo
    if not itemInfo then
        return
    end

    local name= WoWTools_ChineseMixin:GetData(itemInfo.name)
    if name then
        self.Name:SetText(name)
    end

    local isOwned = (itemInfo.status == Enum.AccountStoreItemStatus.Owned) or (itemInfo.status == Enum.AccountStoreItemStatus.Refundable)
	local isRefundable = itemInfo.status == Enum.AccountStoreItemStatus.Refundable

	if isRefundable then
		self.BuyButton:SetText('退款')
	elseif isOwned then
		self.BuyButton:SetText('已经拥有')
	end

end)


hooksecurefunc(AccountStoreFrame.StoreDisplay, 'SetPage', function(self, page)
    local maxPage = self:GetMaxPage()
	page = Clamp(page, 1, maxPage)
	local items = {}
	local maxCardsPerPage = self.currentItemRack:GetMaxCards()
	for i = 1, page * maxCardsPerPage do
		local itemIndex = (page - 1) * maxCardsPerPage + i
		table.insert(items, self.categoryItems[itemIndex])
	end
	self.Footer.PageText:SetFormattedText('%d/%d页', page, maxPage)
end)
--[[
local function GenerateAccountStoreCategoryInfo(cardTemplate, maxCards)
	return {
		cardTemplate = cardTemplate,
		maxCards = maxCards
	};
end

local AccountStoreCategoryToInfo = {
	[Enum.AccountStoreCategoryType.Creature] = GenerateAccountStoreCategoryInfo("AccountStoreCreatureCardTemplate", 4),
	[Enum.AccountStoreCategoryType.TransmogSet] = GenerateAccountStoreCategoryInfo("AccountStoreTransmogSetCardTemplate", 2),
	[Enum.AccountStoreCategoryType.Mount] = GenerateAccountStoreCategoryInfo("AccountStoreMountCardTemplate", 1),
	[Enum.AccountStoreCategoryType.Icon] = GenerateAccountStoreCategoryInfo("AccountStoreIconCardTemplate", 4),
};


hooksecurefunc(AccountStoreItemRackMixin, 'SetCategoryType', function(self, categoryType)
    local categoryInfo = AccountStoreCategoryToInfo[categoryType]
    
	self.maxCards = categoryInfo.maxCards*2
end)]]