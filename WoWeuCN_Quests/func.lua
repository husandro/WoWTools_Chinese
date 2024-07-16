local e= select(2, ...)

local function split(s, delimiter)
    if (s == nil) then
      return nil
    end
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end