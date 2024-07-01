
local id, e = ...






local function Init()
    --列表，名称
    hooksecurefunc('MountJournal_InitMountButton', function(btn)
        btn.DragonRidingLabel:SetText("驭空术")
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