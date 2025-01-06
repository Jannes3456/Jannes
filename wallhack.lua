local player = game.Players.LocalPlayer
local boxVisible = false
local boxes = {}
local screenGui, frame, toggleButton

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
            if character:FindFirstChild("HumanoidRootPart") then
                box.Position = character.HumanoidRootPart.Position
            else
                box:Destroy()
            end
        end)
    end
end

local function toggleBoxes()
    boxVisible = not boxVisible
    for _, box in pairs(boxes) do
        box.Transparency = boxVisible and 0.5 or 1
    end
end

local function createMenu()
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BoxMenu"
    screenGui.Parent = player.PlayerGui

    frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 150)
    frame.Position = UDim2.new(0.5, -100, 0.5, -75)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    frame.Parent = screenGui

    toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 180, 0, 50)
    toggleButton.Position = UDim2.new(0, 10, 0, 50)
    toggleButton.Text = "Toggle Box Visibility"
    toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleButton.Parent = frame

    toggleButton.MouseButton1Click:Connect(function()
        toggleBoxes()
    end)
end

local function openMenuOnStart()
    createMenu()
end

openMenuOnStart()

game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        createBox(character)
    end)
end)

if player.Character then
    createBox(player.Character)  
end
