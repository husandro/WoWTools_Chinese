--[[
[ID]= {"Title_lang", "Description_lang"},
https://wago.tools/db2/Campaign?locale=zhCN
]]

local tab={
[1]= {"阵营战役", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[2]= {"阵营战役", "为了部落！"},
[111]= {"雷文德斯的主宰者", "雷文德斯大帝可能知道某些秘密，可以终结这场心能枯竭。深入他在雷文德斯的国度，了解更多情报。"},
[113]= {"温西尔战役", "雷文德斯的救赎之路极其艰险，但堕罪堡的黑暗王子已经准备好踏上这条路了。他需要你的帮助才能从主宰者及其爪牙手中夺得对雷文德斯的控制权。"},
[114]= {"晋升堡垒", "你被派遣前去调查在噬渊里遇到的神秘渊誓格里恩。只有统御晋升堡垒的执政官才知道他们的身份。"},
[115]= {"战争的艺术", "野心勃勃的通灵领主的土地也面临着灭绝的危机。你的到来将使迥然不同的残部重新融合为一支足以挑战命运的大军。"},
[117]= {"法夜战役", "炽蓝仙野的林地濒临灭亡。每一棵天界巨树陨落，寒冬女王的绝望都会滋长。女王和她的魅夜王庭需要你的帮助才能恢复森林的平衡。"},
[118]= {"兵主之刃", "玛卓克萨斯的大军突袭了晋升堡垒。你受命前往这个战痕密布的国度，从而探究原因。"},
[119]= {"格里恩战役", "晋升堡垒高贵的格里恩面临着危险的局面，弃誓者部队大有扫平国度之势。格里恩如果希望夺回晋升堡垒，拯救暗影界，就需要你的帮助。"},
[124]= {"炽蓝仙野的林地", "你有个重要的消息要带给寒冬女王。去炽蓝仙野的天界林地找她。"},
[125]= {"暗影界战役", "这是给位于战役之间的玩家分类的一般性战役。"},
[126]= {"黑暗迫近", "德纳修斯已经图穷匕见，你必须决定如何回应。"},
[130]= {"暗影界", nil},
[131]= {"命运丝线", nil},
[133]= {"盟约教学", nil},
[138]= {"统御之链", "展现9.1新内容的战役。"},
[140]= {"追赶！", nil},
[153]= {nil, "解锁寻找贝恩和刻符者的前置条件"},
[154]= {"托加斯特剧情进度跳过", nil},
[155]= {nil, "完成安度因剧情"},
[156]= {"暗影国度", nil},
[157]= {"万物之盒初始任务", nil},
[158]= {"初诞者的秘密", "展现9.2新内容的战役。"},
[159]= {"苏醒的龙希尔", "龙希尔初始区域，区域0，联盟"},
[162]= {"初始", nil},
[164]= {"跳转到第六章", nil},
[165]= {"龙鳞探险队", "开场剧情"},
[166]= {"欧恩哈拉平原", "平原升级任务"},
[167]= {"跳转到第五章", nil},
[168]= {"跳转到第七章", nil},
[169]= {"觉醒海岸", "觉醒海岸升级"},
[173]= {"苏醒的龙希尔", "龙希尔初始区域，区域0，部落"},
[174]= {"碧蓝林海", "碧蓝林海"},
[189]= {"索德拉苏斯", "索德拉苏斯升级"},
[190]= {"沉睡者", "欧恩哈拉平原满级绿龙剧情"},
[191]= {"专业入门跳过", nil},
[192]= {"白银使命", "提尔故事线1-4章满级提尔地图4"},
[193]= {"瓦德拉肯", nil},
[194]= {"伊斯卡拉海象人", "满级名望伊斯卡拉海象人地图1"},
[197]= {"龙鳞探险队", "龙鳞探险队名望战役"},
[199]= {"誓言母石", nil},
[200]= {"黑曜堡垒", nil},
[201]= {"巨龙时代", "主战役"},
[203]= {"奈萨里奥之烬", nil},
[207]= {"碧蓝林海", "隐藏战役"},
[209]= {"蓝龙军团", nil},
[210]= {"兹斯克拉宝库", nil},
[212]= {"流放者离岛", "本战役通过流放者离岛的内容让新玩家体验游戏。"},
[213]= {"流放者离岛", "本战役通过流放者离岛的内容让新玩家体验游戏。"},
[214]= {"争霸艾泽拉斯", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[215]= {"争霸艾泽拉斯", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[216]= {"阵营战役", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[217]= {"纳沙塔尔", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[218]= {"麦卡贡", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[219]= {"恩佐斯的幻象", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[221]= {"争霸艾泽拉斯", "身为联盟的勇士，你的职责是增援战事，对抗部落和他们的新盟友。"},
[222]= {"麦卡贡", nil},
[223]= {"纳沙塔尔", nil},
[224]= {"恩佐斯的幻象", nil},
[225]= {"阵营战役", nil},
[226]= {"争霸艾泽拉斯", nil},
[227]= {"飞珑石", nil},
[228]= {"暗影烈焰火花", nil},
[230]= {"测试战役", nil},
[231]= {"梦境守护者", nil},
[235]= {"艾泽拉斯的幻象", "内容更新初始任务"},
[236]= {"多恩岛", nil},
[237]= {"喧鸣深窟", nil},
[238]= {"陨圣峪阿拉希人", nil},
[239]= {"艾基-卡赫特", nil},
[240]= {"地心之战", "满级任务"},
[242]= {"追猎先驱", nil},
[246]= {"夺岛奇兵", nil},
[247]= {"熊猫人之谜", "击败死亡之翼后，部落和联盟的战火重燃。你身为部落的勇士，必须加入战斗。"},
[248]= {"熊猫人之谜", "击败死亡之翼后，部落和联盟的战火重燃。你身为联盟的勇士，必须加入战斗。"},
[249]= {"夺岛奇兵", nil},
[250]= {"雷电之王", nil},
[251]= {"雷电之王", nil},
[252]= {"绝地反击", nil},
[253]= {"决战奥格瑞玛", nil},
[254]= {"决战奥格瑞玛", nil},
[256]= {"巨龙时代", nil},
[257]= {"蓝龙军团", nil},
[258]= {"绿龙军团"},
[261]= {"跳过内容更新初始任务", nil},
[264]= {"安德麦", "安德麦风云"},
[265]= {"肯瑞托的命运", "肯瑞托任务线"},
[266]= {"游学探奇：萨拉塔斯", nil},
[267]= {"炽焰黎明的崛起", nil},
[268]= {"游学探奇：虚灵", nil},
[274]= {"游学探奇：精灵", nil},
[276]= {"海妖岛", nil},
[279]= {"游学探奇：阿尔萨斯", nil},
[260]= {"萦绕暗影", "11.1战役序章"},
[134]= {"盟约教学", nil},
[135]= {"盟约教学", nil},
[136]= {"盟约教学", nil},
[137]= {"盟约教学", nil},
[141]= {"追赶！", nil},
[142]= {"追赶！", nil},
[143]= {"追赶！", nil},
[144]= {"追赶！", nil},
[145]= {"追赶！", nil},
[146]= {"追赶！", nil},
[147]= {"追赶！", nil},
[160]= {"追赶！", nil},
[161]= {"追赶！", nil},
[198]= {"追赶！", nil},
[206]= {"追赶！", nil},
[208]= {"追赶！", nil},
[229]= {"追赶！", nil},
[233]= {"追赶！", nil},
[234]= {"追赶！", nil},
[241]= {"追赶！", nil},
[163]= {"初始", nil},
[313]= {"海妖岛", nil},
[314]= {"海妖岛", nil},
}




--CampaignUtil


local function GetSingleChapterText(chapterID, lineSpacing)
	local chapter = CampaignChapterCache:Get(chapterID);
	local name= WoWTools_ChineseMixin:CN(chapter.name) or chapter.name
	if chapter:IsComplete() then
		return CreateTextureMarkup("Interface/Scenarios/ScenarioIcon-Check", 16, 16, 16, 16, 0, 1, 0, 1, 0, -lineSpacing)
                .. " " .. GREEN_FONT_COLOR:WrapTextInColorCode(name)
	else
		local color = chapter:IsInProgress() and HIGHLIGHT_FONT_COLOR or LIGHTGRAY_FONT_COLOR;
		return color:WrapTextInColorCode(name)
	end
end

local function BuildAllChaptersText(campaign, lineSpacing)
	local chapterText = {};
	for _, chapterID in ipairs(campaign.chapterIDs) do
		table.insert(chapterText, GetSingleChapterText(chapterID, lineSpacing));
	end

	return table.concat(chapterText, "\n");
end

hooksecurefunc(QuestScrollFrame.CampaignTooltip, 'SetJourneyCampaign', function(self, campaign)
	local lineSpacing = 4;
	local name= WoWTools_ChineseMixin:CN(campaign)
	if not name then
		local t= tab[campaign.campaignID]
		name= t and t[1]
	end
	if name then
		self.Title:SetText(name)
	end
    
	self.ChapterTitle:SetText(CampaignUtil.BuildChapterProgressText(campaign, "|cffffd200战役进度 |n|cffffffff%1$d/%2$d 章|r|n|n"))
	self.Description:SetText(BuildAllChaptersText(campaign, lineSpacing))
	self:Layout();
	self:Show();
end)
 

hooksecurefunc(CampaignNextObjectiveMixin, 'Set', function(self, failureReason)
	--self.mapID = failureReason.mapID;
	--self.questID = failureReason.questID;
	if failureReason.text then
		local t= WoWTools_ChineseMixin:CN(failureReason.text)
		if t then
			self.Text:SetText(t)
		end
	end
end)
