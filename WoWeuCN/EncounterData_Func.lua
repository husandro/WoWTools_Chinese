
if loadEncounterData then
    return
end







local function UpdateEncounterJournalHeaders()
    local usedHeaders = EncounterJournal.encounter.usedHeaders
    for index, infoHeader in pairs(usedHeaders) do
        if (infoHeader and infoHeader.description) then
        local sectionID = infoHeader.myID
        local difficultyID = EJ_GetDifficulty()
            local sectionTranslation = WoWeuCN_Tooltips_EncounterSectionData[difficultyID .. 'x' .. sectionID]
            if (sectionTranslation) then
                infoHeader.button.title:SetText(sectionTranslation["Title"])
                infoHeader.description:SetText(sectionTranslation["Description"])
                EncounterJournal_ShiftHeaders(index)
            end
        end
    end
end







local function Init()
    hooksecurefunc("EncounterJournal_DisplayEncounter", function(encounterID)
        local info = WoWeuCN_Tooltips_EncounterData[encounterID]
        if (info) then
            local self = EncounterJournal.encounter
            self.info.encounterTitle:SetText(info["Title"])
            self.overviewFrame.loreDescription:SetText(info["Description"])
            local difficultyID = EJ_GetDifficulty()
            local sectionID = self.overviewFrame.rootOverviewSectionID
            local data = WoWeuCN_Tooltips_EncounterSectionData[difficultyID .. 'x' .. sectionID]

            if (data) then
                self.overviewFrame.overviewDescription.Text:SetText(data["Description"])
                self.overviewFrame.overviewDescription.descriptionHeight = self.overviewFrame.overviewDescription:GetHeight()
            end

            self.infoFrame.description:SetText(info["Description"])
            self.infoFrame.descriptionHeight = self.infoFrame.description:GetHeight()
            if self.usedHeaders[1] then
                self.usedHeaders[1]:SetPoint("TOPRIGHT", 0 , -8 - EncounterJournal.encounter.infoFrame.descriptionHeight - 6)
            end
        end
        UpdateEncounterJournalHeaders()
    end)

    hooksecurefunc("EncounterJournal_ToggleHeaders", function(object)
        if (object == EncounterJournal.encounter.overviewFrame) then
            return
        end
        UpdateEncounterJournalHeaders()
    end)

    hooksecurefunc("EncounterJournal_SetDescriptionWithBullets", function(infoHeader)
        local sectionID = infoHeader.sectionID
        local difficultyID = EJ_GetDifficulty()
        local data = WoWeuCN_Tooltips_EncounterSectionData[difficultyID .. 'x' .. sectionID]
        if (data) then
            infoHeader.button.title:SetText(data["Title"])
            EncounterJournal_SetBullets(infoHeader.overviewDescription, data["Description"], not infoHeader.expanded)
        end
    end)
end






--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_EncounterJournal') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_EncounterJournal' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)
