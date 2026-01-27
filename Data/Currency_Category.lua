--[[
    [ID]= "Name_lang",
https://wago.tools/db2/CurrencyCategory?locale=zhCN
]]
local tab={
[1]= "其它",
[2]= "PvP",
[3]= "未使用",
[4]= "经典旧世",
[21]= "巫妖王之怒",
[22]= "地下城与团队副本",
[23]= "燃烧的远征",
[81]= "大地的裂变",
[82]= "考古学",
[89]= "征服点数变量",
[133]= "熊猫人之谜",
[137]= "德拉诺之王",
[141]= "军团再临",
[143]= "争霸艾泽拉斯",
[144]= "虚拟",
[245]= "暗影国度",
[250]= "巨龙时代",
[257]= "旧版",
[260]= "地心之战",
[263]= "第2赛季",
[264]= "至暗之夜",
[265]= "第3赛季",
[266]= "时空奔行",
[268]= "第1赛季",
}

do
    for id, name in pairs(tab) do
        local info= C_CurrencyInfo.GetPlayerCurrencyCategoryInfo(id)
        if info then
            WoWTools_ChineseMixin:SetCN(info.categoryName, name)
        end
    end
end
tab= nil