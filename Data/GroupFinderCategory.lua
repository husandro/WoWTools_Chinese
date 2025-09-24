--[[
[ID]= {"Name_lang", "Description_lang"},
https://wago.tools/db2/GroupFinderCategory?locale=zhCN
]]
local tab={
[121]= {"地下堡", "搜索地下堡，难度……"},
[113]= {"托加斯特", "搜索难度、区域……"},
[111]= {"海岛探险"},
[9]= {"评级战场"},
[8]= {"战场"},
[7]= {"竞技场练习赛"},
[6]= {"自定义"},
[5]= {"场景战役"},
[4]= {"竞技场"},
[3]= {"团队副本", "搜索团队副本、首领、难度……"},
[2]= {"地下城", "搜索钥匙等级、地下城……"},
[1]= {"任务", "搜索任务名称……"},
}
do
    for categoryID, info in pairs(tab) do
        local data = C_LFGList.GetLfgCategoryInfo(categoryID)
        if data then
            WoWTools_ChineseMixin:SetCN(data.name, info[1])
            WoWTools_ChineseMixin:SetCN(data.searchPromptOverride, info[2])
        end
    end
end
tab=nil