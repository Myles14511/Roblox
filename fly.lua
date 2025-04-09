local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local userInputService = game:GetService("UserInputService")

local flying = false
local speedHackEnabled = false
local flightSpeed = 50  -- Flight speed multiplier
local speedMultiplier = 10  -- Speed multiplier for speed hack
local originalWalkSpeed = humanoid.WalkSpeed

-- Function to toggle flying
local function toggleFlying()
    flying = not flying
    if flying then
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    else
        humanoid.PlatformStand = false
        humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end

-- Function to activate speed hack
local function enableSpeedHack()
    speedHackEnabled = true
    humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier  -- Increase walk speed
end

local function disableSpeedHack()
    speedHackEnabled = false
    humanoid.WalkSpeed = originalWalkSpeed  -- Reset to normal walk speed
end

-- Function to simulate flight
local function fly()
    while flying do
        -- Basic flying movement using screen touch direction
        local direction = Vector3.new(0, 0, 0)

        -- Check for swipe or touch movement
        local touch = userInputService.TouchEnabled
        if touch then
            local touches = userInputService:GetTouches()
            for _, touch in ipairs(touches) do
                -- Simple touch-based directional movement (e.g., swipe up or down for flying)
                local touchPosition = touch.Position
                if touchPosition.Y > 200 then  -- Swipe up to fly
                    direction = Vector3.new(0, 1, 0)  -- Move up
                elseif touchPosition.Y < 100 then  -- Swipe down to move down
                    direction = Vector3.new(0, -1, 0)  -- Move down
                end
            end
        end

        -- Apply flying velocity
        character.HumanoidRootPart.Velocity = direction * flightSpeed
        wait(0.1)
    end
end

-- Listen for touch input to toggle flying and speed hack
local function onTouchInput(input)
    -- Handle speed hack toggle (double tap for speed hack)
    if input.UserInputType == Enum.UserInputType.Touch then
        if input.UserInputState == Enum.UserInputState.Begin then
            -- Example: Use double tap for speed hack toggle
            if speedHackEnabled then
                disableSpeedHack()
            else
                enableSpeedHack()
            end
        end
    end
end

-- Add event listener for touch input
userInputService.InputBegan:Connect(onTouchInput)

-- Listen for mobile swipe gestures to toggle flying (or a specific swipe action)
local swipeThreshold = 50  -- Adjust this for swipe sensitivity
local lastSwipePosition = nil

userInputService.TouchMoved:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        if lastSwipePosition then
            local swipeDistance = (input.Position - lastSwipePosition).Magnitude
            if swipeDistance > swipeThreshold then
                toggleFlying()  -- Toggle flying if the swipe exceeds the threshold
            end
        end
        lastSwipePosition = input.Position
    end
end)
