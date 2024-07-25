local id, e= ...











local function Init_Mount()
    --列表，名称
    hooksecurefunc('MountJournal_InitMountButton', function(btn)
        --btn.DragonRidingLabel:SetText("驭空术")
        e.set(btn.name)
    end)

    e.dia("DIALOG_REPLACE_MOUNT_EQUIPMENT", {text = '你确定要替换此坐骑装备吗？已有的坐骑装备将被摧毁。', button1 = '是', button2 = '否'})

    MountJournalSearchBox.Instructions:SetText('搜索')
    --MountJournal.FilterDropdown.Text:SetText('过滤器')
    MountJournal.MountCount.Label:SetText('坐骑')
    MountJournalSummonRandomFavoriteButton.spellname:SetText('随机召唤\n偏好坐骑')--hooksecurefunc('MountJournalSummonRandomFavoriteButton_OnLoad', function(self)
    MountJournal.MountDisplay.ModelScene.TogglePlayer.TogglePlayerText:SetText('显示角色')
    hooksecurefunc('MountJournal_OnLoad', function(self)
        self.SlotRequirementLabel:SetFormattedText('坐骑装备在%s级解锁', C_MountJournal.GetMountEquipmentUnlockLevel())
    end)
    hooksecurefunc('MountJournal_InitializeEquipmentSlot', function(self, item)
        if not item then
            self.SlotLabel:SetText('使用坐骑装备来强化你的坐骑。')
        end
    end)
    hooksecurefunc('MountJournal_UpdateMountDisplay', function(forceSceneChange)
        if not MountJournal.selectedMountID then
            return
        end
        e.set(MountJournal.MountDisplay.InfoButton.Name)
        e.set(MountJournal.MountDisplay.InfoButton.Source)
        e.set(MountJournal.MountDisplay.InfoButton.Lore)
            --[[local creatureName, spellID= C_MountJournal.GetMountInfoByID(MountJournal.selectedMountID)
            if ( MountJournal.MountDisplay.lastDisplayed ~= spellID or forceSceneChange ) then
                local _, descriptionText, sourceText = C_MountJournal.GetMountInfoExtraByID(MountJournal.selectedMountID)
                e.set(MountJournal.MountDisplay.InfoButton.Name, creatureName)
                e.set(MountJournal.MountDisplay.InfoButton.Source, sourceText)
                e.set(MountJournal.MountDisplay.InfoButton.Lore, descriptionText)
            end]]
            if C_MountJournal.NeedsFanfare(MountJournal.selectedMountID) then
                MountJournal.MountButton:SetText('打开')
            elseif select(4, C_MountJournal.GetMountInfoByID(MountJournal.selectedMountID)) then
                MountJournal.MountButton:SetText('解散坐骑')
            else
                MountJournal.MountButton:SetText('召唤坐骑')
            end
    end)

    --召唤坐骑，按钮，提示
    MountJournalMountButton:HookScript('OnEnter', function()
        local needsFanFare = MountJournal.selectedMountID and C_MountJournal.NeedsFanfare(MountJournal.selectedMountID)
        if needsFanFare then
            GameTooltip_SetTitle(GameTooltip, '打开即可获得|n你的崭新坐骑。', NORMAL_FONT_COLOR, true)
        else
            GameTooltip_SetTitle(GameTooltip, '召唤或解散|n你选定的坐骑。', NORMAL_FONT_COLOR, true)
        end
        GameTooltip:Show()
    end)

    e.set(MountJournal.FilterDropdown.Text)
    e.region(MountJournal.ToggleDynamicFlightFlyoutButton)
end


















local function Init_Pet()
    e.dia("BATTLE_PET_RENAME", {text = '重命名', button1 = '接受', button2 = '取消', button3 = '默认'})
    e.dia("BATTLE_PET_PUT_IN_CAGE", {text = '把这只宠物放入笼中？', button1 = '确定', button2 = '取消'})
    e.dia("BATTLE_PET_RELEASE", {text = "\n\n你确定要释放|cffffd200%s|r吗？\n\n", button1 = '确定', button2 = '取消'})

    PetJournalSearchBox.Instructions:SetText('搜索')
    --PetJournal.FilterDropdown.Text:SetText('过滤器')
    local function Set_Pet_Button_Name()
        local petID = PetJournalPetCard.petID
        local hasPetID = petID ~= nil
        local needsFanfare = hasPetID and C_PetJournal.PetNeedsFanfare(petID)
        if hasPetID and petID == C_PetJournal.GetSummonedPetGUID() then
            PetJournal.SummonButton:SetText('解散')
        elseif needsFanfare then
            PetJournal.SummonButton:SetText('打开')
        else
            PetJournal.SummonButton:SetText('召唤')
        end
    end
    hooksecurefunc('PetJournal_UpdateSummonButtonState', Set_Pet_Button_Name)
    Set_Pet_Button_Name()

    local function set_PetJournalFindBattle()
        local queueState = C_PetBattles.GetPVPMatchmakingInfo()
        if ( queueState == "queued" or queueState == "proposal" or queueState == "suspended" ) then
            PetJournalFindBattle:SetText('离开队列')
        else
            PetJournalFindBattle:SetText('搜寻战斗')
        end
    end
    hooksecurefunc('PetJournalFindBattle_Update', set_PetJournalFindBattle)
    set_PetJournalFindBattle()
    PetJournal.PetCount.Label:SetText('宠物')
    PetJournalSummonRandomFavoritePetButtonSpellName:SetText('召唤随机\n偏好战斗宠物')
    PetJournalHealPetButtonSpellName:SetText('复活\n战斗宠物')

    --列表，名称
    hooksecurefunc(PetJournal.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            e.set(btn.name)
        end
    end)
end















local function Init_Toy()
    --ToyBox.searchBox.Instructions:SetText('搜索')
    --e.set(ToyBox.FilterDropdown.Text)
    hooksecurefunc(ToyBox.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)
   
    hooksecurefunc('ToySpellButton_UpdateButton', function(self)
        if self:IsShown() and self.itemID then
            local name = e.Get_Item_Name(self.itemID) or e.strText[self.name:GetText()]          
            if name then
                name= name:match('|c........(.-)|r') or name
                self.name:SetText(name)
            end
        end
    end)
end






















local function Init_Heirlooms()
    --HeirloomsJournal.FilterDropdown.Text:SetText('过滤器')
    HeirloomsJournalSearchBox.Instructions:SetText('搜索')
    hooksecurefunc(HeirloomsJournal.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)

    hooksecurefunc(HeirloomsJournal, 'LayoutCurrentPage', function(self)
        for _, header in pairs(self.heirloomHeaderFrames or {}) do
            e.set(header.text)
        end
    end)

    --传家宝，名称
    hooksecurefunc(HeirloomsJournal, 'UpdateButton', function(_, btn)
        if not btn.name then
            return
        end
        local name= e.Get_Item_Name(btn.itemID) or e.strText[btn.name:GetText()]
        if name then
            name= name:match('|c........(.-)|r') or name
            btn.name:SetText(name)
        end
    end)
end












local function Init_Wardrobe()
    WardrobeCollectionFrameSearchBox.Instructions:SetText('搜索')
    --[[hooksecurefunc(WardrobeCollectionFrame, 'SetContainer', function(self, parent)
        if parent == CollectionsJournal then
            --self.FilterButton:SetText('过滤器')
        elseif parent == WardrobeFrame then
            self.FilterButton:SetText('来源')
        end
    end)]]
    --WardrobeCollectionFrame.FilterButton.Text:SetText('过滤器')
    WardrobeCollectionFrameTab1:SetText('物品')
        hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
            self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
        end)
    WardrobeCollectionFrameTab2:SetText('套装')
        hooksecurefunc(WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
            self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
        end)

    WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox.Label:SetText('两侧肩膀使用不同的幻化外观')



    --试衣间
    WardrobeFrameTitleText:SetText('幻化')
    --WardrobeOutfitDropDown.SaveButton:SetText('保存')
    --WardrobeTransmogFrame.ApplyButton:SetText('应用')
    WardrobeOutfitEditFrame.Title:SetText('输入外观方案名称：')
    WardrobeOutfitEditFrame.AcceptButton:SetText('接受')
    WardrobeOutfitEditFrame.CancelButton:SetText('取消')
    WardrobeOutfitEditFrame.DeleteButton:SetText('删除外观方案')
    WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:HookScript('OnEnter', function()
        GameTooltip:SetText('取消所有的待定改动')
    end)


    hooksecurefunc(WardrobeSetsScrollFrameButtonMixin, 'Init', function(btn, data)
        e.set(btn.Name)
    end)

    e.hookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Name)
    e.hookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Label)
    e.set(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.LimitedSet.Text)
end

















--Blizzard_FrameXML/SharedPetBattleTemplates.lua
--战斗宠物，技能 SharedPetBattleTemplates.lua
hooksecurefunc('SharedPetBattleAbilityTooltip_SetAbility', function(self, abilityInfo, additionalText)
    local abilityID = abilityInfo:GetAbilityID()
    local info = abilityID and e.Get_Pet_Ablity_Info(abilityID)
    if info then
        --local _, name, icon, _, unparsedDescription, _, petType = C_PetBattles.GetAbilityInfoByID(abilityID)
        local description = info[2] and SharedPetAbilityTooltip_ParseText(abilityInfo, info[2])
        if description then
            self.Description:SetText(description)
        end        
        if info[1] then
            self.Name:SetText(info[1])
        end
    end
end)









local function Init()
    e.hookLabel(CollectionsJournalTitleText)
    Init_Mount()
    Init_Pet()
    Init_Toy()
    Init_Heirlooms()
    Init_Wardrobe()

    hooksecurefunc('CollectionsJournal_UpdateSelectedTab', function(self)--设置，标题
        e.set(self.Text)
    end)

    CollectionsJournalTab1:SetText('坐骑')
    CollectionsJournalTab2:SetText('宠物手册')
    CollectionsJournalTab3:SetText('玩具箱')
    CollectionsJournalTab4:SetText('传家宝')
    CollectionsJournalTab5:SetText('外观')
end











--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_Collections') then
            self:UnregisterEvent('ADDON_LOADED')
            Init()
        end

    elseif arg1=='Blizzard_Collections' then
        self:UnregisterEvent('ADDON_LOADED')
        Init()
    end
end)