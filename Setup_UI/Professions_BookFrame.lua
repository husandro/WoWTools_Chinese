local id, e = ...







local function Set_UpdateButton(self)
    WoWTools_ChineseMixin:Set_Label_Text(self.spellString)
    WoWTools_ChineseMixin:Set_Label_Text(self.subSpellString)
    WoWTools_ChineseMixin:Set_Label_Text(self.subSpellString)
end












local function Init()
    WoWTools_ChineseMixin:Set_Label_Text(ProfessionsBookFrameTitleText)

    WoWTools_ChineseMixin:Set_Label_Text(PrimaryProfession1Missing)
    WoWTools_ChineseMixin:Set_Label_Text(PrimaryProfession1.missingText)
    WoWTools_ChineseMixin:Set_Label_Text(PrimaryProfession2Missing)
    WoWTools_ChineseMixin:Set_Label_Text(PrimaryProfession2.missingText)

    WoWTools_ChineseMixin:Set_Label_Text(SecondaryProfession1Missing)
    WoWTools_ChineseMixin:Set_Label_Text(SecondaryProfession2Missing)
    WoWTools_ChineseMixin:Set_Label_Text(SecondaryProfession3Missing)

    WoWTools_ChineseMixin:Set_Label_Text(SecondaryProfession1.missingText)
    WoWTools_ChineseMixin:Set_Label_Text(SecondaryProfession2.missingText)
    WoWTools_ChineseMixin:Set_Label_Text(SecondaryProfession3.missingText)


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
        WoWTools_ChineseMixin:Set_Label_Text(frame.rank)
        WoWTools_ChineseMixin:HookLabel(frame.professionName, frame.skillName)
    end)
end











EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_ProfessionsBook' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)