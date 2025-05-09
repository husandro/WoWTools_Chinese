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





--有男，女之分
    do
        local className, classFile, classID
        for id, cn in pairs(tab) do
            className, classFile= GetClassInfo(id)
            WoWTools_ChineseMixin:SetCN(className, cn)
            WoWTools_ChineseMixin:SetCN(classFile, cn)
        end
        className, classFile, classID=  UnitClass('player', 2)--男
        WoWTools_ChineseMixin:SetCN(classFile, tab[classID])
        WoWTools_ChineseMixin:SetCN(className, tab[classID])

        className, classFile, classID=  UnitClass('player', 3)--女
        WoWTools_ChineseMixin:SetCN(classFile, tab[classID])
        WoWTools_ChineseMixin:SetCN(className, tab[classID])
    end
    tab=nil