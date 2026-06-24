# Gui 2 Lua

A new Gui 2 lua script implemented directly in lua

## What for?

Some people might try to copy a frame in a Roblox game but they'd have to recreate it with the same properties each time

## Gui 2 Lua automatically dumps every property in the Frame, ScreenGui, Etc and returns it as a script that can be executed directly

## Usage
```lua
local Gui2Lua = loadstring(game:HttpGet("https://raw.githubusercontent.com/MalwareMania/gui-2-lua/refs/heads/main/Gui2Lua.lua"))()

local Instance = ...

setclipboard(Gui2Lua.Dump(instance, "Output directory here"))
```

## Options

Configure some properties before dumping (optional)

| Option | Type | Default | Description |
|---|---|---|---|
| `includeAttributes` | `boolean` | `true` | Include instance attributes |
| `includeTags` | `boolean` | `true` | Include CollectionService tags |
| `includePivot` | `boolean` | `true` | Include pivot for PVInstances |
| `skipDefaults` | `boolean` | `true` | Skip properties that match their default value |

```lua
Gui2Lua.SetOptions({
    includeAttributes = false,
    skipDefaults = false,
})
```

## Add extra properties

Include more or hidden properties

```lua
Gui2Lua.AddExtraProperties("Frame", { "HiddenProp" })
Gui2Lua.AddExtraProperties("*", { "GlobalHiddenProp" }) -- applies to all classes
```

**Changelog:**

• Fixed UIStroke properties not being set

• Added an extra properties table for new properties you'd wanna add

• Added all unique properties and main properties

• Fixed Size and Position not being set

• Fixed Size and Position not being set

• Remade to a loadstring compatible library

• Added `Gui2Lua.SetOptions()` to configure options when dumping

• Added `Gui2Lua.AddExtraProperties()` to include more or hidden properties per class

## V1.3.0
