
--Blizzard_Menu








--MenuTemplates.lua
hooksecurefunc('GetWowStyle1ArrowButtonState', function(self)
    WoWTools_ChineseMixin:HookLabel(self.Text)

end)
hooksecurefunc(DropdownTextMixin, 'OnLoad', function(self)
    WoWTools_ChineseMixin:HookLabel(self.Text)
end)
hooksecurefunc(DropdownTextMixin, 'UpdateText', function(self)
	WoWTools_ChineseMixin:SetLabel(self.Text)
    
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
    WoWTools_ChineseMixin:HookLabel(self.Text)
end)
hooksecurefunc(DropdownSelectionTextMixin, 'UpdateToMenuSelections', function(self)
    --WoWTools_ChineseMixin:SetLabel(self.Text)
    WoWTools_ChineseMixin:HookLabel(self.Text)
end)











hooksecurefunc(DropdownButtonMixin, 'SetupMenu', function(self)
    WoWTools_ChineseMixin:SetLabel(self.Text)
end)




hooksecurefunc(MenuVariants, 'CreateFontString', function(frame)
    WoWTools_ChineseMixin:HookLabel(frame.fontString)
end)
hooksecurefunc(MenuVariants, 'CreateCheckbox', function(_, frame)
    WoWTools_ChineseMixin:HookLabel(frame.fontString)
end)
hooksecurefunc(MenuVariants, 'CreateRadio', function(_, frame)
    WoWTools_ChineseMixin:HookLabel(frame.fontString)
end)





hooksecurefunc(MenuUtil, 'SetElementText', function(elementDescription, text)
    local name= WoWTools_ChineseMixin:SetText(text)
    if name and name~=text then
        elementDescription.text = name
    end
end)

--[[elementDescription:AddInitializer(function(button)
    button.Text:SetText(name)
end)]]

