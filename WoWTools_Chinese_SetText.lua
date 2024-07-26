local e= select(2, ...)



local function set_match(text, a, b)
    local a1= a and e.strText[a]
    local b1= b and e.strText[b]

    local r= a1 and text:gsub(a, a1) or text
    r= b1 and r:gsub(b, b1) or r

    if text~= r then
        return r
    end    
end


function e.set_text(text)
    local text2= text and e.strText[text]
    if not text or text2 then
        return text2
    end
    text2= text:gsub('|c.-|r', function(s)--颜色
        return set_match(s, s:match('|c........(.-)|r'))
    end)
    text2= text2:gsub('%(.-%)', function(s)-- ()
        return set_match(s, s:match('%((.-)%)'))
    end)
    text2= text2:gsub('  .+', function(s)--双空格
        return set_match(s, s:match('  (.+)'))
    end)
    text2= text2:gsub('.-:', function(s)--内容：
        return set_match(s, s:match('^(.-):'), s:match('^(.-:)'))
    end)
    text2= text2:gsub(': .+', function(s)-- :内容
        return set_match(s, s:match(': (.+)'))
    end)
    text2= text2:gsub('%d+ .+', function(s)--数字 内容
        return set_match(s, s:match('%d+ (.+)'))
    end)
    text2= text2:gsub('^.- %(', function(s)--内容 (
        return set_match(s, s:match('^(.-) %('))
    end)

    if text ~= text2 then
        return text2
    end
end



function e.font(lable)
    if lable then
        local _, size2, fontFlag2= lable:GetFont()
        lable:SetFont('Fonts\\ARHei.ttf', size2, fontFlag2 or 'OUTLINE')
    end
end

local function set(self, text)
    if not frame then
        return
    end
    local label= self

    if not text then
        if self.GetText then
            text= self:GetText()
        elseif self.GetObjectType and self:GetObjectType()=='Button' then
            label= self:GetFontString()
            if label then
                text= label:GetText()
            end      
        end
    end

    if text and label and label.SetText then
        local text2= e.set_text(text)
        if text2 and text2~=text then
            label:SetText(text2)
            return true
        end
    end
end


function e.set(label, text, affer, setFont)
    if label then
        if setFont then
            e.font(lable)
        end
        if affer then
            C_Timer.After(affer, function() set(label, text) end)
        else
            set(label, text)
        end
    end
end

function e.dia(string, tab)
    if StaticPopupDialogs[string] then
        for name, text in pairs(tab) do
            if StaticPopupDialogs[string][name] then
                StaticPopupDialogs[string][name]= text
            end
        end
    end
end

function e.hookDia(string, text, func)
    if StaticPopupDialogs[string] then
        if StaticPopupDialogs[string][text] then
            hooksecurefunc(StaticPopupDialogs[string], text, func)
        else
            StaticPopupDialogs[string][text]=func
        end
    end
end

function e.hookLabel(label, setFont)
    if label and not label.hook_chines and label.SetText then
        if setFont then
            e.font(label)
        end
        e.set(label)
        hooksecurefunc(label, 'SetText', function(self, name)
            set(self, name)
        end)
        label.hook_chines=true
    end
end



function e.hookButton(btn, setFont)
    if btn and btn.SetText and not btn.hook_chines then
        if setFont then
            e.font(btn:GetFontString())
        end
        local label= btn:GetFontString()
        if label then
            e.set(labe)
        end
        hooksecurefunc(btn, 'SetText', function(self, name)
            if name and name~='' then
                local cnName= e.strText[name]
                if cnName then
                    self:SetText(cnName)
                end
            end
        end)
        btn.hook_chines=true
    end
end




function e.region(frame, setFont, isHook, notAfter)
    if frame and not frame.region_chinese then
        if isHook then
            for _, region in pairs({frame:GetRegions()}) do
                if region:GetObjectType()=='FontString' then
                    e.hookLabel(region, setFont)
                end
            end

        else
            if notAfter then
                for _, region in pairs({frame:GetRegions()}) do
                    if region:GetObjectType()=='FontString' then
                        e.set(region, setFont)
                    end
                end
            else
                C_Timer.After(2, function()
                    for _, region in pairs({frame:GetRegions()}) do
                        if region:GetObjectType()=='FontString' then
                            e.set(region, setFont)
                        end
                    end
                end)
            end
        end
        frame.region_chinese=true
    end
end


--PanelTemplates_TabResize(tab, padding, absoluteSize, minWidth, maxWidth, absoluteTextSize)
function e.tabSet(frame, setFont, padding, minWidth, absoluteSize)
    for _, tabID in pairs(frame:GetTabSet() or {}) do
        local btn= frame:GetTabButton(tabID)
        e.set(btn.Text or btn, nil, nil, setFont)

        PanelTemplates_TabResize(frame, padding or 20, absoluteSize, minWidth or 70)
    end

end



--[[function e.setButton(btn, setFont)
    local label= btn and btn:GetFontString()
    if label then
        if setFont then
            e.font(label)
        end
        e.set(label)
    end
end]]















