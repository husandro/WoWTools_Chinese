if SpellBookFrame then--11版本
    return
end
local id, e= ...
















local function Init_SpellBookFrame()
    for _, tabID in pairs(PlayerSpellsFrame.SpellBookFrame:GetTabSet() or {}) do
        local btn= PlayerSpellsFrame.SpellBookFrame:GetTabButton(tabID)
        if btn then
            e.set(btn.Text)
        end
    end
    e.set(PlayerSpellsFrame.SpellBookFrame.HidePassivesCheckButton.Label)

    hooksecurefunc(SpellBookItemMixin, 'UpdateVisuals', function(self)
        local name= e.cn(self.spellBookItemInfo.name, {spellID=self.spellBookItemInfo.actionID, isName=true})
        if name then
            self.Name:SetText(name)
        end
        if self.isUnlearned and self.RequiredLevel:IsShown() then
            local levelLearned = C_SpellBook.GetSpellBookItemLevelLearned(self.slotIndex, self.spellBank)
            if not self.isOffSpec and IsCharacterNewlyBoosted() then
                subtext = '暂时锁定';
            elseif levelLearned and levelLearned > UnitLevel("player") then
                subtext = string.format('%d级', levelLearned)
            elseif not self.isOffSpec then
                subtext = '访问你的训练师';
            end
            if subtext then
                self.RequiredLevel:SetText(subtext)
            end
        end
    end)

    hooksecurefunc(SpellBookItemMixin, 'UpdateSubName', function(self, subNameText)
        local name= e.cn(subNameText)
        if name then
            self.SubName:SetText(name)
        end
    end)

    hooksecurefunc(SpellBookSearchMixin, 'OnPreviewSearchResultClicked', function(self, resultInfo)
        if resultInfo and resultInfo.name then
            info= resultInfo
            for k, v in pairs(info) do if v and type(v)=='table' then print('|cff00ff00---',k, '---STAR') for k2,v2 in pairs(v) do print(k2,v2) end print('|cffff0000---',k, '---END') else print(k,v) end end print('|cffff00ff——————————')
            self.SearchBox:SetText(resultInfo.name)
            
        end
    end)
end









local function Init()    
    Init_SpellBookFrame()

    e.hookLabel(PlayerSpellsFrameTitleText)--标题

    for _, tabID in pairs(PlayerSpellsFrame:GetTabSet() or {}) do
        local btn= PlayerSpellsFrame:GetTabButton(tabID)
        if btn then
            e.set(btn.Text)
        end
    end



end


--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_PlayerSpells') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_PlayerSpells' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()

    end
end)