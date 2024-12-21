local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 200)
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(240, 240, 240)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
frame.Parent = screenGui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
titleBar.Parent = frame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Text = "NDPL_real Small GUI"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 24
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = titleBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 40, 0, 40)
minimizeButton.Position = UDim2.new(1, -40, 0, 0)
minimizeButton.Text = "_"
minimizeButton.TextSize = 24
minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
minimizeButton.Parent = titleBar

local button1 = Instance.new("TextButton")
button1.Size = UDim2.new(0, 200, 0, 50)
button1.Position = UDim2.new(0.5, -100, 0.25, -25)
button1.Text = "Fly"
button1.TextSize = 24
button1.Parent = frame

local button2 = Instance.new("TextButton")
button2.Size = UDim2.new(0, 200, 0, 50)
button2.Position = UDim2.new(0.5, -100, 0.75, -25)
button2.Text = "Un"
button2.TextSize = 24
button2.Parent = frame

local flying = false
local speed = 0
local maxspeed = 50
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local bg, bv
local plr = game.Players.LocalPlayer
local mouse = plr:GetMouse()

function Fly()
	game.StarterGui:SetCore("SendNotification", {Title = "Fly Activated"; Text = "NDPL_real on yt"; Duration = 3;})

	local torso = plr.Character:WaitForChild("HumanoidRootPart")
	bg = Instance.new("BodyGyro", torso)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.CFrame = torso.CFrame

	bv = Instance.new("BodyVelocity", torso)
	bv.Velocity = Vector3.new(0, 0.1, 0)
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	repeat
		wait()
		plr.Character.Humanoid.PlatformStand = true

		if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
			speed = speed + 0.5 + (speed / maxspeed)
			if speed > maxspeed then
				speed = maxspeed
			end
		elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
			speed = speed - 1
			if speed < 0 then
				speed = 0
			end
		end

		if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
			bv.Velocity = ((game.Workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) + 
				((game.Workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).p) - 
					game.Workspace.CurrentCamera.CFrame.p)) * speed
			lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
		elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
			bv.Velocity = ((game.Workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + 
				((game.Workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).p) - 
					game.Workspace.CurrentCamera.CFrame.p)) * speed
		else
			bv.Velocity = Vector3.new(0, 0.1, 0)
		end

		bg.CFrame = game.Workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)

	until not flying

	ctrl = {f = 0, b = 0, l = 0, r = 0}
	lastctrl = {f = 0, b = 0, l = 0, r = 0}
	speed = 0
	bg:Destroy()
	bg = nil
	bv:Destroy()
	bv = nil
	plr.Character.Humanoid.PlatformStand = false
	game.StarterGui:SetCore("SendNotification", {Title = "Fly deactivated"; Text = "FLYSCRIPT BY NDPL_real on YT"; Duration = 3;})
end

mouse.KeyDown:Connect(function(key)
	if key:lower() == "e" then
		if flying then
			flying = false
		else
			flying = true
			Fly()
		end
	elseif key:lower() == "w" then
		ctrl.f = 1
	elseif key:lower() == "s" then
		ctrl.b = -1
	elseif key:lower() == "a" then
		ctrl.l = -1
	elseif key:lower() == "d" then
		ctrl.r = 1
	end
end)

mouse.KeyUp:Connect(function(key)
	if key:lower() == "w" then
		ctrl.f = 0
	elseif key:lower() == "s" then
		ctrl.b = 0
	elseif key:lower() == "a" then
		ctrl.l = 0
	elseif key:lower() == "d" then
		ctrl.r = 0
	end
end)

local function function2()
	print("Function 2 is running!")
end

button1.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		Fly()
	else
		bg:Destroy()
		bv:Destroy()
	end
end)

button2.MouseButton1Click:Connect(function()
	function2()
end)

local dragging = false
local dragStart = nil
local startPosition = nil

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPosition = frame.Position
		input.Consumed = true
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
end)

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
	if not isMinimized then
		frame.Size = UDim2.new(0, 400, 0, 40)
		frame.Position = UDim2.new(0.5, -200, 0.5, -20)
		button1.Visible = false
		button2.Visible = false
		isMinimized = true
	else
		frame.Size = UDim2.new(0, 400, 0, 200)
		frame.Position = UDim2.new(0.5, -200, 0.5, -100)
		button1.Visible = true
		button2.Visible = true
		isMinimized = false
	end
end)
