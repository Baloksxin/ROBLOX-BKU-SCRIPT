local player = game.Players.LocalPlayer

if _G._JumpHeightCleanup then
    for _, conn in ipairs(_G._JumpHeightCleanup) do
        conn:Disconnect()
    end
    _G._JumpHeightCleanup = nil
end

local connections = {}

local function setup(char)
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    if jumph and jumph ~= 0 then
        hum.UseJumpPower = false
        hum.JumpHeight = jumph
    end

    table.insert(connections, hum:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if jumph and jumph ~= 0 and hum.JumpHeight ~= jumph then
            hum.JumpHeight = jumph
        end
    end))

    table.insert(connections, hum:GetPropertyChangedSignal("UseJumpPower"):Connect(function()
        if jumph and jumph ~= 0 and hum.UseJumpPower == true then
            hum.UseJumpPower = false
            hum.JumpHeight = jumph
        end
    end))
end

if player.Character then
    setup(player.Character)
end

table.insert(connections, player.CharacterAdded:Connect(setup))

_G._JumpHeightCleanup = connections