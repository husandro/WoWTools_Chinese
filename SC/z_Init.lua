local function GetValueID(id)
    if canaccessvalue(id) and id then
        return tonumber(id)
    end
end


--Item 物品[itemID]={T=, D=, S={specID=}}
function WoWTools_ChineseMixin:GetItemData(itemID, itemLink)
    if not canaccessvalue(itemID) or not canaccessvalue(itemLink) then
        return
    end

    if itemID then
        itemID= C_Item.GetItemInfoInstant(itemID)
    elseif itemLink then
        itemID= C_Item.GetItemInfoInstant(itemLink)
    end

    if not itemID  then
        return
    end

    local title, desc

    local data

    if WoWTools_SC_Item and itemID<=15e4 then
        data= WoWTools_SC_Item[itemID]
    elseif WoWTools_SC_Item2 then
        data= WoWTools_SC_Item2[itemID]
    else
        return
    end

    if data then
        title= data.T
        desc= data.D
    end

    local setID= select(16, C_Item.GetItemInfo(itemID))
-- C_Item.GetSetBonusesForSpecializationByItemID
    if setID and WoWTools_SC_Sets then
        data= WoWTools_SC_Sets[setID]
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

    if not desc and setID then
        local specID= PlayerUtil.GetCurrentSpecID()
        if specID then
            local itemSetSpellIDs = C_Item.GetSetBonusesForSpecializationByItemID(specID, itemID)
            if itemSetSpellIDs then
                for _, spellID in pairs(itemSetSpellIDs) do
                    local d=  select(2, WoWTools_ChineseMixin:GetSpellName(spellID))
                    if d then
                        desc= (desc and desc..'|n' or '')..d
                    end
                end
            end
        end
    end

    if not desc then
        local spellID= select(2, C_Item.GetItemSpell(itemID))
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
    local exists= UnitExists(unit)
    if canaccessvalue(exists) and exists and not UnitIsPlayer(unit) then
        local guid= UnitGUID(unit)
        if guid then
            return select(6, strsplit("-", guid))
        end
    end
end
--Unit 单位 [npcID]={T=, D=}
function WoWTools_ChineseMixin:GetUnitData(unit, npcID)
    if not WoWTools_SC_Unit or not canaccessvalue(unit) or not canaccessvalue(npcID) then
        return
    end

    npcID= npcID or Get_NPC_ID(unit)

    if npcID then
       return WoWTools_SC_Unit[npcID]
    end
end

function WoWTools_ChineseMixin:GetUnitName(unit, npcID)
    if not canaccessvalue(unit) or not canaccessvalue(npcID) then
        return
    end

    local data= self:GetUnitData(unit or 'npc', npcID)
    if data then
        return data.T, data.D
    end
end









--法术 [spellID]={T=, D=}
function WoWTools_ChineseMixin:GetSpellData(spellID)
    spellID= GetValueID(spellID)

    if not spellID then
        return
    end

    local data

    if spellID>=1200000 then
        if WoWTools_SC_Spell2 then
            data= WoWTools_SC_Spell2[spellID]
        end
    elseif WoWTools_SC_Spell then
        data= WoWTools_SC_Spell[spellID]
    end

    if not data then
        local name= self:CN(C_Spell.GetSpellName(spellID))
        if name then
            data= {
                    T= name,
                    D= self:CN(C_Spell.GetSpellDescription(spellID)),
                    S= self:CN(C_Spell.GetSpellSubtext(spellID)),
                }
        end
    end

    return data
end

function WoWTools_ChineseMixin:GetSpellName(spellID)
    local data= self:GetSpellData(spellID)
    if data then
        return data.T, data.D, data.S--GetSpellName GetSpellDescription GetSpellSubtext
    end
end













--[[
function WoWTools_ChineseMixin:GetBoosSectionData(sectionID, difficultyID)
    --sectionID= GetValueID(sectionID)
    difficultyID= difficultyID or EJ_GetDifficulty()
    if sectionID and WoWTools_SC_SectionEncounter then
        local data=WoWTools_SC_SectionEncounter[difficultyID..'x'..sectionID]
        if data then

            return {
                T=data.Title~='' and data.Title or nil,
                D=data.Description~='' and data.Description or nil,
            }
        end
    end
end]]

function WoWTools_ChineseMixin:GetBoosSectionData(sectionID, difficultyID)
    if not WoWTools_SC_SectionEncounter or not canaccessvalue(sectionID) or not canaccessvalue(difficultyID) then
        return
    end

    sectionID= GetValueID(sectionID)
    difficultyID= GetValueID(difficultyID) or EJ_GetDifficulty()

    local data= sectionID and WoWTools_SC_SectionEncounter[sectionID]
    if data then
        return {
            T=data.T,
            D=data[difficultyID] or data[14] or data[1],
        }
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































hooksecurefunc(QuestPinMixin, 'OnMouseEnter', function(self)
    WoWTools_ChineseMixin:Set_Quest(GameTooltip, self:GetQuestID(), true)
end)

hooksecurefunc(GossipSharedQuestButtonMixin, 'UpdateTitleForQuest', function(self, questID, titleText, isIgnored, isTrivial)
    local cn= WoWTools_ChineseMixin:GetQuestName(questID)
    titleText= cn or titleText
    if isIgnored then
        self:SetFormattedText('|cff000000%s（忽略）|r', titleText)
        self:Resize()
    elseif isTrivial then
        self:SetFormattedText('|cff000000%s （低等级）|r', titleText)
        self:Resize()
    elseif cn then
        self:SetFormattedText('|cff000000%s|r', titleText)
        self:Resize()
    end
end)


--hooksecurefunc(GossipSharedAvailableQuestButtonMixin, 'Setup', Set_Gossip_Text)
--hooksecurefunc(GossipSharedActiveQuestButtonMixin, 'Setup', Set_Gossip_Text)







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




