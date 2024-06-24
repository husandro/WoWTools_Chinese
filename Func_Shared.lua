 
 local id, e= ...
 
 
 --UIDropDownMenu.lua
 --[[local function GetChild(frame, name, key)
    if (frame[key]) then
        return frame[key]
    elseif name then
        return _G[name..key]
    end

    return nil
end]]
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
end)


hooksecurefunc(MenuUtil, 'CreateTitle', function(self, text)
    info= self
    for k, v in pairs(info) do if v and type(v)=='table' then print('|cff00ff00---',k, '---STAR') for k2,v2 in pairs(v) do print(k2,v2) end print('|cffff0000---',k, '---END') else print(k,v) end end print('|cffff00ff——————————')
    print(text)
end)



local frame= CreateFrame('Frame')
frame:SetSize(200, 200)
frame:SetPoint('CENTER')

local function GeneratorFunction(owner, rootDescription)
	rootDescription:CreateTitle("My Title");
	rootDescription:CreateButton("My Button", function(data)
    	-- Button handling here.
        print('aaaaaa')
	end);
    local submenu = rootDescription:CreateButton("My Submenu", function() print('My Submenu') end);
    submenu:CreateButton("Enable", function() print('Enable') end, true);
    submenu:CreateButton("Disable", function() print('Disable') end, false);
    local subsubmenu= submenu:CreateButton("My Submenu", function() print('My sub Submenu') end);

subsubmenu:CreateButton("sub Enable", function() print('sub Enable') end, true);

end

local dropdown = CreateFrame("DropdownButton", nil, frame, "WowStyle1FilterDropdownTemplate");
--dropdown:SetDefaultText("My Dropdown");


dropdown:SetPoint('CENTER', 100, -100)

dropdown:SetupMenu(GeneratorFunction);
--[[MenuUtil.CreateButtonMenu(dropdown,
	{"My Button 1", function() print('1') end, 1},
	{"My Button 2", function() print('2') end, 2},
	{"My Button 3", function() print('3') end, 3}
);]]