local tab={
[19487]= {"药水精通", "提高制作药水和相关炼金石的能力，每有一点此专精，获得+1 技能。"},
[19486]= {"冰霜公式药水", "提高制作以活力或觉醒之霜作为基础材料的药水的能力，每有一点此专精，获得+1 技能。"},
[19485]= {"空气公式药水", "提高制作以活力或觉醒之气作为基础材料的药水的能力，每有一点此专精，获得+1 技能。"},
[19484]= {"冰霜公式药水", "提高制作以活力或觉醒之霜作为基础材料的药水的能力，每有一点此专精，获得+1 技能。"},
[19483]= {"药水实验", "提升你对材料的理解，你的实验获得满意效果的可能性提高，每有一点此专精，药水实验获得+1%额外突破几率。"},
[19482]= {"批量生产", "掌握更有效率地生产药水的技术，每有一点此专精，获得+1 产能。"},
[19539]= {"炼金理论", "提升制作炼金产品的能力，每有一点此专精，所有配方都获得+1 技能。"},
[19538]= {"转化", "掌握转化的流程，每有一点此专精，此类制作获得+1 充裕。"},
[19537]= {"化学合成", "提高制作炼金材料和熏香这些特殊配方的能力，每有一点此专精，制作这些配方时获得+1 技能。"},
[19536]= {"腐朽研究", "深入探索活力腐朽和觉醒腐朽的奥秘，每有一点此专精，获得+1 技能。"},
[19535]= {"惯常充裕", "更经济地使用材料，每有一点此专精，获得+1 充裕。"},
[19534]= {"激励氛围", "成为灵感更丰富的炼金师，每有一点此专精，获得+1 灵感。"},
[22483]= {"瓶剂精通", "提高制作瓶剂和相关炼金石的能力，每有一点此专精，获得+1 技能。"},
[22482]= {"冰霜公式瓶剂", "提高制作以活力或觉醒之霜作为基础材料的瓶剂的能力，每有一点此专精，获得+1 技能。"},
[22481]= {"空气公式瓶剂", "提高制作以活力或觉醒之气作为基础材料的瓶剂的能力，每有一点此专精，获得+1 技能。"},
[22480]= {"瓶剂学识", "深入探索瓶剂和相关炼金石的奥秘，每有一点此专精，获得+1 技能。"},
[22479]= {"瓶剂实验", "提升你对材料的理解，你的实验获得满意效果的可能性提高，每有一点此专精，瓶剂实验获得+1%额外突破几率。"},
[22478]= {"批量生产", "掌握更有效率地生产瓶剂的技术，每有一点此专精，获得+1 产能。"},
[23727]= {"武器打造", "提高制作武器和大型工具的能力，每有一点此专精，获得+1 技能。"},
[23726]= {"利刃", "提高制作各种带刃武器和工具的能力，每有一点此专精，获得+1 技能。"},
[23725]= {"短刃", "提高制作短刃武器和工具，包括匕首和拳套的能力，每有一点此专精，获得+1 技能。"},
[23724]= {"长刃", "提高制作长刃武器和工具，如剑、战刃和镰刀的能力，每有一点此专精，获得+1制作技能。"},
[23723]= {"握柄", "提高制作带柄武器和工具，如斧和锤的能力，每有一点此专精，获得+1 技能。"},
[23722]= {"锤", "提高制作锤的能力，每有一点此专精，获得+1制作技能。"},
[23721]= {"斧、镐和长柄武器", "提高制做斧、镐和长柄武器的能力，每有一点此专精，获得+1制作技能。"},
[23765]= {"专业锻制", "提高制作非军用商品的能力，每有一点此专精，获得+1 技能。"},
[23764]= {"工具打造", "成为为许多专业制作金属工具和配饰的专家，每有一点此专精，获得+1 技能。"},
[23763]= {"冒险装备", "成为制作钩爪之类的冒险装备的专家，每有一点此专精，获得+1 技能。"},
[23762]= {"石制品", "成为用石头制作武器和工具的强化物品的专家，每有一点此专精，获得+1 技能。"},
[23761]= {"熔炼", "成为熔炼合金和其他特殊材料的专家，每有一点此专精，获得+1 技能。"},
[23912]= {"铸甲", "提高制作板甲的能力，每有一点此专精，获得+1 技能。"},
[23911]= {"大型板甲", "提高制作最大的护甲部位，包括胸部、腿部以及盾牌的能力，每有一点此专精，获得+1 技能。"},
[23910]= {"胸甲", "成为制作胸部板甲的专家，每有一点此专精，获得+1 技能。"},
[23909]= {"盾牌", "成为制作盾牌的专家，每有一点此专精，获得+1 技能。"},
[23908]= {"护胫", "成为制作腿部板甲的专家，每有一点此专精，获得+1 技能。"},
[23907]= {"塑造护甲", "提高制作头部、肩部和脚部塑形护甲的能力，每有一点此专精，获得+1 技能。"},
[23906]= {"头盔", "成为制作板甲头盔的专家，每有一点此专精，获得+1 技能。"},
[23905]= {"肩铠", "成为制作肩部板甲的专家，每有一点此专精，获得+1 技能。"},
[23904]= {"靴子", "成为制作脚部板甲的专家，每有一点此专精，获得+1 技能。"},
[23903]= {"精良护甲", "提高制作最小型板甲，包括腰部、腕部和手部护甲的能力，每有一点此专精，获得+1 技能。"},
[23902]= {"腰带", "成为制作腰部板甲的专家，每有一点此专精，获得+1 技能。"},
[23901]= {"臂甲", "成为制作腕部板甲的专家，每有一点此专精，获得+1 技能。"},
[23900]= {"护手", "成为制作手部板甲的专家，每有一点此专精，获得+1 技能。"},
[28438]= {"锁甲制作", "提高制作锁甲的能力，每有一点此专精，获得+1 技能。"},
[28437]= {"大型锁甲", "提高制作胸部、肩部、头部和腕部大型锁甲的能力，每有一点此专精，获得+1 技能。"},
[28436]= {"锁甲护胸", "提高制作胸部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28435]= {"护胫", "提高制作腿部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28434]= {"锁甲头盔", "提高制作头部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28433]= {"护腕", "提高制作腕部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28432]= {"精致锁甲", "提高制作手部、脚部、腿部和腰部精致锁甲的能力，每有一点此专精，获得+1 技能。"},
[28431]= {"护手", "提高制作手部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28430]= {"靴子", "提高制作脚部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28429]= {"护肩", "提高制作肩部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28428]= {"腰带", "提高制作腰部锁甲的能力，每有一点此专精，获得+1 技能。"},
[28546]= {"皮甲制作", "提高制作皮甲的能力，每有一点此专精，获得+1 技能。"},
[28545]= {"塑形皮甲", "提高制作胸部、头部、肩部和腕部塑形皮甲的能力，每有一点此专精，获得+11 技能。"},
[28544]= {"胸甲", "提高制作胸部皮甲的能力，每有一点此专精，获得+1技能。"},
[28543]= {"头盔", "提高制作皮甲头盔的能力，每有一点此专精，获得+1技能。"},
[28542]= {"肩甲", "提高制作肩部皮甲的能力，每有一点此专精，获得+1技能。"},
[28541]= {"裹腕", "提高制作腕部皮甲的能力，每有一点此专精，获得+1技能"},
[28540]= {"刺绣皮甲", "提高制作腿部、手部、腰部和脚部皮甲的能力，每有一点此专精，获得+1 技能。"},
[28539]= {"护腿", "提高制作腿部皮甲的能力，每有一点此专精，获得+1技能。"},
[28538]= {"手套", "提高制作皮甲手套的能力，每有一点此专精，获得+1技能。"},
[28537]= {"腰带", "提高制作腰部皮甲的能力，每有一点此专精，获得+1技能。"},
[28536]= {"靴子", "提高制作脚部皮甲的能力，每有一点此专精，获得+1技能。"},
[28610]= {"事业心", "更加擅长珠宝生意，每有一点此专精，选矿，制作所有种类的材料以及专业装备时获得+1 技能。"},
[28609]= {"选矿", "改善选矿的技巧从而提升产量和效率，每有一点此专精，选矿时获得+1 技能。"},
[28608]= {"奢侈品", "提升你制作所有种类的非玻璃器皿材料和专业装备的能力，制作这些产品时，获得+1 技能。"},
[28607]= {"玻璃器皿", "提升你制作棱镜、玻璃器皿和宝石簇的能力，制作这些产品时，获得+1 技能。"},
[28660]= {"琢面", "提升切割宝石的能力，每有一点此专精，所有宝石切割都获得+1 技能。"},
[28659]= {"空气", "提升切割空气宝石的能力，每有一点此专精，所有空气宝石切割都获得+1 技能。"},
[28658]= {"大地", "提升切割大地宝石的能力，每有一点此专精，所有大地宝石切割都获得+1 技能。"},
[28657]= {"火焰", "提升切割火焰宝石的能力，每有一点此专精，所有火焰宝石切割都获得+1 技能。"},
[28656]= {"冰霜", "提升切割冰霜宝石的能力，每有一点此专精，所有冰霜宝石切割都获得+1 技能。"},
[28672]= {"珠宝匠的工具套装精通", "提升珠宝加工的技艺，此专精获得+1 技能。"},
[28728]= {"底座", "提升打造首饰和雕刻石头的技艺，每有一点此专精，获得+1 技能。"},
[28727]= {"珠宝", "磨炼你身为珠宝匠的技能，打造首饰时，每有一点此专精，获得+1 技能。"},
[28726]= {"项链", "专精于制作美丽的项链，每有一点此专精，项链制作获得+1 技能。"},
[28725]= {"戒指", "专精于制作奢华的戒指，每有一点此专精，戒指制作获得+1 技能。"},
[28724]= {"切割", "提升雕刻精致石头的技艺，雕刻雕像或塑像时，每有一点此专精，获得+1 技能。"},
[28723]= {"雕像", "进一步提高雕刻雕像的技艺，雕刻雕像时，每有一点此专精，获得+1 技能"},
[28722]= {"石头", "进一步提高雕刻塑像的技艺，雕刻塑像时，每有一点此专精，获得+1 技能。"},
[31146]= {"始源制皮", "提高始源制皮的能力，制作元素、野兽和腐朽制皮图样时，每有一点此专精，获得+1 技能。"},
[31145]= {"元素精通", "提高制作元素图样和元素注能材料的能力，每有一点此专精，获得+1 技能。"},
[31144]= {"卓越野兽", "提高制作野兽图样和暴怒注能材料的能力，每有一点此专精，获得+1 技能。"},
[31143]= {"腐朽之握", "提高制作腐朽图样和腐朽注能材料的能力，每有一点此专精，获得+1 技能。"},
[31184]= {"制皮律法", "练习你的制皮基本功，每有一点此专精，获得+1 技能。"},
[31183]= {"皮革剪裁精通", "提升从制作材料获得成品的能力，每有一点此专精，获得+1 充裕。"},
[31182]= {"敬畏匠工", "成为灵感更丰富的制皮匠，每有一点此专精，获得+1 灵感。"},
[31181]= {"绑定和缝合", "提升绑定和缝合的能力，制作弓和专业配饰时，每有一点此专精，获得+1 技能。"},
[31180]= {"固化和鞣制", "提升固化和鞣制的能力，制作材料和护甲片时，每有一点此专精，获得+1 技能。"},
[34689]= {"鞣制", "提升你总体的剥皮技巧，剥皮时，每有一点此专精，获得+1 技能。"},
[34688]= {"皮甲精通", "强化你的剥皮技巧，对主要产出皮革的生物进行剥皮时，每有一点此专精，+1 技能。"},
[34687]= {"鳞片精通", "专心研究剥鳞技巧，对主要产出鳞片的生物进行剥皮时，每有一点此专精，+1 技能。"},
[34729]= {"收割", "提升你的效率，剥皮时，每有一点此专精，获得+1 熟练。"},
[34728]= {"诱饵工匠", "锤炼你在巨龙群岛收集可用的小食的能力，剥皮时每有一点此专精，就能略微提高发现小食的几率"},
[34727]= {"剥肉者", "提升你从巨龙群岛的某些生物身上收集肉类的能力，剥皮时每有一点此专精，就能略微提高发现肉类的几率"},
[34726]= {"战利品收集者", "学习识别稀有材料，剥皮时，每有一点此专精，获得+1 感知。"},
[34759]= {"诱饵工匠", "研究从每个生物身上收集更多材料的技术，剥皮时，每有一点此专精，获得+1 精细。"},
[34758]= {"精通", "提升你的协调能力，剥皮时，每有一点此专精，获得+1 熟练。"},
[34757]= {"元素注能", "调和元素能量来提升你的感受力，剥皮时，每有一点此专精，获得+1 感知。"},
[34835]= {"符文精通", "提升铭文的技艺和利用各种材料的能力，每有一点此专精，获得+1 技能。"},
[34834]= {"熟能生巧", "制作物品的效率提高，每有一点此专精，获得+1 充裕。"},
[34833]= {"无穷探索", "成为灵感更丰富的铭文师，每有一点此专精，获得+1 灵感。"},
[34832]= {"植物理解", "提高研磨巨龙群岛各类草药的能力，每有一点此专精，获得+1 技能。"},
[34831]= {"无瑕墨水", "提高制作铭文使用的各类墨水的能力，每有一点此专精，获得+1 技能。"},
[34893]= {"符文绑定", "提升绑定符文物品的技艺，符文物品可以在制作和战斗方面提供帮助，每有一点此专精，获得+1 技能。符文绑定商品包括专业工具、法杖、法典、凡图斯符文，以及动物符文。"},
[34892]= {"木雕", "专精于把复杂的符文与法杖和专业工具绑定在一起，每有一点此专精，获得+1 技能。"},
[34891]= {"专业工具", "成为制作许多专业工具的专家，每有一点此专精，获得+1 技能。"},
[34890]= {"法杖", "成为制作强力双手法杖的专家，每有一点此专精，获得+1 技能。"},
[34889]= {"符文手稿", "专精于把符文徽记雕刻成法典这样的强力装备，以及凡图斯符文和动物符文。每有一点此专精，获得+1 技能。"},
[34888]= {"法典", "提升把复杂的符文与各类法典绑定在一起的能力，每有一点此专精，获得+1 技能。"},
[34887]= {"凡图斯符文", "成为高效地制作凡图斯符文的专家，每有一点此专精，获得+1 充裕。"},
[34886]= {"动物符文", "成为高效地雕刻动物符文的专家，动物符文可以用来强化你的武器，每有一点此专精，获得+1 充裕。"},
[40008]= {"裁缝精通", "提升裁缝的技艺，每有一点此专精，获得+1 技能"},
[40007]= {"布料收集", "学习更有效率地收集布料，每有一点此专精，从巨龙群岛的人形生物身上获得的布料数量增加1%。"},
[40006]= {"节俭缝补", "节俭地使用你的材料，每有一点此专精，获得+1 充裕。"},
[40005]= {"精准缝制", "一针一线都一丝不苟，每有一点此专精，获得+1 灵感。"},
[40038]= {"纺织品", "对裁缝专业里更专精的方面进行提升，包括制作各种材料和专用物品，每有一点此专精，获得+1 技能。"},
[40037]= {"纺织", "成为拆解布和纺织各类线的专家，每有一点此专精，获得+1 技能。"},
[40036]= {"编织", "成为将布纺织为布卷的专家，每有一点此专精，获得+1 技能。"},
[40035]= {"刺绣", "成为简单的物品，如抛光布的刺绣专家，以及精致的物品，如旗帜和背包的刺绣专家，每有一点此专精，获得+1 技能。"},
[40074]= {"巨龙针线活", "找出巨龙群岛的魔法源泉，用像青纹布和时序布这样的材料制作出色的布甲，每有一点此专精，获得+1 技能。"},
[40073]= {"青纹布裁缝", "在裁缝工作时专心研究蓝龙军团的奥术天性，每有一点此专精，制作和使用青纹布时获得+1 技能。"},
[40072]= {"青纹布纺织", "掌握制作青纹布卷的技术，每有一点此专精，获得+1 技能。"},
[40071]= {"时序布裁缝", "在裁缝工作时深入探索青铜龙军团的时间魔法背后的奥秘，每有一点此专精，制作和使用时序布时获得+1 技能。"},
[40070]= {"织时", "掌握制作时序布卷的技术，每有一点此专精，获得+1 技能。"},
[40226]= {"衣着缝制", "提升你缝制布甲对抗巨龙群岛最强大的敌人的能力，每有一点此专精，获得+1 技能。"},
[40225]= {"锦罗玉衣", "提高缝制服装的主要部位的能力，如胸部和腿部护甲。每有一点此专精，获得+1 技能。"},
[40224]= {"长袍", "专精于缝制胸部布甲，如长袍和外衣，每有一点此专精，获得+1 技能。"},
[40223]= {"护腿", "专精于缝制腿部布甲，每有一点此专精，获得+1 技能。"},
[40222]= {"外衣", "提高制作服装的修饰的能力，如手部、脚部、头部和背部护甲。每有一点此专精，获得+1 技能。"},
[40221]= {"手套", "专精于缝制手部布甲，每有一点此专精，获得+1 技能。"},
[40220]= {"足具", "专精于缝制脚部布甲，每有一点此专精，获得+1 技能。"},
[40219]= {"帽子", "专精于缝制头部布甲，每有一点此专精，获得+1 技能。"},
[40218]= {"披风", "专精于缝制披风，每有一点此专精，获得+1 技能。"},
[40217]= {"修饰", "提高制作服装的修饰的能力，如腰部、肩部和腕部护甲。每有一点此专精，获得+1 技能。"},
[40216]= {"披肩", "专精于缝制肩部布甲，每有一点此专精，获得+1 技能。"},
[40215]= {"护臂", "专精于缝制腕部布甲，每有一点此专精，获得+1 技能。"},
[40214]= {"腰带", "专精于缝制腰部布甲，每有一点此专精，获得+1 技能。"},
[42828]= {"锻锤控制", "提升锻造的技艺，每有一点此专精，获得+1 技能。"},
[42827]= {"安全熔炼", "更经济地使用材料，每有一点此专精，获得+1 充裕。"},
[42826]= {"辛酸设计图", "成为灵感更丰富的铁匠，每有一点此专精，获得+1 灵感。"},
[43535]= {"归档", "提升对各种文本进行归档的技艺，每有一点此专精，获得+1 技能。归档商品包括暗月卡牌盒、合约、公函、巨龙论述以及鳞片徽记。"},
[43534]= {"暗月奥秘", "专精于理解暗月卡牌背后的复杂奥秘，以及制作暗月套牌盒，每有一点此专精，获得+1 技能。"},
[43533]= {"火焰", "成为火焰暗月卡片以及制作暗月套牌：地狱火的更强大的版本的专家，每有一点此专精，获得+1 技能。"},
[43532]= {"冰霜", "成为冰霜暗月卡片以及制作暗月套牌：淞的更强大的版本的专家，每有一点此专精，获得+1 技能。"},
[43531]= {"空气", "成为空气暗月卡片以及制作暗月套牌：舞的更强大的版本的专家，每有一点此专精，获得+1 技能。"},
[43530]= {"大地", "成为大地暗月卡片以及制作暗月套牌：看护者的更强大的版本的专家，每有一点此专精，获得+1 技能。"},
[43529]= {"共享知识", "专精于有效地通过合约、公函和论述来分享巨龙群岛的知识，每有一点此专精，获得+1 充裕。"},
[43528]= {"合约和公函", "成为制作巨龙群岛合约和公函的专家，每有一点此专精，获得+1 技能。"},
[43527]= {"巨龙论述", "成为制作许多专业的巨龙论述的专家，每有一点此专精，获得+1 充裕。"},
[43526]= {"鳞片徽记", "专精于制作鳞片徽记来改变你的暗月套牌盒的洗牌效果，每有一点此专精，获得+1 技能。"},
[43525]= {"碧蓝鳞片徽记", "成为制作碧蓝鳞片徽记的专家，每有一点此专精，获得+1 技能。"},
[43524]= {"灰烬鳞片徽记", "学习制作灰烬鳞片徽记，每有一点此专精，获得+1 技能。"},
[43523]= {"贤者鳞片徽记", "学习制作贤者鳞片徽记，每有一点此专精，获得+1 技能。"},
[43522]= {"青铜鳞片徽记", "成为制作青铜鳞片徽记的专家，每有一点此专精，获得+1 技能。"},
[43521]= {"喷流鳞片徽记", "学习制作喷流鳞片徽记，每有一点此专精，获得+1 技能。"},
[50894]= {"爆炸物", "提高所有种类的炸弹的制作水平，每有一点此专精，制作炸弹时获得+1 技能。"},
[50893]= {"创造", "进一步提高所有炸弹的制作水平，每有一点此专精，制作炸弹时获得+1 充裕。"},
[50892]= {"超短引线", "专精于在没有保险丝的情况下创造和使用炸弹。每有一点此专精，制作普通炸弹时获得+1 技能。"},
[50891]= {"易投", "专精于制作“易投”炸弹，造价不菲，但对非工程师来说是非常安全的爆炸物。每有一点此专精，制作“易投”炸弹时获得+1 技能。"},
[50929]= {"功能大于形式", "专精于创造实用的物品供冒险者和匠人日常使用，制作装备和装备强化物品相关的东西时，获得+1 技能。"},
[50928]= {"装备", "进一步改进战斗装备的制作，每有一点此专精，制作这类物品时获得+1 灵感。"},
[50927]= {"齿轮和装备", "进一步改进专业装备、齿轮和附加材料的制作，每有一点此专精，制作这些物品时获得+1 灵感。"},
[50926]= {"实用", "进一步改进弹药和瞄准镜制作，每有一点此专精，获得+1 产能。"},
[50956]= {"机械头脑", "专精于创造和使用精细的装置、机件、旋转玩具和匠械；但这知识对你身为工程师的成长也是无价的。每有一点此专精，制作所有工程学制品时获得+1 技能。"},
[50955]= {"发明创造", "进一步专门改进匠械的制作和使用，而不是小机件和旋转玩具。制作匠械时获得+1 技能。"},
[50954]= {"新奇玩物", "拥抱你异想天开的一面，学习制作各种居然很安全的发明，为你自己和你周围的人提供娱乐。此外，每有一点此专精，制作工程学商品时灵感都能使技能额外提升1%。"},
[50993]= {"优化效率", "专精于普通的预防措施和技术，这些对所有工程师来说都具有无上价值。每有一点此专精，制作所有工程学制品时获得+1 技能。"},
[50992]= {"基础零件", "专精于制作生产所有种类的工程学货物所必须的基础零件，制作材料时，+1 充裕。"},
[50991]= {"拆解者", "专精于利用看起来毫无用处的垃圾。每有一点此专精，制作所有工程学物品时，充裕属性额外节省1%的材料。"},
[50990]= {"通才", "专精多种有用的技能，但不具体到某一方面，从而提升你身为工程师的总体技能。每有一点此专精，制作所有工程学物品时获得+1 技能。"},
[57263]= {"采矿流程", "研究正确的采矿技巧，提升你采矿的效率，并获得新的采矿机遇。每有一点此专精，获得+ 1技能 。"},
[57262]= {"勘测", "提升你发现矿脉和其中的稀有材料的能力。每有一点此专精，获得+1 感知。"},
[57261]= {"工业化", "提升你的能力，使你更快和更有效率地从矿脉提取矿石。采矿时获得+1 熟练。"},
[57260]= {"分类", "提升你从矿脉中提取主要矿石的能力，每有一点此专精，获得+ 1精细。"},
[57293]= {"冶金", "进一步提升你对巨龙群岛各地发现的不同金属的理解。专精此路线会提升你身为矿工的效率，并使你获得技能来精制你的矿石，从而提升其品质。每有一点此专精，开采所有矿脉时获得+1 技能。"},
[57292]= {"宁铁", "专精于了解宁铁，提升你用各种方式收集和精制这种金属的能力。每有一点此专精，采集所有宁铁矿脉时获得+1 技能。"},
[57291]= {"龙银", "专精于了解龙银，提升你用各种方式收集和精制这种金属的能力。每有一点此专精，采集所有龙银矿脉时获得1 技能。"},
[57345]= {"控制元素", "巨龙群岛上元素横行无忌，经验丰富的矿工发现了新的技巧，可以吸取这些宝贵的金属中残留的魔法。每有一点此专精，所有元素矿脉都获得+1 技能。"},
[57344]= {"熔火", "专精于熔火矿脉，使你可以获得额外的活力之火，并提升你采集这些矿脉的效率。每有一点此专精，采集熔火矿脉时获得+1 技能。"},
[57343]= {"硬化", "专精于硬化矿脉，使你可以获得额外的活力之土，并提升你采集这些矿脉的效率。每有一点此专精，采集硬化矿脉时获得+1 技能。"},
[57342]= {"泰坦点化", "专精于泰坦点化的矿脉，使你可以发现传送门，从而迅速前往附近的矿脉并在采矿时获得额外的精华。每有一点此专精，采集泰坦点化的矿脉时获得+1 技能。"},
[57341]= {"原始", "拥抱原始矿脉中发现的混沌之力，提升你收集元素精华的能力，并加深你对混沌元素的理解。每有一点此专精，原始矿脉获得+1 技能。"},
[59621]= {"控制元素", "研究巨龙群岛的觉醒元素微妙的细节，以及它们对植物的影响，采集元素充能的草药时，每有一点此专精，获得+1 技能。"},
[59620]= {"啸风", "专精于啸风草药，每有一点此专精，采集这些草药时获得+1 技能。"},
[59619]= {"冷冽", "专精于冷冽草药，每有一点此专精，采集这些草药时获得+1 技能。"},
[59618]= {"泰坦点化", "专精于泰坦点化的草药，每有一点此专精，采集这些草药时获得+1 技能。"},
[59617]= {"腐朽", "专精于腐朽草药，每有一点此专精，采集这些草药时获得+1 技能。"},
[59651]= {"植物学", "研究有效地采集巨龙群岛的植物的方法和技巧，采集草药时，每有一点此专精，获得+1 精细。"},
[59650]= {"熟谙", "提高使用草药工具的能力，每有一点此专精，采集草药时获得+1 熟练。"},
[59649]= {"栽培", "提升你的栽培技巧，每有一点此专精，采集草药时获得+1 感知。"},
[59701]= {"大丰收", "提升你的综合采集技巧，每有一点此专精，采集草药时获得+1 技能。"},
[59700]= {"园艺", "了解霍亨布墨花微妙而难以掌握的细节，每有一点此专精，采集霍亨布墨花时获得+1 技能。"},
[59699]= {"树木栽培", "练习采集歪扭树皮的新方法，每有一点此专精 ，采集歪扭树皮时就获得+1 技能。"},
[59698]= {"真菌培养", "学习如何处理娇嫩的泡粟花，每有一点此专精 ，采集泡粟花时就获得+1 技能。"},
[59697]= {"花卉栽培", "学习虎耳草的结构，每有一点此专精，采集虎耳草时就获得+1 技能。"},
[64143]= {"附魔", "提升对魔法属性及其应用的理解能力，制作附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64142]= {"原始", "学习驾驭巨龙群岛的原始元素，制作利用活力元素或觉醒元素的附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64141]= {"燃烧", "学习控制你附魔里的火焰，制作利用活力之火或觉醒之火的附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64140]= {"土地", "学习绑定你附魔里的土地，制作利用活力之土或觉醒之土的附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64139]= {"睿智", "学习唤起你附魔里的泰坦之力，制作利用活力秩序或觉醒秩序的附魔时，提升技能。每有一点此专精，获得+1 技能。"},
[64138]= {"凝冰", "学习聚集你附魔里的冰霜，制作利用活力之霜或觉醒之霜的附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64137]= {"飘扬", "学习引导你附魔里的气流，制作利用活力之气或觉醒之气的附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64136]= {"材料操纵", "提升你改造装备来满足你的各种需要的能力，为护腕、胸甲、披风和专业工具制作附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64135]= {"适性", "成为制作适性附魔的专家，为护腕和披风制作附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64134]= {"艺术", "成为制作艺术附魔的专家，为专业工具制作附魔时提升技能。每有一点此专精，获得+1 技能。"},
[64133]= {"魔法支援", "学习提升主要战斗能力，制作胸甲和戒指的附魔时提升技能。每有一点此专精，获得+1 技能。"},
[68402]= {"蓝龙洞察", "提升对魔法来源的观察力，使你可以在巨龙群岛的敌人身上和宝藏中发现玄秘物品。玄秘物品可以被分解为材料。每有一点此专精，获得+1%几率发现可分解的物品。"},
[68401]= {"巨龙附魔", "学习更专业的技巧来从物品中找回魔法材料，每有一点此专精，分解物品时就有+1%的几率获得额外的材料。"},
[68400]= {"原始提取", "学习提取原始元素生物的元素，进一步研究其魔法并获得额外的材料。每有一点此专精，就有+1%的几率获得额外的活力元素。"},
[68445]= {"棒、符文和诡计", "提高你的能力，使你利用工具和材料时更有效率，效果也更好，制作附魔和附魔商品时提升技能。每有一点此专精，获得+1 技能。"},
[68444]= {"棒和魔杖", "提高制作附魔棒和魔杖的能力，每有一点此专精，获得+1 技能。"},
[68443]= {"幻影商品", "学习用幻影魔法和附魔进行娱乐和故弄玄虚，制作幻影商品时提升技能。每有一点此专精，获得+1 技能。"},
[68442]= {"充裕手稿", "研究新的魔法效率，每有一点此专精，获得+1 充裕。"},
[68441]= {"灵感专注", "通过你对魔法附魔的热忱而获得灵感，每有一点此专精，获得+1 灵感。"},
[81118]= {"耀眼铁器", "成为灵感更丰富的珠宝匠，每有一点此专精，获得+1 灵感。"},
[81119]= {"节银省金", "更经济地使用材料，每有一点此专精，获得+1 充裕。"},

}


--[[
TraitNodeID]= {"名称", "描述"},
https://www.wowhead.com/cn/profession-trait/100512

https://wago.tools/db2/ProfTraitPathNode?locale=zhCN
]]

local e= select(2, ...)
function e.Get_Profession_Node_Desc(nodeID)
    return tab[nodeID]
end