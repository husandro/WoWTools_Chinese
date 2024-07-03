local id, e = ...


--[[
[ID]= 'DisplayName_lang',
https://warcraft.wiki.gg/wiki/API_C_PerksProgram.GetCategoryInfo
]]
for categoryID, name in pairs({
[1]= '幻化',
[2]= '坐骑',
[3]= '宠物',
[5]= '玩具',
[6]= '自定义选项',
[8]= '幻化套装',
}) do
    local data= C_PerksProgram.GetCategoryInfo(categoryID) or {}
    if data.displayName then
        e.strText[data.displayName]= name
    end
end



--[[
[Field_10_0_5_47118_002]= 'Name_lang',
--https://wago.tools/db2/PerksActivityThresholdGroup?build=11.0.0.55288&locale=zhCN
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



--[[
https://wago.tools/db2/PerksActivityTag?build=11.0.0.55288&locale=zhCN
[ID]= 'TagName_lang',
]]
local PerksActivityTag={
[1]= '任务',
[2]= 'PvP',
[3]= '地下城和团队副本',
[4]= '巨龙时代',
[5]= '专业',
[6]= '宠物对战',
[7]= '节日和事件',
[8]= '特殊',
[9]= '德拉诺之王',
[10]= '军团再临',
[11]= '收集品',
[12]= '熊猫人之谜',
[13]= '燃烧的远征',
[14]= '巫妖王之怒',
[15]= '大地的裂变',
[16]= '世界',
[17]= '争霸艾泽拉斯',
[18]= '暗影国度',
[19]= '地心之战',
[20]= '潘达利亚：幻境新生',
}
local tags= C_PerksActivities.GetAllPerksActivityTags() or {}
for index, name in pairs(tags.tagName or {}) do
    local cnName= PerksActivityTag[index]
    if name and cnName then
        e.strText[name]= cnName
    end
end




















local function Init()
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
    e.set(EncounterJournalMonthlyActivitiesFrame.ThresholdBar.TextContainer.Points)
    EncounterJournalMonthlyActivitiesFrame.HeaderContainer.Title:SetText('旅行者日志')
    EncounterJournalMonthlyActivitiesFrame.BarComplete.AllRewardsCollectedText:SetText('你已经收集完了本月的所有奖励')


    --任务，名称
    hooksecurefunc(MonthlyActivitiesButtonTextContainerMixin, 'UpdateText', function(self, data)
        local info= e.Get_PerksActivity_Info(data.ID) or {}
        if info[1] then
            self.NameText:SetText(info[1])
        end
    end)

    --任务，提示
    hooksecurefunc( MonthlyActivitiesButtonMixin, 'ShowTooltip', function(self)
        local data = self:GetData() or {}
        local info= data.ID and e.Get_PerksActivity_Info(data.ID) or {}
        local name, desc= info[1], info[2]
        if name or desc then
            GameTooltip_AddBlankLineToTooltip(GameTooltip)
            if name then
                GameTooltip:AddLine('|cffffd100'..name..'|r', nil,nil,nil, true)
            end
            if desc then
                if name then
                    GameTooltip_AddBlankLineToTooltip(GameTooltip)
                end
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
                GameTooltip:AddLine('|cffffffff'..desc..'|r', nil,nil,nil, true)
            end
            GameTooltip:Show()
        end
    end)


    --任务，列表，名称
    hooksecurefunc(EncounterJournalMonthlyActivitiesFrame.FilterList.ScrollBox, 'Update', function(self)
        if self frame:GetView() then
            return
        end
        for _, btn in pairs(self:GetFrames() or {}) do
            e.set(btn.Label)
        end
    end)


    --月份 名称
    hooksecurefunc(EncounterJournalMonthlyActivitiesFrame, 'UpdateTime', function(self, _, secondsRemaining)
        local text = EncounterJournalMonthlyActivitiesFrame.TimeLeftFormatter:Format(secondsRemaining)
        self.HeaderContainer.TimeLeft:SetFormattedText('|A:activities-clock:0:0:0:0|a %s |cnRED_FONT_COLOR:后结束|r', text)
        local data = C_PerksActivities.GetPerksActivitiesInfo() or {}
        local name= data.activePerksMonth and PerksActivityThresholdGroup[data.activePerksMonth]
        if name then
            self.HeaderContainer.Month:SetText(name)
        else
            e.set(self.HeaderContainer.Month)
        end
    end)


end















--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_EncounterJournal') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_EncounterJournal' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)

