-- [ By r7pha ]
-- [ Nigga ]

local repo = 'https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()
local Options = Library.Options
local Toggles = Library.Toggles

local plr = game.Players.LocalPlayer
local DmgEvent = game:GetService("ReplicatedStorage"):WaitForChild("ACS_Engine"):WaitForChild("Events"):WaitForChild("Damage")
local GranadeEvent = game:GetService("ReplicatedStorage"):WaitForChild("ACS_Engine"):WaitForChild("Events"):WaitForChild("Grenade")
local WhizzEvent = game:GetService("ReplicatedStorage"):WaitForChild("ACS_Engine"):WaitForChild("Events"):WaitForChild("Whizz")
local loopkillall = false
local loopwhizzall = false
local loopexplodeall = false
local dmgcount = 100

local Window = Library:CreateWindow({
	Title = 'Troca no Complexo - by r7pha',
	Center = true,
	AutoShow = true,
	Resizable = true,
	ShowCustomCursor = false,
	NotifySide = "Left",
	TabPadding = 8,
	MenuFadeTime = 0.2
})

local Tabs = {
	Main = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

local LeftGroupBox = Tabs.Main:AddLeftGroupbox('Troll')

local FireDmg = function(Part,g,dmg)
    if not dmg then dmg=999 end
    DmgEvent:FireServer(Part, dmg, g)
end

local KillPlr = function(plr,g)
    if plr.Character and plr.Character:FindFirstChild("Head") then
        local c = plr["Character"]
        local h = c["Head"]
        FireDmg(h, g)
    end
end

local GetGun = function()
    local gun=nil
    for _,v in pairs(plr.Character:GetChildren()) do
        if v:FindFirstChild("ACS_Settings") then
            gun=v
            break
        end
    end
    return gun
end

LeftGroupBox:AddButton({
	Text = 'Kill All',
	Func = function()
		local g = GetGun()
        if not g then
            Library:Notify("equipa uma arma seu bosta")
            return
        end
        for _,p in pairs(game.Players:GetPlayers()) do
            KillPlr(p,g)
        end
	end,
	DoubleClick = false,

	Disabled = false,
	Visible = true
})

LeftGroupBox:AddSlider('asdzfasdf', {
	Text = 'dmg',
	Default = 100,
	Min = 1,
	Max = 100,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		dmgcount = Value
	end,

	Disabled = false,
	Visible = true,
})
LeftGroupBox:AddButton({
	Text = 'Damage All',
	Func = function()
		local g = GetGun()
        if not g then
            Library:Notify("equipa uma arma seu bosta")
            return
        end
        for _,p in pairs(game.Players:GetPlayers()) do
            FireDmg(p,g,dmgcount)
        end
	end,
	DoubleClick = false,

	Disabled = false,
	Visible = true
})
LeftGroupBox:AddButton({
	Text = 'Explode All',
	Func = function()
        for _,v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character.Torso then
                GranadeEvent:FireServer(Instance.new("Tool",nil),{Ammo=0,DamageFallOf=0,ShootRate=0,IgnoreProtection=false,EnableZeroing=false,MinRecoilPower=1,Zoom=70,MaxRecoilPower=1,SightAtt="",BulletPenetration=0,CanCheckMag=false,MuzzleVelocity=0,CanBreachDoor=false,AmmoInGun=0,camRecoil={camRecoilUp={0,0},camRecoilRight={0,0},camRecoilLeft={0,0},camRecoilTilt={0,0}},gunName="Granada",HeadDamage={0,0},Zoom2=70,MagCount=false,InfraRed=false,AimInaccuracyStepAmount=0,CurrentZero=0,RainbowMode=false,CrosshairOffset=0,AimSpreadReduction=1,ShootType=0,Bullets=0,EnableHUD=false,SlideEx=CFrame.new(0,0,0,1,0,0,0,1,0,0,0,1),Tracer=true,LimbDamage={0,0},MaxStoredAmmo=0,UnderBarrelAtt="",TracerColor=Color3.new(1,1,1),TracerEveryXShots=0,CenterDot=true,CanBreak=false,TorsoDamage={0,0},ShellInsert=false,MinDamage=0,gunRecoil={gunRecoilTilt={0,0},gunRecoilUp={0,0},gunRecoilLeft={0,0},gunRecoilRight={0,0}},BurstShot=0,RecoilPowerStepAmount=1,Type="Grenade",MaxSpread=0,CrossHair=false,SlideLock=false,FireModes={Auto=false,ChangeFiremode=false,Burst=false,Semi=false},BarrelAtt="",OtherAtt="",BulletType="",AimRecoilReduction=1,IncludeChamberedBullet=false,canAim=false,MaxZero=0,AimInaccuracyDecrease=0,adsTime=1,BulletFlare=true,StoredAmmo=0,MinSpread=0,WalkMult=0,ZeroIncrement=0,BulletDrop=0,Jammed=false,RandomTracer={Enabled=false,Chance=25}},v.Character.Torso.CFrame,vector.create(0.6024577617645264,-0.18805333971977234,-0.7756807208061218),1,1)
            end
        end      
	end,
	DoubleClick = false,
	Disabled = false,
	Visible = true
})

LeftGroupBox:AddButton({
	Text = 'Whizz All',
	Func = function()
        for _,v in pairs(game.Players:GetPlayers()) do
            WhizzEvent:FireServer(v)
        end      
	end,
	DoubleClick = false,
	Disabled = false,
	Visible = true
})
LeftGroupBox:AddToggle('loopkillall', {
	Text = 'Loop Whizz All',

	Default = true,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
		loopwhizzall = Value

        while loopwhizzall do
            task.wait()
            for _,v in pairs(game.Players:GetPlayers()) do
                WhizzEvent:FireServer(v)
            end   
        end
	end
})
LeftGroupBox:AddToggle('loopkillall', {
	Text = 'Loop Explode All',

	Default = true,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
		loopexplodeall = Value

        while loopexplodeall do
            task.wait()
        for _,v in pairs(game.Players:GetPlayers()) do
            if v.Character and v.Character.Torso then
                GranadeEvent:FireServer(Instance.new("Tool",nil),{Ammo=0,DamageFallOf=0,ShootRate=0,IgnoreProtection=false,EnableZeroing=false,MinRecoilPower=1,Zoom=70,MaxRecoilPower=1,SightAtt="",BulletPenetration=0,CanCheckMag=false,MuzzleVelocity=0,CanBreachDoor=false,AmmoInGun=0,camRecoil={camRecoilUp={0,0},camRecoilRight={0,0},camRecoilLeft={0,0},camRecoilTilt={0,0}},gunName="Granada",HeadDamage={0,0},Zoom2=70,MagCount=false,InfraRed=false,AimInaccuracyStepAmount=0,CurrentZero=0,RainbowMode=false,CrosshairOffset=0,AimSpreadReduction=1,ShootType=0,Bullets=0,EnableHUD=false,SlideEx=CFrame.new(0,0,0,1,0,0,0,1,0,0,0,1),Tracer=true,LimbDamage={0,0},MaxStoredAmmo=0,UnderBarrelAtt="",TracerColor=Color3.new(1,1,1),TracerEveryXShots=0,CenterDot=true,CanBreak=false,TorsoDamage={0,0},ShellInsert=false,MinDamage=0,gunRecoil={gunRecoilTilt={0,0},gunRecoilUp={0,0},gunRecoilLeft={0,0},gunRecoilRight={0,0}},BurstShot=0,RecoilPowerStepAmount=1,Type="Grenade",MaxSpread=0,CrossHair=false,SlideLock=false,FireModes={Auto=false,ChangeFiremode=false,Burst=false,Semi=false},BarrelAtt="",OtherAtt="",BulletType="",AimRecoilReduction=1,IncludeChamberedBullet=false,canAim=false,MaxZero=0,AimInaccuracyDecrease=0,adsTime=1,BulletFlare=true,StoredAmmo=0,MinSpread=0,WalkMult=0,ZeroIncrement=0,BulletDrop=0,Jammed=false,RandomTracer={Enabled=false,Chance=25}},v.Character.Torso.CFrame,vector.create(0.6024577617645264,-0.18805333971977234,-0.7756807208061218),1,1)
            end
        end    
        end
	end
})
LeftGroupBox:AddToggle('loopkillall', {
	Text = 'Loop Kill All',

	Default = true,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
		loopkillall = Value

        while loopkillall do
            task.wait()
            local g = GetGun()
            if not g then
                Library:Notify("equipa a arma seu bosta")
                break
            end
            for _,p in pairs(game.Players:GetPlayers()) do
                KillPlr(p,g)
            end
        end
	end
})
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddToggle("KeybindMenuOpen", { Default = Library.KeybindFrame.Visible, Text = "Open Keybind Menu", Callback = function(value) Library.KeybindFrame.Visible = value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
ThemeManager:ApplyToTab(Tabs['UI Settings'])
