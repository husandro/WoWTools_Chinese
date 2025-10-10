--添加，自定义

local tab_G={
['STAT_CRITICAL_STRIKE']= "爆击",
['SPEED']= "速度",
['SPLASH_BATTLEFORAZEROTH_8_1_0_2_RIGHT_TITLE']= "达萨罗之战",
['EXPANSION_NAME2']= "巫妖王之怒",
['GLYPHS']= "雕文",
['AUCTION_HOUSE_DROPDOWN_REMOVE_FAVORITE']= "从偏好中移除",
['AUCTION_HOUSE_DROPDOWN_SET_FAVORITE']= "设置为偏好",
['TOOLTIP_BATTLE_PET']= "战斗宠物",
['GRAPHICS_HEADER']= "图形",
['ADDON_DISABLED']= "禁用",
['EMOTE67_CMD1']= "/不"    ,
['GRAPHICS_LABEL']= "图形",
['SPELLBOOK']= "法术书",
['COLOR']= "颜色",
['POI_FOCUS'] = "焦点",
['PROFESSIONS_SPECIALIZATIONS_TAB_NAME'] = "专精",
['GENERAL_LABEL'] = "综合",
['COMBAT_LOG'] = "战斗记录",
['CATALOG_SHOP_BACK'] = "返回",
['IGNORE'] = "屏蔽",
}
for en, cn in pairs(tab_G) do
    WoWTools_ChineseMixin:SetCN(_G[en], cn)
end



local tabString={
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE)]= "|TInterface\\FriendsFrame\\StatusIcon-Online:16:16|t 有空",
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY)]= "|TInterface\\FriendsFrame\\StatusIcon-Away:16:16|t 离开",
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY)]= "|TInterface\\FriendsFrame\\StatusIcon-DnD:16:16|t 忙碌",

[CURRENCY_FILTER_TYPE_CHARACTER:format(UnitName('player'))] = "仅限|A:auctionhouse-icon-favorite:0:0|a我",
    --['Alliance', '联盟')
    --'Horde', '部落')
}


local tabItem= {
[60223]= '大火力推膛枪',
[219948]= '风暴之尘',
[219951]= '粼光碎片',
[219955]= '耀辉水晶',
[221757]= '幽邃之皮',
[221754]= '喧鸣深窟金属锭',
[221758]= '被亵渎的火绒盒',
[221756]= '一瓶卡赫提之油',
[221763]= '铬绿魅菇',
[213611]= '蠕动样本',
[213610]= '晶脉粉末',
[213613]= '魔网残渣',
[213612]= '新绿孢子',
[211806]= '鎏金之瓶',
[210828]= '稀释溶液',
[85663]= '草药师的铲子',
[212754]= '晶铸大锅',
[5956]= '铁匠锤',
[226202]= '回音助熔剂',
[38682]= '附魔羊皮纸',
[227208]= '铋棒',
[6256]= '鱼竿',
[226204]= '刚做的羊皮纸',
[226205]= '蒸馏的阿加淡水',
[39505]= '学者的书写工具',
[200860]= '巨龙塞子',
[222695]= '盘绕草药',
[222696]= '松脆的胡椒',
[222697]= '心核隧途之尘',
[222699]= '卡兹阿加番茄',
[222700]= '香料颗粒',
[222701]= '面粉块',
[6218]= '符文铜棒',
[20815]= '珠宝匠的工具套装',
[6219]= '弧光扳手',
[10498]= '侏儒微调器',
[64670]= '褪魔粉',
[2901]= '矿工锄',
[188152]= '传送门控制碎片',
[212498]= '背反琥珀',
[213398]= '一把砾石',
[213399]= '流光玻璃',
[7005]= '剥皮小刀',
[224764]= '苔绒羱之线',
[228930]= '装饰绶带',
[10290]= '粉红染料',
[6261]= '橙色染料',
[6260]= '蓝色染料',
[4342]= '紫色染料',
[4341]= '黄色染料',
[4340]= '灰色染料',
[2605]= '绿色染料',
[2604]= '红色染料',
[2325]= '黑色染料',
[2324]= '漂白液',
[219150]= '一堆锈蚀的碎片',
[228414]= '缺损接线',
[228956]= '垃圾之桶',
}













do
    for itemID, text in pairs(tabItem) do
        ItemEventListener:AddCancelableCallback(itemID, function()
            WoWTools_ChineseMixin:SetCN(C_Item.GetItemNameByID(itemID), text)
        end)
    end
end
tabItem=nil


EventRegistry:RegisterFrameEventAndCallback("LOADING_SCREEN_DISABLED", function(owner)
    local name= EJ_GetTierInfo(2)
    if not WoWTools_ChineseMixin:CN(name) then
        WoWTools_ChineseMixin:SetCN(name, '燃烧远征')
    end
    name= EJ_GetTierInfo(EJ_GetNumTiers())
    if not WoWTools_ChineseMixin:CN(name) then
        WoWTools_ChineseMixin:SetCN(name, '本赛季')
    end

    do
        for en, cn in pairs(tab_G) do
            WoWTools_ChineseMixin:SetCN(_G[en], cn)
        end

        for en, cn in pairs(tabString) do
            WoWTools_ChineseMixin:SetCN(en, cn)
        end
    end

    tab_G=nil
    tabString=nil

    EventRegistry:UnregisterCallback('LOADING_SCREEN_DISABLED', owner)
end)
