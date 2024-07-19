local e= select(2, ...)


--QuestInfo.lua
e.set(QuestInfoDescriptionHeader)
e.set(QuestInfoObjectivesHeader)
e.set(QuestInfoRewardsFrame.Header)
e.set(QuestInfoRewardsFrame.ItemReceiveText)
e.set(MapQuestInfoRewardsFrame.ItemReceiveText)
e.set(QuestInfoAccountCompletedNotice)


hooksecurefunc('QuestInfo_ShowTitle', function()
   local title= e.Get_Quest_Info(e.Get_QuestID(), true, false, false)
   if not title then
      return
   end
	if QuestInfoFrame.questLog and IsCurrentQuestFailed() then
		title = format('%s-(|cnRED_FONT_COLOR:失败|r)', title);
	end
	QuestInfoTitleHeader:SetText(title);
end)



hooksecurefunc('QuestInfo_ShowDescriptionText', function()
   local desc=  e.Get_Quest_Info(e.Get_QuestID(), false, false, true)
   if desc then
      QuestInfoDescriptionText:SetText(desc)
   end
end)

hooksecurefunc('QuestInfoTimerFrame_OnUpdate', function(self, elapsed)
	if self.timeLeft then
		self.timeLeft = max(self.timeLeft - elapsed, 0);
		QuestInfoTimerText:SetText("剩余时间： "..SecondsToTime(self.timeLeft));
	end
end


hooksecurefunc('QuestInfo_ShowObjectives', function()
	local questID = e.Get_QuestID()
	local numObjectives = GetNumQuestLeaderBoards();
	local objective;
	local text, type, finished;
	local objectivesTable = QuestInfoObjectivesFrame.Objectives;
	local numVisibleObjectives = 0;

	local waypointText = C_QuestLog.GetNextWaypointText(questID);
	if ( waypointText ) then
		numVisibleObjectives = numVisibleObjectives + 1;
		objective = objectivesTable[numVisibleObjectives]
      if objective then
		   objective:SetFormattedText('0/1 %s （可选）', e.cn(waypointText))
      end
	end

	for i = 1, numObjectives do
		text, type, finished = GetQuestLogLeaderBoard(i);
		if (type ~= "spell" and type ~= "log" and numVisibleObjectives < MAX_OBJECTIVES) then
			numVisibleObjectives = numVisibleObjectives+1;
			objective = objectivesTable[numVisibleObjectives]
         if objective then
            if ( not text or strlen(text) == 0 ) then
               text = e.strText[type]
            end
            if ( finished ) then
               text = e.cn(text).." (完成)"
            end
            if text then
               objective:SetText(text)
            end
         end
      end
	end
end)











--[[
local function set_Detail()
   local data= e.Get_Quest_Info(e.Get_QuestID())
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


--QuestFrame.lua
hooksecurefunc('QuestFrame_SetPortrait', function()
   if not UnitExists('questnpc') then
      return
   end
   local name, name2= e.Get_Unit_Name('questnpc', nil, true)
   if name then
      QuestFrame:SetTitle(name..(name2 and ' - '..name2 or ''))
   end
  
end)

]]



