-- main.thegamerpointgui.lua modified

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI creation (assuming it's mostly the same, I'm focusing on the teleport part)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TheGamerPointGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Parent = ScreenGui

-- Player dropdown (Selection)
local PlayerDropdown = Instance.new("TextButton")
PlayerDropdown.Text = "Select Player"
PlayerDropdown.Size = UDim2.new(0, 280, 0, 40)
PlayerDropdown.Position = UDim2.new(0, 10, 0, 10)
PlayerDropdown.Parent = Frame

local DropdownList = Instance.new("ScrollingFrame")
DropdownList.Size = UDim2.new(0, 280, 0, 150)
DropdownList.Position = UDim2.new(0, 10, 0, 55)
DropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DropdownList.Visible = false
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = DropdownList
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local selectedPlayerName = nil

-- Helper to refresh dropdown players + add "All"
local function refreshPlayers()
    for _, child in pairs(DropdownList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    -- Add "All" button
    local allButton = Instance.new("TextButton")
    allButton.Size = UDim2.new(1, 0, 0, 30)
    allButton.Text = "All"
    allButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    allButton.TextColor3 = Color3.new(1,1,1)
    allButton.Parent = DropdownList
    allButton.MouseButton1Click:Connect(function()
        selectedPlayerName = "All"
        PlayerDropdown.Text = "Selected: All"
        DropdownList.Visible = false
    end)

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Text = player.Name
            btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = DropdownList
            btn.MouseButton1Click:Connect(function()
                selectedPlayerName = player.Name
                PlayerDropdown.Text = "Selected: "..player.Name
                DropdownList.Visible = false
            end)
        end
    end

    -- Adjust canvas size
    UIListLayout:DoLayout()
    local layoutSize = UIListLayout.AbsoluteContentSize.Y
    DropdownList.CanvasSize = UDim2.new(0,0,0,layoutSize)
end

PlayerDropdown.MouseButton1Click:Connect(function()
    DropdownList.Visible = not DropdownList.Visible
    if DropdownList.Visible then
        refreshPlayers()
    end
end)

-- Teleport button
local TeleportButton = Instance.new("TextButton")
TeleportButton.Size = UDim2.new(0, 280, 0, 40)
TeleportButton.Position = UDim2.new(0, 10, 0, 210)
TeleportButton.Text = "Teleport Selected to Me"
TeleportButton.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
TeleportButton.TextColor3 = Color3.new(1,1,1)
TeleportButton.Parent = Frame

TeleportButton.MouseButton1Click:Connect(function()
    if selectedPlayerName then
        if selectedPlayerName == "All" then
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
                    player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        else
            local player = Players:FindFirstChild(selectedPlayerName)
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    else
        warn("No player selected!")
    end
end)

-- You can add your credits label or other UI as needed here.

