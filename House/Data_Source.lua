--住宅，物品来源， 数据来源 WoWTools_Chinese_Scanner 插件

local HouseSource = {
}


do
    local faction= UnitFactionGroup('player')
    for itemID, data in pairs(HouseSource) do
        local entryInfo = C_HousingCatalog.GetCatalogEntryInfoByItem(itemID, false)
        if entryInfo then
            WoWTools_ChineseMixin:SetCN(entryInfo.sourceText, data[faction])
        end
    end
end
HouseSource= nil