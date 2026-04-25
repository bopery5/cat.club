local getservice = function(name)
    return cloneref and cloneref(game[name]) or game[name]
end

local rs = getservice("Run Service")
local uis = getservice("UserInputService")

local camera = workspace.CurrentCamera

local enabled = true
local msg = "voidspam: idle.."

local screenGui = Instance.new("ScreenGui")
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")
screenGui.DisplayOrder = 2147483647

local mainmsg = Instance.new("TextLabel")
mainmsg.BackgroundTransparency = 1
mainmsg.TextColor3 = Color3.new(1, 1, 1)
mainmsg.TextStrokeTransparency = 0
mainmsg.Font = Enum.Font.RobotoMono
mainmsg.TextSize = 17
mainmsg.AnchorPoint = Vector2.new(0.5, 0.5)
mainmsg.Position = UDim2.new(0.5, 0, 0.5, 0)
mainmsg.Size = UDim2.new(1, 0, 0, 20)
mainmsg.Parent = screenGui

local statusMsg = Instance.new("TextLabel")
statusMsg.BackgroundTransparency = 1
statusMsg.TextColor3 = Color3.new(0, 1, 0)
statusMsg.TextStrokeTransparency = 0
statusMsg.Font = Enum.Font.RobotoMono
statusMsg.TextSize = 14
statusMsg.AnchorPoint = Vector2.new(0.5, 0.5)
statusMsg.Position = UDim2.new(0.5, 0, 0.6, 0)
statusMsg.Size = UDim2.new(1, 0, 0, 20)
statusMsg.Parent = screenGui
statusMsg.Text = "[ENABLED] PRESS LALT TO TOGGLE"

rs.Heartbeat:Connect(function(dt)
    camera.FieldOfView = 120
    workspace.FallenPartsDestroyHeight = 0/0
    game:GetService("Players").LocalPlayer.CameraMode = Enum.CameraMode.Classic

    mainmsg.Text = msg
    mainmsg.Visible = msg ~= ""
end)

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local Animations = {
    ["L"] = "rbxassetid://81809682819287",
    ["Yung Blud"] = "http://www.roblox.com/asset/?id=15609995579",
    ["Poop"] = "rbxassetid://76580366945676",
    ["Tornado"] = "rbxassetid://135373056067761",
    ["Biblically Accurate Emote"] = "rbxassetid://86806707642727",
    ["Pumpkin King"] = "rbxassetid://98413544617717",
    ["Michal Myers"] = "rbxassetid://71619636299185",
    ["Fish"] = "rbxassetid://116819742540173",
    ["Human Gun"] = "rbxassetid://73049499124836",
    ["UFO"] = "rbxassetid://90090882315052",
    ["Jumper"] = "rbxassetid://113923275362771",
    ["Solar System"] = "rbxassetid://89393294638590"
}

local chosenId = Animations["Tornado"]

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local anim = Instance.new("Animation")
anim.AnimationId = chosenId

local track = humanoid:LoadAnimation(anim)

local function stopAnim()
    if track then
        pcall(function() track:Stop() end)
    end
end

local function startAnim()
    if track then
        pcall(function() track:Play() end)
        pcall(function() track:AdjustSpeed(100) end)
    end
end

track.Priority = Enum.AnimationPriority.Action4
track.Looped = true
startAnim()

local players = getservice("Players")
local char = players.LocalPlayer.Character

local function getMyColor()
    return char and char:GetAttribute("TeamColor")
end

players.LocalPlayer.CharacterAdded:Connect(function(newchar)
    char = newchar
    task.wait(0.5)
    if enabled then
        startAnim()
    end
end)

local voidpos = Vector3.new(-9999, -9999, -9999)
local centerPos = Vector3.new(0, 500, 0)
local lastSpam = 0

local function getClosestEnemyToCenter()
    local closest = nil
    local closestDist = math.huge
    local myColor = getMyColor()
    
    for _, plr in ipairs(players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local theirColor = plr.Character:GetAttribute("TeamColor")
            if theirColor and myColor and theirColor ~= myColor then
                local plrPos = plr.Character:GetPivot().Position
                local dist = (centerPos - plrPos).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closest = plr
                end
            end
        end
    end
    
    return closest, closestDist
end

local function mouse1click()
    pcall(function() 
        local VirtualInput = game:GetService("VirtualUser")
        VirtualInput:ClickButton1(Vector2.new(0,0))
    end)
end

uis.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.LeftAlt then
        enabled = not enabled
        if enabled then
            statusMsg.Text = "[ENABLED] PRESS LALT TO TOGGLE"
            statusMsg.TextColor3 = Color3.new(0, 1, 0)
            msg = "voidspam: enabled"
            startAnim()
            task.wait(0.5)
            msg = "voidspam: idle.."
        else
            statusMsg.Text = "[DISABLED] PRESS LALT TO TOGGLE"
            statusMsg.TextColor3 = Color3.new(1, 0, 0)
            msg = "voidspam: disabled"
            stopAnim()
            task.wait(0.5)
            msg = "voidspam: idle.."
        end
    end
end)

rs.RenderStepped:Connect(function(dt)
    if not enabled then return end
    if not char or not char.Parent then return end
    
    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.AutoRotate = false
    end
    
    local enemy, dist = getClosestEnemyToCenter()
    
    if not enemy then
        char:PivotTo(CFrame.new(voidpos))
        msg = "voidspam: void"
    else
        msg = "voidspam: attacking " .. enemy.Name .. " (distance: " .. math.floor(dist) .. ")"
        char:PivotTo(enemy.Character:GetPivot() + Vector3.new(0, -5, 0) - enemy.Character:GetPivot().lookVector * 3)
        camera.CameraType = Enum.CameraType.Custom
        camera.CFrame = CFrame.lookAt(
            enemy.Character:GetPivot().Position - enemy.Character:GetPivot().LookVector * 3 + Vector3.new(0, 2, 0),
            enemy.Character.Head.Position
        )
        
        local now = tick()
        if now - lastSpam > 0.05 then
            mouse1click()
            lastSpam = now
        end
    end
end)