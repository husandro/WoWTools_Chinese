


--地下城和团队副本, PVP
--PvP查找器



--[[
[ID]= {Name_lang, Description_lang, Objective_lang}
https://wago.tools/db2/PvpBrawl?build=11.0.2.55399&locale=zhCN
]]
local brawlTab={

[2]= {"乱斗：南海镇VS塔伦米尔", "团队死斗", "- 击杀敌方玩家可以获得点数|n- 荣誉击杀可以提高你的军衔|n- 击杀高级军衔的玩家可以获得更多点数"},
[3]= {"乱斗：魔古接力", "能量宝珠", "- 急速提高|n- 移动速度提高|n- 复活时间缩短"},
[4]= {"乱斗：引力失效", "占领模式（飞腾）", "- 周期性发生重力变化|n- 旗帜携带者的重力增加|n- 其他所有玩家的重力减轻"},
[5]= {"乱斗：阿拉希暴风雪", "占领模式（冰霜）", "- 占领目标|n- 能见度下降|n- 冰冻地形"},
[6]= {"乱斗：深风大灌篮", "大灌篮", "- 拾取矿井的球|n- 将球带到敌方基地|n- 投球或者灌篮"},
[7]= {"乱斗：号角之眼", "占领模式（山羊）", "- 骑乘山羊坐骑！|n- 你的山羊有击退技能|n- 距离越远，击退越强"},
[8]= {"乱斗：爆棚乱战", "15v15竞技场", "- 团队死斗|n- 每队15名玩家|n- 最后存活的团队获胜"},
[9]= {"乱斗：战歌争夺战", "夺旗", "- 每支队伍拥有数面旗帜|n- 只需一面旗帜即可占领|n- 可获得随机增益效果箱子"},
[10]= {"乱斗：决战影踪派", "5v5竞技场", "- 5v5竞技场|n- 击败对方的魔古首领后获胜|n- 收集召唤出的箱子以获取强化能力"},
[11]= {"乱斗：六人战", "6v6战场", "- 每队6人|n- 全新游戏模式"},
[12]= {"乱斗：六人战-吉尔尼斯之战", "6v6战场", "- 每队6人|n- 全新游戏模式"},
[13]= {"乱斗：六人战-战歌峡谷", "6v6战场", "- 每队6人|n- 全新游戏模式"},
[14]= {"乱斗：六人战-碎银矿脉", "6v6战场", "- 每队6人|n- 全新游戏模式"},
[15]= {"乱斗：六人战-寇魔古寺", "6v6战场", "- 每队6人|n- 全新游戏模式"},
[16]= {"乱斗：六人战-风暴之眼", "6v6战场", "- 每队6人|n- 全新游戏模式"},
[17]= {"乱斗：碟中碟", "收集竞速", "- 在农场里收集材料，交给厨师|n- 先收集到足够材料的一方获胜！|n- 击败敌对阵营的重击者可以让他们加入己方"},
[18]= {"乱斗：熙攘乱战", "团队死斗", "- 小队死斗|n- 每队3名玩家|n- 每队前两次死亡的玩家会立刻复活"},
[19]= {"涌泉海滩", "收集艾泽里特", "菲拉斯近海一座被遗忘的神秘海岛上发现了大量的艾泽里特，如今那里被称作涌泉海滩。"},
[120]= {"乱斗：经典阿什兰", "无尽史诗战场", "- 阿什兰的战斗永不终结！|n- 消灭敌方阵营首领，完成事件以获取奖励|n- 从生物身上获取神器碎片并上交，为你的阵营提供增益效果"},
[121]= {"乱斗：人机对决", "占领模式", "- 占领目标|n- 消灭敌人|n- 胜利"},
[122]= {"冬拥湖", "防守或突袭冬拥湖", "- 防守方需要守住冬拥堡垒|n- 进攻方需要摧毁冬拥堡垒最后的一面墙"},
[123]= {"乱斗：繁盛海岛", "10v10海岛", "我们需要更大的船……"},
[124]= {"科尔拉克的复仇", "魔兽世界周年庆典", "- 体验最古老的奥特兰克山谷|n- 消灭血怒者科尔拉克并击退巨魔入侵！|n- 完成任务和目标，获取奖励"},
[125]= {"深风峡谷", "占领目标", "- 占领并守卫目标|n- 获得1500份资源"},
[126]= {"乱斗：科尔拉克的复仇", "奥特兰克山谷（经典）", "- 体验最古老的奥特兰克山谷|n- 消灭血怒者科尔拉克并击退巨魔入侵！|n- 完成任务和目标，获取奖励"},
[130]= {"单排轮斗", "轮换队伍的竞技场匹配构成", "- 6名玩家打6轮3v3的竞技场比赛|n- 每轮结束后轮换队伍|n- 只限玩家单排加入"},
[132]= {"单排轮斗：迷阵竞技场", "轮换队伍的竞技场匹配构成", "- 6名玩家打6轮3v3的竞技场比赛|n- 每轮结束后轮换队伍|n- 只限玩家单排加入"},
[133]= {"乱斗：引爆深风峡谷", "搜索并毁灭", "-在集市上拾起炸弹|n-护送炸弹到基地|n-放置并防御"},
[136]= {"乱斗：战场闪电战", "战场闪电战", "- 单排，除了治疗者可以双排|n- 每队8人|n- 与双方阵营成员一同作战|n- 全体坐骑速度提升|n- 更快节奏的游戏模式"},
[137]= {"乱斗：战场闪电战-战歌峡谷", "战场闪电战", nil},
[138]= {"乱斗：战场闪电战-双子峰", "战场闪电战", nil},
[139]= {"乱斗：战场闪电战-吉尔尼斯之战", "战场闪电战", nil},
[140]= {"乱斗：战场闪电战-碎银矿脉", "战场闪电战", nil},
[141]= {"乱斗：战场闪电战-寇魔古寺", "战场闪电战", nil},
[142]= {"乱斗：战场闪电战-深风峡谷", "战场闪电战", nil},
[143]= {"乱斗：战场闪电战-阿拉希盆地", "战场闪电战", nil},
[144]= {"乱斗：战场闪电战-风暴之眼", "战场闪电战", nil},
[145]= {"乱斗：白热缠斗", "3v3竞技场", "- 3v3竞技场|n- 削减敌方玩家的生命值到低血量时，你的队伍造成的伤害会提升|n- 治疗者获得一个水壶，可以在战斗中回复法力值"},
[147]= {"乱斗：战场闪电战——御渊溪谷", "战场闪电战", nil},
[148]= {"御渊溪谷", "御渊溪谷", nil},

}

























































--快速比赛
local function Init_HonorFrame()
    --按钮，列表, OnEnter
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
    HonorFrame.BonusFrame.Arena1Button:SetScript('OnEnter', function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText('练习赛', 1, 1, 1)
		GameTooltip:AddLine('- 2v2或3v3死斗大赛|n- 站到最后的队伍获胜|n- 治疗者只能参与3v3比赛', nil, nil, nil, true)
		GameTooltip:Show()
    end)
    hooksecurefunc(GameTooltip, 'SetPvpBrawl', function(_, specialBrawl)
        local brawlInfo= specialBrawl and C_PvP.GetSpecialEventBrawlInfo() or C_PvP.GetAvailableBrawlInfo()
        local data= brawlInfo and brawlTab[brawlInfo.brawlID]
        if data then
            GameTooltip:AddLine(' ')
            if data[1] then
                GameTooltip:AddLine(data[1], 1,1,1)
            end
            if data[1] then
                GameTooltip:AddLine(data[2])
            end
            if data[1] then
                GameTooltip:AddLine(data[3])
            end
            GameTooltip:Show()
        end
    end)



    --按钮，列表，标题
    hooksecurefunc('HonorFrameBonusFrame_Update', function()
        HonorFrame.BonusFrame.RandomBGButton.Title:SetText('随机战场')
        HonorFrame.BonusFrame.RandomEpicBGButton.Title:SetText('随机史诗战场')
        HonorFrame.BonusFrame.Arena1Button.Title:SetText('竞技场练习赛')

        local brawlInfo = C_PvP.GetAvailableBrawlInfo()
        local name
        if (brawlInfo and brawlInfo.canQueue) then
            local data= brawlTab[brawlInfo.brawlID]
            name = data and data[1] or WoWTools_ChineseMixin:CN(brawlInfo.name)
        else
            local timeUntilNext = brawlInfo and brawlInfo.timeLeftUntilNextChange or 0
            if (timeUntilNext == 0) then
                name= '乱斗（已关闭）'
            else
                name= format('乱斗（新的乱斗将在%s后开始）', SecondsToTime(timeUntilNext, false, false, 1))
            end
        end
        if name then
            HonorFrame.BonusFrame.BrawlButton.Title:SetText(name)
        end

        brawlInfo = C_PvP.GetSpecialEventBrawlInfo()
        local specName
        if (brawlInfo) then
            if (brawlInfo and brawlInfo.canQueue) then
                local data= brawlTab[brawlInfo.brawlID]
                specName = data and data[1] or WoWTools_ChineseMixin:CN(brawlInfo.name)
            else
                specName= '乱斗（已关闭）'
            end
        end
        if specName then
            HonorFrame.BonusFrame.BrawlButton2.Title:SetText(specName)
        end
    end)




    --加入战斗，按钮
    hooksecurefunc('HonorFrame_UpdateQueueButtons', function()
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





    --宏伟宝库
    WoWTools_ChineseMixin:HookLabel(PVPQueueFrame.HonorInset.CasualPanel.HKLabel)
if PVPQueueFrame.HonorInset.CasualPanel.WeeklyChest then
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
end


    --荣誉等级
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

    --随机战场，指定
    hooksecurefunc('HonorFrame_InitSpecificButton', function(self, data)
        WoWTools_ChineseMixin:SetLabelText(self.NameText, data.localizedName)
        WoWTools_ChineseMixin:SetLabelText(self.InfoText, data.gameType)
        if self.set_enter then
            return
        end
        self.set_enter=true
        self:HookScript('OnEnter', function(frame)
            local info= brawlTab[frame.bgID] or {}
            if info[2] or info[3] then
                GameTooltip:AddLine(' ')
                GameTooltip:AddLine(info[2])
                GameTooltip:AddLine(info[3])
                GameTooltip:Show()
            end
        end)
    end)
end









































local function conquestFrameButton_OnEnter(self)--hooksecurefunc('ConquestFrameButton_OnEnter', function(self)--Blizzard_PVPUI.lua
    local tooltip = ConquestTooltip

	local rating, seasonBest, weeklyBest, seasonPlayed, seasonWon, weeklyPlayed, weeklyWon, lastWeeksBest, hasWon, pvpTier, ranking, roundsSeasonPlayed, roundsSeasonWon, roundsWeeklyPlayed, roundsWeeklyWon = GetPersonalRatedInfo(self.bracketIndex)

	WoWTools_ChineseMixin:SetLabelText(tooltip.Title, self.toolTipTitle)

	local isSoloShuffle = self.id == 1--RATED_SOLO_SHUFFLE_BUTTON_ID
	local isRatedBGBlitz = self.id == 2--RATED_BG_BLITZ_BUTTON_ID
	local tierInfo = pvpTier and C_PvP.GetPvpTierInfo(pvpTier)
	local tierName = tierInfo and tierInfo.pvpTierEnum and PVPUtil.GetTierName(tierInfo.pvpTierEnum)
	local hasSpecRank = tierName and ranking and (isSoloShuffle or isRatedBGBlitz)
	if tierName then
        tierName= WoWTools_ChineseMixin:Setup(tierName)
		if ranking and not hasSpecRank then
			tooltip.Tier:SetFormattedText('"%1$s  #%2$d (%3$d)', tierName, ranking, rating)
		else
			tooltip.Tier:SetFormattedText('%1$s (%2$d)', tierName, rating)
		end
	end
    if hasSpecRank and ranking then
	    tooltip.SpecRank:SetFormattedText('%s: 等级 #%d', WoWTools_ChineseMixin:Setup(PlayerUtil.GetSpecName()) or '', ranking)
	end
	
	tooltip.WeeklyBest:SetText('最高等级：'..weeklyBest)
	tooltip.WeeklyWon:SetText(isSoloShuffle and ('胜利回合：' .. roundsWeeklyWon) or ('赢得比赛：' .. weeklyWon))
	tooltip.WeeklyPlayed:SetText(isSoloShuffle and ('已完成回合：' .. roundsWeeklyPlayed) or ('比赛场次：' .. weeklyPlayed))

	tooltip.SeasonBest:SetText('最高等级：'..seasonBest)
	tooltip.SeasonWon:SetText(isSoloShuffle and ('胜利回合：' .. roundsSeasonWon) or ('赢得比赛：' .. seasonWon))
	tooltip.SeasonPlayed:SetText(isSoloShuffle and ('已完成回合：' .. roundsSeasonPlayed) or ('比赛场次：' .. seasonPlayed))

	local specStats = (isSoloShuffle and C_PvP.GetPersonalRatedSoloShuffleSpecStats()) or (isRatedBGBlitz and C_PvP.GetPersonalRatedBGBlitzSpecStats and C_PvP.GetPersonalRatedBGBlitzSpecStats())
	if specStats then
		local weeklyStat = isSoloShuffle and specStats.weeklyMostPlayedSpecRounds or specStats.weeklyMostPlayedSpecGames
		tooltip.WeeklyMostPlayedSpec:SetFormattedText('使用最多：%s (%d)', WoWTools_ChineseMixin:Setup(PlayerUtil.GetSpecNameBySpecID(specStats.weeklyMostPlayedSpecID)), weeklyStat)
		local seasonStat = isSoloShuffle and specStats.seasonMostPlayedSpecRounds or specStats.seasonMostPlayedSpecGames
		tooltip.SeasonMostPlayedSpec:SetFormattedText('使用最多：%s (%d)', WoWTools_ChineseMixin:Setup(PlayerUtil.GetSpecNameBySpecID(specStats.seasonMostPlayedSpecID)), seasonStat)
	end

    if self.modeDescription then
        local desc= WoWTools_ChineseMixin:CN(self.modeDescription)
        if desc then
            desc= desc:gsub('。', '。|n')
            tooltip.ModeDescription:SetText(desc)
        end
    end
    local descriptionWidth = 95--tooltip.minimumWidth 152
	for _, fontString in ipairs(tooltip.Content) do
		descriptionWidth = math.max(descriptionWidth , fontString:GetStringWidth())
	end
	tooltip.ModeDescription:SetWidth(descriptionWidth)
	tooltip:Layout()
	--tooltip:Show()
end


































--评级
local function Init_ConquestFrame()
    WoWTools_ChineseMixin:SetLabelText(ConquestFrame.RatedSoloShuffle.TeamSizeText)--单人
    WoWTools_ChineseMixin:SetLabelText(ConquestFrame.RatedSoloShuffle.TeamTypeText)--竞技场
    WoWTools_ChineseMixin:SetLabelText(ConquestFrame.Arena2v2.TeamTypeText)
    WoWTools_ChineseMixin:SetLabelText(ConquestFrame.Arena3v3.TeamTypeText)
    WoWTools_ChineseMixin:SetLabelText(ConquestFrame.RatedBG.TeamTypeText)--战场


    --Blizzard_PVPUI.xml
    WoWTools_ChineseMixin:SetLabelText(ConquestTooltip.WeeklyLabel)--第周统计
    WoWTools_ChineseMixin:SetLabelText(ConquestTooltip.SeasonLabel)--赛季统计

    --PVPRatedActivityButtonTemplate
    ConquestFrame.RatedSoloShuffle:HookScript('OnEnter', conquestFrameButton_OnEnter)--单人模式
    ConquestFrame.Arena2v2:HookScript('OnEnter', conquestFrameButton_OnEnter)
    ConquestFrame.Arena3v3:HookScript('OnEnter', conquestFrameButton_OnEnter)
    ConquestFrame.RatedBG:HookScript('OnEnter', conquestFrameButton_OnEnter)--10v10战场

    if ConquestFrame.RatedBGBlitz then--11新模式
        ConquestFrame.RatedBGBlitz:HookScript('OnEnter', conquestFrameButton_OnEnter)
        WoWTools_ChineseMixin:SetLabelText(ConquestFrame.RatedBGBlitz.TeamSizeText)
        WoWTools_ChineseMixin:SetLabelText(ConquestFrame.RatedBGBlitz.TeamTypeText)
    end

    --加入战斗，按钮
    hooksecurefunc('ConquestFrame_UpdateJoinButton', function()-- RATED_SOLO_SHUFFLE_BUTTON_ID=1  RATED_BG_BLITZ_BUTTON_ID=2 RATED_BG_BUTTON_ID =5
        local button = ConquestFrame.JoinButton       
        if not ConquestFrame_HasActiveSeason() then
            return
        end

        local lfgListDisabled
        if ( not ConquestFrame.selectedButton ) or ( ConquestFrame.selectedButton.id ~= RATED_SOLO_SHUFFLE_BUTTON_ID ) then
            if ( select(2,C_LFGList.GetNumApplications()) > 0 ) then
                lfgListDisabled = '你不能在拥有有效的预创建队伍申请时那样做。'
            elseif ( C_LFGList.HasActiveEntryInfo() ) then
                lfgListDisabled = '你不能在你的队伍出现在预创建队伍列表中时那样做。'
            end
        end

        if ( lfgListDisabled ) then
            button.tooltip = lfgListDisabled
            return
        end

        local groupSize = GetNumGroupMembers()
        if ( ConquestFrame.selectedButton ) then
            if ( ConquestFrame.selectedButton.id == 1 ) then
                local minItemLevel = C_PvP.GetRatedSoloShuffleMinItemLevel()
                local _, _, playerPvPItemLevel = GetAverageItemLevel()
                if (playerPvPItemLevel < minItemLevel) then
                    button.tooltip = format('你需要更高的PvP装备物品平均等级才能加入队列。|n（需要 %1$d，当前%2$d。）', minItemLevel, playerPvPItemLevel)
                else
                    return
                end
            elseif ( ConquestFrame.selectedButton.id == 2 ) then
                local minItemLevel = C_PvP.GetRatedSoloRBGMinItemLevel()
                local _, _, playerPvPItemLevel = GetAverageItemLevel()
                local inGroup = groupSize >= 1
                local partyMinItemLevel, playerWithLowestItemLevel = C_PartyInfo.GetMinItemLevel(Enum.AvgItemLevelCategories.PvP)
                local isGroupLeader = UnitIsGroupLeader("player")
                local playerItemLevelBelowMinimum = (playerPvPItemLevel < minItemLevel)
                if inGroup and isGroupLeader and (partyMinItemLevel < minItemLevel) then
                    button.tooltip = format('"%1$s需要更高的平均装备物品等级。（需要：%2$d。当前%3$d。）', playerWithLowestItemLevel, minItemLevel, partyMinItemLevel)
                elseif inGroup and not isGroupLeader then
                    if playerItemLevelBelowMinimum then
                        button.tooltip = format('你需要更高的PvP装备物品平均等级才能加入队列。|n（需要 %1$d，当前%2$d。）', minItemLevel, playerPvPItemLevel)
                    else 
                        button.tooltip = '只有小队队长能够带领小队加入队列。'
                    end
                elseif not inGroup and playerItemLevelBelowMinimum then
                    button.tooltip = format('你需要更高的PvP装备物品平均等级才能加入队列。|n（需要 %1$d，当前%2$d。）', minItemLevel, playerPvPItemLevel)
                else
                    return
                end
            elseif ( groupSize == 0 ) then
                button.tooltip = '你所在的队伍不能加入该队列。'
            elseif ( not UnitIsGroupLeader("player") ) then
                button.tooltip = '只有小队队长能够带领小队加入队列。'
            else
                local neededSize = CONQUEST_SIZES[ConquestFrame.selectedButton.id]
                local token, loopMax
                if (groupSize > (MAX_PARTY_MEMBERS + 1)) then
                    token = "raid"
                    loopMax = groupSize
                else
                    token = "party"
                    loopMax = groupSize - 1
                end
                if ( neededSize == groupSize ) then
                    local validGroup = true
                    local maxLevel = GetMaxLevelForLatestExpansion()
                    for i = 1, loopMax do
                        if ( not UnitIsConnected(token..i) ) then
                            validGroup = false
                            button.tooltip = '你的队伍中有成员掉线，无法加入队列。'
                            break
                        elseif ( UnitLevel(token..i) < maxLevel ) then
                            validGroup = false
                            button.tooltip = '你所在的队伍不能加入该队列。'
                            break
                        end
                    end
                    if ( validGroup ) then
                        if ( not GetSpecialization() ) then
                            button.tooltip = '你必须先选择一项天赋专精。'
                        else
                            return
                        end
                    end
                elseif ( neededSize > groupSize ) then
                    if ( ConquestFrame.selectedButton.id == 5 ) then
                        button.tooltip = string.format('要加入评级战场，你的团队需要增加%d名玩家。', neededSize - groupSize)
                    else
                        button.tooltip = string.format('要进入该竞技场，你的团队需要增加%d名玩家。', neededSize - groupSize)
                    end
                else
                    if ( ConquestFrame.selectedButton.id == 5 ) then
                        button.tooltip = string.format('要加入评级战场，你的团队需要减少%d名玩家。', groupSize -  neededSize)
                    else
                        button.tooltip = string.format('要进入该竞技场，你的团队需要减少%d名玩家。', groupSize -  neededSize)
                    end
                end
            end
        end
    end)
    WoWTools_ChineseMixin:HookLabel(ConquestJoinButtonText)--ConquestJoinButton:SetText('加入战斗')


    WoWTools_ChineseMixin:HookLabel(PVPQueueFrame.HonorInset.RatedPanel.Label)--宏伟宝库

    --赛季最高
    WoWTools_ChineseMixin:HookLabel(PVPQueueFrame.HonorInset.RatedPanel.Tier.Title)

    PVPQueueFrame.HonorInset.RatedPanel.Tier:HookScript('OnEnter', function(self)--PVPRatedTier_OnEnter(self)
        local tierName = self.tierInfo and self.tierInfo.pvpTierEnum and PVPUtil.GetTierName(self.tierInfo.pvpTierEnum)
        if tierName then
            GameTooltip_SetTitle(GameTooltip, WoWTools_ChineseMixin:Setup(tierName))    
            local _, weeklyItemLevel = C_PvP.GetRewardItemLevelsByTierEnum(self.tierInfo.pvpTierEnum)
            if weeklyItemLevel > 0 then
                GameTooltip_AddColoredLine(GameTooltip, format('在此类别中获胜后，你可以从宏伟宝库获得物品等级为%d的奖励。', weeklyItemLevel), NORMAL_FONT_COLOR)
            end
            GameTooltip:Show()
        end
    end)

    --下一级
    PVPQueueFrame.HonorInset.RatedPanel.Tier.NextTier:HookScript('OnEnter', function(self)-- NextTier_OnEnter(self)
        local tierName = self.tierInfo and self.tierInfo.pvpTierEnum and PVPUtil.GetTierName(self.tierInfo.pvpTierEnum)
        if tierName then
            GameTooltip_SetTitle(GameTooltip, format('下一级：%s', WoWTools_ChineseMixin:Setup(tierName)))
            local tierDescription = PVPUtil.GetTierDescription(self.tierInfo.pvpTierEnum)
            if tierDescription then
                GameTooltip:SetMinimumWidth(270)--260
                GameTooltip_AddNormalLine(GameTooltip, WoWTools_ChineseMixin:Setup(tierDescription))
            end
            local activityItemLevel, weeklyItemLevel = C_PvP.GetRewardItemLevelsByTierEnum(self.tierInfo.pvpTierEnum)
            if activityItemLevel > 0 then
                GameTooltip_AddBlankLineToTooltip(GameTooltip)
                GameTooltip_AddColoredLine(GameTooltip, format('在此类别中获胜可以将你的宏伟宝库的奖励的物品等级提升到%d。', weeklyItemLevel), NORMAL_FONT_COLOR)
            end
            GameTooltip:Show()
        end
    end)

    --赛季奖励
    for _, label in pairs({PVPQueueFrame.HonorInset.RatedPanel.SeasonRewardFrame:GetRegions()}) do
        if label:GetObjectType()=='FontString' then
            WoWTools_ChineseMixin:SetLabelText(label)
        end
    end
    PVPQueueFrame.HonorInset.CasualPanel.HonorLevelDisplay.NextRewardLevel:HookScript('OnEnter', function()
        local honorLevel = UnitHonorLevel("player")
        local nextHonorLevelForReward = C_PvP.GetNextHonorLevelForReward(honorLevel)
        local rewardInfo = nextHonorLevelForReward and C_PvP.GetHonorRewardInfo(nextHonorLevelForReward)
        if rewardInfo then
            local rewardText = select(11, GetAchievementInfo(rewardInfo.achievementRewardedID))
            if rewardText and rewardText ~= "" then
                GameTooltip:SetText(format('到达荣誉等级%d级后可获得下一个奖励', nextHonorLevelForReward))
                GameTooltip_AddColoredLine(GameTooltip, WoWTools_ChineseMixin:Setup(rewardText), HIGHLIGHT_FONT_COLOR, true)
                GameTooltip:Show()
            end
        end
    end)
end























--Blizzard_PVPUI.lua
local function Init()
    hooksecurefunc('PVPQueueFrame_UpdateTitle', function()--Blizzard_PVPUI.lua
        if ConquestFrame.seasonState == 2 then--SEASON_STATE_PRESEASON
            PVEFrame:SetTitle('PvP（季前赛）')
        elseif ConquestFrame.seasonState == 1 then--SEASON_STATE_OFFSEASON
            PVEFrame:SetTitle('玩家VS玩家（休赛期）')
        else
            local expName = _G["EXPANSION_NAME"..GetExpansionLevel()]
            PVEFrame:SetTitleFormatted('玩家VS玩家 '..(WoWTools_ChineseMixin:CN(expName) or expName)..' 第 %d 赛季', PVPUtil.GetCurrentSeasonNumber())
        end
    end)
    PVPQueueFrameCategoryButton1.Name:SetText('快速比赛')

    PVPQueueFrameCategoryButton2.Name:SetText('评级')
    PVPQueueFrameCategoryButton3.Name:SetText('预创建队伍')
    PVPQueueFrame.NewSeasonPopup.Leave:SetText('关闭')

    hooksecurefunc('PVPConquestLockTooltipShow', function()
        GameTooltip:SetText(string.format('该功能将在%d级开启。', GetMaxLevelForLatestExpansion()))
        GameTooltip:Show()
    end)


    Init_HonorFrame()
    Init_ConquestFrame()
end














EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(owner, arg1)
    if arg1=='Blizzard_PVPUI' then
        Init()
        EventRegistry:UnregisterCallback('ADDON_LOADED', owner)
    end
end)

