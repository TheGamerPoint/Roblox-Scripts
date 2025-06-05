-- Your full original code here (paste it exactly as you had it) --
-- (Since you didn’t provide the full code pasted, I’m showing the additions below) --

-- Add a dropdown list with player names + "All"
local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

-- Assuming you have a UI dropdown named "PlayerDropdown" somewhere in your GUI
-- If you don't have it, you need to create it in the GUI beforehand.

local playerDropdown = script.Parent:WaitForChild("PlayerDropdown") -- Adjust path as needed

-- Populate dropdown with all player names + "All"
local function updateDropdown()
    local playerNames = {"All"}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    playerDropdown:ClearAllItems()
    for _, name in pairs(playerNames) do
        playerDropdown:AddItem(name)
    end
end

updateDropdown()
Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)

-- Teleport button logic
local teleportButton = script.Parent:WaitForChild("TeleportButton") -- Adjust path

teleportButton.MouseButton1Click:Connect(function()
    local selected = playerDropdown:GetSelectedItem()
    if not selected then return end

    if selected == "All" then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    else
        local player = Players:FindFirstChild(selected)
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = localPlayer.Character.HumanoidRootPart.CFrame
        end
    end
end)
