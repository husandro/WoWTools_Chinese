local e= select(2, ...)
local tab={
    [198268]='便携式工匠工作台',
}


for itemID, cnName in pairs(tab) do
    local name= C_Item.GetItemNameByID(itemID)
    if name then
        e.strText[name]= cnName
        tab[itemID]=nil
    end 
end


local panel= CreateFrame('Frame')
panel:RegisterEvent('ITEM_DATA_LOAD_RESULT')
panel:SetScript("OnEvent", function(_,_, itemID, success)
    if success then
        local cnName= tab[itemID]
        if cnName then
            local name= C_Item.GetItemNameByID(itemID)
            if name then
                e.strText[name]= cnName
                tab[itemID]=nil
            end 
        end
    end
end)