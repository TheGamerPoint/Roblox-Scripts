-- Example additions for your existing GUI script

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Function to kill a target player
local function killPlayer(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        targetPlayer.Character.Humanoid.Health = 0
    end
end

-- Function to teleport target player to local player
local function teleportPlayerToMe(targetPlayer)
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot then
            targetPlayer.Character.HumanoidRootPart.CFrame = myRoot.CFrame + Vector3.new(2,0,0) -- Teleport 2 studs beside you
        end
    end
end

-- Example: Add buttons to your GUI (modify your GUI code accordingly)

local killButton = Instance.new("TextButton")
killButton.Size = UDim2.new(0, 200, 0, 50)
killButton.Position = UDim2.new(0, 10, 0, 10) -- Adjust position accordingly
killButton.Text = "Kill Player"
killButton.Parent = yourGuiFrame -- Replace with your main GUI frame

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 200, 0, 50)
teleportButton.Position = UDim2.new(0, 10, 0, 70) -- Adjust position accordingly
teleportButton.Text = "Teleport Player to Me"
teleportButton.Parent = yourGuiFrame

-- Input to choose player (example: first player that is not you)
local function getFirstOtherPlayer()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            return plr
        end
    end
    return nil
end

killButton.MouseButton1Click:Connect(function()
    local target = getFirstOtherPlayer()
    if target then
        killPlayer(target)
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    local target = getFirstOtherPlayer()
    if target then
        teleportPlayerToMe(target)
    end
end)
