local e= select(2, ...)


--QuestInfo.lua
--没测试
e.hookLabel(QuestInfoDescriptionHeader)
e.hookLabel(QuestInfoObjectivesHeader)
e.hookLabel(QuestInfoRewardsFrame.Header)
e.hookLabel(QuestInfoRewardsFrame.ItemReceiveText)
e.hookLabel(MapQuestInfoRewardsFrame.ItemReceiveText)
e.hookLabel(QuestInfoAccountCompletedNotice)


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
		QuestInfoTimerText:SetText("剩余时间："..SecondsToTime(self.timeLeft));
	end
end)


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


hooksecurefunc('QuestInfo_ShowSpecialObjectives', function()
   if not QuestInfoSpellObjectiveFrame:IsShown() then
      return
   end
   local spellID, finished, spellName
   if ( QuestInfoFrame.questLog) then
      spellID, spellName, _, finished = GetQuestLogCriteriaSpell();
   else
      spellID, spellName, _, finished = GetCriteriaSpell();
   end
   if not spellID then
      return
   end
   spellName = e.strText[spellName] or e.Get_Spell_Name(spellID)
   if spellName then
      QuestInfoSpellObjectiveFrame.Name:SetText(spellName);
   end

   if (finished and QuestInfoFrame.questLog) then -- don't show as completed for the initial offer, as it won't update properly
      QuestInfoSpellObjectiveLearnLabel:SetText("学习法术：(完成)");
   else
      QuestInfoSpellObjectiveLearnLabel:SetText('学习法术：');
   end
end)


hooksecurefunc('QuestInfo_ShowTimer', function()
	local timeLeft= QuestInfoTimerFrame.timeLeft
	if timeLeft then
		QuestInfoTimerText:SetText("剩余时间："..SecondsToTime(timeLeft))
	end
end)


hooksecurefunc('QuestInfo_ShowGroupSize', function()
   if not QuestInfoGroupSize:IsShown() then
      return
   end
   local groupNum;
	if QuestInfoFrame.questLog then
		groupNum = C_QuestLog.GetSuggestedGroupSize(C_QuestLog.GetSelectedQuest());
	else
		groupNum = GetSuggestedGroupSize();
	end
	if groupNum and groupNum > 0 then
		QuestInfoGroupSize:SetFormattedText('建议玩家人数：[%d]', groupNum);
	end
end)






--[[





]]



