-- Create ScreenGui
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleUtilityGui"
screenGui.Parent = playerGui

-- Create Credits Label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(0, 300, 0, 30)
creditsLabel.Position = UDim2.new(0, 10, 0, 10)
creditsLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
creditsLabel.TextColor3 = Color3.new(1, 1, 1)
creditsLabel.Text = "Made by TheGamerPoint"
creditsLabel.Parent = screenGui

-- Create Fly Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 150, 0, 50)
flyButton.Position = UDim2.new(0, 10, 0, 50)
flyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Text = "Toggle Fly"
flyButton.Parent = screenGui

-- Create Teleport Button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 150, 0, 50)
teleportButton.Position = UDim2.new(0, 170, 0, 50)
teleportButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
teleportButton.TextColor3 = Color3.new(1, 1, 1)
teleportButton.Text = "Teleport to Player"
teleportButton.Parent = screenGui

-- Create WalkSpeed Button
local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 150, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 110)
speedButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Text = "Set WalkSpeed"
speedButton.Parent = screenGui

-- Fly script variables
local flying = false
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local UIS = game:GetService("UserInputService")

local flySpeed = 50
local flyVelocity = Instance.new("BodyVelocity")
flyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
flyVelocity.Velocity = Vector3.new(0, 0, 0)
flyVelocity.Parent = rootPart

local flyDirection = Vector3.new(0,0,0)

-- Function to update flying velocity
local function updateFly()
    flyVelocity.Velocity = flyDirection * flySpeed
end

-- Toggle flying function
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyVelocity.Parent = rootPart
        flyDirection = Vector3.new(0,0,0)
        humanoid.PlatformStand = true -- disables normal controls
        -- Listen for input to fly
        local conn
        conn = UIS.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.W then
                flyDirection = flyDirection + workspace.CurrentCamera.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.S then
                flyDirection = flyDirection - workspace.CurrentCamera.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.A then
                flyDirection = flyDirection - workspace.CurrentCamera.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.D then
                flyDirection = flyDirection + workspace.CurrentCamera.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.Space then
                flyDirection = flyDirection + Vector3.new(0, 1, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                flyDirection = flyDirection - Vector3.new(0, 1, 0)
            end
            updateFly()
        end)
        local conn2
        conn2 = UIS.InputEnded:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == Enum.KeyCode.W then
                flyDirection = flyDirection - workspace.CurrentCamera.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.S then
                flyDirection = flyDirection + workspace.CurrentCamera.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.A then
                flyDirection = flyDirection + workspace.CurrentCamera.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.D then
                flyDirection = flyDirection - workspace.CurrentCamera.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.Space then
                flyDirection = flyDirection - Vector3.new(0, 1, 0)
            elseif input.KeyCode == Enum.KeyCode.LeftControl then
                flyDirection = flyDirection + Vector3.new(0, 1, 0)
            end
            updateFly()
        end)

        -- Disconnect flying when toggle off
        flyButton.MouseButton1Click:Wait()
        flying = false
        flyVelocity.Parent = nil
        humanoid.PlatformStand = false
        conn:Disconnect()
        conn2:Disconnect()

    else
        flying = false
        flyVelocity.Parent = nil
        humanoid.PlatformStand = false
    end
end)

-- Teleport to player
teleportButton.MouseButton1Click:Connect(function()
    -- Show a simple InputDialog to enter player name
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 200, 0, 30)
    input.Position = UDim2.new(0.5, -100, 0.5, -15)
    input.PlaceholderText = "Enter player name"
    input.Parent = screenGui
    input:CaptureFocus()

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local targetName = input.Text
            local targetPlayer = game.Players:FindFirstChild(targetName)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                rootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
            else
                warn("Player not found or no character")
            end
            input:Destroy()
        else
            input:Destroy()
        end
    end)
end)

-- WalkSpeed button
speedButton.MouseButton1Click:Connect(function()
    -- Show input box for speed value
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0, 200, 0, 30)
    input.Position = UDim2.new(0.5, -100, 0.5, -15)
    input.PlaceholderText = "Enter WalkSpeed number"
    input.Parent = screenGui
    input:CaptureFocus()

    input.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local speed = tonumber(input.Text)
            if speed and speed > 0 and speed <= 500 then
                humanoid.WalkSpeed = speed
            else
                warn("Invalid speed value (1-500)")
            end
            input:Destroy()
        else
            input:Destroy()
        end
    end)
end)
