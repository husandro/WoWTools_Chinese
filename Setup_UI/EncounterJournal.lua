local _, e = ...



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
                        WoWTools_ChineseMixin:SetLabelText(infoHeaderButton.title, '伤害')
                    elseif iconFlag==2 then
                        WoWTools_ChineseMixin:SetLabelText(infoHeaderButton.title, '治疗者')
                    elseif iconFlag==0 then
                        WoWTools_ChineseMixin:SetLabelText(infoHeaderButton.title, '坦克')
                    end
                end
            end
        end
    end
end




local function UpdateEncounterJournalHeaders()        
    for index, infoHeader in pairs(EncounterJournal.encounter.usedHeaders or {}) do
        if infoHeader.myID and infoHeader.button then
            if infoHeader.description then                
                local difficultyID = EJ_GetDifficulty()
                local data = WoWTools_ChineseMixin:GetBoosSectionData(infoHeader.myID, difficultyID)--difficultyID and WoWeuCN_Tooltips_EncounterSectionData[difficultyID .. 'x' .. sectionID]
                if data then
                    local title= data["Title"]
                    local desc= data["Description"]
                    if title then
                        infoHeader.button.title:SetText(data["Title"])
                    end
                    if desc then
                        infoHeader.description:SetText(data["Description"])
                    end
                    EncounterJournal_ShiftHeaders(index)
                end
            end
            
            EncounterJournal_SetupIconFlags(infoHeader.myID, infoHeader.button)
        end
    end
end






local function get_encounter_name(encounterID)
    if encounterID then
        return WoWTools_ChineseMixin:GetBossName(encounterID) or WoWTools_ChineseMixin:GetData(EJ_GetEncounterInfo(encounterID))
    end
end




































local function Init_EncounterJournal()

    EncounterJournalTitleText:SetText('冒险指南')
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


    --EncounterJournalEncounterFrameInfoFilterToggle.Text:SetText('过滤器')
    EncounterJournalEncounterFrameInstanceFrameMapButtonText:SetText('显示\n地图')
    EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetText('综述')


    hooksecurefunc('EncounterJournal_ListInstances', function()
        local frame= EncounterJournal.instanceSelect.ScrollBox
        if not frame:GetView() then
            return
        end
        for _, button in pairs(frame:GetFrames()) do
            WoWTools_ChineseMixin:SetLabelText(button.name)
            local tooltiptext=  WoWTools_ChineseMixin:CN(button.tooltiptext)
            if tooltiptext then
                button.tooltiptext= tooltiptext
            end
        end
    end)

    --BOSS，掉落
    hooksecurefunc(EncounterJournalItemMixin,'Init', function(self)--Blizzard_EncounterJournal.lua
        local itemInfo = C_EncounterJournal.GetLootInfoByIndex(self.index)
        if ( itemInfo and itemInfo.name ) then
            local name= WoWTools_ChineseMixin:GetItemName(itemInfo.itemID) or WoWTools_ChineseMixin:CN(itemInfo.name)
            if name then
                self.name:SetText(WrapTextInColorCode(name, itemInfo.itemQuality))
            end
            local slot= WoWTools_ChineseMixin:CN(itemInfo.slot)
            if slot and self.slot then
                if itemInfo.handError then
                    self.slot:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(slot))
                else
                    self.slot:SetText(slot)
                end
            end
            local armorType= WoWTools_ChineseMixin:CN(itemInfo.armorType)
            if armorType and self.armorType then
                if itemInfo.weaponTypeError then
                    self.armorType:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(armorType))
                else
                    self.armorType:SetText(armorType)
                end
            end

            local numEncounters = EJ_GetNumEncountersForLootByIndex(self.index)
            
            if ( numEncounters == 1 ) then
                local name2= get_encounter_name(itemInfo.encounterID)
                if name2 then
                    self.boss:SetFormattedText('首领：%s', name2)
                end

            elseif ( numEncounters == 2) then
                local itemInfoSecond = C_EncounterJournal.GetLootInfoByIndex(self.index, 2)
                local secondEncounterID = itemInfoSecond and itemInfoSecond.encounterID
                local name1, name2= get_encounter_name(itemInfo.encounterID), get_encounter_name(secondEncounterID)
                if name1 and name2 then
                    self.boss:SetFormattedText('首领：%s，%s', name1 or '', name2)
                end

            elseif ( numEncounters > 2 ) then
                local name2= get_encounter_name(itemInfo.encounterID)
                if name2 then
                    self.boss:SetFormattedText('首领：%s及其他', name)
                end
            end
        else
            self.name:SetText('正在获取物品信息')
        end
    end)

    hooksecurefunc(EncounterJournalItemHeaderMixin, 'Init', function(self, elementData)
        local name= WoWTools_ChineseMixin:CN(elementData.text)
        if name then
            self.name:SetText(name)
        end
    end)

    hooksecurefunc(EncounterBossButtonMixin, 'Init', function(self, elementData)
        local name= WoWTools_ChineseMixin:CN(elementData.name)
        if name then
            self:SetText(name)
        end
    end)

    hooksecurefunc('EncounterJournal_UpdateFilterString', function()
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
        name= WoWTools_ChineseMixin:GetData(name)
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
                local tooltip= WoWTools_ChineseMixin:CN(button.tooltip)
                if tooltip then
                    button.tooltip= tooltip
                end
            end
        end
    end



    hooksecurefunc(EncounterJournal.encounter.info.BossesScrollBox, 'Update', function(self)
        if not self:GetView() then
            return
        end
        for _, btn in pairs(self:GetFrames()) do
            local data= btn:GetData()
            local name= data and WoWTools_ChineseMixin:GetBossName(data.bossID)
            if name then
                btn.text:SetText(name)
            end
        end
    end)








    --物品，掉落，列表
    hooksecurefunc(EncounterJournal.LootJournalItems.ItemSetsFrame.ScrollBox, 'Update', function(self)
        if not self:GetView() then
            return
        end
        for _, btn in pairs(self:GetFrames() or {}) do
            WoWTools_ChineseMixin:SetLabelText(btn.SetName)
        end
    end)



    hooksecurefunc('EncounterJournal_SetUpOverview', function(self, overviewSectionID, index)
        local infoHeader= self.overviews[index]
        if infoHeader and infoHeader.button and overviewSectionID then
            EncounterJournal_SetupIconFlags(overviewSectionID, infoHeader.button, index)
        end
    end)
    
    --副本，数据
    hooksecurefunc('EncounterJournal_DisplayInstance', function(instanceID)
        local self= EncounterJournal.encounter
        local instanceName, description = EJ_GetInstanceInfo()

        WoWTools_ChineseMixin:SetLabelText(self.instance.title, instanceName)
        WoWTools_ChineseMixin:SetLabelText(self.info.instanceTitle, instanceName)
        WoWTools_ChineseMixin:SetLabelText(self.instance.LoreScrollingFont, description)

        local tooltip= WoWTools_ChineseMixin:CN(self.info['overviewTab'].tooltip)
        if tooltip then
            self.info['overviewTab'].tooltip= tooltip
        end
        local desc= WoWTools_ChineseMixin:GetInstanceDesc(instanceID)
        if desc then
            EncounterJournal.encounter.instance.LoreScrollingFont:SetText(desc)
        end
    end)

    WoWTools_ChineseMixin:HookButton(EncounterJournalEncounterFrameInfoSlotFilterToggle)
    WoWTools_ChineseMixin:HookButton(EncounterJournalEncounterFrameInfoDifficulty)
end














--导航条
local function set_navButton(navBar, text)
    if not navBar or not navBar.navList then
        return
    end
    local navButton = navBar.navList[#navBar.navList]
    if navButton then
        WoWTools_ChineseMixin:SetCNFont(navButton.text)
        navButton:SetText(text)
        local buttonExtraWidth
        if navButton.listFunc  and not navBar.oldStyle then
            buttonExtraWidth = 53
        else
            buttonExtraWidth = 30
        end
        navButton:SetWidth(navButton.text:GetStringWidth() + buttonExtraWidth)
    end
end









local function Init_WoWeuCN()
    if loadEncounterData then
        return
    end


    hooksecurefunc("EncounterJournal_DisplayEncounter", function(encounterID)
        local self = EncounterJournal.encounter
        local info= WoWTools_ChineseMixin:GetBossData(encounterID)
        if info then
            local title= info["Title"]
            local desc= info["Description"]
            if title then
                self.info.encounterTitle:SetText(title)
                set_navButton(EncounterJournal.navBar, title)--导航条
                
            end
            if desc then
                self.overviewFrame.loreDescription:SetText(desc)
                self.infoFrame.description:SetText(desc)
                self.infoFrame.descriptionHeight = self.infoFrame.description:GetHeight()
                if self.usedHeaders[1] then
                    self.usedHeaders[1]:SetPoint("TOPRIGHT", 0 , -8 - EncounterJournal.encounter.infoFrame.descriptionHeight - 6)
                end
            end
        end 

        local desc= WoWTools_ChineseMixin:GetBoosSectionDesc(self.overviewFrame.rootOverviewSectionID)            
        if desc then
            self.overviewFrame.overviewDescription.Text:SetText(desc)
            self.overviewFrame.overviewDescription.descriptionHeight = self.overviewFrame.overviewDescription:GetHeight()
        end
        if des or info then
            UpdateEncounterJournalHeaders()
        end
    end)

    hooksecurefunc("EncounterJournal_ToggleHeaders", function(object)
        if (object == EncounterJournal.encounter.overviewFrame) then
            return
        end
        UpdateEncounterJournalHeaders()
    end)

    hooksecurefunc("EncounterJournal_SetDescriptionWithBullets", function(infoHeader)
        local data = infoHeader and WoWTools_ChineseMixin:GetBoosSectionData(infoHeader.sectionID)
        if data then
            local title= data["Title"]
            local desc= data["Description"]
            if title then
                infoHeader.button.title:SetText(title)
            end
            if desc then
                EncounterJournal_SetBullets(infoHeader.overviewDescription, desc, not infoHeader.expanded)
            end
        end
    end)
end



















function WoWTools_ChineseMixin.Events:Blizzard_EncounterJournal()
    Init_EncounterJournal()
    Init_WoWeuCN()

    hooksecurefunc('EJSuggestFrame_RefreshDisplay', function()
       

        local frame = EncounterJournal.suggestFrame;
       

        local num= #frame.suggestions
        if  num== 0 then
            return
        end
            for i = 1, num do
                local suggestion = frame["Suggestion"..i]
		        local data = frame.suggestions[i]
                if not suggestion or not data then
                    break;
                end
                WoWTools_ChineseMixin:SetLabelText(suggestion.centerDisplay.title.text, data.title)
                WoWTools_ChineseMixin:SetLabelText(suggestion.centerDisplay.description.text, data.description)
                if suggestion.centerDisplay then
                    WoWTools_ChineseMixin:SetLabelText(suggestion.centerDisplay.button, data.buttonText)
                else
                    WoWTools_ChineseMixin:SetLabelText(suggestion.button, data.buttonText)
                end
            end
    end)


    --hooksecurefunc(EncounterJournalItemMixin, 'Init', function(frame, data)可用
    do
        WoWTools_ChineseMixin.Events:Blizzard_EncounterJournal_PerksActivity()
    end
    WoWTools_ChineseMixin.Events.Blizzard_EncounterJournal_PerksActivity=nil
end









