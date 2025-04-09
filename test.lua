-- LocalScript to simulate flying on mobile (with UI button to toggle)
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 50  -- Speed of flying (adjustable)
local maxHeight = 200  -- Maximum height the player can fly
local minHeight = 10   -- Minimum height (keep from going too low)
local bodyVelocity = nil
local bodyGyro = nil
local flightHeight = 10  -- Height above the ground for flying

-- Create the UI button for mobile
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyingUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 200, 0, 50)
flyButton.Position = UDim2.new(0.5, -100, 0.9, -25)  -- Centered at bottom of screen
flyButton.Text = "Toggle Flight"
flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)  -- Green button
flyButton.Parent = screenGui

-- Show the button only if it's a mobile device
if game:GetService("UserInputService").TouchEnabled then
    screenGui.Enabled = true
else
    screenGui.Enabled = false
end

-- Toggle flying with the UI button
local function toggleFlying()
    flying = not flying
    if flying then
        humanoid.PlatformStand = true  -- Disable normal humanoid controls
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)

        -- Create BodyVelocity and BodyGyro for smooth flight
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)  -- High force to allow flying
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)  -- Start velocity
        bodyVelocity.Parent = humanoidRootPart

        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(400000, 400000, 400000)  -- Prevents tilting during flight
        bodyGyro.CFrame = humanoidRootPart.CFrame
        bodyGyro.Parent = humanoidRootPart
    else
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)

        -- Remove BodyVelocity and BodyGyro when flying is turned off
        if bodyVelocity then bodyVelocity:Destroy() end
        if bodyGyro then bodyGyro:Destroy() end
    end
end

-- Update the flying movement
local function updateFlying()
    while flying do
        -- Capture movement via touch (you can make this more complex if needed)
        local direction = Vector3.new(0, 0, 0)

        -- Forward/Backward movement (using simulated touch controls)
        if game:GetService("UserInputService"):IsTouching(Enum.UserInputType.Touch) then
            -- Here you can set up touch detection for movement
            -- For simplicity, I'm using a fixed direction (can improve with custom touch controls)
            direction = humanoidRootPart.CFrame.LookVector
        end

        -- Prevent the player from flying above maxHeight or below minHeight
        if humanoidRootPart.Position.Y > maxHeight then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame - Vector3.new(0, 5, 0)  -- Lower the player
        elseif humanoidRootPart.Position.Y < minHeight then
            humanoidRootPart.CFrame = humanoidRootPart.CFrame + Vector3.new(0, 5, 0)  -- Raise the player
        end

        -- Apply the velocity
        bodyVelocity.Velocity = direction * speed
        wait(0.1)
    end
end

-- Connect button click to flying toggle
flyButton.MouseButton1Click:Connect(function()
    toggleFlying()
    if flying then
        updateFlying()
    end
end)
