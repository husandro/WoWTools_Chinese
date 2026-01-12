

GameMenuFrame.Header.Text:SetText('游戏菜单')

--MainMenuFrameMixin MainMenuFrameMixin:AddButton
hooksecurefunc(GameMenuFrame, 'InitButtons', function(self)
    for btn in self.buttonPool:EnumerateActive() do
        WoWTools_ChineseMixin:SetLabel(btn)
    end
end)

WoWTools_ChineseMixin:SetLabel(GameMenuFrame.NewOptionsFrame.Label)
WoWTools_ChineseMixin:SetLabel(GameMenuFrame.NewOptionsFrame.BGLabel)
WoWTools_ChineseMixin:SetLabel(GameMenuFrame.NewOptionsFrame.label)