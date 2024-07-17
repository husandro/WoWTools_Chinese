local e= select(2, ...)

GameMenuFrame.Header.Text:SetText('游戏菜单')

if GameMenuButtonHelp then--11版本
    GameMenuButtonHelp:SetText('帮助')
    GameMenuButtonStore:SetText('商店')
    GameMenuButtonWhatsNew:SetText('新内容')
    GameMenuButtonSettings:SetText('选项')
    GameMenuButtonEditMode:SetText('编辑模式')
    GameMenuButtonMacros:SetText('宏')
    GameMenuButtonAddons:SetText('插件')
    GameMenuButtonLogout:SetText('登出')
    GameMenuButtonQuit:SetText('退出游戏')
    GameMenuButtonContinue:SetText('返回游戏')
    return
end

--MainMenuFrameMixin MainMenuFrameMixin:AddButton
hooksecurefunc(GameMenuFrame, 'InitButtons', function(self)
    for btn in self.buttonPool:EnumerateActive() do
        e.set(btn)
    end
end)

