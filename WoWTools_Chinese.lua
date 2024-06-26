local e= select(2, ...)
--e.Not_Is_EU= (GetCurrentRegion()~=3 and not IsPublicBuild()) or LOCALE_zhCN or LOCALE_zhTW

e.strText={}--主要，汉化


--WoW_Tools_Chinese_CN(text, tab) = e.cn(...) 全局 Func.lua
function e.cn(text, tab)--{gossipOptionID=, questID=}
    if text then
        return e.strText[text] or text

    elseif tab then
        if tab.holydayID then
            return e.Get_HoliDay_Info(tab.holydayID)--eventID

        elseif tab.journalEncounterID then
            return e.Get_Boss_Description(tab.journalEncounterID)

        elseif tab.instanceID then
            return e.Get_Instance_Description(tab.instanceID)

        elseif tab.perksActivityID then
            return e.Get_PerksActivity_Info(tab.perksActivityID)

        elseif tab.vignetteID then
            return e.Get_Vignette_Name(tab.vignetteID)

        elseif tab.toyID then
            return e.Set_Toy_Source(tab.toyID)

        elseif tab.speciesID then
            return e.Get_Pet_Description(tab.speciesID)

        elseif tab.petAbilityID then
            return e.Get_Pet_Ablity_Info(tab.petAbilityID)

        elseif tab.skillCategoryID then
            return e.Get_TradeSkillCategory_Name(skillCategoryID)

        elseif tab.spellID then
            if tab.isName then

            elseif isDesc then
                return e.Get_Spell_Desc(tab.spellID, tab.isAura)
            end
        end
    end
end
WoW_Tools_Chinese_CN= e.cn






function e.font(lable)
    if lable then
        local _, size2, fontFlag2= lable:GetFont()
        lable:SetFont('Fonts\\ARHei.ttf', size2, fontFlag2 or 'OUTLINE')
    end
end

local function set(label, text)
    text= text or label:GetText()
    text= e.strText[text]
    if text then
        label:SetText(text)
    end
end
function e.set(label, text, affer, setFont)
    if label then
        if setFont then
            e.font(lable)
        end
        if affer then
            C_Timer.After(affer, function() set(label, text) end)
        else
            set(label, text)
        end
    end
end

function e.dia(string, tab)
    if StaticPopupDialogs[string] then
        for name, text in pairs(tab) do
            if StaticPopupDialogs[string][name] then
                StaticPopupDialogs[string][name]= text
            end
        end
    end
end

function e.hookDia(string, text, func)
    if StaticPopupDialogs[string] then
        if StaticPopupDialogs[string][text] then
            hooksecurefunc(StaticPopupDialogs[string], text, func)
        else
            StaticPopupDialogs[string][text]=func
        end
    end
end

function e.hookLabel(label, setFont)
    if label and label.SetText then
        if setFont then
            e.font(label)
        end
        e.set(label)
       hooksecurefunc(label, 'SetText', function(self, name)
            set(self, name)
        end)
    end
end

function e.setButton(btn, setFont)
    local label= btn and btn:GetFontString()
    if label then
        if setFont then
            e.font(label)
        end
        e.set(label)
    end
end

function e.hookButton(btn, setFont)
    if btn and btn.SetText then
        if setFont then
            e.font(btn:GetFontString())
        end
        local label= btn:GetFontString()
        if label then
            e.set(labe)
        end
        hooksecurefunc(btn, 'SetText', function(self, name)
            name= e.strText[name]
            if name then
                self:SetText(name)
            end
        end)
    end
end





function e.reg(self, text, index)
    if self then
        for i, region in pairs({self:GetRegions()}) do
            if region:GetObjectType()=='FontString' and (index==i or not index) then
                text= index==i and text or e.strText[region:GetText()]
                set(region, text)
                if index then
                    return
                end
            end
        end
    end
end
































--[[##############
--创建, 添加控制面板
--##############
local variableIndex=0
local function get_variableIndex()
    variableIndex= variableIndex+1
    return variableIndex
end
--插件名称
local Category = Settings.RegisterVerticalLayoutCategory('|TInterface\\AddOns\\WoWTools_Chinese\\Sesource\\WoWtools.tga:0|t|cffff00ffWoW|r |cff00ff00Tools|r_|cff28a3ffChinese|r')
Settings.RegisterAddOnCategory(Category)
function e.AddPanel_Check(tab)
    local name = tab.name
    local tooltip = tab.tooltip
    local category= tab.category or Category
    local defaultValue= tab.value and true or false
    local func= tab.func

    local variable = id..name..(category.order or '')..get_variableIndex()
    local setting= Settings.RegisterAddOnSetting(category, name, variable, type(defaultValue), defaultValue)

    local initializer= Settings.CreateCheckboxWithOptions(category, setting, nil, tooltip);
    Settings.SetOnValueChangedCallback(variable, func, initializer)
    return initializer
end

function e.GetEnabeleDisable(ed)--启用或禁用字符
    return ed and '|cnGREEN_FONT_COLOR:启用|r' or '|cnRED_FONT_COLOR:禁用|r'
end
]]



function e.Cstr(self, tab)
    tab= tab or {}
    self= self or UIParent
    local name= tab.name
    local alpha= tab.alpha
    local font= tab.changeFont
    local layer= tab.layer or 'OVERLAY'--BACKGROUND BORDER ARTWORK OVERLAY HIGHLIGHT
    local fontName= tab.fontName or 'GameFontNormal'
    --local level= tab.level or self:GetFrameLevel()+1
    local copyFont= tab.copyFont
    local size= tab.size or 12
    local justifyH= tab.justifyH
    local notFlag= tab.notFlag
    local notShadow= tab.notShadow
    local color= tab.color
    local mouse= tab.mouse
    local wheel= tab.wheel

    font = font or self:CreateFontString(name, layer, fontName)
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
        if color==true then--颜色
            e.Set_Label_Texture_Color(font, {type='FontString'})
        elseif type(color)=='table' then
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




















--local battleTag= select(2, BNGetInfo())
--local baseClass= UnitClassBase('player')
--local playerRealm= GetRealmName():gsub(' ', '')
e.Player={
    class= UnitClassBase('player'),
    sex= UnitSex("player"),
}
    --[[realm= playerRealm,
    Realms= {},--多服务器
    name_realm= UnitName('player')..'-'..playerRealm,
    name= UnitName('player'),
    sex= UnitSex("player"),
    class= baseClass,
    r= GetClassColor(baseClass),
    g= select(2,GetClassColor(baseClass)),
    b= select(3, GetClassColor(baseClass)),
    col= '|c'..select(4, GetClassColor(baseClass)),
    cn= GetCurrentRegion()==5,
    region= GetCurrentRegion(),--1US (includes Brazil and Oceania) 2Korea 3Europe (includes Russia) 4Taiwan 5China
    --Lo= GetLocale(),
    week= GetWeek(),--周数
    guid= UnitGUID('player'),
    levelMax= UnitLevel('player')==MAX_PLAYER_LEVEL,--玩家是否最高等级
    level= UnitLevel('player'),--UnitEffectiveLevel('player')
    husandro= battleTag== '古月剑龙#5972' or battleTag=='SandroChina#2690' or battleTag=='Sandro126#2297' or battleTag=='Sandro163EU#2603',
    faction= UnitFactionGroup('player'),--玩家, 派系  "Alliance", "Horde", "Neutral"
    Layer= nil, --位面数字
    --useColor= nil,--使用颜色
    L={},--多语言，文本]]



