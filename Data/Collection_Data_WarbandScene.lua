--https://wago.tools/db2/WarbandScene?locale=zhCN

local tab={
[1]= {"冒险者之眠", "郁郁葱葱的林地和风景优美的瀑布，还有什么比这更好的扎营地点吗？"},
[4]= {"欧恩哈拉瞭望台", "艾泽拉斯各地的冒险者都找不到比这里风景更好的休憩之地了。"},
[5]= {"密教徒的港湾", "地下堡中偶尔传来密教徒的念诵之声，又被奔腾的流水所淹没。"},
[7]= {"芙原清泉", "芙原村的土灵很乐意接待声名显赫的冒险者，只要你收拾干净就行。"},
[25]= {"加乐宫大画廊", "虽然加里维克斯决心榨干安德麦的每一分价值，不过他确实很有品味！"},
[29]= {"从偏好中随机选取", "每次登录时选取一个偏好营区。如果没有偏好营区，则会从整个收藏中选取。"},
[99]= {"冒险者之眠", nil},
[111]= {"冒险者之眠", nil},
[119]= {"被吞噬者的命运", "塔扎维什，帷纱集市坐拥众多便利的设施、香气扑鼻的街头美食、最新潮的虚灵幻化，还有绝赞的美景。"},
}



do
    for warbandSceneID, data in pairs(tab) do
        local info= C_WarbandScene.GetWarbandSceneEntry(warbandSceneID)
        if info then
            WoWTools_ChineseMixin:SetCN(info.name, data[1])
            tab[warbandSceneID][1]= nil
            --WoWTools_ChineseMixin:SetCN(info.description, data[2])
            --WoWTools_ChineseMixin:SetCN(info.source, data[3])
        end
    end
end

--SharedCollectionTemplates.lua
hooksecurefunc(WarbandSceneEntryMixin, 'OnEnter', function(self)
    local id= self.warbandSceneInfo and self.warbandSceneInfo.warbandSceneID
    local data= tab[id]
    if not data or not (data[2] and data[3]) then
        return
    end
    local tooltip = GetAppropriateTooltip()
    tooltip:AddLine(' ')
    tooltip:AddLine(data[2], nil, nil, nil, true)
    if data[3] then
        tooltip:AddLine(' ')
        tooltip:AddLine(data[3], nil, nil, nil, true)
    end
    GameTooltip_CalculatePadding(tooltip)
end)