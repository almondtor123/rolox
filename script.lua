local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local flyspeed = 50

local UserInputService = game:GetService("UserInputService")

local player = game:GetService("Players").LocalPlayer
local playergui = player.PlayerGui
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local camera = Workspace.CurrentCamera

local speed = playergui:WaitForChild("BikeGui").Main.Meters.MainFrame.Speed

local Window = Rayfield:CreateWindow({
    Name = "My Bike Life",
    LoadingTitle = "BIKES!",
    LoadingSubtitle = "by SOMEONE🤐",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "bike life"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false,
    KeySettings = {
        Title = "Untitled",
        Subtitle = "Key System",
        Note = "No method of obtaining the key is provided",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Hello"}
    }
})

local Tab = Window:CreateTab("Misc", nil)
local Section = Tab:CreateSection("Ramps")

local isChecking = false
local isInAir = false
local freePointsEnabled = false

local Toggle = Tab:CreateToggle({
    Name = "Full Blast Ramps(without stunt park)",
    CurrentValue = false,
    Flag = "Toggle1",
    Callback = function(Value)
        isChecking = Value
        while isChecking do
            for _, v in pairs(Workspace.Game.Ramps:GetChildren()) do
                if v.Name == "Ramp" then
                    -- Perform the desired action for ramps
                else
                    local speedPad = v:FindFirstChild("Speed Pad")
                    if speedPad then
                        speedPad:SetAttribute("Boost", 700)
                    end
                end
            end
            wait(2)
        end
    end,
})

local Button = Tab:CreateButton({
    Name = "Car Fly(buggy)",
    Callback = function()
        Rayfield:Notify({
            Title = "Please notice",
            Content = "if you crash or you jump of the bike you need to repress the fly button!, to toggle the fly press F",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })

        local flying = false
        local part = game:GetService("Workspace").Characters:WaitForChild(player.Name)
        local originalCFrame

        local function startFlying()

            local bodyGyro = Instance.new("BodyGyro")
            bodyGyro.P = 9e4
            bodyGyro.maxTorque = Vector3.new(9e4, 9e4, 9e4)
            bodyGyro.cframe = part.CFrame
            bodyGyro.Parent = part

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.velocity = Vector3.new(0, 0, 0)
            bodyVelocity.maxForce = Vector3.new(9e4, 9e4, 9e4)
            bodyVelocity.Parent = part

            flying = true

            RunService.RenderStepped:Connect(function()
                if flying then
                    local direction = Vector3.new(0, 0, 0)
                    local lookVector = camera.CFrame.LookVector

                    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + (lookVector * flyspeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - (lookVector * flyspeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - (camera.CFrame.RightVector * flyspeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + (camera.CFrame.RightVector * flyspeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.E) then
                        direction = direction + (camera.CFrame.UpVector * flyspeed)
                    end
                    if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
                        direction = direction - (camera.CFrame.UpVector * flyspeed)
                    end

                    bodyVelocity.velocity = direction
                    bodyGyro.cframe = CFrame.new(part.Position, part.Position + lookVector)
                end
            end)
        end

        local function stopFlying()
            flying = false
            for _, child in pairs(part:GetChildren()) do
                if child:IsA("BodyGyro") or child:IsA("BodyVelocity") then
                    child:Destroy()
                end
            end
        end

        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.F then
                if flying then
                    stopFlying()
                else
                    startFlying()
                end
            end
        end)
    end,
})

local Slider = Tab:CreateSlider({
   Name = "Fly speed",
   Range = {0, 250},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "Slider1",
   Callback = function(Value)
       flyspeed = Value
   end,
})

local Button = Tab:CreateButton({
    Name = "Free Points",
    Callback = function()
        Rayfield:Notify({
            Title = "Please notice",
            Content = "to toggle the free points press R, please wait so your MPH is on 000 then it will work",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })

        Rayfield:Notify({
            Title = "Please notice",
            Content = "and when you press R to disable dont touch anything for 5 to 10 sec",
            Duration = 6.5,
            Image = 4483362458,
            Actions = {
                Ignore = {
                    Name = "Okay!",
                    Callback = function()
                        print("The user tapped Okay!")
                    end
                },
            },
        })

        local freePointsEnabled = false
        local part = game:GetService("Workspace").Characters:WaitForChild(player.Name)
        local speedLabel = playergui:WaitForChild("BikeGui").Main.Meters.MainFrame.Speed

        local initialYOffset = 10
        local highYOffset = 20

        local vectorForce = part:WaitForChild("VectorForce")
        local receiveInput = vectorForce:WaitForChild("ReceiveInput")
        local grounded = vectorForce:FindFirstChild("Grounded")

        local checkedOnce = false
        local originalCFrame

        local rotationSpeed = 60 -- Adjust the speed of rotation (degrees per second)

        -- Function to set part's position
        local function setPartYPosition(yOffset)
            while freePointsEnabled do
                local currentCFrame = part.CFrame
                part.CFrame = CFrame.new(currentCFrame.Position.X, currentCFrame.Position.Y + yOffset, currentCFrame.Position.Z)
                if part.CFrame.Position.Y >= 2500 then
                    part.CFrame = CFrame.new(currentCFrame.Position.X, currentCFrame.Position.Y - 100, currentCFrame.Position.Z)
                end
                wait(1)
            end
        end


        -- Function to spin the part
        local function spinPart()
            while freePointsEnabled do
                local randomDirection = Vector3.new(math.random(), math.random(), math.random()).Unit
                local rotationIncrement = randomDirection * rotationSpeed
                -- Apply the rotation
                part.CFrame = part.CFrame * CFrame.Angles(math.rad(rotationIncrement.X), math.rad(rotationIncrement.Y), math.rad(rotationIncrement.Z))
                
                -- Wait for the next frame
                wait()
            end
        end

        -- Function to check the speed
        local function checkForSpeed()
            if speedLabel.Text == "000" then
                checkedOnce = true
                originalCFrame = part.CFrame
            end
        end

        local function toggleFreePoints()
            freePointsEnabled = not freePointsEnabled
            checkedOnce = false

            if freePointsEnabled then
                -- Save the original CFrame when enabling free points
                originalCFrame = part.CFrame

                -- When button is toggled on
                coroutine.wrap(function()
                    while freePointsEnabled do
                        if not checkedOnce then
                            checkForSpeed()
                        end
                        if checkedOnce then
                            setPartYPosition(highYOffset)
                        end
                        wait(1)
                    end
                end)()

                coroutine.wrap(function()
                    spinPart()
                end)()
            else
                -- When button is toggled off, restore the original CFrame
                if originalCFrame then
                    part.CFrame = originalCFrame
                end
            end
        end

        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.R then
                toggleFreePoints()
            end
        end)
    end,
})
