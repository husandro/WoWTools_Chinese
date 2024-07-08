local e= select(2, ...)





_G['LFDQueueFrameFollowerTitle']:SetText('追随者地下城')
_G['LFDQueueFrameFollowerDescription']:SetText('与NPC队友一起完成地下城')
--set(LFDQueueFrameRandomScrollFrameChildFrameTitle, '')
hooksecurefunc('LFGRewardsFrame_UpdateFrame', function(parentFrame, dungeonID)--LFGFrame.lua
    if ( not dungeonID ) then
        return
    end
    local _, _, subtypeID,_,_,_,_,_,_,_,_,_,_,_, isHoliday, _, _, isTimewalker = GetLFGDungeonInfo(dungeonID)
    local isScenario = (subtypeID == LFG_SUBTYPEID_SCENARIO)
    local doneToday = GetLFGDungeonRewards(dungeonID)
    if ( isTimewalker ) then
        parentFrame.rewardsDescription:SetText('你将获得该奖励：')
        parentFrame.title:SetText('随机时空漫游地下城')
        parentFrame.description:SetText('时空漫游将让你回到低级地下城中，并将你的角色实力降低到与之相适应程度，但首领会掉落与你当前等级相符的战利品。')
    elseif ( isHoliday ) then
        if ( doneToday ) then
            parentFrame.rewardsDescription:SetText('每天继首次胜利之后的每次胜利将为你赢得：')
        else
            parentFrame.rewardsDescription:SetText('你每天取得的首次胜利将为你赢得：')
        end
        --parentFrame.title:SetText(dungeonName)
        --parentFrame.description:SetText(dungeonDescription)
    elseif ( subtypeID == LFG_SUBTYPEID_RAID ) then
        if ( doneToday ) then --May not actually be today, but whatever this reset period is.
            parentFrame.rewardsDescription:SetText('当你完成每周的首次副本之后，每次胜利都可为你赢得：')
        else
            parentFrame.rewardsDescription:SetText('每周第一次完成可获得：')
        end
        --parentFrame.title:SetText(dungeonName)
        --parentFrame.description:SetText(dungeonDescription)
    else
        local numCompletions, isWeekly = LFGRewardsFrame_EstimateRemainingCompletions(dungeonID)
        if ( numCompletions <= 0 ) then
            parentFrame.rewardsDescription:SetText('你将获得该奖励：')
        elseif ( isWeekly ) then
            parentFrame.rewardsDescription:SetText(format('本周你还能获取此奖励%d|4次:次：', numCompletions))
        else
            parentFrame.rewardsDescription:SetText(format('今天你还能获取此奖励%d|4次:次：', numCompletions))
        end
        if ( isScenario ) then
            if ( LFG_IsHeroicScenario(dungeonID) ) then
                parentFrame.title:SetText('随机英雄场景战役')
                parentFrame.description:SetText('使用随机英雄场景战役排队可获得额外奖励。但你需要组满队伍')
            else
                parentFrame.title:SetText('随机场景战役')
                parentFrame.description:SetText('使用随机场景战役排队，会获得额外奖励哦！')
            end
        else
            parentFrame.title:SetText('随机地下城')
            parentFrame.description:SetText('使用地下城查找器前往随机地下城，会有额外奖励哦！')
        end
    end
end)