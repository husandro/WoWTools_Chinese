--[[
职业
https://wago.tools/db2/ChrClasses?locale=zhCN
]]
local tab= {

[1] ='战士',
[2] ='圣骑士',
[3] ='猎人',
[4] ='潜行者',
[5] ='牧师',
[6] ='死亡骑士',
[7] ='萨满祭司',
[8] ='法师',
[9] ='术士',
[10] ='武僧',
[11] ='德鲁伊',
[12] ='恶魔猎手',
[13] ='唤魔师',
[14] ='冒险者',

}

do
    for classID, cn in pairs(tab) do
        WoWTools_ChineseMixin:SetText(UnitClass(classID), cn)
    end
end
tab=nil