local gun = script.Parent -- Hier den Ort deiner Waffe angeben
local fireRate = 0.1 -- Geschwindigkeit des Schießens, hier 100ms
local rapidFire = true -- Setze auf true für Rapid-Fire
local isFiring = false

local function shoot()
    if gun and gun:FindFirstChild("Fire") then
        -- Hier könnte der Fire-Mechanismus deiner Waffe aufgerufen werden
        gun.Fire:Fire()  -- Beispiel, wie eine Schussfunktion aufgerufen wird
    end
end

local function startFiring()
    while isFiring do
        shoot()
        wait(fireRate) -- Hier wird die Feuerrate angepasst
    end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isFiring = true
        startFiring()
    end
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isFiring = false
    end
end)
