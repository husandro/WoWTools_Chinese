local e = select(2, ...)

ReputationFrame.ReputationDetailFrame.ViewRenownButton:SetText('浏览名望')--ReputationFrame.xml
ReputationFrame.ReputationDetailFrame.WatchFactionCheckbox.Label:SetText('显示为经验条')
ReputationFrame.ReputationDetailFrame.MakeInactiveCheckbox.Label:SetText('隐藏')
ReputationFrame.ReputationDetailFrame.AtWarCheckbox.Label:SetText('交战状态')

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
    