local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local DrawingService = game:GetService("Drawing")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = 100
fovCircle.Color = Color3.fromRGB(54, 0, 198)
fovCircle.Filled = false
fovCircle.Transparency = 1

local highlights = {}
local menuOpen = false
local menuFrame
local fovInput
local toggleFovCheckbox
local toggleHighlightCheckbox

local function updateFovCircle()
    local screenCenter = Camera.ViewportSize / 2
    fovCircle.Position = Vector2.new(screenCenter.X, screenCenter.Y)
    fovCircle.Visible = true
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

local function createMenu()
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 300, 0, 200)
    menuFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
    menuFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    menuFrame.Visible = false
    menuFrame.Parent = game.Players.LocalPlayer.PlayerGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    title.Text = "Settings Menu"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.Parent = menuFrame

    toggleFovCheckbox = Instance.new("TextButton")
    toggleFovCheckbox.Size = UDim2.new(0, 280, 0, 40)
    toggleFovCheckbox.Position = UDim2.new(0, 10, 0, 40)
    toggleFovCheckbox.Text = "Toggle FOV Circle"
    toggleFovCheckbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleFovCheckbox.Parent = menuFrame
    toggleFovCheckbox.MouseButton1Click:Connect(function()
        fovCircle.Visible = not fovCircle.Visible
    end)

    toggleHighlightCheckbox = Instance.new("TextButton")
    toggleHighlightCheckbox.Size = UDim2.new(0, 280, 0, 40)
    toggleHighlightCheckbox.Position = UDim2.new(0, 10, 0, 90)
    toggleHighlightCheckbox.Text = "Toggle Player Highlights"
    toggleHighlightCheckbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    toggleHighlightCheckbox.Parent = menuFrame
    toggleHighlightCheckbox.MouseButton1Click:Connect(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    if highlights[character] then
                        for _, highlight in ipairs(highlights[character]) do
                            highlight:Destroy()
                        end
                        highlights[character] = nil
                    else
                        highlightPlayer(player)
                    end
                end
            end
        end
    end)

    fovInput = Instance.new("TextBox")
    fovInput.Size = UDim2.new(0, 280, 0, 40)
    fovInput.Position = UDim2.new(0, 10, 0, 140)
    fovInput.Text = tostring(fovCircle.Radius)
    fovInput.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    fovInput.Parent = menuFrame
    fovInput.FocusLost:Connect(function()
        local radius = tonumber(fovInput.Text)
        if radius and radius > 0 then
            fovCircle.Radius = radius
        else
            fovInput.Text = tostring(fovCircle.Radius)
        end
    end)
end

local function toggleMenu()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        toggleMenu()
    end
end)

RunService.RenderStepped:Connect(function()
    updateFovCircle()
end)

task.spawn(function()
    while true do
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                highlightPlayer(player)
            end
        end
        task.wait(2)
    end
end)
