




















function WoWTools_ChineseMixin.Events:Blizzard_ProfessionsBook()
    self:SetLabel(ProfessionsBookFrameTitleText)

    self:SetLabel(PrimaryProfession1Missing)
    self:SetLabel(PrimaryProfession1.missingText)
    self:SetLabel(PrimaryProfession2Missing)
    self:SetLabel(PrimaryProfession2.missingText)

    self:SetLabel(SecondaryProfession1Missing)
    self:SetLabel(SecondaryProfession2Missing)
    self:SetLabel(SecondaryProfession3Missing)

    self:SetLabel(SecondaryProfession1.missingText)
    self:SetLabel(SecondaryProfession2.missingText)
    self:SetLabel(SecondaryProfession3.missingText)


    local tab={
        "PrimaryProfession1",
        "PrimaryProfession2",
        "SecondaryProfession1",
        "SecondaryProfession2",
        "SecondaryProfession3",
    }

    local function Set_UpdateButton(btn)
        local parent = btn:GetParent()
        if not parent.professionInitialized then
            return
        end
        local activeSpellBank = Enum.SpellBookSpellBank.Player
        local spellIndex = btn:GetID() + parent.spellOffset
        local spellBookItemInfo = C_SpellBook.GetSpellBookItemInfo(spellIndex, activeSpellBank)
        local name
        if spellBookItemInfo.spellID then
            name= self:GetSpellName(spellBookItemInfo.spellID)
        end
        if name then
            btn.spellString:SetText(name)
        else
            self:SetLabel(btn.spellString)
        end

        self:SetLabel(btn.subSpellString)
        self:SetLabel(btn.subSpellString)
    end

    for _, name in pairs(tab) do
        local frame= _G[name]
        if frame then
            hooksecurefunc(_G[name].SpellButton1, 'UpdateButton', Set_UpdateButton)
            hooksecurefunc(_G[name].SpellButton2, 'UpdateButton', Set_UpdateButton)
        end
    end

    --hooksecurefunc(ProfessionSpellButtonMixin, 'UpdateButton', function(btn, index)
      

    hooksecurefunc('FormatProfession', function(frame)
        self:SetLabel(frame.rank)
        self:HookLabel(frame.professionName, frame.skillName)
    end)
end