







ProfessionMicroButton.tooltipText = MicroButtonTooltipText('专业', "TOGGLEPROFESSIONBOOK")
ProfessionMicroButton:HookScript('OnEvent', function(self, event)
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('专业', "TOGGLEPROFESSIONBOOK")
    end
end)
PlayerSpellsMicroButton.tooltipText = MicroButtonTooltipText('天赋和法术书', "TOGGLETALENTS")
PlayerSpellsMicroButton:HookScript('OnEvent', function(self, event)
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('天赋和法术书', "TOGGLETALENTS")
    end
end)

if HousingMicroButton then
    hooksecurefunc(HousingMicroButton, 'UpdateTooltipText', function(self)
        self.tooltipText = MicroButtonTooltipText('住宅信息板', "TOGGLEHOUSINGDASHBOARD");
        self.newbieText = '!所有住宅系统相关的信息板!'
    end)
end


AchievementMicroButton.tooltipText = MicroButtonTooltipText('成就', "TOGGLEACHIEVEMENT")
AchievementMicroButton.newbieText = '浏览有关你的成就和统计数据的信息。'
AchievementMicroButton:HookScript('OnEvent', function(self, event)
    if not Kiosk.IsEnabled() and event == "UPDATE_BINDINGS" then
        self.tooltipText = MicroButtonTooltipText('成就', "TOGGLEACHIEVEMENT")
    end
end)

hooksecurefunc(QuestLogMicroButton, 'UpdateTooltipText', function(self)
    self.tooltipText = MicroButtonTooltipText('任务日志', "TOGGLEQUESTLOG")
    self.newbieText = '你现在所拥有的任务。你最多可以同时拥有25条任务记录。'
end)

hooksecurefunc(GuildMicroButton, 'UpdateMicroButton', function(self)
    if ( IsCommunitiesUIDisabledByTrialAccount() or self.factionGroup == "Neutral" or Kiosk.IsEnabled() ) then
        if not Kiosk.IsEnabled() then
            self.disabledTooltip = '免费试玩账号无法进行此项操作'
        end
    elseif ( C_Club.IsEnabled() and not BNConnected() ) then
        self.disabledTooltip = '不可用|n|n暴雪游戏服务目前不可用。'
    elseif ( C_Club.IsEnabled() and C_Club.IsRestricted() ~= Enum.ClubRestrictionReason.None ) then
        self.disabledTooltip = '不可用'
    elseif not (( CommunitiesFrame and CommunitiesFrame:IsShown() ) or ( _G['GuildFrame'] and _G['GuildFrame']:IsShown() )) then

        if ( CommunitiesFrame_IsEnabled() ) then
            self.tooltipText = MicroButtonTooltipText('公会与社区', "TOGGLEGUILDTAB")
            --self.newbieText = NEWBIE_TOOLTIP_COMMUNITIESTAB
        elseif ( IsInGuild() ) then
            self.tooltipText = MicroButtonTooltipText('公会', "TOGGLEGUILDTAB")
            self.newbieText = '查看关于你所在的公会及其会员的信息。如果你是公会的管理人员，还可以在这个窗口中进行公会管理工作。'
        else
            self.tooltipText = MicroButtonTooltipText('公会查找器', "TOGGLEGUILDTAB")
            self.newbieText = '让您找到一个公会。'
        end
    end
end)

LFDMicroButton.tooltipText = MicroButtonTooltipText('队伍查找器', "TOGGLEGROUPFINDER")
LFDMicroButton.disabledTooltip = function()
    local canUse, failureReason = C_LFGInfo.CanPlayerUseGroupFinder()
    return canUse and '此功能在你选择阵营前不可用。' or (WoWTools_ChineseMixin:CN(failureReason) or failureReason)
end
hooksecurefunc(LFDMicroButton, 'UpdateMicroButton',function(self)
    if not ( PVEFrame and PVEFrame:IsShown() ) and not self:IsActive() then
        self.disabledTooltip = function()
            local canUse, failureReason = C_LFGInfo.CanPlayerUseGroupFinder()
            return canUse and '此功能在你选择阵营前不可用。' or (WoWTools_ChineseMixin:CN(failureReason) or failureReason)
        end
    end
end)
LFDMicroButton:HookScript('OnEvent', function(self, event)
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('队伍查找器', "TOGGLEGROUPFINDER")
    end
end)

CollectionsMicroButton.tooltipText = MicroButtonTooltipText('战团藏品', "TOGGLECOLLECTIONS")
CollectionsMicroButton:HookScript('OnEvent', function(self, event)
    if CollectionsJournal and CollectionsJournal:IsShown() then
        return
    end
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('战团藏品', "TOGGLECOLLECTIONS")
    end
end)

EJMicroButton.tooltipText = MicroButtonTooltipText('地下城手册', "TOGGLEENCOUNTERJOURNAL")
EJMicroButton.newbieText = '查看各个地下城及团队副本首领的资料，包括他们的技能和收藏的宝物。'
EJMicroButton:HookScript('OnEvent', function(self, event)
    if event == "UPDATE_BINDINGS" then
        self.tooltipText = MicroButtonTooltipText('冒险指南', "TOGGLEENCOUNTERJOURNAL")
        EJMicroButton.newbieText = '查看各个地下城及团队副本首领的资料，包括他们的技能和收藏的宝物。'
    end
end)
if not (EncounterJournal and EncounterJournal:IsShown() ) and not AdventureGuideUtil.IsAvailable() then
    EJMicroButton.disabledTooltip = Kiosk.IsEnabled() and '该系统目前已被禁用。'  or '该功能尚不可用。'
end
hooksecurefunc(EJMicroButton, 'UpdateDisplay', function(self)
    if not ( EncounterJournal and EncounterJournal:IsShown() ) and not AdventureGuideUtil.IsAvailable() then
        self.disabledTooltip = Kiosk.IsEnabled() and '该系统目前已被禁用。' or '该功能尚不可用。'
    end
end)


StoreMicroButton.tooltipText = '商城'
hooksecurefunc(StoreMicroButton, 'UpdateMicroButton', function(self)
    if ( C_StorePublic.IsDisabledByParentalControls() ) then
        self.disabledTooltip = '家长监控已禁用了该功能。'
    elseif ( Kiosk.IsEnabled() ) then
        self.disabledTooltip = '该系统目前已被禁用。'
    elseif ( not C_StorePublic.IsEnabled() ) then
        if not ( GetCurrentRegionName() == "CN" ) then
            self.disabledTooltip = '商城当前不可用。'
        end
    end
end)



QuickJoinToastButton:HookScript('OnEnter', function(self)
    if ( not KeybindFrames_InQuickKeybindMode() ) then
        if ( self.displayedToast ) then
            local queues = C_SocialQueue.GetGroupQueues(self.displayedToast.guid)
            if ( queues ) then
                local knowsLeader = SocialQueueUtil_HasRelationshipWithLeader(self.displayedToast.guid)
                GameTooltip:SetOwner(self.Toast, self.isOnRight and "ANCHOR_LEFT" or "ANCHOR_RIGHT")
                SocialQueueUtil_SetTooltip(GameTooltip, SocialQueueUtil_GetHeaderName(self.displayedToast.guid), queues, true, knowsLeader)
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine('|cnGREEN_FONT_COLOR:<点击加入>')
                GameTooltip:Show()
            end
        else
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            GameTooltip_SetTitle(GameTooltip, MicroButtonTooltipText('社交', "TOGGLESOCIAL"))
            GameTooltip:Show()
        end
    end
end)







--主菜单，按钮
CharacterMicroButton.tooltipText = MicroButtonTooltipText('角色信息', "TOGGLECHARACTER0")--MainMenuBarMicroButtons.lua
CharacterMicroButton:HookScript('OnEvent', function(self, event)
    if ( event == "UPDATE_BINDINGS" ) then
        self.tooltipText = MicroButtonTooltipText('角色信息', "TOGGLECHARACTER0")
    end
end)





















MainMenuBarVehicleLeaveButton:HookScript('OnEnter', function()
    if UnitOnTaxi("player") then
        GameTooltip_SetTitle(GameTooltip, '请求终止')
        GameTooltip:AddLine('将在下一个可用的飞行管理员处着陆。', NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, true)
        GameTooltip:Show()
    else
        GameTooltip_SetTitle(GameTooltip, '退出')
        GameTooltip:Show()
    end
end)