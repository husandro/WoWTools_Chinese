local e= select(2, ...)




e.hookLabel(QuestInfoDescriptionHeader)
e.hookLabel(QuestInfoObjectivesHeader)
e.hookLabel(QuestInfoRewardsFrame.Header)
e.hookLabel(QuestInfoRewardsFrame.ItemReceiveText)

if WoWeuCN_Quests_OnEvent then
   return
end

local function Get_QuestID()
   if QuestInfoFrame.questLog then
      return C_QuestLog.GetSelectedQuest()
   else
      return GetQuestID()
   end
end


--[[
QuestScrollFrame.headerFramePool,
QuestScrollFrame.campaignHeaderFramePool,
QuestScrollFrame.campaignHeaderMinimalFramePool,
QuestScrollFrame.covenantCallingsHeaderFramePool
]]
hooksecurefunc("QuestLogQuests_Update", function()
   for line in QuestScrollFrame.headerFramePool:EnumerateActive() do
      e.set(line.ButtonText)
   end

   for line in QuestScrollFrame.titleFramePool:EnumerateActive() do
      if line.Text then

         local name =  e.Get_Quest_Info(line.questID, true, false, false)
         if name then
            line.Text:SetText(name)
         end
      end
   end
end)



local function set_Detail()
   local data= e.Get_Quest_Info(Get_QuestID())
   if not data then
      return
   end
   local title= data["Title"]
   if title and title~='' then
      QuestInfoTitleHeader:SetText(title)
   end
   local object= data["Objectives"]
   if object then
      QuestInfoObjectivesText:SetText(object)
   end
   local desc= data["Description"]
   if desc and desc~='' then
      QuestInfoDescriptionText:SetText(desc)
   end
end
hooksecurefunc("QuestMapFrame_ShowQuestDetails", function()
   local data= e.Get_Quest_Info(Get_QuestID())
   if not data then
      return
   end
   local title= data["Title"]
   if title and title~='' then
      QuestInfoTitleHeader:SetText(title)
   end
   local object= data["Objectives"]
   if object then
      QuestInfoObjectivesText:SetText(object)
   end
   local desc= data["Description"]
   if desc and desc~='' then
      QuestInfoDescriptionText:SetText(desc)
   end
end)

hooksecurefunc('QuestInfo_ShowRewards', set_Detail)





hooksecurefunc('QuestFrame_SetPortrait', function()
   local name, name2= e.Get_Unit_Name('questnpc', nil, true)
   if name then
      QuestFrame:SetTitle(name..(name2 and ' - '..name2 or ''))
   end
end)

