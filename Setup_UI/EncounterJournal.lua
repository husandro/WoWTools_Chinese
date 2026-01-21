


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

    self:HookLabel(EncounterJournalTitleText)
    EncounterJournalSuggestTab:SetText('推荐')
    EncounterJournalDungeonTab:SetText('地下城')
    EncounterJournalRaidTab:SetText('团本')
    EncounterJournalLootJournalTab:SetText('套装')
    EncounterJournalSearchBox.Instructions:SetText('搜索')
    self:HookLabel(EncounterJournal.instanceSelect.Title)

    EncounterJournalEncounterFrameInstanceFrameMapButtonText:SetText('显示\n地图')
    EncounterJournalEncounterFrameInfoOverviewScrollFrameScrollChildTitle:SetText('综述')


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
    end)

    self:HookButton(EncounterJournalEncounterFrameInfoSlotFilterToggle)
    self:HookButton(EncounterJournalEncounterFrameInfoDifficulty)







    hooksecurefunc("EncounterJournal_DisplayEncounter", function(encounterID)
        local frame = EncounterJournal.encounter
        local ename, description= EJ_GetEncounterInfo(encounterID)

        self:SetLabel(frame.info.encounterTitle, ename)

        local desc= WoWTools_ChineseMixin:CN(description)
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
        local frame = EncounterJournal.suggestFrame        local num= #frame.suggestions
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

    do
        WoWTools_ChineseMixin.Events:Blizzard_EncounterJournal_PerksActivity()
    end
    WoWTools_ChineseMixin.Events.Blizzard_EncounterJournal_PerksActivity=nil






    self:SetFrame(EncounterJournal.TutorialsFrame.Contents)
    self:SetButton(EncounterJournal.TutorialsFrame.Contents.StartButton)
    self:SetLabel(EncounterJournalInstanceSelect.Title)

--旅程 12.0
    if not EncounterJournalJourneysFrame  then
        return
    end


    self:HookLabel(EncounterJournalJourneysFrame.JourneyOverview.JourneyName)
    self:SetLabel(EncounterJournalJourneysFrame.JourneyOverview.JourneyWarbandLabel)
    self:HookLabel(EncounterJournalJourneysFrame.JourneyOverview.JourneyDescription)

    hooksecurefunc(EncounterJournalJourneysFrame.JourneysList, 'Update', function(frame)
        if not frame:HasView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            local data= btn:GetElementData() or {}

            if data.category then
                self:SetLabel(btn.CategoryName)--类别
            elseif data.divider then
            elseif data.isRenownJourney then
                self:SetLabel(btn.RenownCardFactionName)--名称

                if data.paragonInfo and data.paragonInfo.level ~= 0 then
                    btn.RenownCardFactionLevel:SetFormattedText('最大名望：等级%d', data.renownLevel + data.paragonInfo.level)
                else
                    btn.RenownCardFactionLevel:SetFormattedText('等级 %d', data.renownLevel)
                end

                self:SetLabel(btn.WatchedFactionToggleFrame.WatchFactionCheckbox.Label)--"显示为经验条

            else
                self:SetLabel(btn.JourneyCardName)

                if data.paragonInfo and data.paragonInfo.level ~= 0 then
                    btn.JourneyCardLevel:SetFormattedText('最大名望：等级%d', data.renownLevel + data.paragonInfo.level)
                else
                    btn.JourneyCardLevel:SetFormattedText('等级 %d', data.renownLevel)
                end
            end
        end
    end)

--奖励
    self:HookLabel(EncounterJournalJourneysFrame.JourneyProgress.JourneyName)
    self:SetLabel(EncounterJournalJourneysFrame.JourneyProgress.LockedStateFrame.JourneyLockedText)
    self:HookButton(EncounterJournalJourneysFrame.JourneyProgress.OverviewBtn)
    self:SetButton(EncounterJournalJourneysFrame.JourneyProgress.LevelSkipButton)

--JourneyProgressFrameMixin
    hooksecurefunc(EncounterJournalJourneysFrame.JourneyProgress, 'SetRewards', function(frame)
        for btn in frame.rewardPool:EnumerateActive() do
            self:SetLabel(btn.RewardCardName)
        end
    end)
    hooksecurefunc(EncounterJournalJourneysFrame.JourneyProgress.EncounterRewardProgressFrame, 'Init', function(frame)

    end)

    hooksecurefunc(EncounterJournalJourneysFrame.JourneyProgress, 'SetupProgressDetails', function(frame)
        local progressFrame = frame.ProgressDetailsFrame
        local threshold, progress
        if frame.majorFactionData.paragonInfo and frame.majorFactionData.renownLevel == frame.maxLevel  then
            threshold = frame.majorFactionData.paragonInfo.threshold
            progress = frame.majorFactionData.paragonInfo.value - (threshold * frame.majorFactionData.paragonInfo.level)
        else
            threshold = frame.majorFactionData.renownLevelThreshold
            progress = frame.majorFactionData.renownReputationEarned
        end

        progressFrame.JourneyLevelProgress:SetFormattedText('当前进度 |cnHIGHLIGHT_FONT_COLOR:%d/%d|r', progress, threshold)
    end)

    self:SetButton(EncounterJournalJourneysFrame.JourneyOverview.OverviewBtn)
    self:SetLabel(EncounterJournalJourneysFrame.JourneyProgress.RenownTrackFrame.ClipFrame.ParagonLevelFrame.Label)

    self:HookLabel(EncounterJournalJourneysFrame.JourneyProgress.DelvesCompanionConfigurationFrame.CompanionConfigBtn.CompanionName)
end
--[[

-- In order to be able to use companion config, players need to have unlocked a companion and have it set with a proper trait config
function JourneyCompanionConfigBtnMixin:SetCompanionEnabledState()
	local progressFrame = self:GetParent():GetParent();
	if progressFrame and progressFrame.majorFactionData and progressFrame.majorFactionData.playerCompanionID then
		self.playerCompanionID = progressFrame.majorFactionData.playerCompanionID;
		local traitTreeID = C_DelvesUI.GetTraitTreeForCompanion(self.playerCompanionID);

		if C_Traits.GetConfigIDByTreeID(traitTreeID) then
			self.enabled = true;
		else
			self.enabled = false;
		end
	else
		self.enabled = false;
	end
	self:SetEnabled(self.enabled);
end

function JourneyCompanionConfigBtnMixin:OnShow()
	self:SetCompanionEnabledState();
end

function JourneyCompanionConfigBtnMixin:ToggleCompanionConfig()
	if not DelvesCompanionConfigurationFrame:IsShown() then
		local playerCompanionID = self:GetParent():GetParent().majorFactionData.playerCompanionID;
		DelvesCompanionConfigurationFrame.playerCompanionID = playerCompanionID;
		ShowUIPanel(DelvesCompanionConfigurationFrame);
	else
		HideUIPanel(DelvesCompanionConfigurationFrame);
	end
end

function JourneyCompanionConfigBtnMixin:OnEnter()
	if not self.enabled then
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT", -10, -10);
		GameTooltip_AddErrorLine(GameTooltip, C_DelvesUI.GetLockedTextForCompanion(self.playerCompanionID));
		GameTooltip:Show();
	end
end

function JourneyCompanionConfigBtnMixin:OnLeave()
	GameTooltip:Hide();
end

function JourneyCompanionConfigBtnMixin:OnClick()
	if self.enabled then
		self:ToggleCompanionConfig();
	end
end
]]