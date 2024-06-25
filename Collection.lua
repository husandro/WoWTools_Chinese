local id, e= ...















--坐骑
local function Init_Mount()
    e.dia("DIALOG_REPLACE_MOUNT_EQUIPMENT", {text = '你确定要替换此坐骑装备吗？已有的坐骑装备将被摧毁。', button1 = '是', button2 = '否'})

    MountJournalSearchBox.Instructions:SetText('搜索')
    MountJournal.FilterDropdown.Text:SetText('过滤器')
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
        if ( MountJournal.selectedMountID ) then
            local creatureName, spellID= C_MountJournal.GetMountInfoByID(MountJournal.selectedMountID)
            if ( MountJournal.MountDisplay.lastDisplayed ~= spellID or forceSceneChange ) then
                local _, descriptionText, sourceText = C_MountJournal.GetMountInfoExtraByID(MountJournal.selectedMountID)
                e.set(MountJournal.MountDisplay.InfoButton.Name, creatureName)
                e.set(MountJournal.MountDisplay.InfoButton.Source, sourceText)
                e.set(MountJournal.MountDisplay.InfoButton.Lore, descriptionText)
            end
            if C_MountJournal.NeedsFanfare(MountJournal.selectedMountID) then
                MountJournal.MountButton:SetText('打开')
            elseif select(4, C_MountJournal.GetMountInfoByID(MountJournal.selectedMountID)) then
                MountJournal.MountButton:SetText('解散坐骑')
            else
                MountJournal.MountButton:SetText('召唤坐骑')
            end
        end
    end)
    MountJournalMountButton:HookScript('OnEnter', function()
        local needsFanFare = MountJournal.selectedMountID and C_MountJournal.NeedsFanfare(MountJournal.selectedMountID)
        if needsFanFare then
            GameTooltip_AddNormalLine(GameTooltip, '打开即可获得你的崭新坐骑。', true)
        else
            GameTooltip_AddNormalLine(GameTooltip, '召唤或解散你选定的坐骑。', true)
        end
        GameTooltip:Show()
    end)
    hooksecurefunc('MountJournal_InitMountButton', function(button, elementData)
        local creatureName= C_MountJournal.GetDisplayedMountInfo(elementData.index)
        e.set(button.name, creatureName)
        if button.DragonRidingLabel:IsShown() then
            button.DragonRidingLabel:SetText('驭空术')
        end
    end)
end







local function Init_Pet()
    e.dia("BATTLE_PET_RENAME", {text = '重命名', button1 = '接受', button2 = '取消', button3 = '默认'})
    e.dia("BATTLE_PET_PUT_IN_CAGE", {text = '把这只宠物放入笼中？', button1 = '确定', button2 = '取消'})
    e.dia("BATTLE_PET_RELEASE", {text = "\n\n你确定要释放|cffffd200%s|r吗？\n\n", button1 = '确定', button2 = '取消'})

    PetJournalSearchBox.Instructions:SetText('搜索')
    PetJournal.FilterDropdown.Text:SetText('过滤器')
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

end








local function Init_Toy()
    
    --ToyBox.searchBox.Instructions:SetText('搜索')
    e.set(ToyBox.FilterDropdown.Text)
    hooksecurefunc(ToyBox.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)
end






local function Init_Heirlooms()
    
    HeirloomsJournal.FilterDropdown.Text:SetText('过滤器')
    HeirloomsJournalSearchBox.Instructions:SetText('搜索')
    hooksecurefunc(HeirloomsJournal.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)
end



local function Init_Wardrobe()
    WardrobeCollectionFrameSearchBox.Instructions:SetText('搜索')
    hooksecurefunc(WardrobeCollectionFrame, 'SetContainer', function(self, parent)
        if parent == CollectionsJournal then
            self.FilterButton:SetText('过滤器')
        elseif parent == WardrobeFrame then
            self.FilterButton:SetText('来源')
        end
    end)
    WardrobeCollectionFrame.FilterButton.Text:SetText('过滤器')
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


    hooksecurefunc(WardrobeSetsScrollFrameButtonMixin, 'Init', function(btn)
        e.set(btn.Name)
    end)

    e.hookLable(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Name)
    e.hookLable(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Label)


end





local function Init()

    Init_Mount()
    Init_Pet()
    Init_Toy()
    Init_Heirlooms()
    Init_Wardrobe()
    
    CollectionsJournalTab1:SetText('坐骑')
    CollectionsJournalTab2:SetText('宠物手册')
    CollectionsJournalTab3:SetText('玩具箱')
    CollectionsJournalTab4:SetText('传家宝')
    CollectionsJournalTab5:SetText('外观')

    hooksecurefunc('CollectionsJournal_UpdateSelectedTab', function(self)--设置，标题
        e.set(self.Text)
        --[[local selected = CollectionsJournal_GetTab(self)
        if selected==1 then
            self:SetTitle('坐骑')
        elseif selected==2 then
            self:SetTitle('宠物手册')
        elseif selected==3 then
            self:SetTitle('玩具箱')
        elseif selected==4 then
            self:SetTitle('传家宝')
        elseif selected==5 then
            self:SetTitle('外观')
        end]]
    end)
    
    


    

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