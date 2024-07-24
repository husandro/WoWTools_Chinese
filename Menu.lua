--Blizzard_Menu

local e= select(2, ...)
if not DropdownTextMixin then
    return
end



hooksecurefunc(DropdownTextMixin, 'OnLoad', function(self)
    e.set(self.text)
end)

hooksecurefunc(DropdownTextMixin, 'UpdateText', function(self)
    local text= e.strText[self:GetUpdateText()]
    if not text then
        return
    end
	self.Text:SetText(text)
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


local function set_fontString(frame)
    C_Timer.After(0.05, function()
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


