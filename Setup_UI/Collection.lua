











local function Init_Mount()
    --列表，名称
    hooksecurefunc('MountJournal_InitMountButton', function(btn, data)
        local name=  C_MountJournal.GetDisplayedMountInfo(data.index)
        local cn= WoWTools_ChineseMixin:CN(name)
        if cn and not btn.cnName then
            btn.cnName= WoWTools_ChineseMixin:Cstr(btn, {layer='ARTWORK'})
            btn.cnName:SetPoint('BOTTOMLEFT', 5, 2)
            btn.name:SetPoint('RIGHT')
        end
        if btn.cnName then
            btn.cnName:SetText(cn or '')
        end
    end)

        --btn.DragonRidingLabel:SetText("驭空术")
        --WoWTools_ChineseMixin:SetLabel(btn.name)

    WoWTools_ChineseMixin:AddDialogs("DIALOG_REPLACE_MOUNT_EQUIPMENT", {text = '你确定要替换此坐骑装备吗？已有的坐骑装备将被摧毁。', button1 = '是', button2 = '否'})

    MountJournalSearchBox.Instructions:SetText('搜索')
    MountJournal.MountCount.Label:SetText('坐骑')
    if MountJournalSummonRandomFavoriteButton then--11.1.7没了
        MountJournalSummonRandomFavoriteButton.spellname:SetText('随机召唤\n偏好坐骑')--hooksecurefunc('MountJournalSummonRandomFavoriteButton_OnLoad', function(self)
    end
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
        WoWTools_ChineseMixin:SetLabel(MountJournal.MountDisplay.InfoButton.Name)
        WoWTools_ChineseMixin:SetLabel(MountJournal.MountDisplay.InfoButton.Source)
        WoWTools_ChineseMixin:SetLabel(MountJournal.MountDisplay.InfoButton.Lore)
            --[[local creatureName, spellID= C_MountJournal.GetMountInfoByID(MountJournal.selectedMountID)
            if ( MountJournal.MountDisplay.lastDisplayed ~= spellID or forceSceneChange ) then
                local _, descriptionText, sourceText = C_MountJournal.GetMountInfoExtraByID(MountJournal.selectedMountID)
                WoWTools_ChineseMixin:SetLabel(MountJournal.MountDisplay.InfoButton.Name, creatureName)
                WoWTools_ChineseMixin:SetLabel(MountJournal.MountDisplay.InfoButton.Source, sourceText)
                WoWTools_ChineseMixin:SetLabel(MountJournal.MountDisplay.InfoButton.Lore, descriptionText)
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

    --WoWTools_ChineseMixin:SetLabel(MountJournal.FilterDropdown.Text)
    WoWTools_ChineseMixin:SetRegions(MountJournal.ToggleDynamicFlightFlyoutButton)
end


















local function Init_Pet()
    WoWTools_ChineseMixin:AddDialogs("BATTLE_PET_RENAME", {text = '重命名', button1 = '接受', button2 = '取消', button3 = '默认'})
    WoWTools_ChineseMixin:AddDialogs("BATTLE_PET_PUT_IN_CAGE", {text = '把这只宠物放入笼中？', button1 = '确定', button2 = '取消'})
    WoWTools_ChineseMixin:AddDialogs("BATTLE_PET_RELEASE", {text = "\n\n你确定要释放|cffffd200%s|r吗？\n\n", button1 = '确定', button2 = '取消'})

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
    


--[[
    列表，名称
    pet.petID = petID
    pet.speciesID = speciesID
    pet.index = index
    pet.owned = isOwned
]]


--CompanionListButtonTemplate
--列表，名称
    hooksecurefunc('PetJournal_InitPetButton', function(pet)
        if not pet:IsVisible() then
            return
        end
        local companionID= select(11, C_PetJournal.GetPetInfoByIndex(pet.index))
        local npcName= WoWTools_ChineseMixin:GetUnitName(nil, companionID)
        if npcName and not pet.cnName then
            pet.cnName= WoWTools_ChineseMixin:Cstr(pet, {layer='ARTWORK'})
            pet.cnName:SetPoint('BOTTOMLEFT', pet.icon, 'BOTTOMRIGHT', 10, 1)
            pet.subName:SetPoint('TOPLEFT', pet.name, 'BOTTOMLEFT', 0, 0)
        end
        if pet.cnName then
            pet.cnName:SetText(npcName or '')
        end
    end)


    WoWTools_ChineseMixin:SetLabel(PetJournalPetCard.CannotBattleText)--该生物无法对战。

--PetCard
    hooksecurefunc('PetJournal_UpdatePetCard', function(self)
        if (not PetJournalPetCard.petID and not PetJournalPetCard.speciesID) then
            self.PetInfo.name:SetText('从左侧的列表中选择一个宠物')
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
                t= WoWTools_ChineseMixin:CN(_G["BATTLE_PET_BREED_QUALITY"..rarity])
                if t then
                    self.QualityFrame.quality:SetText(t)
                end
            end
        else
            speciesID = PetJournalPetCard.speciesID
            _, _, petType, _, _, _, _, canBattle= C_PetJournal.GetPetInfoBySpeciesID(PetJournalPetCard.speciesID)

        end
--类型
        t= WoWTools_ChineseMixin:CN(_G["BATTLE_PET_NAME_"..petType])
        if t then
            self.TypeInfo.type:SetText(t)
        end
--名称
        if not self.PetInfo.cnName then
            self.PetInfo.cnName= WoWTools_ChineseMixin:Cstr(self.PetInfo)
            self.PetInfo.cnName:SetPoint('TOPLEFT', self.PetInfo.subName, 'BOTTOMLEFT', 0, -3)
        end
        local companionID= select(4, C_PetJournal.GetPetInfoBySpeciesID(speciesID))
        local cnName= WoWTools_ChineseMixin:GetUnitName(nil, companionID)
        self.PetInfo.cnName:SetText(cnName or '')
        if cnName and cnName~='' then
            self.PetInfo.speciesName= cnName
        end


        local data= WoWTools_ChineseMixin:GetPetDesc(speciesID)
        if data then
            local desc= data[1]
            local source= data[2]
            if desc and not desc~='' then
                self.PetInfo.description=desc
            end
            if source and source~='' then
                self.PetInfo.sourceText= source
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

                local cnName= WoWTools_ChineseMixin:GetUnitName(nil, companionID)
                if cnName and not loadoutPlate.cnName then
                    loadoutPlate.cnName= WoWTools_ChineseMixin:Cstr(loadoutPlate)
                    loadoutPlate.cnName:SetPoint('TOPLEFT', loadoutPlate.icon, 'TOPRIGHT', 10,4)
                end
                if loadoutPlate.cnName then
                    loadoutPlate.cnName:SetText(cnName or '')
                end
            end
        end
    end)

    WoWTools_ChineseMixin:SetLabel(PetJournalLoadoutPet1EmptySlotDragHere)
    WoWTools_ChineseMixin:SetLabel(PetJournalLoadoutPet2EmptySlotDragHere)
    WoWTools_ChineseMixin:SetLabel(PetJournalLoadoutPet3EmptySlotDragHere)
end











--WowStyle1FilterDropdownMixin.SetButton


local function Init_Toy()
    --ToyBox.searchBox.Instructions:SetText('搜索')
    --WoWTools_ChineseMixin:SetLabel(ToyBox.FilterDropdown.Text)
    hooksecurefunc(ToyBox.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)

    if not _G['OnToyBoxButtonUpdate'] then
        for i = 1, 18 do--TOYS_PER_PAGE
            local button = ToyBox.iconsFrame["spellButton"..i]
            if button and button.name then
                hooksecurefunc(button.name, 'SetText', function(self, text)
                    if not self:IsVisible() then
                        return
                    end
                    local name = WoWTools_ChineseMixin:CN(text) or  WoWTools_ChineseMixin:GetItemName(self:GetParent().itemID)
                    if name then
                        name= name:match('|c........(.-)|r') or name
                        if name ~=text then
                            self:SetText(name)
                        end
                    end
                end)
            end
        end
    end

    --[[if not _G['OnToyBoxButtonUpdate'] then
        local function set_toy_name(self)
            local name = WoWTools_ChineseMixin:GetItemName(self.itemID) or WoWTools_ChineseMixin:CN(self.name:GetText())
            if name then
                name= name:match('|c........(.-)|r') or name
                self.name:SetText(name)
            end
        end
        hooksecurefunc('ToySpellButton_UpdateButton', set_toy_name)

        hooksecurefunc('ToyBox_UpdateButtons', function()
            for i = 1, 18 do--TOYS_PER_PAGE
                local button = ToyBox.iconsFrame["spellButton"..i]
                if button then
                    set_toy_name(button)
                end
            end
        end)
    end]]
end






















local function Init_Heirlooms()
    --HeirloomsJournal.FilterDropdown.Text:SetText('过滤器')
    HeirloomsJournalSearchBox.Instructions:SetText('搜索')
    hooksecurefunc(HeirloomsJournal.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)

    hooksecurefunc(HeirloomsJournal, 'LayoutCurrentPage', function(self)
        for _, header in pairs(self.heirloomHeaderFrames or {}) do
            WoWTools_ChineseMixin:SetLabel(header.text)
        end
    end)

    --传家宝，名称
    hooksecurefunc(HeirloomsJournal, 'UpdateButton', function(_, btn)
        if not btn.name then
            return
        end
        local name= WoWTools_ChineseMixin:GetItemName(btn.itemID) or WoWTools_ChineseMixin:CN(btn.name:GetText())
        if name then
            name= name:match('|c........(.-)|r') or name
            btn.name:SetText(name)
        end
    end)
end












--幻化
local function Init_Wardrobe()
    WoWTools_ChineseMixin:SetLabel(WardrobeTransmogFrame.OutfitDropdown.SaveButton)
    WardrobeCollectionFrameSearchBox.Instructions:SetText('搜索')
    WardrobeCollectionFrameTab1:SetText('物品')
    hooksecurefunc(WardrobeCollectionFrame.ItemsCollectionFrame.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
    end)
    WardrobeCollectionFrameTab2:SetText('套装')
    hooksecurefunc(WardrobeCollectionFrame.SetsTransmogFrame.PagingFrame, 'Update', function(self)--Blizzard_CollectionTemplates.lua
        self.PageText:SetFormattedText('%d/%d页', self.currentPage, self.maxPages)
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
        WoWTools_ChineseMixin:SetLabel(btn.Name)
    end)

    WoWTools_ChineseMixin:HookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Name)
    WoWTools_ChineseMixin:HookLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.Label)
    WoWTools_ChineseMixin:SetLabel(WardrobeCollectionFrame.SetsCollectionFrame.DetailsFrame.LimitedSet.Text)
end




















--local TRANSMOGRIFY_TOOLTIP_APPEARANCE_KNOWN_CHECKMARK = "|A:common-icon-checkmark:16:16:0:-1|a 你已经收藏过此外观了"
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











--试衣间
local function Init_DressUpFrame()
    DressUpFrameTitleText:SetText('试衣间')
    DressUpFrame.LinkButton:SetText('外观方案链接')
    DressUpFrameResetButton:SetText('重置')
    DressUpFrameCancelButton:SetText('关闭')
    DressUpFrame.ToggleOutfitDetailsButton:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '外观列表')
        GameTooltip:Show()
    end)
    WoWTools_ChineseMixin:SetLabel(DressUpFrameOutfitDropdown.SaveButton)
end









local function Init_WarbandSceneJournal()

    WarbandSceneJournal.IconsFrame.Icons.Controls.ShowOwned.Text:SetText('只显示已获得的')

    hooksecurefunc(WarbandSceneEntryMixin, 'UpdateWarbandSceneData', function(self)
        if not self.elementData then
            return
        end
        --self.warbandSceneInfo = C_WarbandScene.GetWarbandSceneEntry(self.elementData.warbandSceneID)
        if self.warbandSceneInfo then
            local name= WoWTools_ChineseMixin:CN(self.warbandSceneInfo.name)
            if name then
                self.Name:SetText(name)
            end
            --self.Icon:SetAtlas(self.warbandSceneInfo.textureKit, TextureKitConstants.UseAtlasSize)
        end
    end)
    --WoWTools_ChineseMixin:SetLabel(WarbandSceneJournal.IconsFrame.Icons.Controls.ShowOwned.Text)
end









function WoWTools_ChineseMixin.Events:Blizzard_Collections()
    WoWTools_ChineseMixin:HookLabel(CollectionsJournalTitleText)
    Init_Mount()
    Init_Pet()
    Init_Toy()
    Init_Heirlooms()
    Init_Wardrobe()
    Init_DressUpFrame()
    Init_WarbandSceneJournal()
    hooksecurefunc('CollectionsJournal_UpdateSelectedTab', function(frame)--设置，标题
        WoWTools_ChineseMixin:SetLabel(frame.Text)
    end)

    CollectionsJournalTab1:SetText('坐骑')
    CollectionsJournalTab2:SetText('宠物手册')
    CollectionsJournalTab3:SetText('玩具箱')
    CollectionsJournalTab4:SetText('传家宝')
    CollectionsJournalTab5:SetText('外观')
    if CollectionsJournalTab6 then--11.1
        CollectionsJournalTab6:SetText('营地')
    end
end