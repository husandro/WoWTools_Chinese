WoWTools_ChineseMixin={}


local CNData={}--主要，汉化


function WoWTools_ChineseMixin:SetCN(en, cn)
    if en and cn and cn:find("[\228-\233][\128-\191][\128-\191]") then--检查 UTF-8 字符
        CNData[en]=cn
    end
end

function WoWTools_ChineseMixin:CN(text)
    return CNData[text]
end

--[[

WoWTools_ChineseMixin:SetCN(

]]









function WoWTools_ChineseMixin:Setup(text, tab)
    local data= self:SetText(text)
    if data then
        return data
    end

    if type(tab)=='table' then
        if tab.holydayID then
            if tab.isName then
                data= self:GetHoliDayName(tab.holydayID)
            elseif tab.isDesc then
                data= self:GetHoliDayDesc(tab.holydayID)
            else
                data= self:GetHoliDayInfo(tab.holydayID)--节日 eventID
            end
        elseif tab.perksActivityID then
            data= self:GetPerksActivityInfo(tab.perksActivityID)--PERKS

        elseif tab.vignetteID then
            data= self:GetVignetteName(tab.vignetteID)--Vignette

        elseif tab.toyID then
            data= self:GetToySource(tab.toyID)--玩具itemID

        elseif tab.speciesID then
            data= self:GetPetDesc(tab.speciesID)--专精

        elseif tab.petAbilityID then
            data= self:GetPetAblityInfo(tab.petAbilityID)--宠物技能

        elseif tab.skillCategoryID then
            data= self:GetTradeSkillCategoryName(tab.skillCategoryID)--专业目录

        elseif tab.spellID or tab.spellLink then
            local spellID= tab.spellID
            if not spellID and tab.spellLink then
                local spellInfo = C_Spell.GetSpellInfo(tab.spellLink)
                if spellInfo then
                    spellID= spellInfo.spellID
                end
            end
            if spellID then
                if tab.isName then
                    local name= self:GetSpellName(spellID)--法术名称
                    if name then
                        if tab.spellLink and tab.spellLink:find('|h%[.-]|h') then
                            data= tab.spellLink:gsub('|h%[.-]|h', '|h['..name..']|h')
                        end
                        data= data or name
                    end
                elseif tab.isDesc then
                    data= self:GetSpellDesc(spellID)
                else
                    data= self:GetSpellData(spellID)
                    if data then
                        for index, name2 in pairs(data) do
                            data[index]= self:ReplaceText(name2)
                        end
                    end
                end
            end

        elseif tab.itemID or tab.itemLink then
            local itemID= tab.itemID or C_Item.GetItemIDForItemInfo(tab.itemLink)
            if tab.isToy then
                data= self:GetToySource(itemID)
            elseif tab.isHeirloom then
                data= self:GetHeirloomSource(itemID)

            elseif tab.isName then
                local link= tab.itemLink
                if link then
                    local name= self:GetItemName(itemID)--物品名称
                    if name then
                        name= name:match('|c........(.+)|r') or name
                        if link:find('|h%[.-]|h') then
                            data= link:gsub('|h%[.-]|h', '|h['..name..']|h')
                        end
                    end
                end
                data= data or self:GetItemName(itemID)--物品名称

            elseif tab.isDesc then
                data= self:GetHeirloomSource(itemID)--物品名称
                
            else
                data= self:GetItemData(itemID)--物品名称
                if data then
                    for index, name2 in pairs(data) do
                        data[index]= self:ReplaceText(name2)
                    end
                end
            end

        elseif tab.skillLineAbilityID then
            data= self:GetSkillLineAbilityName(tab.skillLineAbilityID)--专业配方,名称

        elseif tab.recipeID then
            data= self:GetRecipeSource(tab.recipeID)--专业配方,来源

        elseif tab.ProfessionNodeID then
            data= self:GetProfessionNodeDesc(tab.ProfessionNodeID)


        elseif tab.lfgDungeonID then
            data= self:GetLFGDungeonDesc(tab.lfgDungeonID)

        elseif tab.sectionID then
            if tab.isName then
                data= self:GetBoosSectionName(tab.sectionID, tab.difficultyID)
            elseif tab.isDesc then
                data= self:GetBoosSectionDesc(tab.sectionID, tab.difficultyID)
            else
                data= self:GetBoosSectionData(tab.sectionID, tab.difficultyID)
            end

        elseif tab.journalEncounterID then
            if tab.isName then
               data= self:GetBossName(journalEncounterID)
            elseif tab.isDesc then
                data= self:GetBossDesc(tab.journalEncounterID)--BOOS
            else
                data= self:GetBossData(tab.journalEncounterID)
            end

        elseif tab.instanceID then
            data= self:GetInstanceDesc(tab.instanceID)--副本

        elseif tab.scenarioID then
            if tab.isName then
                data= self:GetScenarioName(tab.scenarioID)
            else
                self:GetScenarioStepData(tab.scenarioID, tab.stepIndex)
            end

        elseif tab.questID then
            if tab.isObject then
                self:GetQuestObject(tab.questID, tab.index)
            else
                data= self:GetQuestData(tab.questID, tab.isName, tab.isObject, tab.isDesc)
            end

        elseif tab.npcID or tab.unit then
            if tab.isName then
                data= self:GetUnitName(tab.unit, tab.npcID)
            else
                data= self:GetUnitData(tab.unit, tab.npcID)
            end


        elseif tab.titleID then
            data= self:GetTitleName(tab.titleID)
        end
    end
    return data or text
end
















local function set(self, text)
    local label= self
    if self and not text then
        if self.GetText then
            text= self:GetText()
        elseif self.GetObjectType and self:GetObjectType()=='Button' then
            label= self:GetFontString()
            if label then
                text= label:GetText()
            end
        else
            return
        end
    end

    if text and label and label.SetText then
        local text2= WoWTools_ChineseMixin:SetText(text)
        if text2 and text2~=text then
            label:SetText(text2)
        end
    end
end



local function set_match(text, a, b)
    local a1=WoWTools_ChineseMixin:CN(a)
    local b1= WoWTools_ChineseMixin:CN(b)

    local r= a1 and a1:find('%W') and text:gsub(a, a1) or text
    r= b1 and b1:find('%W') and r:gsub(b, b1) or r

    if text~= r then
        return r
    end
end










--( ) . % + - * ? [ ^ $
function WoWTools_ChineseMixin:SetText(text)
    if type(text)~='string' or text=='' or text=='%s' then
        return
    end

    local text2= self:CN(text)
    if text2 then
        if text2:find('%W') then
            return text2
        end
    end

    text2= text:gsub('|c.-|r', function(s)--颜色
        return set_match(s, s:match('|c........(.-)|r'))
    end)
    text2= text2:gsub('%(.-%)', function(s)-- ()
        return set_match(s, s:match('%((.-)%)'))
    end)
    text2= text2:gsub('  .+', function(s)--双空格
        return set_match(s, s:match('  (.+)'))
    end)
    text2= text2:gsub('.-:', function(s)--内容：
        return set_match(s, s:match('^(.-):'), s:match('^(.-:)'))
    end)
    text2= text2:gsub(': .+', function(s)-- :内容
        return set_match(s, s:match(': (.+)'))
    end)
    text2= text2:gsub('^.- %(', function(s)--内容 (
        return set_match(s, s:match('^(.-) %('))
    end)

    text2= text2:gsub('%d+ .+', function(s)--数字 内容
        return set_match(s, s:match('%d+ (.+)'))
    end)
    text2= text2:gsub('%(%d+%) .+', function(s)--(数字) 内容
        return set_match(s, s:match('%(%d+%) (.+)'))
    end)

    text2= text2:gsub(': .- %(', function(s)--[Chiave del Potere: Conca dei Felcepelle (2)]
         return set_match(s, s:match(': (.-) %('))
    end)

    if text ~= text2 and text2:find('%W') then
        return text2
    end
end



function WoWTools_ChineseMixin:SetLabelFont(lable)
    if lable then
        local _, size2, fontFlag2= lable:GetFont()
        lable:SetFont('Fonts\\ARHei.ttf', size2, fontFlag2 or 'OUTLINE')
    end
end




function WoWTools_ChineseMixin:SetLabelText(label, text, affer, setFont)
    if label and not label.hook_chines then
        if setFont then
            self:SetLabelFont(lable)
        end
        if affer then
            C_Timer.After(affer, function() set(label, text) end)
        else
            set(label, text)
        end
    end
end

function WoWTools_ChineseMixin:AddDialogs(string, tab)
    if StaticPopupDialogs[string] then
        for name, text in pairs(tab) do
            if StaticPopupDialogs[string][name] then
                StaticPopupDialogs[string][name]= text
            end
        end
    end
end

function WoWTools_ChineseMixin:HookDialog(string, text, func)
    if StaticPopupDialogs[string] then
        if StaticPopupDialogs[string][text] then
            hooksecurefunc(StaticPopupDialogs[string], text, func)
        else
            StaticPopupDialogs[string][text]=func
        end
    end
end

function WoWTools_ChineseMixin:HookLabel(label, setFont)
    if label and not label.hook_chines and label.SetText then
        if setFont then
            self:SetLabelFont(label)
        end
        self:SetLabelText(label)
        hooksecurefunc(label, 'SetText', function(self, name)
            set(self, name)
        end)
        label.hook_chines=true
    end
end



function WoWTools_ChineseMixin:HookButton(btn, setFont)
    if btn and btn.SetText and not btn.hook_chines then
        if setFont then
            self:SetLabelFont(btn:GetFontString())
        end
        local label= btn:GetFontString()
        if label then
            self:SetLabelText(labe)
        end
        hooksecurefunc(btn, 'SetText', function(frame, name)
            if name and name~='' then
                local cnName= WoWTools_ChineseMixin:CN(name)
                if cnName then
                    frame:SetText(cnName)
                end
            end
        end)
        btn.hook_chines=true
    end
end




function WoWTools_ChineseMixin:SetRegions(frame, setFont, isHook, notAfter)
    if frame and not frame.region_chinese then
        if isHook then
            for _, region in pairs({frame:GetRegions()}) do
                if region:GetObjectType()=='FontString' then
                    self:HookLabel(region, setFont)
                end
            end

        else
            if notAfter then
                for _, region in pairs({frame:GetRegions()}) do
                    if region:GetObjectType()=='FontString' then
                        self:SetLabelText(region, setFont)
                    end
                end
            else
                C_Timer.After(2, function()
                    for _, region in pairs({frame:GetRegions()}) do
                        if region:GetObjectType()=='FontString' then
                            self:SetLabelText(region, setFont)
                        end
                    end
                end)
            end
        end
        frame.region_chinese=true
    end
end


--PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
function WoWTools_ChineseMixin:SetTabSystem(frame, setFont, padding, minWidth, absoluteSize)
    for _, tabID in pairs(frame:GetTabSet() or {}) do
        local btn= frame:GetTabButton(tabID)
        self:SetLabelText(btn.Text or btn, nil, nil, setFont)

        PanelTemplates_TabResize(frame, padding or 20, absoluteSize, minWidth or 70)
    end
end












function WoWTools_ChineseMixin:GetRecipeName(recipeInfo, hyperlink)
    local name
    hyperlink= hyperlink or (recipeInfo and recipeInfo.hyperlink)

    local color
    if hyperlink then
        local item = Item:CreateFromItemLink(hyperlink)
        color= (item:GetItemQualityColor() or {}).color
        name= self:GetItemName(item:GetItemID()) or self:CN(item:GetItemName())
    end
    if not name and recipeInfo then
        name= self:GetSkillLineAbilityName(recipeInfo.skillLineAbilityID)
    end
    if name and color then
        name= WrapTextInColor(name, color)
    end

    return name
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