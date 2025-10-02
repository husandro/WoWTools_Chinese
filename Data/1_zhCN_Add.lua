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
['COMBAT_LOG']= "战斗记录",
['GRAPHICS_HEADER']= "图形",
['ADDON_DISABLED']= "禁用",
['EMOTE67_CMD1']= "/不"    ,
['GRAPHICS_LABEL']= "图形",
['SPELLBOOK']= "法术书",
['COLOR']= "颜色",
['POI_FOCUS'] = "焦点",
['PROFESSIONS_SPECIALIZATIONS_TAB_NAME'] = "专精",
['GENERAL_LABEL'] = "综合",
}




local tabString={
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE)]= "|TInterface\\FriendsFrame\\StatusIcon-Online:16:16|t 有空",
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY)]= "|TInterface\\FriendsFrame\\StatusIcon-Away:16:16|t 离开",
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY)]= "|TInterface\\FriendsFrame\\StatusIcon-DnD:16:16|t 忙碌",

[CURRENCY_FILTER_TYPE_CHARACTER:format(UnitName('player'))] = "仅限|A:auctionhouse-icon-favorite:0:0|a我",
    --['Alliance', '联盟')
    --'Horde', '部落')
}


local tabItem= {
    [6948]= '炉石',
    [5956]= '铁匠锤',
    [6256]= '鱼竿',
    [211806]= '鎏金之瓶',
    [3868]= '附魔羊皮纸',
    [85663]= '草药师的铲子',
    [226204]= '刚做的羊皮纸',
    [39505]= '学者的书写工具',
    [2901]= '矿工锄',
    [210828]= '稀释溶液',
    [212754]= '晶铸大锅',
    [227208]= '铋棒',
    [222700]= '香料颗粒',
    [222701]= '面粉块',
    [6218]= '符文铜棒',
    [20815]= '珠宝匠的工具套装',
    [6219]= '弧光扳手',
    [10498]= '侏儒微调器',
    [64670]= '褪魔粉',
    [109253]= '终极版侏儒军刀',
    [219948]= '风暴之尘',
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
    WoWTools_ChineseMixin:SetCN(EJ_GetTierInfo(2), '燃烧远征')
    WoWTools_ChineseMixin:SetCN(EJ_GetTierInfo(EJ_GetNumTiers()), '本赛季')

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




