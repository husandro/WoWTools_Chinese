local function GetValueID(id)
    if id then
        return tonumber(id)
    end
end

--Item 物品[itemID]={T=, D=, S={specID=}}
function WoWTools_ChineseMixin:GetItemData(itemID, itemLink)
    --itemID= (itemID or itemLink) and C_Item.GetItemInfoInstant(itemLink or itemID
    itemID= itemID or (itemLink and C_Item.GetItemInfoInstant(itemID))
    itemID= GetValueID(itemID)
    if not itemID  then
        return
    end

    local title, desc

    local data= WoWTools_SC_Item and WoWTools_SC_Item[itemID]
    if data then
        title= data.T
        desc= data.D
    end

    if WoWTools_SC_SetsItem then
        local setID= select(16, C_Item.GetItemInfo(itemID))
        if setID then
            data= WoWTools_SC_SetsItem[setID]
            if data then
                local specID= PlayerUtil.GetCurrentSpecID()
                if data[specID] then
                    desc=data[specID]
                else
                    local specs= C_Item.GetItemSpecInfo(itemID)
                    if specs and specs[1] and data[specs[1]] then
                        desc= data[specs[1]]
                    end
                end
            end
        end
    end

    if not desc then
        local spellID= C_Item.GetItemSpell(itemID)
        if spellID then
            desc= select(2, WoWTools_ChineseMixin:GetSpellName(spellID))
        end
    end

    if title or desc then
        return {
                T= title,
                D= desc,
            }
    end
end

function WoWTools_ChineseMixin:GetItemName(itemID, itemLink)
    local data= self:GetItemData(itemID, itemLink)
    if data then
        return data.T, data.D
    end
end













--单位
local function Get_NPC_ID(unit)--NPC ID
    if UnitExists(unit) and not UnitIsPlayer(unit) then
        local guid= UnitGUID(unit)
        if guid then
            return select(6,  strsplit("-", guid))
        end
    end
end
--Unit 单位 [npcID]={T=, D=}
function WoWTools_ChineseMixin:GetUnitData(unit, npcID)
    npcID= GetValueID(npcID or Get_NPC_ID(unit))
    if npcID and WoWTools_SC_Unit then
        return WoWTools_SC_Unit[npcID]
    end
end

function WoWTools_ChineseMixin:GetUnitName(unit, npcID)
    unit= unit or 'npc'
    local data= self:GetUnitData(unit, npcID)
    if data then
        return data.T, data.D
    end
end









--法术 [spellID]={T=, D=}
function WoWTools_ChineseMixin:GetSpellData(spellID)
    spellID= spellID and tonumber(spellID)
    local ID= GetValueID(spellID)
    if not ID then
        return
    end

    local data

    if spellID>=1200000 then
        if WoWTools_SC_Spell2 then
            data= WoWTools_SC_Spell2[ID]
        end
    elseif WoWTools_SC_Spell then
        data= WoWTools_SC_Spell[ID]
    end
    if data then
        return data
    else
        local name= self:CN(C_Spell.GetSpellName(spellID))
        if name then
            return {
                    T=name
                }
        end
    end
end

function WoWTools_ChineseMixin:GetSpellName(spellID)
    local data= self:GetSpellData(spellID)
    if data then
        return data.T, data.D, data.S--GetSpellName GetSpellDescription GetSpellSubtext
    end
end
















function WoWTools_ChineseMixin:GetBoosSectionData(sectionID, difficultyID)
    sectionID= sectionID and tonumber(sectionID)
    difficultyID= difficultyID and tonumber(difficultyID) or EJ_GetDifficulty()
    if sectionID and difficultyID and WoWTools_SC_SectionEncounter then
        local data=WoWTools_SC_SectionEncounter[sectionID]
        if data then
            return WoWTools_SC_SectionEncounter[difficultyID]
        end
    end
end

function WoWTools_ChineseMixin:GetBoosSectionName(sectionID, difficultyID)
    local data= self:GetBoosSectionData(sectionID, difficultyID)
    if data then
        return data.T, data.D
    end
end



--[[任务
local Player_Sex= UnitSex("player")
local Player_Name= UnitName('player')
local Player_Race= UnitRace('player')
local Player_Class= UnitClass('player')
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
]]





--任务
function WoWTools_ChineseMixin:GetQuestData(questID)
    questID= GetValueID(questID)
    if questID and WoWTools_SC_Quest then
        return WoWTools_SC_Quest[questID]
    end
end
function WoWTools_ChineseMixin:GetQuestName(questID)
    local data=self:GetQuestData(questID)
    if data then
        return data.T, data.D, data.O
    end
end

function WoWTools_ChineseMixin:GetQuestObject(questID)
    local data=self:GetQuestData(questID)
    if data then
        return data.S
    end
end






















--[[

function WoWTools_ChineseMixin:GetHolidayData(eventID)
    eventID= GetValueID(id)
    if eventID and WoWTools_SC_Holyday then
        return WoWTools_SC_Holyday[eventID]
    end
end

function WoWTools_ChineseMixin:GetHoliDayName(eventID)
    local data= self:GetHolidayData(eventID)
    if data then
        return data.T, data.D
    end
end
]]
























EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function(owner)
    do
        for journalEncounterID, data in pairs(WoWTools_SC_Encounter or {}) do
            local name, desc= EJ_GetEncounterInfo(journalEncounterID)
            WoWTools_ChineseMixin:SetCN(name, data.T)
            WoWTools_ChineseMixin:SetCN(desc, data.D)
        end
    end
    WoWTools_SC_Encounter= nil

    do
        for achievementID, data in pairs(WoWTools_SC_Achievement or {}) do
            local _, title, _, _, _, _, _, desc, _, _, reward = GetAchievementInfo(achievementID)
            WoWTools_ChineseMixin:SetCN(title, data.T)
            WoWTools_ChineseMixin:SetCN(desc, data.D)
            WoWTools_ChineseMixin:SetCN(reward, data.R)

            local numCriteria= GetAchievementNumCriteria(achievementID)
            if data.S and numCriteria>0 then
                for index = 1, numCriteria do
                    local criteriaString = GetAchievementCriteriaInfo(achievementID, index)
                    WoWTools_ChineseMixin:SetCN(criteriaString, data.S[index])
                end
            end
        end
    end
    WoWTools_SC_Achievement=nil

    EventRegistry:UnregisterCallback('PLAYER_ENTERING_WORLD', owner)
end)




