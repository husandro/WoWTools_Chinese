if SpellBookFrame then--11版本
    return
end
local id, e= ...
















local function Init_SpellBookFrame()
    e.set(PlayerSpellsFrame.SpellBookFrame.HidePassivesCheckButton.Label)--隐藏被动技能
    e.set(PlayerSpellsFrame.SpellBookFrame.SearchPreviewContainer.DefaultResultButton.Text)
    e.set(ClassTalentLoadoutCreateDialog.Title)
    e.set(ClassTalentLoadoutCreateDialog.NameControl.Label)
    e.set(ClassTalentLoadoutCreateDialog.AcceptButton)
    e.set(ClassTalentLoadoutCreateDialog.CancelButton)

--TabSys
    for _, tabID in pairs(PlayerSpellsFrame.SpellBookFrame:GetTabSet() or {}) do
        local btn= PlayerSpellsFrame.SpellBookFrame:GetTabButton(tabID)
        if btn then
            e.set(btn.Text)
        end
    end


--名称
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

--子，名称
    hooksecurefunc(SpellBookItemMixin, 'UpdateSubName', function(self, subNameText)
        local name= e.cn(subNameText)
        if name then
            self.SubName:SetText(name)
        end
    end)

end











--Blizzard_SharedTalentFrameTemplates.lua
hooksecurefunc(TalentFrameGateMixin, 'OnEnter', function(self)
    if (self.condInfo.condID) then
        local condInfo = self:GetTalentFrame():GetAndCacheCondInfo(self.condInfo.condID);
        --GameTooltip:SetOwner(self, "ANCHOR_LEFT", 4, -4);
        GameTooltip:ClearLines()
        GameTooltip_AddErrorLine(GameTooltip, format('"再花费%d点天赋才能解锁此行', condInfo.spentAmountRequired));
        GameTooltip:Show()
    end
end)











--天赋
local function Init_TalentsFrame()
    e.set(PlayerSpellsFrame.TalentsFrame.ApplyButton)--:SetText('应用改动')
    e.hookLabel(PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown.Text)
    e.set(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.DefaultResultButton.Text)
    --专精，名称
    hooksecurefunc(PlayerSpellsFrame.TalentsFrame, 'RefreshCurrencyDisplay', function(self)
        local className = e.strText[self:GetClassName()]
        if className then
            self.ClassCurrencyDisplay:SetPointTypeText(className)
        end            
        local specName= e.strText[self:GetSpecName()]
        if specName then
            self.SpecCurrencyDisplay:SetPointTypeText(specName)
        end        
    end)

    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.ChooseSpecLabel1:SetText('选择你的')
    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.ChooseSpecLabel2:SetText('英雄天赋')
    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.LockedLabel1:SetText('英雄天赋')
    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.LockedLabel2:SetText('达到%d级后解锁')

    hooksecurefunc(PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer, 'UpdateHeroSpecButton', function(self)     
        if self:IsDisplayingActiveHeroSpec() then
            local name= e.strText[self.activeSubTreeInfo.name]
            if name then
                self.HeroSpecLabel:SetText(name)
            end
        elseif not self:IsDisplayingHeroSpecChoices() and self:IsDisplayingPreviewSpecs() then            
            self.LockedLabel2:SetFormattedText('达到%d级后解锁', self.heroSpecsRequiredLevel)
        end       
    end)


end





















local function Init_SpecFrame()
    
    hooksecurefunc(PlayerSpellsFrame.SpecFrame, 'UpdateSpecContents', function(self, index, sex, frameWidth, numSpecs)
        if self.isInitialized or not C_SpecializationInfo.IsInitialized() then
            return;
        end
        self.isInitialized = true;
    
        local numSpecs = GetNumSpecializations(false, false);
        self.numSpecs = numSpecs;
        if numSpecs == 0 then 
            return;
        end
        local sex = UnitSex("player");
        local specContentWidth = self:GetWidth() / numSpecs;
    
        -- set spec infos
        self.SpecContentFramePool:ReleaseAll();
        for i = 1, numSpecs do
            local contentFrame = self.SpecContentFramePool:Acquire();
            contentFrame:Setup(i, sex, specContentWidth, numSpecs);
        end
        self:Layout();
    end)




    local sex= UnitSex('player')
    for frame in PlayerSpellsFrame.SpecFrame.SpecContentFramePool:EnumerateActive() do 
        e.hookLabel(frame.SpecName)
        e.hookLabel(frame.RoleName)
        e.hookLabel(frame.ActivatedText)
        e.hookLabel(frame.ActivateButton)
        e.hookLabel(frame.SampleAbilityText)

        local specID, name, description, icon, _, primaryStat = GetSpecializationInfo(frame.specIndex, false, false, nil, sex)
        if description then
            frame.Description:SetText(e.cn(description).."|n"..format('主要属性：%s', e.cn(SPEC_STAT_STRINGS[primaryStat])))
        end
    end
end











local function Init()    
    Init_SpellBookFrame()
    Init_TalentsFrame()
    Init_SpecFrame()

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