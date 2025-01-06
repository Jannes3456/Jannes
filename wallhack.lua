local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local boxVisible = false
local boxes = {}

local function createBox(character)
    if character and character:FindFirstChild("HumanoidRootPart") then
        local box = Instance.new("Part")
        box.Size = Vector3.new(6, 10, 6)
        box.Position = character.HumanoidRootPart.Position
        box.Anchored = true
        box.CanCollide = false
        box.Transparency = 0.5
        box.BrickColor = BrickColor.new("Bright red")
        box.Parent = workspace
        
        table.insert(boxes, box)

        game:GetService("RunService").Heartbeat:Connect(function()
            box.Position = character.HumanoidRootPart.Position
        end)
    end
end

local function toggleBoxes()
    boxVisible = not boxVisible
    for _, box in pairs(boxes) do
        box.Transparency = boxVisible and 0.5 or 1
    end
end

mouse.KeyDown:Connect(function(key)
    if key:lower() == "e" then
        toggleBoxes()
    end
end)

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        createBox(character)
    end)
end)

if player.Character then
    createBox(player.Character)
end
