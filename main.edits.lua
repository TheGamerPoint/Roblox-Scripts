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
mainFrame.Size = UDim2.new(0, 320, 0, 320)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -160)
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
local bringButton = createButton("Bring Player", 150)
local bringAllButton = createButton("Bring All Players", 200)
local speedButton = createButton("Set WalkSpeed", 250)

-- Flying Variables
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

-- Helper function to create dropdown menu of players
local function createPlayerDropdown(parentFrame, position, onPlayerSelected)
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(0, 280, 0, 150)
    dropdownFrame.Position = position
    dropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownFrame.BorderSizePixel = 0
    dropdownFrame.Parent = parentFrame

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
                onPlayerSelected(plr)
                dropdownFrame:Destroy()
            end)
        end
    end

    return dropdownFrame
end

-- Teleport to Player Dropdown
local teleportDropdownOpen = false
local teleportDropdownFrame

teleportButton.MouseButton1Click:Connect(function()
    if teleportDropdownOpen then
        if teleportDropdownFrame then
            teleportDropdownFrame:Destroy()
        end
        teleportDropdownOpen = false
        return
    end

    teleportDropdownOpen = true
    teleportDropdownFrame = createPlayerDropdown(mainFrame, teleportButton.Position + UDim2.new(0, 0, 0, 45), function(plr)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            rootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
        teleportDropdownOpen = false
    end)
end)

-- Bring Player Dropdown
local bringDropdownOpen = false
local bringDropdownFrame

bringButton.MouseButton1Click:Connect(function()
    if bringDropdownOpen then
        if bringDropdownFrame then
            bringDropdownFrame:Destroy()
        end
        bringDropdownOpen = false
        return
    end

    bringDropdownOpen = true
    bringDropdownFrame = createPlayerDropdown(mainFrame, bringButton.Position + UDim2.new(0, 0, 0, 45), function(plr)
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and rootPart then
            -- Teleport the chosen player to you
            plr.Character.HumanoidRootPart.CFrame = rootPart.CFrame + Vector3.new(0, 5, 0)
        end
        bringDropdownOpen = false
    end)
end)

-- Bring All Players Button
bringAllButton.MouseButton1Click:Connect(function()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and rootPart then
            plr.Character.HumanoidRootPart.CFrame = rootPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
end)

-- WalkSpeed input
speedButton.MouseButton1Click:Connect(function()
    -- Check if there's an input box already
    if mainFrame:FindFirstChild("SpeedInput") then return end

    local inputBox = Instance.new("TextBox")
    inputBox.Name = "SpeedInput"
    inputBox.Size = UDim2.new(0, 200, 0, 30)
    inputBox.Position = speedButton.Position + UDim2.new(0, 0, 0, 45)
    inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    inputBox.TextColor3 = Color3.new(1, 1, 1)
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Enter WalkSpeed (Default 16)"
    inputBox.TextSize = 18
    inputBox.Parent = mainFrame
    inputBox.ClearTextOnFocus = false
    inputBox.Text = ""

    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local speed = tonumber(inputBox.Text)
            if speed and speed > 0 then
                humanoid.WalkSpeed = speed
            else
                humanoid.WalkSpeed = 16 -- default
            end
            inputBox:Destroy()
        else
            inputBox:Destroy()
        end
    end)
end)

-- Update references on character respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end)
