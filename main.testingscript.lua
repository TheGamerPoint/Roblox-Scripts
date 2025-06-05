-- TheGamerPoint's Ultimate GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GamerPointGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 300, 0, 300)
Main.Position = UDim2.new(0.3, 0, 0.3, 0)
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 8)

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Position = UDim2.new(1, -35, 0, 5)
Close.Text = "X"
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.TextColor3 = Color3.new(1, 1, 1)
Close.Parent = Main
Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "TheGamerPoint GUI"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Parent = Main

-- WalkSpeed Button
local WSBtn = Instance.new("TextButton")
WSBtn.Size = UDim2.new(0, 280, 0, 40)
WSBtn.Position = UDim2.new(0, 10, 0, 50)
WSBtn.Text = "Set WalkSpeed to 100"
WSBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 200)
WSBtn.TextColor3 = Color3.new(1, 1, 1)
WSBtn.Parent = Main
WSBtn.MouseButton1Click:Connect(function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

-- Fly toggle
local flying = false
local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0, 280, 0, 40)
FlyBtn.Position = UDim2.new(0, 10, 0, 100)
FlyBtn.Text = "Toggle Fly (Off)"
FlyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 150)
FlyBtn.TextColor3 = Color3.new(1, 1, 1)
FlyBtn.Parent = Main

local function Fly()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    local bodyVelocity = Instance.new("BodyVelocity", humanoidRootPart)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.MaxForce = Vector3.new(9999, 9999, 9999)

    local flyingConn
    flyingConn = game:GetService("RunService").RenderStepped:Connect(function()
        local direction = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            direction += workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            direction -= workspace.CurrentCamera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            direction -= workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            direction += workspace.CurrentCamera.CFrame.RightVector
        end
        bodyVelocity.Velocity = direction.Unit * 100
        if not flying then
            flyingConn:Disconnect()
            bodyVelocity:Destroy()
        end
    end)
end

FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    FlyBtn.Text = flying and "Toggle Fly (On)" or "Toggle Fly (Off)"
    if flying then
        Fly()
    end
end)

-- Teleport Section
local TPBox = Instance.new("TextBox")
TPBox.Size = UDim2.new(0, 280, 0, 40)
TPBox.Position = UDim2.new(0, 10, 0, 150)
TPBox.PlaceholderText = "Enter player name or 'all'"
TPBox.Text = ""
TPBox.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
TPBox.TextColor3 = Color3.new(1, 1, 1)
TPBox.Parent = Main

local TPBtn = Instance.new("TextButton")
TPBtn.Size = UDim2.new(0, 280, 0, 40)
TPBtn.Position = UDim2.new(0, 10, 0, 200)
TPBtn.Text = "Teleport to Player"
TPBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
TPBtn.TextColor3 = Color3.new(1, 1, 1)
TPBtn.Parent = Main

TPBtn.MouseButton1Click:Connect(function()
    local input = TPBox.Text:lower()
    if input == "all" then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                plr.Character:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
            end
        end
    else
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name:lower():sub(1, #input) == input and plr.Character then
                LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position)
                break
            end
        end
    end
end)

-- Credits
local Credits = Instance.new("TextLabel")
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -30)
Credits.Text = "Made by TheGamerPoint"
Credits.TextColor3 = Color3.fromRGB(200, 200, 200)
Credits.BackgroundTransparency = 1
Credits.Parent = Main
