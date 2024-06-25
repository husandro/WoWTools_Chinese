local id, e = ...








local function calendar_Uptate()
    local indexInfo = C_Calendar.GetEventIndex()
    local info= indexInfo and C_Calendar.GetDayEvent(indexInfo.offsetMonths, indexInfo.monthDay, indexInfo.eventIndex) or {}

    if info.eventID then
        local data= e.cn(nil, {holydayID= info.eventID}) or {}
        local head= data[1]
        local desc= data[2]
        if head then
            CalendarViewHolidayFrame.Header:Setup(head)
        end
        if desc then
            if (info.startTime and info.endTime) then
                desc = format('%1$s|n|n开始：%2$s %3$s|n结束：%4$s %5$s', desc, FormatShortDate(info.startTime.monthDay, info.startTime.month, 0), GameTime_GetFormattedTime(info.startTime.hour, info.startTime.minute, true), FormatShortDate(info.endTime.monthDay, info.endTime.month), GameTime_GetFormattedTime(info.endTime.hour, info.endTime.minute, true));
            end
            CalendarViewHolidayFrame.ScrollingFont:SetText(desc)
        end
    end
end





local function Init()

    CalendarFrame.FilterButton.Text:SetText('过滤器')

    CalendarEventPickerCloseButtonText:SetText('关闭')
    --星期
    hooksecurefunc('CalendarFrame_Update', function()
        for i= 1, 7 do
            e.set(_G['CalendarWeekday'..i..'Name'])
        end
    end)
    --月份
    hooksecurefunc('CalendarFrame_UpdateTitle', function()
        e.set(CalendarMonthName)
    end)

    CalendarEventPickerFrame.Header.Text:SetText('选择一个活动')
    hooksecurefunc('CalendarEventPickerFrame_InitButton', function(btn, elementData)
        local dayButton = CalendarEventPickerFrame.dayButton
        local monthOffset = dayButton.monthOffset
        local day = dayButton.day
        local eventIndex = elementData.index
        local event = C_Calendar.GetDayEvent(monthOffset, day, eventIndex) or {}
        local tab= e.Get_HolyDay(event.eventID)
        if tab[1] then
            btn.Title:SetText(tab[1])
        end
    end)

    local function ShouldDisplayEventOnCalendar(event)
        local shouldDisplayBeginEnd = event and event.sequenceType ~= "ONGOING"
        if ( event.sequenceType == "END" and event.dontDisplayEnd ) then
            shouldDisplayBeginEnd = false
        end
        return shouldDisplayBeginEnd
    end
    hooksecurefunc('CalendarFrame_UpdateDayEvents', function(index, day, monthOffset)
        local dayButtonName= 'CalendarDayButton'..index
        local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)
        local eventIndex = 1
        local eventButtonIndex = 1
        while ( eventButtonIndex <= 4 and eventIndex <= numEvents ) do
            local eventButtonText1 = _G[dayButtonName..'EventButton'..eventButtonIndex.."Text1"]
            local event = C_Calendar.GetDayEvent(monthOffset, day, eventIndex)
            if ShouldDisplayEventOnCalendar(event) then
                local title= e.Get_HolyDay(event.eventID)[1]
                if title then
                    eventButtonText1:SetText(title)
                end
                eventButtonIndex = eventButtonIndex + 1
            end
            eventIndex = eventIndex + 1
        end
    end)


    hooksecurefunc(CalendarViewHolidayFrame, 'update', calendar_Uptate)--提示节目ID    
    hooksecurefunc('CalendarViewHolidayFrame_Update', calendar_Uptate)
end










--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_Calendar') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_Calendar' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')

    end
end)
