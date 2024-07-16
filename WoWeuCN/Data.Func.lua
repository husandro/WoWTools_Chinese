local e= select(2, ...)
--[[
因无法找到数据来源，
只能导入别的插件数据，
无法自已更新数据。

数据来源
插件 Tooltips Translator - Chinese (WoWeuCN_Tooltips)
网站 https://www.curseforge.com/wow/addons/tooltips-translator-chinese
插件 Quest Translator - Chinese (WoWeuCN_Quest)
https://www.curseforge.com/wow/addons/quest-chinese-translator

如果已加 载WoWeuCN_Tooltips, 不会再次加载数据
10.2.7

e.ReplaceText(string)
法术 e.Get_Spell_Data(spellID)
物品 e.Get_Item_Data(itemID)
任务 e.Get_Quest_Info(questID, isName, isObject, isDesc)
]]









local function split(s, delimiter)
    if s then
        local result = {};
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match);
        end
        return result
    end
end


local replacement
if ReplaceText then
    e.ReplaceText= ReplaceText
else
    replacement = {
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





















--法术 e.Get_Spell_Data(spellID)
e.Get_Spell_Data= GetSpellData or function(spellID)
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




















--物品 e.Get_Item_Data(itemID)
e.Get_Item_Data= GetItemData or function(itemID)
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






















--单位 e.Get_Unit_Name(tab.unit, tab.npcID)
local function Get_NPC_ID(unit)--NPC ID
    if UnitExists(unit) then
        local guid=UnitGUID(unit)
        if guid then
            return select(6,  strsplit("-", guid))
        end
    end
end

local Get_Unit_Data= GetUnitData or function(npcID)
    local num_id = npcID and tonumber(npcID)
    if not num_id then
        return
    end
    
    local dataIndex
    if (num_id >= 0 and num_id < 100000) then
        dataIndex = WoWeuCN_Tooltips_UnitIndexData_0[num_id]
    elseif (num_id >= 100000 and num_id < 200000) then
        dataIndex = WoWeuCN_Tooltips_UnitIndexData_100000[num_id - 100000]
    elseif (num_id >= 200000 and num_id < 300000) then
        dataIndex = WoWeuCN_Tooltips_UnitIndexData_200000[num_id - 200000]
    end

    if not dataIndex then
        return
    end

    if (num_id >= 0 and num_id < 100000) then        
        return split(WoWeuCN_Tooltips_UnitData_0[dataIndex], '£')

    elseif (num_id >= 100000 and num_id < 200000) then
        return split(WoWeuCN_Tooltips_UnitData_100000[dataIndex], '£')

    elseif (num_id >= 200000 and num_id < 300000) then
        return split(WoWeuCN_Tooltips_UnitData_200000[dataIndex], '£')
    end
end




function e.Get_Unit_Name(unit, npcID)
    npcID= npcID or Get_NPC_ID(unit)   
    local data= Get_Unit_Data(npcID)
    if data then
        return data[1], data[2]
    end
end





















--任务 e.Get_Quest_Info(questID, isName, isObject, isDesc)
local baseClass= UnitClassBase('player')
local Player_Col= '|c'..select(4, GetClassColor(baseClass))..'%s'
local Player_Sex= UnitSex("player")
local Player_Name= format(Player_Col, UnitName('player'))
local Player_Race= format(Player_Col, e.cn(UnitRace('player')))
local Player_Class= format(Player_Col, e.cn(UnitClass('player')))

local function expand_text(msg)-- function WoWeuCN_Quests_ExpandUnitInfo(desc)
   if not msg and msg=='' then
      return
   end
   msg= msg:gsub("NEW_LINE", "\n")
   msg= msg:gsub('YOUR_GENDER%(.-;.-%)', function(s)--YOUR_GENDER(兄弟;小姐)
      local a,b= s:match('%((.-);(.-)%)')
      if a and b then
         return format(Player_Col, Player_Sex==3 and a or b)--3	Female
      end
   end)
   msg= msg:gsub("{name}", Player_Name)
   msg= msg:gsub("{race}", Player_Race)
   msg= msg:gsub("{class}", Player_Class)
   return msg;
end


function e.Get_Quest_Info(questID, isName, isObject, isDesc)
   if not questID then
      return
   end

   local str_ID= tostring(questID)
   local data= WoWeuCN_Quests_QuestData[str_ID]
   if not data then
      return
   end

   local name= data["Title"]
   if name =='' then
      name= nil
   end
   if isName then
      return name
   else
      local object= expand_text(data["Objectives"])
      if isObject then
         return object
      end
      local desc= expand_text(data["Description"])
      if isDesc then
         return desc
      else
         return {
            ["Title"]= name,
            ["Objectives"]= object,
            ["Description"]= desc,
         }
      end
   end
end

















