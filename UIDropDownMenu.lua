local id, e= ...

--UIDropDownMenu.lua
--[[
local envTable = GetCurrentEnvironment();
local function GetChild(frame, name, key)
	if (frame[key]) then
		return frame[key];
	elseif name then
		return envTable[name..key];
	end
	return nil;
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

hooksecurefunc('UIDropDownMenu_SetText', function(frame, text)
    text= e.strText[text]
    if text then
        GetChild(frame, frameName, "Text"):SetText(text);
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


hooksecurefunc('UIMenu_AddButton', function(self, text, shortcut)--UIMenu.lua
    local ID = self.numButtons + 1;
	if ( ID > UIMENU_NUMBUTTONS ) then
		return;
	end
	local button = _G[self:GetName().."Button"..ID];
    text= e.strText[text]
	if  text then
		button:SetText(text);
	end
    shortcut= e.strText[shortcut]
	if shortcut then
		local shortcutString = _G[button:GetName().."ShortcutText"];
		shortcutString:SetText(shortcut);
	end
end)]]








if not UIDropDownMenu_AddButton then
    return
end

--UIDropDownMenu.lua
local function GetChild(frame, name, key)
    if frame and key then
        if frame[key] then
            return frame[key]
        elseif name then
            return _G[name..key]
        end
    end
end

local function get_menu_text(text)
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
    local label= GetChild(frame, frame:GetName(), "Text")
    if label then
        local text
        if type(name)=='string' then
            text= name
        elseif type(text)=='function' then
            text= name()
        end
        text= get_menu_text(text)
        if text then
            label:SetText(text)
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

for i=1, 12 do
    e.set(_G['ChatMenuButton'..i])
end

if _G['VoiceMacroMenu'] then
    local w= _G['VoiceMacroMenu']:GetWidth()
    _G['VoiceMacroMenu']:SetWidth(w*1.6)
    for i=1, 23 do
        local btn= _G['VoiceMacroMenuButton'..i]
        local name= btn and btn:GetText()
        local text= name and e.strText[name]
        if text then
            btn:SetText(text)
            local shortcutString = _G[btn:GetName().."ShortcutText"]
            if shortcutString then
                shortcutString:SetText(name)
                shortcutString:Show()
            end
            btn:SetWidth(w*1.4)
        end
    end
end
if _G['EmoteMenu'] then
    local w= _G['EmoteMenu']:GetWidth()
    _G['EmoteMenu']:SetWidth(w*1.6)
    for i=1, 21 do
        local btn= _G['EmoteMenuButton'..i]
        local name= btn and btn:GetText()
        local text= name and e.strText[name]
        if text then
            btn:SetText(text)
            local shortcutString = _G[btn:GetName().."ShortcutText"]
            if shortcutString then
                shortcutString:SetText(name)
                shortcutString:Show()
            end
            btn:SetWidth(w*1.4)
        end
    end
end



