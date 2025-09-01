local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local oldGui = CoreGui:FindFirstChild("PlayerokKeyGui")
if oldGui then oldGui:Destroy() end

local keysURL = "https://raw.githubusercontent.com/RobloxScriptKey/MilediKeys-/main/MILEDI-keys.json"
local success, response = pcall(function() return game:HttpGet(keysURL) end)
local keys = {}
if success then keys = HttpService:JSONDecode(response) end

local today = os.date("%Y-%m-%d")
local todayKeyTable = keys[today]
local validKey = nil
if todayKeyTable then
    validKey = ""
    for _, v in ipairs(todayKeyTable) do
        validKey = validKey .. string.char(v)
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "PlayerokKeyGui"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.4, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 140, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 220, 255))
}
grad.Rotation = 45

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0, 36)
box.Position = UDim2.new(0.1, 0, 0, 110)
box.Font = Enum.Font.Gotham
box.TextSize = 20
box.TextColor3 = Color3.fromRGB(50, 50, 50)
box.BackgroundColor3 = Color3.fromRGB(230, 230, 255)
box.Text = ""
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0, 160)
button.BackgroundColor3 = Color3.fromRGB(160, 200, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(30, 30, 30)
button.Text = ""
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

local getKeyButton = Instance.new("TextButton", frame)
getKeyButton.Size = UDim2.new(0.8, 0, 0, 40)
getKeyButton.Position = UDim2.new(0.1, 0, 0, 210)
getKeyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextSize = 20
getKeyButton.TextColor3 = Color3.fromRGB(30, 30, 30)
getKeyButton.Text = ""
Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 12)

local feedback = Instance.new("TextLabel", frame)
feedback.Size = UDim2.new(1, 0, 0, 20)
feedback.Position = UDim2.new(0, 0, 0, 145)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.TextColor3 = Color3.new(1, 1, 1)
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 18

local progressBackground = Instance.new("Frame", frame)
progressBackground.Size = UDim2.new(0.8, 0, 0, 20)
progressBackground.Position = UDim2.new(0.1, 0, 0, 260)
progressBackground.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
Instance.new("UICorner", progressBackground).CornerRadius = UDim.new(0, 10)

local progressBar = Instance.new("Frame", progressBackground)
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 10)

local function tweenIn(instance, duration, targetSize)
    TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end
tweenIn(frame, 0.5, UDim2.new(0, 400, 0, 320))

local function pulseButton(btn)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    TweenService:Create(btn, tweenInfo, {Size = UDim2.new(0.82, 0, 0, 42)}):Play()
end
pulseButton(button)
pulseButton(getKeyButton)

button.MouseButton1Click:Connect(function()
    local input = box.Text:match("^%s*(.-)%s*$")
    if not validKey then
        feedback.Text = ""
        feedback.TextColor3 = Color3.fromRGB(255, 170, 0)
    elseif input == validKey then
        feedback.Text = ""
        feedback.TextColor3 = Color3.fromRGB(30, 200, 30)

        local duration = 2
        local startTime = tick()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local pct = math.clamp(elapsed / duration, 0, 1)
            progressBar.Size = UDim2.new(pct, 0, 1, 0)
            if pct >= 1 then
                conn:Disconnect()
                gui:Destroy()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/Kurdhub"))()
            end
        end)
    else
        feedback.Text = ""
        feedback.TextColor3 = Color3.fromRGB(200, 40, 40)
    end
end)

getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://playerok.com/profile/MILEDI-STORE/products")
    feedback.Text = ""
    feedback.TextColor3 = Color3.fromRGB(30, 200, 30)
end)
