--[[
function HousingCatalogDecorEntryMixin:GetEntryData()
	-- Overrides HousingCatalogEntryMixin.

	local tryGetOwnedInfo = false;
	return self:IsBundleItem() and 
    
    C_HousingCatalog.GetCatalogEntryInfoByRecordID(Enum.HousingCatalogEntryType.Decor, self.bundleItemInfo.decorID, tryGetOwnedInfo)
    or HousingCatalogEntryMixin.GetEntryData(self);
end
]]


--[[
https://wago.tools/db2/DecorCategory?locale=zhCN
[ID]= Name_lang
]]
local category={
[18] = "全部",
[17] = "推荐",
[9] = "房间",
[8] = "杂项",
[6] = "自然",
[5] = "功能",
[4] = "照明",
[3] = "点缀",
[2] = "构造",
[1] = "家具",
}


--[[
https://wago.tools/db2/DecorSubcategory?locale=zhCN
[ID]= "Name_lang",
]]
local subCategory= {

[51]= "其他功能",
[35]= "房间 - 全部",
[34]= "杂项 - 全部",
[29]= "其他自然",
[28]= "地被植物",
[27]= "灌木",
[26]= "小型植物",
[25]= "大型植物",
[22]= "效能",
[21]= "其他照明",
[20]= "环境照明",
[19]= "小型灯具",
[18]= "吊灯",
[17]= "墙壁灯具",
[16]= "大型灯具",
[15]= "其他点缀",
[14]= "地板",
[13]= "食物和饮料",
[12]= "壁挂",
[11]= "观赏",
[10]= "其他构造",
[9]= "大型构造",
[8]= "窗户",
[7]= "其他家具",
[6]= "储物",
[5]= "桌台",
[4]= "墙壁与立柱",
[3]= "门",
[2]= "床铺",
[1]= "座椅",
}


--[[
https://wago.tools/db2/HouseTheme?locale=zhCN
[ID] = "Name_lang",
]]
local theme= {

[28] = "亮色银月城",
[27] = "亮色贝拉梅斯",
[26] = "亮色粗犷",
[20] = "亮色民间",
[13] = "暗色银月城",
[12] = "中等银月城",
[11] = "暗色贝拉梅斯",
[10] = "中等贝拉梅斯",
[9] = "暗色粗犷",
[8] = "中等粗犷",
[7] = "暗色民间",
[6] = "中等民间",
[5] = "银月城",
[4] = "贝拉梅斯",
[3] = "通用",
[2] = "粗犷",
[1] = "民间",
}
do
    for id, cn in pairs(category) do
        local data= C_HousingCatalog.GetCatalogCategoryInfo(id)
        if data then
            WoWTools_ChineseMixin:SetCN(data.name, cn)
        end
    end
end
category= nil

do
    for id, cn in pairs(subCategory) do
        local data= C_HousingCatalog.GetCatalogSubcategoryInfo(id)
        if data then
            WoWTools_ChineseMixin:SetCN(data.name, cn)
        end
    end
end
subCategory= nil

do
    for id, cn in pairs(theme) do
        WoWTools_ChineseMixin:SetCN(C_HousingCustomizeMode.GetThemeSetInfo(id), cn)
    end
end
theme= nil
