local e= select(2, ...)



local tab= {
    [6948]= '炉石',
}

C_Timer.After(4, function()
    do
        for itemID, text in pairs(tab) do
            local name= C_Item.GetItemNameByID(itemID)
            if name then
                e.strText[name]= text
            end
        end
    end
    tab=nil
end)