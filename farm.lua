local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

local function isOnSameTeam(otherPlayer)
    if player.Team and otherPlayer.Team then
        return player.Team == otherPlayer.Team
    end
    return false
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if not isOnSameTeam(otherPlayer) then
                local distance = (player.Character.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = otherPlayer
                end
            end
        end
    end
    return closestPlayer
end

-- Diese Funktion bewegt den Charakter normal zum nächstgelegenen Spieler
local function moveToClosestPlayer()
    local closestPlayer = getClosestPlayer()
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local closestPosition = closestPlayer.Character.HumanoidRootPart.Position
        if player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:MoveTo(closestPosition)
            end
        end
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.X then
        moveToClosestPlayer()
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Flame", 
    Text = "MoveTo geladen! // Drücke X, um zum nächsten Spieler zu laufen", 
    Duration = 2
})
