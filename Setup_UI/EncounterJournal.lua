


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
                        WoWTools_ChineseMixin:SetLabel(infoHeaderButton.title, '伤害')
                    elseif iconFlag==2 then
                        WoWTools_ChineseMixin:SetLabel(infoHeaderButton.title, '治疗者')
                    elseif iconFlag==0 then
                        WoWTools_ChineseMixin:SetLabel(infoHeaderButton.title, '坦克')
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
                    if data.T then
                        infoHeader.button.title:SetText(data.T)
                    end
                    if data.D then
                        infoHeader.description:SetText(data.D)
                    end
                    EncounterJournal_ShiftHeaders(index)
                end
            end

            EncounterJournal_SetupIconFlags(infoHeader.myID, infoHeader.button)
        end
    end
end
















































--[[导航条
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
end]]



















function WoWTools_ChineseMixin.Events:Blizzard_EncounterJournal()

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


    --hooksecurefunc('EncounterJournal_ListInstances', function()
    --EncounterInstanceButtonTemplate
    hooksecurefunc(EncounterJournal.instanceSelect.ScrollBox, 'Update', function(frame)
        frame= frame or EncounterJournal.instanceSelect.ScrollBox
        if not frame:GetView() then
            return
        end
        for _, button in pairs(frame:GetFrames()) do
            self:SetLabel(button.name)
        end
    end)

    

    --BOSS，掉落
    hooksecurefunc(EncounterJournalItemMixin,'Init', function(frame)--Blizzard_EncounterJournal.lua
        if not frame:IsVisible() then
            return
        end
        local itemInfo = C_EncounterJournal.GetLootInfoByIndex(frame.index)
        if ( itemInfo and itemInfo.name ) then
            local name= self:GetItemName(itemInfo.itemID) or self:CN(itemInfo.name)
            if name then
                frame.name:SetText(WrapTextInColorCode(name, itemInfo.itemQuality))
            end
            local slot= self:CN(itemInfo.slot)
            if slot and frame.slot then
                if itemInfo.handError then
                    frame.slot:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(slot))
                else
                    frame.slot:SetText(slot)
                end
            end
            local armorType= self:CN(itemInfo.armorType)
            if armorType and frame.armorType then
                if itemInfo.weaponTypeError then
                    frame.armorType:SetText(INVALID_EQUIPMENT_COLOR:WrapTextInColorCode(armorType))
                else
                    frame.armorType:SetText(armorType)
                end
            end

            local numEncounters = EJ_GetNumEncountersForLootByIndex(frame.index)

            local bossName= itemInfo.encounterID and EJ_GetEncounterInfo(itemInfo.encounterID)
            bossName= self:CN(bossName) or bossName

            if ( numEncounters == 1 ) then
                if bossName then
                    frame.boss:SetFormattedText('首领：%s', bossName)
                end

            elseif ( numEncounters == 2) then
                local itemInfoSecond = C_EncounterJournal.GetLootInfoByIndex(frame.index, 2)
                local secondEncounterID = itemInfoSecond and itemInfoSecond.encounterID
                local bossName2= secondEncounterID and EJ_GetEncounterInfo(secondEncounterID)
                bossName2= self:CN(bossName2) or bossName2
                if bossName or bossName2 then
                    frame.boss:SetFormattedText('首领：%s，%s', bossName or '', bossName2)
                end

            elseif ( numEncounters > 2 ) then
                if bossName then
                    frame.boss:SetFormattedText('首领：%s及其他', bossName)
                end
            end
        else
            frame.name:SetText('正在获取物品信息')
        end
    end)

    hooksecurefunc(EncounterJournalItemHeaderMixin, 'Init', function(frame, elementData)
        local name= self:CN(elementData.text)
        if name then
            frame.name:SetText(name)
        end
    end)

    hooksecurefunc(EncounterBossButtonMixin, 'Init', function(frame, elementData)
        local name= self:CN(elementData.name)
        if name then
            frame:SetText(name)
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
        name= self:CN(name) or name
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
                local tooltip= self:CN(button.tooltip)
                if tooltip then
                    button.tooltip= tooltip
                end
            end
        end
    end



    hooksecurefunc(EncounterJournal.encounter.info.BossesScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames()) do
            self:SetLabel(btn.text)
        end
    end)




    










--物品，掉落，列表

    --套装
    hooksecurefunc(LootJournalItemSetButtonMixin, 'Init', function(btn, data)
        local name= self:CN(data.name)
        if name then
            btn.SetName:SetText(name)
        end
	    btn.ItemLevel:SetFormattedText('物品等级%d', data.itemLevel)
    end)
    --[[hooksecurefunc(EncounterJournal.LootJournalItems.ItemSetsFrame.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            self:SetLabel(btn.SetName)
        end
    end)]]



    hooksecurefunc('EncounterJournal_SetUpOverview', function(frame, overviewSectionID, index)
        local infoHeader= frame.overviews[index]
        if infoHeader and infoHeader.button and overviewSectionID then
            EncounterJournal_SetupIconFlags(overviewSectionID, infoHeader.button, index)
        end
    end)

    --副本，数据
    hooksecurefunc('EncounterJournal_DisplayInstance', function()
        local frame= EncounterJournal.encounter
        local instanceName, description = EJ_GetInstanceInfo()

        self:SetLabel(frame.instance.title, instanceName)
        self:SetLabel(frame.info.instanceTitle, instanceName)
        self:SetLabel(frame.instance.LoreScrollingFont, description)

        local tooltip= self:CN(frame.info['overviewTab'].tooltip)
        if tooltip then
            frame.info['overviewTab'].tooltip= tooltip
        end
        --[[local desc= self:GetInstanceDesc(instanceID)
        if desc then
            EncounterJournal.encounter.instance.LoreScrollingFont:SetText(desc)
        end]]
    end)

    self:HookButton(EncounterJournalEncounterFrameInfoSlotFilterToggle)
    self:HookButton(EncounterJournalEncounterFrameInfoDifficulty)







    hooksecurefunc("EncounterJournal_DisplayEncounter", function(encounterID)
        local frame = EncounterJournal.encounter
        local ename, description= EJ_GetEncounterInfo(encounterID)

        self:SetLabel(frame.info.encounterTitle, ename)

        local desc= WoWTools_ChineseMixin:CN(description)
        
        --set_navButton(EncounterJournal.navBar, title)--导航条
        
        if desc then
            frame.overviewFrame.loreDescription:SetText(desc)
            frame.infoFrame.description:SetText(desc)
            frame.infoFrame.descriptionHeight = frame.infoFrame.description:GetHeight()
            if frame.usedHeaders[1] then
                frame.usedHeaders[1]:SetPoint("TOPRIGHT", 0 , -8 - EncounterJournal.encounter.infoFrame.descriptionHeight - 6)
            end
        end

        desc= select(2, WoWTools_ChineseMixin:GetBoosSectionName(frame.overviewFrame.rootOverviewSectionID))
        if desc then
            frame.overviewFrame.overviewDescription.Text:SetText(desc)
            frame.overviewFrame.overviewDescription.descriptionHeight = frame.overviewFrame.overviewDescription:GetHeight()
        end
        UpdateEncounterJournalHeaders()
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
            local title= data.T
            local desc= data.D
            if title then
                infoHeader.button.title:SetText(title)
            end
            if desc then
                EncounterJournal_SetBullets(infoHeader.overviewDescription, desc, not infoHeader.expanded)
            end
        end
    end)


































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
                    break
                end

                WoWTools_ChineseMixin:SetLabel(suggestion.centerDisplay.title.text, data.title)
                WoWTools_ChineseMixin:SetLabel(suggestion.centerDisplay.description.text, data.description)
                if suggestion.centerDisplay then
                    WoWTools_ChineseMixin:SetLabel(suggestion.centerDisplay.button, data.buttonText)
                else
                    WoWTools_ChineseMixin:SetLabel(suggestion.button, data.buttonText)
                end
            end
    end)


    --hooksecurefunc(EncounterJournalItemMixin, 'Init', function(frame, data)可用
    do
        WoWTools_ChineseMixin.Events:Blizzard_EncounterJournal_PerksActivity()
    end
    WoWTools_ChineseMixin.Events.Blizzard_EncounterJournal_PerksActivity=nil
end









