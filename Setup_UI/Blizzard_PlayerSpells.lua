function WoWTools_ChineseMixin.Events:Blizzard_PlayerSpells()

    self:HookLabel(PlayerSpellsFrameTitleText)--标题
    self:SetButton(PlayerSpellsFrame.TalentsFrame.InspectCopyButton)
    for _, tabID in pairs(PlayerSpellsFrame:GetTabSet() or {}) do
        local btn= PlayerSpellsFrame:GetTabButton(tabID)
        if btn then
            self:SetLabel(btn.Text)
        end
    end









--专精
    hooksecurefunc(PlayerSpellsFrame.SpecFrame, 'UpdateSpecContents', function(frame)--, index, sex, frameWidth, numSpecs)
        if frame.isInitialized or not C_SpecializationInfo.IsInitialized() then
            return
        end
        frame.isInitialized = true

        local numSpecs = GetNumSpecializations(false, false)
        frame.numSpecs = numSpecs
        if numSpecs == 0 then
            return
        end
        local sex = UnitSex("player")
        local specContentWidth = frame:GetWidth() / numSpecs

        -- set spec infos
        frame.SpecContentFramePool:ReleaseAll()
        for i = 1, numSpecs do
            local contentFrame = frame.SpecContentFramePool:Acquire()
            contentFrame:Setup(i, sex, specContentWidth, numSpecs)
        end
        frame:Layout()
    end)

    local sex= UnitSex('player')
    for frame in PlayerSpellsFrame.SpecFrame.SpecContentFramePool:EnumerateActive() do
        self:HookLabel(frame.SpecName)
        self:HookLabel(frame.RoleName)
        self:HookLabel(frame.ActivatedText)
        self:HookLabel(frame.ActivateButton)
        self:HookLabel(frame.SampleAbilityText)

        local _, _, description, _, _, primaryStat = GetSpecializationInfo(frame.specIndex, false, false, nil, sex)
        if description then
            local spec= SPEC_STAT_STRINGS[primaryStat]
            frame.Description:SetText(
                self:CN(description) or description
                .."|n"
                ..format('主要属性：%s', self:CN(spec) or spec or '')
            )
        end
    end










--天赋
    self:SetLabel(PlayerSpellsFrame.TalentsFrame.ApplyButton)--:SetText('应用改动')
    --self:HookLabel(PlayerSpellsFrame.TalentsFrame.LoadSystem.Dropdown.Text)

--新建 天赋，配置
    self:SetLabel(ClassTalentLoadoutCreateDialog.Title)
    self:SetLabel(ClassTalentLoadoutCreateDialog.NameControl.Label)
    self:SetButton(ClassTalentLoadoutCreateDialog.AcceptButton)
    self:SetButton(ClassTalentLoadoutCreateDialog.CancelButton)

--导入，天赋，配置
    self:SetLabel(ClassTalentLoadoutImportDialog.Title)
    self:SetLabel(ClassTalentLoadoutImportDialog.ImportControl.Label)
    self:SetLabel(ClassTalentLoadoutImportDialog.ImportControl.InputContainer.EditBox.Instructions)
    self:SetLabel(ClassTalentLoadoutImportDialog.NameControl.Label)
    self:SetButton(ClassTalentLoadoutImportDialog.AcceptButton)
    self:SetButton(ClassTalentLoadoutImportDialog.CancelButton)

    --专精，名称
    hooksecurefunc(PlayerSpellsFrame.TalentsFrame, 'RefreshCurrencyDisplay', function(frame)
        local className = self:SetText(frame:GetClassName()) or self:CN(PlayerUtil.GetClassName())
        if className then
            frame.ClassCurrencyDisplay:SetPointTypeText(className)
        end
        local specName= self:CN(frame:GetSpecName())
        if specName then
            frame.SpecCurrencyDisplay:SetPointTypeText(specName)
        end
    end)

    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.ChooseSpecLabel1:SetText('选择你的')
    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.ChooseSpecLabel2:SetText('英雄天赋')
    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.LockedLabel1:SetText('英雄天赋')
    PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer.LockedLabel2:SetText('达到%d级后解锁')

    hooksecurefunc(PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer, 'UpdateHeroSpecButton', function(frame)
        if frame:IsDisplayingActiveHeroSpec() then
            local name= self:CN(frame.activeSubTreeInfo.name)
            if name then
                frame.HeroSpecLabel:SetText(name)
            end
        elseif not frame:IsDisplayingHeroSpecChoices() and frame:IsDisplayingPreviewSpecs() then
            frame.LockedLabel2:SetFormattedText('达到%d级后解锁', frame.heroSpecsRequiredLevel)
        end
    end)

    PlayerSpellsFrame.TalentsFrame.WarmodeButton:HookScript('OnEnter', function(frame)
        local wrap = true
        local warModeRewardBonus = C_PvP.GetWarModeRewardBonus()
        GameTooltip:AddLine(' ')
        GameTooltip_AddNormalLine(GameTooltip, format('加入战争模式即可激活世界PvP，使任务的奖励和经验值提高%1$d%%，并可以在野外使用PvP天赋。', warModeRewardBonus), wrap)
        local canToggleWarmode = C_PvP.CanToggleWarMode(true)
        local canToggleWarmodeOFF = C_PvP.CanToggleWarMode(false)
        if(not canToggleWarmode or not canToggleWarmodeOFF) then
                if (not C_PvP.ArePvpTalentsUnlocked()) then
                GameTooltip_AddErrorLine(GameTooltip, format('在%d级解锁', C_PvP.GetPvpTalentsUnlockedLevel()), wrap)
            end
        end
        GameTooltip:Show()
    end)

    hooksecurefunc(PlayerSpellsFrame.TalentsFrame.PvPTalentList.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            local info= btn.talentInfo
            if info then
                local name= self:GetData(nil, {spellID=info.spellID, isName=true})
                if name then
                    btn.Name:SetText(name)
                end
            end
        end
    end)

--Blizzard_SharedTalentFrameTemplates.lua
    hooksecurefunc(TalentFrameGateMixin, 'OnEnter', function(self)
        if (self.condInfo.condID) then
            local condInfo = self:GetTalentFrame():GetAndCacheCondInfo(self.condInfo.condID)
            --GameTooltip:SetOwner(self, "ANCHOR_LEFT", 4, -4)
            GameTooltip:ClearLines()
            GameTooltip_AddErrorLine(GameTooltip, format('"再花费%d点天赋才能解锁此行', condInfo.spentAmountRequired))
            GameTooltip:Show()
        end
    end)


--英雄天赋
    hooksecurefunc(HeroTalentSpecContentMixin, 'Setup', function(frame)
        local specName= self:GetTraitSubTree(frame.subTreeID, true, false)
        if specName then
            frame.SpecName:SetText(specName)
        end
        local desc= self:GetTraitSubTree(frame.subTreeID, false, true)
        if desc then
            frame.Description:SetText(desc)
        end
        self:SetButton(frame.ActivateButton)
        self:SetButton(frame.ApplyChangesButton)
        self:SetButton(frame.ApplyChangesButton)

        self:SetLabel(frame.CurrencyFrame.LabelText)
        self:SetLabel(frame.ActivatedText)
        self:SetLabel(frame.LabelText)
    end)

--HeroTalentsContainerMixin
    hooksecurefunc(PlayerSpellsFrame.TalentsFrame.HeroTalentsContainer, 'UpdateHeroSpecButton', function(frame)
        if frame.HeroSpecLabel:IsShown() and frame.activeSubTreeInfo and frame.activeSubTreeInfo then
            local specName= self:GetTraitSubTree(frame.activeSubTreeInfo.ID, true, false)
            if specName then
                frame.HeroSpecLabel:SetText(specName)
            end
        end
    end)












--法术书
    if PlayerSpellsFrame.SpellBookFrame.AssistedCombatRotationSpellFrame then--11.1.7才有
        self:HookLabel(PlayerSpellsFrame.SpellBookFrame.AssistedCombatRotationSpellFrame.Label)
        --PlayerSpellsFrame.SpellBookFrame.AssistedCombatRotationSpellFrame.Label:SetText('一键|n辅助')
    else--11.1.7没了
        self:SetLabel(PlayerSpellsFrame.SpellBookFrame.HidePassivesCheckButton.Label)--隐藏被动技能
    end


    if PlayerSpellsFrame.SpellBookFrame.SearchPreviewContainer.DefaultResultButton then--11.2.5没了
        self:SetLabel(PlayerSpellsFrame.SpellBookFrame.SearchPreviewContainer.DefaultResultButton.Text)
    end
    self:SetLabel(ClassTalentLoadoutCreateDialog.Title)
    self:SetLabel(ClassTalentLoadoutCreateDialog.NameControl.Label)
    self:SetLabel(ClassTalentLoadoutCreateDialog.AcceptButton)
    self:SetLabel(ClassTalentLoadoutCreateDialog.CancelButton)



--名称
    hooksecurefunc(SpellBookItemMixin, 'UpdateVisuals', function(frame)
        local info= frame.spellBookItemInfo
        if not info then
            return
        end

        local spellID= info.spellID or (info.actionID and C_ActionBar.GetSpell(info.actionID))
        if not spellID then
            return
        end
        
        local cn= self:GetSpellName(spellID) -- actionID= self:GetData(info.name, {spellID=info.actionID, isName=true})
        if cn then
            frame.Name:SetText(cn)
        else
            self:SetLabel(frame.Name, info.name)
        end
        if frame.isUnlearned and frame.RequiredLevel:IsShown() then
            local levelLearned = C_SpellBook.GetSpellBookItemLevelLearned(frame.slotIndex, frame.spellBank)
            local subtext
            if not frame.isOffSpec and IsCharacterNewlyBoosted() then
                subtext = '暂时锁定'
            elseif levelLearned and levelLearned > UnitLevel("player") then
                subtext = string.format('%d级', levelLearned)
            elseif not frame.isOffSpec then
                subtext = '访问你的训练师'
            end
            if subtext then
                frame.RequiredLevel:SetText(subtext)
            end
        end
    end)

--子，名称
    hooksecurefunc(SpellBookItemMixin, 'UpdateSubName', function(frame, subNameText)
        if subNameText == "" and frame.spellBookItemInfo.isPassive then
		    subNameText = '被动'
            frame.spellBookItemInfo.subName = subNameText
            frame.SubName:SetText(subNameText)
	    else
            local cn= self:CN(subNameText)
            if frame.spellBookItemInfo and not cn then
                cn= select(3, self:GetSpellName(frame.spellBookItemInfo.spellID))
            end
            if cn then
                frame.SubName:SetText(cn)
            else
                self:SetLabel(frame.SubName, subNameText)
            end
        end
    end)

--Header Blizzard_SpellBookTemplates.lua
    hooksecurefunc(PlayerSpellsFrame.SpellBookFrame, 'UpdateDisplayedSpells',function(frame)
        for _, btn in pairs(frame.PagedSpellsFrame:GetFrames() or {}) do
            local cn = btn.Text and self:SetText(btn.Text:GetText())
            if cn then
                cn= cn:gsub('|c........', '')
                cn= cn:gsub('|r', '')
                btn.Text:SetText(cn)
            end
        end
    end)

    hooksecurefunc(PlayerSpellsFrame.SpellBookFrame.PagedSpellsFrame.PagingControls, 'SetCurrentPage',function(frame)
        for _, btn in pairs(frame:GetParent():GetFrames() or {}) do
            local cn = btn.Text and self:SetText(btn.Text:GetText())
            if cn then
                cn= cn:gsub('|c........', '')
                cn= cn:gsub('|r', '')
                btn.Text:SetText(cn)
            end
        end
    end)
end





