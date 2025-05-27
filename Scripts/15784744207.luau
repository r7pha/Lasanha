function Callback(answer)
    if answer == "Yes" then
       loadstring(game:HttpGet("https://raw.githubusercontent.com/r7pha/Lasanha/refs/heads/main/Scripts/Open-Source/ValleyPrison.luau"))()
    end
end

local Bindable = Instance.new("BindableFunction")
Bindable.OnInvoke = Callback

game.StarterGui:SetCore("SendNotification", {
    Title = "ALERT";
    Text = "The script for this game has been discontinued, do you want to run it anyway?";
    Duration = "10";
    Button1 = "Yes";
    Button2 = "No bye";
    Callback = Bindable
})
