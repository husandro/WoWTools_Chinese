--[[
职业
https://wago.tools/db2/ChrClasses?locale=zhCN
]]
local tab= {

[1] ='战士',
[2] ='圣骑士',
[3] ='猎人',
[4] ='潜行者',
[5] ='牧师',
[6] ='死亡骑士',
[7] ='萨满祭司',
[8] ='法师',
[9] ='术士',
[10] ='武僧',
[11] ='德鲁伊',
[12] ='恶魔猎手',
[13] ='唤魔师',
[14] ='冒险者',
}
do
    for classID, name in pairs(tab) do
        local classFilename= select(2, GetClassInfo(classID))
        local hex=classFilename and select(4, GetClassColor(classFilename))
        if hex then
            tab[classID]=(
                    classFilename~='EVOKER'
                    and '|A:groupfinder-icon-class-'..classFilename..':0:0|a'
                    or '|A:UI-HUD-UnitFrame-Player-Portrait-ClassIcon-Evoker:0:0|a'
                )
                ..'|c'..hex..name..'|r'
        end
    end
end
do

--英文
for index, name in pairs({
    'Warrior',
    'Paladin',
    'Hunter',
    'Rogue',
    'Priest',
    'Death Knight',
    'Shaman',
    'Mage',
    'Warlock',
    'Monk',
    'Druid',
    'Demon Hunter',
    'Evoker',
}) do
    WoWTools_ChineseMixin:SetCN(name,  tab[index])

end




--有男，女之分
--[[
	local numClasses = GetNumClasses();
	local count = 0;
	for i = 1, numClasses do
		local _, _, classID = GetClassInfo(i);
		for j = 1, C_SpecializationInfo.GetNumSpecializationsForClassID(classID) do
			count = count + 1
		end
	end
]]
    
    for id, cn in pairs(tab) do
        WoWTools_ChineseMixin:SetCN(GetClassInfo(id), cn)
        --WoWTools_ChineseMixin:SetCN(classFile, cn)
    end

    local className, _, classID=  UnitClass('player')--男
    --WoWTools_ChineseMixin:SetCN(classFile, tab[classID])
    WoWTools_ChineseMixin:SetCN(className, tab[classID])


    --[[className, _, classID=  UnitClass('player', 3)--女
    --WoWTools_ChineseMixin:SetCN(classFile, tab[classID])
    WoWTools_ChineseMixin:SetCN(className, tab[classID])]]
end

tab=nil


