



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

function WoWTools_ChineseMixin:GetQuestData(questID)
    return WoWTools_SC_Quest[questID]
end
function WoWTools_ChineseMixin:GetQuestName(questID)
    local data=self:GetQuestData(questID)
    return expand_text(data and data["T"])
end
function WoWTools_ChineseMixin:GetQuestDesc(questID)
    local data=self:GetQuestData(questID)
    return expand_text(data and data["O"])
end
function WoWTools_ChineseMixin:GetQuestObject(questID)
    local data=self:GetQuestData(questID)
    return expand_text(data and data["S"])
end




do
    for journalEncounterID, data in pairs(WoWTools_SC_Encounter) do
        local name, desc= EJ_GetEncounterInfo(journalEncounterID)
        WoWTools_ChineseMixin:SetCN(name, data.T)
        WoWTools_ChineseMixin:SetCN(desc, data.D)
    end
end
WoWTools_SC_Encounter= nil
--[[function WoWTools_ChineseMixin:GetBossData(journalEncounterID)
    return WoWTools_SC_Encounter[journalEncounterID]
end

function WoWTools_ChineseMixin:GetBossDesc(journalEncounterID)
    local data= self:GetBossData(journalEncounterID)
    if data then
        return data.D
    end
end

function WoWTools_ChineseMixin:GetBossName(journalEncounterID)
    local data= self:GetBossData(journalEncounterID)
    if data then
        return data.T
    end
end]]