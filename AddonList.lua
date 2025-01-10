local e= select(2, ...)


--插件
AddonListTitleText:SetText('插件列表')

e.set(AddonList.SearchBox.Instructions)

AddonList.EnableAllButton:SetText('全部启用')
AddonList.DisableAllButton:SetText('全部禁用')
hooksecurefunc('AddonList_Update', function()--AddonList.lua
    if ( not InGlue() ) then
        if ( AddonList_HasAnyChanged() ) then
            AddonList.OkayButton:SetText('重新加载UI')
        else
            AddonList.OkayButton:SetText('确定')
        end
    end
end)
AddonList.CancelButton:SetText('取消')
--hooksecurefunc('AddonList_InitButton', function(entry)
hooksecurefunc('AddonList_InitAddon', function(entry)
    if entry then
        e.hookLabel(entry.Status)
        e.hookLabel(entry.Reload)
    end
end)

C_Timer.After(2, function()
    e.region(AddonListForceLoad)
end)