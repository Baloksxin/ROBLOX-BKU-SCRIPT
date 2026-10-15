local player = game.Players.LocalPlayer

if _G._JumpHeightCleanup then
    for _, conn in ipairs(_G._JumpHeightCleanup) do
        conn:Disconnect()
    end
    _G._JumpHeightCleanup = nil
end

local connections = {}

local function applyState(hum)
    if not hum then return end
    if jumph and jumph > 0 then
        hum.UseJumpPower = false
        hum.JumpHeight = jumph
    else
        hum.UseJumpPower = true
        hum.JumpPower = 0
    end
end

local function setup(char)
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    applyState(hum)

    table.insert(connections, hum:GetPropertyChangedSignal("JumpHeight"):Connect(function()
        if jumph and jumph > 0 then
            if hum.JumpHeight ~= jumph then
                hum.JumpHeight = jumph
            end
        else
            if hum.UseJumpPower ~= true then
                hum.UseJumpPower = true
            end
            if hum.JumpPower ~= 0 then
                hum.JumpPower = 0
            end
        end
    end))

    table.insert(connections, hum:GetPropertyChangedSignal("UseJumpPower"):Connect(function()
        if jumph and jumph > 0 then
            if hum.UseJumpPower ~= false then
                hum.UseJumpPower = false
            end
            if hum.JumpHeight ~= jumph then
                hum.JumpHeight = jumph
            end
        else
            if hum.UseJumpPower ~= true then
                hum.UseJumpPower = true
            end
            if hum.JumpPower ~= 0 then
                hum.JumpPower = 0
            end
        end
    end))

    table.insert(connections, hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
        if not jumph or jumph == 0 then
            if hum.JumpPower ~= 0 then
                hum.JumpPower = 0
            end
            if hum.UseJumpPower ~= true then
                hum.UseJumpPower = true
            end
        end
    end))
end

if player.Character then
    setup(player.Character)
end

table.insert(connections, player.CharacterAdded:Connect(setup))

_G._JumpHeightCleanup = connections