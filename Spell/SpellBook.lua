if not SpellBookFrame then--11版本
    return
end


local e= select(2, ...)
--法术书，界面, 菜单
--11版本

for i=1, SPELLS_PER_PAGE  do--SPELLS_PER_PAGE = 12
    local btn= _G['SpellButton'..i]
    if btn and btn.UpdateButton then
        hooksecurefunc(btn, 'UpdateButton', function(self)--SpellBookFrame.lua            
            e.set(self.SpellSubName)            
            if self.SpellName then                
                local name
                local slot = SpellBook_GetSpellBookSlot(self)
                if slot then
                    local _, spellID = GetSpellBookItemInfo(slot, SpellBookFrame.bookType);                    
                    name= spellID and e.Get_Spell_Name(spellID)                
                end
                name= name or e.strText[self.SpellName:GetText()]                
                if name then
                    self.SpellName:SetText(name)
                end
                --[[if name and not self.SpellName2 then
                    self.SpellName2= e.Cstr(self)
                    self.SpellName2:SetAllPoints(self.SpellName)
                end                
                if self.SpellName2 then
                    self.SpellName2:SetText(name or '')                    
                end
                self.SpellName:SetAlpha(name and 0 or 1)]]
            end
        end)
    end
end