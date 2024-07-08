local id, e = ...


--地下城和团队副本, PVP










local function conquestFrameButton_OnEnter(self)--hooksecurefunc('ConquestFrameButton_OnEnter', function(self)--Blizzard_PVPUI.lua
    local tooltip = ConquestTooltip
    local rating, seasonBest, weeklyBest, seasonPlayed, seasonWon, weeklyPlayed, weeklyWon, lastWeeksBest, hasWon, pvpTier, ranking, roundsSeasonPlayed, roundsSeasonWon, roundsWeeklyPlayed, roundsWeeklyWon = GetPersonalRatedInfo(self.bracketIndex)
    tooltip.Title:SetText(e.strText[self.toolTipTitle] or self.toolTipTitle)
    local isSoloShuffle = self.id == 1
    local tierInfo = pvpTier and C_PvP.GetPvpTierInfo(pvpTier)
    local tierName = tierInfo and tierInfo.pvpTierEnum and PVPUtil.GetTierName(tierInfo.pvpTierEnum)
    local hasSpecRank = tierName and ranking and isSoloShuffle
    tierName= e.strText[tierName]
    if tierName then
        if ranking and not hasSpecRank then
            tooltip.Tier:SetFormattedText(PVP_TIER_WITH_RANK_AND_RATING, tierName, ranking, rating)
        else
            tooltip.Tier:SetFormattedText(PVP_TIER_WITH_RATING, tierName, rating)
        end
    end
    local specName= PlayerUtil.GetSpecName()
    tooltip.SpecRank:SetFormattedText(hasSpecRank and format('%s: 等级 #%d', e.cn(specName), ranking) or "")
    tooltip.WeeklyBest:SetText('最高等级：'..weeklyBest)
    tooltip.WeeklyWon:SetText(isSoloShuffle and ('胜利回合：' .. roundsWeeklyWon) or ('赢得比赛：' .. weeklyWon))
    tooltip.WeeklyPlayed:SetText(isSoloShuffle and ('已完成回合：' .. roundsWeeklyPlayed) or ('比赛场次：' .. weeklyPlayed))
    tooltip.SeasonBest:SetText('最高等级：'..seasonBest)
    tooltip.SeasonWon:SetText(isSoloShuffle and ('胜利回合：' .. roundsSeasonWon) or ('赢得比赛：' .. seasonWon))
    tooltip.SeasonPlayed:SetText(isSoloShuffle and ('已完成回合：' .. roundsSeasonPlayed) or ('比赛场次：' .. seasonPlayed))
    local specStats = isSoloShuffle and C_PvP.GetPersonalRatedSoloShuffleSpecStats()
    if specStats then
        tooltip.WeeklyMostPlayedSpec:SetFormattedText('使用最多：%s (%d)', PlayerUtil.GetSpecNameBySpecID(specStats.weeklyMostPlayedSpecID), specStats.weeklyMostPlayedSpecRounds)
        tooltip.SeasonMostPlayedSpec:SetFormattedText('使用最多：%s (%d)',PlayerUtil.GetSpecNameBySpecID(specStats.seasonMostPlayedSpecID), specStats.seasonMostPlayedSpecRounds)
    end
    e.set(self.modeDescription, self.modeDescription)
end





















local function Init()
    hooksecurefunc('PVPQueueFrame_UpdateTitle', function()--Blizzard_PVPUI.lua
        if ConquestFrame.seasonState == 2 then--SEASON_STATE_PRESEASON
            PVEFrame:SetTitle('PvP（季前赛）')
        elseif ConquestFrame.seasonState == 1 then--SEASON_STATE_OFFSEASON
            PVEFrame:SetTitle('玩家VS玩家（休赛期）')
        else
            local expName = _G["EXPANSION_NAME"..GetExpansionLevel()]
            PVEFrame:SetTitleFormatted('玩家VS玩家 '..(e.strText[expName] or expName)..' 第 %d 赛季', PVPUtil.GetCurrentSeasonNumber())
        end
    end)
    PVPQueueFrameCategoryButton1.Name:SetText('快速比赛')
        hooksecurefunc('HonorFrameBonusFrame_Update', function()--Blizzard_PVPUI.lua
            HonorFrame.BonusFrame.RandomBGButton.Title:SetText('随机战场')
            HonorFrame.BonusFrame.RandomEpicBGButton.Title:SetText('随机史诗战场')
            HonorFrame.BonusFrame.Arena1Button.Title:SetText('竞技场练习赛')
        end)
    PVPQueueFrameCategoryButton2.Name:SetText('评级')
    PVPQueueFrameCategoryButton3.Name:SetText('预创建队伍')
    PVPQueueFrame.NewSeasonPopup.Leave:SetText('关闭')

    hooksecurefunc('HonorFrame_UpdateQueueButtons', function()
        local HonorFrame = HonorFrame
        local canQueue
        local arenaID
        local isBrawl
        local isSpecialBrawl
        if ( HonorFrame.type == "specific" ) then
            if ( HonorFrame.SpecificScrollBox.selectionID ) then
                canQueue = true
            end
        elseif ( HonorFrame.type == "bonus" ) then
            if ( HonorFrame.BonusFrame.selectedButton ) then
                canQueue = HonorFrame.BonusFrame.selectedButton.canQueue
                arenaID = HonorFrame.BonusFrame.selectedButton.arenaID
                isBrawl = HonorFrame.BonusFrame.selectedButton.isBrawl
                isSpecialBrawl = HonorFrame.BonusFrame.selectedButton.isSpecialBrawl
            end
        end

        local disabledReason

        if arenaID then
            local battlemasterListInfo = C_PvP.GetSkirmishInfo(arenaID)
            if battlemasterListInfo then
                local groupSize = GetNumGroupMembers()
                local minPlayers = battlemasterListInfo.minPlayers
                local maxPlayers = battlemasterListInfo.maxPlayers
                if groupSize > maxPlayers then
                    canQueue = false
                    disabledReason = format('要进入该竞技场，你的团队需要减少%d名玩家。', groupSize - maxPlayers)
                elseif groupSize < minPlayers then
                    canQueue = false
                    disabledReason = format('要进入该竞技场，你的团队需要增加%d名玩家。', minPlayers - groupSize)
                end
            end
        end

        if (isBrawl or isSpecialBrawl) and not canQueue then
            if IsInGroup(LE_PARTY_CATEGORY_HOME) then
                local brawlInfo = isSpecialBrawl and C_PvP.GetSpecialEventBrawlInfo() or C_PvP.GetAvailableBrawlInfo() or {}
                if brawlInfo then
                    disabledReason = format('你的小队未满足最低等级要求（%s）。', isSpecialBrawl and brawlInfo.minLevel or GetMaxLevelForPlayerExpansion())
                end
            else
                disabledReason = '你的级别不够。'
            end
        end

        if isBrawl or isSpecialBrawl and canQueue then
            local brawlInfo = isSpecialBrawl and C_PvP.GetSpecialEventBrawlInfo() or C_PvP.GetAvailableBrawlInfo() or {}
            local brawlHasMinItemLevelRequirement = brawlInfo and brawlInfo.brawlType == Enum.BrawlType.SoloRbg
            if (IsInGroup(LE_PARTY_CATEGORY_HOME)) then
                if(brawlInfo and not brawlInfo.groupsAllowed) then
                    canQueue = false
                    disabledReason = '你不能在队伍中那样做。'
                end
                if (brawlHasMinItemLevelRequirement and brawlInfo.groupsAllowed) then
                    local brawlMinItemLevel = brawlInfo.minItemLevel
                    local partyMinItemLevel, playerWithLowestItemLevel = C_PartyInfo.GetMinItemLevel(Enum.AvgItemLevelCategories.PvP)
                    if (UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME) and partyMinItemLevel < brawlMinItemLevel) then
                        canQueue = false
                        disabledReason = format('"%1$s需要更高的平均装备物品等级。（需要：%2$d。当前%3$d。）', playerWithLowestItemLevel, brawlMinItemLevel, partyMinItemLevel)
                    end
                end
            end
            local _, _, playerPvPItemLevel = GetAverageItemLevel()
            if (brawlHasMinItemLevelRequirement and playerPvPItemLevel < brawlInfo.minItemLevel) then
                canQueue = false
                disabledReason = format('你需要更高的PvP装备物品平均等级才能加入队列。|n（需要 %2$d，当前%3$d。）', brawlInfo.minItemLevel, playerPvPItemLevel)
            end
        end
        if not disabledReason then
            if ( select(2,C_LFGList.GetNumApplications()) > 0 ) then
                disabledReason = '你不能在拥有有效的预创建队伍申请时那样做。'
                canQueue = false
            elseif ( C_LFGList.HasActiveEntryInfo() ) then
                disabledReason = '你不能在你的队伍出现在预创建队伍列表中时那样做。'
                canQueue = false
            end
        end
        local isInCrossFactionGroup = C_PartyInfo.IsCrossFactionParty()
        if ( canQueue ) then
            if ( IsInGroup(LE_PARTY_CATEGORY_HOME) ) then
                HonorFrame.QueueButton:SetText('小队加入')
                if (not UnitIsGroupLeader("player", LE_PARTY_CATEGORY_HOME)) then
                    disabledReason = '你现在不是队长'
                elseif(isInCrossFactionGroup) then
                    if isBrawl or isSpecialBrawl then
                        local brawlInfo = isSpecialBrawl and C_PvP.GetSpecialEventBrawlInfo() or C_PvP.GetAvailableBrawlInfo()
                        local allowCrossFactionGroups = brawlInfo and brawlInfo.brawlType == Enum.BrawlType.SoloRbg
                        if (not allowCrossFactionGroups) then
                            disabledReason ='在跨阵营队伍中无法这么做。你可以参加竞技场或者评级战场。'
                        end
                    end
                end
            else
                HonorFrame.QueueButton:SetText('加入战斗')
            end
        else
            if (HonorFrame.type == "bonus" and HonorFrame.BonusFrame.selectedButton and HonorFrame.BonusFrame.selectedButton.queueID) then
                if not disabledReason then
                    disabledReason = LFGConstructDeclinedMessage(HonorFrame.BonusFrame.selectedButton.queueID)
                end
            end
        end
        HonorFrame.QueueButton.tooltip = disabledReason
    end)

    hooksecurefunc('PVPConquestLockTooltipShow', function()
        GameTooltip:SetText(string.format('该功能将在%d级开启。', GetMaxLevelForLatestExpansion()))
        GameTooltip:Show()
    end)

    PVPQueueFrame.HonorInset.CasualPanel:HookScript('OnShow', function(self)
        if self.HKLabel:IsShown() then
            self.HKLabel:SetText('宏伟宝库')
        end
    end)
    PVPQueueFrame.HonorInset.CasualPanel.HKLabel:SetText('宏伟宝库')
    PVPQueueFrame.HonorInset.CasualPanel.WeeklyChest:HookScript('OnEnter', function()
        if not ConquestFrame_HasActiveSeason() then
            GameTooltip_SetTitle(GameTooltip, '宏伟宝库奖励')
            GameTooltip_AddDisabledLine(GameTooltip, '无效会阶')
            GameTooltip_AddNormalLine(GameTooltip, '征服点数只能在PvP赛季开启期间获得。')
            GameTooltip:Show()
        else
            local weeklyProgress = C_WeeklyRewards.GetConquestWeeklyProgress()
            local unlocksCompleted = weeklyProgress.unlocksCompleted or 0
            local maxUnlocks = weeklyProgress.maxUnlocks or 3
            local description
            if unlocksCompleted > 0 then
                description = format('通过评级PvP获得获得荣誉点数以解锁宏伟宝库的奖励。你的奖励的物品等级会以你本周胜场的最高段位为基准。\n\n%s/%s奖励已解锁。', unlocksCompleted, maxUnlocks)
            else
                description = format('通过评级PvP获得获得荣誉点数以解锁宏伟宝库的奖励。你的奖励的物品等级会以你本周胜场的最高段位为基准。\n\n%s/%s奖励已解锁。', unlocksCompleted, maxUnlocks)
            end
            GameTooltip_SetTitle(GameTooltip, '宏伟宝库奖励')
            local hasRewards = C_WeeklyRewards.HasAvailableRewards()
            if hasRewards then
                GameTooltip_AddColoredLine(GameTooltip, '宏伟宝库里有奖励在等待着你。', GREEN_FONT_COLOR)
                GameTooltip_AddBlankLineToTooltip(GameTooltip)
            end
            GameTooltip_AddNormalLine(GameTooltip, description)
            GameTooltip_AddInstructionLine(GameTooltip, '点击预览宏伟宝库')
            GameTooltip:Show()
        end
    end)

    hooksecurefunc(PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay, 'Update', function(self)
        local honorLevel = UnitHonorLevel("player")
        self.LevelLabel:SetFormattedText('荣誉等级 %d', honorLevel)
    end)
    PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay:HookScript('OnEnter', function()
        GameTooltip_SetTitle(GameTooltip, '生涯荣誉')
        GameTooltip_AddColoredLine(GameTooltip, '所有角色获得的荣誉。', NORMAL_FONT_COLOR)
        GameTooltip_AddBlankLineToTooltip(GameTooltip)
        local currentHonor = UnitHonor("player")
        local maxHonor = UnitHonorMax("player")
        GameTooltip_AddColoredLine(GameTooltip, string.format('%d / %d', currentHonor, maxHonor), HIGHLIGHT_FONT_COLOR)
        GameTooltip:Show()
    end)
    PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay.NextRewardLevel:HookScript('OnEnter', function(self)
        local honorLevel = UnitHonorLevel("player")
        local nextHonorLevelForReward = C_PvP.GetNextHonorLevelForReward(honorLevel)
        local rewardInfo = nextHonorLevelForReward and C_PvP.GetHonorRewardInfo(nextHonorLevelForReward)
        if rewardInfo then
            local rewardText = select(11, GetAchievementInfo(rewardInfo.achievementRewardedID))
            if rewardText and rewardText ~= "" then
                GameTooltip:SetText(format('到达荣誉等级%d级后可获得下一个奖励', nextHonorLevelForReward))
                local WRAP = true
                GameTooltip_AddColoredLine(GameTooltip, rewardText, HIGHLIGHT_FONT_COLOR, WRAP)
                GameTooltip:Show()
            end
        end
    end)

    BONUS_BUTTON_TOOLTIPS.RandomBG.func= function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText('随机战场', 1, 1, 1)
        GameTooltip:AddLine('在随机战场上与敌对阵营竞争。', nil, nil, nil, true)
        GameTooltip:Show()
    end
    BONUS_BUTTON_TOOLTIPS.EpicBattleground.func = function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText('随机史诗战场', 1, 1, 1)
        GameTooltip:AddLine('在40人的大型战场上与敌对阵营竞争。', nil, nil, nil, true)
        GameTooltip:Show()
    end

    --role_tooltips('HonorFrame')
    ConquestJoinButton:SetText('加入战斗')




    if ConquestFrame.Arena2v2 then
        ConquestFrame.Arena2v2:HookScript('OnEnter', conquestFrameButton_OnEnter)
    end
    if ConquestFrame.Arena3v3 then
        ConquestFrame.Arena3v3:HookScript('OnEnter', conquestFrameButton_OnEnter)
    end
    if ConquestFrame.RatedBG then
        ConquestFrame.RatedBG:HookScript('OnEnter', conquestFrameButton_OnEnter)
    end

    ---hooksecurefunc('HonorFrame_UpdateQueueButtons', function()
end
















--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if arg1==id then
        if C_AddOns.IsAddOnLoaded('Blizzard_PVPUI') then
            Init()
            self:UnregisterEvent('Blizzard_PVPUI')
        end

    elseif arg1=='Blizzard_PVPUI' then
        Init()
        self:UnregisterEvent('Blizzard_PVPUI')
    end
end)
