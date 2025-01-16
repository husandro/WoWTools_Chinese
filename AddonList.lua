local e= select(2, ...)


--插件
AddonListTitleText:SetText('插件列表')


if AddonList.SearchBox then--11.1
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

else
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
    hooksecurefunc('AddonList_InitButton', function(entry)
        if not entry then
            return
        end
        --entry.Enabled.tooltip= e.cn(entry.Enabled.tooltip)
        e.hookLabel(entry.Status)
        --entry.Security.tooltip= e.cn(entry.Security.tooltip)
    end)

    C_Timer.After(2, function()
        e.region(AddonListForceLoad)
    end)
end