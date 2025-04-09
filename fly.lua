-- Mobile Flight and Speed Hack GUI (for testing)

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- Create GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CheatGUI"

local flyButton = Instance.new("TextButton", gui)
flyButton.Size = UDim2.new(0, 120, 0, 40)
flyButton.Position = UDim2.new(0, 10, 0.8, 0)
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)

local speedButton = Instance.new("TextButton", gui)
speedButton.Size = UDim2.new(0, 120, 0, 40)
speedButton.Position = UDim2.new(0, 10, 0.9, 0)
speedButton.Text = "Speed Hack"
speedButton.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
speedButton.TextColor3 = Color3.new(1, 1, 1)

-- Flight system
local flying = false
local flightVelocity
local bodyGyro
local flightSpeed = 50

flyButton.MouseButton1Click:Connect(function()
    flying = not flying

    if flying then
        humanoid.PlatformStand = true

        flightVelocity = Instance.new("BodyVelocity")
        flightVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        flightVelocity.Velocity = Vector3.new(0, 0, 0)
        flightVelocity.Parent = hrp

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bodyGyro.CFrame = hrp.CFrame
        bodyGyro.Parent = hrp

        -- Flight loop
        task.spawn(function()
            while flying do
                flightVelocity.Velocity = hrp.CFrame.LookVector * flightSpeed + Vector3.new(0, 2, 0)
                bodyGyro.CFrame = hrp.CFrame
                task.wait()
            end
        end)
    else
        humanoid.PlatformStand = false
        if flightVelocity then flightVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end)

-- Speed hack system
local speedOn = false
local defaultSpeed = humanoid.WalkSpeed
local boostedSpeed = 100

speedButton.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if speedOn then
        humanoid.WalkSpeed = boostedSpeed
    else
        humanoid.WalkSpeed = defaultSpeed
    end
end)
