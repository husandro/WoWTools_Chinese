function WoWTools_ChineseMixin:SetCNFont(lable)
    if lable then
        local _, size2, fontFlag2= lable:GetFont()
        lable:SetFont('Fonts\\ARHei.ttf', size2, fontFlag2 or 'OUTLINE')
    end
end



function WoWTools_ChineseMixin:Cstr(frame, tab)
    tab= tab or {}
    frame= frame or UIParent
    local name= tab.name
    local alpha= tab.alpha
    local font= tab.changeFont
    local layer= tab.layer or 'OVERLAY'
    local fontName= tab.fontName or 'GameFontNormal'
    local copyFont= tab.copyFont
    local size= tab.size or 12
    local justifyH= tab.justifyH
    local notFlag= tab.notFlag
    local notShadow= tab.notShadow
    local color= tab.color
    local mouse= tab.mouse
    local wheel= tab.wheel

    font = font or frame:CreateFontString(name, layer, fontName)
    if copyFont then
        local fontName2, size2, fontFlag2 = copyFont:GetFont()
        font:SetFont(fontName2, size or size2, fontFlag2)
        font:SetTextColor(copyFont:GetTextColor())
        font:SetFontObject(copyFont:GetFontObject())
        font:SetShadowColor(copyFont:GetShadowColor())
        font:SetShadowOffset(copyFont:GetShadowOffset())
        if justifyH then font:SetJustifyH(justifyH) end
        --if alpha then font:SetAlpha(alpha) end
    else
        local _, size2, fontFlag2= font:GetFont()
        font:SetFont('Fonts\\ARHei.ttf', size or size2, notFlag and fontFlag2 or 'OUTLINE')
        font:SetJustifyH(justifyH or 'LEFT')
    end
    if not notShadow then
        font:SetShadowOffset(1, -1)
    end
    if color~=false then
        if type(color)=='table' then
            font:SetTextColor(color.r, color.g, color.b, color.a or 1)
        else
            font:SetTextColor(1, 0.82, 0, 1)
        end
    end
    if mouse then
        font:EnableMouse(true)
    end
    if wheel then
        font:EnableMouseWheel(true)
    end
    if alpha then
        font:SetAlpha(alpha)
    end
    return font
end











function WoWTools_ChineseMixin:GetQuestID()
    if QuestInfoFrame.questLog then
       return C_QuestLog.GetSelectedQuest()
    else
       return GetQuestID()
    end
end







function WoWTools_ChineseMixin:Magic(text)
    local tab= {'%.', '%(','%)','%+', '%-', '%*', '%?', '%[', '%^'}
    for _,v in pairs(tab) do
        text= text:gsub(v,'%%'..v)
    end
    tab={
        ['%%%d%$s']= '%(%.%-%)',
        ['%%s']= '%(%.%-%)',
        ['%%%d%$d']= '%(%%d%+%)',
        ['%%d']= '%(%%d%+%)',
    }
    local find
    for k,v in pairs(tab) do
        text= text:gsub(k,v)
        find=true
    end
    if find then
        tab={'%$'}
    else
        tab={'%%','%$'}
    end
    for _, v in pairs(tab) do
        text= text:gsub(v,'%%'..v)
    end
    return text
end



function WoWTools_ChineseMixin:MK(number, bit)
    if not number then
        return
    end
    bit = bit or 1

    local text= ''
    if number>=1e6 then
        number= number/1e6
        text= 'm'
    elseif number>= 1e4 then
        number= number/1e4
        text='w'
    elseif number>=1e3 then
        number= number/1e3
        text= 'k'
    end
    if bit==0 then
        number= math.modf(number)
        number= number==0 and 0 or number
        return number..text--format('%i', number)..text
    else
        local num, point= math.modf(number)
        if point==0 then
            return num..text
        else---0.5/10^bit
            return format('%0.'..bit..'f', number)..text
        end
    end
end

















--[[
    function WoWTools_ChineseMixin:GetPlayerInfo(unit, guid, name, tab)
        if type(unit)=='table' then
            tab= unit
        else
            tab= tab or {}
        end


        unit= unit or tab.unit or (guid and UnitTokenFromGUID(guid))
        name= name or tab.name
        guid= guid or tab.guid or (UnitExists(unit) and UnitGUID(unit)) or self:GetGUID(unit, name)
        

        local faction= tab.faction
        local reLink= tab.reLink
        local reName= tab.reName
        local reNotRegion= tab.reNotRegion
        local reRealm= tab.reRealm
        local size= tab.size or 0


        if guid==WoWTools_DataMixin.Player.GUID
            or name==WoWTools_DataMixin.Player.Name
            or name==WoWTools_DataMixin.Player.name_realm
        then
            return WoWTools_DataMixin.Icon.Player
                ..(
                    (reName or reLink) and WoWTools_DataMixin.Player.col..(WoWTools_DataMixin.onlyChinese and '我' or COMBATLOG_FILTER_STRING_ME)..'|r' or ''
                )..'|A:auctionhouse-icon-favorite:0:0|a'
        end

        if reLink then
            return self:GetLink(unit, guid, name, true) --玩家超链接
        end



        local text
        if guid and C_PlayerInfo.GUIDIsPlayer(guid) then
            local _, englishClass, _, englishRace, sex, name2, realm = GetPlayerInfoByGUID(guid)
            name= name2

            if guid and (not faction or unit) then
                if WoWTools_DataMixin.GroupGuid[guid] then
                    unit = unit or WoWTools_DataMixin.GroupGuid[guid].unit
                    faction= faction or WoWTools_DataMixin.GroupGuid[guid].faction
                end
            end

            local friend= self:GetIsFriendIcon(nil, guid, nil)--检测, 是否好友
            local groupInfo= WoWTools_DataMixin.GroupGuid[guid] or {}--队伍成员
            local server= not reNotRegion and WoWTools_RealmMixin:Get_Region(realm)--服务器，EU， US {col=, text=, realm=}

            text= (server and server.col or '')
                        ..(friend or '')
                        ..(self:GetFaction(unit, faction, nil, {size=size}) or '')--检查, 是否同一阵营
                        ..(self:GetRaceIcon(unit, guid, englishRace, {sex=sex, size=size}) or '')
                        ..(self:GetClassIcon(unit, guid, englishClass, {size=size}) or '')

            if groupInfo.combatRole=='HEALER' or groupInfo.combatRole=='TANK' then--职业图标
                text= text..WoWTools_DataMixin.Icon[groupInfo.combatRole]..(groupInfo.subgroup or '')
            end
            if reName and name then
                if reRealm then
                    if not realm or realm=='' or realm==WoWTools_DataMixin.Player.realm then
                        text= text..name
                    else
                        text= text..name..'-'..realm
                    end
                else
                    text= text..self:NameRemoveRealm(name, realm)
                end
    --等级 
                local unitLevel= tab.level
                    or (unit and UnitLevel(name))
                    or guid and WoWTools_WoWDate[guid] and WoWTools_WoWDate[guid].level
                if unitLevel and unitLevel~=0 and GetMaxLevelForLatestExpansion()~=unitLevel then
                    text= text..'|cnGREEN_FONT_COLOR:'..unitLevel..'|r'
                end

                text= '|c'..select(4,GetClassColor(englishClass))..text..'|r'
            end
        end


        if (not text or text=='') and name then
            if reLink then
                return self:GetLink(unit, guid, name, true) --玩家超链接

            elseif reName then
                if not reRealm then
                    name= self:NameRemoveRealm(name)
                end
                text= name
            end
        end

        return text or ''
    end
]]




