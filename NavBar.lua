local e= select(2, ...)

--[[
导航条
NavigationBar.lua
navButton= self.navList[#self.navList]
local navButton = self.freeButtons[#self.freeButtons];
navButton.myclick = buttonData.OnClick;
navButton.listFunc = buttonData.listFunc;
navButton.id = buttonData.id;
navButton.data = buttonData
]]

hooksecurefunc('NavBar_AddButton', function(self, buttonData)
    local navButton = self.navList[#self.navList]
    local name= e.strText[buttonData.name]
    if name then
        e.font(navButton.text)
        navButton.text:SetText(name)
        local buttonExtraWidth
        if ( buttonData.listFunc and not self.oldStyle ) then
            buttonExtraWidth = 53
        else
            buttonExtraWidth = 30
        end
        navButton:SetWidth(navButton.text:GetStringWidth() + buttonExtraWidth)
    end
end)


hooksecurefunc('NavBar_Initialize', function(_, _, homeData, homeButton)
    e.font(homeButton.text)
    e.set(homeButton.text)
end)
