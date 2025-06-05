-- TheGamerPoint GUI Script

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TheGamerPointGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 350)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Text = "TheGamerPoint GUI"
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.Parent = mainFrame

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.Parent = mainFrame

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Credits label
local credits = Instance.new("TextLabel")
credits.Text = "Made by TheGamerPoint"
credits.Size = UDim2.new(1, 0, 0, 30)
credits.Position = UDim2.new(0, 0, 1, -30)
credits.BackgroundColor3 = Color3.fromRGB(30,30,30)
credits.TextColor3 = Color3.fromRGB(200, 200, 200)
credits.Font = Enum.Font.GothamItalic
credits.TextSize = 14
credits.Parent = mainFrame

-- WalkSpeed Slider label
local speedLabel = Instance.new("TextLabel")
speedLabel.Text = "WalkSpeed: 16"
speedLabel.Size = UDim2.new(1, -40, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 50)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextSize = 18
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = mainFrame

-- WalkSpeed Slider
local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0, 50, 0, 30)
speedSlider.Position = UDim2.new(1, -60, 0, 50)
speedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
speedSlider.Text = "16"
speedSlider.ClearTextOnFocus = false
speedSlider.Font = Enum.Font.Gotham
speedSlider.TextSize = 18
speedSlider.Parent = mainFrame

speedSlider.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local val = tonumber(speedSlider.Text)
        if val and val >= 16 and val <= 500 then
            speedLabel.Text = "WalkSpeed: "..val
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = val
            end
        else
            speedSlider.Text = "16"
            speedLabel.Text = "WalkSpeed: 16"
        end
    end
end)

-- Fly toggle button
local flyBtn = Instance.new("TextButton")
flyBtn.Text = "Fly: OFF"
flyBtn.Size = UDim2.new(0, 120, 0, 40)
flyBtn.Position = UDim2.new(0, 10, 0, 100)
flyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
flyBtn.TextColor3 = Color3.new(1,1,1)
flyBtn.Font = Enum.Font.GothamBold
flyBtn.TextSize = 20
flyBtn.Parent = mainFrame

local flying = false
local flySpeed = 50
local flyBodyVelocity

local function startFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    flying = true
    flyBtn.Text = "Fly: ON"
    flyBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 50)

    local hrp = LocalPlayer.Character.HumanoidRootPart
    flyBodyVelocity = Instance.new("BodyVelocity")
    flyBodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBodyVelocity.Velocity = Vector3.new(0,0,0)
    flyBodyVelocity.Parent = hrp

    local flyConnection
    flyConnection = RunService.Heartbeat:Connect(function()
        if flying and hrp and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") and LocalPlayer.Character.Humanoid.Health > 0 then
            local cam = workspace.CurrentCamera
            local direction = Vector3.new(0,0,0)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                direction = direction + cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                direction = direction - cam.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                direction = direction - cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                direction = direction + cam.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                direction = direction + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                direction = direction - Vector3.new(0,1,0)
            end
            flyBodyVelocity.Velocity = direction.Unit * flySpeed
        else
            flyBodyVelocity.Velocity = Vector3.new(0,0,0)
        end
    end)

    flyBtn.MouseButton1Click:Connect(function()
        flying = false
        flyBtn.Text = "Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if flyBodyVelocity then
            flyBodyVelocity:Destroy()
        end
        if flyConnection then
            flyConnection:Disconnect()
        end
    end)
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then
        flying = false
        flyBtn.Text = "Fly: OFF"
        flyBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        if flyBodyVelocity then flyBodyVelocity:Destroy() end
    else
        startFly()
    end
end)

-- Teleport to player UI elements
local tpLabel = Instance.new("TextLabel")
tpLabel.Text = "Teleport to Player:"
tpLabel.Size = UDim2.new(1, 0, 0, 30)
tpLabel.Position = UDim2.new(0, 10, 0, 160)
tpLabel.BackgroundTransparency = 1
tpLabel.TextColor3 = Color3.fromRGB(255,255,255)
tpLabel.Font = Enum.Font.Gotham
tpLabel.TextSize = 18
tpLabel.TextXAlignment = Enum.TextXAlignment.Left
tpLabel.Parent = mainFrame

local tpInput = Instance.new("TextBox")
tpInput.Size = UDim2.new(1, -20, 0, 30)
tpInput.Position = UDim2.new(0, 10, 0, 190)
tpInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
tpInput.TextColor3 = Color3.fromRGB(255,255,255)
tpInput.Text = ""
tpInput.PlaceholderText = "Type player name or 'all'"
tpInput.ClearTextOnFocus = true
tpInput.Font = Enum.Font.Gotham
tpInput.TextSize = 18
tpInput.Parent = mainFrame

local tpBtn = Instance.new("TextButton")
tpBtn.Text = "Teleport"
tpBtn.Size = UDim2.new(1, -20, 0, 40)
tpBtn.Position = UDim2.new(0, 10, 0, 230)
tpBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 230)
tpBtn.TextColor3 = Color3.fromRGB(255,255,255)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 20
tpBtn.Parent = mainFrame

tpBtn.MouseButton1Click:Connect(function()
    local target = tpInput.Text:lower()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    if target == "all" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = hrp.CFrame
            end
        end
    else
        local targetPlayer = Players:FindFirstChild(tpInput.Text)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            targetPlayer.Character.HumanoidRootPart.CFrame = hrp.CFrame
        else
            warn("Player not found or no character")
        end
    end
end)

-- That's it! This script creates a GUI you can drag and close, lets you toggle fly, change walk speed, teleport players, and credits yourself.

