







local function Set_UpdateButton(frame)
    WoWTools_ChineseMixin:SetLabel(frame.spellString)
    WoWTools_ChineseMixin:SetLabel(frame.subSpellString)
    WoWTools_ChineseMixin:SetLabel(frame.subSpellString)
end












function WoWTools_ChineseMixin.Events:Blizzard_ProfessionsBook()
    WoWTools_ChineseMixin:SetLabel(ProfessionsBookFrameTitleText)

    WoWTools_ChineseMixin:SetLabel(PrimaryProfession1Missing)
    WoWTools_ChineseMixin:SetLabel(PrimaryProfession1.missingText)
    WoWTools_ChineseMixin:SetLabel(PrimaryProfession2Missing)
    WoWTools_ChineseMixin:SetLabel(PrimaryProfession2.missingText)

    WoWTools_ChineseMixin:SetLabel(SecondaryProfession1Missing)
    WoWTools_ChineseMixin:SetLabel(SecondaryProfession2Missing)
    WoWTools_ChineseMixin:SetLabel(SecondaryProfession3Missing)

    WoWTools_ChineseMixin:SetLabel(SecondaryProfession1.missingText)
    WoWTools_ChineseMixin:SetLabel(SecondaryProfession2.missingText)
    WoWTools_ChineseMixin:SetLabel(SecondaryProfession3.missingText)


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
        WoWTools_ChineseMixin:SetLabel(frame.rank)
        WoWTools_ChineseMixin:HookLabel(frame.professionName, frame.skillName)
    end)
end