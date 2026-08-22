local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local CoreGui=game:GetService("CoreGui")
local LPlr=Players.LocalPlayer
local antiSlipperyEnabled=false
local antiSlipperyConnection=nil
local function antiSlippery()
local char=LPlr.Character
if not char then return end
local humanoid=char:FindFirstChildOfClass("Humanoid")
local rootPart=char:FindFirstChild("HumanoidRootPart")
if not humanoid or not rootPart then return end
if humanoid.Health<=0 then return end
local currentVel=rootPart.AssemblyLinearVelocity
local moveDir=humanoid.MoveDirection
local walkSpeed=humanoid.WalkSpeed
if walkSpeed<=0 or walkSpeed>200 then return end
if moveDir.Magnitude<0.05 then
if math.abs(currentVel.X)>0.01 or math.abs(currentVel.Z)>0.01 then
rootPart.AssemblyLinearVelocity=Vector3.new(0,currentVel.Y,0)
end
else
local targetHorizontal=moveDir.Unit*walkSpeed
rootPart.AssemblyLinearVelocity=Vector3.new(targetHorizontal.X,currentVel.Y,targetHorizontal.Z)
end
end
local function enableAntiSlippery()
if antiSlipperyEnabled then return end
if not LPlr.Character or not LPlr.Character:FindFirstChild("HumanoidRootPart") then
task.wait(0.5)
end
antiSlipperyConnection=RunService.Heartbeat:Connect(antiSlippery)
antiSlipperyEnabled=true
if type(_G.updateUI)=="function" then _G.updateUI() end
end
local function disableAntiSlippery()
if not antiSlipperyEnabled then return end
if antiSlipperyConnection then
antiSlipperyConnection:Disconnect()
antiSlipperyConnection=nil
end
antiSlipperyEnabled=false
if type(_G.updateUI)=="function" then _G.updateUI() end
end
LPlr.CharacterAdded:Connect(function()
if antiSlipperyEnabled then
if antiSlipperyConnection then
antiSlipperyConnection:Disconnect()
antiSlipperyConnection=nil
end
task.wait(0.5)
antiSlipperyConnection=RunService.Heartbeat:Connect(antiSlippery)
if type(_G.updateUI)=="function" then _G.updateUI() end
end
end)
local function createUI()
local oldGui=CoreGui:FindFirstChild("AntiSlipperyUI")
if oldGui then oldGui:Destroy() end
local screenGui=Instance.new("ScreenGui")
screenGui.Name="AntiSlipperyUI"
screenGui.ResetOnSpawn=false
pcall(function()
screenGui.Parent=CoreGui
end)
if not screenGui.Parent then
screenGui.Parent=LPlr:WaitForChild("PlayerGui")
end
local mainFrame=Instance.new("Frame")
mainFrame.Name="MainFrame"
mainFrame.Size=UDim2.new(0,200,0,80)
mainFrame.Position=UDim2.new(0,20,0,20)
mainFrame.BackgroundColor3=Color3.fromRGB(40,40,40)
mainFrame.BackgroundTransparency=0.15
mainFrame.BorderSizePixel=1
mainFrame.BorderColor3=Color3.fromRGB(100,100,100)
mainFrame.Active=true
mainFrame.Draggable=false
mainFrame.Parent=screenGui
local titleBar=Instance.new("Frame")
titleBar.Name="TitleBar"
titleBar.Size=UDim2.new(1,0,0,30)
titleBar.BackgroundColor3=Color3.fromRGB(60,60,60)
titleBar.BorderSizePixel=0
titleBar.Parent=mainFrame
local titleLabel=Instance.new("TextLabel")
titleLabel.Size=UDim2.new(1,0,1,0)
titleLabel.BackgroundTransparency=1
titleLabel.Text="防脚滑"
titleLabel.TextColor3=Color3.fromRGB(255,255,255)
titleLabel.TextSize=16
titleLabel.Font=Enum.Font.SourceSansBold
titleLabel.TextXAlignment=Enum.TextXAlignment.Center
titleLabel.Parent=titleBar
local toggleButton=Instance.new("TextButton")
toggleButton.Name="ToggleButton"
toggleButton.Size=UDim2.new(0,120,0,36)
toggleButton.Position=UDim2.new(0.5,-60,0,42)
toggleButton.BackgroundColor3=Color3.fromRGB(150,0,0)
toggleButton.TextColor3=Color3.fromRGB(255,255,255)
toggleButton.TextSize=18
toggleButton.Font=Enum.Font.SourceSansBold
toggleButton.Text="关"
toggleButton.BorderSizePixel=0
toggleButton.Parent=mainFrame
function _G.updateUI()
if antiSlipperyEnabled then
toggleButton.Text="开"
toggleButton.BackgroundColor3=Color3.fromRGB(0,150,0)
else
toggleButton.Text="关"
toggleButton.BackgroundColor3=Color3.fromRGB(150,0,0)
end
end
_G.updateUI()
toggleButton.Activated:Connect(function()
if antiSlipperyEnabled then
disableAntiSlippery()
else
enableAntiSlippery()
end
_G.updateUI()
end)
local dragging=false
local dragStartPos=nil
local frameStartPos=nil
local function onInputBegan(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=true
dragStartPos=input.Position
frameStartPos=mainFrame.Position
end
end
local function onInputEnded(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=false
end
end
local function onInputChanged(input)
if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
local delta=input.Position-dragStartPos
local newPos=UDim2.new(
frameStartPos.X.Scale,
frameStartPos.X.Offset+delta.X,
frameStartPos.Y.Scale,
frameStartPos.Y.Offset+delta.Y
)
mainFrame.Position=newPos
end
end
titleBar.InputBegan:Connect(onInputBegan)
titleBar.InputEnded:Connect(onInputEnded)
UserInputService.InputChanged:Connect(onInputChanged)
end
task.spawn(function()
repeat task.wait() until LPlr and LPlr:FindFirstChild("PlayerGui")
createUI()
end)
_G.EnableAntiSlippery=enableAntiSlippery
_G.DisableAntiSlippery=disableAntiSlippery
