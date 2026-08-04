local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Baloksxin/BK-PE-SCRIPT/refs/heads/main/UI.txt"))()
local LPlr = game:GetService("Players").LocalPlayer
local Players = game:GetService("Players")
local RS, UIS, Light = game:GetService("RunService"), game:GetService("UserInputService"), game:GetService("Lighting")
local Cam = workspace.CurrentCamera
local initSpeed = 16

if LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then
    initSpeed = LPlr.Character.Humanoid.WalkSpeed
end

local Config = {
    Speed = initSpeed,
    FOV = Cam.FieldOfView,
    SpeedEn = false,
    FOVEn = false,
    InfJump = false,
    Noclip = false,
    FreezeSelf = false,
    AnchorOnly = false,
    NightVis = false,
    ThirdPerson = false,
    InstantInteract = false,
}
local Orig = {
    FOV = Cam.FieldOfView,
    Bright = Light.Brightness,
    Ambient = Light.Ambient,
    Clock = Light.ClockTime,
    Speed = initSpeed,
}

local function UpdatePrompts(state)
    Config.InstantInteract = state
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            v.HoldDuration = state and 0 or 0.5
        end
    end
end

game.DescendantAdded:Connect(function(v)
    if Config.InstantInteract and v:IsA("ProximityPrompt") then
        v.HoldDuration = 0
    end
end)

local fovConnection = nil
local function LockFOV()
    if fovConnection then
        fovConnection:Disconnect()
    end
    if Cam then
        fovConnection = Cam:GetPropertyChangedSignal("FieldOfView"):Connect(function()
            if Config.FOVEn and Cam.FieldOfView ~= Config.FOV then
                Cam.FieldOfView = Config.FOV
            end
        end)
    end
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Cam = workspace.CurrentCamera
    LockFOV()
    if Config.FOVEn and Cam then
        Cam.FieldOfView = Config.FOV
    end
end)
LockFOV()

local Window = OrionLib:MakeWindow({
    Name = "BKU SCRIPT 通用",
    HidePremium = true,
    SaveConfig = false,
    IntroText = "BKU SCRIPT",
})
OrionLib:MakeNotification({ Name = "BKU SCRIPT 通用", Content = "辛巴爸爸卢比呀", Time = 3 })

local originalNoclipCollisions = {}
local cachedAnimationSpeeds = {}

local function setCharacterAnimationFrozen(char, frozen)
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            if frozen then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    cachedAnimationSpeeds[track] = track.Speed
                    track:AdjustSpeed(0)
                end
            else
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    if cachedAnimationSpeeds[track] then
                        track:AdjustSpeed(cachedAnimationSpeeds[track])
                    else
                        track:AdjustSpeed(1)
                    end
                end
                table.clear(cachedAnimationSpeeds)
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end
    end
end

LPlr.CharacterAdded:Connect(function()
    table.clear(originalNoclipCollisions)
    table.clear(cachedAnimationSpeeds)
end)

local t1 = Window:MakeTab({ Name = "信息", Icon = "rbxassetid://77348087165494" })
t1:AddSection({ Name = "信息" })
t1:AddLabel("使用者: " .. LPlr.DisplayName)
t1:AddLabel("执行器: " .. ((identifyexecutor and identifyexecutor()) or "未知"))
t1:AddLabel("游戏 ID (PlaceId): " .. tostring(game.PlaceId))
t1:AddLabel("服务器 ID (JobId): " .. (game.JobId ~= "" and game.JobId or "单人/私服"))
t1:AddButton({
    Name = "点击复制服务器 ID",
    Callback = function()
        setclipboard(game.JobId)
    end,
})
t1:AddButton({
    Name = "复制作者KS ID",
    Callback = function()
        setclipboard("Baloksxin")
    end,
})

local t2 = Window:MakeTab({ Name = "通用", Icon = "rbxassetid://77348087165494" })
t2:AddSection({ Name = "角色属性修改" })
t2:AddSlider({
    Name = "修改速度值",
    Min = 0,
    Max = 500,
    Default = Orig.Speed,
    Increment = 1,
    ValueName = "",
    Callback = function(v)
        Config.Speed = v
        if Config.SpeedEn and LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then
            LPlr.Character.Humanoid.WalkSpeed = v
        end
    end,
})
t2:AddToggle({
    Name = "开启速度修改",
    Callback = function(v)
        Config.SpeedEn = v
        if not v and LPlr.Character:FindFirstChild("Humanoid") then
            LPlr.Character.Humanoid.WalkSpeed = Orig.Speed
        elseif v and LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then
            LPlr.Character.Humanoid.WalkSpeed = Config.Speed
        end
    end,
})
t2:AddSlider({
    Name = "修改FOV值",
    Min = 1,
    Max = 120,
    Default = Orig.FOV,
    Increment = 1,
    ValueName = "",
    Callback = function(v)
        Config.FOV = v
        if Config.FOVEn and Cam then
            Cam.FieldOfView = v
        end
    end,
})
t2:AddToggle({
    Name = "开启 FOV 修改",
    Callback = function(v)
        Config.FOVEn = v
        if not v then
            Cam.FieldOfView = Orig.FOV
        else
            Cam.FieldOfView = Config.FOV
        end
    end,
})
t2:AddToggle({
    Name = "第三人称",
    Callback = function(v)
        Config.ThirdPerson = v
    end,
})
t2:AddToggle({
    Name = "无限跳跃",
    Callback = function(v)
        Config.InfJump = v
    end,
})
t2:AddToggle({
    Name = "穿墙模式 (Noclip)",
    Callback = function(v)
        Config.Noclip = v
        if not v then
            for part, originalState in pairs(originalNoclipCollisions) do
                if part and part.Parent then
                    part.CanCollide = originalState
                end
            end
            table.clear(originalNoclipCollisions)
        end
    end,
})
t2:AddToggle({
    Name = "固定自己",
    Callback = function(v)
        Config.FreezeSelf = v
        if LPlr.Character then
            local hrp = LPlr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = v
            end
            setCharacterAnimationFrozen(LPlr.Character, v)
        end
    end,
})
t2:AddToggle({
    Name = "固定自己(不固定动画)",
    Callback = function(v)
        Config.AnchorOnly = v
        if LPlr.Character then
            local hrp = LPlr.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = v
            end
        end
    end,
})
t2:AddToggle({
    Name = "夜视模式",
    Callback = function(v)
        Config.NightVis = v
        if not v then
            Light.Brightness, Light.Ambient, Light.ClockTime = Orig.Bright, Orig.Ambient, Orig.Clock
        end
    end,
})
t2:AddToggle({
    Name = "立即互动",
    Callback = function(v)
        UpdatePrompts(v)
    end,
})
t2:AddSection({ Name = "开启跳跃" })
local defaultJumpPower = 15
local jumpHeightValue = defaultJumpPower
t2:AddTextbox({
    Name = "跳跃高度",
    Default = "15",
    TextDisappear = false,
    Callback = function(v)
        jumpHeightValue = tonumber(v) or defaultJumpPower
    end,
})
t2:AddButton({
    Name = "开启跳跃按钮(覆盖游戏原有)",
    Callback = function()
        local jumph = jumpHeightValue
        loadstring(
            [[local jumph = ]]
                .. tostring(jumph)
                .. [[ ]]
                .. game:HttpGet(
                    "https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/JB.LUA"
                )
        )()
    end,
})

local tTools = Window:MakeTab({ Name = "工具", Icon = "rbxassetid://77348087165494" })
tTools:AddSection({ Name = "工具" })
tTools:AddButton({
    Name = "AnimHubV2",
    Callback = function()
        loadstring(
            game:HttpGet(
                "https://raw.githubusercontent.com/Emerson2-creator/Scripts-Roblox/refs/heads/main/ScriptR6/AnimGuiV2.lua"
            )
        )()
    end,
})
tTools:AddButton({
    Name = "声音修改工具",
    Callback = function()
        loadstring(
            game:HttpGet(
                "https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/%E5%A3%B0%E9%9F%B3%E4%BF%AE%E6%94%B9.LUA"
            )
        )()
    end,
})
tTools:AddButton({
    Name = "手机版Shiftlock",
    Callback = function()
        loadstring(
            game:HttpGet(
                "https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/MobileShiftlock.LUA"
            )
        )()
    end,
})
tTools:AddButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})
tTools:AddButton({
    Name = "TP Tool",
    Callback = function()
        loadstring(
            game:HttpGet(
                "https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/TP%20TOOL.LUA"
            )
        )()
    end,
})
tTools:AddButton({
    Name = "飞行 GUI",
    Callback = function()
        loadstring(
            game:HttpGet(
                "https://raw.githubusercontent.com/Baloksxin/ROBLOX-BKU-SCRIPT/refs/heads/main/Scripts/Fly%20Gui.LUA"
            )
        )()
    end,
})
tTools:AddButton({
    Name = "R15动作脚本",
    Callback = function()
        loadstring(
            game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Free-emote/refs/heads/main/Delta%20mad%20stuffs")
        )()
    end,
})

local tRotation = Window:MakeTab({ Name = "旋转", Icon = "rbxassetid://77348087165494" })

local RotationConfig = {
    Enabled = false,
    Speed = 1,
    Direction = 1,
}

local rotationConnection = nil

local function startRotation()
    if rotationConnection then
        rotationConnection:Disconnect()
        rotationConnection = nil
    end

    if not RotationConfig.Enabled then
        if LPlr.Character then
            local humanoid = LPlr.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.AutoRotate = true
            end
        end
        return
    end

    if LPlr.Character then
        local humanoid = LPlr.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = false
        end
    end

    rotationConnection = RS.RenderStepped:Connect(function()
        if not RotationConfig.Enabled then
            return
        end

        local char = LPlr.Character
        if not char then
            return
        end

        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            return
        end

        local currentCFrame = hrp.CFrame
        local rotationAngle = math.rad(RotationConfig.Speed * RotationConfig.Direction)
        local newCFrame = currentCFrame * CFrame.Angles(0, rotationAngle, 0)
        hrp.CFrame = newCFrame
    end)
end

LPlr.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if RotationConfig.Enabled then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.AutoRotate = false
        end
        if rotationConnection then
            rotationConnection:Disconnect()
            rotationConnection = nil
        end
        startRotation()
    end
end)

tRotation:AddSection({ Name = "旋转功能" })

tRotation:AddToggle({
    Name = "开启旋转",
    Default = false,
    Callback = function(v)
        RotationConfig.Enabled = v
        if v then
            startRotation()
        else
            if rotationConnection then
                rotationConnection:Disconnect()
                rotationConnection = nil
            end
            if LPlr.Character then
                local humanoid = LPlr.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid.AutoRotate = true
                end
            end
        end
    end,
})

tRotation:AddSlider({
    Name = "旋转速度",
    Min = 1,
    Max = 500,
    Default = 1,
    Increment = 1,
    ValueName = "度/帧",
    Callback = function(v)
        RotationConfig.Speed = v
    end,
})

tRotation:AddDropdown({
    Name = "旋转方向",
    Default = "顺时针",
    Options = { "顺时针", "逆时针" },
    Callback = function(v)
        if v == "顺时针" then
            RotationConfig.Direction = 1
        else
            RotationConfig.Direction = -1
        end
    end,
})

RS.RenderStepped:Connect(function()
    if Config.SpeedEn and LPlr.Character and LPlr.Character:FindFirstChild("Humanoid") then
        LPlr.Character.Humanoid.WalkSpeed = Config.Speed
    end
    if Config.NightVis then
        Light.Brightness, Light.Ambient, Light.ClockTime = 2, Color3.new(1, 1, 1), 12
    end
    if Config.FOVEn and Cam then
        Cam.FieldOfView = Config.FOV
    end
    if Config.ThirdPerson then
        LPlr.CameraMode = Enum.CameraMode.Classic
    end
end)

RS.Stepped:Connect(function()
    if Config.Noclip and LPlr.Character then
        for _, v in ipairs(LPlr.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                if originalNoclipCollisions[v] == nil then
                    originalNoclipCollisions[v] = v.CanCollide
                end
                v.CanCollide = false
            end
        end
    end
    if Config.AnchorOnly and LPlr.Character then
        local hrp = LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
        end
    end
    if Config.FreezeSelf and LPlr.Character then
        local hrp = LPlr.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Anchored = true
        end
        local humanoid = LPlr.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                    if track.Speed ~= 0 then
                        cachedAnimationSpeeds[track] = track.Speed
                        track:AdjustSpeed(0)
                    end
                end
            end
        end
    end
end)

UIS.JumpRequest:Connect(function()
    if Config.InfJump and LPlr.Character then
        local h = LPlr.Character:FindFirstChildOfClass("Humanoid")
        if h then
            h:ChangeState("Jumping")
        end
    end
end)

OrionLib:Init()
