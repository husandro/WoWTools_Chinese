local e= select(2, ...)

--NavigationBar.lua
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
    if homeData.name then
        e.set(homeButton.text, homeData.name)
    else
        e.font(navButton.text)
        homeButton.text:SetText('首页')
    end
end)
