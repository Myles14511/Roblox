-- Fly Exploit Test Script (for Anti-Cheat Testing)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Create GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TestFlightGUI"
gui.ResetOnSpawn = false
pcall(function()
	gui.Parent = game.CoreGui
end)

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0, 10, 0.8, 0)
button.Text = "Toggle Fly"
button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
button.TextColor3 = Color3.new(1, 1, 1)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 20
button.Parent = gui

-- Flight Logic
local flying = false
local bv, bg

local function startFlying()
	humanoid.PlatformStand = true

	bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.zero
	bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.CFrame = hrp.CFrame
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.Parent = hrp

	-- Basic flight loop
	task.spawn(function()
		while flying and bv and bg do
			bv.Velocity = hrp.CFrame.LookVector * 50 + Vector3.new(0, 2, 0)
			bg.CFrame = hrp.CFrame
			task.wait()
		end
	end)
end

local function stopFlying()
	humanoid.PlatformStand = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

-- Toggle flying with button
button.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFlying()
	else
		stopFlying()
	end
end)
