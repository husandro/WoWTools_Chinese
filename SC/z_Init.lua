
--单位
local function Get_NPC_ID(unit)--NPC ID
    if UnitExists(unit) then
        local guid=UnitGUID(unit)
        if guid then
            return select(6,  strsplit("-", guid))
        end
    end
end
--npcID 为字符
function WoWTools_ChineseMixin:GetUnitData(unit, npcID)
    npcID= npcID or Get_NPC_ID(unit)
    npcID= type(npcID)=='number' and tostring(npcID)  or npcID
    if npcID then
        return WoWTools_SC_Unit(npcID)
    end
end

function WoWTools_ChineseMixin:GetUnitName(unit, npcID)
    unit= unit or 'npc'
    local data= self:GetUnitData(unit, npcID)
    if data then
        return data.T, data.D
    end
end





















function WoWTools_ChineseMixin:GetBoosSectionData(sectionID, difficultyID)
    difficultyID = difficultyID or EJ_GetDifficulty()
    if difficultyID and sectionID then
        return WoWTools_SC_SectionEncounter[sectionID .. 'x' .. difficultyID]
    end
end

function WoWTools_ChineseMixin:GetBoosSectionName(sectionID, difficultyID)
    local data= self:GetBoosSectionData(sectionID, difficultyID)
    if data then
        return data.T
    end
end
function WoWTools_ChineseMixin:GetBoosSectionDesc(sectionID, difficultyID)
    local data= self:GetBoosSectionData(sectionID, difficultyID)
    if data then
        return data.D
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
    questID= questID  and tonumber(questID)
    if questID then
        return WoWTools_SC_Quest[questID]
    end
end
function WoWTools_ChineseMixin:GetQuestName(questID)
    local data=self:GetQuestData(questID)
    if data then
        return data.T
    end
end
function WoWTools_ChineseMixin:GetQuestObjectText(questID)
    local data=self:GetQuestData(questID)
    if data then
        return data.O
    end
end
function WoWTools_ChineseMixin:GetQuestObject(questID)
    local data=self:GetQuestData(questID)
    if data then
        return data.S
    end
end
function WoWTools_ChineseMixin:GetQuestDesc(questID)
    local data=self:GetQuestData(questID)
    if data then
        return data.D
    end
end






















function WoWTools_ChineseMixin:GetItemData(itemID, itemLink)
    if not itemID and itemLink then
        itemID= C_Item.GetItemInfoInstant(itemLink)
    end
    if itemID then
        return WoWTools_SC_Item[tostring(itemID)]
    end
end


function WoWTools_ChineseMixin:GetItemName(itemID, itemLink)
    local data= self:GetItemData(itemID, itemLink)
    if data then
        return data.T, data.D
    end
end

function WoWTools_ChineseMixin:GetItemDesc(itemID, itemLink)
    local data= self:GetItemData(itemID, itemLink)
    if data then
        return data.D, data.T
    end
end











function WoWTools_ChineseMixin:GetSpellData(spellID)
    if spellID then
        return WoWTools_SC_Spell[tostring(spellID)]
    end
end

function WoWTools_ChineseMixin:GetSpellName(spellID)
    local data= self:GetSpellData(spellID)
    if data then
        return data.T, data.D
    end
end

function WoWTools_ChineseMixin:GetSpellDesc(spellID)
    local data= self:GetSpellData(spellID)
    if data then
        return data.D, data.T
    end
end









EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function(owner)
    do
        for journalEncounterID, data in pairs(WoWTools_SC_Encounter) do
            local name, desc= EJ_GetEncounterInfo(journalEncounterID)
            WoWTools_ChineseMixin:SetCN(name, data.T)
            WoWTools_ChineseMixin:SetCN(desc, data.D)
        end
    end
    WoWTools_SC_Encounter= nil

    do
        for achievementID, data in pairs(WoWTools_SC_Achievement) do
            achievementID= tonumber(achievementID)
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




