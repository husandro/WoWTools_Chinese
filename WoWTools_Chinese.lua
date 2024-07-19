local e= select(2, ...)
--e.Not_Is_EU= (GetCurrentRegion()~=3 and not IsPublicBuild()) or LOCALE_zhCN or LOCALE_zhTW

e.strText={--主要，汉化    
    --[GetClassInfo(13)] = "|cff33937f唤魔师|r",

}



















function e.Get_HoliDay_Info()end---tab.holydayID eventID {'名称', '描述}
function e.Get_Boss_Description()end---tab.journalEncounterID
function e.Get_Instance_Description()end---tab.instanceID
function e.Get_PerksActivity_Info()end---tab.perksActivityID {'名称', '描述}
function e.Get_Vignette_Name()end--tab.vignetteID
function e.Get_Title_Name()end--e.Get_Title_Name(titleID) 头衔

function e.Get_Pet_Description()end---tab.speciesID
function e.Get_Pet_Ablity_Info()end---tab.petAbilityID {'名称', '描述}

--{itemID, isName, isToy, isHeirloom}
function e.Get_Toy_Source()end
function e.Get_Heirloom_Source()end

function e.Get_SkillLineAbility_Name()end--tab.skillLineAbilityID 专业配方，名称
function e.Get_TradeSkillCategory_Name()end---tab.skillCategoryID 专业目录，名称
function e.Get_Recipe_Source()end--配方，来源
function e.Get_Profession_Node_Desc()end--tab.nodeID

function e.Get_LFGDungeon_Desc()end--tab.lfgDungeonID
--WoW_Tools_Chinese_CN(text, tab) = e.cn(...) 全局 Func.lua

function e.ReplaceText()end-- WoWeuCN_Tooltips
function e.Get_Item_Data()end--物品数据
function e.Get_Spell_Data()end--法术数据，{'名称', '1', '2', ...}
function e.Get_Quest_Info()end--e.Get_Quest_Info(tab.questID, tab.isName, tab.isObject, tab.isDesc) {['Title']='标题', ['Objectives']='目标描述', ['Description']='描述'}
function e.Get_Unit_Name()end--e.Get_Unit_Name(tab.unit, tab.npcID) NPC return 名称，头衔
function e.Get_Unit_Info()end--e.Get_Unit_Name(tab.unit, tab.npcID) NPC return {'名称', '头衔'}











function e.cn(text, tab)
    local cnName=text and e.strText[text]
    if cnName then
        return cnName
    end
    local data
    if type(tab)=='table' then
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
            else
                data= e.Get_Spell_Data(tab.spellID)
            end

        elseif tab.itemID then
            if tab.isName then
                data= e.Get_Item_Name(tab.itemID)--物品名称

            elseif tab.isToy then
                data= e.Get_Toy_Source(itemID)

            elseif tab.isHeirloom then
                data= e.Get_Heirloom_Source(itemID)
            end

        elseif tab.skillLineAbilityID then
            data= e.Get_SkillLineAbility_Name(tab.skillLineAbilityID)--专业配方,名称

        elseif tab.recipeID then
            data= e.Get_Recipe_Source(tab.recipeID)--专业配方,来源

        elseif tab.ProfessionNodeID then
            data= e.Get_Profession_Node_Desc(tab.ProfessionNodeID)

        elseif tab.lfgDungeonID then
            data= e.Get_LFGDungeon_Desc(tab.lfgDungeonID)

        elseif tab.questID then
            data= e.Get_Quest_Info(tab.questID, tab.isName, tab.isObject, tab.isDesc)

        elseif tab.npcID or tab.unit then
            data= e.Get_Unit_Info(tab.unit, tab.npcID)

        elseif tab.titleID then
            data= e.Get_Title_Name(tab.titleID)
        end
    end
    return data or text
end
WoW_Tools_Chinese_CN= e.cn









function e.Get_Item_Name(itemID)
    if itemID then
        local data= e.Get_Item_Data(itemID)
        if data then
            return data[1]
        end
    end
end

function e.Get_Spell_Name(spellID)
    if spellID then
        local data= e.Get_Spell_Data(spellID)
        if data then
            return e.ReplaceText(data[1])
        end
    end
end




function e.Get_Recipe_Name(recipeInfo, hyperlink)
    local name
    hyperlink= hyperlink or (recipeInfo and recipeInfo.hyperlink)

    local color
    if hyperlink then
        local item = Item:CreateFromItemLink(hyperlink)
        color= (item:GetItemQualityColor() or {}).color
        name= e.Get_Item_Name(item:GetItemID()) or e.strText[item:GetItemName()]
    end
    if not name and recipeInfo then
        name= e.Get_SkillLineAbility_Name(recipeInfo.skillLineAbilityID)
    end
    if name and color then
        name= WrapTextInColor(name, color)
    end

    return name
end

















function e.font(lable)
    if lable then
        local _, size2, fontFlag2= lable:GetFont()
        lable:SetFont('Fonts\\ARHei.ttf', size2, fontFlag2 or 'OUTLINE')
    end
end

local function set(frame, text)
    if not frame then
        return
    end
    local p
    if not text then
        if frame.GetText then
            text= frame:GetText()
            p=text
        elseif frame:GetObjectType()=='Button' then
            local font= frame:GetFontString()
            if font then
                text= font:GetText()
                p=text
            end
        elseif frame.Text or frame.text or frame.Label then
            local label= frame.Text or frame.text or frame.Label
            text= label:GetText()
            frame= label
        else
            for _, region in pairs({frame:GetRegions()}) do
                if region:GetObjectType()=='FontString' then
                    text= region:GetText()
                    frame= region
                    break
                end
            end
        end
    end
    local col, name
    if text then
        col, name=text:match('^(|c........)(.+)|r$')
        text= e.strText[name or text]
    end
    if text and text~='' then
        if col then
            text= col..text..'|r'
        end
        if p~=text then
            frame:SetText(text)
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
        if not label.hook_chines then
            hooksecurefunc(label, 'SetText', function(self, name)
                set(self, name)
            end)
            label.hook_chines=true
        end
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
        if not btn.hook_chines then
            hooksecurefunc(btn, 'SetText', function(self, name)
                if name and name~='' then
                    local cnName= e.strText[name]
                    if cnName then
                        self:SetText(cnName)
                    end
                end
            end)
            btn.hook_chines=true
        end
    end
end

function e.region(frame, setFont, isHook)
    if frame then
        if isHook then
            e.hookLabel(label, setFont)
        else
            C_Timer.After(2, function()
                for _, region in pairs({frame:GetRegions()}) do
                    if region:GetObjectType()=='FontString' then
                        e.set(region, setFont)
                        
                    end
                end
            end)
        end
    end
end



function e.tabSet(frame, setFont, padding, minWidth, absoluteSize)
    for _, tabID in pairs(frame:GetTabSet() or {}) do
        local btn= frame:GetTabButton(tabID)
        e.set(btn.Text or btn)

        PanelTemplates_TabResize(frame, padding or 20, absoluteSize, minWidth or 70)
    end
    --PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
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





function e.Get_QuestID()
    if QuestInfoFrame.questLog then
       return C_QuestLog.GetSelectedQuest()
    else
       return GetQuestID()
    end
 end



















































C_Timer.After(6, function()
    e.strText['']=nil
end)

