local e= select(2, ...)
--e.Not_Is_EU= (GetCurrentRegion()~=3 and not IsPublicBuild()) or LOCALE_zhCN or LOCALE_zhTW

e.strText={--主要，汉化    
    --[GetClassInfo(13)] = "|cff33937f唤魔师|r",

}


function e.Get_HoliDay_Info()end---tab.holydayID eventID
function e.Get_Boss_Description()end---tab.journalEncounterID
function e.Get_Instance_Description()end---tab.instanceID
function e.Get_PerksActivity_Info()end---tab.perksActivityID
function e.Get_Vignette_Name()end---tab.vignetteID
function e.Get_Pet_Description()end---tab.speciesID
function e.Get_Pet_Ablity_Info()end---tab.petAbilityID
function e.Get_Spell_Name()end---tab.spellID

--{itemID, isName, isToy, isHeirloom}
function e.Get_Item_Search_Name()end--tab.itemID
function e.Get_Toy_Source()end
function e.Get_Heirloom_Source()end

function e.Get_SkillLineAbility_Name()end--tab.skillLineAbilityID 专业配方，名称
function e.Get_TradeSkillCategory_Name()end---tab.skillCategoryID 专业目录，名称
function e.Get_Recipe_Source()end--配方，来源


function e.Get_LFGDungeon_Desc() end--tab.lfgDungeonID
--WoW_Tools_Chinese_CN(text, tab) = e.cn(...) 全局 Func.lua

function e.cn(text, tab)
    local cnName=text and e.strText[text]
    if cnName then
        return cnName
    end
    local data
    if tab and type(tab)=='table' then
        if tab.holydayID then
            data= e.Get_HoliDay_Info(tab.holydayID)--节日 eventID

        elseif tab.journalEncounterID then
            data= e.Get_Boss_Description(tab.journalEncounterID)--BOOS

        elseif tab.instanceID then
            data= e.Get_Instance_Description(tab.instanceID)--副本

        elseif tab.perksActivityID then
            data= e.Get_PerksActivity_Info(tab.perksActivityID)--PERKS

        elseif tab.vignetteID then
            data= e.Get_Vignette_Name(tab.vignetteID)--Vignette

        elseif tab.toyID then
            data= e.Get_Toy_Source(tab.toyID)--玩具itemID

        elseif tab.speciesID then
            data= e.Get_Pet_Description(tab.speciesID)--专精

        elseif tab.petAbilityID then
            data= e.Get_Pet_Ablity_Info(tab.petAbilityID)--宠物技能

        elseif tab.skillCategoryID then
            data= e.Get_TradeSkillCategory_Name(tab.skillCategoryID)--专业目录

        elseif tab.spellID then
            if tab.isName then
                data= e.Get_Spell_Name(tab.spellID)--法术名称
            end

        elseif tab.itemID then
            if tab.isName then
                data= e.Get_Item_Search_Name(tab.itemID)--物品名称

            elseif tab.isToy then
                data= e.Get_Toy_Source(itemID)

            elseif tab.isHeirloom then
                data= e.Get_Heirloom_Source(itemID)
            end

        elseif tab.skillLineAbilityID then
            data= e.Get_SkillLineAbility_Name(tab.skillLineAbilityID)--专业配方,名称

        elseif tab.recipeID then
            data= e.Get_Recipe_Source(tab.recipeID)--专业配方,来源

        elseif tab.lfgDungeonID then
            data= e.Get_LFGDungeon_Desc(tab.lfgDungeonID)
        end
    end
    return data or text
end
WoW_Tools_Chinese_CN= e.cn






function e.font(lable)
    if lable then
        local _, size2, fontFlag2= lable:GetFont()
        lable:SetFont('Fonts\\ARHei.ttf', size2, fontFlag2 or 'OUTLINE')
    end
end

local function set(label, text)
    if label then
        if not text then
            if label.GetText then
                text= label:GetText()
            elseif label:GetObjectType(labe)=='Button' then
                local font= label:GetFontString()
                text= font and font:GetText()
            end
        end
        text= text and e.strText[text]
        if text then
            label:SetText(text)
        end
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

--[[function e.setButton(btn, setFont)
    local label= btn and btn:GetFontString()
    if label then
        if setFont then
            e.font(label)
        end
        e.set(label)
    end
end]]

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
            if name and name~='' then
                local cnName= e.strText[name]                
                if cnName then
                    self:SetText(cnName)
                end
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

















