local config = {
    spaces = 4,
    highlighting = false
}

local Serializer = {}
local clonef = clonefunction
local rep = clonef(string.rep)
local format = clonef(string.format)
local sub = clonef(string.sub)
local byte = clonef(string.byte)
local match = clonef(string.match)
local getfn = clonef(game.GetFullName)
local info = clonef(debug.getinfo)
local huge = math.huge
local typeof = clonef(typeof)
local pairs = clonef(pairs)
local tostring = clonef(tostring)
local concat = clonef(table.concat)
local getmetatable = clonef(getmetatable)
local rawget = clonef(rawget)
local rawset = clonef(rawset)

-- List of Roblox datatypes
local DataTypes = {
    Axes = true, BrickColor = true, CatalogSearchParams = true, CFrame = true,
    Color3 = true, ColorSequence = true, ColorSequenceKeypoint = true, DateTime = true,
    DockWidgetPluginGuiInfo = true, Enum = true, Faces = true, Instance = true,
    NumberRange = true, NumberSequence = true, NumberSequenceKeypoint = true,
    OverlapParams = true, PathWaypoint = true, PhysicalProperties = true, Random = true,
    Ray = true, RaycastParams = true, RaycastResult = true, Rect = true, Region3 = true,
    Region3int16 = true, TweenInfo = true, UDim = true, UDim2 = true, Vector2 = true,
    Vector2int16 = true, Vector3 = true, Vector3int16 = true
}

-- Forward declaration
local Serialize

local function getTab(level)
    return rep(" ", (config.spaces or 4) * level)
end

local function safeToString(obj)
    local mt = getmetatable(obj)
    if mt and typeof(mt) == "table" then
        local backup = rawget(mt, "__tostring")
        rawset(mt, "__tostring", nil)
        local out = tostring(obj)
        rawset(mt, "__tostring", backup)
        return out
    end
    return tostring(obj)
end

local function formatNumber(n)
    if n == huge then return "math.huge" end
    if n == -huge then return "-math.huge" end
    return tostring(n)
end

local function formatString(str)
    local out = {}
    for i = 1, #str do
        local c = sub(str, i, i)
        local b = byte(c)
        if c == "\n" then
            out[#out + 1] = "\\n"
        elseif c == "\t" then
            out[#out + 1] = "\\t"
        elseif c == "\"" then
            out[#out + 1] = "\\\""
        elseif b < 32 or b > 126 then
            out[#out + 1] = "\\" .. b
        else
            out[#out + 1] = c
        end
    end
    return concat(out)
end

local function formatFunction(fn)
    local proto = info(fn)
    if proto and proto.nparams then
        local args = {}
        for i = 1, proto.nparams do args[i] = "p" .. i end
        if proto.isvararg then args[#args + 1] = "..." end
        return format("function(%s) --[[ %s ]] end", concat(args, ", "), proto.name or "anonymous")
    end
    return "function() end"
end

local function formatIndex(idx, depth)
    local t = typeof(idx)
    if t == "string" and not match(idx, "^[%a_][%w_]*$") then
        return format("[%q]", idx)
    elseif t == "number" or t == "boolean" then
        return "[" .. tostring(idx) .. "]"
    elseif t == "Instance" then
        return "[" .. getfn(idx) .. "]"
    elseif t == "function" then
        return "[" .. formatFunction(idx) .. "]"
    elseif t == "table" then
        return "[" .. Serialize(idx, depth + 1) .. "]"
    else
        return "[" .. safeToString(idx) .. "]"
    end
end

Serialize = function(tbl, depth, seen)
    depth = depth or 0
    seen = seen or {}
    if seen[tbl] then return "\"<recursion>\"" end
    seen[tbl] = true

    local result = {}
    for k, v in pairs(tbl) do
        local line = getTab(depth + 1)
        local key = formatIndex(k, depth)
        local t = typeof(v)

        if t == "string" then
            line = line .. key .. " = " .. format("\"%s\"", formatString(v))
        elseif t == "number" or t == "boolean" then
            line = line .. key .. " = " .. formatNumber(v)
        elseif t == "table" then
            line = line .. key .. " = " .. Serialize(v, depth + 1, seen)
        elseif t == "function" then
            line = line .. key .. " = " .. formatFunction(v)
        elseif t == "Instance" then
            line = line .. key .. " = " .. getfn(v)
        elseif DataTypes[t] then
            line = line .. key .. " = " .. t .. ".new(" .. safeToString(v) .. ")"
        else
            line = line .. key .. " = \"" .. safeToString(v) .. "\""
        end

        result[#result + 1] = line
    end

    return "{\n" .. concat(result, ",\n") .. "\n" .. getTab(depth) .. "}"
end

function Serializer.Serialize(tbl)
    if typeof(tbl) ~= "table" then
        error("Serializer.Serialize expects a table, got " .. typeof(tbl))
    end
    return Serialize(tbl)
end

function Serializer.FormatArguments(...)
    local out = {}
    for _, v in pairs({...}) do
        if typeof(v) == "string" then
            out[#out + 1] = "\"" .. v .. "\""
        elseif typeof(v) == "table" then
            out[#out + 1] = Serialize(v)
        else
            out[#out + 1] = safeToString(v)
        end
    end
    return concat(out, ", ")
end

function Serializer.FormatString(str)
    if typeof(str) ~= "string" then error("Expected string") end
    return formatString(str)
end

function Serializer.UpdateConfig(opt)
    if typeof(opt) ~= "table" then error("UpdateConfig expects a table") end
    config.spaces = opt.spaces or 4
    config.highlighting = opt.highlighting or false
end

return Serializer
