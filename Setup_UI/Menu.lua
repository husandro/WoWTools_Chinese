--Blizzard_Menu/MenuUtil.lua
hooksecurefunc(MenuUtil, 'SetElementText', function(desc, text)
    if text then
        if type(desc.data)=='table' and (desc.data.specID==251 or desc.data.specID==64) then--251 DK 专精 冰霜
            text= text..desc.data.specID
        end
        local cn= WoWTools_ChineseMixin:SetText(text)
        if cn then
            desc:AddInitializer(function(btn)
                btn.fontString:SetText(cn)
            end)
        end
    end
end)


hooksecurefunc(WowStyle1DropdownMixin, 'SetText', function(self, text)
    WoWTools_ChineseMixin:SetLabel(self.Text, text)
end)

hooksecurefunc(WowStyle1FilterDropdownMixin, 'UpdateText', function(self, text)
    WoWTools_ChineseMixin:SetLabel(self.Text, self.text)
end)
--[[
hooksecurefunc(WowStyle1FilterDropdownMixin, 'SetText', function(self, text)
    WoWTools_ChineseMixin:SetLabel(self.Text, text)
end)
MenuTemplates.lua
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

elementDescription:AddInitializer(function(button)
    button.Text:SetText(name)
end)]]

