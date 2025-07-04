--[[
PLEASE READ - IMPORTANT

© 2025 Peteware
This project is part of Developers-Toolbox-Peteware, an open-source roblox toolbox for developing scripts.

Licensed under the MIT License.  
See the full license at:  
https://github.com/PetewareScripts/Developers-Toolbox-Peteware/blob/main/LICENSE

**Attribution required:** You must give proper credit to Peteware when using or redistributing this project or its derivatives.

This software is provided "AS IS" without warranties of any kind.  
Violations of license terms may result in legal action.

Thank you for respecting the license and supporting open source software!

Peteware Development Team
]]

--// Services & Setup
local coreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local conn

--// UI Cleanup
local oldUI = coreGui:FindFirstChild("StopwatchGUI")

if oldUI then
    oldUI:Destroy()
end

--// Main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StopwatchGUI"
screenGui.Parent = coreGui
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 110)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

--// Timer
local timeLabel = Instance.new("TextLabel", frame)
timeLabel.Size = UDim2.new(1, -20, 0, 50)
timeLabel.Position = UDim2.new(0, 10, 0, 10)
timeLabel.BackgroundTransparency = 1
timeLabel.TextColor3 = Color3.new(1, 1, 1)
timeLabel.Font = Enum.Font.SourceSansBold
timeLabel.TextSize = 28
timeLabel.Text = "00:00:00.000"

--// Button Handlers
local startButton = Instance.new("TextButton", frame)
startButton.Size = UDim2.new(0, 60, 0, 25)
startButton.Position = UDim2.new(0, 10, 0, 70)
startButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
startButton.TextColor3 = Color3.new(1, 1, 1)
startButton.Font = Enum.Font.SourceSansBold
startButton.TextSize = 20
startButton.Text = "Start"

local stopButton = Instance.new("TextButton", frame)
stopButton.Size = UDim2.new(0, 60, 0, 25)
stopButton.Position = UDim2.new(0, 80, 0, 70)
stopButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
stopButton.TextColor3 = Color3.new(1, 1, 1)
stopButton.Font = Enum.Font.SourceSansBold
stopButton.TextSize = 20
stopButton.Text = "Stop"

local resetButton = Instance.new("TextButton", frame)
resetButton.Size = UDim2.new(0, 60, 0, 25)
resetButton.Position = UDim2.new(0, 150, 0, 70)
resetButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
resetButton.TextColor3 = Color3.new(1, 1, 1)
resetButton.Font = Enum.Font.SourceSansBold
resetButton.TextSize = 20
resetButton.Text = "Reset"

local closeButton = Instance.new("TextButton", frame)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 20
closeButton.Text = "X"

local running = false
local startTime = 0
local elapsedTime = 0

local function startStopwatch()
    if not running then
        startTime = tick() - elapsedTime
        running = true
    end
end

local function stopStopwatch()
    if running then
        elapsedTime = tick() - startTime
        running = false
    end
end

local function resetStopwatch()
    running = false
    elapsedTime = 0
    timeLabel.Text = "00:00:00.000"
end

startButton.MouseButton1Click:Connect(startStopwatch)
stopButton.MouseButton1Click:Connect(stopStopwatch)
resetButton.MouseButton1Click:Connect(resetStopwatch)
closeButton.MouseButton1Click:Connect(function()
    conn:Disconnect()
    screenGui:Destroy()
end)

--// Loop Handler
conn = RunService.RenderStepped:Connect(function()
    if running then
        elapsedTime = tick() - startTime
        local totalSeconds = math.floor(elapsedTime)
        local hours = math.floor(totalSeconds / 3600)
        local minutes = math.floor((totalSeconds % 3600) / 60)
        local seconds = totalSeconds % 60
        local milliseconds = math.floor((elapsedTime - totalSeconds) * 1000)
        timeLabel.Text = string.format("%02d:%02d:%02d.%03d", hours, minutes, seconds, milliseconds)
    end
end)
