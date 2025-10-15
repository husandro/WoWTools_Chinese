--Blizzard_Menu/MenuUtil.lua
hooksecurefunc(MenuUtil, 'SetElementText', function(desc)
    desc:AddInitializer(function(btn)
        WoWTools_ChineseMixin:HookLabel(btn.fontString)
    end)
end)


hooksecurefunc(WowStyle1DropdownMixin, 'SetText', function(frame, text)
    WoWTools_ChineseMixin:SetLabel(frame.Text, text)
end)

hooksecurefunc(WowStyle1FilterDropdownMixin, 'UpdateText', function(frame, text)
    WoWTools_ChineseMixin:SetLabel(frame.Text, text)
end)

--下拉菜单
hooksecurefunc(WowStyle2DropdownMixin, 'SetText', function(frame, text)
    WoWTools_ChineseMixin:SetLabel(frame.Text, text)
end)
hooksecurefunc(DropdownTextMixin, 'OnLoad', function(frame)
    WoWTools_ChineseMixin:HookLabel(frame.Text)
end)
--[[
hooksecurefunc(WowStyle1FilterDropdownMixin, 'SetText', function(frame, text)
    WoWTools_ChineseMixin:SetLabel(frame.Text, text)
end)
MenuTemplates.lua
hooksecurefunc('GetWowStyle1ArrowButtonState', function(frame)
    WoWTools_ChineseMixin:HookLabel(frame.Text)

end)
hooksecurefunc(DropdownTextMixin, 'OnLoad', function(frame)
    WoWTools_ChineseMixin:HookLabel(frame.Text)
end)
hooksecurefunc(DropdownTextMixin, 'UpdateText', function(frame)
	WoWTools_ChineseMixin:SetLabel(frame.Text)
    
	if frame.resizeToText then
        local newWidth = frame.Text:GetUnboundedStringWidth();
        if frame.resizeToTextPadding then
            newWidth = newWidth + frame.resizeToTextPadding;
        end
        if frame.resizeToTextMaxWidth then
            newWidth = math.min(frame.resizeToTextMaxWidth, newWidth);
        end
        if frame.resizeToTextMinWidth then
            newWidth = math.max(frame.resizeToTextMinWidth, newWidth);
        end
        frame:SetWidth(newWidth);
    end
end)
hooksecurefunc(DropdownSelectionTextMixin, 'OverrideText', function(frame)
    WoWTools_ChineseMixin:HookLabel(frame.Text)
end)
hooksecurefunc(DropdownSelectionTextMixin, 'UpdateToMenuSelections', function(frame)
    --WoWTools_ChineseMixin:SetLabel(frame.Text)
    WoWTools_ChineseMixin:HookLabel(frame.Text)
end)











hooksecurefunc(DropdownButtonMixin, 'SetupMenu', function(frame)
    WoWTools_ChineseMixin:SetLabel(frame.Text)
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

