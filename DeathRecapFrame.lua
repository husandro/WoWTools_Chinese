local e= select(2, ...)



e.dia("DEATH", {text = '%d%s后释放灵魂', button1 = '释放灵魂', button2 = '复活', button3 = '复活', button4 = '摘要'})

e.hookDia("DEATH", 'OnShow', function(self)
    if ( IsActiveBattlefieldArena() and not C_PvP.IsInBrawl() ) then
        self.text:SetText('你死亡了。释放灵魂后将进入观察模式。')
    elseif ( self.timeleft == -1 ) then
        self.text:SetText('你死亡了。要释放灵魂到最近的墓地吗？')
    end
    e.set(self.button1)
    e.set(self.button2)
    e.set(self.button3)
    e.set(self.button4)
end)




local function get_spell_name(option)
    if not option or not option then
        return
    end
    local name, icon
    if option.optionType==Enum.SelfResurrectOptionType.Spell then
        name= e.Get_Spell_Name(option.id)
        icon= C_Spell.GetSpellTexture(option.id)

    elseif option.optionType==Enum.SelfResurrectOptionType.Item then
        name= e.Get_Item_Name(option.id)
        icon= C_Item.GetItemIconByID(option.id)
    end
    if icon== 134400 then
        icon=nil
    end
    name= name or e.strText[option.name]
    if name then
        return (icon and '|T'..icon..':0|t' or '')..name
    end
end

e.hookDia("DEATH", 'OnUpdate', function(self)
    if ( IsFalling() and not IsOutOfBounds()) then
        return
    end
    local b1_enabled = self.button1:IsEnabled()
    local encounterSupressRelease = IsEncounterSuppressingRelease()
    if ( encounterSupressRelease ) then
        self.button1:SetText('释放灵魂')
    else
        local hasNoReleaseAura, _, hasUntilCancelledDuration = HasNoReleaseAura()
        if ( hasNoReleaseAura ) then
            if hasUntilCancelledDuration then
                self.button1:SetText('释放灵魂')
            end
        else
            self.button1:SetText('释放灵魂')
        end
    end
    if ( b1_enabled ~= self.button1:IsEnabled() ) then
        if ( b1_enabled ) then
            if ( encounterSupressRelease ) then
                self.text:SetText('你队伍中有一名成员正在战斗中。')
            else
                self.text:SetText('现在无法释放。')
            end
        end
    end

    local option1, option2
    local resOptions = GetSortedSelfResurrectOptions()
    if ( resOptions ) then
        if ( IsEncounterLimitingResurrections() ) then
            option1, option2= resOptions[1], resOptions[2]
        else
            option1=resOptions[1]
        end
    end

    local name = get_spell_name(option1)
    if name then
        self.button2:SetText(name)
    end

    local name = get_spell_name(option2)
    if name then
        self.button3:SetText(name)
    end
end)



e.dia("RESURRECT", {text = '%s想要复活你。一旦这样复活，你将会进入复活虚弱状态', delayText = '%s要复活你，%d%s内生效。一旦这样复活，你将会进入复活虚弱状态。', button1 = '接受', button2 = '拒绝'})
e.dia("RESURRECT_NO_SICKNESS", {text = '%s想要复活你', delayText = '%s要复活你，%d%s内生效', button1 = '接受', button2 = '拒绝'})
e.dia("RESURRECT_NO_TIMER", {text = '%s想要复活你', button1 = '接受', button2 = '拒绝'})













local function set_DeathRecapFrame_OpenRecap()
    local self = DeathRecapFrame;
    if not DeathRecapFrame:IsShown() then
        return
    end
    
    local events = DeathRecap_GetEvents(self.recapID );
    if( not events or #events <= 0 ) then
        return;
    end

    for i = 1, #events do
        local entry = self.DeathRecapEntry[i]        
        local evtData = events[i]
        if entry and entry:IsShown() and evtData then
            local spellId, spellName = DeathRecapFrame_GetEventInfo(evtData)
            local name= e.Get_Spell_Name(spellId) or e.strText[spellName]
            if name then
                entry.SpellInfo.Name:SetText(name)
            end
            e.set(entry.SpellInfo.Caster)

            local dmgInfo = entry.DamageInfo;
            if dmgInfo and evtData.amount then
                dmgInfo.dmgExtraStr = "";
                if ( evtData.overkill and evtData.overkill > 0 ) then
                    dmgInfo.dmgExtraStr = format('（%s 过量伤害）', evtData.overkill);
                end
                if ( evtData.absorbed and evtData.absorbed > 0 ) then
                    dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr.." "..format('（%s 吸收）', evtData.absorbed);
                end
                if ( evtData.resisted and evtData.resisted > 0 ) then
                    dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr.." "..format('（%s 抵抗）', evtData.resisted);
                end
                if ( evtData.blocked and evtData.blocked > 0 ) then
                    dmgInfo.dmgExtraStr = dmgInfo.dmgExtraStr.." "..format('（%s 格挡）', evtData.blocked);
                end
            end
        end
    end
end






local function Init()
    DeathRecapFrame.CloseButton:SetText('关闭')
    DeathRecapFrame.Title:SetText('死亡摘要')

    hooksecurefunc('DeathRecapFrame_OpenRecap', set_DeathRecapFrame_OpenRecap)
end








--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_DeathRecap') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_DeathRecap' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)

