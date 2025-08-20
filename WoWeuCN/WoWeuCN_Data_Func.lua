--[[
因无法找到数据来源，
只能导入别的插件数据，
无法自已更新数据。

数据来源
插件 Tooltips Translator - Chinese (WoWeuCN_Tooltips)
网站 https://www.curseforge.com/wow/addons/tooltips-translator-chinese
插件 Quest Translator - Chinese (WoWeuCN_Quest)
https://www.curseforge.com/wow/addons/quest-chinese-translator


WoWTools_ChineseMixin:ReplaceText(string)
法术 WoWTools_ChineseMixin:GetSpellData(spellID)
物品 WoWTools_ChineseMixin:GetItemData(itemID)
任务 WoWTools_ChineseMixin:GetQuestData(questID, isName, isObject, isDesc)

WoWTools_ChineseMixin:GetUnitData(unit, npcID)
WoWTools_ChineseMixin:GetUnitName(unit, npcID)

WoWTools_ChineseMixin:GetBossData(journalEncounterID)
WoWTools_ChineseMixin:GetBossDesc(journalEncounterID)
WoWTools_ChineseMixin:GetBossName(journalEncounterID)
]]

do
loadEncounterData()
end
loadEncounterData=function()end

do
    loadItemData0()
end
loadItemData0=function()end
do
    loadItemData100000()
end
loadItemData100000=function()end
do
    loadItemData200000()
end
loadItemData200000=function()end




do
    loadSpellData0()
end
loadSpellData0=function()end

do
    loadSpellData100000()
end
loadSpellData100000=function()end

do
    loadSpellData200000()
end
loadSpellData200000=function()end

do
    loadSpellData300000()
end
loadSpellData300000=function()end

do
    loadSpellData400000()
end
loadSpellData400000=function()end





do
    loadUnitData0()
end
loadUnitData0=function()end

do
    loadUnitData100000()
end
loadUnitData100000=function()end

do
    loadUnitData200000()
end
loadUnitData200000=function()end




















local function split(s, delimiter)
    if s then
        local result = {};
        for match in (s..delimiter):gmatch("(.-)"..delimiter) do
            table.insert(result, match);
        end
        return result
    end
end


local replacement = {
    ["瞬发"] = "À",
    ["施法时间"] = "Á",
    ["码射程"] = "Â",
    ["秒"] = "Ã",
    ["冷却时间"] = "Ä",
    --["|cffffffff"] = "Å",
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

function WoWTools_ChineseMixin:ReplaceText(s)
    if s and self:IsCN(s) then
        for new, origin in pairs(replacement) do
            s = s:gsub(origin, new)
        end
        return s
    end
end



















--法术 WoWTools_ChineseMixin:GetSpellData(spellID)
function WoWTools_ChineseMixin:GetSpellData(spellID)
    if not spellID then
        return
    elseif GetSpellData then
        return GetSpellData(spellID)
    end

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
                    data = self:GetSpellData(newID)
                    if not data then
                        return
                    end
                end
            end
        end
    end


    return data
end




function WoWTools_ChineseMixin:GetSpellName(spellID)
    if not spellID then
        return
    end
    local data= self:GetSpellData(spellID)
    if data then
        return self:ReplaceText(data[1])
    else
        local name= C_Spell.GetSpellName(spellID)
        local cn= name and self:CN(name)
        if cn then
            return cn
        end
    end
end

function WoWTools_ChineseMixin:GetSpellDesc(spellID)
    local data= self:GetSpellData(spellID) or {}
    local num= #data
    if num<=1 then
        return
    end

    local t, t2, desc
    local name= data[1]
    local tab={[name]= true}

    for index=2, num do
        t= data[index]
        if t and not tab[t] then
            tab[t]=true

            t2= self:ReplaceText(t)

            if t2 then
                desc= (desc and desc..'|n' or '').. t2
            end
        end
    end

    name= self:ReplaceText(name)

    return desc, name
end















--物品 WoWTools_ChineseMixin:GetItemData(itemID)
if GetItemData then
    function WoWTools_ChineseMixin:GetItemData(itemID)
        return GetItemData(itemID)
    end
else
    function WoWTools_ChineseMixin:GetItemData(itemID)
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


function WoWTools_ChineseMixin:GetItemName(itemID, itemLink)
    itemID= itemID or (itemLink and C_Item.GetItemInfoInstant(itemLink))
    local data= itemID and self:GetItemData(itemID)
    return data and self:ReplaceText(data[1])
end


function WoWTools_ChineseMixin:GetItemDesc(itemID)
    local data= itemID and self:GetItemData(itemID)
    if not data then
        return
    end

    local name= data[1]
    table.remove(data, 1)
    local tab={[name]=true}

    local text, t
    for _, desc in pairs(data) do
        t= not tab[desc] and self:ReplaceText(desc)
        if t then
            tab[desc]= true
            text= (text and text..'|n' or '')..t
        end
    end
    name= self:ReplaceText(name)

    return text, name
end




















--单位 WoWTools_ChineseMixin:GetUnitName(tab.unit, tab.npcID)
local function Get_NPC_ID(unit)--NPC ID
    if UnitExists(unit) then
        local guid=UnitGUID(unit)
        if guid then
            return select(6,  strsplit("-", guid))
        end
    end
end

local Get_Unit_Data= GetUnitData or function(npcID)
    if not WoWeuCN_Tooltips_UnitIndexData_0 then
        return
    end
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


function WoWTools_ChineseMixin:GetUnitData(unit, npcID)
    npcID= npcID or Get_NPC_ID(unit)
    return Get_Unit_Data(npcID)
end

function WoWTools_ChineseMixin:GetUnitName(unit, npcID)
    unit= unit or 'npc'
    local data= self:GetUnitData(unit, npcID)
    if data then
        return data[1], data[2]
    end
end





















--任务
local Player_Sex= UnitSex("player")
local Player_Name= UnitName('player')
local Player_Race= UnitRace('player')
local Player_Class=  UnitClass('player')
EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner)
    Player_Race=  WoWTools_ChineseMixin:CN(Player_Race) or Player_Race
    Player_Class=  WoWTools_ChineseMixin:CN(Player_Class) or Player_Class
    EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
end)

local function YOUR_GENDER(s)
    local a,b= s:match('%((.-);(.-)%)')
    if a and b then
       return Player_Sex==3 and a or b--3	Female
    end
end


local function expand_text(msg)-- function WoWeuCN_Quests_ExpandUnitInfo(desc)
   if not msg or msg=='' then
      return
   end

   msg= msg:gsub("NEW_LINE", "\n")
   msg= msg:gsub('YOUR_GENDER%(.-;.-%)', YOUR_GENDER)--YOUR_GENDER(兄弟;小姐)
   msg= msg:gsub("{name}", Player_Name)
   msg= msg:gsub("{race}", Player_Race)
   msg= msg:gsub("{class}", Player_Class)
   return msg;
end







--Title Objectives Description

function WoWTools_ChineseMixin:GetQuestName(questID)
    local data=self:GetQuestData(questID)
    return expand_text(data and data["Title"])
end

function WoWTools_ChineseMixin:GetQuestObject(questID)
    local data=self:GetQuestData(questID)
    return expand_text(data and data["Objectives"])
end

function WoWTools_ChineseMixin:GetQuestDesc(questID)
    local data=self:GetQuestData(questID)
    return expand_text(data and data["Description"])
end

function WoWTools_ChineseMixin:GetQuestData(questID)
    local data = questID and WoWeuCN_Quests_QuestData[tostring(questID)]
    if data then
        return {
            Title= expand_text(data.Title),
            Objectives= expand_text(data.Objectives),
            Description= expand_text(data.Description),
        }
    end
end






















function WoWTools_ChineseMixin:GetBossData(journalEncounterID)
    if not WoWeuCN_Tooltips_EncounterData then
        return
    end
    local data= WoWeuCN_Tooltips_EncounterData[journalEncounterID]
    if data then
        local title, desc= true, true
        if not data.Title or data.Title=='' then
            data.Title=nil
            title=false
        end
        if not data.Description or data.Description=='' then
            data.Description= nil
            desc=false
        end
        if title or desc then
            return data
        end
    end
end

function WoWTools_ChineseMixin:GetBossDesc(journalEncounterID)
    local data= self:GetBossData(journalEncounterID)
    if data then
        return data.Description
    end
end

function WoWTools_ChineseMixin:GetBossName(journalEncounterID)
    local data= self:GetBossData(journalEncounterID)
    if data then
        return data.Title
    end
end




function WoWTools_ChineseMixin:GetBoosSectionData(sectionID, difficultyID)
    if WoWeuCN_Tooltips_EncounterSectionData then
        difficultyID = difficultyID or EJ_GetDifficulty()
        if difficultyID and sectionID then
            return WoWeuCN_Tooltips_EncounterSectionData[difficultyID .. 'x' .. sectionID]
        end
    end
end

function WoWTools_ChineseMixin:GetBoosSectionName(sectionID, difficultyID)
    local data= self:GetBoosSectionData(sectionID, difficultyID)
    if data and data.Title~='' then
        return data.Title
    end
end
function WoWTools_ChineseMixin:GetBoosSectionDesc(sectionID, difficultyID)
    local data= self:GetBoosSectionData(sectionID, difficultyID)
    if data and data.Description~='' then
        return data.Description
    end
end








--[[
do
    for journalEncounterID, info in pairs(WoWeuCN_Tooltips_EncounterData) do
        local name, desc= EJ_GetEncounterInfo(journalEncounterID)
        WoWTools_ChineseMixin:SetCN(name,  info['Title'])
        WoWTools_ChineseMixin:SetCN(desc,  info['Description'])
    end
end
if not loadEncounterData then
    WoWeuCN_Tooltips_EncounterData=nil
end]]



