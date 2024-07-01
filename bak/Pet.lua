
local id, e = ...




--Blizzard_FrameXML/SharedPetBattleTemplates.lua
--战斗宠物，技能 SharedPetBattleTemplates.lua
hooksecurefunc('SharedPetBattleAbilityTooltip_SetAbility', function(self, abilityInfo, additionalText)
    print(additionalText)
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
    for _, btn in pairs(PetJournal.ScrollBox:GetFrames() or {}) do
        e.set(btn.name)
    end

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