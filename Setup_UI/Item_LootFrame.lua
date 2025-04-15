


--LootFrame.lua
WoWTools_ChineseMixin:SetLabel(LootFrameTitleText)

--[[hooksecurefunc(LootFrameItemElementMixin, 'Init', function(self)
    local elementData = self:GetElementData() or {}
    if elementData.quality then
        WoWTools_ChineseMixin:SetLabel(self.QualityText, _G[format("ITEM_QUALITY%s_DESC", elementData.quality)])
    end
end)]]

hooksecurefunc(LootFrameElementMixin, "Init", function(self, ...)
    local slotIndex = self:GetSlotIndex();
    local name
	local texture, item, quantity, currencyID, itemQuality = GetLootSlotInfo(slotIndex);
	if currencyID then
		item = CurrencyContainerUtil.GetCurrencyContainerInfo(currencyID, quantity, item, texture, itemQuality);
        name= WoWTools_ChineseMixin:CN(item)
    else
        local itemLink	= GetLootSlotLink(slotIndex);
        if itemLink then
            local itemID
            itemID = string.match(itemLink, 'Hitem:(%d+):')
            itemID= tonumber(itemID)
            name = WoWTools_ChineseMixin:GetItemName(itemID)
        end
	end
    if name then
        self.Text:SetText(name)
    end
    WoWTools_ChineseMixin:SetLabel(self.QualityText)
end)