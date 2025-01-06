local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local targetPart = nil

-- Funktion zum Finden des nächstgelegenen Ziels
function getClosestTarget()
    local closestTarget = nil
    local closestDistance = math.huge  -- Setze eine sehr hohe Anfangsdistanz
    
    -- Durchsuche alle NPCs oder Objekte in der Umgebung
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") then  -- Prüfe, ob es ein NPC ist
            local part = obj:FindFirstChild("Head")  -- Nehme den Kopf des NPCs als Ziel
            if part then
                local distance = (part.Position - mouse.Hit.p).Magnitude
                if distance < closestDistance then
                    closestTarget = part
                    closestDistance = distance
                end
            end
        end
    end
    return closestTarget
end

-- Zielerfassungs-Funktion
function aimAtTarget()
    targetPart = getClosestTarget()
    if targetPart then
        -- Berechne den Vektor zum Ziel
        local targetPosition = targetPart.Position
        -- Erstelle eine Zielrichtung
        local direction = (targetPosition - player.Character.HumanoidRootPart.Position).unit
        -- Drehe den Charakter in diese Richtung
        player.Character:SetPrimaryPartCFrame(CFrame.new(player.Character.HumanoidRootPart.Position, targetPosition))
    end
end

-- Verfolge das Ziel, wenn die rechte Maustaste gedrückt wird
mouse.Button2Down:Connect(function()
    while mouse.Button2Down do
        aimAtTarget()
        wait(0.05)  -- Aktualisiere das Ziel alle 50 Millisekunden
    end
end)
