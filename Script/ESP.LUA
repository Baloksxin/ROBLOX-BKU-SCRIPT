local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PlayerESP"
ScreenGui.Parent = PlayerGui

local ESPContainer = Instance.new("Frame")
ESPContainer.Name = "ESPContainer"
ESPContainer.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ESPContainer.BackgroundTransparency = 0.7
ESPContainer.BorderSizePixel = 0
ESPContainer.Position = UDim2.new(0, 0, 0, 0)
ESPContainer.Size = UDim2.new(1, 0, 1, 0)
ESPContainer.Parent = ScreenGui

local espLabels = {}

local function updateESP()
	if ESP_LOCKED then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer and player.Character then
			local head = player.Character:FindFirstChild("Head")
			if head then
				local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local label = espLabels[player]
					if not label then
						label = Instance.new("TextLabel")
						label.Name = "ESPLabel"
						label.BackgroundTransparency = 1
						label.TextColor3 = Color3.fromRGB(255, 0, 0)
						label.TextScaled = true
						label.Font = Enum.Font.SourceSansBold
						label.Size = UDim2.new(0, 100, 0, 20)
						label.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - 10)
						label.Parent = ESPContainer
						espLabels[player] = label
					else
						label.Position = UDim2.new(0, screenPos.X - 50, 0, screenPos.Y - 10)
						label.Visible = true
					end
					local distance = (head.Position - Camera.CFrame.Position).Magnitude
					label.Text = player.Name .. "\n" .. math.floor(distance) .. " br"
				else
					if espLabels[player] then
						espLabels[player].Visible = false
					end
				end
			else
				if espLabels[player] then
					espLabels[player].Visible = false
				end
			end
		end
	end
end

local function onPlayerAdded(player)
	if player == Players.LocalPlayer then return end
end

local function onPlayerRemoving(player)
	if espLabels[player] then
		espLabels[player]:Destroy()
		espLabels[player] = nil
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Players.LocalPlayer then
		onPlayerAdded(player)
	end
end

RunService.RenderStepped:Connect(function()
	updateESP()
end)
