
















local function Init_SpellBookFrame()
    WoWTools_ChineseMixin:SetLabelText(PlayerSpellsFrame.SpellBookFrame.HidePassivesCheckButton.Label)--隐藏被动技能
    WoWTools_ChineseMixin:SetLabelText(PlayerSpellsFrame.SpellBookFrame.SearchPreviewContainer.DefaultResultButton.Text)
    WoWTools_ChineseMixin:SetLabelText(ClassTalentLoadoutCreateDialog.Title)
    WoWTools_ChineseMixin:SetLabelText(ClassTalentLoadoutCreateDialog.NameControl.Label)
    WoWTools_ChineseMixin:SetLabelText(ClassTalentLoadoutCreateDialog.AcceptButton)
    WoWTools_ChineseMixin:SetLabelText(ClassTalentLoadoutCreateDialog.CancelButton)

--TabSys
    for _, tabID in pairs(PlayerSpellsFrame.SpellBookFrame:GetTabSet() or {}) do
        local btn= PlayerSpellsFrame.SpellBookFrame:GetTabButton(tabID)
        if btn then
            WoWTools_ChineseMixin:SetLabelText(btn.Text)
        end
    end


--名称
    hooksecurefunc(SpellBookItemMixin, 'UpdateVisuals', function(self)
        local name= WoWTools_ChineseMixin:Setup(self.spellBookItemInfo.name, {spellID=self.spellBookItemInfo.actionID, isName=true})
        if name then
            self.Name:SetText(name)
        end
        if self.isUnlearned and self.RequiredLevel:IsShown() then
            local levelLearned = C_SpellBook.GetSpellBookItemLevelLearned(self.slotIndex, self.spellBank)
            local subtext
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
        local name= WoWTools_ChineseMixin:Setup(subNameText)
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
    WoWTools_ChineseMixin:SetLabelText(PlayerSpellsFrame.TalentsFrame.ApplyButton)--:SetText('应用改动')
    WoWTools_ChineseMixin:HookLabel(PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown.Text)
    WoWTools_ChineseMixin:SetLabelText(PlayerSpellsFrame.TalentsFrame.SearchPreviewContainer.DefaultResultButton.Text)
    --专精，名称
    hooksecurefunc(PlayerSpellsFrame.TalentsFrame, 'RefreshCurrencyDisplay', function(self)
        local className = WoWTools_ChineseMixin:CN(self:GetClassName())
        if className then
            self.ClassCurrencyDisplay:SetPointTypeText(className)
        end
        local specName= WoWTools_ChineseMixin:CN(self:GetSpecName())
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
            local name= WoWTools_ChineseMixin:CN(self.activeSubTreeInfo.name)
            if name then
                self.HeroSpecLabel:SetText(name)
            end
        elseif not self:IsDisplayingHeroSpecChoices() and self:IsDisplayingPreviewSpecs() then
            self.LockedLabel2:SetFormattedText('达到%d级后解锁', self.heroSpecsRequiredLevel)
        end
    end)

    PlayerSpellsFrame.TalentsFrame.WarmodeButton:HookScript('OnEnter', function(self)
        local wrap = true;
        local warModeRewardBonus = C_PvP.GetWarModeRewardBonus();
        GameTooltip:AddLine(' ')
        GameTooltip_AddNormalLine(GameTooltip, format('加入战争模式即可激活世界PvP，使任务的奖励和经验值提高%1$d%%，并可以在野外使用PvP天赋。', warModeRewardBonus), wrap);
        local canToggleWarmode = C_PvP.CanToggleWarMode(true);
        local canToggleWarmodeOFF = C_PvP.CanToggleWarMode(false);
        if(not canToggleWarmode or not canToggleWarmodeOFF) then
                if (not C_PvP.ArePvpTalentsUnlocked()) then
                GameTooltip_AddErrorLine(GameTooltip, format('在%d级解锁', C_PvP.GetPvpTalentsUnlockedLevel()), wrap);
            end
        end
        GameTooltip:Show();
    end)


    hooksecurefunc(PlayerSpellsFrame.TalentsFrame.PvPTalentList.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            local info= btn.talentInfo
            if info then
                local name= WoWTools_ChineseMixin:Setup(nil, {spellID=info.spellID, isName=true})
                if name then
                    btn.Name:SetText(name)
                end
            end
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
        WoWTools_ChineseMixin:HookLabel(frame.SpecName)
        WoWTools_ChineseMixin:HookLabel(frame.RoleName)
        WoWTools_ChineseMixin:HookLabel(frame.ActivatedText)
        WoWTools_ChineseMixin:HookLabel(frame.ActivateButton)
        WoWTools_ChineseMixin:HookLabel(frame.SampleAbilityText)

        local specID, name, description, icon, _, primaryStat = GetSpecializationInfo(frame.specIndex, false, false, nil, sex)
        if description then
            frame.Description:SetText(WoWTools_ChineseMixin:Setup(description).."|n"..format('主要属性：%s', WoWTools_ChineseMixin:Setup(SPEC_STAT_STRINGS[primaryStat])))
        end
    end
end











local function Init()
    Init_SpellBookFrame()
    Init_TalentsFrame()
    Init_SpecFrame()

    WoWTools_ChineseMixin:HookLabel(PlayerSpellsFrameTitleText)--标题

    for _, tabID in pairs(PlayerSpellsFrame:GetTabSet() or {}) do
        local btn= PlayerSpellsFrame:GetTabButton(tabID)
        if btn then
            WoWTools_ChineseMixin:SetLabelText(btn.Text)
        end
    end
end














EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_PlayerSpells' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)
