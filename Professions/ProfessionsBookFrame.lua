local id, e = ...







local function Set_UpdateButton(self)
    e.set(self.spellString)
    e.set(self.subSpellString)
    e.set(self.subSpellString)
end












local function Init()
    e.set(ProfessionsBookFrameTitleText)

    local tab={
        "PrimaryProfession1",
        "PrimaryProfession2",
        "SecondaryProfession1",
        "SecondaryProfession2",
        "SecondaryProfession3",
    }

    for _, name in pairs(tab) do
        local frame= _G[name]
        if frame then
            hooksecurefunc(_G[name].SpellButton1, 'UpdateButton', Set_UpdateButton)
            hooksecurefunc(_G[name].SpellButton2, 'UpdateButton', Set_UpdateButton)
        end
    end

    hooksecurefunc('FormatProfession', function(frame, index)
        e.set(frame.rank)
        e.set(frame.professionName, frame.skillName)
    end)
end














--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_ProfessionsBook') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_ProfessionsBook' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()

    end
end)