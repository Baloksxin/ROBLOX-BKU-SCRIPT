local player = game.Players.LocalPlayer

if _G._JumpHeightCleanup then
    for _, conn in ipairs(_G._JumpHeightCleanup) do
        conn:Disconnect()
    end
    _G._JumpHeightCleanup = nil
end

local function getTarget()
    local val = _G.jumph
    if val == nil or val == 0 then
        return 15
    end
    return val
end

local connections = {}

local function setup(char)
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    hum.UseJumpPower = false
    hum.JumpHeight = getTarget()

    table.insert(connections, hum:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        local target = getTarget()
        if hum.JumpHeight ~= target then
            hum.JumpHeight = target
        end
    end))

    table.insert(connections, hum:GetPropertyChangedSignal("UseJumpPower"):Connect(function()
        local target = getTarget()
        if hum.UseJumpPower == true then
            hum.UseJumpPower = false
            hum.JumpHeight = target
        end
    end))
end

if player.Character then
    setup(player.Character)
end

table.insert(connections, player.CharacterAdded:Connect(setup))

_G._JumpHeightCleanup = connections