-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "TheGamerPointGui"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 160)
Frame.Position = UDim2.new(0.5, -125, 0.5, -80)
Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Text = "Made by TheGamerPoint"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18

-- Dropdown Menu
local PlayerDropdown = Instance.new("TextButton", Frame)
PlayerDropdown.Size = UDim2.new(0, 220, 0, 30)
PlayerDropdown.Position = UDim2.new(0, 15, 0, 40)
PlayerDropdown.Text = "Select Player"
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
PlayerDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
PlayerDropdown.Font = Enum.Font.SourceSans
PlayerDropdown.TextSize = 16

local DropdownList = Instance.new("ScrollingFrame", Frame)
DropdownList.Size = UDim2.new(0, 220, 0, 70)
DropdownList.Position = UDim2.new(0, 15, 0, 75)
DropdownList.Visible = false
DropdownList.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
DropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownList.ScrollBarThickness = 4

-- Selected player variable
local selectedPlayer = nil

local function updateDropdown()
	DropdownList:ClearAllChildren()
	local yPos = 0

	for _, plr in ipairs(game.Players:GetPlayers()) do
		if plr ~= game.Players.LocalPlayer then
			local btn = Instance.new("TextButton", DropdownList)
			btn.Size = UDim2.new(1, 0, 0, 25)
			btn.Position = UDim2.new(0, 0, 0, yPos)
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.Font = Enum.Font.SourceSans
			btn.TextSize = 14
			btn.Text = plr.Name

			btn.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				PlayerDropdown.Text = "Selected: " .. plr.Name
				DropdownList.Visible = false
			end)

			yPos += 25
		end
	end

	DropdownList.CanvasSize = UDim2.new(0, 0, 0, yPos)
end

PlayerDropdown.MouseButton1Click:Connect(function()
	DropdownList.Visible = not DropdownList.Visible
	if DropdownList.Visible then
		updateDropdown()
	end
end)

-- Teleport Button
local TeleportButton = Instance.new("TextButton", Frame)
TeleportButton.Size = UDim2.new(0, 220, 0, 30)
TeleportButton.Position = UDim2.new(0, 15, 0, 150)
TeleportButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
TeleportButton.Text = "Teleport to Player"
TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeleportButton.Font = Enum.Font.SourceSansBold
TeleportButton.TextSize = 16

TeleportButton.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myChar = game.Players.LocalPlayer.Character
		if myChar and myChar:FindFirstChild("HumanoidRootPart") then
			myChar.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 0)
		end
	end
end)
