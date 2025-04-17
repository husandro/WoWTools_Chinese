




function WoWTools_ChineseMixin.Events:Blizzard_WeeklyRewards()
    WoWTools_ChineseMixin:AddDialogs("CONFIRM_SELECT_WEEKLY_REWARD", {text = '你一旦选好奖励就不能变更了。|n|n你确定要选择这件物品吗？', button1 = '是', button2 = '取消'})

    WoWTools_ChineseMixin:HookLabel(WeeklyRewardsFrame.RaidFrame.Name)
    WoWTools_ChineseMixin:HookLabel(WeeklyRewardsFrame.MythicFrame.Name)

    WoWTools_ChineseMixin:SetCNFont(WeeklyRewardsFrame.HeaderFrame.Text)


    hooksecurefunc(WeeklyRewardsFrame, 'UpdateOverlay', function(frame)--Blizzard_WeeklyRewards.lua
        if frame.Overlay then
            WoWTools_ChineseMixin:SetLabel(frame.Overlay.Text)
            WoWTools_ChineseMixin:SetLabel(frame.Overlay.Title)
        end
    end)


    hooksecurefunc(WeeklyRewardsFrame, 'UpdateTitle', function(frame)
        local canClaimRewards = C_WeeklyRewards.CanClaimRewards()
        if canClaimRewards then
            frame.HeaderFrame.Text:SetText('你只能从宏伟宝库选择一件奖励。')
        elseif not C_WeeklyRewards.HasInteraction() and C_WeeklyRewards.HasAvailableRewards() then
            frame.HeaderFrame.Text:SetText('返回宏伟宝库，获取你的奖励')
        else
            frame.HeaderFrame.Text:SetText('每周完成活动可以将物品添加到宏伟宝库中。|n你每周可以选择一件奖励。')
        end
    end)
end

    --[[hooksecurefunc(WeeklyRewardsActivityMixin, 'SetProgressText', function(frame, text)
        local activityInfo = frame.info;
        local name
        if text then
            name= WoWTools_ChineseMixin:CN(text)
        elseif frame.hasRewards then
            
        elseif frame.unlocked then
            if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
                name = WoWTools_ChineseMixin:CN(DifficultyUtil.GetDifficultyName(activityInfo.level))
                
            elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.Activities then
                if frame:IsCompletedAtHeroicLevel() then
                    name= '英雄'
                else
                    name= format('史诗 %d', activityInfo.level);
                end
            elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
                name= WoWTools_ChineseMixin:CN(PVPUtil.GetTierName(activityInfo.level))
            elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.World then
                name= format('难度 %s', activityInfo.level)
            end
        end
        if name then
            frame.Progress:SetText(name);
        end
    end)]]















--挑战, 钥匙插入， 界面
function WoWTools_ChineseMixin.Events:Blizzard_ChallengesUI()

    hooksecurefunc(ChallengesFrame, 'UpdateTitle', function()
        local currentDisplaySeason =  C_MythicPlus.GetCurrentUIDisplaySeason()
        if ( not currentDisplaySeason ) then
            PVEFrame:SetTitle('史诗钥石地下城')
        else
            local expName = _G["EXPANSION_NAME"..GetExpansionLevel()]
            local title = format('史诗钥石地下城 %s 赛季 %d', WoWTools_ChineseMixin:CN(expName) or expName, currentDisplaySeason)
            PVEFrame:SetTitle(title)
        end
    end)

    ChallengesFrame.WeeklyInfo.Child.ThisWeekLabel:SetText('本周')
    ChallengesFrame.WeeklyInfo.Child.Description:SetText('在史诗难度下，你每完成一个地下城，都会提升下一个地下城的难度和奖励。\n\n每周你都会根据完成的史诗地下城获得一系列奖励。\n\n要想开始挑战，把你的地下城难度设置为史诗，然后前往任意下列地下城吧。')

    hooksecurefunc(ChallengesFrame.WeeklyInfo.Child.WeeklyChest, 'Update', function(frame, bestMapID, dungeonScore)
        if C_WeeklyRewards.HasAvailableRewards() then
            frame.RunStatus:SetText('拜访宏伟宝库获取你的奖励！')
        elseif frame:HasUnlockedRewards(Enum.WeeklyRewardChestThresholdType.Activities)  then
            frame.RunStatus:SetText('完成史诗钥石地下城即可获得：')
        elseif C_MythicPlus.GetOwnedKeystoneLevel() or (dungeonScore and dungeonScore > 0) then
            frame.RunStatus:SetText('完成史诗钥石地下城即可获得：')
        end
    end)


    ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript('OnEnter', function(frame)
        GameTooltip_SetTitle(GameTooltip, '宏伟宝库奖励')
        if frame.state == 4 then--CHEST_STATE_COLLECT
            GameTooltip_AddColoredLine(GameTooltip, '宏伟宝库里有奖励在等待着你。', GREEN_FONT_COLOR)
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
        end
        local lastCompletedActivityInfo, nextActivityInfo = WeeklyRewardsUtil.GetActivitiesProgress()
        if not lastCompletedActivityInfo then
            GameTooltip_AddNormalLine(GameTooltip, '在本周内完成一个满级英雄或史诗地下城可以解锁一个宏伟宝库奖励。时空漫游地下城算作英雄地下城。|n|n你的奖励的物品等级会以你本周最高等级的成绩为依据。')
        else
            if nextActivityInfo then
                local globalString = (lastCompletedActivityInfo.index == 1) and '再完成%1$d个满级英雄或史诗地下城可以解锁第二个宏伟宝库奖励。时空漫游地下城算作英雄地下城。' or '再完成%1$d个满级英雄或史诗地下城可以解锁第三个宏伟宝库奖励。时空漫游地下城算作英雄地下城。'
                GameTooltip_AddNormalLine(GameTooltip, globalString:format(nextActivityInfo.threshold - nextActivityInfo.progress))
            else
                GameTooltip_AddNormalLine(GameTooltip, '你已经解锁了本周可提供的所有奖励。在下周开始时拜访宏伟宝库，从你解锁的奖励里进行选择！')
                GameTooltip_AddBlankLineToTooltip(GameTooltip)
                GameTooltip_AddColoredLine(GameTooltip, '提升你的奖励', GREEN_FONT_COLOR)
                local level, count = WeeklyRewardsUtil.GetLowestLevelInTopDungeonRuns(lastCompletedActivityInfo.threshold)
                if level == WeeklyRewardsUtil.HeroicLevel then
                    GameTooltip_AddNormalLine(GameTooltip, format('完成%1$d次史诗难度的地下城，提升你的奖励。', count))
                else
                    local nextLevel = WeeklyRewardsUtil.GetNextMythicLevel(level)
                    GameTooltip_AddNormalLine(GameTooltip, format('完成%1$d个%2$d级或更高的史诗地下城可以提升你的奖励。', count, nextLevel))
                end
            end
        end
        GameTooltip_AddInstructionLine(GameTooltip, '点击预览宏伟宝库')
        GameTooltip:Show()
    end)

    ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo.Title:SetText('史诗钥石评分')
    ChallengesFrame.WeeklyInfo.Child.DungeonScoreInfo:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '史诗钥石评分')
        GameTooltip_AddNormalLine(GameTooltip, '基于你在每个地下城的最佳成绩得出的总体评分。你可以通过更迅速地完成地下城或者完成更高难度的地下城来提高你的评分。|n|n提升你的史诗地下城评分后，你就能把你的地下城装备升级到最高等级。|n|cff1eff00<Shift+点击以链接到聊天栏>|r')
        GameTooltip:Show()
    end)


    CHALLENGE_MODE_EXTRA_AFFIX_INFO["dmg"].name= '额外伤害'
    CHALLENGE_MODE_EXTRA_AFFIX_INFO["dmg"].desc = '敌人的伤害值提高%d%%'
    CHALLENGE_MODE_EXTRA_AFFIX_INFO["health"].name= '额外生命值'
    CHALLENGE_MODE_EXTRA_AFFIX_INFO["health"].desc = '敌人的生命值提高%d%%'
    ChallengesKeystoneFrame.StartButton:SetText('激活')
    ChallengesKeystoneFrame.Instructions:SetText('插入史诗钥石')
        hooksecurefunc(ChallengesKeystoneFrame, 'OnKeystoneSlotted', function(frame)
            local mapID, _, powerLevel= C_ChallengeMode.GetSlottedKeystoneInfo()
            if mapID ~= nil then
                local name= C_ChallengeMode.GetMapUIInfo(mapID)
                WoWTools_ChineseMixin:SetLabel(frame.DungeonName, name)
                frame.PowerLevel:SetFormattedText('%d级', powerLevel)
            end
        end)

    WoWTools_ChineseMixin:SetLabel(ChallengesFrame.SeasonChangeNoticeFrame.NewSeason)--:SetText('全新赛季！')
    WoWTools_ChineseMixin:HookLabel(ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription)--:SetText('地下城奖励的物品等级已经提升！')
    WoWTools_ChineseMixin:HookLabel(ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription2)--:SetText('史诗地下城的敌人变得更强了！')

    ChallengesFrame.SeasonChangeNoticeFrame.Leave:SetText('离开')

    --ChallengesFrame.WeeklyInfo.Child.SeasonBest:SetText('赛季最佳')
end



















--地下堡
function WoWTools_ChineseMixin.Events:Blizzard_DelvesDashboardUI()
    local function HasActiveSeason()
        local num= C_DelvesUI.GetCurrentDelvesSeasonNumber()
        return num and num>0
    end

    hooksecurefunc(DelvesDashboardFrame, 'UpdateTitles', function(frame)
        local currExpID = GetExpansionLevel()
        local expName = WoWTools_ChineseMixin:CN(_G["EXPANSION_NAME"..currExpID])
        if HasActiveSeason()  then
            PVEFrame:SetTitle('地下堡')
            frame.ReputationBarTitle:SetText('地下堡行者的旅程（赛季期间可用）')
        else
            PVEFrame:SetTitle(format('%s（%s第%s赛季）', '地下堡', expName, num))
            frame.ReputationBarTitle:SetText(format('地下堡行者的旅程（%s第%s赛季）', expName, num))
        end
    end)

    --DelvesDashboardFrame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel
    --CompanionConfigButtonPanelMixin
    --hooksecurefunc(CompanionConfigButtonPanelMixin, 'OnShow', function(frame)
    DelvesDashboardFrame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel:HookScript('OnShow', function(frame)
        local companionFactionID = C_DelvesUI.GetFactionForCompanion()
        local companionFactionInfo = companionFactionID and C_Reputation.GetFactionDataByID(companionFactionID)
        if companionFactionInfo then
            local name= WoWTools_ChineseMixin:CN(companionFactionInfo.name)
            if name then
                frame.PanelTitle:SetText(name)
            end
            frame.PanelDescription:SetText('地下堡伙伴')
        else
            frame.PanelTitle:SetText('地下堡伙伴')
        end
    end)

    DelvesDashboardFrame.ButtonPanelLayoutFrame.GreatVaultButtonPanel:HookScript('OnShow', function(frame)
        frame.PanelTitle:SetText('宏伟宝库')
        if not HasActiveSeason() then
            frame.PanelDescription:SetText('赛季期间可用')
        else
            frame.PanelDescription:SetText('完成地下堡获取每周奖励')
        end
    end)
    WoWTools_ChineseMixin:SetLabel(DelvesDashboardFrame.ButtonPanelLayoutFrame.CompanionConfigButtonPanel.CompanionConfigButton.ButtonText)



end







--[[
    C_DelvesUI.GetTraitTreeForCompanion()
]]
function WoWTools_ChineseMixin.Events:Blizzard_DelvesCompanionConfiguration()
    self:SetRegions(DelvesCompanionConfigurationFrame.CompanionConfigShowAbilitiesButton)

--第一个栏， 伙伴
    hooksecurefunc(DelvesCompanionConfigurationFrame.CompanionInfoFrame, 'Refresh', function(frame)
        local companionInfo = DelvesCompanionConfigurationFrame.companionInfo
        if companionInfo then
            local name= WoWTools_ChineseMixin:CN(companionInfo.name)
            if name then
                frame.CompanionName:SetText(name)
            end
            local desc= WoWTools_ChineseMixin:CN(companionInfo.description)
            if desc then
                frame.CompanionDescription:SetText(desc)
            end
        end
    end)

--第二个栏 CompanionConfigSlotTemplateMixin
    hooksecurefunc(DelvesCompanionConfigurationFrame.CompanionCombatTrinketSlot, 'Refresh', function(frame)
        self:SetLabel(frame.Label)
        if frame.selectionNodeInfo then
            if not frame.selectionNodeInfo.isVisible then
                self:SetLabel(frame.Value)
            elseif frame:HasSelectionAndInfo() then
                self:SetLabel(frame.Value)
            else
                frame.Value:SetText(GREEN_FONT_COLOR:WrapTextInColorCode('空置'))
            end
        end
    end)

--第三个栏 CompanionConfigSlotTemplateMixin 
    hooksecurefunc(DelvesCompanionConfigurationFrame.CompanionUtilityTrinketSlot, 'Refresh', function(frame)
        self:SetLabel(frame.Label)
        if frame.selectionNodeInfo then
            if not frame.selectionNodeInfo.isVisible then
                self:SetLabel(frame.Value)
            elseif frame:HasSelectionAndInfo() then
                self:SetLabel(frame.Value)
            else
                frame.Value:SetText(GREEN_FONT_COLOR:WrapTextInColorCode('空置'))
            end
        end
    end)

--职业 CompanionConfigSlotTemplateMixin
    hooksecurefunc(DelvesCompanionConfigurationFrame.CompanionCombatRoleSlot, 'Refresh', function(frame)
        self:SetLabel(frame.Label)
        self:SetLabel(frame.Value)
    end)


--技能
    self:SetLabel(DelvesCompanionAbilityListFrameTitleText)
    hooksecurefunc(DelvesCompanionAbilityMixin, 'InitAdditionalElements', function(frame)
        local name= frame:GetName()
        local text= self:GetData(name, {spellID=frame:GetSpellID(), isName=true})
        if text~=name and text then
            frame.Name:SetText(text)
        end
        if frame.locked  then
            self:SetLabel(frame.UnlockCondition)
        else
            if frame.nodeInfo.maxRanks > 1 then
                frame.Rank:SetFormattedText('等级 %d', frame.nodeInfo.currentRank)
            end
        end
    end)
end