

local e= select(2, ...)
if not DropdownTextMixin then
    return
end



hooksecurefunc(DropdownTextMixin, 'OnLoad', function(self)
    local text= self.text and e.strText[self.text]
    if text then
		self:SetText(text)
	end
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

hooksecurefunc(MenuVariants, 'CreateFontString', function(frame)
    local type= frame:GetObjectType()--=='Button'

    for _, region in pairs({frame:GetRegions()}) do       
        if region:GetObjectType()=='FontString' then
            e.hookLabel(region)
        end
    end
end)







local function GeneratorFunction(owner, rootDescription)
	rootDescription:CreateTitle("My Title");
	rootDescription:CreateButton("My Button", function(data)
    	-- Button handling here.
	end);
end);
local submenu = rootDescription:CreateButton("My Submenu");
submenu:CreateButton("Enable", SetEnabledFunction, true);
submenu:CreateButton("Disable", SetEnabledFunction, false);



