
--团队查找器
--RaidFinder.lua







--加入，按钮
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

