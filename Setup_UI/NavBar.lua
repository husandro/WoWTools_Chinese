

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
    local name= WoWTools_ChineseMixin:CN(buttonData.name)
    if name then
        WoWTools_ChineseMixin:SetCNFont(navButton.text)
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
    WoWTools_ChineseMixin:SetCNFont(homeButton.text)
    WoWTools_ChineseMixin:SetLabel(homeButton.text)
end)
