--[[
职业
https://wago.tools/db2/ChrClasses?locale=zhCN
]]
local tab= {

WARRIOR ='战士',
PALADIN ='圣骑士',
HUNTER ='猎人',
ROGUE ='潜行者',
PRIEST ='牧师',
DEATHKNIGHT ='死亡骑士',
SHAMAN ='萨满祭司',
MAGE ='法师',
WARLOCK ='术士',
MONK ='武僧',
DRUID ='德鲁伊',
DEMONHUNTER ='恶魔猎手',
EVOKER ='唤魔师',
Adventurer ='冒险者',
TRAVELER= '旅行者',
}
do
    for name, en in pairs(LOCALIZED_CLASS_NAMES_MALE or {}) do
        WoWTools_ChineseMixin:SetCN(en, tab[name])
    end
    for name, en in pairs(LOCALIZED_CLASS_NAMES_FEMALE or {}) do
        WoWTools_ChineseMixin:SetCN(en, tab[name])
    end
end


--英文
do
    tab= {

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
    [15]= '旅行者',
    }
    for index, name in pairs({
        'Warrior',
        'Paladin',
        'Hunter',
        'Rogue',
        'Priest',
        'Death Knight',
        'Shaman',
        'Mage',
        'Warlock',
        'Monk',
        'Druid',
        'Demon Hunter',
        'Evoker',
        'Traveler'
    }) do
        WoWTools_ChineseMixin:SetCN(name,  tab[index])
    end
end

tab= nil