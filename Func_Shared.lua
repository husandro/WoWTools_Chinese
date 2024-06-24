 --UIDropDownMenu.lua
 local function GetChild(frame, name, key)
    if (frame[key]) then
        return frame[key]
    elseif name then
        return _G[name..key]
    end

    return nil
end
local function get_menu_text(text)--( ) . % + - * ? [ ^ $
    if text then
        local col, text2= text:match('(|cff......)(.-)|r')
        local str1, str2= text:match('(.-) %((.-)%)')
        local str3= text:match('%((.+)%)')
        text= e.strText[text2 or text]
        if text then
            return col and col..text..'|r' or text
        elseif str1 and str2 then
            local name, col2 =str1:match('(.-)(|cff......)')
            str1= name or str1
            str2= str2:gsub('|r', '')
            if e.strText[str1] or e.strText[str2] then
                return (e.strText[str1] or str1)..(col2 or '')..' ('..(e.strText[str2] or str2)..')'..(col2 and '|r' or '')
            end
        elseif e.strText[str3] then
            return '('..e.strText[str3]..')'
        end
    end
end
hooksecurefunc('UIDropDownMenu_SetText', function(frame, name)
    if frame then
        local text
        if type(name)=='string' then
            text= name
        elseif type(text)=='function' then
            text= name()
        end
        text= get_menu_text(text)
        if text then
            e.set(GetChild(frame, frame:GetName(), "Text"), text)
        end
    end
end)
hooksecurefunc('UIDropDownMenu_AddButton', function(info, level)
    level = level or 1
    local listFrame = _G["DropDownList"..level]
    listFrame = listFrame or _G["DropDownList"..level]
    local listFrameName = listFrame:GetName()
    local index = listFrame and (listFrame.numButtons) or 1
    local button = _G[listFrameName.."Button"..index]
    local text= get_menu_text(info.text)
    if text then
        button:SetText(info.colorCode and info.colorCode..text.."|r" or text)
    end
end)


hooksecurefunc('UIMenu_AddButton', function(self, text)--UIMenu.lua
    if ( self.numButtons > UIMENU_NUMBUTTONS ) then
        return
    end
    local button = _G[self:GetName().."Button"..self.numButtons]
    if ( button and text ) then
        e.set(button, text)
        e.set(_G[button:GetName().."ShortcutText"])
    end
end)