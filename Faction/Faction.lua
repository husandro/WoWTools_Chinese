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

    TokenFramePopup.Title:SetText('货币设置')
    TokenFramePopup.InactiveCheckBox.Text:SetText('未使用')
    TokenFramePopup.BackpackCheckBox.Text:SetText('在行囊上显示')
    hooksecurefunc(ReputationFrame.ScrollBox, 'Update', function(self)
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
    end)
end