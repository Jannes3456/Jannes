local function createMenu()
    menuFrame = Instance.new("Frame")
    menuFrame.Size = UDim2.new(0, 300, 0, 240)  -- Increased height to accommodate new button
    menuFrame.Position = UDim2.new(0.5, -150, 0.5, -120)  -- Adjusted to center
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

    -- New button to change FOV circle color
    local changeColorButton = Instance.new("TextButton")
    changeColorButton.Size = UDim2.new(0, 280, 0, 40)
    changeColorButton.Position = UDim2.new(0, 10, 0, 190)
    changeColorButton.Text = "Change FOV Circle Color"
    changeColorButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    changeColorButton.Parent = menuFrame
    changeColorButton.MouseButton1Click:Connect(function()
        fovCircle.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    end)
end

local function toggleMenu()
    menuOpen = not menuOpen
    menuFrame.Visible = menuOpen
end

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.F8 then
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

createMenu()
