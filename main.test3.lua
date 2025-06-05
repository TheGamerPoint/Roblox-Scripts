-- Made by TheGamerPoint
local ScreenGui = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local UICorner = Instance.new("UICorner")
local Close = Instance.new("TextButton")
local Credit = Instance.new("TextLabel")
local Fly = Instance.new("TextButton")
local Speed = Instance.new("TextButton")
local Teleport = Instance.new("TextButton")
local TeleportHere = Instance.new("TextButton")
local Kill = Instance.new("TextButton")
local PlayerBox = Instance.new("TextBox")

ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "TheGamerPointGui"

Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Main.Position = UDim2.new(0.3, 0, 0.2, 0)
Main.Size = UDim2.new(0, 300, 0, 300)
Main.Active = true
Main.Draggable = true

UICorner.Parent = Main

Close.Name = "Close"
Close.Parent = Main
Close.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Close.Position = UDim2.new(0.88, 0, 0, 0)
Close.Size = UDim2.new(0, 30, 0, 30)
Close.Text = "X"
Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

Credit.Name = "Credit"
Credit.Parent = Main
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0, 0, 0.92, 0)
Credit.Size = UDim2.new(1, 0, 0, 25)
Credit.Text = "Made by TheGamerPoint"
Credit.TextColor3 = Color3.fromRGB(255, 255, 255)
Credit.TextScaled = true

Fly.Name = "Fly"
Fly.Parent = Main
Fly.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Fly.Position = UDim2.new(0.05, 0, 0.1, 0)
Fly.Size = UDim2.new(0, 120, 0, 40)
Fly.Text = "Fly (Toggle)"
Fly.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://pastebin.com/raw/Kf9nG6Gz"))() -- Simple fly
end)

Speed.Name = "Speed"
Speed.Parent = Main
Speed.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Speed.Position = UDim2.new(0.55, 0, 0.1, 0)
Speed.Size = UDim2.new(0, 120, 0, 40)
Speed.Text = "Set Speed to 100"
Speed.MouseButton1Click:Connect(function()
	game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100
end)

PlayerBox.Name = "PlayerBox"
PlayerBox.Parent = Main
PlayerBox.PlaceholderText = "Enter Player Name"
PlayerBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
PlayerBox.Position = UDim2.new(0.05, 0, 0.3, 0)
PlayerBox.Size = UDim2.new(0.9, 0, 0, 30)
PlayerBox.TextColor3 = Color3.fromRGB(255, 255, 255)

Teleport.Name = "Teleport"
Teleport.Parent = Main
Teleport.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Teleport.Position = UDim2.new(0.05, 0, 0.45, 0)
Teleport.Size = UDim2.new(0, 120, 0, 40)
Teleport.Text = "Teleport to Player"
Teleport.MouseButton1Click:Connect(function()
	local target = game.Players:FindFirstChild(PlayerBox.Text)
	if target and target.Character then
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
	end
end)

TeleportHere.Name = "TeleportHere"
TeleportHere.Parent = Main
TeleportHere.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TeleportHere.Position = UDim2.new(0.55, 0, 0.45, 0)
TeleportHere.Size = UDim2.new(0, 120, 0, 40)
TeleportHere.Text = "Bring Player"
TeleportHere.MouseButton1Click:Connect(function()
	local target = game.Players:FindFirstChild(PlayerBox.Text)
	if target and target.Character then
		target.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
	end
end)

Kill.Name = "Kill"
Kill.Parent = Main
Kill.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Kill.Position = UDim2.new(0.3, 0, 0.65, 0)
Kill.Size = UDim2.new(0, 120, 0, 40)
Kill.Text = "Kill Player"
Kill.MouseButton1Click:Connect(function()
	local target = game.Players:FindFirstChild(PlayerBox.Text)
	if target and target.Character and target.Character:FindFirstChild("Humanoid") then
		target.Character.Humanoid.Health = 0
	end
end)
