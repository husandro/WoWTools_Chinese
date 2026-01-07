--[[
https://wago.tools/db2/ResearchBranch?locale=zhCN
[ID]= "Name_lang",
]]
local tab={
[1]= "矮人",
[2]= "德莱尼",
[3]= "化石",
[4]= "暗夜精灵",
[5]= "蛛魔",
[6]= "兽人",
[7]= "托维尔",
[8]= "巨魔",
[27]= "维库人",
[29]= "螳螂妖",
[229]= "熊猫人",
[231]= "魔古族",
[315]= "鸦人",
[350]= "德拉诺氏族",
[382]= "食人魔",
[404]= "上层精灵",
[406]= "至高岭牛头人",
[408]= "恶魔",
[423]= "赞达拉巨魔",
[424]= "德鲁斯特",
}

do
    for branchID, cn in pairs(tab) do
        WoWTools_ChineseMixin:SetCN(GetArchaeologyRaceInfoByID(branchID), cn)
    end
end
tab=nil








if ArcheologyDigsiteProgressBar then
    WoWTools_ChineseMixin:SetLabel(ArcheologyDigsiteProgressBar.BarTitle)
end

function WoWTools_ChineseMixin.Events:Blizzard_ArchaeologyUI()
    ArchaeologyFrameTitleText:SetText('考古学')
    ArchaeologyFrameSummaryPageTitle:SetText('种族')
    ArchaeologyFrameCompletedPage.infoText:SetText('你还没有完成任何神器。寻找碎片及钥石以完成神器。')
    ArchaeologyFrameCompletedPage.titleBig:SetText('已完成神器')
    ArchaeologyFrameCompletedPage.titleMid:SetText('已完成的普通神器')

    ArchaeologyFrameCompletedPage.titleTop:SetText('已完成的普通神器')

    ArchaeologyFrameArtifactPage.historyTitle:SetText('历史')
    ArchaeologyFrameArtifactPage.raceRarity:SetText('种族')
    if ArchaeologyFrame.backButton then
        ArchaeologyFrame.backButton:SetText('后退')
    end
    ArchaeologyFrameArtifactPageSolveFrameSolveButton:SetText('解密')

    hooksecurefunc(ArchaeologyFrame.summaryPage, 'UpdateFrame', function(frame)
        frame.pageText:SetFormattedText('第%d页', frame.currentPage)
    end)
    hooksecurefunc(ArchaeologyFrame.completedPage, 'UpdateFrame', function(frame)
        frame.pageText:SetFormattedText('第%d页', frame.currentPage)
        frame.titleTop:SetText(frame.currData.onRare and '已完成的精良神器' or '已完成的普通神器')
    end)
    hooksecurefunc('ArchaeologyFrame_CurrentArtifactUpdate', function(frame)
        local RaceName, _, RaceitemID	= GetArchaeologyRaceInfo(frame.raceID, true)

        local runeName
        if RaceitemID and RaceitemID > 0 then
            runeName = C_Item.GetItemInfo(RaceitemID)
        end
        if runeName then
            for i=1, ARCHAEOLOGY_MAX_STONES do
                local slot= frame.solveFrame["keystone"..i]
                if slot and slot:IsShown() then
                    if ItemAddedToArtifact(i) then
                        frame.solveFrame["keystone"..i].tooltip = format('点此以移除 |cnGREEN_FONT_COLOR:%s|r 。', runeName)
                    else
                        frame.solveFrame["keystone"..i].tooltip = format('点此以从你的背包中选择一块 |cnGREEN_FONT_COLOR:%s|r 来降低完成该神器所需要的碎片数量。', runeName)
                    end
                end
            end
        end

        if select(3, GetSelectedArtifactInfo()) == 0 then --Common Item
            frame.raceRarity:SetText(RaceName.." - |cffffffff普通|r")
        else
            frame.raceRarity:SetText(RaceName.." - |cff0070dd精良|r")
        end
    end)

    ArchaeologyFrame.rankBar:HookScript('OnEnter', function()
        GameTooltip:SetText('考古学技能',  HIGHLIGHT_FONT_COLOR:GetRGB())
        GameTooltip:Show()
    end)

    ArchaeologyFrameArtifactPageSolveFrameStatusBar:HookScript('OnEnter', function()
        local _, _, _, _, _, maxCount = GetArchaeologyRaceInfo(ArchaeologyFrame.artifactPage.raceID)
        GameTooltip:SetText(format('拼出该神器所需的碎片数量。\n\n每个种族的碎片最多只能保存%d块。', maxCount), HIGHLIGHT_FONT_COLOR:GetRGB())
        GameTooltip:Show()
    end)
    ArchaeologyFrameHelpPageTitle:SetText('考古学')
    ArchaeologyFrameHelpPageHelpScrollHelpText:SetText('你需要搜集散落在世界各处的神器碎片来将它们复原为完整的神器。你能够在挖掘场里找到这些碎片，挖掘场的位置会标记在你的地图上。在挖掘场使用调查技能，你的调查工具就会显示出神器碎片大致的埋藏方向和位置。在前往一个新的挖掘地址前你可以在一个挖掘场中收集六次碎片。当你拥有了足够的碎片之后，你就可以破译隐藏在神器中的秘密，了解更多关于艾泽拉斯昔日的历史和传说。寻宝愉快！')
    ArchaeologyFrameHelpPageDigTitle:SetText('考古学地图位置标记')

    ArchaeologyFrameSummarytButton:HookScript('OnEnter', function()
        GameTooltip:SetText('当前神器')
    end)
    ArchaeologyFrameCompletedButton:HookScript('OnEnter', function()
        GameTooltip:SetText('已完成神器')
    end)
end