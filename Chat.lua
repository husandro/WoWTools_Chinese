local e= select(2, ...)



local function cn_Link_Text(link, tabInfo)
    local name= link:match('|h%[|c........(.-)|r]|h') or link:match('|h%[(.-)]|h')
    if name then
        local new= e.cn(name, tabInfo)--汉化
        if new then
            name= name:match('|c........(.-)|r') or name
            link= link:gsub(name, new)
        end
    end
    return link
end



ChatFrame_AddMessageEventFilter('CHAT_MSG_CHANNEL', function(...)
print(...)
end)