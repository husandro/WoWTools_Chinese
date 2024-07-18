local e= select(2, ...)



e.set(QuestScrollFrame.SearchBox.Instructions)


--[[
QuestScrollFrame.headerFramePool,
QuestScrollFrame.campaignHeaderFramePool,
QuestScrollFrame.campaignHeaderMinimalFramePool,
QuestScrollFrame.covenantCallingsHeaderFramePool
]]

local function set_text(line)
    e.set(line.ButtonText)
    if line.Text then
        local name =  e.Get_Quest_Info(line.questID, true, false, false)
        if name then
            line.Text:SetText(name)
        end
   end
end
hooksecurefunc("QuestLogQuests_Update", function()
    for line in QuestScrollFrame.headerFramePool:EnumerateActive() do
        set_text(line)
    end

    for line in QuestScrollFrame.titleFramePool:EnumerateActive() do
        set_text(line)
       e.set(line.ButtonText)
    end

    for line in QuestScrollFrame.campaignHeaderFramePool:EnumerateActive() do
       e.set(line.Text)
       e.set(line.Progress)
    end

    for line in QuestScrollFrame.covenantCallingsHeaderFramePool:EnumerateActive() do--没测试
        set_text(line)
    end
 end)