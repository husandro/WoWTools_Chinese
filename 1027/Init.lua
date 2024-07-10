if select(4,GetBuildInfo())>=110000  then--11版本
    return
end

local e= select(2, ...)


 --法术 SpellBookFrame.lua
 hooksecurefunc('SpellBookFrame_Update', function()
    e.set(SpellBookFrameTabButton1)
    e.set(SpellBookFrameTabButton2)
    e.set(SpellBookFrameTabButton3)

    if SpellBookFrame.bookType== BOOKTYPE_SPELL then
        SpellBookFrame:SetTitle('法术')
    elseif SpellBookFrame.bookType== BOOKTYPE_PROFESSION then
        SpellBookFrame:SetTitle('专业')
    elseif SpellBookFrame.bookType== BOOKTYPE_PET then
        SpellBookFrame:SetTitle('宠物')
    end
end)
hooksecurefunc('SpellBookFrame_UpdatePages', function()
    local currentPage, maxPages = SpellBook_GetCurrentPage()
    if ( maxPages == nil or maxPages == 0 ) then
        return
    end
    SpellBookPageText:SetFormattedText('第%d页', currentPage)
end)

hooksecurefunc('UpdateProfessionButton', function(self)
    local parent = self:GetParent()
    local spellIndex = self:GetID() + parent.spellOffset
    local spellName, _, spellID = GetSpellBookItemName(spellIndex, SpellBookFrame.bookType)
    e.set(self.spellString, spellName)
    if spellID then
        local spell = Spell:CreateFromSpellID(spellID)
        spell:ContinueOnSpellLoad(function()
            local text= spell:GetSpellSubtext()
            e.set(self.subSpellString, text)
        end)
    end
end)
