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
['GENERAL']= "综合",
['COLOR']= "颜色",
['POI_FOCUS'] = "焦点",
['PROFESSIONS_SPECIALIZATIONS_TAB_NAME'] = "专精",
}




local tabString={
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_ONLINE, FRIENDS_LIST_AVAILABLE)]= "|TInterface\\FriendsFrame\\StatusIcon-Online:16:16|t 有空",
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_AFK, FRIENDS_LIST_AWAY)]= "|TInterface\\FriendsFrame\\StatusIcon-Away:16:16|t 离开",
[format('\124T%s.tga:16:16:0:0\124t %s', FRIENDS_TEXTURE_DND, FRIENDS_LIST_BUSY)]= "|TInterface\\FriendsFrame\\StatusIcon-DnD:16:16|t 忙碌",
}


local tabItem= {
    [6948]= '炉石',
}


EventRegistry:RegisterFrameEventAndCallback("LOADING_SCREEN_DISABLED", function(owner)
    do
        for itemID, text in pairs(tabItem) do
            WoWTools_ChineseMixin:SetCN(C_Item.GetItemNameByID(itemID), text)
        end
    end
    tabItem=nil

    WoWTools_ChineseMixin:SetCN(EJ_GetTierInfo(2), '燃烧远征')
    WoWTools_ChineseMixin:SetCN('Alliance', '联盟')
    WoWTools_ChineseMixin:SetCN('Horde', '部落')
    WoWTools_ChineseMixin:SetCN('Neutral', '中立')

    EventRegistry:UnregisterCallback('LOADING_SCREEN_DISABLED', owner)
end)



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
