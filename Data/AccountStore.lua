--[[
https://wago.tools/db2/AccountStoreCategory?locale=zhCN

[ID]= {'Name_lang', 'Description_lang'},
https://wago.tools/db2/AccountStoreItem?locale=zhCN
]]

local categoryTab={
[15]= {'其它', 1542848},
[14]= {'玩具', 237429},
[13]= {'背部', 2428524},
[10]= {'战袍', 5690395},
[9]= {'萦雷', 1941310},
[8]= {'豪放', 5559633},
[7]= {'头部', 1941312},
[6]= {'时髦', 5519312},
[5]= {'水手杂兵', 4279080},
[4]= {'武器', 1958262},
[3]= {'枪械', 1934251},
[2]= {'坐骑', 132261},
[1]= {'宠物', 656556},
}


local itemTab={



[1]= {'乐乐', '|cFF00ccff“地心之战”宠物|r|n|cFF1eff00“霸业风暴”宠物|r|n|n解锁“乐乐”宠物。在“霸业风暴”中，达卡什·暗账可以帮你召唤你的宠物。|n|n“它光是能来这儿逛逛就很兴奋了。”'},
[2]= {'泡泡', '|cFF00ccff“地心之战”宠物|r|n|cFF1eff00“霸业风暴”宠物|r|n|n解锁“泡泡”宠物。在“霸业风暴”中，达卡什·暗账可以帮你召唤你的宠物。|n|n“它跟踪你回家了！”|n|n|cFFFFFFFF额外宠物：小钳|r|n|n|CFFa335ee经典怀旧服宠物|r|n|n解锁“巫妖王之怒”宠物：“收集者小钳”。|n|n“小心尖端！”'},
[3]= {'格拉姆洛克', '|cFF00ccff“地心之战”宠物|r|n|cFF1eff00“霸业风暴”宠物|r|n|n解锁“格拉姆洛克”宠物。在“霸业风暴”中，达卡什·暗账可以帮你召唤你的宠物。|n|n“收集爱好者，你的同行。”'},
[4]= {'闪钳', '|cFF00ccff“地心之战”宠物|r\n|cFF1eff00“霸业风暴”宠物|r\n\n解锁“闪钳”宠物。在“霸业风暴”中，达卡什·暗账可以帮你召唤你的宠物。\n\n“钳住一切闪闪发光的东西是一种生活方式。”'},
[5]= {'银白浪骁', '|cFF00ccff“地心之战”坐骑|r|n|n解锁“银白浪骁”水下坐骑。|n|n“有股虾味。”'},
[6]= {'皇家海羽鹦鹉', '|cFF00ccff“地心之战”坐骑|r|n|n解锁“皇家海羽鹦鹉”飞行坐骑。|n|n“看你已经成就了如此霸业，没有只巨型鹦鹉跟着你还像话吗？”'},
[7]= {'波利·罗杰', '|cFF00ccff“地心之战”坐骑|r|n|n解锁“波利·罗杰”驭空术坐骑。|n|n“船长把他自己那只喜怒无常的巨型鹦鹉送给了你。祝你好运！”|n|n|cFFFFFFFF额外坐骑：波利·罗杰|r|n|n|CFFa335ee经典怀旧服坐骑|r|n|n解锁“巫妖王之怒”飞行坐骑：“波利·罗杰”。'},
[8]= {'霸业枭雄的午夜鳄鱼', '|cFF00ccff“地心之战”坐骑|r|n|n解锁“霸业枭雄的午夜鳄鱼”坐骑。|n|n“由高品质黑色皮革制成的豪华座椅。”'},
[9]= {'判判', '|cFF00ccff“地心之战”宠物|r|n|n|cFF1eff00“霸业风暴”宠物|r解锁“判判”宠物。在“霸业风暴”中，达卡什·暗账可以帮你召唤你的宠物。|n|n“讽刺的是，并不擅长谈判。”'},
[10]= {'致命之匕', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“致命之匕”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“你是桶腿船团的手下了，杂兵。快，拿上匕首，收集财宝，成就霸业！”'},
[11]= {'黑钢利刃', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“黑钢利刃”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“为海风中的剑术对决而打造。”'},
[12]= {'有裂纹的铁斧', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“有裂纹的铁斧”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“锋利的斧子，最适合你这种威风的水手！”'},
[13]= {'钙化重剑', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“钙化重剑”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“剑其实跟匕首差不多，只是块更大的铁板而已。”'},
[14]= {'水手杂兵的铲子', '|cFF00ccff“地心之战”外观|r|n|n|cFF1eff00“霸业风暴”外观|r解锁“水手杂兵的铲子”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“你挖得到吗？”'},
[15]= {'水手杂兵的船桨', '|cFF00ccff“地心之战”外观|r|n|n|cFF1eff00“霸业风暴”外观|r解锁“水手杂兵的船桨”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“让我们荡起单桨。”'},
[16]= {'霸业枭雄的飞首斧', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的飞首斧”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“水手霸主的兵器库里可不能少了这个。”'},
[17]= {'霸业枭雄的精工细剑', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的精工细剑”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“是用来戳的。”'},
[18]= {'霸业枭雄的白银弯刀', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的白银弯刀”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“在阳光下高举的话，会发出夺目的光芒。”'},
[19]= {'霸业枭雄的鎏金符印', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的鎏金符印”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“高举霸业枭雄的法杖，集结一帮船员，成就霸业！”'},
[20]= {'霸业枭雄的萦雷飞首斧', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷飞首斧”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。'},
[21]= {'霸业枭雄的萦雷细剑', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷细剑”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。'},
[22]= {'霸业枭雄的萦雷弯刀', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷弯刀”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。'},
[23]= {'霸业枭雄的萦雷符印', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷符印”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。'},
[24]= {'铜质火炮', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“铜质火炮”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“有了这门炮，收集就是小菜一碟。”'},
[25]= {'神奇的多发火枪', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“神奇的多发火枪”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“别贴脸瞄准。”'},
[26]= {'霸业枭雄的手炮', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的手炮”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。|n|n“闻着有黄金和火药的味道。”'},
[27]= {'霸业枭雄的萦雷手炮', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷手炮”外观。欲改变“霸业风暴”中的角色外观，请与达卡什·暗账交谈。'},
[28]= {'暖意羊绒帽', '|cFF00ccff“地心之战”外观|r|n|n解锁“暖意羊绒帽”外观。|n|n“再黑心的水手也会有觉得寒心的时候。”'},
[29]= {'风暴船长帽', '|cFF00ccff“地心之战”外观|r|n|n解锁“风暴船长帽”外观。|n|n“这顶精美的帽子，最适合戴在风暴中巍然不动的船长头上！”'},
[30]= {'大副的迷人帽子', '|cFF00ccff“地心之战”外观|r|n|n解锁“大副的迷人帽子”外观。|n|n“帽子底下可是藏匿意外之财的绝佳地方。”'},
[31]= {'大副的迷人护头', '|cFF00ccff“地心之战”外观|r|n|n解锁“大副的迷人护头”外观。|n|n“帅气的造型就是最强大的竞争力。”'},
[32]= {'霸业枭雄的海军部三角帽', '|cFF00ccff“地心之战”外观|r\n|cFF1eff00“霸业风暴”外观|r\n\n解锁“霸业枭雄的海军部三角帽”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁所有该套装外观后与达卡什·暗账交谈。\n\n“精致的羽饰头盔，比着你的头型做的。”'},
[33]= {'霸业枭雄的萦雷三角帽', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷三角帽”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[34]= {'霸业枭雄的旧眼罩', '|cFF00ccff“地心之战”外观|r|n|n解锁“霸业枭雄的旧眼罩”外观。|n|n“把它戴正，你就能看到水平线。”'},
[35]= {'霸业枭雄的旧帽子', '|cFF00ccff“地心之战”外观|r|n|n解锁“霸业枭雄的旧帽子”外观。|n|n“向霸业枭雄脱帽致敬。”'},
[36]= {'霸业枭雄的单片眼镜', '|cFF00ccff“地心之战”外观|r|n|n解锁“霸业枭雄的单片眼镜”外观。|n|n“即使只有一只眼睛，有了它的帮助，也可以轻松地查看海面。”'},
[37]= {'霸业枭雄的流苏肩甲', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的流苏肩甲”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[38]= {'霸业枭雄的萦雷肩甲', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷肩甲”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[39]= {'防风斗披', '|cFF00ccff“地心之战”外观|r|n|n解锁“防风斗披”外观。|n|n“只能防风，不能防水。注意别掉进水里。”'},
[40]= {'潜伏者披风', '|cFF00ccff“地心之战”外观|r|n|n解锁“潜伏者披风”外观。|n|n“一些收集者老喜欢躲在阴影里。”'},
[41]= {'霸业枭雄的斗披', '|cFF00ccff“地心之战”外观|r|n|n解锁“霸业枭雄的斗披”外观。|n|n“当然是为了红黄搭配。”'},
[42]= {'霸业枭雄的萦雷斗披', '|cFF00ccff“地心之战”外观|r|n|n解锁“霸业枭雄的萦雷斗披”外观。'},
[43]= {'棉纺衬衣', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“棉纺衬衣”外观。|n|n“霸业风暴”的“寒酸的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁所有外观后与达卡什·暗账交谈。'},
[44]= {'精致的深红紧身上衣', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“精致的深红紧身上衣”外观。“霸业风暴”的“时髦的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[45]= {'霸业枭雄的背心', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的背心”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁所有该套装外观后与达卡什·暗账交谈。|n|n“背心好风光，土鸡变凤凰。”'},
[46]= {'霸业枭雄的萦雷背心', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷背心”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[47]= {'霸业枭雄的战袍', '|cFF00ccff“地心之战”外观|r|n解锁“霸业枭雄的战袍”外观。|n|n“你已经证明了自己是一名逍遥浪客，是桶腿船长的心腹。骄傲地展示你对大伙儿的忠诚吧。”'},
[48]= {'霸业枭雄的腕扣', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的腕扣”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁所有该套装外观后与达卡什·暗账交谈。|n|n“金色的腕扣才配得上威震天下的水手。”'},
[49]= {'霸业枭雄的萦雷腕扣', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷腕扣”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[50]= {'水手杂兵的手套', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“水手杂兵的手套”外观。“霸业风暴”的“寒酸的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“皮手套可以让你争夺宝物时手不打滑。”'},
[51]= {'骗子的无指手套', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“骗子的无指手套”外观。“霸业风暴”的“时髦的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“适合手法老练的家伙。”'},
[52]= {'霸业枭雄的收集手套', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的收集手套”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“顺滑如丝。”'},
[53]= {'霸业枭雄的萦雷收集手套', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷收集手套”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[54]= {'霸业枭雄的黄金腰链', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的黄金腰链”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“巨大的金色头骨腰带把这套装束衬托得非常醒目。”'},
[55]= {'霸业枭雄的萦雷腰链', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷腰链”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[56]= {'手织长裤', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“手织长裤”外观。“霸业风暴”的“时髦的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“船长给的礼物。是特意替你量身打造的！”'},
[57]= {'絮棉马裤', '|cFF00ccff“地心之战”外观“霸业风暴”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“絮棉马裤”外观。“霸业风暴”的“寒酸的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“给你一条新裤子，让你摔倒时有东西垫屁股。”'},
[58]= {'霸业枭雄的时髦长裤', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的时髦长裤”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“这下你的裤子就是天底下最时髦的了。”'},
[59]= {'霸业枭雄的萦雷长裤', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷长裤”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[60]= {'寡言皮靴', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“寡言皮靴”外观。“霸业风暴”的“时髦的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“有时候，躲藏就是最好的进攻。”'},
[61]= {'稳健之靴', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“稳健之靴”外观。“霸业风暴”的“寒酸的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“无论是船上还是在陆地上，它都能帮你稳住脚步。”'},
[62]= {'霸业枭雄的掠泥飞靴', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的掠泥飞靴”外观。“霸业风暴”的“豪放的水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。|n|n“可别真的沾了泥巴。”'},
[63]= {'霸业枭雄的萦雷掠泥飞靴', '|cFF00ccff“地心之战”外观|r|n|cFF1eff00“霸业风暴”外观|r|n|n解锁“霸业枭雄的萦雷掠泥飞靴”外观。“霸业风暴”的“萦雷水手杂兵”装束的一部分。欲改变“霸业风暴”中的角色装束，请在解锁该套装所有外观后与达卡什·暗账交谈。'},
[64]= {'铁钩爪', '|cFF00ccff“地心之战”坐骑|r\n\n解锁“铁钩爪”飞行坐骑。\n\n“利爪如钩，别无所求。”'},
[66]= {'微型羽饰三角帽', '|cFF00ccff“地心之战”朋友|r|n|cFF1eff00“霸业风暴”朋友|r|n|n召唤后，佩佩偶尔会打扮成霸业枭雄的模样。要在霸业风暴中召唤小小船长，就去找达卡什·暗账吧。'},
[67]= {'黑心警告标志', '|cFF00ccff“地心之战”玩具|r|n|n解锁黑心警告标志玩具。|n|n“举办自己的水手聚会时的完美之选。”'},
[68]= {'一袋收集的250枚商贩标币', '|cFF00ccff“地心之战”奖励|r|n|n解锁250枚商贩标币，就在暴风城或奥格瑞玛的收集者的宝箱里。'},
[69]= {'一箱收集的500枚商贩标币', '|cFF00ccff“地心之战”奖励|r|n|n解锁500枚商贩标币，就在暴风城或奥格瑞玛的收集者的宝箱里。'},

}





    do
        for categoryID, data in pairs(categoryTab) do
            local info= C_AccountStore.GetCategoryInfo(categoryID)
            if info and info.icon==data[2] then
                WoWTools_ChineseMixin:SetCN(info.name, data[1])
            end
        end
        for itemID, data in pairs(itemTab) do
            local info= C_AccountStore.GetItemInfo(itemID)
            if info then
                WoWTools_ChineseMixin:SetCN(info.name, data[1])
                WoWTools_ChineseMixin:SetCN(info.description, data[2])
            end
        end
    end

    itemTab=nil
    categoryTab=nil