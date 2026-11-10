local flySpeed = 60
local minSpeed = 30
local maxSpeed = 500

local Players = game:GetService("Players")
local rs = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer

local function protectGui(gui)
	local ok = pcall(function()
		gui.Parent = game:GetService("CoreGui")
	end)
	if not ok then
		pcall(function()
			gui.Parent = plr:WaitForChild("PlayerGui")
		end)
	end
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlyControlGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
protectGui(ScreenGui)

local Frame = Instance.new("Frame")
Frame.Name = "MainFrame"
Frame.Size = UDim2.new(0, 200, 0, 190)
Frame.Position = UDim2.new(0.5, -100, 0.5, -95)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.BorderColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.BorderSizePixel = 0
Title.Text = "飞行Ui--由Baloksxin汉化"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.Gotham
Title.TextSize = 14
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0.9, 0, 0, 30)
ToggleButton.Position = UDim2.new(0.05, 0, 0, 40)
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
ToggleButton.BorderSizePixel = 0
ToggleButton.Text = "开启飞行"
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 12
ToggleButton.Parent = Frame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = ToggleButton

local NoclipButton = Instance.new("TextButton")
NoclipButton.Name = "NoclipButton"
NoclipButton.Size = UDim2.new(0.9, 0, 0, 30)
NoclipButton.Position = UDim2.new(0.05, 0, 0, 80)
NoclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
NoclipButton.BorderSizePixel = 0
NoclipButton.Text = "穿墙: 关闭"
NoclipButton.TextColor3 = Color3.fromRGB(200, 200, 200)
NoclipButton.Font = Enum.Font.Gotham
NoclipButton.TextSize = 12
NoclipButton.Parent = Frame

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 6)
NoclipCorner.Parent = NoclipButton

local SpeedSlider = Instance.new("Frame")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(0.9, 0, 0, 50)
SpeedSlider.Position = UDim2.new(0.05, 0, 0, 120)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Parent = Frame

local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 6)
SliderCorner.Parent = SpeedSlider

local SpeedText = Instance.new("TextLabel")
SpeedText.Name = "SpeedText"
SpeedText.Size = UDim2.new(1, 0, 0, 20)
SpeedText.Position = UDim2.new(0, 0, 0, 0)
SpeedText.BackgroundTransparency = 1
SpeedText.Text = "速度: " .. flySpeed
SpeedText.TextColor3 = Color3.fromRGB(200, 200, 200)
SpeedText.Font = Enum.Font.Gotham
SpeedText.TextSize = 12
SpeedText.Parent = SpeedSlider

local SliderBar = Instance.new("Frame")
SliderBar.Name = "SliderBar"
SliderBar.Size = UDim2.new(0.9, 0, 0, 6)
SliderBar.Position = UDim2.new(0.05, 0, 0, 25)
SliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = SpeedSlider

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(0, 3)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Name = "SliderFill"
SliderFill.Size = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), 0, 1, 0)
SliderFill.Position = UDim2.new(0, 0, 0, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(0, 3)
FillCorner.Parent = SliderFill

local SliderButton = Instance.new("TextButton")
SliderButton.Name = "SliderButton"
SliderButton.Size = UDim2.new(0, 20, 0, 20)
SliderButton.Position = UDim2.new((flySpeed - minSpeed) / (maxSpeed - minSpeed), -10, 0.5, -10)
SliderButton.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
SliderButton.BorderSizePixel = 0
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local SliderButtonCorner = Instance.new("UICorner")
SliderButtonCorner.CornerRadius = UDim.new(0, 10)
SliderButtonCorner.Parent = SliderButton

local flying = false
local noclipEnabled = false
local flyConnection = nil
local originalCollisions = {}
local controlModule = nil
local keys = { W = false, A = false, S = false, D = false }

pcall(function()
	controlModule = require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
end)

local function getRoot(char)
	if not char then
		return nil
	end
	return char:FindFirstChild("HumanoidRootPart")
		or char:FindFirstChild("Torso")
		or char:FindFirstChild("UpperTorso")
		or char.PrimaryPart
end

local function getHumanoid(char)
	return char and char:FindFirstChildOfClass("Humanoid")
end

local function getCamera()
	return workspace.CurrentCamera
end

local function getMoveVector()
	if controlModule then
		local ok, dir = pcall(function()
			return controlModule:GetMoveVector()
		end)
		if ok and typeof(dir) == "Vector3" and dir.Magnitude > 0.01 then
			return Vector3.new(dir.X, 0, dir.Z)
		end
	end
	local x, z = 0, 0
	if keys.D then
		x += 1
	end
	if keys.A then
		x -= 1
	end
	if keys.W then
		z -= 1
	end
	if keys.S then
		z += 1
	end
	if x ~= 0 or z ~= 0 then
		return Vector3.new(x, 0, z)
	end
	local hum = getHumanoid(plr.Character)
	local cam = getCamera()
	if hum and cam and hum.MoveDirection.Magnitude > 0.01 then
		local md = hum.MoveDirection
		local look = Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z)
		local right = Vector3.new(cam.CFrame.RightVector.X, 0, cam.CFrame.RightVector.Z)
		if look.Magnitude < 0.01 then
			look = Vector3.new(0, 0, -1)
		else
			look = look.Unit
		end
		if right.Magnitude < 0.01 then
			right = Vector3.new(1, 0, 0)
		else
			right = right.Unit
		end
		local flat = Vector3.new(md.X, 0, md.Z)
		if flat.Magnitude > 0.01 then
			flat = flat.Unit
			return Vector3.new(flat:Dot(right), 0, -flat:Dot(look))
		end
	end
	return Vector3.zero
end

local function clearMovers(root)
	if not root then
		return
	end
	for _, name in ipairs({ "VelocityHandler", "GyroHandler", "FlyLinearVelocity", "FlyAttachment", "FlyAlign" }) do
		local obj = root:FindFirstChild(name)
		if obj then
			obj:Destroy()
		end
	end
	for _, child in ipairs(root:GetChildren()) do
		if child:IsA("BodyVelocity") or child:IsA("BodyGyro") or child:IsA("LinearVelocity") or child:IsA("AlignOrientation") then
			if child.Name:find("Fly") or child.Name:find("VelocityHandler") or child.Name:find("GyroHandler") then
				child:Destroy()
			end
		end
	end
end

local function makeMovers(root)
	clearMovers(root)
	local attach = Instance.new("Attachment")
	attach.Name = "FlyAttachment"
	attach.Parent = root

	local lv = Instance.new("LinearVelocity")
	lv.Name = "FlyLinearVelocity"
	lv.Attachment0 = attach
	lv.MaxForce = 1e9
	lv.VectorVelocity = Vector3.zero
	lv.RelativeTo = Enum.ActuatorRelativeTo.World
	lv.Parent = root

	local ao = Instance.new("AlignOrientation")
	ao.Name = "FlyAlign"
	ao.Mode = Enum.OrientationAlignmentMode.OneAttachment
	ao.Attachment0 = attach
	ao.MaxTorque = 1e9
	ao.Responsiveness = 200
	ao.Parent = root

	return lv, ao, attach
end

local function setVelocity(root, lv, velocity)
	if lv and lv.Parent then
		pcall(function()
			lv.VectorVelocity = velocity
		end)
	end
	pcall(function()
		root.AssemblyLinearVelocity = velocity
	end)
end

local function disableFlight()
	if not flying then
		return
	end
	flying = false
	ToggleButton.Text = "开启飞行"
	ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	local char = plr.Character
	local hum = getHumanoid(char)
	local root = getRoot(char)
	if hum then
		hum.PlatformStand = false
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end
	if root then
		clearMovers(root)
		pcall(function()
			root.AssemblyLinearVelocity = Vector3.zero
		end)
	end
end

local function enableFlight()
	if flying then
		return
	end
	local char = plr.Character
	local hum = getHumanoid(char)
	local root = getRoot(char)
	if not (char and hum and root and hum.Health > 0) then
		return
	end

	flying = true
	ToggleButton.Text = "关闭飞行"
	ToggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)

	local lv, ao = makeMovers(root)
	hum.PlatformStand = true
	pcall(function()
		hum:ChangeState(Enum.HumanoidStateType.Physics)
	end)
	pcall(function()
		hum.AutoRotate = false
	end)

	flyConnection = rs.Heartbeat:Connect(function(dt)
		if not flying then
			return
		end
		char = plr.Character
		hum = getHumanoid(char)
		root = getRoot(char)
		if not (char and hum and root and hum.Health > 0) then
			disableFlight()
			return
		end
		if not (lv and lv.Parent == root) then
			lv, ao = makeMovers(root)
		end

		local cam = getCamera()
		if not cam then
			return
		end

		local direction = getMoveVector()
		local vel = Vector3.zero
		local look = cam.CFrame.LookVector
		local right = cam.CFrame.RightVector

		if direction.Magnitude > 0.01 then
			vel = vel + right * (direction.X * flySpeed)
			vel = vel - look * (direction.Z * flySpeed)
		end
		if vel.Magnitude > flySpeed * 1.5 then
			vel = vel.Unit * (flySpeed * 1.5)
		end

		setVelocity(root, lv, vel)
		if ao and ao.Parent then
			pcall(function()
				ao.CFrame = cam.CFrame
			end)
		end
		hum.PlatformStand = true
	end)
end

rs.Stepped:Connect(function()
	if noclipEnabled and plr.Character then
		for _, part in ipairs(plr.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				if originalCollisions[part] == nil then
					originalCollisions[part] = part.CanCollide
				end
				part.CanCollide = false
			end
		end
	end
end)

NoclipButton.MouseButton1Click:Connect(function()
	noclipEnabled = not noclipEnabled
	if noclipEnabled then
		NoclipButton.Text = "穿墙: 开启"
		NoclipButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	else
		NoclipButton.Text = "穿墙: 关闭"
		NoclipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		for part, originalState in pairs(originalCollisions) do
			if part and part.Parent then
				part.CanCollide = originalState
			end
		end
		table.clear(originalCollisions)
	end
end)

ToggleButton.MouseButton1Click:Connect(function()
	if flying then
		disableFlight()
	else
		enableFlight()
	end
end)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then
		return
	end
	local k = input.KeyCode
	if k == Enum.KeyCode.W then
		keys.W = true
	elseif k == Enum.KeyCode.A then
		keys.A = true
	elseif k == Enum.KeyCode.S then
		keys.S = true
	elseif k == Enum.KeyCode.D then
		keys.D = true
	end
end)

UserInputService.InputEnded:Connect(function(input)
	local k = input.KeyCode
	if k == Enum.KeyCode.W then
		keys.W = false
	elseif k == Enum.KeyCode.A then
		keys.A = false
	elseif k == Enum.KeyCode.S then
		keys.S = false
	elseif k == Enum.KeyCode.D then
		keys.D = false
	end
end)

plr.CharacterAdded:Connect(function()
	if flying then
		disableFlight()
	end
	table.clear(originalCollisions)
end)

local sliding = false
local function updateSlider(input)
	if sliding then
		local sliderAbsolutePosition = SliderBar.AbsolutePosition
		local sliderAbsoluteSize = SliderBar.AbsoluteSize
		local touchPosition = (input.UserInputType == Enum.UserInputType.Touch) and input.Position or UserInputService:GetMouseLocation()
		local relativeX = math.clamp((touchPosition.X - sliderAbsolutePosition.X) / sliderAbsoluteSize.X, 0, 1)
		SliderButton.Position = UDim2.new(relativeX, -10, 0.5, -10)
		SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
		flySpeed = math.floor(minSpeed + (maxSpeed - minSpeed) * relativeX)
		SpeedText.Text = "速度: " .. flySpeed
	end
end

SliderButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		sliding = true
	end
end)
SliderBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		sliding = true
		updateSlider(input)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		sliding = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if sliding and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		updateSlider(input)
	end
end)
