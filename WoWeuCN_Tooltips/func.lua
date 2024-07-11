local e= select(2, ...)



local function split(s, delimiter)
    if (s == nil) then
        return nil
    end
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end






if ReplaceText then
    e.ReplaceText= ReplaceText
else
    local replacement = {
        ["瞬发"] = "À",
        ["施法时间"] = "Á",
        ["码射程"] = "Â",
        ["秒"] = "Ã",
        ["冷却时间"] = "Ä",
        ["|cffffd100"] = "Å",
        ["|r|cff7f7f7f"] = "Æ",
        ["|r"] = "Ç",
        ["近战范围"] = "È",
        ["持续"] = "É",
        ["造成"] = "Ê",

        ["点伤害"] = "Ë",
        ["点治疗"] = "Ì",
        ["点生命值"] = "Í",
        ["点法力值"] = "Î",
        ["点物理伤害"] = "Ï",
        ["点魔法伤害"] = "Ð",
        ["点火焰伤害"] = "Ñ",
        ["点冰霜伤害"] = "Ò",
        ["点暗影伤害"] = "Ó",
        ["点神圣伤害"] = "Ô",
        ["点奥术伤害"] = "Õ",
        ["点混乱伤害"] = "Ö",
        ["点流血伤害"] = "Ø"
    }
    function e.ReplaceText(s)
        if s then
            for origin,new in pairs(replacement) do
                s = string.gsub(s, new, origin)
            end
            return s
        end
    end
end











if GetSpellData then
    e.Get_Spell_Data= GetSpellData
else
    function e.Get_Spell_Data(spellID)
        local data
        if spellID and WoWeuCN_Tooltips_SpellIndexData_0 then
            local index
            if (spellID >= 0 and spellID < 100000) then
                index = WoWeuCN_Tooltips_SpellIndexData_0[spellID]
            elseif (spellID >= 100000 and spellID < 200000) then
                index = WoWeuCN_Tooltips_SpellIndexData_100000[spellID - 100000]
            elseif (spellID >= 200000 and spellID < 300000) then
                index = WoWeuCN_Tooltips_SpellIndexData_200000[spellID - 200000]
            elseif (spellID >= 300000 and spellID < 400000) then
                index = WoWeuCN_Tooltips_SpellIndexData_300000[spellID - 300000]
            elseif (spellID >= 400000 and spellID < 500000) then
                index = WoWeuCN_Tooltips_SpellIndexData_400000[spellID - 400000]
            end
            if index then
                if (spellID >= 0 and spellID < 100000) then
                    data = split(WoWeuCN_Tooltips_SpellData_0[index], '£')
                elseif (spellID >= 100000 and spellID < 200000) then
                    data = split(WoWeuCN_Tooltips_SpellData_100000[index], '£')
                elseif (spellID >= 200000 and spellID < 300000) then
                    data = split(WoWeuCN_Tooltips_SpellData_200000[index], '£')
                elseif (spellID >= 300000 and spellID < 400000) then
                    data = split(WoWeuCN_Tooltips_SpellData_300000[index], '£')
                elseif (spellID >= 400000 and spellID < 500000) then
                    data = split(WoWeuCN_Tooltips_SpellData_400000[index], '£')
                end
                if data then
                    local newID
                    while (string.find(data[1], "¿")) do
                        newID= string.sub(data[1], 3)
                        newID= newID and tonumber(newID)
                        data = e.Get_Spell_Data(newID)
                        if not data then
                            return
                        end
                    end
                end
            end
        end
        return data
    end
end













if GetItemData then
    e.Get_Item_Data= GetItemData
else
    function e.Get_Item_Data(itemID)
        if itemID and WoWeuCN_Tooltips_ItemData_0 then
            local index = nil
            if (itemID >= 0 and itemID < 100000) then
                index = WoWeuCN_Tooltips_ItemIndexData_0[itemID]
            elseif (itemID >= 100000 and itemID < 200000) then
                index = WoWeuCN_Tooltips_ItemIndexData_100000[itemID - 100000]
            elseif (itemID >= 200000 and itemID < 300000) then
                index = WoWeuCN_Tooltips_ItemIndexData_200000[itemID - 200000]
            end
            if index then
                if (itemID >= 0 and itemID < 100000) then
                    return split(WoWeuCN_Tooltips_ItemData_0[index], '£')
                elseif (itemID >= 100000 and itemID < 200000) then
                    return split(WoWeuCN_Tooltips_ItemData_100000[index], '£')
                elseif (itemID >= 200000 and itemID < 300000) then
                    return split(WoWeuCN_Tooltips_ItemData_200000[index], '£')
                end
            end
        end
    end
end
