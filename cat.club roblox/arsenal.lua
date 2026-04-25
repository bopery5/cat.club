-- setting up folders
if not isfolder("cat.club") then
    makefolder("cat.club")
end

-- fetching library
local library = loadstring(game:HttpGet("https://pastebin.com/raw/tDKTswd7"))()

print("Loaded UI library, proceeding with loading script.")

local getservice = function(name)
    return cloneref and cloneref(game[name]) or game[name]
end

local rs = getservice("Run Service")
local uis = getservice("UserInputService")

local camera = workspace.CurrentCamera

local thirdp = false

local msg = "cat.club: idle.."

-- textlabel setup
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

rs.Heartbeat:Connect(function(dt)
    camera.FieldOfView = 120
    workspace.FallenPartsDestroyHeight = 0/0

    if thirdp then
        game:GetService("Players").LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end

    if library.toggled then
        uis.MouseBehavior = Enum.MouseBehavior.Default
        uis.MouseIconEnabled = true
    end

    mainmsg.Text = msg
    mainmsg.Visible = msg ~= ""
end)

uis.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        library:Toggle()
    end
end)

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    camera.FieldOfView = 120
end)

local window = library:New({
    name = "cat.club",
    accent = Color3.fromHex("#B88A6A"),
    outline = { Color3.fromHex("#E8C2A6"), Color3.fromHex("#A8745A") },
    sizeX = 450,
    sizeY = 550
})

library:Initialize()

-- ts is useless btw cuz i wont be making this