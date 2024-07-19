local e= select(2, ...)






hooksecurefunc("QuestMapFrame_ShowQuestDetails",function()
    print('QuestMapFrame_ShowQuestDetails')
    e.Set_QuestInfo()
end)