local id, e = ...
if e.Not_Is_EU then return end

--[[
specTab=nil
spellTab=nil
raceTab=nil
affixTab=nil
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

















local affixTab= {-- {', ''},
    {1, '溢出', '对目标的过量治疗会被转化为治疗吸收效果。'},
    {2, '无常', '敌人对坦克所产生威胁值的关注程度大幅下降。'},
    {3, '火山', '在战斗中，敌人会周期性地令远处的玩家脚下喷发出岩浆柱。'},
    {4, '死疽', '所有敌人的近战攻击都将造成可叠加的枯萎效果，造成持续伤害并降低所受到的治疗效果。'},
    {5, '繁盛', '整个地下城都将增加额外的非首领敌人。'},
    {6, '暴怒', '非首领敌人在生命值降至30%时将被激怒，暂时免疫群体控制效果。'},
    {7, '激励', '任何非首领敌人死亡时，其临死的哀嚎将强化附近的盟友，使其伤害暂时提高20%。'},
    {8, '血池', '非首领敌人被击杀后会留下一个缓慢消失的脓液之池，可以治疗其盟友，并且伤害玩家。'},
    {9, '残暴', '首领的生命值提高30%，首领及其爪牙造成的伤害最多提高15%。'},

    {10, '强韧', '非首领敌人的生命值提高20%，造成的伤害最高提高30%。'},
    {11, '崩裂', '非首领敌人被击杀时会爆炸，令所有玩家在4秒内受到伤害。此效果可叠加。'},
    {12, '重伤', '受伤的玩家会受到周期性伤害，直到被完全治愈为止。'},
    {13, '易爆', '在战斗中，敌人会周期性地召唤爆裂宝珠。如果不将其摧毁，宝珠将会爆炸。'},
    {14, '震荡', '所有玩家都会周期性地发出冲击波，对附近的盟友造成伤害并打断其施法。'},
    {16, '共生', '部分非首领敌人被戈霍恩之嗣感染。'},

    {117, '收割', '非首领敌人被邦桑迪所强化，会定期死而复生并寻求复仇。'},
    {119, '迷醉', '整个地下城都将出现艾萨拉的各类使者。'},

    {120, '觉醒', '地下城中会出现许多方尖碑，玩家可以借此进入尼奥罗萨并直面恩佐斯的强力仆从。如果有仆从没有被解决掉，他们会出现在地下城终点的首领战中。'},
    {121, '傲慢', '击败非首领敌人会让玩家内心充满傲慢，最终会形成傲慢具象。击败傲慢具象会大幅强化玩家。'},
    {122, '鼓舞', '某些非首领敌人有鼓舞光环，可以强化盟友。'},
    {123, '怨毒', '从非首领敌人的尸体中会出现敌人并追击随机玩家。'},
    {124, '风雷', '战斗中敌人会周期性地召唤伤害性的旋风。'},
    {128, '磨难', '地下城中遍布典狱长的仆从，打败后会提供强大的增益。如果有未被击败的仆从，他们就会强化最终首领。'},
    {129, '狱火', '某些首领附近有地狱火道标。激活道标或者与道标附近的首领交战会触发一次军团入侵。'},

    {130, '加密', '地下城中的敌人持有初诞者的圣物。摧毁圣物可以召唤初诞者的自动体并获得强大的增益，具体效果由摧毁圣物的顺序决定。'},
    {131, '伪装', '纳斯雷兹姆潜入者们伪装身份，混入了整个地下城的敌人中间。帮助塔财团捕获他们，你就能获得丰厚奖赏。'},
    {132, '雷霆', '敌人生命值增加5%。玩家处于战斗中时，会周期性地从莱萨杰丝的无尽风暴中获得原始能量的过载之力。这种力量具有很高的风险，如果不迅速释放这力量就会让人昏迷。'},
    {134, '纠缠', '在战斗中，纠缠藤蔓会周期性地出现，并诱捕玩家。'},
    {135, '受难', '在战斗中，受难之魂会周期性地出现，并向玩家寻求帮助。'},
    {136, '虚体', '在战斗中，虚体生物会周期性地出现，并试图削弱玩家。'},
    {137, '护盾', '在战斗中，敌人会周期性地召唤护盾宝珠。如果不将其摧毁，宝珠将为附近的敌人提供护盾。'},
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

    for _, info in pairs(affixTab) do
        local name, desc = C_ChallengeMode.GetAffixInfo(info[1])
        if name and name~='' then
            e.strText[name]= info[2]
        end
        if info[3] and desc and desc~='' and info[3]~='' then
            e.strText[desc]= info[3]
        end
    end



   

   








    e.strText[GetClassInfo(13)] = "|cff33937f唤魔师|r"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE)] = "|TInterface\\FriendsFrame\\StatusIcon-Online:16:16|t 有空"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY)] = "|TInterface\\FriendsFrame\\StatusIcon-Away:16:16|t 离开"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY)] = "|TInterface\\FriendsFrame\\StatusIcon-DnD:16:16|t 忙碌"




--[[local Covenant={
    [1]='格里恩',
    [2]='温西尔',
    [3]='法夜',
    [4]='通灵领主',
}
do
for covenantID=1, 4 do
    local data = C_Covenants.GetCovenantData(covenantID) or {}
    if data.name then
        e.strText[data.name]= Covenant[covenantID]
    end
end
end
Covenant=nil]]





--[[
--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
self:RegisterEvent('SPELL_DATA_LOAD_RESULT')
panel:SetScript("OnEvent", function(self, event, arg1, arg2)
    if arg1 and arg2 then
        local info= spellTab[arg1]
        if info then
            local name=  C_Spell.GetSpellName(arg1)
            if name then
                e.strText[name]= info[1]
            end
            if info[2] and info[2]~='' then
                local desc= C_Spell.GetSpellDescription(arg1)
                if desc and desc~='' then
                    e.strText[desc]= info[2]
                end
            end
            spellTab[arg1]=nil
        end
    end
end)
]]