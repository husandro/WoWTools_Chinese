if UnitClassBase('player')~= 'HUNTER' then
    return
end


WoWTools_ChineseMixin:HookLabel(StableFrame.StabledPetList.FilterBar.FilterDropdown.Text)

StableFrame.StabledPetList.FilterBar.SearchBox.Instructions:SetText('查询')

WoWTools_ChineseMixin:HookButton(StableFrame.StableTogglePetButton, true)
StableFrame.ReleasePetButton:SetText('释放')
StableFrame.ReleasePetButton.disabledTooltip='你只能释放你当前召唤的宠物。'
StableFrame.PetModelScene.AbilitiesList.ListHeader:SetText('特殊技能')
StableFrame.ActivePetList.ListName:SetText('激活')
StableFrame.StabledPetList.ListName:SetText('兽栏')

StableFrameTitleText:SetFormattedText('|cffaad372%s|r 的宠物', UnitName('player'))

hooksecurefunc(StableFrame.PetModelScene.PetInfo, 'SetPet', function(self, petData)
    if petData.isExotic then
        self.Exotic:SetText('特殊')
    end
end)

hooksecurefunc(StablePetAbilityMixin, 'Initialize', function(self, spellID)
    local name = spellID and WoWTools_ChineseMixin:GetSpellName(spellID)
    if name then
        self.Name:SetText(name)
    end
end)


hooksecurefunc(StableFrame.StabledPetList.ScrollBox, 'Update', function(frame)
    if not frame:GetView() then
        return
    end
    for _, btn in pairs(frame:GetFrames() or {}) do
        WoWTools_ChineseMixin:SetLabel(btn.Label)
        WoWTools_ChineseMixin:SetLabel(btn.Name)
        WoWTools_ChineseMixin:SetLabel(btn.Type)
    end
end)

--替换 原生
function StableFrame:SetupPetCounter()
	self.StabledPetList.ListCounter.Count:SetFormattedText(
        '%1d/%2d',
        #self.StabledPetList.pets + math.min(#self.ActivePetList.pets, Constants.PetConsts_PostCata.MAX_SUMMONABLE_HUNTER_PETS),
        Constants.PetConsts_PostCata.NUM_PET_SLOTS_HUNTER
    )
end