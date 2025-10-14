local DebugInfo = getinfo or debug.getinfo
local DebugMode = false
local HookedFunctions = {}
local DetectedFunction, KillFunction
local RepStorage = game:GetService 'ReplicatedStorage';
local Players = game:GetService 'Players';
local xRep = RepStorage:FindFirstChild 'xReplicatedStorage';
local AC_Remote = xRep.Eventos:FindFirstChild 'UI';

local Notify = function(Title, Message)
    game:GetService('StarterGui'):SetCore("SendNotification", {
        Title = Title,
        Text = Message
    })
end

setthreadidentity(2)

for _, Item in getgc(true) do
    if typeof(Item) == "table" then
        local Detected = rawget(Item, "Detected")
        local Kill = rawget(Item, "Kill")

        if typeof(Detected) == "function" and not DetectedFunction then
            DetectedFunction = Detected

            local HookedDetected
            HookedDetected = hookfunction(DetectedFunction, function(Arg1, Arg2, Arg3)
                if Arg1 ~= "_" then
                    if DebugMode then
                        warn('Adonis DTC: ' .. Arg1 .. ' | ' .. Arg2)
                    end
                end
                return true
            end)

            table.insert(HookedFunctions, DetectedFunction)
        end

        if rawget(Item, "Variables") and rawget(Item, "Process") and typeof(Kill) == "function" and not KillFunction then
            KillFunction = Kill

            local HookedKill
            HookedKill = hookfunction(KillFunction, function(Arg)
                if DebugMode then
                    warn('Adonis fallback: ' .. Arg)
                end
            end)

            table.insert(HookedFunctions, KillFunction)
        end
    end
end

local HookedDebugInfo
HookedDebugInfo = hookfunction(getrenv().debug.info, newcclosure(function(...)
    local FirstArg, SecondArg = ...

    if DetectedFunction and FirstArg == DetectedFunction then
        if DebugMode then
            print('Adonis has been bypassed UwU')
        end
        return coroutine.yield(coroutine.running())
    end

    return HookedDebugInfo(...)
end))

setthreadidentity(7)
wait(0.3)

local gMt = getrawmetatable(game);
setreadonly(gMt, false);

local Hooked; Hooked = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
    local Method = getnamecallmethod();

    if Method == 'Kick' and self == Players.LocalPlayer then
        return;
    end

    if Method == 'InvokeServer' and self == AC_Remote then
        return;
    end

    if Method == 'GetDescendants' and self == game then -- ninguem usa game:GetDescendants() :sob:
        return {};
    end

    return Hooked(self,...);
end))

setreadonly(gMt, true);
Notify("Success", "Anti-cheat bypassed!")
Notify("Credits", "Made by r7pha")
