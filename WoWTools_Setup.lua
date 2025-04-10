local e= select(2, ...)

WoWTools_Chinese_Mixin={}






function WoWTools_Chinese_Mixin:Setup(text, tab)
    local data= e.set_text(text)
    if data then
        return data
    end

    if type(tab)=='table' then
        if tab.holydayID then
            if tab.isName then
                data= e.Get_HoliDay_Name(tab.holydayID)
            elseif tab.isDesc then
                data= e.Get_HoliDay_Desc(tab.holydayID)
            else
                data= e.Get_HoliDay_Info(tab.holydayID)--节日 eventID
            end
            print(tab.holydayID, data[1], data[2])
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
            local spellID= tab.spellID
            if not spellID and tab.spellLink then
                local spellInfo = C_Spell.GetSpellInfo(tab.spellLink)
                if spellInfo then
                    spellID= spellInfo.spellID
                end
            end
            if spellID then
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