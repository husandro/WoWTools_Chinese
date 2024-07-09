--Blizzard_FrameXMLBase/Constants.lua
local e= select(2, ...)



local function set_table(data)
    for index, name in pairs(_G[data] or {}) do
        local cnName= e.strText[name]
        if cnName then
            _G[data][index]= cnName
        end
    end
end



local function Init()
    local tab={
        'SCHOOL_STRINGS',
        'CALENDAR_WEEKDAY_NAMES',
        'CALENDAR_FULLDATE_MONTH_NAMES',
        'LFG_CATEGORY_NAMES',
    }
    for _, name in pairs(tab) do
        set_table(name)
    end
end


C_Timer.After(4, Init)