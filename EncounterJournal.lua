local _, e = ...



local function Init_Boss()

    local t= EJ_GetTierInfo(2)
    if t then
        e.strText[t]='燃烧远征'
    end
    t= EJ_GetTierInfo(10)
    if t then
        e.strText[t]='本赛季'
    end

    e.set(EncounterJournalTitleText, '冒险指南')

    if EncounterJournalMonthlyActivitiesTab then
        e.set(EncounterJournalMonthlyActivitiesTab, '旅行者日志')
            EncounterJournalMonthlyActivitiesTab:SetScript('OnEnter', function()
                if not C_PlayerInfo.IsTravelersLogAvailable() then
                    local tradingPostLocation = UnitFactionGroup('player') == "Alliance" and '暴风城' or '奥格瑞玛'
                    GameTooltip_AddBlankLineToTooltip(GameTooltip)
                    GameTooltip_AddErrorLine(GameTooltip, format('拜访%s的商栈，查看旅行者日志。', tradingPostLocation))
                    if AreMonthlyActivitiesRestricted() then
                        GameTooltip_AddBlankLineToTooltip(GameTooltip)
                        GameTooltip_AddErrorLine(GameTooltip, '需要可用的游戏时间。')
                    end

                    GameTooltip:Show()
                end
            end)
        end

    e.set(EncounterJournalSuggestTab, '推荐玩法')
    e.set(EncounterJournalDungeonTab, '地下城')
    e.set(EncounterJournalRaidTab, '团队副本')
    e.set(EncounterJournalLootJournalTab, '套装物品')
    e.set(EncounterJournalSearchBox.Instructions, '搜索')

    hooksecurefunc('EJInstanceSelect_UpdateTitle', function(tabId)
        local text
        if ( tabId == EncounterJournal.suggestTab:GetID()) then
            text= '推荐玩法'
        elseif ( tabId == EncounterJournal.raidsTab:GetID()) then
            text= '团队副本'
        elseif ( tabId == EncounterJournal.dungeonsTab:GetID()) then
            text= '地下城'
        --elseif ( tabId == EncounterJournal.MonthlyActivitiesTab:GetID()) then
        elseif (tabId == EncounterJournal.LootJournalTab:GetID()) then
            text= '套装物品'
        end
        if text then
            e.set(EncounterJournal.instanceSelect.Title, text)
        end
    end)
    if EncounterJournalMonthlyActivitiesFrame and EncounterJournalMonthlyActivitiesFrame.HeaderContainer then
        e.set(EncounterJournalMonthlyActivitiesFrame.HeaderContainer.Title, '旅行者日志')
        e.set(EncounterJournalMonthlyActivitiesFrame.BarComplete.AllRewardsCollectedText, '你已经收集完了本月的所有奖励')
    end

    e.set(EncounterJournalEncounterFrameInfoFilterToggle.Text, '过滤器')
    e.set(EncounterJournalEncounterFrameInstanceFrameMapButtonText, '显示\n地图')
    e.set(EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle, '综述')

    local function EncounterJournal_SetupIconFlags(sectionID, infoHeaderButton, index)--Blizzard_EncounterJournal.lua
        local iconFlags = C_EncounterJournal.GetSectionIconFlags(sectionID)
        for index2, icon in ipairs(infoHeaderButton.icons or {}) do
            local iconFlag = iconFlags and iconFlags[index2]
            if iconFlag then
                local tab={
                    [0] = "坦克预警",
                    [1] = "伤害输出预警",
                    [10] = "疾病效果",
                    [11] = "激怒",
                    [12] = "史诗难度",
                    [13] = "流血",
                    [2] = "治疗预警",
                    [3] = "英雄难度",
                    [4] = "灭团技",
                    [5] = "重要",
                    [6] = "可打断技能",
                    [7] = "法术效果",
                    [8] = "诅咒效果",
                    [9] = "中毒效果",
                }
                if tab[iconFlag] then
                    icon.tooltipTitle = tab[iconFlag]--_G["ENCOUNTER_JOURNAL_SECTION_FLAG"..iconFlag]
                    if index then
                        if iconFlag==1 then
                            e.set(infoHeaderButton.title, '伤害')
                        elseif iconFlag==2 then
                            e.set(infoHeaderButton.title, '治疗者')
                        elseif iconFlag==0 then
                            e.set(infoHeaderButton.title, '坦克')
                        end
                    end
                end
            end
        end
    end
    hooksecurefunc('EncounterJournal_SetUpOverview', function(self, overviewSectionID, index)
        local infoHeader= self.overviews[index]
        --local sectionInfo = C_EncounterJournal.GetSectionInfo(overviewSectionID)
        if infoHeader and infoHeader.button and overviewSectionID then
            EncounterJournal_SetupIconFlags(overviewSectionID, infoHeader.button, index)
        end
    end)
    hooksecurefunc('EncounterJournal_ToggleHeaders', function()
        for _, infoHeader in pairs(EncounterJournal.encounter.usedHeaders or {}) do
            if infoHeader.myID and  infoHeader.button then
                EncounterJournal_SetupIconFlags(infoHeader.myID, infoHeader.button)
            end
        end
    end)




    hooksecurefunc(MonthlyActivitiesButtonTextContainerMixin, 'UpdateText', function(self, data)
        if data.name then
            local a,b= data.name:match('(.-): (.+)')
            a= e.strText[a] or a
            b= e.strText[b] or b
            if a and b then
                e.set(self.NameText, (e.strText[a] or a)..': '..(e.strText[b] or b))
            else
                e.set(self.NameText, e.strText[data.name])
            end
        end
    end)
    hooksecurefunc(EncounterJournalMonthlyActivitiesFrame.FilterList.ScrollBox, 'Update', function(self)
        if not self:GetView() then
            return
        end
        for _, btn in pairs(self:GetFrames() or {}) do
            e.set(btn.Label)
        end
    end)


    hooksecurefunc('EncounterJournal_ListInstances', function()
        local frame= EncounterJournal.instanceSelect.ScrollBox
        if not frame:GetView() then
            return
        end
        for _, button in pairs(frame:GetFrames()) do
            e.set(button.name)
            if button.tooltiptext and e.strText[button.tooltiptext] then
                button.tooltiptext= e.strText[button.tooltiptext]
            end
        end
    end)

    hooksecurefunc(EncounterJournalItemMixin,'Init', function(self)--Blizzard_EncounterJournal.lua
        local itemInfo = C_EncounterJournal.GetLootInfoByIndex(self.index)
        if ( itemInfo and itemInfo.name ) then
            local name= e.strText[itemInfo.name]
            if name then
                e.set(self.name, WrapTextInColorCode(name, itemInfo.itemQuality))
            end
            local slot= e.strText[itemInfo.slot]
            if slot then
                if itemInfo.handError then
                    e.set(self.slot, INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(slot))
                else
                    e.set(self.slot, slot)
                end
            end
            local armorType= e.strText[itemInfo.armorType]
            if armorType then
                if itemInfo.weaponTypeError then
                    e.set(self.armorType, INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(armorType))
                else
                    e.set(self.armorType, armorType)
                end
            end

            local numEncounters = EJ_GetNumEncountersForLootByIndex(self.index)
            if ( numEncounters == 1 ) then
                e.set(self.boss, format('首领：%s', EJ_GetEncounterInfo(itemInfo.encounterID)))
            elseif ( numEncounters == 2) then
                local itemInfoSecond = C_EncounterJournal.GetLootInfoByIndex(self.index, 2)
                local secondEncounterID = itemInfoSecond and itemInfoSecond.encounterID
                if ( itemInfo.encounterID and secondEncounterID ) then
                    e.set(self.boss:SetFormattedText('首领：%s，%s', e.cn(EJ_GetEncounterInfo(itemInfo.encounterID)), e.cn(EJ_GetEncounterInfo(secondEncounterID))))
                end
            elseif ( numEncounters > 2 ) then
                e.set(self.boss:SetFormattedText('首领：%s及其他', e.cn(EJ_GetEncounterInfo(itemInfo.encounterID))))
            end
        else
            self.name:SetText('正在获取物品信息')
        end
    end)

    hooksecurefunc(EncounterJournalItemHeaderMixin, 'Init', function(self, elementData)
        e.set(self.name, e.strText[elementData.text])
    end)

    hooksecurefunc(EncounterBossButtonMixin, 'Init', function(self, elementData)
        e.set(self, e.strText[elementData.name])
    end)

    hooksecurefunc('EncounterJournal_UpdateFilterString', function(self)
        local name
        local classID, specID = EJ_GetLootFilter()
        if (specID > 0) then
            local _
            _, name = GetSpecializationInfoByID(specID, UnitSex("player"))
        elseif (classID > 0) then
            local classInfo = C_CreatureInfo.GetClassInfo(classID)
            if classInfo then
                name = classInfo.className
            end
        end
        name= e.cn(name)
        if name then
            e.set(EncounterJournal.encounter.info.LootContainer.classClearFilter.text, format('职业筛选：%s', name))
        end
    end)


    if EncounterJournal.encounter.info then
        local btnTab={
            --"overviewTab",
            "lootTab",
            "bossTab",
            "modelTab"
        }
        for _, str in pairs (btnTab) do
            local button= EncounterJournal.encounter.info[str]
            if button then
                local tooltip= e.strText[button.tooltip]
                if tooltip then
                    button.tooltip= tooltip
                end
            end
        end
    end
    hooksecurefunc('EncounterJournal_DisplayInstance', function()
        local self= EncounterJournal.encounter
        local instanceName, description = EJ_GetInstanceInfo()
        e.set(self.instance.title, e.strText[instanceName])
        e.set(self.info.instanceTitle, e.strText[instanceName])
        e.set(self.instance.LoreScrollingFont, e.strText[description])
        local tooltip= e.strText[self.info['overviewTab'].tooltip]
        if tooltip then
            self.info['overviewTab'].tooltip= tooltip
        end
    end)

    e.hookButton(EncounterJournalEncounterFrameInfoSlotFilterToggle)
    e.hookButton(EncounterJournalEncounterFrameInfoDifficulty)



    hooksecurefunc('EncounterJournal_DisplayEncounter', function(journalEncounterID)--BOSS，详细，信息
        local f = EncounterJournal.encounter
        e.set(f.info.encounterTitle)

        local desc= e.Get_Boss_Description(journalEncounterID)
        if desc then
            local rootSectionID = select(4, EJ_GetEncounterInfo(journalEncounterID))
            if rootSectionID then
                local sectionInfo = C_EncounterJournal.GetSectionInfo(rootSectionID);
                if sectionInfo and sectionInfo.headerType==3 then
                    f.overviewFrame.loreDescription:SetText(desc)
                    if (f.overviewFrame.Bullets and #self.overviewFrame.Bullets > 0) then--更新，高度
                        local bulletHeight = 0;
                        for i = 1, #f.overviewFrame.Bullets do
                            bulletHeight = bulletHeight + f.overviewFrame.Bullets[i]:GetHeight();
                        end
                        f.overviewFrame.descriptionHeight = f.overviewFrame.loreDescription:GetHeight() + f.overviewFrame.overviewDescription:GetHeight() + bulletHeight + 42;
                    end
                end
            end

            f.infoFrame.description:SetText(desc)
            f.infoFrame.descriptionHeight = f.infoFrame.description:GetHeight()
        end
    end)
end


























local function Init_EncounterJournal()
    e.font(EncounterJournalNavBarHomeButtonText)

    EncounterJournalTitleText:SetText('冒险指南')

    if EncounterJournalMonthlyActivitiesTab then
        EncounterJournalMonthlyActivitiesTab:SetText('旅行者日志')
        EncounterJournalMonthlyActivitiesTab:SetScript('OnEnter', function()
            if not C_PlayerInfo.IsTravelersLogAvailable() then
                local tradingPostLocation = UnitFactionGroup('player') == "Alliance" and '暴风城' or '奥格瑞玛'
                GameTooltip_AddBlankLineToTooltip(GameTooltip)
                GameTooltip_AddErrorLine(GameTooltip, format('拜访%s的商栈，查看旅行者日志。', tradingPostLocation))
                if AreMonthlyActivitiesRestricted() then
                    GameTooltip_AddBlankLineToTooltip(GameTooltip)
                    GameTooltip_AddErrorLine(GameTooltip, '需要可用的游戏时间。')
                end

                GameTooltip:Show()
            end
        end)
    end

    EncounterJournalSuggestTab:SetText('推荐玩法')
    EncounterJournalDungeonTab:SetText('地下城')
    EncounterJournalRaidTab:SetText('团队副本')
    EncounterJournalLootJournalTab:SetText('套装物品')
    EncounterJournalSearchBox.Instructions:SetText('搜索')

    hooksecurefunc('EJInstanceSelect_UpdateTitle', function(tabId)
        local text
        if ( tabId == EncounterJournal.suggestTab:GetID()) then
            text= '推荐玩法'
        elseif ( tabId == EncounterJournal.raidsTab:GetID()) then
            text= '团队副本'
        elseif ( tabId == EncounterJournal.dungeonsTab:GetID()) then
            text= '地下城'
        --elseif ( tabId == EncounterJournal.MonthlyActivitiesTab:GetID()) then
        elseif (tabId == EncounterJournal.LootJournalTab:GetID()) then
            text= '套装物品'
        end
        if text then
            EncounterJournal.instanceSelect.Title:SetText(text)
        end
    end)
    if EncounterJournalMonthlyActivitiesFrame and EncounterJournalMonthlyActivitiesFrame.HeaderContainer then
        EncounterJournalMonthlyActivitiesFrame.HeaderContainer.Title:SetText('旅行者日志')
        EncounterJournalMonthlyActivitiesFrame.BarComplete.AllRewardsCollectedText:SetText('你已经收集完了本月的所有奖励')
    end

    --EncounterJournalEncounterFrameInfoFilterToggle.Text:SetText('过滤器')
    EncounterJournalEncounterFrameInstanceFrameMapButtonText:SetText('显示\n地图')
    EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetText('综述')







    --[[hooksecurefunc(MonthlyActivitiesButtonTextContainerMixin, 'UpdateText', function(self, data)
        if data.name then
            local a,b= data.name:match('(.-): (.+)')
            a= e.strText[a] or a
            b= e.strText[b] or b
            if a and b then
                e.set(self.NameText, (e.strText[a] or a)..': '..(e.strText[b] or b))
            else
                e.set(self.NameText, e.strText[data.name])
            end
        end
    end)]]
    hooksecurefunc(EncounterJournalMonthlyActivitiesFrame.FilterList.ScrollBox, 'Update', function(self)
        if self:GetView() then
            for _, btn in pairs(self:GetFrames() or {}) do
                e.set(btn.Label)
            end
        end
    end)


    hooksecurefunc('EncounterJournal_ListInstances', function()
        local frame= EncounterJournal.instanceSelect.ScrollBox
        if not frame:GetView() then
            return
        end
        for _, button in pairs(frame:GetFrames()) do
            e.set(button.name)
            local tooltiptext=  e.strText[button.tooltiptext]
            if tooltiptext then
                button.tooltiptext= tooltiptext
            end
        end
    end)

    hooksecurefunc(EncounterJournalItemMixin,'Init', function(self)--Blizzard_EncounterJournal.lua
        local itemInfo = C_EncounterJournal.GetLootInfoByIndex(self.index)
        if ( itemInfo and itemInfo.name ) then
            local name= e.strText[itemInfo.name]
            if name then
                self.name:SetText(WrapTextInColorCode(name, itemInfo.itemQuality))
            end
            local slot= e.strText[itemInfo.slot]
            if slot and self.slot then
                if itemInfo.handError then
                    self.slot:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(slot))
                else
                    self.slot:SetText(slot)
                end
            end
            local armorType= e.strText[itemInfo.armorType]
            if armorType and self.armorType then
                if itemInfo.weaponTypeError then
                    self.armorType:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(armorType))
                else
                    self.armorType:SetText(armorType)
                end
            end

            local numEncounters = EJ_GetNumEncountersForLootByIndex(self.index)
            if ( numEncounters == 1 ) then
                self.boss:SetFormattedText('首领：%s', e.cn(EJ_GetEncounterInfo(itemInfo.encounterID)) or '')
            elseif ( numEncounters == 2) then
                local itemInfoSecond = C_EncounterJournal.GetLootInfoByIndex(self.index, 2)
                local secondEncounterID = itemInfoSecond and itemInfoSecond.encounterID
                if ( itemInfo.encounterID and secondEncounterID ) then
                    self.boss:SetFormattedText('首领：%s，%s', e.cn(EJ_GetEncounterInfo(itemInfo.encounterID)) or '', e.cn(EJ_GetEncounterInfo(secondEncounterID)) or '')
                end
            elseif ( numEncounters > 2 ) then
                self.boss:SetFormattedText('首领：%s及其他', e.cn(EJ_GetEncounterInfo(itemInfo.encounterID)))
            end
        else
            self.name:SetText('正在获取物品信息')
        end
    end)

    hooksecurefunc(EncounterJournalItemHeaderMixin, 'Init', function(self, elementData)
        local name= e.strText[elementData.text]
        if name then
            self.name:SetText(name)
        end
    end)

    hooksecurefunc(EncounterBossButtonMixin, 'Init', function(self, elementData)
        local name= e.strText[elementData.name]
        if name then
            self:SetText(name)
        end
    end)

    hooksecurefunc('EncounterJournal_UpdateFilterString', function(self)
        local name
        local classID, specID = EJ_GetLootFilter()
        if (specID > 0) then
            local _
            _, name = GetSpecializationInfoByID(specID, UnitSex("player"))
        elseif (classID > 0) then
            local classInfo = C_CreatureInfo.GetClassInfo(classID)
            if classInfo then
                name = classInfo.className
            end
        end
        name= e.cn(name)
        if name then
            EncounterJournal.encounter.info.LootContainer.classClearFilter.text:SetFormattedText('职业筛选：%s', name)
        end
    end)


    if EncounterJournal.encounter.info then
        local btnTab={
            --"overviewTab",
            "lootTab",
            "bossTab",
            "modelTab"
        }
        for _, str in pairs (btnTab) do
            local button= EncounterJournal.encounter.info[str]
            if button then
                local tooltip= e.strText[button.tooltip]
                if tooltip then
                    button.tooltip= tooltip
                end
            end
        end
    end



    hooksecurefunc(EncounterJournal.encounter.info.BossesScrollBox, 'Update', function(frame)
        if frame:GetView() then
            for _, btn in pairs(frame:GetFrames()) do
                e.set(btn.text)
            end
        end
    end)
    
    hooksecurefunc('EncounterJournal_DisplayInstance', function(instanceID)--副本，数据
        local self= EncounterJournal.encounter
        local instanceName, description = EJ_GetInstanceInfo()
        
        e.set(self.instance.title, instanceName)
        e.set(self.info.instanceTitle, instanceName)
        e.set(self.instance.LoreScrollingFont, description)

        local tooltip= e.strText[self.info['overviewTab'].tooltip]
        if tooltip then
            self.info['overviewTab'].tooltip= tooltip
        end
        local desc= e.Get_Instance_Description(instanceID)
        if desc then
            EncounterJournal.encounter.instance.LoreScrollingFont:SetText(desc)
        end
    end)



    local t= EJ_GetTierInfo(2)
    if t then
        e.strText[t]='燃烧远征'
    end
    t= EJ_GetTierInfo(11)
    if t then
        e.strText[t]='本赛季'
    end
end










--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_EncounterJournal') then
            Init_EncounterJournal()
            Init_Boss()
            self:UnregisterEvent('ADDON_LOADED')
        end
        
    elseif arg1=='Blizzard_EncounterJournal' then--冒险指南
        Init_EncounterJournal()
        Init_Boss()
        self:UnregisterEvent('ADDON_LOADED')        
    end
end)
