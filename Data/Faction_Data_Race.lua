local tab= {


[1]= {'人类', '人类'},
[2]= {'兽人', '兽人'},
[3]= {'矮人', '矮人'},
[4]= {'暗夜精灵', '暗夜精灵'},
[5]= {'亡灵', '亡灵'},
[6]= {'牛头人', '牛头人'},
[7]= {'侏儒', '侏儒'},
[8]= {'巨魔', '巨魔'},
[9]= {'地精', '地精'},
[10]= {'血精灵', '血精灵'},
[11]= {'德莱尼', '德莱尼'},
[12]= {'邪兽人', '邪兽人'},
[13]= {'纳迦', '纳迦'},
[14]= {'破碎者', '破碎者'},
[15]= {'骷髅', '骸骨'},
[16]= {'维库人', '维库人'},
[17]= {'海象人', '海象人'},
[18]= {'森林巨魔', '森林巨魔'},
[19]= {'牦牛人', '牦牛人'},
[20]= {'诺森德骷髅', '诺森德骷髅'},
[21]= {'冰巨魔', '冰巨魔'},
[22]= {'狼人', '狼人'},
[23]= {'吉尔尼斯人', '吉尔尼斯人'},
[24]= {'熊猫人', '熊猫人'},
[25]= {'熊猫人', '熊猫人'},
[26]= {'熊猫人', '熊猫人'},
[27]= {'夜之子', '夜之子'},
[28]= {'至高岭牛头人', '至高岭牛头人'},
[74]= {'崖际荒狂幼龙', nil},
[29]= {'虚空精灵', '虚空精灵'},
[30]= {'光铸德莱尼', '光铸德莱尼'},
[31]= {'赞达拉巨魔', '赞达拉巨魔'},
[32]= {'库尔提拉斯人', '库尔提拉斯人'},
[33]= {'人类', '人类'},
[34]= {'黑铁矮人', '黑铁矮人'},
[35]= {'狐人', '狐人'},
[36]= {'玛格汉兽人', '玛格汉兽人'},
[37]= {'机械侏儒', '机械侏儒'},
[52]= {'龙希尔', nil},
[70]= {'龙希尔', nil},
[71]= {'高地幼龙', nil},
[72]= {'复苏始祖幼龙', nil},
[73]= {'盘曲蜿变幼龙', nil},
[75]= {'幻容', nil},
[76]= {'幻容', nil},
[77]= {'载风迅疾幼龙', nil},
[80]= {'岩洞灵翼幼龙', nil},
[83]= {'繁盛奇想幼龙', nil},
[84]= {'土灵', '土灵'},
[85]= {'土灵', '土灵'},
[86]= {'哈籁尼尔', nil},
[87]= {'飞艇', nil},
[82]= {'阿加驭雷者', nil},





}

--[[
C_AlliedRaces.GetRaceInfoByID
maleName	string	
femaleName	string	
description string

C_CreatureInfo.GetRaceInfo
raceName	string	localized name, e.g. "Night Elf"
clientFileString	string	non-localized name, e.g. "NightElf"
local e= select(2, ...)

[ID]= {'Name_lang', 'Name_female_lang'},
https://wago.tools/db2/ChrRaces?locale=zhCN
11.0.2.55763
]]
local e= select(2, ...)
do
for raceID, data in pairs(tab) do
    local info= C_AlliedRaces.GetRaceInfoByID(raceID) or C_CreatureInfo.GetRaceInfo(raceID)
    if info then
        if info.raceName then
            e.strText[info.raceName]= data[1]
        else
            if info.maleName then
                e.strText[info.maleName]= data[1]
            end
            if info.femaleName and data[2] then
                e.strText[info.maleName]= data[2]
            end
        end
    end
end
end
tab=nil


