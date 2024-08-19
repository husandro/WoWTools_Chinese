
local id, e= ...



local function Init_Blizzard_WeeklyRewards()
    e.dia("CONFIRM_SELECT_WEEKLY_REWARD", {text = '你一旦选好奖励就不能变更了。|n|n你确定要选择这件物品吗？', button1 = '是', button2 = '取消'})

    e.hookLabel(WeeklyRewardsFrame.RaidFrame.Name)
    e.hookLabel(WeeklyRewardsFrame.MythicFrame.Name)

    e.font(WeeklyRewardsFrame.HeaderFrame.Text)
    

    hooksecurefunc(WeeklyRewardsFrame, 'UpdateOverlay', function(self)--Blizzard_WeeklyRewards.lua
        e.set(self.Overlay.Text)
        e.set(self.Overlay.Title)
    end)

    hooksecurefunc(WeeklyRewardsFrame, 'UpdateTitle', function(self)
        local canClaimRewards = C_WeeklyRewards.CanClaimRewards()
        if canClaimRewards then
            self.HeaderFrame.Text:SetText('你只能从宏伟宝库选择一件奖励。')
        elseif not C_WeeklyRewards.HasInteraction() and C_WeeklyRewards.HasAvailableRewards() then
            self.HeaderFrame.Text:SetText('返回宏伟宝库，获取你的奖励')
        else
            self.HeaderFrame.Text:SetText('每周完成活动可以将物品添加到宏伟宝库中。|n你每周可以选择一件奖励。')
        end
    end)
end

    --[[hooksecurefunc(WeeklyRewardsActivityMixin, 'SetProgressText', function(self, text)
        local activityInfo = self.info;
        local name
        if text then
            name= e.strText[text]
        elseif self.hasRewards then
            
        elseif self.unlocked then
            if activityInfo.type == Enum.WeeklyRewardChestThresholdType.Raid then
                name = e.strText[DifficultyUtil.GetDifficultyName(activityInfo.level)]
                
            elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.Activities then
                if self:IsCompletedAtHeroicLevel() then
                    name= '英雄'
                else
                    name= format('史诗 %d', activityInfo.level);
                end
            elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.RankedPvP then
                name= e.strText[PVPUtil.GetTierName(activityInfo.level)]
            elseif activityInfo.type == Enum.WeeklyRewardChestThresholdType.World then
                name= format('难度 %s', activityInfo.level)
            end
        end
        if name then
            self.Progress:SetText(name);
        end
    end)]]















--挑战, 钥匙插入， 界面
local function Init_Blizzard_ChallengesUI()

    hooksecurefunc(ChallengesFrame, 'UpdateTitle', function()
        local currentDisplaySeason =  C_MythicPlus.GetCurrentUIDisplaySeason()
        if ( not currentDisplaySeason ) then
            PVEFrame:SetTitle('史诗钥石地下城')
        else
            local expName = _G["EXPANSION_NAME"..GetExpansionLevel()]
            local title = format('史诗钥石地下城 %s 赛季 %d', e.strText[expName] or expName, currentDisplaySeason)
            PVEFrame:SetTitle(title)
        end
    end)

    ChallengesFrame.WeeklyInfo.Child.ThisWeekLabel:SetText('本周')
    ChallengesFrame.WeeklyInfo.Child.Description:SetText('在史诗难度下，你每完成一个地下城，都会提升下一个地下城的难度和奖励。\n\n每周你都会根据完成的史诗地下城获得一系列奖励。\n\n要想开始挑战，把你的地下城难度设置为史诗，然后前往任意下列地下城吧。')

    hooksecurefunc(ChallengesFrame.WeeklyInfo.Child.WeeklyChest, 'Update', function(self, bestMapID, dungeonScore)
        if C_WeeklyRewards.HasAvailableRewards() then
            self.RunStatus:SetText('拜访宏伟宝库获取你的奖励！')
        elseif self:HasUnlockedRewards(Enum.WeeklyRewardChestThresholdType.Activities)  then
            self.RunStatus:SetText('完成史诗钥石地下城即可获得：')
        elseif C_MythicPlus.GetOwnedKeystoneLevel() or (dungeonScore and dungeonScore > 0) then
            self.RunStatus:SetText('完成史诗钥石地下城即可获得：')
        end
    end)


    ChallengesFrame.WeeklyInfo.Child.WeeklyChest:HookScript('OnEnter', function(self)
        GameTooltip_SetTitle(GameTooltip, '宏伟宝库奖励')
        if self.state == 4 then--CHEST_STATE_COLLECT
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
        hooksecurefunc(ChallengesKeystoneFrame, 'OnKeystoneSlotted', function(self)
            local mapID, _, powerLevel= C_ChallengeMode.GetSlottedKeystoneInfo()
            if mapID ~= nil then
                local name= C_ChallengeMode.GetMapUIInfo(mapID)
                e.set(self.DungeonName, name)
                self.PowerLevel:SetFormattedText('%d级', powerLevel)
            end
        end)

    e.set(ChallengesFrame.SeasonChangeNoticeFrame.NewSeason)--:SetText('全新赛季！')
    e.hookLabel(ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription)--:SetText('地下城奖励的物品等级已经提升！')
    e.hookLabel(ChallengesFrame.SeasonChangeNoticeFrame.SeasonDescription2)--:SetText('史诗地下城的敌人变得更强了！')

    ChallengesFrame.SeasonChangeNoticeFrame.Leave:SetText('离开')

    --ChallengesFrame.WeeklyInfo.Child.SeasonBest:SetText('赛季最佳')
end




--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
function panel:un_event()
    if C_AddOns.IsAddOnLoaded('Blizzard_WeeklyRewards')
        and C_AddOns.IsAddOnLoaded('Blizzard_ChallengesUI')
    then
        self:UnregisterEvent('ADDON_LOADED')
    end
end
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_WeeklyRewards') then
            Init_Blizzard_WeeklyRewards()
        end
        if C_AddOns.IsAddOnLoaded('Blizzard_ChallengesUI') then
            Init_Blizzard_WeeklyRewards()
        end
        self:un_event()

    elseif arg1=='Blizzard_WeeklyRewards' then
        Init_Blizzard_WeeklyRewards()
        self:un_event()

    elseif arg1=='Blizzard_ChallengesUI' then
        Init_Blizzard_ChallengesUI()
        self:un_event()
    end
end)