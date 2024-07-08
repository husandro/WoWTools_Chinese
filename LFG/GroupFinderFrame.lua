local e= select(2, ...)


GroupFinderFrame:HookScript('OnShow', function()
    PVEFrame:SetTitle('地下城和团队副本')
end)

GroupFinderFrame.groupButton1.name:SetText('地下城查找器')
e.set(LFDQueueFrameTypeDropdownName)
e.set(RaidFinderQueueFrameSelectionDropdownName)
GroupFinderFrame.groupButton2.name:SetText('团队查找器')
GroupFinderFrame.groupButton3.name:SetText('预创建队伍')


--RaidFinder.lua
hooksecurefunc('RaidFinderFrameFindRaidButton_Update', function()
    local mode = GetLFGMode(LE_LFG_CATEGORY_RF, RaidFinderQueueFrame.raid)
    if ( mode == "queued" or mode == "rolecheck" or mode == "proposal" or mode == "suspended" ) then
        RaidFinderFrameFindRaidButton:SetText('离开队列')
    else
        if ( IsInGroup() and GetNumGroupMembers() > 1 ) then
            RaidFinderFrameFindRaidButton:SetText('小队加入')
        else
            RaidFinderFrameFindRaidButton:SetText('寻找组队')
        end
    end
end)
