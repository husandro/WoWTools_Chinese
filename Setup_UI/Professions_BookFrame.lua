local id, e = ...







local function Set_UpdateButton(self)
    e.set(self.spellString)
    e.set(self.subSpellString)
    e.set(self.subSpellString)
end












local function Init()
    e.set(ProfessionsBookFrameTitleText)

    e.set(PrimaryProfession1Missing)
    e.set(PrimaryProfession1.missingText)
    e.set(PrimaryProfession2Missing)
    e.set(PrimaryProfession2.missingText)

    e.set(SecondaryProfession1Missing)
    e.set(SecondaryProfession2Missing)
    e.set(SecondaryProfession3Missing)

    e.set(SecondaryProfession1.missingText)
    e.set(SecondaryProfession2.missingText)
    e.set(SecondaryProfession3.missingText)


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

    hooksecurefunc('FormatProfession', function(frame)
        e.set(frame.rank)
        e.hookLabel(frame.professionName, frame.skillName)
    end)
end











EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_ProfessionsBook' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)