--[[
function HousingCatalogDecorEntryMixin:GetEntryData()
	-- Overrides HousingCatalogEntryMixin.

	local tryGetOwnedInfo = false;
	return self:IsBundleItem() and C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, self.bundleItemInfo.decorID, tryGetOwnedInfo) or HousingCatalogEntryMixin.GetEntryData(self);
end
]]