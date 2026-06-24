local Gui2Lua = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalwareMania/gui-2-lua/refs/heads/main/Gui2Lua.lua"))()

-- Dump and copy to clipboard

local Instance = game:GetService("Players").LocalPlayer.PlayerGui.MailboxUI.Frame.Header
setclipboard(Gui2Lua.Dump(Instance, "game.Players.LocalPlayer.PlayerGui.MailboxUI.Frame"))

-- Optional: Set options when dumping
Gui2Lua.SetOptions({
    includeAttributes = true,
    includeTags = true,
    includePivot = true,
    skipDefaults = true,
})

-- Optional: Add more or hidden properties when dumping

Gui2Lua.AddExtraProperties("Frame", { "HiddenProp" })
Gui2Lua.AddExtraProperties("*", { "NewProp" })
