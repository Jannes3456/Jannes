local player = game.Players.LocalPlayer
local boxVisible = false
local boxes = {}
local screenGui, frame, toggleButton
local highlights = {}

local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = 100
fovCircle.Color = Color3.fromRGB(54, 0, 198)
fovCircle.Filled = false
fovCircle.Transparency = 1

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

local function createHighlightForCharacter(character)
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.Parent = character
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.FillTransparency = 0.7
            highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineTransparency = 0.5
            table.insert(highlights[character], highlight)
        end
    end
end

local function highlightPlayer(player)
    local character = player.Character
    if character then
        if highlights[character] then
            for _, highlight in ipairs(highlights[character]) do
                highlight:Destroy()
            end
            highlights[character] = nil
        end
        highlights[character] = {}
        createHighlightForCharacter(character)
    end
end

local function updateFovCircle()
    local screenCenter = Camera.ViewportSize / 2
    fovCircle.Position = Vector2.new(screenCenter.X, screenCenter.Y)
    fovCircle.Visible = true
end

local function isPlayerHeadInFov(player)
    local character = player.Character
    if not character then return false end

    local head = character:FindFirstChild("Head")
    if not head then return false end

    local screenPosition, onScreen = Camera:WorldToViewportPoint(head.Position)
    if onScreen then
        local screenCenter = Camera.ViewportSize / 2
        local distanceFromCenter = (Vector2.new(screenPosition.X, screenPosition.Y) - Vector2.new(screenCenter.X, screenCenter.Y)).Magnitude
        return distanceFromCenter <= fovCircle.Radius
    end
    return false
end

local function lockCameraOnHead(player)
    local character = player.Character
    if character then
        local head = character:FindFirstChild("Head")
        if head then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
        end
    end
end

UserInputService.JumpRequest:Connect(function()
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")
    if humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

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
        highlightPlayer(player)
    end)
end)

if player.Character then
    createBox(player.Character)
    highlightPlayer(player)
end

RunService.RenderStepped:Connect(function()
    updateFovCircle()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if isPlayerHeadInFov(p) then
                lockCameraOnHead(p)
            end
        end
    end
end)

task.spawn(function()
    while true do
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                highlightPlayer(p)
            end
        end
        task.wait(2)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character and highlights[player.Character] then
        for _, highlight in ipairs(highlights[player.Character]) do
            highlight:Destroy()
        end
        highlights[player.Character] = nil
    end
end)

