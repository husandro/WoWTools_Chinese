-- []= {[1]='', [2]='', [3]='', [4]='', [5]=''},--
local tab={
[2544]= {[1]='中立', [2]='偏爱', [3]='尊重', [4]='重视', [5]='崇尚'},--工匠商盟-巨龙群岛支部
[2550]= {[1]='空', [2]='低', [3]='中', [4]='高', [5]='最大'},--钴蓝集所
[2517]= {[1]='熟人', [2]= '同好', [3]='盟友', [4]='龙牙', [5]='朋友', [6]='挚友'},--拉希奥
[2518]= {[1]='熟人', [2]= '同好', [3]='盟友', [4]='龙牙', [5]='朋友', [6]='挚友'},--萨贝里安
[2553]= {[1]='畸体', [2]='未来之友', [3]='裂隙修复者', [4]='时间行者', [5]='传奇'},--索莉多米
[2615]= {[1]='学士', [2]='助理', [3]='合约', [4]='常驻', [5]='终身'},--艾泽拉斯档案馆
[2568]= {[1]='有抱负', [2]='业余', [3]='能干', [4]='老练', [5]='专业'},--格里梅罗格竞速者

[2432]= {[1]='猜忌', [2]='防备', [3]='犹豫', [4]='纠结', [5]='和善', [6]='欣赏'},--威-娜莉

[1740]= {[1]='保镖', [2]='贴身保镖', [3]='亲密搭档'},--艾达-晨光
[1739]= {[1]='保镖', [2]='贴身保镖', [3]='亲密搭档'},--薇薇安
[1738]= {[1]='保镖', [2]='贴身保镖', [3]='亲密搭档'},--防御者艾萝娜
[1733]= {[1]='保镖', [2]='贴身保镖', [3]='亲密搭档'},--德尔瓦-铁拳
[1737]= {[1]='保镖', [2]='贴身保镖', [3]='亲密搭档'},--鸦爪祭司伊沙尔
[1736]= {[1]='保镖', [2]='贴身保镖', [3]='亲密搭档'},--托莫克
[1741]= {[1]='保镖', [2]='贴身保镖', [3]='亲密搭档'},--利奥拉

[1374]= {[1]='等级1', [2]='等级2', [3]='等级3', [4]='等级4', [5]='等级5', [6]='等级6', [7]='等级7', [8]='等级8', [9]='等级9', [10]='顶级'},--搏击竞技场（第1赛季）
[1690]= {[1]='等级1', [2]='等级2', [3]='等级3', [4]='等级4', [5]='等级5', [6]='等级6', [7]='等级7', [8]='等级8', [9]='等级9', [10]='顶级'},--搏击竞技场（第2赛季）
[2010]= {[1]='等级1', [2]='等级2', [3]='等级3', [4]='等级4', [5]='等级5', [6]='等级6', [7]='等级7', [8]='等级8', [9]='等级9', [10]='顶级'},--搏击竞技场（第3赛季）

[1419]= {[1]='等级1', [2]='等级2', [3]='等级3', [4]='等级4', [5]='等级5', [6]='等级6', [7]='等级7', [8]='等级8', [9]='等级9', [10]='顶级'},--比兹莫搏击俱乐部（第1赛季）
[1691]= {[1]='等级1', [2]='等级2', [3]='等级3', [4]='等级4', [5]='等级5', [6]='等级6', [7]='等级7', [8]='等级8', [9]='等级9', [10]='顶级'},--比兹莫搏击俱乐部（第2赛季）
[2011]= {[1]='等级1', [2]='等级2', [3]='等级3', [4]='等级4', [5]='等级5', [6]='等级6', [7]='等级7', [8]='等级8', [9]='等级9', [10]='顶级'},--比兹莫搏击俱乐部（第3赛季）

[1358]= {[1]='陌生人', [2]='同伴', [3]='哥们', [4]='朋友', [5]='好友', [6]='挚友'},--纳特·帕格
}




do
    for friendshipFactionID, info in pairs(tab) do
        local rankInfo = C_GossipInfo.GetFriendshipReputation(friendshipFactionID)
        local rank = C_GossipInfo.GetFriendshipReputationRanks(friendshipFactionID)
        if rankInfo and rank then
            WoWTools_ChineseMixin:SetCN(rankInfo.reaction, info[rank.currentLevel])
        end
    end
end
tab=nil