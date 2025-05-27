--[[
PLEASE READ - IMPORTANT

© 2025 Peteware
This project is part of Peteware V1, an open-source Roblox script collection.

Licensed under the MIT License.  
See the full license at:  
https://github.com/PetewareScripts/Developers-Toolbox-Peteware/blob/main/LICENSE

**Attribution required:** You must give proper credit to Peteware when using or redistributing this project or its derivatives.

This software is provided "AS IS" without warranties of any kind.  
Violations of license terms may result in legal action.

Thank you for respecting the license and supporting open source software!

Peteware Development Team
]]

if _G.VariableTest and getgenv().VariableTest then
    _G.VariableTest = nil
    getgenv().VariableTest = nil
end

local foundNewgetgenvNew = false
local foundNew_GNew = false
local found_G = false

foundInstanceClass = false

local showProperties = {
    -- Value containers
    IntValue = "Value",
    StringValue = "Value",
    BoolValue = "Value",
    NumberValue = "Value",
    Color3Value = "Value",
    Vector3Value = "Value",
    CFrameValue = "Value",
    ObjectValue = "Value",

    -- Common parts
    Part = "Transparency",        -- useful to detect invisible parts
    Model = "Parent",
    UnionOperation = "Transparency",
    Decal = "Texture",            
    Texture = "Texture",

    -- Characters and Gameplay
    Humanoid = "DisplayName",
    Tool = "ToolTip",
    Animation = "AnimationId",
    AnimationTrack = "Animation",

    -- Sounds and Effects
    Sound = "SoundId",
    ParticleEmitter = "Enabled",
}

local foundClasses = {}
local orderList = {}
local inShowProps = nil
local property = nil

local startTime = os.clock()
local endTime = os.clock()
local finalTime = endTime - startTime

local original_G = {}
local original_genv = {}

for k, _ in pairs(_G) do
    original_G[k] = true
end

for k, _ in pairs(getgenv()) do
    original_genv[k] = true
end

local StarterGui = game:GetService("StarterGui")
local uis = game:GetService("UserInputService")
httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)

local TeleportCheck = false

local ExecuteOnTeleport = true -- set to false if you dont want execution on server hop / rejoin

if ExecuteOnTeleport then

        game.Players.LocalPlayer.OnTeleport:Connect(function(State)
            if not TeleportCheck and queueteleport then
                TeleportCheck = true
                queueteleport([[
                repeat wait() until game:IsLoaded()
                task.wait(1)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/poupeue/Developers-Toobox-Peteware/refs/heads/main/Toolbox", true))()
]])
            end
        end)
end

local deviceUser

if uis.TouchEnabled and not uis.KeyboardEnabled and not uis.MouseEnabled then
    deviceUser = "Mobile"
elseif not uis.TouchEnabled and uis.KeyboardEnabled and uis.MouseEnabled then
    deviceUser = "PC"
else
    deviceUser = "Unknown"
end

local executorName = identifyexecutor()
local executorLevel = getthreadcontext()

local function getExecutorInfo()
game:GetService("StarterGui"):SetCore("DevConsoleVisible", true)
print("Device: " .. deviceUser)    
print("Executor: " .. executorName)
print("Executor Level: " .. executorLevel)
end
    
local function rejoinServer()
    StarterGui:SetCore("SendNotification", {
        Title = "Rejoining...",
        Text = "Attempting to Rejoin Server",
        Icon = "rbxassetid://108052242103510",
        Duration = 3.5,
    })
task.wait(1)
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.placeId, game.jobId)
end

local function serverHop()
    StarterGui:SetCore("SendNotification", {
                Title = "Hopping...",
                Text = "Attempting to Server Hop",
                Icon = "rbxassetid://108052242103510",
                Duration = 3.5,
                })
    if httprequest then
        local servers = {}
        local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.placeId)})
        local body = game:GetService("HttpService"):JSONDecode(req.Body)

        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.jobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end

        if #servers > 0 then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.placeId, servers[math.random(1, #servers)], Player)
        else
            return StarterGui:SetCore("SendNotification", {
                Title = "Server Hop",
                Text = "Server Hop Failed. Couldnt find a available server",
                Icon = "rbxassetid://108052242103510",
                Duration = 3.5,
            })
        end
    else
       StarterGui:SetCore("SendNotification", {
                Title = "Incompatible Exploit",
                Text = "Your exploit does not support this function (missing request)",
                Icon = "rbxassetid://108052242103510",
                Duration = 3.5,
            })
    end
end

local function DebuggetgenvNew()
    startTime = os.clock()
    print([[ [Toolbox]: Scanning for Recently Added getgenv() contents...
    
---------------------------------------------------------------------------------------------------------------------------
        
        ]])
    
    for name, value in pairs(getgenv()) do
        if not original_genv[name] then
            foundNewgetgenv = true
            print(" →", name, "=", value)
        end
    end
    
    if not foundNewgetgenv then
        warn("[Toolbox]: No Recently Added getgenv() contents found.")
    end
    
    endTime = os.clock()
    finalTime = endTime - startTime
    
    print(string.format([[
[Toolbox]: Scan completed in %.4f seconds. 
        
---------------------------------------------------------------------------------------------------------------------------
        
        ]], finalTime))
end

local function Debug_GNew()
    startTime = os.clock()
    print([[ [Toolbox]: Scanning for Recently Added _G contents...
    
---------------------------------------------------------------------------------------------------------------------------
        
        ]])
    
    for name, value in pairs(_G) do
        if not original_G[name] then
            foundNew_G = true
            print(" →", name, "=", value)
        end
    end
    
    if not foundNew_G then
        warn("[Toolbox]: No Recently Added _G contents found.")
    end
    
    endTime = os.clock()
    finalTime = endTime - startTime
    
    print(string.format([[
[Toolbox]: Scan completed in %.4f seconds. 
        
---------------------------------------------------------------------------------------------------------------------------
        
        ]], finalTime))
end

local function Debuggetgenv()
    startTime = os.clock()
    print([[ [Toolbox]: Scanning for getgenv() contents...
    
---------------------------------------------------------------------------------------------------------------------------
        
        ]])
    
    for name, value in pairs(getgenv()) do
    print(" →", name, "=", value)
end
    
    endTime = os.clock()
    finalTime = endTime - startTime

    print(string.format([[
[Toolbox]: Scan completed in %.4f seconds. 
        
---------------------------------------------------------------------------------------------------------------------------
        
        ]], finalTime))
end

local function Debug_G()
    startTime = os.clock()
    print([[[Toolbox]: Scanning for _G contents...
    
---------------------------------------------------------------------------------------------------------------------------
        
        ]])
    
    for name, value in pairs(_G) do
        found_G = true
    print(" →", name, "=", value)
end

if not found_G then
        warn("[Toolbox]: No _G contents found.")
    end
    
    endTime = os.clock()
    finalTime = endTime - startTime

    print(string.format([[
[Toolbox]: Scan completed in %.4f seconds. 
        
---------------------------------------------------------------------------------------------------------------------------

        ]], finalTime))
end

local function FetchAvailableClasses()
    startTime = os.clock()
    print([[[Toolbox]: Scanning for Available Classes...

---------------------------------------------------------------------------------------------------------------------------

        ]])
    
    foundClasses = {}

    for _, instance in pairs(game:GetDescendants()) do
        foundClasses[instance.ClassName] = true
    end
    
    orderList = {}
    for className in pairs(foundClasses) do
        table.insert(orderList, className)
    end
    table.sort(orderList)

    for _, className in ipairs(orderList) do
    property = showProperties[className]
    if property then
        print(string.format(
            "Name → %s | showProperties table = true | PropertyShown = %s",
            className,
            tostring(property)
        ))
    else
        print(string.format(
            "Name → %s | showProperties table = false",
            className
        ))
    end
end

    endTime = os.clock()
    finalTime = endTime - startTime
    print(string.format([[
[Toolbox]: Scan completed in %.4f seconds.

---------------------------------------------------------------------------------------------------------------------------

        ]], finalTime))
end

local Library = loadstring(Game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/wizard"))()

local PetewareToolbox = Library:NewWindow("Dev Toolbox | Peteware")

local Tools = PetewareToolbox:NewSection("Toolbox")

Tools:CreateButton("Infinite Yield", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

Tools:CreateButton("Remote Spy", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/SimpleSpyV3/main.lua"))()
end)

Tools:CreateButton("Dex Explorer", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
end)

Tools:CreateButton("Hydroxide", function()
local owner = "Hosvile"
local branch = "revision"

local function webImport(file)
    return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/MC-Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
end

webImport("init")
webImport("ui/main")
end)

Tools:CreateButton("Adv AC Scanner", function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Advanced-Game-Anti-Cheat-Scanner-33244",true))()
end)

local Debugging1 = PetewareToolbox:NewSection("Debugging1 (Advanced)")

Debugging1:CreateButton("Print Global Variables V1", function()
StarterGui:SetCore("DevConsoleVisible", true)
    Debug_G()
end)

Debugging1:CreateButton("Print Global Variables V2", function()
StarterGui:SetCore("DevConsoleVisible", true)
    Debuggetgenv()
end)

Debugging1:CreateButton("Print Recent Global Variables V1", function()
StarterGui:SetCore("DevConsoleVisible", true)
    Debug_GNew()
end)

Debugging1:CreateButton("Print Recent Global Variables V2", function()
StarterGui:SetCore("DevConsoleVisible", true)
    DebuggetgenvNew()
end)

Debugging1:CreateTextbox("Copy Global Variable V1", function(text)
    if _G[text] ~= nil then
        local variableValue = tostring(_G[text])
        setclipboard("_G." .. text .. " = " .. variableValue)
        print("Copied: _G." .. text .. " = " .. variableValue)
        StarterGui:SetCore("DevConsoleVisible", true)
    else
        print(text .. " Variable not found in _G.")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

Debugging1:CreateTextbox("Copy Global Variable V2", function(text)
    if getgenv()[text] ~= nil then
        local variableValue = tostring(getgenv()[text])
        setclipboard("getgenv()." .. text .. " = " .. variableValue)
        print("Copied: getgenv()." .. text .. " = " .. variableValue)
        StarterGui:SetCore("DevConsoleVisible", true)
    else
        print(text .. " Variable not found in getgenv().")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

local Debugging2 = PetewareToolbox:NewSection("Debugging2 (Advanced)")

Debugging2:CreateTextbox("Create Global Variable V1", function(input)
local varName, value = input:match("^(%S+)%s*=%s*(.+)$")
    if varName and value then
        if _G[varName] == nil then
            local success, result = pcall(loadstring("return " .. value))
            if success then
                _G[varName] = result
                print("Created: _G." .. varName .. " = " .. tostring(result))
                StarterGui:SetCore("DevConsoleVisible", true)
            else
                print("Invalid value format.")
                StarterGui:SetCore("DevConsoleVisible", true)
            end
        else
            print(varName .. " found in _G. Creating not allowed.")
            StarterGui:SetCore("DevConsoleVisible", true)
        end
    else
        print("Invalid input format. Please use 'VariableName = value'.")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

Debugging2:CreateTextbox("Create Global Variable V2", function(input)
local varName, value = input:match("^(%S+)%s*=%s*(.+)$")
    if varName and value then
        if getgenv()[varName] == nil then
            local success, result = pcall(loadstring("return " .. value))
            if success then
                getgenv()[varName] = result
                print("Created: getgenv()." .. varName .. " = " .. tostring(result))
                StarterGui:SetCore("DevConsoleVisible", true)
            else
                print("Invalid value format.")
                StarterGui:SetCore("DevConsoleVisible", true)
            end
        else
            print(varName .. " found in getgenv(). Creating not allowed.")
            StarterGui:SetCore("DevConsoleVisible", true)
        end
    else
        print("Invalid input format. Please use 'VariableName = value'.")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

Debugging2:CreateTextbox("Edit Global Variable V1", function(input)
    local varName, value = input:match("^(%S+)%s*=%s*(.+)$")
    if varName and value then
        if _G[varName] ~= nil then
            local success, result = pcall(loadstring("return " .. value))
            if success then
                _G[varName] = result
                print("Edited: _G." .. varName .. " = " .. tostring(result))
                StarterGui:SetCore("DevConsoleVisible", true)
            else
                print("Invalid value format.")
                StarterGui:SetCore("DevConsoleVisible", true)
            end
        else
            print(varName .. " not found in _G. Editing not allowed.")
            StarterGui:SetCore("DevConsoleVisible", true)
        end
    else
        print("Invalid input format. Please use 'VariableName = value'.")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

Debugging2:CreateTextbox("Edit Global Variable V2", function(input)
    local varName, value = input:match("^(%S+)%s*=%s*(.+)$")
    if varName and value then
        if getgenv()[varName] ~= nil then
            local success, result = pcall(loadstring("return " .. value))
            if success then
                getgenv()[varName] = result
                print("Edited: getgenv()." .. varName .. " = " .. tostring(result))
                StarterGui:SetCore("DevConsoleVisible", true)
            else
                print("Invalid value format.")
                StarterGui:SetCore("DevConsoleVisible", true)
            end
        else
            print(varName .. " not found in getgenv(). Editing not allowed.")
            StarterGui:SetCore("DevConsoleVisible", true)
        end
    else
        print("Invalid input format. Please use 'VariableName = value'.")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

Debugging2:CreateTextbox("Delete Global Variable V1", function(text)
    if _G[text] ~= nil then
        _G[text] = nil
        print("Deleted: _G." .. text)
        StarterGui:SetCore("DevConsoleVisible", true)
    else
        print(text .. " not found in _G.")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

Debugging2:CreateTextbox("Delete Global Variable V2", function(text)
    if getgenv()[text] ~= nil then
        getgenv()[text] = nil
        print("Deleted: getgenv()." .. text)
        StarterGui:SetCore("DevConsoleVisible", true)
    else
        print(text .. " not found in getgenv().")
        StarterGui:SetCore("DevConsoleVisible", true)
    end
end)

local InstanceScanner = PetewareToolbox:NewSection("Instance Scanner")

InstanceScanner:CreateButton("Fetch All Available Classes", function()
StarterGui:SetCore("DevConsoleVisible", true)
    FetchAvailableClasses()
end)

InstanceScanner:CreateTextbox("Scan by Class", function(className)
    StarterGui:SetCore("DevConsoleVisible", true)
    local startTime = os.clock()
    local foundInstanceClass = false

    print(string.format([[
[Toolbox]: Scanning for Instances of Class: %s

---------------------------------------------------------------------------------------------------------------------------

]], className))

    for _, inst in ipairs(game:GetDescendants()) do
        if inst.ClassName == className then
            foundInstanceClass = true

            local output = "Name → " .. inst.Name .. " | Path → " .. inst:GetFullName()
            local propName = showProperties[className]
            if propName and inst[propName] ~= nil then
                output = output .. " | " .. propName .. " = " .. tostring(inst[propName])
            end

            print(output)
        end
    end

    if not foundInstanceClass then
        warn(string.format("[Toolbox]: No instances of class '%s' were found.", className))
    end

    local endTime = os.clock()
    local finalTime = endTime - startTime

    print(string.format([[
[Toolbox]: Scan completed in %.4f seconds.

---------------------------------------------------------------------------------------------------------------------------

]], finalTime))
end)

local Other = PetewareToolbox:NewSection("Other")

Other:CreateButton("Stopwatch", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/PetewareScripts/Developers-Toolbox-Peteware/refs/heads/main/stopwatch.lua",true))()
end)

Other:CreateButton("Launch Peteware", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/PetewareScripts/Peteware-V1/refs/heads/main/Loader",true))()
end)

Other:CreateButton("FPS Booster", function()
-- Made by RIP#6666
_G.Settings = {
    Players = {
        ["Ignore Me"] = true, -- Ignore your Character
        ["Ignore Others"] = true -- Ignore other Characters
    },
    Meshes = {
        Destroy = false, -- Destroy Meshes
        LowDetail = true -- Low detail meshes (NOT SURE IT DOES ANYTHING)
    },
    Images = {
        Invisible = true, -- Invisible Images
        LowDetail = false, -- Low detail images (NOT SURE IT DOES ANYTHING)
        Destroy = false, -- Destroy Images
    },
    ["No Particles"] = true, -- Disables all ParticleEmitter, Trail, Smoke, Fire and Sparkles
    ["No Camera Effects"] = true, -- Disables all PostEffect's (Camera/Lighting Effects)
    ["No Explosions"] = true, -- Makes Explosion's invisible
    ["No Clothes"] = true, -- Removes Clothing from the game
    ["Low Water Graphics"] = true, -- Removes Water Quality
    ["No Shadows"] = true, -- Remove Shadows
    ["Low Rendering"] = true, -- Lower Rendering
    ["Low Quality Parts"] = true -- Lower quality parts
}
loadstring(game:HttpGet("https://raw.githubusercontent.com/CasperFlyModz/discord.gg-rips/main/FPSBooster.lua"))()
end)

Other:CreateButton("Executor Info", function()
    getExecutorInfo()
end)

Other:CreateButton("Rejoin", function()
    rejoinServer()
end)

Other:CreateButton("Server Hop", function()
    serverHop()
end)

local GlobalVariableTest = false -- set to true to create a _G and a getgenv() Variable for testing

if GlobalVariableTest then
    _G.VariableTest = true
    getgenv().VariableTest = true
end

