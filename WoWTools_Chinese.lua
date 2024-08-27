local e= select(2, ...)
--e.Not_Is_EU= (GetCurrentRegion()~=3 and not IsPublicBuild()) or LOCALE_zhCN or LOCALE_zhTW
















function e.Get_HoliDay_Desc()end--{holydayID=eventID} {'名称', '描述}
function e.Get_HoliDay_Name()end--{holydayID, isName}
function e.Get_HoliDay_Info()end--{holydayID, isDesc}


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
function e.Get_Instance_Desc()end---tab.instanceID
function e.Get_Scenario_Name()end--{scenarioID, isName}
function e.Get_Scenario_Step_Info()end--{tab.scenarioID, tab.stepIndex}

function e.Get_Boss_Name()end--tab.journalEncounterID
function e.Get_Boss_Desc()end
function e.Get_Boss_Info()end
function e.Get_Boos_Section_Info()end--(sectionID, difficultyID)
function e.Get_Boos_Section_Name()end--(sectionID, difficultyID)
function e.Get_Boos_Section_Desc()end--(sectionID, difficultyID)


--WoW_Tools_Chinese_CN(text, tab) = e.cn(...) 全局 Func.lua

function e.ReplaceText()end-- WoWeuCN_Tooltips

function e.Get_Quest_Info()end--e.Get_Quest_Info(tab.questID, tab.isName, tab.isObject, tab.isDesc) {['Title']='标题', ['Objectives']='目标描述', ['Description']='描述'}
function e.Get_Quest_Object()end--{questID=1, index=1, isObject=true}
function e.Get_Unit_Name()end--e.Get_Unit_Name(tab.unit, tab.npcID) NPC return 名称，头衔
function e.Get_Unit_Info()end--e.Get_Unit_Name(tab.unit, tab.npcID) NPC return {'名称', '头衔'}


function e.Get_Item_Info()end--物品数据
function e.Get_Item_Name()end
function e.Get_Item_Desc()end--{itemID, index}

function e.Get_Spell_Data()end -- 初始func, 法术数据，{'名称', '1', '2', ...}
function e.Get_Spell_Name()end --{spellID, isName}
function e.Get_Spell_Desc()end-- {spellID, isDesc}










function e.cn(text, tab)
    local data= e.set_text(text)
    if data then
        return data
    end

    if type(tab)=='table' then
        if tab.holydayID then
            if tab.isName then
                data= e.Get_HoliDay_Name(tab.holydayID)
            elseif isDesc then
                data= e.Get_HoliDay_Desc(tab.holydayID)
            else
                data= e.Get_HoliDay_Info(tab.holydayID)--节日 eventID
            end

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

        elseif tab.spellID or tab.spellLink then
            local spellID= select(7, tab.spellLink)
            
            if tab.isName then
                local name= e.Get_Spell_Name(spellID)--法术名称
                if name then
                    if tab.spellLink and tab.spellLink:find('|h%[.-]|h') then
                        data= tab.spellLink:gsub('|h%[.-]|h', '|h['..name..']|h')
                    end
                    data= data or name
                end
            elseif tab.isDesc then
                data= e.Get_Spell_Desc(spellID)
            else
                data= e.Get_Spell_Data(spellID)
                if data then
                    for index, name2 in pairs(data) do
                        data[index]= e.ReplaceText(name2)
                    end
                end
            end

        elseif tab.itemID or tab.itemLink then
            local itemID= tab.itemID or C_Item.GetItemIDForItemInfo(tab.itemLink)
            if tab.isToy then
                data= e.Get_Toy_Source(itemID)
            elseif tab.isHeirloom then
                data= e.Get_Heirloom_Source(itemID)

            elseif tab.isName then
                local link= tab.itemLink
                if link then
                    local name= e.Get_Item_Name(itemID)--物品名称
                    if name then
                        name= name:match('|c........(.+)|r') or name
                        if link:find('|h%[.-]|h') then
                            data= link:gsub('|h%[.-]|h', '|h['..name..']|h')
                        end
                    end
                end
                data= data or e.Get_Item_Name(itemID)--物品名称

            elseif tab.isDesc then
                data= e.Get_Item_Desc(itemID)--物品名称
            else
                data= e.Get_Item_Info(itemID)--物品名称
                if data then
                    for index, name2 in pairs(data) do
                        data[index]= e.ReplaceText(name2)
                    end
                end
            end

        elseif tab.skillLineAbilityID then
            data= e.Get_SkillLineAbility_Name(tab.skillLineAbilityID)--专业配方,名称

        elseif tab.recipeID then
            data= e.Get_Recipe_Source(tab.recipeID)--专业配方,来源

        elseif tab.ProfessionNodeID then
            data= e.Get_Profession_Node_Desc(tab.ProfessionNodeID)


        elseif tab.lfgDungeonID then
            data= e.Get_LFGDungeon_Desc(tab.lfgDungeonID)

        elseif tab.sectionID then
            if tab.isName then
                data= e.Get_Boos_Section_Name(tab.sectionID, tab.difficultyID)
            elseif tab.isDesc then
                data= e.Get_Boos_Section_Desc(tab.sectionID, tab.difficultyID)
            else
                data= e.Get_Boos_Section_Info(tab.sectionID, tab.difficultyID)
            end

        elseif tab.journalEncounterID then
            if tab.isName then
               data= e.Get_Boss_Name(journalEncounterID)
            elseif tab.isDesc then
                data= e.Get_Boss_Desc(tab.journalEncounterID)--BOOS
            else
                data= e.Get_Boss_Info(tab.journalEncounterID)
            end

        elseif tab.instanceID then
            data= e.Get_Instance_Desc(tab.instanceID)--副本

        elseif tab.scenarioID then
            if tab.isName then
                data= e.Get_Scenario_Name(tab.scenarioID)
            else
                e.Get_Scenario_Step_Info(tab.scenarioID, tab.stepIndex)
            end

        elseif tab.questID then
            if tab.isObject then
                e.Get_Quest_Object(tab.questID, tab.index)
            else
                data= e.Get_Quest_Info(tab.questID, tab.isName, tab.isObject, tab.isDesc)
            end

        elseif tab.npcID or tab.unit then
            if tab.isName then
                data= e.Get_Unit_Name(tab.unit, tab.npcID)
            else
                data= e.Get_Unit_Info(tab.unit, tab.npcID)
            end


        elseif tab.titleID then
            data= e.Get_Title_Name(tab.titleID)
        end
    end
    return data or text
end
WoW_Tools_Chinese_CN= e.cn












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






function e.Magic(text)
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












































C_Timer.After(6, function()
    e.strText['']=nil
end)

