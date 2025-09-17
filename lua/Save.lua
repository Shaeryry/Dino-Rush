local save = {};

function save:new(file)
    local saveInstance = {
        fileName = file;
    };

    return setmetatable(saveInstance,{__index=self});
end

local function serialize(data)
    indent = indent or ""
    local serializedData = "{\n"

    for k, v in pairs(data) do
        local key = type(k) == "string" and string.format("[%q]", k) or string.format("[%d]", k)
        if type(v) == "table" then
            serializedData = serializedData .. indent .. "  " .. key .. " = " .. serialize(v, indent .. "  ") .. ",\n"
        elseif type(v) == "string" then
            serializedData = serializedData .. indent .. "  " .. key .. " = " .. string.format("%q", v) .. ",\n"
        else
            serializedData = serializedData .. indent .. "  " .. key .. " = " .. tostring(v) .. ",\n"
        end
    end

    serializedData = serializedData .. indent .. "}"

    return serializedData
end

function save:save(data)
    local file = io.open(self.fileName, "w")
    if not file then
        return false
    end 

    local serializedData = serialize(data);
    file:write("return " .. serializedData .. "\n")
    file:close()
end

function save:read()
    local file = io.open(self.fileName, "r")
    if not file then
        return nil
    end
    file:close()  -- Close the file immediately; dofile will reopen it.

    local success, result = pcall(dofile, self.fileName)
    if not success then
        return nil
    end
    return result
end

return save;