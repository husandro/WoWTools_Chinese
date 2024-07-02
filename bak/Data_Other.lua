local id, e = ...
if e.Not_Is_EU then return end

--[[
specTab=nil
raceTab=nil
]]









































local specTab={
    {71, '武器'}, {72, '狂怒'}, {73, '防护'},
    {65, '神圣'}, {66, '防护'}, {70, '惩戒'},
    {250, '鲜血'}, {251, '冰霜'}, {252, '邪恶'},
    {253, '野兽控制'}, {254, '射击'}, {255, '生存'},
    {102, '平衡'}, {103, '野性'}, {104, '守护'}, {105, '恢复'},
    {262, '元素'}, {263, '增强'}, {264, '恢复'},
    {259, '奇袭'}, {260, '狂徒'}, {261, '敏锐'},
    {268, '酒仙'}, {270, '织雾'}, {269, '踏风'},
    {265, '痛苦'}, {266, '恶魔学识'}, {267, '毁灭'},
    {62, '奥术'}, {63, '火焰'}, {64, '冰霜'},
    {577, '浩劫'}, {581, '复仇'},
    {256, '戒律'}, {257, '神圣'}, {258, '暗影'},
    {1467, '湮灭'}, {1468, '恩护'}, {1473, '增辉'},
    --{, ''}, {, ''}, {, ''},
}



local raceTab={
    [1] = "人类",
    [2] = "兽人",
    [3] = "矮人",
    [4] = "暗夜精灵",
    [5] = "亡灵",
    [6] = "牛头人",
    [7] = "侏儒",
    [8] = "巨魔",
    [9] = "地精",
    [10] = "血精灵",
    [11] = "德莱尼",
    [22] = "狼人",
    [24] = "熊猫人",
    [25] = "熊猫人",
    [26] = "熊猫人",
    [27] = "夜之子",
    [28] = "至高岭牛头人",
    [29] = "虚空精灵",
    [30] = "光铸德莱尼",
    [31] = "赞达拉巨魔",
    [32] ="库尔提拉斯人",
    [34] = "黑铁矮人",
    [35] = "狐人",
    [36] = "玛格汉兽人",
    [37] = "机械侏儒",
    [52] = "龙希尔",
    [70] = "龙希尔",
}




























    for _, info in pairs(specTab) do
        local name, desc, _, role= select(2, GetSpecializationInfoByID(info[1]))
        if name and info[2] then
            e.strText[name]= info[2]..(e.Icon[role] or '')
        end
        if desc and info[3] and desc~='' then
            e.strText[desc]= info[3]
        end
    end

    for raceID, name in pairs(raceTab) do
        local info = C_CreatureInfo.GetRaceInfo(raceID) or {}
        if info.clientFileString and info.clientFileString~='' then
            e.strText[info.clientFileString]= name
        end
    end




   

   








    e.strText[GetClassInfo(13)] = "|cff33937f唤魔师|r"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE)] = "|TInterface\\FriendsFrame\\StatusIcon-Online:16:16|t 有空"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY)] = "|TInterface\\FriendsFrame\\StatusIcon-Away:16:16|t 离开"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY)] = "|TInterface\\FriendsFrame\\StatusIcon-DnD:16:16|t 忙碌"


