local config = {
    spaces = 4,
    highlighting = false,
    Tab = "    " -- 4 spaces default
}

local clonef = clonefunction
local str = string
local gme = game
local sub = clonef(str.sub)
local format = clonef(str.format)
local rep = clonef(str.rep)
local byte = clonef(str.byte)
local match = clonef(str.match)
local getfn = clonef(gme.GetFullName)
local info = clonef(debug.getinfo)
local huge = math.huge
local Type = clonef(typeof)
local Pairs = clonef(pairs)
local Assert = clonef(assert)
local tostring = clonef(tostring)
local concat = clonef(table.concat)
local getmet = clonef(getmetatable)
local rawget = clonef(rawget)
local rawset = clonef(rawset)

-- Roblox DataTypes
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

local function Tostring(obj)
    local mt = getmet(obj)
    if not mt or Type(mt) ~= "table" then
        return tostring(obj)
    end
    local b = rawget(mt, "__tostring")
    rawset(mt, "__tostring", nil)
    local r = tostring(obj)
    rawset(mt, "__tostring", b)
    return r
end

local function serializeArgs(...)
    local Serialized = {}
    for _, v in Pairs({...}) do
        local vt = Type(v)
        if vt == "string" then
            table.insert(Serialized, format(config.highlighting and "\27[32m\"%s\"\27[0m" or "\"%s\"", v))
        elseif vt == "table" then
            table.insert(Serialized, Serialize(v, 0))
        else
            table.insert(Serialized, Tostring(v))
        end
    end
    return concat(Serialized, ", ")
end

local function formatFunction(func)
    local proto = info(func)
    local params = {}
    if proto and proto.nparams then
        for i = 1, proto.nparams do
            params[#params + 1] = format("p%d", i)
        end
        if proto.isvararg then
            params[#params + 1] = "..."
        end
        return format("function (%s) --[[ %s ]] end", concat(params, ", "), proto.name or "anonymous")
    end
    return "function () end"
end

local function formatString(str)
    local result = {}
    for i = 1, #str do
        local c = sub(str, i, i)
        local b = byte(c)
        if c == "\n" then
            result[i] = "\\n"
        elseif c == "\t" then
            result[i] = "\\t"
        elseif c == "\"" then
            result[i] = "\\\""
        elseif b < 32 or b > 126 then
            result[i] = format("\\%d", b)
        else
            result[i] = c
        end
    end
    return concat(result)
end

local function formatNumber(n)
    if n == huge then return "math.huge" end
    if n == -huge then return "-math.huge" end
    return Tostring(n)
end

local function formatIndex(idx, scope)
    local vt = Type(idx)
    if vt == "string" and not match(idx, "^[%a_][%w_]*$") then
        return format("[%s]", config.highlighting and format("\27[32m\"%s\"\27[0m", formatString(idx)) or format("\"%s\"", formatString(idx)))
    elseif vt == "table" then
        return format("[%s]", Serialize(idx, scope + 1))
    elseif vt == "number" or vt == "boolean" then
        return format("[%s]", config.highlighting and format("\27[33m%s\27[0m", formatNumber(idx)) or formatNumber(idx))
    elseif vt == "function" then
        return format("[%s]", formatFunction(idx))
    elseif vt == "Instance" then
        return format("[%s]", getfn(idx))
    else
        return format("[%s]", Tostring(idx))
    end
end

function Serialize(tbl, scope, checked)
    checked = checked or {}
    if checked[tbl] then return format("\"%s -- recursive table\"", Tostring(tbl)) end
    checked[tbl] = true
    scope = scope or 0

    local serialized = {}
    local tab = rep(config.Tab, scope + 1)
    local tabEnd = rep(config.Tab, scope)

    local len = 0
    for k, v in Pairs(tbl) do
        len += 1
        local keyStr = (len ~= k) and format("%s = ", formatIndex(k, scope)) or ""
        local vt = Type(v)
        local line = ""

        if vt == "string" then
            line = format("%s%s\"%s\"", tab, keyStr, formatString(v))
            if config.highlighting then line = format("%s%s\27[32m\"%s\"\27[0m", tab, keyStr, formatString(v)) end
        elseif vt == "number" or vt == "boolean" then
            local val = formatNumber(v)
            line = format("%s%s%s", tab, keyStr, val)
            if config.highlighting then line = format("%s%s\27[33m%s\27[0m", tab, keyStr, val) end
        elseif vt == "table" then
            line = format("%s%s%s", tab, keyStr, Serialize(v, scope + 1, checked))
        elseif vt == "userdata" then
            line = format("%s%snewproxy()", tab, keyStr)
        elseif vt == "function" then
            line = format("%s%s%s", tab, keyStr, formatFunction(v))
        elseif vt == "Instance" then
            line = format("%s%s%s", tab, keyStr, getfn(v))
        elseif DataTypes[vt] then
            line = format("%s%s%s.new(%s)", tab, keyStr, vt, Tostring(v))
        else
            line = format("%s%s\"%s\"", tab, keyStr, Tostring(v))
        end

        table.insert(serialized, line)
    end

    if #serialized > 0 then
        return format("{\n%s\n%s}", concat(serialized, ",\n"), tabEnd)
    else
        return "{}"
    end
end

local Serializer = {}

function Serializer.Serialize(tbl)
    Assert(Type(tbl) == "table", "Serialize expects a table")
    return Serialize(tbl)
end

function Serializer.FormatArguments(...)
    return serializeArgs(...)
end

function Serializer.FormatString(str)
    Assert(Type(str) == "string", "FormatString expects a string")
    return formatString(str)
end

function Serializer.UpdateConfig(opt)
    Assert(Type(opt) == "table", "UpdateConfig expects a table")
    config.spaces = opt.spaces or config.spaces
    config.highlighting = opt.highlighting or false
    config.Tab = rep(" ", config.spaces)
end

return Serializer
