-- Beispiel: Kopfbewegung für den Spieler, ohne die FOV zu ändern
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Warte, bis der Humanoid und Kopf vorhanden sind
local humanoid = character:WaitForChild("Humanoid")
local head = character:WaitForChild("Head")

-- Funktion für zufällige Kopfbewegung ohne die Kamera zu beeinflussen
local function randomHeadRotation()
    while true do
        -- Setze zufällige Drehung für den Kopf
        local randomRotation = Vector3.new(math.random(-15, 15), math.random(-15, 15), math.random(-15, 15))
        
        -- Wende die Rotation nur auf den Kopf an
        head.CFrame = head.CFrame * CFrame.Angles(math.rad(randomRotation.X), math.rad(randomRotation.Y), math.rad(randomRotation.Z))
        
        wait(0.1) -- Warte 100 ms bevor der nächste zufällige Wert gesetzt wird (0.1 Sekunden)
    end
end

-- Starte die Kopfrotation
randomHeadRotation()
