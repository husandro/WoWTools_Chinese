local tab= {

    [6948]= '炉石',

}

EventRegistry:RegisterFrameEventAndCallback("LOADING_SCREEN_DISABLED", function(owner)
    do
        for itemID, text in pairs(tab) do
            WoWTools_ChineseMixin:SetCN(C_Item.GetItemNameByID(itemID), text)
        end
    end
    tab=nil
    EventRegistry:UnregisterCallback('LOADING_SCREEN_DISABLED', owner)
end)
