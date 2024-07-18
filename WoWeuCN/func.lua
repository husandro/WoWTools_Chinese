local e= select(2, ...)




e.hookLabel(QuestInfoDescriptionHeader)
e.hookLabel(QuestInfoObjectivesHeader)
e.hookLabel(QuestInfoRewardsFrame.Header)
e.hookLabel(QuestInfoRewardsFrame.ItemReceiveText)

e.set(QuestMapFrame.DetailsFrame.BackFrame.BackButton)
e.set(QuestMapFrame.DetailsFrame.RewardsFrameContainer.RewardsFrame.Label)
e.hookLabel(MapQuestInfoRewardsFrame.ItemReceiveText)



e.region(MapQuestInfoRewardsFrame, nil, true)











--[[if WoWeuCN_Quests_OnEvent then
   return
end]]


local function Get_QuestID()
   if QuestInfoFrame.questLog then
      return C_QuestLog.GetSelectedQuest()
   else
      return GetQuestID()
   end
end
e.hookLabel(QuestInfoAccountCompletedNotice)



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
--hooksecurefunc("QuestMapFrame_ShowQuestDetails", set_Detail)
--hooksecurefunc('QuestInfo_ShowRewards', set_Detail)
hooksecurefunc('QuestInfo_Display', set_Detail)



hooksecurefunc('QuestFrame_SetPortrait', function()
   local name, name2= e.Get_Unit_Name('questnpc', nil, true)
   if name then
      QuestFrame:SetTitle(name..(name2 and ' - '..name2 or ''))
   end
end)

