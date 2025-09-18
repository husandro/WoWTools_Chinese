

function WoWTools_ChineseMixin:GetBossData(journalEncounterID)
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



