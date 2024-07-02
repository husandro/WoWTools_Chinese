local id, e= ...
--Constants.lua
-- LFG


for index, name in pairs(LFG_CATEGORY_NAMES) do
    local cnName= e.strText[name]
    if cnName then
        LFG_CATEGORY_NAMES[index]= cnName
        
    end
end