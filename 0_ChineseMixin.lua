GAME_LOCALE= "zhCN"
--[[LOCALE_zhCN= true
GetLocale=function()
    return "zhCN"
end]]

WoWTools_ChineseMixin={
    Events={},
    Frames={},
}




local CNData={}--主要，汉化

--[\228-\233][\128-\191][\128-\191]--检查 UTF-8 字符
function WoWTools_ChineseMixin:IsCN(text)
    if text and string.find(text, '[\228-\233]') then
        return text
    end

end
function WoWTools_ChineseMixin:SetCN(en, cn)
    cn= en and en~='' and self:IsCN(cn)
    if cn then
        CNData[en]=cn
    end
end

function WoWTools_ChineseMixin:CN(text)
    if text then
        return CNData[text]
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




function WoWTools_ChineseMixin:GetData(text, tab)
    local data= self:SetText(text)
    if data then
        return data
    end

    if type(tab)~='table' then
        return
    end

    if tab.holydayID then
        if tab.isName then
            data= self:GetHoliDayName(tab.holydayID)
        elseif tab.isDesc then
            data= select(2, self:GetHoliDayName(tab.holydayID))
        else
            data= self:GetHolidayData(tab.holydayID)--节日 eventID
        end
    elseif tab.perksActivityID then

        if tab.isName then
            data= self:GetPerksActivityName(tab.perksActivityID)
        elseif tab.isDesc then
            data= self:GetPerksActivityDesc(tab.perksActivityID)
        else
            data= self:GetPerksActivityData(tab.perksActivityID)--PERKS
        end

    elseif tab.vignetteID then
        data= self:GetVignetteName(tab.vignetteID)--Vignette

    elseif tab.toyID then
        data= self:GetToySource(tab.toyID)--玩具itemID

    elseif tab.speciesID then
        data= self:GetPetDesc(tab.speciesID)--专精

    elseif tab.petSpeciesID or tab.companionID then
        local companionID= tab.companionID or select(4, C_PetJournal.GetPetInfoBySpeciesID(tab.petSpeciesID))
        if companionID then
            if tab.isName then
                data= self:GetUnitName(nil, companionID)
            else
                data= self:GetUnitData(nil, companionID)
            end
        end

    elseif tab.petAbilityID then--宠物技能
        if tab.isName then
            data= self:GetPetAblityName(tab.petAbilityID)
        elseif tab.isDesc then
            data= self:GetPetAblityDesc(tab.petAbilityID, tab.abilityInfo)
        else
            data= self:GetPetAblityData(tab.petAbilityID, tab.abilityInfo)
        end

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
                data= select(2, self:GetSpellName(spellID))
            else
                data= self:GetSpellData(spellID)
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
            data= data or self:GetItemName(itemID) --物品名称

        elseif tab.isDesc then
            data= self:GetHeirloomSource(itemID)--物品名称

        else
            data= self:GetItemData(itemID)--物品名称
        end

    elseif tab.skillLineAbilityID then
        data= self:GetSkillLineAbilityName(tab.skillLineAbilityID)--专业配方,名称

    elseif tab.recipeID then
        data= self:GetRecipeSource(tab.recipeID)--专业配方,来源

    elseif tab.ProfessionNodeID then
        if tab.isName then
            data= self:GetProfessionNodeName(tab.ProfessionNodeID)
        elseif tab.isDesc then
            data= self:GetProfessionNodeDesc(tab.ProfessionNodeID)
        else
            data= self:GetProfessionNodeData(tab.ProfessionNodeID)
        end


    elseif tab.lfgDungeonID then
        data= self:GetLFGDungeonDesc(tab.lfgDungeonID)

    elseif tab.sectionID then
        if tab.isName then
            data= self:GetBoosSectionName(tab.sectionID, tab.difficultyID)
        elseif tab.isDesc then
            data= select(2, self:GetBoosSectionName(tab.sectionID, tab.difficultyID))
        else
            data= self:GetBoosSectionData(tab.sectionID, tab.difficultyID)
        end

    --[[elseif tab.journalEncounterID then
        if tab.isName then
            data= self:GetBossName(tab.journalEncounterID)
        elseif tab.isDesc then
            data= self:GetBossDesc(tab.journalEncounterID)--BOOS
        else
            data= self:GetBossData(tab.journalEncounterID)
        end

    elseif tab.instanceID then
        data= self:GetInstanceDesc(tab.instanceID)--副本]]

    elseif tab.scenarioID then
        if tab.isName then
            data= self:GetScenarioName(tab.scenarioID)
        --else
            --self:GetScenarioStepData(tab.scenarioID, tab.stepIndex)
        end

    elseif tab.questID then
        if tab.isName then
            data= self:GetQuestName(tab.questID)
        elseif tab.isObject then
            data= self:GetQuestObject(tab.questID)
        elseif tab.isDesc then
            data= select(2, self:GetQuestName(tab.questID))
        else
            data= self:GetQuestData(tab.questID)
        end

    elseif tab.npcID or tab.unit then
        if tab.isName then
            data= self:GetUnitName(tab.unit, tab.npcID)
        else
            data= self:GetUnitData(tab.unit, tab.npcID)
        end


    elseif tab.titleID then
        data= self:GetTitleName(tab.titleID)

    elseif tab.subTreeID then
        data= self:Get_TraitSubTree(subTreeID, isName, isDesc)
    end

    return data
end
















local function set(self, text)
    if not self
        or not self.SetText
        or (not text and not self.GetText)
    then
        return
    end

    text= text or self:GetText()
    local cn= WoWTools_ChineseMixin:SetText(text)
    if cn and cn~=text then
        self:SetText(cn)
    end
end



local function set_match(text, a, b)
    local a1=WoWTools_ChineseMixin:CN(a)
    local b1= WoWTools_ChineseMixin:CN(b)

    local r= a1 and a1:find('[\228-\233]') and text:gsub(a, a1) or text
    r= b1 and b1:find('[\228-\233]') and r:gsub(b, b1) or r

    if text~= r then
        return r
    end
end











--( ) . % + - * ? [ ^ $
function WoWTools_ChineseMixin:SetText(text)
    if type(text)~='string' or text=='' or text=='%s' or self:IsCN(text) then
        return
    end

    local text2= self:CN(text)
    if text2 then
        return text2
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


    text2= text2:gsub('|A:.-|a.+', function(s)
        return set_match(s, s:match('|A:.-|a (.+)') or s:match('|A:.-|a(.+)'))
    end)
    text2= text2:gsub('|T.-|t.+', function(s)
        return set_match(s, s:match('|T.-|t (.+)') or s:match('|T.-|t(.+)'))
    end)

    if text ~= text2 and text2:find('[\228-\233]') then
        return text2
    end
end








function WoWTools_ChineseMixin:SetLabel(label, text, affer, setFont)
    if label and not label.hook_chinese then
        if setFont then
            self:SetCNFont(lable)
        end
        if affer then
            C_Timer.After(affer, function() set(label, text) end)
        else
            set(label, text)
        end
    end
end

function WoWTools_ChineseMixin:SetButton(btn, text, affer, setFont, isRestWidth)
    local label, find
    if btn and not btn.hook_chinese then
        label= btn:GetFontString() or btn.Text or btn.text
        if label then
            self:SetLabel(label, text, affer, setFont)
            find=true
        elseif btn.GetText and btn.SetText then
            self:SetLabel(btn, text, affer, setFont)
            find=true
        end
    end
    if find and isRestWidth and label then
        local s= math.max(label:GetStringWidth()+40, btn:GetWidth())
        btn:SetWidth(s)
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
    if label and not label.hook_chinese and label.SetText then
        if setFont then
            self:SetCNFont(label)
        end
        self:SetLabel(label)
        hooksecurefunc(label, 'SetText', function(obj, name)
            set(obj, name)
        end)
        label:HookScript('OnShow', function(obj)
            set(obj)
        end)
        label.hook_chinese=true
    end
end



function WoWTools_ChineseMixin:HookButton(btn, setFont)
    if btn and btn.SetText and not btn.hook_chinese then
        self:SetButton(btn, nil, nil, setFont)

        hooksecurefunc(btn, 'SetText', function(frame, name)
            if name and name~='' then
                local cnName= self:SetText(name)
                if cnName then
                    frame:SetText(cnName)
                end
            end
        end)
        btn.hook_chinese=true
    end
end




function WoWTools_ChineseMixin:SetRegions(frame, setFont, isHook, notAfter)
    if not frame or frame.region_chinese then
        return
    end

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
                    self:SetLabel(region, setFont)
                end
            end
        else
            C_Timer.After(2, function()
                for _, region in pairs({frame:GetRegions()}) do
                    if region:GetObjectType()=='FontString' then
                        self:SetLabel(region, setFont)
                    end
                end
            end)
        end
    end
    frame.region_chinese=true
end


function WoWTools_ChineseMixin:SetTabButton(frame, text, isSetCNFont)
    if not frame then
        return
    end
    local padding= frame:GetParent().tabPadding or 0
    local minW= frame:GetParent().minTabWidth
    local maxW= frame:GetParent().maxTabWidth
    
    if frame.GetTabSet then
        for _, tabID in pairs(frame:GetTabSet()) do
            local btn= frame:GetTabButton(tabID)
            if btn then
                self:SetLabel(btn.Text, text, nil, isSetCNFont)
                PanelTemplates_TabResize(btn, padding , nil, minW, maxW)
            end
        end
    else
        local label= frame.Text or (btn.GetFontString and btn:GetFontString())
        if label then
            self:SetLabel(label, text, nil, isSetCNFont)
            PanelTemplates_TabResize(frame, padding , nil, minW, maxW)
        end
    end
end
function WoWTools_ChineseMixin:SetFrame(frame, setFont, isHook, affer)
    if not frame then
        return
    end
    if frame.GetRegions then
        for _, f in ipairs({frame:GetRegions()}) do
            local t= f:GetObjectType()
            if t=='Button' then
                if isHook then
                    self:HookButton(f, setFont)
                else
                    self:SetButton(f, nil, affer, setFont)
                end
            elseif t=='FontString' then
                if isHook then
                    self:HookLabel(f, setFont)
                else
                    self:SetLabel(f, nil, affer, setFont)
                end
            end
        end
    end
end

function WoWTools_ChineseMixin:SetFrames(frame, setFont, isHook, affer)
    if not frame or not frame.GetChildren then
        return
    end

    local t
    for _, f in pairs({frame:GetChildren()}) do
        t= f:GetObjectType()
        if t=='Frame' then
            self:SetFrame(f, setFont, isHook, affer)
        elseif t=='Button' then
            self:SetButton(f, nil, affer, setFont)
        end
    end
end


--/dump WoWTools_ChineseMixin:SetFrame(CommunitiesFrame.MemberList.ColumnDisplay)
--/dump CommunitiesFrame.MemberList.ColumnDisplay:GetChildren()

--PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
--[[function WoWTools_ChineseMixin:SetTabSystem(frame, setFont, padding, minWidth, absoluteSize)
    for _, tabID in pairs(frame:GetTabSet() or {}) do
        local btn= frame:GetTabButton(tabID)
        self:SetLabel(btn.Text or btn, nil, nil, setFont)

        PanelTemplates_TabResize(frame, padding or 20, absoluteSize, minWidth or 70)
    end
end]]


