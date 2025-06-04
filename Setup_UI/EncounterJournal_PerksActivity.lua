


--[[
[Field_10_0_5_47118_002]= 'Name_lang',
https://wago.tools/db2/PerksActivityThresholdGroup?locale=zhCN
]]
local PerksActivityThresholdGroup={
[1]= '一月：重新启程',
[2]= '二月：关爱与分享',
[3]= '三月：光彩照人',
[4]= '四月：春日的脚步',
[5]= '五月：童真时光',
[6]= '六月：玩火',
[7]= '七月：欢庆！',
[8]= '八月：变脸！',
[9]= '九月：派对时间',
[10]= '十月：惊心动魄',
[11]= '十一月：多多益善',
[12]= '十二月：天寒地冻',
[13]= '一月：重新启程',
[14]= '二月：新欢旧爱',
[15]= '三月：华丽起舞',
[16]= '四月：春意袭人',
[17]= '五月：花朵魅力',
[18]= '六月：夏日欢笑',
[19]= '七月：深邃黑暗',
[20]= '八月：竞争之魂',
[21]= '九月：欢乐同享',
[22]= '十月：光暗对决',
[23]= '十一月：璀璨夺目',
[24]= '十二月：冰寒试炼',
[25]= '一月：稳步前进',
[26]= '二月：月耀光辉',
[27]= '三月：灵感与天资',
[28]= '四月：马戏团游戏',
[29]= '五月：萌物国度',
[30]= '六月：灼燃之心',
[31]= '七月：遗忘的回忆',
[32]= '八月：不可兼得',
[33]= '九月：矮人风采',
[34]= '十月：邪能庆典',
[35]= '十一月：累累恩赐',
[36]= '十二月：冰封之心',
}



local function set_desc_event(desc, data)
    if desc and data then
        if data.eventStartTime and desc:find('{EventStartDate}') then
            local eventStartTimeUnits = date("*t", data.eventStartTime)
            local eventStartDate = FormatShortDate(eventStartTimeUnits.day, eventStartTimeUnits.month)
            if eventStartDate then
                desc= desc:gsub('{EventStartDate}', '|cnGREEN_FONT_COLOR:'..eventStartDate..'|r')
            end
        end
        if data.eventEndTime and desc:find('{EventEndDate}') then
            local eventEndTimeUnits = date("*t", data.eventEndTime)
            local eventEndDate = FormatShortDate(eventEndTimeUnits.day, eventEndTimeUnits.month)
            if eventEndDate then
                desc= desc:gsub('{EventEndDate}', '|cnRED_FONT_COLOR:'..eventEndDate..'|r')
            end
        end
    end
    return desc
end












function WoWTools_ChineseMixin.Events:Blizzard_EncounterJournal_PerksActivity()

    EncounterJournalMonthlyActivitiesFrame.RestrictedText:SetText('你必须有可用的订阅或游戏时间|n才能完成活动并在商栈赢取奖励')
    EncounterJournalMonthlyActivitiesTab:SetText('旅行者日志')
    EncounterJournalMonthlyActivitiesTab:SetScript('OnEnter', function()
        if not C_PlayerInfo.IsTravelersLogAvailable() then
            local tradingPostLocation = UnitFactionGroup('player') == "Alliance" and '暴风城' or '奥格瑞玛'
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            GameTooltip_AddErrorLine(GameTooltip, format('拜访%s的商栈，查看旅行者日志。', tradingPostLocation))
            if AreMonthlyActivitiesRestricted() then
                GameTooltip_AddBlankLineToTooltip(GameTooltip)
                GameTooltip_AddErrorLine(GameTooltip, '需要可用的游戏时间。')
            end

            GameTooltip:Show()
        end
    end)
    if EncounterJournalMonthlyActivitiesFrame.ThresholdContainer then
        WoWTools_ChineseMixin:SetLabel(EncounterJournalMonthlyActivitiesFrame.ThresholdContainer.TextContainer.Points)
    end
    EncounterJournalMonthlyActivitiesFrame.HeaderContainer.Title:SetText('旅行者日志')
    EncounterJournalMonthlyActivitiesFrame.BarComplete.AllRewardsCollectedText:SetText('你已经收集完了本月的所有奖励')






    --任务，名称
    hooksecurefunc(MonthlyActivitiesButtonTextContainerMixin, 'UpdateText', function(frame, data)
        local info= WoWTools_ChineseMixin:GetPerksActivityData(data.ID)
        if not info then
            return
        end
        local name= info[1]
        if name then
            frame.NameText:SetText(name)
        end
        local desc= set_desc_event(info[2], data)
        if desc then
            frame.ConditionsText:SetText(desc)
            frame.ConditionsText:SetPoint('RIGHT', -30,0)
            frame:SetPoint('RIGHT', -30)
        end
    end)

    --任务，提示
    hooksecurefunc(MonthlyActivitiesButtonMixin, 'ShowTooltip', function(frame)
        local data = frame:GetData() or {}
        local info= WoWTools_ChineseMixin:GetPerksActivityData(data.ID)
        if not info then
            return
        end
        GameTooltip_AddBlankLineToTooltip(GameTooltip)
        local name= info[1]
        local desc= set_desc_event(info[2], data)
        if name or desc then
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            if name then
                GameTooltip:AddLine('|cffffd100'..name..'|r', nil,nil,nil, true)
            end
            if desc then
                if name then
                    GameTooltip_AddBlankLineToTooltip(GameTooltip)
                end
                GameTooltip:AddLine('|cffffffff'..desc..'|r', nil,nil,nil, true)
            end
            GameTooltip:Show()
        end
    end)


    --任务，列表，名称
    hooksecurefunc(EncounterJournalMonthlyActivitiesFrame.FilterList.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, btn in pairs(frame:GetFrames() or {}) do
            WoWTools_ChineseMixin:SetLabel(btn.Label)
        end
    end)


    --月份 名称
    hooksecurefunc(EncounterJournalMonthlyActivitiesFrame, 'UpdateTime', function(frame, _, secondsRemaining)
        local text = EncounterJournalMonthlyActivitiesFrame.TimeLeftFormatter:Format(secondsRemaining)
        frame.HeaderContainer.TimeLeft:SetFormattedText('|A:activities-clock:0:0:0:0|a %s |cnRED_FONT_COLOR:后结束|r', text)
        local data = C_PerksActivities.GetPerksActivitiesInfo() or {}
        local name= data.activePerksMonth and PerksActivityThresholdGroup[data.activePerksMonth]
        if name then
            frame.HeaderContainer.Month:SetText(name)
        else
            WoWTools_ChineseMixin:SetLabel(frame.HeaderContainer.Month)
        end
    end)

end
