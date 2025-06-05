local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TheGamerPointGui"
screenGui.Parent = PlayerGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 300) -- increased height to fit new button
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Active = true -- required for dragging
mainFrame.Draggable = true

-- Top bar for dragging
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 30)
topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
topBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.Text = "TheGamerPoint GUI"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = topBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 50, 1, 0)
closeButton.Position = UDim2.new(1, -50, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(170, 50, 50)
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Text = "X"
closeButton.Parent = topBar

closeButton.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- Credits Label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, 0, 0, 20)
creditsLabel.Position = UDim2.new(0, 0, 1, -20)
creditsLabel.BackgroundTransparency = 1
creditsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.TextSize = 14
creditsLabel.Text = "Made by TheGamerPoint"
creditsLabel.Parent = mainFrame

-- Buttons Style
local function createButton(text, positionY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.BorderSizePixel = 0
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 18
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = text
    btn.Parent = mainFrame
    return btn
end

local flyButton = createButton("Toggle Fly (Off)", 50)
local teleportButton = createButton("Teleport to Player", 100)
local allButton = createButton("Teleport ALL to Me", 150) -- new button
local speedButton = createButton("Set WalkSpeed", 200)

-- Flying Variables (unchanged) ...
local flying = false
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local flySpeed = 50
local bodyVelocity = nil
local flyConnection1, flyConnection2

local function startFlying()
    if flying then return end
    flying = true
    flyButton.Text = "Toggle Fly (On)"
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    humanoid.PlatformStand = true

    local direction = Vector3.new(0,0,0)
    local function updateVelocity()
        bodyVelocity.Velocity = direction * flySpeed
    end

    flyConnection1 = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.W then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.S then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.A then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.D then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.Space then
            direction = direction + Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            direction = direction - Vector3.new(0, 1, 0)
        end
        updateVelocity()
    end)

    flyConnection2 = UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.W then
            direction = direction - workspace.CurrentCamera.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.S then
            direction = direction + workspace.CurrentCamera.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.A then
            direction = direction + workspace.CurrentCamera.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.D then
            direction = direction - workspace.CurrentCamera.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.Space then
            direction = direction - Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftControl then
            direction = direction + Vector3.new(0, 1, 0)
        end
        updateVelocity()
    end)
end

local function stopFlying()
    flying = false
    flyButton.Text = "Toggle Fly (Off)"
    humanoid.PlatformStand = false
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if flyConnection1 then flyConnection1:Disconnect() flyConnection1 = nil end
    if flyConnection2 then flyConnection2:Disconnect() flyConnection2 = nil end
end

flyButton.MouseButton1Click:Connect(function()
    if flying then
        stopFlying()
    else
        startFlying()
    end
end)

-- Teleport to Player Dropdown
local dropdownOpen = false
local dropdownFrame

teleportButton.MouseButton1Click:Connect(function()
    if dropdownOpen then
        dropdownFrame:Destroy()
        dropdownOpen = false
        return
    end

    dropdownOpen = true

    dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(0, 280, 0, 200)
    dropdownFrame.Position = teleportButton.Position + UDim2.new(0, 0, 0, 45)
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = mainFrame

    local layout = Instance.new("UIListLayout")
    layout.Parent = dropdownFrame
    layout.Padding = UDim.new(0, 5)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, -10, 0, 30)
            playerBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            playerBtn.BorderSizePixel = 0
            playerBtn.TextColor3 = Color3.new(1,1,1)
            playerBtn.Font = Enum.Font.Gotham
            playerBtn.TextSize = 16
            playerBtn.Text = plr.Name
            playerBtn.Parent = dropdownFrame

            playerBtn.MouseButton1Click:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    -- Teleport yourself to the selected player
                    rootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                end
                dropdownFrame:Destroy()
                dropdownOpen = false
            end)

            -- Right-click / secondary button for "Bring Player to Me"
            playerBtn.MouseButton2Click:Connect(function()
                if plr.Character and plr.Character:Find
