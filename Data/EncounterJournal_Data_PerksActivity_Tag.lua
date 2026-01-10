--[[
[ID]= DisplayName_lang
https://warcraft.wiki.gg/wiki/API_C_PerksProgram.GetCategoryInfo

https://wago.tools/db2/PerksVendorCategory?locale=zhCN
]]

local categoryTab={
    [1]= '幻化',
    [2]= '坐骑',
    [3]= '宠物',
    [5]= '玩具',
    [6]= '自定义选项',
    [8]= '幻化套装',
}



--[[
https://wago.tools/db2/PerksActivityTag?locale=zhCN
[ID]= 'TagName_lang',
]]
local PerksActivityTag={
[34]= "至暗之夜",
[33]= "军团再临：幻境新生",
[23]= "霸业风暴",
[22]= "经典旧世",
[21]= "周年庆典",
[20]= "潘达利亚：幻境新生",
[19]= "地心之战",
[18]= "暗影国度",
[17]= "争霸艾泽拉斯",
[16]= "世界",
[15]= "大地的裂变",
[14]= "巫妖王之怒",
[13]= "燃烧的远征",
[12]= "熊猫人之谜",
[11]= "收集品",
[10]= "军团再临",
[9]= "德拉诺之王",
[8]= "特殊",
[7]= "节日和事件",
[6]= "宠物对战",
[5]= "专业",
[4]= "巨龙时代",
[3]= "地下城和团队副本",
[2]= "PvP",
[1]= "任务",
}

do
    local tags= C_PerksActivities.GetAllPerksActivityTags()
    if tags and tags.tagName then
        for index, name in pairs(tags.tagName) do
            local cnName= PerksActivityTag[index]
            if name and cnName then
                WoWTools_ChineseMixin:SetCN(name, cnName)
            end
        end
    end
    for categoryID, name in pairs(categoryTab) do
        local data= C_PerksProgram.GetCategoryInfo(categoryID)
        if data then
            WoWTools_ChineseMixin:SetCN(data.displayName, name)
        end
    end
end
PerksActivityTag=nil
categoryTab=nil