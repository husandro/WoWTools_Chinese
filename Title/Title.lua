local e= select(2, ...)

hooksecurefunc(PaperDollFrame.TitleManagerPane.ScrollBox, 'Update', function(self)
    for _, btn in pairs(self:GetFrames() or {}) do
        if not btn.get_name then
            function btn:get_name()
                local name= e.Get_Title_Name(btn.titleId)
                return name
            end
            e.font(btn:GetFontString())
            btn:HookScript('OnLeave', GameTooltip_Hide)
            btn:HookScript('OnEnter', function(frame)
                local name= frame:get_name()
                if not name then
                    return
                end
                GameTooltip:SetOwner(frame, "ANCHOR_LEFT")     
                local title= format(name, UnitName('player'))
                GameTooltip_SetTitle(GameTooltip, title)
                GameTooltip_AddNormalLine(GameTooltip, (GetTitleName(frame.titleId) or '')..' ')
                GameTooltip:Show()
            end)
        end
        local name= btn:get_name()
        if name then
            btn:SetText(name:gsub('%%s', ''))
        end
    end
end)