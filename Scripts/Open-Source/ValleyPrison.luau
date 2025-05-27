--[[
this script was made by r7pha
open source cuz discontinued 
code is fucking ass
GIVE ME CREDITS IF UR GONNA USE THIS
--]]
if (getgenv().LasanhaLoaded) then
    return
else
    getgenv().LasanhaLoaded = true
end
-- // Local Variables
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local CCamera = workspace.CurrentCamera
local Humanoid = Character:WaitForChild("Humanoid")
local HRP = Character:WaitForChild("HumanoidRootPart")

local UserInputService = game:GetService("UserInputService")
local Device = "Unknown"
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
    Device = "Mobile"
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Mobile not supported",
        Text = "Mobile devices are not supported YET."
    })
	return
else
    Device = "PC"
end

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "hi",
    Text = "wsp"
})
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title = "Script made by r7pha",
    Text = "This script was made by r7pha, join our Discord Server if you have any problem: https://discord.com/invite/SYNBSkvkEN"
})
if setclipboard then
    setclipboard("https://discord.com/invite/SYNBSkvkEN")
else
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "bro",
        Text = "this executor is fucking ass wtf how it doesnt even have setclipboard bruh"
    })
end
local RunService = game:GetService("RunService")
local FOV_SIZE = 150
local AIMBOT_TOGGLE = false
local AIMBOT_ENABLED = false
local TARGET_PART = "Head"
local AIM_AIMBOT_TOGGLE = true
local target = nil
local Drawing = Drawing or {}
Drawing.new = Drawing.new or function(type)
    local obj = {Visible = true, Color = Color3.new(1, 1, 1), Thickness = 1}
    if type == "Circle" then
        obj.Radius = 0
        obj.Position = Vector2.new(0, 0)
        obj.Filled = false
    end
    return obj
end

-- // Game Variables
local SearchablesFolder = workspace.Map.Functional.Storages.Searchable
local CraftingFolder = workspace.Map.Functional.Crafting
local UnorganizedFolder = workspace.Map.Unorganized

local CFrames = {
    ["Inside Prison"] = CFrame.new(-6.28603077, 14.327239, -65.8896255, -0.996954799, -6.11251744e-06, 0.0779815242, 0, 1, 7.83841751e-05, -0.0779815242, 7.81454801e-05, -0.996954799),
    ["Yard"] = CFrame.new(16.0546284, 17.3025665, -173.014847, -0.699242294, -0.0225217361, -0.714529872, 0, 0.999503613, -0.0315040089, 0.714884758, -0.0220289361, -0.698895216),
    ["Prison infront"] = CFrame.new(326.37796, 12.116416, -299.086273, -0.803120136, -0.0594869703, 0.592840016, 0, 0.995003402, 0.0998409912, -0.595817089, 0.0801843107, -0.799107254),
    ["Max Security"] = CFrame.new(119.513069, -4.72246933, -139.166809, -0.966988742, -0.0472528972, 0.25039947, 0, 0.982656121, 0.185437098, -0.254819006, 0.179315582, -0.950217426),
    ["Evidence Room"] = CFrame.new(145.34137, -5.22101402, -33.0974388, 0.8083781, -0.0221011341, 0.588248551, 0, 0.999294937, 0.0375445932, -0.588663578, -0.0303502269, 0.807808161),
    ["Booking"] = CFrame.new(193.852661, 13.6560698, -132.638474, 0.556063235, -0.0557648465, 0.829267144, 0, 0.997746646, 0.067094408, -0.831139982, -0.0373087339, 0.554810226),
    ["Gas Station"] = CFrame.new(299.072205, 10.487587, -596.306396, 0.818923473, 0.10656067, -0.563922942, 0, 0.982610762, 0.185677245, 0.573902667, -0.152055457, 0.80468303),
    ["Escapee Base"] = CFrame.new(750.413879, 2.63774228, -474.134705, -0.573824465, -0.147300407, 0.805622816, 0, 0.983692467, 0.179858744, -0.81897831, 0.10320735, -0.564466774)
}

-- // Script Variables
local repo = 'https://github.com/violin-suzutsuki/LinoriaLib/raw/refs/heads/main/'
local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local BreakFinderOnTool = false
local ToolsSignal = 0
local Clip = true
local Noclipping = false
local AutoGetGunOnSpawn = false
local AutoGetKeycardOnSpawn = false
local ReturnTPTime = 1
local CustomGunSettings = {Accuracy = 0, BulletCount = 5, RecoilMin = 0, RecoilMax = 0, RPM = 9999, Scope = false}
local WillCumBack = true
local IsHoldingMouseButton = false

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = true
fovCircle.Radius = FOV_SIZE
fovCircle.Color = Color3.new(1, 0, 0)
fovCircle.Thickness = 2
fovCircle.Filled = false
fovCircle.Position = Vector2.new(CCamera.ViewportSize.X / 2, CCamera.ViewportSize.Y / 2)

local BulletCountSaved = 1
local OneBulletSaved = false

-- // Functions
local CheckForBrazilians = function()
    for _,Plr in ipairs(game.Players:GetPlayers()) do
        if Plr:FindFirstChild("ServerVariables") and Plr.ServerVariables:FindFirstChild("BaseInfo") and Plr.ServerVariables.BaseInfo:FindFirstChild("GeoRegion") and Plr.ServerVariables.BaseInfo:FindFirstChild("GeoRegion").Value == "BR" then
            return Plr.Name
        end
    end
end

local IsValidTarget = function(player)
    if player == Player then return false end
    if not player.Character or not player.Character:FindFirstChild("Humanoid") or player.Character.Humanoid.Health <= 0 then return false end
    if Player.Team:GetAttribute("TeamID") == player.Team:GetAttribute("TeamID") then return false end
    return true 
end
local IsTargetVisible = function(targetPart)
    local origin = CCamera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {Player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    if raycastResult then
        local hitPart = raycastResult.Instance
        return hitPart:IsDescendantOf(targetPart.Parent)
    end
    return false
end
local GetClosestPlayer = function()
    local closestPlayer = nil
    local closestDistance = math.huge
    local screenCenter = Vector2.new(CCamera.ViewportSize.X / 2, CCamera.ViewportSize.Y / 2)
    for _, player in pairs(Players:GetPlayers()) do
        if IsValidTarget(player) then
            local character = player.Character
            local targetPart = character:FindFirstChild(TARGET_PART)
            if targetPart then
                local screenPos, onScreen = CCamera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                    if distance <= FOV_SIZE and distance < closestDistance and IsTargetVisible(targetPart) then
                        closestDistance = distance
                        closestPlayer = player
                    end
                end
            end
        end
    end
    return closestPlayer
end
local LockCameraToTarget = function()
    local newTarget = GetClosestPlayer()
    if newTarget and AIMBOT_TOGGLE then
        AIMBOT_ENABLED = true
        target = newTarget
        local targetPart = target.Character[TARGET_PART]
        if target.Character:FindFirstChild(TARGET_PART) and target.Character.Humanoid.Health > 0 and IsTargetVisible(targetPart) then

            CCamera.CFrame = CFrame.new(CCamera.CFrame.Position, targetPart.Position)
        else
            target = GetClosestPlayer()
        end
    else
        AIMBOT_ENABLED = false
        target = nil
    end
end

UserInputService.InputBegan:Connect(function(input, gp)
    if AIMBOT_TOGGLE and AIM_AIMBOT_TOGGLE and input.UserInputType == Enum.UserInputType.MouseButton2 and not gp then
        IsHoldingMouseButton = true
    end
end)
UserInputService.InputEnded:Connect(function(input, gp)
    if AIMBOT_TOGGLE and AIM_AIMBOT_TOGGLE and input.UserInputType == Enum.UserInputType.MouseButton2 and not gp then
        IsHoldingMouseButton = false
    end
end)
RunService.Heartbeat:Connect(function()
    if AIMBOT_TOGGLE then
        fovCircle.Visible = true
        fovCircle.Position = Vector2.new(CCamera.ViewportSize.X / 2, CCamera.ViewportSize.Y / 2)
        if not AIM_AIMBOT_TOGGLE then
            LockCameraToTarget()
        elseif IsHoldingMouseButton then
            LockCameraToTarget()
        end
    else
        AIMBOT_ENABLED = false
        fovCircle.Visible = false
    end
end)

local TweenTeleport = function(NewCFrame, TInfo)
    if not TInfo then TInfo = TweenInfo.new(1) end
    return TS:Create(HRP, TInfo, {CFrame = NewCFrame})
end

local Teleport = function(NewCFrame)
    HRP.CFrame = NewCFrame
end

local GetAllTools = function()
    local SavedCF = HRP.CFrame
    for _,v in ipairs(SearchablesFolder:GetDescendants()) do
        if v:IsA("ProximityPrompt") then
            if BreakFinderOnTool == true and ToolsSignal == 1 then ToolsSignal = 0 break end
            v.HoldDuration = 0
            Teleport(v.Parent.CFrame)
            wait(0.2)
            fireproximityprompt(v)
            wait(0.2)
        end
    end
    HRP.CFrame = SavedCF
end 

local GetKeycard = function(KeycardName)
    local SavedCF = HRP.CFrame
    for _,v in ipairs(UnorganizedFolder:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Name == KeycardName then
            v.HoldDuration = 0
            Teleport(v.Parent.CFrame * CFrame.new(0, 1, 0))
            wait(0.2)
            fireproximityprompt(v)
            wait(0.2)
            break
        end
    end
    HRP.CFrame = SavedCF
end

local GetAllClothes = function()
    local SavedCF = HRP.CFrame
    for _,v in ipairs(CraftingFolder:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Parent.ClassName == "UnionOperation"  then
            v.HoldDuration = 0
            Teleport(v.Parent.CFrame * CFrame.new(0, 1, 0))
            wait(0.2)
            fireproximityprompt(v)
            wait(0.2)
        end
    end
    HRP.CFrame = SavedCF
end 
function GetAllMaterials()
    local SavedCF = HRP.CFrame
    for _,v in ipairs(CraftingFolder:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Parent.ClassName == "Part" then
            v.HoldDuration = 0
            Teleport(v.Parent.CFrame * CFrame.new(0, 1, 0))
            wait(0.2)
            fireproximityprompt(v)
            wait(0.2)
        end
    end
    HRP.CFrame = SavedCF
end 

local SetGunSettings = function(Gun, SettingsTable)
    Gun.LocalConfig.Configuration.Accuracy.Value = Vector3.new(SettingsTable.Accuracy, SettingsTable.Accuracy, SettingsTable.Accuracy)
    Gun.LocalConfig.Configuration.BulletCount.Value = SettingsTable.BulletCount
    Gun.LocalConfig.Configuration.RecoilMin.Value = Vector3.new(SettingsTable.RecoilMin, SettingsTable.RecoilMin, SettingsTable.RecoilMin)
    Gun.LocalConfig.Configuration.RecoilMax.Value = Vector3.new(SettingsTable.RecoilMax, SettingsTable.RecoilMax, SettingsTable.RecoilMax)
    Gun.LocalConfig.Configuration.RPM.Value = SettingsTable.RPM
    --Gun.LocalConfig.Configuration.UseScope.Value = SettingsTable.Scope
end
local SetGunSetting = function(Gun, SettingName, NewValue)
    if (Gun.LocalConfig.Configuration:FindFirstChild(SettingName)) then
        Gun.LocalConfig.Configuration:FindFirstChild(SettingName).Value = NewValue
    end
end

local GetPlayerGuns = function()
    return game.Players.LocalPlayer.Backpack:GetChildren()
end

--// Player Triggers
--[[Player.Backpack.ChildAdded:Connect(function(Child)
    if BreakFinderOnTool == true then
        ToolsSignal = 1
    end
    if Child:WaitForChild("LocalConfig", 2) then
        SetGunSettings(Child, CustomGunSettings)
    end
end)
patched :(
]]

Player.CharacterAdded:Connect(function(Char)
    Character = Char
    Humanoid = Char:WaitForChild("Humanoid")
    HRP = Char:WaitForChild("HumanoidRootPart")

    if (AutoGetGunOnSpawn) then
        local SavedCF = HRP.CFrame
        HRP.CFrame = CFrame.new(187.437027, 27.3668308, -212.803543, 0.249399811, 0.468888342, -0.847315431, 0, 0.87496376, 0.484188408, 0.968400598, -0.120756499, 0.218215793)
        workspace.Armory.ArmoryMain.StealArmory.ProximityPrompt.HoldDuration = 0
        task.wait(0.2)
        fireproximityprompt(workspace.Armory.ArmoryMain.StealArmory.ProximityPrompt)
       -- if not WillCumBack then return end
        task.wait(0.2)
        HRP.CFrame = SavedCF
    end
    if (AutoGetKeycardOnSpawn) then
        GetKeycard("Employee Keycard")
        task.wait()
        GetKeycard("Director Keycard")
        task.wait()
        GetKeycard("Corrections Keycard")
    end

end)

local Window = Library:CreateWindow({
    Title = 'Lasanha - Valley Prison - by r7pha',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0
})
local Tabs = {
    Player = Window:AddTab('Main'),
    ['Interface'] = Window:AddTab('UI Settings'),
}

local ToolsLeftGroupBox = Tabs.Player:AddLeftGroupbox('Tools, penis, etc')
ToolsLeftGroupBox:AddLabel('Giver')

ToolsLeftGroupBox:AddButton('Get All Materials', function()
    local SavedCF = HRP.CFrame
    for _,v in ipairs(CraftingFolder:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.Parent.ClassName == "Part" then
            v.HoldDuration = 0
            HRP.CFrame =v.Parent.CFrame
            wait(0.2)
            fireproximityprompt(v)
            wait(0.2)
        end
    end
    HRP.CFrame = SavedCF
end)

ToolsLeftGroupBox:AddButton('Get All Clothes', function()
    GetAllClothes()
end)
ToolsLeftGroupBox:AddButton('Get All Tools', function()
    GetAllTools()
end)
ToolsLeftGroupBox:AddButton('Get Employee Keycard', function()
    GetKeycard("Employee Keycard")
end)
ToolsLeftGroupBox:AddButton('Get Director Keycard', function()
    GetKeycard("Director Keycard")
end)
ToolsLeftGroupBox:AddButton('Get Corrections Keycard', function()
    GetKeycard("Corrections Keycard")
end)

ToolsLeftGroupBox:AddButton('Insta Get Gun', function()
    local SavedCF = HRP.CFrame
    HRP.CFrame =CFrame.new(187.437027, 27.3668308, -212.803543, 0.249399811, 0.468888342, -0.847315431, 0, 0.87496376, 0.484188408, 0.968400598, -0.120756499, 0.218215793)
    workspace.Armory.ArmoryMain.StealArmory.ProximityPrompt.HoldDuration = 0
    task.wait(0.2)
    fireproximityprompt(workspace.Armory.ArmoryMain.StealArmory.ProximityPrompt)
    task.wait(0.2)
    HRP.CFrame = SavedCF
end)
ToolsLeftGroupBox:AddButton('Insta Refill Ammo', function()
    local SavedCF = HRP.CFrame
    HRP.CFrame =CFrame.new(workspace.Map.AmmoBoxes:GetChildren()[4].Prompt.ProximityPrompt.Parent.Position)
    workspace.Map.AmmoBoxes:GetChildren()[4].Prompt.ProximityPrompt.HoldDuration = 0
    task.wait(0.2)
    fireproximityprompt(workspace.Map.AmmoBoxes:GetChildren()[4].Prompt.ProximityPrompt)
    task.wait(0.2)
    HRP.CFrame = SavedCF
end)

ToolsLeftGroupBox:AddLabel('Skill Issue Section')

ToolsLeftGroupBox:AddToggle('aimbotetas', {
    Text = 'Aimlock',
    Default = false,
    Tooltip = 'Bot that aims for you',
 
    Callback = function(Value)
        AIMBOT_TOGGLE = Value
    end
 })
 ToolsLeftGroupBox:AddToggle('zzasdasd', {
    Text = 'Only lock while aiming',
    Default = false,
    Tooltip = 'only aims when youre aiming',
 
    Callback = function(Value)
        AIM_AIMBOT_TOGGLE = Value
    end
 })
 
 ToolsLeftGroupBox:AddLabel('Aimlock Toggle'):AddKeyPicker('KeyPicker', {
    Default = 'G', 
    SyncToggleState = false,

    Mode = 'Toggle',

    Text = 'Aimlock Toggle',
    NoUI = false,

    Callback = function(Value)
        AIMBOT_TOGGLE = Value
    end,

    ChangedCallback = function(New)
        
    end
})
ToolsLeftGroupBox:AddSlider('daszfdas', {
    Text = 'FOV Size',
    Default = 150,
    Min = 10,
    Max = 360,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        FOV_SIZE = Value
        fovCircle.Radius = Value
    end
})
ToolsLeftGroupBox:AddDropdown('dropdownnigger', {
    Values = { 'Head', 'Torso', 'HumanoidRootPart' },
    Default = 1,
    Multi = false,

    Text = 'Aim Part',
    Tooltip = 'Set part to aim',

    Callback = function(Value)
        TARGET_PART = Value
    end
})
ToolsLeftGroupBox:AddLabel('Gun Tweaks')

--[[ ToolsLeftGroupBox:AddToggle('onebullet', {
    Text = 'One Bullet',
    Default = false,
    Tooltip = 'kills with 1 bullet',
 
    Callback = function(Value)
        OneBulletSaved = Value
        for _,v in ipairs(Character:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.BulletCount = 20
                SetGunSettings(v, CustomGunSettings)
            end
        end
        for _,v in ipairs(Player.Backpack:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.BulletCount = 20
                SetGunSettings(v, CustomGunSettings)
            end
        end
    end
 })
 
 ToolsLeftGroupBox:AddToggle('onebullet', {
    Text = 'No Recoil',
    Default = false,
    Tooltip = 'no recoil ig idk prob',
 
    Callback = function(Value)
        for _,v in ipairs(Character:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.RecoilMin = Vector3.new(0,0,0)
                CustomGunSettings.RecoilMax = Vector3.new(0,0,0)
                SetGunSettings(v, CustomGunSettings)
            end
        end
        for _,v in ipairs(Player.Backpack:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.RecoilMin = Vector3.new(0,0,0)
                CustomGunSettings.RecoilMax = Vector3.new(0,0,0)
                SetGunSettings(v, CustomGunSettings)
            end
        end
    end
 })
--[[ToolsLeftGroupBox:AddSlider('gunaccu', {
    Text = 'Gun Accuracy',
    Default = 0,
    Min = 0,
    Max = 0.010,
    Rounding = 0.001,
    Compact = true,

    Callback = function(Value)
        CustomGunSettings.Accuracy = Value
        for _,v in ipairs(Player.Backpack:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                SetGunSettings(v, {Accuracy = 0, BulletCount = 10, RecoilMin = 0, RecoilMax = 0, RPM = 9999, Scope = false})
            end
        end
        for _,v in ipairs(Character:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                SetGunSettings(v, {Accuracy = 0, BulletCount = 10, RecoilMin = 0, RecoilMax = 0, RPM = 9999, Scope = false})
            end
        end
    end
})
ToolsLeftGroupBox:AddSlider('asdfasdfz', {
    Text = 'Bullet Count',
    Default = 1,
    Min = 1,
    Max = 20,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        CustomGunSettings.BulletCount = Value
        for _,v in ipairs(Character:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.BulletCount = Value
                SetGunSettings(v, CustomGunSettings)
            end
        end
        for _,v in ipairs(Player.Backpack:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.BulletCount = Value
                SetGunSettings(v, CustomGunSettings)
            end
        end
    end
})
ToolsLeftGroupBox:AddSlider('asdfasdf', {
    Text = 'Recoil Min',
    Default = 0,
    Min = 0,
    Max = 0.1,
    Rounding = 0.01,
    Compact = false,

    Callback = function(Value)
        CustomGunSettings.RecoilMin = Value
        for _,v in ipairs(GetPlayerGuns()) do
            SetGunSettings(v, CustomGunSettings)
        end
    end
})]]
--[[ToolsLeftGroupBox:AddSlider('azsdfasdf', {
    Text = 'Recoil Max',
    Default = 0,
    Min = 0,
    Max = 0.1,
    Rounding = 0.01,
    Compact = false,

    Callback = function(Value)
        CustomGunSettings.RecoilMax = Value
        for _,v in ipairs(GetPlayerGuns()) do
            SetGunSettings(v, CustomGunSettings)
        end
    end
})]]
ToolsLeftGroupBox:AddSlider('azsdfasdf', {
    Text = 'RPM',
    Default = 1,
    Min = 1,
    Max = 9999,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        CustomGunSettings.RPM = Value
        for _,v in ipairs(Player.Backpack:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.RPM = Value
                SetGunSettings(v, CustomGunSettings)

            end
        end
        for _,v in ipairs(Character:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                CustomGunSettings.RPM = Value
                SetGunSettings(v, CustomGunSettings)
            end
        end
    end
})
ToolsLeftGroupBox:AddToggle('scopethng', {
    Text = 'Scope',
    Default = false,
    Tooltip = 'set scope in every gun',
 
    Callback = function(Value)
        CustomGunSettings.Scope = Value
        for _,v in ipairs(Player.Backpack:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                SetGunSettings(v, CustomGunSettings)
            end
        end
        for _,v in ipairs(Character:GetDescendants()) do
            if v:FindFirstChild "Fireact" then -- is gun
                SetGunSettings(v, CustomGunSettings)
            end
        end
    end
 })
 ToolsLeftGroupBox:AddLabel('Gun Tweaks Templates')
 ToolsLeftGroupBox:AddButton('Set OP Gun Settings', function()
    for _,v in ipairs(Player.Backpack:GetDescendants()) do
       if v:FindFirstChild "Fireact" then -- is gun
           SetGunSettings(v, {RPM = 9999, Scope = false})
       end
   end
   for _,v in ipairs(Character:GetDescendants()) do
    if v:FindFirstChild "Fireact" then -- is gun
        SetGunSettings(v, {RPM = 9999, Scope = false})
    end
end
end)
local LeftGroupBox = Tabs.Player:AddLeftGroupbox('Player Tweaks')

LeftGroupBox:AddToggle('Nocliptoggle', {
    Text = 'Noclip',
    Default = false,
    Tooltip = 'no... clip?',

    Callback = function(Value)
        if Value then
            Clip = false
            local function NoclipLoop()
                if Clip == false and Character ~= nil then
                    for _, child in pairs(Character:GetDescendants()) do
                        if child:IsA("BasePart") and child.CanCollide == true and child.Name ~= floatName then
                            child.CanCollide = false
                        end
                    end
                end
            end
            Noclipping = game["Run Service"].Stepped:Connect(NoclipLoop)
        else
            Clip = true
            if Noclipping then
                Noclipping:Disconnect()
            end
        end
    end
})
--[[LeftGroupBox:AddSlider('StaminaIdk2', {
    Text = 'Stamina Lose',
    Default = 0,
    Min = 1,
    Max = 9999,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        if game:GetService("Players").LocalPlayer.ServerVariables.Sprint.SubPerM then
            game:GetService("Players").LocalPlayer.ServerVariables.Sprint.SubPerM.Value = Value
        end
    end
})]]
LeftGroupBox:AddToggle('fsdfasdfasdzz', {
    Text = 'Infinite Stamina',
    Default = false,
    Tooltip = 'infinite what',

    Callback = function(Value)
        if Value then
            if game:GetService("Players").LocalPlayer.ServerVariables.Sprint.MaxStamina then
                game:GetService("Players").LocalPlayer.ServerVariables.Sprint.MaxStamina.Value = math.huge
            end
            if game:GetService("Players").LocalPlayer.ServerVariables.Sprint.Stamina then
                game:GetService("Players").LocalPlayer.ServerVariables.Sprint.Stamina.Value = math.huge
            end
        else
            if game:GetService("Players").LocalPlayer.ServerVariables.Sprint.MaxStamina then
                game:GetService("Players").LocalPlayer.ServerVariables.Sprint.MaxStamina.Value = 100
            end
            if game:GetService("Players").LocalPlayer.ServerVariables.Sprint.Stamina then
                game:GetService("Players").LocalPlayer.ServerVariables.Sprint.Stamina.Value = 100
            end
        end
    end
})
LeftGroupBox:AddSlider('StaminaIdk3', {
    Text = 'Normal Walkspeed',
    Default = 16,
    Min = 1,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        if game:GetService("Players").LocalPlayer.ServerVariables.Sprint.SprintWalkSpeed then
            game:GetService("Players").LocalPlayer.ServerVariables.Sprint.SprintWalkSpeed.Value = Value
        end
    end
})
LeftGroupBox:AddSlider('StaminaIdk4', {
    Text = 'Sprint Walkspeed',
    Default = 20,
    Min = 1,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        if game:GetService("Players").LocalPlayer.ServerVariables.Sprint.SprintWalkSpeed then
            game:GetService("Players").LocalPlayer.ServerVariables.Sprint.SprintWalkSpeed.Value = Value
        end
    end
})

local MapLeftGroupBox = Tabs.Player:AddRightGroupbox('Map')
for i, _ in pairs(CFrames) do
    MapLeftGroupBox:AddButton('Teleport to ' .. i, function()
        HRP.CFrame = CFrames[i]
    end)
end
MapLeftGroupBox:AddButton('Insta Escape', function()
    local SavedCF = HRP.CFrame
    HRP.CFrame = workspace.Map.Functional.Invisible.EscapeBarriers:FindFirstChildWhichIsA("Part").CFrame
    task.wait(ReturnTPTime)
    HRP.CFrame = SavedCF
end)
--[[MapLeftGroupBox:AddToggle('Comebacktoggleidk', {
    Text = 'Come back',
    Default = true,
    Tooltip = 'Cum back.',

    Callback = function(Value)
        WillCumBack = Value
    end
})
MapLeftGroupBox:AddSlider('azsdszffasdf', {
    Text = 'Come back after... (seconds)',
    Default = 1,
    Min = 1,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        ReturnTPTime = Value
    end
})]]


Library:OnUnload(function()
    fovCircle.Visible = false
    getgenv().LasanhaLoaded = false
    Library.Unloaded = true
end)

local MenuGroup = Tabs['Interface']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'LeftAlt', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind 

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('XiggaPrison')
SaveManager:SetFolder('XiggaPrison/xiggerz')

SaveManager:BuildConfigSection(Tabs['Interface'])

ThemeManager:ApplyToTab(Tabs['Interface'])

SaveManager:LoadAutoloadConfig()
