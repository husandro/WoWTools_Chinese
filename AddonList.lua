local e= select(2, ...)


--插件
AddonListTitleText:SetText('插件列表')


AddonListEnableAllButton:SetText('全部启用')
AddonListDisableAllButton:SetText('全部禁用')
hooksecurefunc('AddonList_Update', function()--AddonList.lua
    if ( not InGlue() ) then
        if ( AddonList_HasAnyChanged() ) then
            AddonListOkayButton:SetText('重新加载UI')
        else
            AddonListOkayButton:SetText('确定')
        end
    end
end)
AddonListCancelButton:SetText('取消')
hooksecurefunc('AddonList_InitButton', function(entry, addonIndex)
    local security = select(6, C_AddOns.GetAddOnInfo(addonIndex))
    -- Get the character from the current list (nil is all characters)
    local character = UIDropDownMenu_GetSelectedValue(AddonCharacterDropDown)
    if ( character == true ) then
        character = nil
    end
    local loadable, reason = C_AddOns.IsAddOnLoadable(addonIndex, character)
    local checkboxState = C_AddOns.GetAddOnEnableState(addonIndex, character)
    if (checkboxState == Enum.AddOnEnableState.Some ) then
        entry.Enabled.tooltip = '该插件只对某些角色启用。'
    end
    local name= _G["ADDON_"..security]
    if name then
        local text2= e.strText[name]
        if text2 then
            entry.Security.tooltip = text2
        end
        if ( not loadable and reason ) then
            e.set(entry.Status, name)
        end
    end
end)

C_Timer.After(2, function()
    e.region(AddonListForceLoad)
end)