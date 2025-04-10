local e= select(2, ...)
--Blizzard_Menu








--MenuTemplates.lua
hooksecurefunc('GetWowStyle1ArrowButtonState', function(self)
    WoWTools_ChineseMixin:Set_Label_Text(self.Text)
end)
hooksecurefunc(DropdownTextMixin, 'OnLoad', function(self)
    WoWTools_ChineseMixin:Set_Label_Text(self.Text)
end)
hooksecurefunc(DropdownTextMixin, 'UpdateText', function(self)
	WoWTools_ChineseMixin:Set_Label_Text(self.Text)
	if self.resizeToText then
        local newWidth = self.Text:GetUnboundedStringWidth();
        if self.resizeToTextPadding then
            newWidth = newWidth + self.resizeToTextPadding;
        end
        if self.resizeToTextMaxWidth then
            newWidth = math.min(self.resizeToTextMaxWidth, newWidth);
        end
        if self.resizeToTextMinWidth then
            newWidth = math.max(self.resizeToTextMinWidth, newWidth);
        end
        self:SetWidth(newWidth);
    end
end)
hooksecurefunc(DropdownSelectionTextMixin, 'OverrideText', function(self)
    WoWTools_ChineseMixin:Set_Label_Text(self.Text)
end)
hooksecurefunc(DropdownSelectionTextMixin, 'UpdateToMenuSelections', function(self)
    WoWTools_ChineseMixin:Set_Label_Text(self.Text)
end)











hooksecurefunc(DropdownButtonMixin, 'SetupMenu', function(self)
    WoWTools_ChineseMixin:Set_Label_Text(self.Text)
end)



local function set_fontString(frame)
    C_Timer.After(0.01, function()
        WoWTools_ChineseMixin:Set_Label_Text(frame.fontString)
    end)
end
hooksecurefunc(MenuVariants, 'CreateFontString', set_fontString)
hooksecurefunc(MenuVariants, 'CreateCheckbox', function(_, frame)
    set_fontString(frame)
end)
hooksecurefunc(MenuVariants, 'CreateRadio', function(_, frame)
    set_fontString(frame)
end)





hooksecurefunc(MenuUtil, 'SetElementText', function(elementDescription, text)
    local name= e.strText[text]
    if name and name~=text then
        elementDescription.text = name
    end
end)

--[[elementDescription:AddInitializer(function(button)
    button.Text:SetText(name)
end)]]

