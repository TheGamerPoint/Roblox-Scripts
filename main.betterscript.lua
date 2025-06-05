-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TheGamerPointGUI"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 250)
mainFrame.Position = UDim2.new(0.5, -150, 0.4, -125)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Make draggable
mainFrame.Active = true
mainFrame.Draggable = true

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1,1,1)
closeButton.Parent = mainFrame

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "TheGamerPoint GUI"
titleLabel.TextColor3 = Color3.new(1,1,1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

-- Credits Label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, -20, 0, 20)
creditsLabel.Position = UDim2.new(0, 10, 1, -30)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Made by TheGamerPoint"
creditsLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
creditsLabel.Font = Enum.Font.SourceSansItalic
creditsLabel.TextSize = 14
creditsLabel.TextXAlignment = Enum.TextXAlignment.Right
creditsLabel.Parent = mainFrame

-- Fly Toggle Button
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 130, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0, 45)
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
flyButton.TextColor3 = Color3.new(1,1,1)
flyButton.Font = Enum.Font.SourceSansBold
flyButton.TextSize = 18
flyButton.Text = "Fly: OFF"
flyButton.Parent = mainFrame

-- Variables for flying
local flying = false
local speed = 50
local bodyVelocity

flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    flyButton.Text = flying and "Fly: ON" or "Fly: OFF"

    if flying then
        local character = LocalPlayer.Character
        if not character then return end
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end

        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bodyVelocity.Velocity = Vector3.new(0,0,0)
        bodyVelocity.Parent = humanoidRootPart

        -- Control fly movement
        RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Character.Value, function()
            if not flying or not character.Parent then
                bodyVelocity:Destroy()
                RunService:UnbindFromRenderStep("FlyMovement")
                return
            end

            local moveDir = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.LookVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDir = moveDir - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDir = moveDir + workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDir = moveDir + Vector3.new(0,1,0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                moveDir = moveDir - Vector3.new(0,1,0)
            end

            bodyVelocity.Velocity = moveDir.Unit * speed
        end)
    else
        if bodyVelocity and bodyVelocity.Parent then
            bodyVelocity:Destroy()
        end
        RunService:UnbindFromRenderStep("FlyMovement")
    end
end)

-- Teleport Dropdown & Button
local playerDropdown = Instance.new("TextBox")
playerDropdown.PlaceholderText = "Enter player name or 'all'"
playerDropdown.Size = UDim2.new(0, 200, 0, 30)
playerDropdown.Position = UDim2.new(0, 10, 0, 100)
playerDropdown.ClearTextOnFocus = false
playerDropdown.Text = ""
playerDropdown.Parent = mainFrame

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 80, 0, 30)
teleportButton.Position = UDim2.new(0, 220, 0, 100)
teleportButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
teleportButton.TextColor3 = Color3.new(1,1,1)
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 18
teleportButton.Text = "Teleport"
teleportButton.Parent = mainFrame

teleportButton.MouseButton1Click:Connect(function()
    local text = playerDropdown.Text:lower()
    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if text == "all" then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                hrp.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
                wait(0.1)
            end
        end
    else
        local target = Players:FindFirstChild(text) or Players:FindFirstChild(function(p) return p.Name:lower():sub(1, #text) == text end)
        if not target then
            warn("Player not found")
            return
        end

        if target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        else
            warn("Target character invalid")
        end
    end
end)

-- WalkSpeed Slider and Label
local walkspeedLabel = Instance.new("TextLabel")
walkspeedLabel.Size = UDim2.new(0, 280, 0, 20)
walkspeedLabel.Position = UDim2.new(0, 10, 0, 145)
walkspeedLabel.BackgroundTransparency = 1
walkspeedLabel.TextColor3 = Color3.new(1,1,1)
walkspeedLabel.Font = Enum.Font.SourceSansBold
walkspeedLabel.TextSize = 16
walkspeedLabel.Text = "WalkSpeed: 16 (default)"
walkspeedLabel.Parent = mainFrame

local walkspeedBox = Instance.new("TextBox")
walkspeedBox.Size = UDim2.new(0, 280, 0, 30)
walkspeedBox.Position = UDim2.new(0, 10, 0, 170)
walkspeedBox.PlaceholderText = "Enter walkspeed (16-200)"
walkspeedBox.ClearTextOnFocus = true
walkspeedBox.Text = ""
walkspeedBox.Parent = mainFrame

walkspeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local value = tonumber(walkspeedBox.Text)
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if value and humanoid and value >= 16 and value <= 200 then
            humanoid.WalkSpeed = value
            walkspeedLabel.Text = "WalkSpeed: "..value
        else
            walkspeedLabel.Text = "Invalid value! Use 16-200"
        end
    end
end)

-- Reset walkspeed to default when GUI closes or script stops
screenGui.AncestryChanged:Connect(function()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = 16
    end
end)
