




hooksecurefunc(ReputationBarMixin, 'TryShowReputationStandingText', function(frame)
    local text= frame.reputationStandingText
    if text then
        local cnName= WoWTools_ChineseMixin:CN(text)
        if not cnName and text:find('(.-) %d') then
            local name= text:match('(.-) %d')
            local name2= name and WoWTools_ChineseMixin:CN(name)
            if name and name2 then
                cnName=text:gsub(name, name2)
            end
        end
        if cnName then
            frame.BarText:SetText(cnName)
        end
    end
end)

WoWTools_ChineseMixin:HookLabel(ReputationFrame.filterDropdown.Text)
ReputationFrame.ReputationDetailFrame.ViewRenownButton:SetText('浏览名望')--ReputationFrame.xml
ReputationFrame.ReputationDetailFrame.WatchFactionCheckbox.Label:SetText('显示为经验条')
ReputationFrame.ReputationDetailFrame.MakeInactiveCheckbox.Label:SetText('隐藏')
ReputationFrame.ReputationDetailFrame.AtWarCheckbox.Label:SetText('交战状态')
hooksecurefunc(ReputationHeaderMixin, 'Initialize', function(frame)
    if frame.elementData.name then
        local cnName= WoWTools_ChineseMixin:CN(frame.elementData.name)
        if cnName then
            frame.Name:SetText(cnName)
        end
    end
end)
hooksecurefunc(ReputationEntryMixin, 'Initialize', function(frame)
    if frame.elementData.name then
        local cnName= WoWTools_ChineseMixin:CN(frame.elementData.name)
        if cnName then
            frame.Content.Name:SetText(cnName)
        end
    end
end)

WoWTools_ChineseMixin:HookLabel(ReputationFrame.ReputationDetailFrame.Title)
WoWTools_ChineseMixin:HookLabel(ReputationFrame.ReputationDetailFrame.Description)
    --hooksecurefunc(ReputationFrame.ReputationDetailFrame, 'Refresh', function(frame)


    --[[hooksecurefunc(ReputationFrame.ScrollBox, 'Update', function(frame)
        if not frame:GetView() then
            return
        end
        for _, frame in pairs(frame:GetFrames() or {}) do
            WoWTools_ChineseMixin:SetLabel(frame.Container.Name)

            local bar=frame.Container.ReputationBar
            if bar then
                local text= bar.FactionStanding:GetText()
                if text then
                    local cnName= WoWTools_ChineseMixin:CN(text)
                    if not cnName and text:find('(.-) %d') then
                        local name= text:match('(.-) %d')
                        local name2= name and WoWTools_ChineseMixin:CN(name)
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
