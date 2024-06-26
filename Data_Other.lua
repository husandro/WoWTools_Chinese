local id, e = ...
if e.Not_Is_EU then return end

--[[
specTab=nil
spellTab=nil
raceTab=nil
affixTab=nil
itemSubTypeTab=nil
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















local itemSubTypeTab={
["爆炸物和装置"]= {0, 0},
["药水"]= {0, 1},
["药剂"]= {0, 2},
["合剂和瓶剂"]= {0, 3},
['卷轴']= {0, 4},
["食物和饮水"]= {0, 5},
['物品增强']= {0, 6},
["绷带"]= {0, 7},
["凡图斯符文"]= {0, 9},

--["容器"]= {1, 0},
['灵魂袋']= {1, 1},
["草药袋"]= {1, 2},
["附魔材料袋"]= {1, 3},
["工程材料袋"]= {1, 4},
["宝石袋"]= {1, 5},
["矿石袋"]= {1, 6},
["制皮材料包"]= {1, 7},
["铭文包"]= {1, 8},
["钓鱼箱"]= {1, 9},
["烹饪包"]= {1, 10},
["材料包"]= {1, 11},

["单手斧"]= {2, 0},
["双手斧"]= {2, 1},
["弓"]= {2, 2},
["枪械"]= {2, 3},
["单手锤"]= {2, 4},
["双手锤"]= {2, 5},
["长柄武器"]= {2, 6},
["单手剑"]= {2, 7},
["双手剑"]= {2, 8},
["战刃"]= {2, 9},
["法杖"]= {2, 10},
["熊爪"]= {2, 11},
["豹爪"]= {2, 12},
["拳套"]= {2, 13},
['其它']= {2, 14},
["匕首"]= {2, 15},
["投掷武器"]= {2, 16},
["矛"]= {2, 17},
["弩"]= {2, 18},
["魔杖"]= {2, 19},
["鱼竿"]= {2, 20},

["神器圣物"]= {3, 11},
["智力"]= {3, 0},
["敏捷"]= {3, 1},
["力量"]= {3, 2},
["耐力"]= {3, 3},
["爆击"]= {3, 5},
["精通"]= {3, 6},
["急速"]= {3, 7},
["全能"]= {3, 8},
["复合属性"]= {3, 10},

--['其它']= {4, 0},
["布甲"]= {4, 1},
["皮甲"]= {4, 2},
["锁甲"]= {4, 3},
["板甲"]= {4, 4},
--["装妆品"]= {4, 5},
--['盾牌']= {4, 6},
['圣约']= {4, 7},
['神像']= {4, 8},
--['图腾']= {4, 9},
['魔印']= {4, 10},
--['圣物']= {4, 11},

--['材料']= {5, 0},
['钥石']= {5, 1},
['环境对应兑换物']= {5, 2},

['商品']= {7, 0},
['零件']= {7, 1},
['爆炸物']= {7, 2},
['装置']= {7, 3},
["珠宝加工"]= {7, 4},
["布料"]= {7, 5},
["皮料"]= {7, 6},
["金属和矿石"]= {7, 7},
--["烹饪"]= {7, 8},
["草药"]= {7, 9},
["元素"]= {7, 10},
["附魔材料"]= {7, 12},
['原料']= {7, 13},
['物品附魔']= {7, 14},
['武器强化']= {7, 15},
--["铭文"]= {7, 16},
["附加材料"]= {7, 18},
["成品材料"]= {7, 19},

["头部"]= {8, 0},
["颈部"]= {8, 1},
["肩部"]= {8, 2},
["披风"]= {8, 3},
["胸部"]= {8, 4},
["手腕"]= {8, 5},
["手部"]= {8, 6},
["腰部"]= {8, 7},
["腿部"]= {8, 8},
["脚部"]= {8, 9},
["手指"]= {8, 10},
--["武器"]= {8, 11},
["双手武器"]= {8, 12},
["盾牌/副手"]= {8, 13},

['书箱']= {9, 0},
["制皮"]= {9, 1},
["裁缝"]= {9, 2},
["工程学"]= {9, 3},
["锻造"]= {9, 4},
["炼金术"]= {9, 6},
--["烹饪"]= {9, 5},
["急救"]= {9, 7},
["附魔"]= {9, 8},
--["钓鱼"]= {9, 9},
--["珠宝加工"]= {9, 10},
--["铭文"]= {9, 11},



["垃圾"]= {15, 0},
--["材料"]= {15, 1},
["节日"]= {15, 3},
["坐骑"]= {15, 5},
["坐骑装备"]= {15, 6},

["|cffc69b6d战士|r"]= {16, 1},
["|cfff48cba圣骑士|r"]= {16, 2},
["|cffaad372猎人|r"]= {16, 3},
["|cfffff468盗贼|r"]= {16, 4},
["|cffffffff牧师|r"]= {16, 5},
["|cffc41e3a死亡骑士|r"]= {16, 6},
["|cff0070dd萨满|r"]= {16, 7},
["|cff3fc7eb法师|r"]= {16, 8},
["|cff8788ee术士|r"]= {16, 9},
["|cff00ff98武僧|r"]= {16, 10},
["|cffff7c0a德鲁伊|r"]= {16, 11},
["|cffa330c9恶魔猎手|r"]= {16, 12},

["人形"]= {17, 0},
["龙类"]= {17, 1},
["飞行"]= {17, 2},
["亡灵"]= {17, 3},
["小动物"]= {17, 4},
["魔法"]= {17, 5},
--["元素"]= {17, 6},
["野兽"]= {17, 7},
["水栖"]= {17, 8},
["机械"]= {17, 9},

["时光徽章"]= {18, 0},

--["制皮"]= {19, 1},
["草药学"]= {19, 3},
["采矿"]= {19, 5},
--["工程学"]= {19, 7},
["剥皮"]= {19, 10},

['消耗品']={0},
['容器']= {1},
['武器']= {2},
['宝石']= {3},
['护甲']= {4},
['材料']= {5},
['弹药']= {6},
['商业技能']= {7},
['物品强化']= {8},
['配方']= {9},
['钱币']= {10},
['箭袋']= {11},
['任务']= {12},
["钥匙"]= {13},
['永久物品']= {14},
["杂项"]= {15},
['雕文']= {16},
['战斗宠物']= {17},
--['时光徽章']= {18},
['专业技能']={19},
}












    for mapChallengeModeID, info in pairs(e.ChallengesSpellTabs) do
        if info.spell then
            if info.spellName then
                local name= C_Spell.GetSpellName(info.spell)
                if name then
                    e.strText[name]= info.spellName
                end
            end
            if info.spellDes then
                local desc = C_Spell.GetSpellDescription(info.spell)
                if desc and desc~='' then
                    e.strText[desc]= info.spellDes
                end
            end
        end
        if info.insName and info.ins then
            local name, description= EJ_GetInstanceInfo(info.ins)
            if name then
                e.strText[name]= info.insName
            end
            if info.insDesc and description then
                e.strText[description]= info.insDesc
            end
        end
        if info.name then
            local name= C_ChallengeMode.GetMapUIInfo(mapChallengeModeID)
            if name then
                e.strText[name]= info.name
            end
        end
    end




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

    for name, info in pairs(itemSubTypeTab) do
        if info[2] then
            local sub= C_Item.GetItemSubClassInfo(info[1], info[2])
            if sub and sub~='' then
                e.strText[sub]= name
            end
        else
            local class= C_Item.GetItemClassInfo(info[1])
            if class and class~='' then
                e.strText[class]= name
            end
        end
    end

   

   








    e.strText[GetClassInfo(13)] = "|cff33937f唤魔师|r"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE)] = "|TInterface\\FriendsFrame\\StatusIcon-Online:16:16|t 有空"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY)] = "|TInterface\\FriendsFrame\\StatusIcon-Away:16:16|t 离开"
    e.strText[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY)] = "|TInterface\\FriendsFrame\\StatusIcon-DnD:16:16|t 忙碌"




    local Covenant={
        [1]='格里恩',
        [2]='温西尔',
        [3]='法夜',
        [4]='通灵领主',
    }
    for covenantID=1, 4 do
        local data = C_Covenants.GetCovenantData(covenantID) or {}
        if data.name then
            e.strText[data.name]= Covenant[covenantID]
        end
    end







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