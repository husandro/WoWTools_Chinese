function WoWTools_ChineseMixin.Events:Blizzard_GroupFinder()

    self:SetLabel(RaidFinderQueueFrameSelectionDropdownName)
    self:SetLabel(RaidFinderQueueFrameScrollFrameChildFrameRewardsLabel)
    self:HookLabel(RaidFinderQueueFrameSelectionDropdown.Text)
    RaidFinderQueueFrameScrollFrameChildFrameEncounterList:HookScript('OnEnter', function(frame)
        if frame.dungeonID then
            local numEncounters, numCompleted = GetLFGDungeonNumEncounters(frame.dungeonID)
            if ( numCompleted > 0 ) then
                GameTooltip:AddLine(' ')
                GameTooltip:AddLine(format('|cnHIGHLIGHT_FONT_COLOR:物品已经被拾取（%d/%d）', numCompleted, numEncounters))
                GameTooltip:Show()
            end
        end
    end)

    hooksecurefunc('RaidFinderQueueFrameIneligibleFrame_UpdateFrame', function(frame)
        if ( frame.queueRestriction ) then
            if ( frame.queueRestriction == "lfd" ) then
                frame.description:SetText('你无法在排队加入随机地下城时排队加入随机团队副本的队列。')
                frame.leaveQueueButton:SetText('离开队列')
            else
                frame.description:SetText('处于其他团队列表时无法加入团队副本队列。')
                if ( IsInGroup() ) then
                    frame.leaveQueueButton:SetText('不列出我的队伍')
                else
                    frame.leaveQueueButton:SetText('不列出我的名字')
                end
            end
        elseif ( frame.ineligibleGroup ) then
            frame.description:SetText('你的队伍不能通过团队查找器加入任何随机团队副本。')
            frame.leaveQueueButton:Hide()
            frame:Show()
            return true
        elseif ( frame.ineligiblePlayer ) then
            frame.description:SetText('你不能通过团队查找器排队加入任何随机团队副本。')
        end
    end)

--加入，按钮
    self:HookButton(RaidFinderFrameFindRaidButton)




--地下城查找器
    GroupFinderFrame:HookScript('OnShow', function()
        PVEFrame:SetTitle('地下城和团队副本')
    end)

    LFDQueueFrameFollowerTitle:SetText('追随者地下城')
    LFDQueueFrameFollowerDescription:SetText('与NPC队友一起完成地下城')

    --自定义，地下城，列表
    hooksecurefunc('LFGDungeonListButton_SetDungeon', function(button)
        self:SetLabel(button.instanceName)
    end)




    self:SetLabel(LFDQueueFrameTypeDropdownName)

    self:HookLabel(LFDQueueFrameTypeDropdown.Text)









    hooksecurefunc('LFGRewardsFrame_UpdateFrame', function(parentFrame, dungeonID)--LFGFrame.lua
        if ( not dungeonID ) then
            return
        end
        local dungeonName, _, subtypeID,_,_,_,_,_,_,_,_,_,_, dungeonDescription, isHoliday, _, _, isTimewalker = GetLFGDungeonInfo(dungeonID)
        local isScenario = (subtypeID == LFG_SUBTYPEID_SCENARIO)
        local doneToday = GetLFGDungeonRewards(dungeonID)
        local name, desc, reward
        if ( isTimewalker ) then
            reward='你将获得该奖励：'
            name='随机时空漫游地下城'
            desc= '时空漫游将让你回到低级地下城中，并将你的角色实力降低到与之相适应程度，但首领会掉落与你当前等级相符的战利品。'
        elseif ( isHoliday ) then
            if ( doneToday ) then
                reward= '每天继首次胜利之后的每次胜利将为你赢得：'
            else
                reward= '你每天取得的首次胜利将为你赢得：'
            end

        elseif ( subtypeID == LFG_SUBTYPEID_RAID ) then
            if ( doneToday ) then --May not actually be today, but whatever this reset period is.
                reward='当你完成每周的首次副本之后，每次胜利都可为你赢得：'
            else
                reward='每周第一次完成可获得：'
            end

        else
            local numCompletions, isWeekly = LFGRewardsFrame_EstimateRemainingCompletions(dungeonID)
            if ( numCompletions <= 0 ) then
                reward= '你将获得该奖励：'
            elseif ( isWeekly ) then
                reward= format('本周你还能获取此奖励%d|4次:次：', numCompletions)
            else
                reward= format('今天你还能获取此奖励%d|4次:次：', numCompletions)
            end
            if ( isScenario ) then
                if ( LFG_IsHeroicScenario(dungeonID) ) then
                    name= '随机英雄场景战役'
                    desc= '使用随机英雄场景战役排队可获得额外奖励。但你需要组满队伍'
                else
                    name= '随机场景战役'
                    desc= '使用随机场景战役排队，会获得额外奖励哦！'
                end
            else
                name= '随机地下城'
                desc= '使用地下城查找器前往随机地下城，会有额外奖励哦！'
            end
        end


        name= name or self:CN(dungeonName)
        desc= desc or self:CN(dungeonDescription) or self:GetLFGDungeonDesc(dungeonID)

        if name then
            parentFrame.title:SetText(name)
        end
        if desc then
            parentFrame.description:SetText(desc)
        end
        if reward then
            parentFrame.rewardsDescription:SetText(reward)
        end
    end)

end
