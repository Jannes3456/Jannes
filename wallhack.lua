local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local head = character:WaitForChild("Head")

local function keepHeadDown()
    while true do
        head.CFrame = CFrame.new(head.Position) * CFrame.Angles(math.rad(-90), 0, 0)
        wait(0.1)
    end
end

keepHeadDown()
