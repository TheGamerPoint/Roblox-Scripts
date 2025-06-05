--// Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--// Variables
local FlyEnabled = false
local Speed = 16

--// Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheGamerPointGui"
ScreenGui.Parent = game.CoreGui

--// Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 400)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true

--// Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.Text = "X"
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.TextColor3 = Color3.new(1,1,1)
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

--// Title Label
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -40, 0, 30)
TitleLabel.Position = UDim2.new(0, 5, 0, 5)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "TheGamerPoint GUI"
TitleLabel.TextColor3 = Color3.new(1,1,1)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

--// Credits Label
local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Size = UDim2.new(1, 0, 0, 20)
CreditsLabel.Position = UDim2.new(0, 0, 1, -25)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Text = "Made by TheGamerPoint"
CreditsLabel.TextColor3 = Color3.fromRGB(170, 170, 170)
CreditsLabel.Font = Enum.Font.Gotham
CreditsLabel.TextSize = 14
CreditsLabel.Parent = MainFrame

--// Buttons function
local function createButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = MainFrame
    return btn
end

local flyButton = createButton("Toggle Fly (OFF)", 50)
local teleportButton = createButton("Teleport Player To You", 100)
local walkSpeedButton = createButton("Increase WalkSpeed", 150)
local resetSpeedButton = createButton("Reset WalkSpeed", 200)

--// Fly implementation
local bodyVelocity
local bodyGyro

local function enableFly()
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = LocalPlayer.Character.HumanoidRootPart

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0,0,0)
    bodyVelocity.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    FlyEnabled = true
    flyButton.Text = "Toggle Fly (ON)"

    local speed = 50
    local direction = Vector3.new(0,0,0)

    local function onInput(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then
                direction = direction + Vector3.new(0,0,-1)
            elseif input.KeyCode == Enum.KeyCode.S then
                direction = direction + Vector3.new(0,0,1)
            elseif input.KeyCode == Enum.KeyCode.A then
                direction = direction + Vector3.new(-1,0,0)
            elseif input.KeyCode == Enum.KeyCode.D then
                direction = direction + Vector3.new(1,0,0)
            elseif input.KeyCode == Enum.KeyCode.Space then
                direction = direction + Vector3.new(0,1,0)
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                direction = direction + Vector3.new(0,-1,0)
            end
        end
    end

    local function onInputEnded(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if input.KeyCode == Enum.KeyCode.W then
                direction = direction - Vector3.new(0,0,-1)
            elseif input.KeyCode == Enum.KeyCode.S then
                direction = direction - Vector3.new(0,0,1)
            elseif input.KeyCode == Enum.KeyCode.A then
                direction = direction - Vector3.new(-1,0,0)
            elseif input.KeyCode == Enum.KeyCode.D then
                direction = direction - Vector3.new(1,0,0)
            elseif input.KeyCode == Enum.KeyCode.Space then
                direction = direction - Vector3.new(0,1,0)
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                direction = direction - Vector3.new(0,-1,0)
            end
        end
    end

    UserInputService.InputBegan:Connect(onInput)
    UserInputService.InputEnded:Connect(onInputEnded)

    RunService:BindToRenderStep("Fly", 301, function()
        if FlyEnabled and bodyVelocity and bodyGyro and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            bodyVelocity.Velocity = direction.Unit * speed
            bodyGyro.CFrame = workspace.CurrentCamera.CFrame
        else
            RunService:UnbindFromRenderStep("Fly")
        end
    end)
end

local function disableFly()
    FlyEnabled = false
    flyButton.Text = "Toggle Fly (OFF)"
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    RunService:UnbindFromRenderStep("Fly")
end

flyButton.MouseButton1Click:Connect(function()
    if FlyEnabled then
        disableFly()
    else
        enableFly()
    end
end)

--// Teleport player to you
local function getFirstOtherPlayer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            return plr
        end
    end
    return nil
end

teleportButton.MouseButton1Click:Connect(function()
    local target = getFirstOtherPlayer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        target.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(3, 0, 0)
    end
end)

--// WalkSpeed buttons
walkSpeedButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 100
    end
end)

resetSpeedButton.MouseButton1Click:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Speed -- reset to default 16
    end
end)
