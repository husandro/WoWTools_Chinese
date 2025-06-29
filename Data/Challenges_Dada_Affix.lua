--[[
[ID]= {'Name_lang', 'Description_lang'},
https://wago.tools/db2/KeystoneAffix?locale=zhCN

]]

local tab={

[1]= {"溢出", "对目标的过量治疗会被转化为治疗吸收效果。"},
[2]= {"无常", "敌人对坦克所产生威胁值的关注程度大幅下降。"},
[3]= {"火山", "在战斗中，敌人会周期性地令远处的玩家脚下喷发出岩浆柱。"},
[4]= {"死疽", "所有敌人的近战攻击都将造成可叠加的枯萎效果，造成持续伤害并降低所受到的治疗效果。"},
[5]= {"繁盛", "整个地下城都将增加额外的非首领敌人。"},
[6]= {"暴怒", "非首领敌人在生命值降至30%时将被激怒，暂时免疫群体控制效果。"},
[7]= {"激励", "任何非首领敌人死亡时，其临死的哀嚎将强化附近的盟友，使其伤害暂时提高20%。"},
[8]= {"血池", "非首领敌人被击杀后会留下一个缓慢消失的脓液之池，可以治疗其盟友，并且伤害玩家。"},
[9]= {"残暴", "首领的生命值提高25%，首领及其爪牙造成的伤害最多提高15%。"},
[10]= {"强韧", "非首领敌人的生命值提高20%，造成的伤害最多提高20%。"},
[11]= {"崩裂", "非首领敌人被击杀时会爆炸，令所有玩家在4秒内受到伤害。此效果可叠加。"},
[12]= {"重伤", "受伤的玩家会受到周期性伤害，直到被完全治愈为止。"},
[13]= {"易爆", "在战斗中，敌人会周期性地召唤爆裂宝珠。如果不将其摧毁，宝珠将会爆炸。"},
[14]= {"震荡", "所有玩家都会周期性地发出冲击波，对附近的盟友造成伤害并打断其施法。"},
[16]= {"共生", "部分非首领敌人被戈霍恩之嗣感染。"},
[117]= {"收割", "非首领敌人被邦桑迪所强化，会定期死而复生并寻求复仇。"},
[119]= {"迷醉", "整个地下城都将出现艾萨拉的各类使者。"},
[120]= {"觉醒", "地下城中会出现许多方尖碑，玩家可以借此进入尼奥罗萨并直面恩佐斯的强力仆从。如果有仆从没有被解决掉，他们会出现在地下城终点的首领战中。"},
[121]= {"傲慢", "击败非首领敌人会让玩家内心充满傲慢，最终会形成傲慢具象。击败傲慢具象会大幅强化玩家。"},
[122]= {"鼓舞", "某些非首领敌人有鼓舞光环，可以强化盟友。"},
[123]= {"怨毒", "从非首领敌人的尸体中会出现敌人并追击随机玩家。"},
[124]= {"风雷", "战斗中敌人会周期性地召唤伤害性的旋风。"},
[128]= {"磨难", "地下城中遍布典狱长的仆从，打败后会提供强大的增益。如果有未被击败的仆从，他们就会强化最终首领。"},
[129]= {"狱火", "某些首领附近有地狱火道标。激活道标或者与道标附近的首领交战会触发一次军团入侵。"},
[130]= {"加密", "地下城中的敌人持有初诞者的圣物。摧毁圣物可以召唤初诞者的自动体并获得强大的增益，具体效果由摧毁圣物的顺序决定。"},
[131]= {"伪装", "纳斯雷兹姆潜入者们伪装身份，混入了整个地下城的敌人中间。帮助塔财团捕获他们，你就能获得丰厚奖赏。"},
[132]= {"雷霆", "敌人生命值增加5%。玩家处于战斗中时，会周期性地从莱萨杰丝的无尽风暴中获得原始能量的过载之力。这种力量具有很高的风险，如果不迅速释放这力量就会让人昏迷。"},
[133]= {"专注", "有法力值的非首领敌人的急速提高30%，但受到的冰霜和火焰伤害提高10%。"},
[134]= {"纠缠", "在战斗中，纠缠藤蔓会周期性地出现，并诱捕玩家。"},
[135]= {"受难", "在战斗中，受难之魂会周期性地出现，并向玩家寻求帮助。"},
[136]= {"虚体", "在战斗中，虚体生物会周期性地出现，并试图削弱玩家。"},
[137]= {"护盾", "在战斗中，敌人会周期性地召唤护盾宝珠。如果不将其摧毁，宝珠将为附近的敌人提供护盾。"},
[144]= {"荆棘", "无法力值的非首领敌人被攻击时会对攻击者造成物理伤害，但受到的神圣和暗影伤害提高10%。"},
[145]= {"鲁莽", "无法力值的非首领敌人的攻击无视20%的护甲值，但其护甲值降低30%，而且受到的奥术伤害提高10%。"},
[146]= {"调和", "有法力值的非首领敌人造成的魔法伤害提高20%，但受到的自然伤害提高10%，受到的流血效果的伤害提高30%。"},
[147]= {"萨拉塔斯的狡诈", "萨拉塔斯背叛了玩家，撤销了自己的交易，而且每次角色死亡都会让剩余时间减少15秒。"},
[148]= {"萨拉塔斯的交易：扬升", "在战斗中，萨拉塔斯会召唤宇宙能量宝珠从天而降，强化敌人或玩家。"},
[152]= {"挑战者的危境", "计时增加90秒，但死亡会从剩余时间里扣除15秒。"},
[153]= {"萨拉塔斯的交易：狂暴", "非首领敌人在生命值还剩30%时会进入狂暴状态，急速提升40%，但受到的伤害提升20%。"},
[158]= {"萨拉塔斯的交易：虚缚", "战斗中，萨拉塔斯会召唤虚空大使。虚空大使会强化附近的敌人。"},
[159]= {"萨拉塔斯的交易：湮灭", "在战斗中，萨拉塔斯会让水晶从虚空中显形，敌人或玩家都可以吸收这些水晶。"},
[160]= {"萨拉塔斯的交易：吞噬", "在战斗中，萨拉塔斯会撕开裂隙，吞噬玩家的精华。"},
[162]= {"萨拉塔斯的交易：脉冲", "在战斗中，萨拉塔斯会召唤环绕玩家的脉冲星。"},
}




    do
        for affixID, info in pairs(tab) do
            local name, desc = C_ChallengeMode.GetAffixInfo(affixID)
            WoWTools_ChineseMixin:SetCN(name, info[1])
            WoWTools_ChineseMixin:SetCN(desc, info[2])
        end
    end
    tab=nil