





















function WoWTools_ChineseMixin.Events:Blizzard_Collections()
    self:HookLabel(CollectionsJournalTitleText)

    hooksecurefunc('CollectionsJournal_UpdateSelectedTab', function(frame)--设置，标题
        self:SetLabel(frame.Text)
    end)

    CollectionsJournalTab1:SetText('坐骑')
    CollectionsJournalTab2:SetText('宠物手册')
    CollectionsJournalTab3:SetText('玩具箱')
    CollectionsJournalTab4:SetText('传家宝')
    CollectionsJournalTab5:SetText('外观')
    CollectionsJournalTab6:SetText('营地')











--坐骑
    if MountJournal.SummonRandomFavoriteSpellFrame then--11.1.7才有
        self:SetLabel(MountJournal.SummonRandomFavoriteSpellFrame.Label)--随机召唤\n偏好坐骑
    else
        MountJournalSummonRandomFavoriteButton.spellname:SetText('随机召唤\n偏好坐骑')
    end
--列表，名称
    hooksecurefunc('MountJournal_InitMountButton', function(btn, data)
        local name=  C_MountJournal.GetDisplayedMountInfo(data.index)
        local cn= self:CN(name)
        if cn and not btn.cnName then
            btn.cnName= self:Cstr(btn, {layer='ARTWORK'})
            btn.cnName:SetPoint('BOTTOMLEFT', 5, 2)
            btn.name:SetPoint('RIGHT')
        end
        if btn.cnName then
            btn.cnName:SetText(cn or '')
        end
    end)

    self:AddDialogs("DIALOG_REPLACE_MOUNT_EQUIPMENT", {text = '你确定要替换此坐骑装备吗？已有的坐骑装备将被摧毁。', button1 = '是', button2 = '否'})

    MountJournalSearchBox.Instructions:SetText('搜索')
    MountJournal.MountCount.Label:SetText('坐骑')

    MountJournal.MountDisplay.ModelScene.TogglePlayer.TogglePlayerText:SetText('显示角色')
    hooksecurefunc('MountJournal_OnLoad', function(frame)
        frame.SlotRequirementLabel:SetFormattedText('坐骑装备在%s级解锁', C_MountJournal.GetMountEquipmentUnlockLevel())
    end)
    hooksecurefunc('MountJournal_InitializeEquipmentSlot', function(frame, item)
        if item then
            local itemName= self:GetItemName(item.itemID)
            if itemName then
                frame.SlotLabel:SetText(itemName)
            end
        else
            frame.SlotLabel:SetText('使用坐骑装备来强化你的坐骑。')
        end
    end)
    hooksecurefunc('MountJournal_UpdateMountDisplay', function(forceSceneChange)
        if not MountJournal.selectedMountID then
            return
        end
        self:SetLabel(MountJournal.MountDisplay.InfoButton.Name)
        self:SetLabel(MountJournal.MountDisplay.InfoButton.Source)
        self:SetLabel(MountJournal.MountDisplay.InfoButton.Lore)
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

    self:SetRegions(MountJournal.ToggleDynamicFlightFlyoutButton)














--宠物
self:AddDialogs("BATTLE_PET_RENAME", {text = '重命名', button1 = '接受', button2 = '取消', button3 = '默认'})
    self:AddDialogs("BATTLE_PET_PUT_IN_CAGE", {text = '把这只宠物放入笼中？', button1 = '确定', button2 = '取消'})
    self:AddDialogs("BATTLE_PET_RELEASE", {text = "\n\n你确定要释放|cffffd200%s|r吗？\n\n", button1 = '确定', button2 = '取消'})

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

    if PetJournal.SummonRandomPetSpellFrame then--11.1.7才有
        PetJournal.SummonRandomPetSpellFrame.Label:SetText('召唤随机\n偏好战斗宠物')
        PetJournal.HealPetSpellFrame.Label:SetText('复活\n战斗宠物')
    else
        PetJournalSummonRandomFavoritePetButtonSpellName:SetText('召唤随机\n偏好战斗宠物')
        PetJournalHealPetButtonSpellName:SetText('复活\n战斗宠物')
    end
--列表，名称
    hooksecurefunc('PetJournal_InitPetButton', function(pet)
        if not pet:IsVisible() then
            return
        end
        local companionID= select(11, C_PetJournal.GetPetInfoByIndex(pet.index))
        local npcName= self:GetUnitName(nil, companionID)
        if npcName and not pet.cnName then
            pet.cnName= self:Cstr(pet, {layer='ARTWORK'})
            pet.cnName:SetPoint('BOTTOMLEFT', pet.icon, 'BOTTOMRIGHT', 10, 1)
            pet.subName:SetPoint('TOPLEFT', pet.name, 'BOTTOMLEFT', 0, 0)
        end
        if pet.cnName then
            pet.cnName:SetText(npcName or '')
        end
    end)

    self:SetLabel(PetJournalPetCard.CannotBattleText)--该生物无法对战。

--PetCard
    hooksecurefunc('PetJournal_UpdatePetCard', function(frame)
        if (not PetJournalPetCard.petID and not PetJournalPetCard.speciesID) then
            frame.PetInfo.name:SetText('从左侧的列表中选择一个宠物')
            return
        end

        local speciesID, petType, canBattle, _, t

        if PetJournalPetCard.petID then
            speciesID, _, _, _, _, _, _, _, _, petType, _, _, _, _, canBattle= C_PetJournal.GetPetInfoByPetID(PetJournalPetCard.petID)
            if ( not speciesID ) then
                return
            end
            if ( canBattle ) then
                local rarity = select(5, C_PetJournal.GetPetStats(PetJournalPetCard.petID))
--品质
                t= self:CN(_G["BATTLE_PET_BREED_QUALITY"..rarity])
                if t then
                    frame.QualityFrame.quality:SetText(t)
                end
            end
        else
            speciesID = PetJournalPetCard.speciesID
            _, _, petType, _, _, _, _, canBattle= C_PetJournal.GetPetInfoBySpeciesID(PetJournalPetCard.speciesID)

        end
--类型
        t= self:CN(_G["BATTLE_PET_NAME_"..petType])
        if t then
            frame.TypeInfo.type:SetText(t)
        end
--名称
        if not frame.PetInfo.cnName then
            frame.PetInfo.cnName= self:Cstr(frame.PetInfo)
            frame.PetInfo.cnName:SetPoint('TOPLEFT', frame.PetInfo.subName, 'BOTTOMLEFT', 0, -3)
        end
        local companionID= select(4, C_PetJournal.GetPetInfoBySpeciesID(speciesID))
        local cnName= self:GetUnitName(nil, companionID)
        frame.PetInfo.cnName:SetText(cnName or '')
        if cnName and cnName~='' then
            frame.PetInfo.speciesName= cnName
        end

        local data= self:GetPetDesc(speciesID)
        if data then
            local desc= data[1]
            local source= data[2]
            if desc and not desc~='' then
                frame.PetInfo.description=desc
            end
            if source and source~='' then
                frame.PetInfo.sourceText= source
            end
        end
    end)


--PetCard 1，2，3 宠物
    hooksecurefunc('PetJournal_UpdatePetLoadOut', function()
        for i=1, 3 do--MAX_ACTIVE_PETS
            local loadoutPlate = PetJournal.Loadout["Pet"..i]
            if loadoutPlate.emptyslot:IsShown() then
                loadoutPlate.emptyslot.slot:SetFormattedText('战斗宠物栏位%d', i)
            elseif loadoutPlate.name:IsShown() then

                local petID =C_PetJournal.GetPetLoadOutInfo(i)
                local speciesID= petID and C_PetJournal.GetPetInfoByPetID(petID)
                local companionID= speciesID and select(4, C_PetJournal.GetPetInfoBySpeciesID(speciesID))

                local cnName= self:GetUnitName(nil, companionID)
                if cnName and not loadoutPlate.cnName then
                    loadoutPlate.cnName= self:Cstr(loadoutPlate)
                    loadoutPlate.cnName:SetPoint('TOPLEFT', loadoutPlate.icon, 'TOPRIGHT', 10,4)
                end
                if loadoutPlate.cnName then
                    loadoutPlate.cnName:SetText(cnName or '')
                end
            end
        end
    end)
    self:SetLabel(PetJournalLoadoutBorderSlotHeaderText)
    self:SetLabel(PetJournalLoadoutPet1EmptySlotDragHere)
    self:SetLabel(PetJournalLoadoutPet2EmptySlotDragHere)
    self:SetLabel(PetJournalLoadoutPet3EmptySlotDragHere)













--玩具
    hooksecurefunc(ToyBox.PagingFrame, 'Update', function(frame)--Blizzard_CollectionTemplates.lua
        frame.PageText:SetFormattedText('%d/%d页', frame.currentPage, frame.maxPages)
    end)

    if not _G['OnToyBoxButtonUpdate'] then
        for i = 1, 18 do--TOYS_PER_PAGE
            local button = ToyBox.iconsFrame["spellButton"..i]
            if button and button.name then
                hooksecurefunc(button.name, 'SetText', function(frame, text)
                    if not frame:IsVisible() then
                        return
                    end
                    local name = self:CN(text) or  self:GetItemName(frame:GetParent().itemID)
                    if name then
                        name= name:match('|c........(.-)|r') or name
                        if name ~=text then
                            frame:SetText(name)
                        end
                    end
                end)
            end
        end
    end













--传家宝
    HeirloomsJournalSearchBox.Instructions:SetText('搜索')
    hooksecurefunc(HeirloomsJournal.PagingFrame, 'Update', function(frame)--Blizzard_CollectionTemplates.lua
        frame.PageText:SetFormattedText('%d/%d页', frame.currentPage, frame.maxPages)
    end)

    hooksecurefunc(HeirloomsJournal, 'LayoutCurrentPage', function(frame)
        for _, header in pairs(frame.heirloomHeaderFrames or {}) do
            self:SetLabel(header.text)
        end
    end)

--传家宝，名称
    hooksecurefunc(HeirloomsJournal, 'UpdateButton', function(_, btn)
        if not btn.name then
            return
        end
        local name= self:GetItemName(btn.itemID) or self:CN(btn.name:GetText())
        if name then
            name= name:match('|c........(.-)|r') or name
            btn.name:SetText(name)
        end
    end)












--幻化
    self:SetLabel(WardrobeTransmogFrame.OutfitDropdown.SaveButton)
    WardrobeCollectionFrameSearchBox.Instructions:SetText('搜索')
    WardrobeCollectionFrameTab1:SetText('物品')
    hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame, 'Update', function(frame)--Blizzard_CollectionTemplates.lua
        frame.PageText:SetFormattedText('%d/%d页', frame.currentPage, frame.maxPages)
    end)
    WardrobeCollectionFrameTab2:SetText('套装')
    hooksecurefunc(WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame, 'Update', function(frame)--Blizzard_CollectionTemplates.lua
        frame.PageText:SetFormattedText('%d/%d页', frame.currentPage, frame.maxPages)
    end)

    WardrobeTransmogFrame.ToggleSecondaryAppearanceCheckbox.Label:SetText('两侧肩膀使用不同的幻化外观')


    WardrobeFrameTitleText:SetText('幻化')
    --WardrobeOutfitDropDown.SaveButton:SetText('保存')
    WardrobeTransmogFrame.ApplyButton:SetText('应用')
    WardrobeOutfitEditFrame.Title:SetText('输入外观方案名称：')
    WardrobeOutfitEditFrame.AcceptButton:SetText('接受')
    WardrobeOutfitEditFrame.CancelButton:SetText('取消')
    WardrobeOutfitEditFrame.DeleteButton:SetText('删除外观方案')
    WardrobeTransmogFrame.ModelScene.ClearAllPendingButton:HookScript('OnEnter', function()
        GameTooltip:SetText('取消所有的待定改动')
    end)

    hooksecurefunc(WardrobeSetsScrollFrameButtonMixin, 'Init', function(btn, data)
        self:SetLabel(btn.Name)
    end)

    self:HookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Name)
    self:HookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Label)
    self:SetLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.LimitedSet.Text)












--试衣间
    DressUpFrameTitleText:SetText('试衣间')
    DressUpFrame.LinkButton:SetText('外观方案链接')
    DressUpFrameResetButton:SetText('重置')
    DressUpFrameCancelButton:SetText('关闭')
    DressUpFrame.ToggleOutfitDetailsButton:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '外观列表')
        GameTooltip:Show()
    end)
    self:SetLabel(DressUpFrameOutfitDropdown.SaveButton)

--试衣间，套装
    WarbandSceneJournal.IconsFrame.Icons.Controls.ShowOwned.Text:SetText('只显示已获得的')
    hooksecurefunc(WarbandSceneEntryMixin, 'UpdateWarbandSceneData', function(frame)
        if frame.warbandSceneInfo then
            local name= self:CN(frame.warbandSceneInfo.name)
            if name then
                frame.Name:SetText(name)
            end
        end
    end)
end

































--local TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN_CHECKMARK = "|A:common-icon-checkmark:16:16:0:-1|a 你已经收藏过此外观了"
--试衣间
hooksecurefunc(DressUpOutfitDetailsSlotMixin, 'OnEnter', function(self)--DressUpFrames.lua
    if not self.transmogID or (self.item and not self.item:IsItemDataCached()) then
        return
    end
    local name= WoWTools_ChineseMixin:CN(self.name) or ' '
    if self.isHiddenVisual then
        GameTooltip_AddColoredLine(GameTooltip, name, NORMAL_FONT_COLOR)
    elseif not self.item then
        -- illusion
        GameTooltip_AddColoredLine(GameTooltip,name, NORMAL_FONT_COLOR)
        if self.slotState == 3 then
            GameTooltip_AddColoredLine(GameTooltip, '你尚未收藏过此外观', LIGHTBLUE_FONT_COLOR)
        else
            GameTooltip_AddColoredLine(GameTooltip, "|cnGREEN_FONT_COLOR:|A:common-icon-checkmark:16:16:0:-1|a 你已经收藏过此外观了", GREEN_FONT_COLOR)
        end
    elseif self.slotState == 1 then
        local hasData, canCollect = C_TransmogCollection.AccountCanCollectSource(self.transmogID)
        if not canCollect and (self.slotID == INVSLOT_MAINHAND or self.slotID == INVSLOT_OFFHAND) then
            local pairedTransmogID = C_TransmogCollection.GetPairedArtifactAppearance(self.transmogID)
            if pairedTransmogID then
                hasData, canCollect = C_TransmogCollection.AccountCanCollectSource(pairedTransmogID)
                if not hasData then
                    return
                end
            end
        end
        if canCollect then
            local nameColor = self.item:GetItemQualityColor().color
            GameTooltip_AddColoredLine(GameTooltip,name, nameColor)
            local slotName = _G[TransmogUtil.GetSlotName(self.slotID)]
            GameTooltip_AddColoredLine(GameTooltip, WoWTools_ChineseMixin:CN(slotName) or slotName, HIGHLIGHT_FONT_COLOR)
            GameTooltip_AddErrorLine(GameTooltip, '你的角色无法使用此外观。')
        else
            local hideVendorPrice = true
            GameTooltip:SetHyperlink(self.item:GetItemLink(), nil, nil, hideVendorPrice)
            GameTooltip_AddErrorLine(GameTooltip, '该物品无法在幻化时使用，但可以视为装备穿戴。')
        end
    elseif self.slotState == 3 then
        if not C_TransmogCollection.PlayerKnowsSource(self.transmogID) then
            local nameColor = self.item:GetItemQualityColor().color
            GameTooltip_AddColoredLine(GameTooltip, name, nameColor)
            local slotName = _G[TransmogUtil.GetSlotName(self.slotID)]
            GameTooltip_AddColoredLine(GameTooltip, WoWTools_ChineseMixin:CN(slotName) or slotName, HIGHLIGHT_FONT_COLOR)
            GameTooltip_AddColoredLine(GameTooltip, '|cnRED_FONT_COLOR:你尚未收藏过此外观', LIGHTBLUE_FONT_COLOR)
        end
    else
        local nameColor = self.item:GetItemQualityColor().color
        GameTooltip_AddColoredLine(GameTooltip, name, nameColor)
        local slotName = _G[TransmogUtil.GetSlotName(self.slotID)]
        GameTooltip_AddColoredLine(GameTooltip, WoWTools_ChineseMixin:CN(slotName) or slotName, HIGHLIGHT_FONT_COLOR)
        GameTooltip_AddColoredLine(GameTooltip, '|cnGREEN_FONT_COLOR:|A:common-icon-checkmark:16:16:0:-1|a 你已经收藏过此外观了', GREEN_FONT_COLOR)
    end
    GameTooltip:Show()
end)

hooksecurefunc(DressUpOutfitDetailsSlotMixin, 'SetAppearance', function(self, slotID, transmogID, isSecondary)
    local itemID = C_TransmogCollection.GetSourceItemID(transmogID)
    if not itemID and not isSecondary then
        local name= _G[TransmogUtil.GetSlotName(slotID)]
        local slotName = WoWTools_ChineseMixin:CN(name)
        if slotName then
            self.Name:SetFormattedText('(%s)', slotName)
        end
    end
end)
hooksecurefunc(DressUpOutfitDetailsSlotMixin, 'RefreshAppearanceTooltip', function(self)
    GameTooltip_AddColoredLine(GameTooltip, '|cnRED_FONT_COLOR:你尚未收藏过此外观', LIGHTBLUE_FONT_COLOR)
    GameTooltip:Show()
end)