local id, e= ...

local function Init()
    BarberShopFrame.CancelButton:SetText('取消')
    BarberShopFrame.ResetButton:SetText('重置')
    BarberShopFrame.AcceptButton:SetText('接受')
end





--###########
--加载保存数据
--###########
local panel= CreateFrame("Frame")
panel:RegisterEvent("ADDON_LOADED")
panel:SetScript("OnEvent", function(self, _, arg1)
    if id==arg1 then
        if C_AddOns.IsAddOnLoaded('Blizzard_BarbershopUI') then
            Init()
            self:UnregisterEvent('ADDON_LOADED')
        end

    elseif arg1=='Blizzard_BarbershopUI' then--冒险指南
        Init()
        self:UnregisterEvent('ADDON_LOADED')
    end
end)
