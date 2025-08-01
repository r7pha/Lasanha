local mt = getrawmetatable(game)
setreadonly(mt, false)

local oldnmc = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == game.Players.LocalPlayer and method == "Kick" then
        return
    end
    return oldnmc(self, ...)
end)
