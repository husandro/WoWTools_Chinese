local e= select(2, ...)
--Blizzard_Menu








--MenuTemplates.lua
hooksecurefunc('GetWowStyle1ArrowButtonState', function(self)
    e.set(self.Text)
end)
hooksecurefunc(DropdownTextMixin, 'OnLoad', function(self)
    e.set(self.Text)
end)
hooksecurefunc(DropdownTextMixin, 'UpdateText', function(self)
	e.set(self.Text)
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
    e.set(self.Text)
end)
hooksecurefunc(DropdownSelectionTextMixin, 'UpdateToMenuSelections', function(self)
    e.set(self.Text)
end)











hooksecurefunc(DropdownButtonMixin, 'SetupMenu', function(self)
    e.set(self.Text)
end)



local function set_fontString(frame)
    C_Timer.After(0.01, function()
        e.set(frame.fontString)
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

        
        elementDescription:AddInitializer(function(button)
            button.Text:SetText(name)
            print(name, text)
        end)
    end
end)
