--https://wago.tools/db2/WarbandScene?locale=zhCN

local tab={

[1]= {'冒险者之眠', '郁郁葱葱的林地和风景优美的瀑布，还有什么比这更好的扎营地点吗？', nil},
[4]= {'欧恩哈拉瞭望台', '艾泽拉斯各地的冒险者都找不到比这里风景更好的休憩之地了。', nil},
[5]= {'密教徒的港湾', '地下堡中偶尔传来密教徒的念诵之声，又被奔腾的流水所淹没。', '|cFFFFD200商人出售：|r雷诺·杰克逊|n|cFFFFD200地区：|r多恩诺嘉尔|n|cFFFFD200解锁：|r推进第2赛季地下堡行者的旅程'},
[7]= {'芙原清泉', '芙原村的土灵很乐意接待声名显赫的冒险者，只要你收拾干净就行。', '|cFFFFD200成就：|r卡兹全家福'},
[25]= {'加乐宫大画廊', '虽然加里维克斯决心榨干安德麦的每一分价值，不过他确实很有品味！', '|cFFFFD200成就：|r地精模式全开'},
[29]= {'从偏好中随机选取', '每次登录时选取一个偏好营区。如果没有偏好营区，则会从整个收藏中选取。', nil},
}

do
    for warbandSceneID, data in pairs(tab) do
        local info= C_WarbandScene.GetWarbandSceneEntry(warbandSceneID)
        if info then
            WoWTools_ChineseMixin:SetCN(info.name, data[1])
            WoWTools_ChineseMixin:SetCN(info.description, data[2])
            WoWTools_ChineseMixin:SetCN(info.source, data[3])
        end
    end
end
tab=nil