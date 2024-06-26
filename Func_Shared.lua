local id, e= ...

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
end)
