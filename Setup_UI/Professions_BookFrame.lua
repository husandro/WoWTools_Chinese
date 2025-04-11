







local function Set_UpdateButton(self)
    WoWTools_ChineseMixin:SetLabelText(self.spellString)
    WoWTools_ChineseMixin:SetLabelText(self.subSpellString)
    WoWTools_ChineseMixin:SetLabelText(self.subSpellString)
end












local function Init()
    WoWTools_ChineseMixin:SetLabelText(ProfessionsBookFrameTitleText)

    WoWTools_ChineseMixin:SetLabelText(PrimaryProfession1Missing)
    WoWTools_ChineseMixin:SetLabelText(PrimaryProfession1.missingText)
    WoWTools_ChineseMixin:SetLabelText(PrimaryProfession2Missing)
    WoWTools_ChineseMixin:SetLabelText(PrimaryProfession2.missingText)

    WoWTools_ChineseMixin:SetLabelText(SecondaryProfession1Missing)
    WoWTools_ChineseMixin:SetLabelText(SecondaryProfession2Missing)
    WoWTools_ChineseMixin:SetLabelText(SecondaryProfession3Missing)

    WoWTools_ChineseMixin:SetLabelText(SecondaryProfession1.missingText)
    WoWTools_ChineseMixin:SetLabelText(SecondaryProfession2.missingText)
    WoWTools_ChineseMixin:SetLabelText(SecondaryProfession3.missingText)


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
        WoWTools_ChineseMixin:SetLabelText(frame.rank)
        WoWTools_ChineseMixin:HookLabel(frame.professionName, frame.skillName)
    end)
end











EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_ProfessionsBook' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)