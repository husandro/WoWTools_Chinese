local e = select(2, ...)



if ReputationHeaderMixin then--11版本
    hooksecurefunc(ReputationBarMixin, 'TryShowReputationStandingText', function(self)
        local text= self.reputationStandingText
        if text then
            local cnName= e.strText[text]
            if not cnName and text:find('(.-) %d') then
                local name= text:match('(.-) %d')
                local name2= name and e.strText[name]
                if name and name2 then
                    cnName=text:gsub(name, name2)
                end
            end
            if cnName then
                self.BarText:SetText(cnName)
            end
        end
    end)
    ReputationFrame.ReputationDetailFrame.ViewRenownButton:SetText('浏览名望')--ReputationFrame.xml
    ReputationFrame.ReputationDetailFrame.WatchFactionCheckbox.Label:SetText('显示为经验条')
    ReputationFrame.ReputationDetailFrame.MakeInactiveCheckbox.Label:SetText('隐藏')
    ReputationFrame.ReputationDetailFrame.AtWarCheckbox.Label:SetText('交战状态')
    hooksecurefunc(ReputationHeaderMixin, 'Initialize', function(self)
        if self.elementData.name then
            local cnName= e.strText[self.elementData.name]
            if cnName then
                self.Name:SetText(cnName)
            end
        end
    end)
    hooksecurefunc(ReputationEntryMixin, 'Initialize', function(self)
        if self.elementData.name then
            local cnName= e.strText[self.elementData.name]
            if cnName then
                self.Content.Name:SetText(cnName)
            end
        end
    end)

    e.hookLabel(ReputationFrame.ReputationDetailFrame.Title)
    e.hookLabel(ReputationFrame.ReputationDetailFrame.Description)
    --hooksecurefunc(ReputationFrame.ReputationDetailFrame, 'Refresh', function(self)
else









        ReputationFrameFactionLabel:SetText('阵营')--FACTION
        ReputationFrameStandingLabel:SetText("关系")--STANDING
        ReputationDetailViewRenownButton:SetText('浏览名望')--ReputationFrame.xml
        ReputationDetailMainScreenCheckBoxText:SetText( '显示为经验条')
        ReputationDetailInactiveCheckBoxText:SetText('隐藏')
        ReputationDetailAtWarCheckBoxText:SetText('交战状态')
        hooksecurefunc('ReputationFrame_InitReputationRow', function(factionRow, elementData)
            local factionIndex = elementData.index
            local name, description, standingID, _, _, _, _, _, _, _, _, _, _, factionID = GetFactionInfo(factionIndex)
            name= name and e.strText[name]
            if not name then
                return
            end

            local factionContainer = factionRow.Container
            factionContainer.Name:SetText(name)
            if not factionID then
                return
            end

            local factionStandingtext
            local isMajorFaction = factionID and C_Reputation.IsMajorFaction(factionID)
            local repInfo = factionID and C_GossipInfo.GetFriendshipReputation(factionID)
            if (repInfo and repInfo.friendshipFactionID > 0) then
                factionStandingtext = e.strText[repInfo.reaction]

            elseif ( isMajorFaction ) then
                local majorFactionData = C_MajorFactions.GetMajorFactionData(factionID) or {}
                factionStandingtext = '名望'..majorFactionData.renownLevel
            else
                factionStandingtext = e.strText[GetText("FACTION_STANDING_LABEL"..standingID, UnitSext('player'))]
            end
            if factionStandingtext then
                factionContainer.ReputationBar.FactionStanding:SetText(factionStandingtext)
                factionRow.standingText = factionStandingtext
            end
            if ( factionIndex == GetSelectedFaction() ) then
                if ( ReputationDetailFrame:IsShown() ) then
                    ReputationDetailFactionName:SetText(name)
                    e.set(ReputationDetailFactionDescription, description)
                end
            end
        end)
end

    --[[hooksecurefunc(ReputationFrame.ScrollBox, 'Update', function(self)
        if not self:GetView() then
            return
        end
        for _, frame in pairs(self:GetFrames() or {}) do
            e.set(frame.Container.Name)

            local bar=frame.Container.ReputationBar
            if bar then
                local text= bar.FactionStanding:GetText()
                if text then
                    local cnName= e.strText[text]
                    if not cnName and text:find('(.-) %d') then
                        local name= text:match('(.-) %d')
                        local name2= name and e.strText[name]
                        if name and name2 then
                            cnName=text:gsub(name, name2)
                        end
                    end
                    if cnName then
                        bar.FactionStanding:SetText(cnName)
                    end
                end
            end
        end			
    end)]]
