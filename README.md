# Initiative Main Frame

> **Roblox script framework** that automatically collects tagged ModuleScripts and assigns them to the right services (`StarterPlayerScripts`, `StarterCharacterScripts`, etc.) with optional replication and client preloading.

---

## Features

- **Auto-register** modules tagged with `"Initiative"`.
- **Replicate** modules tagged `"Replicate"` into `ReplicatedStorage.Libraries` for client access.
- **Targeted placement** into `StarterPlayerScripts` & `StarterCharacterScripts` with corresponding tags.
- **Preload client modules** tagged `"PreloadClient"` for instant availability on the client.
- Works **regardless of module location** in the DataModel.
- Simple `Initiative:Load()` API for module requiring.

---

## Recognized Tags

| Tag | Description | Example Target |
| --- | ----------- | -------------- |
| `Initiative` | Registers the module with Initiative for use via `Initiative:Load()` | Anywhere |
| `Replicate` | Copies the module to `ReplicatedStorage.Libraries` for client-side access | ServerScriptService/MyModule |
| `StarterPlayerScripts` | Automatically inserts a loader into `StarterPlayer.StarterPlayerScripts` to run client modules | StarterPlayer/StarterPlayerScripts |
| `StarterCharacterScripts` | Automatically inserts a loader into `StarterPlayer.StarterCharacterScripts` to run client modules | StarterPlayer/StarterCharacterScripts |
| `PreloadClient` | Requires and caches the module on the client at startup *(must be in a client-accessible location such as `StarterPlayerScripts`, `StarterCharacterScripts`, or `PlayerGui`)* | PlayerGui/MyUI |

---

## How It Works

Modules with the tag `"Initiative"` are registered automatically.  
Think of it as an **enhanced `require()` system**:  

```lua
local Initiative = require(game.ReplicatedStorage:WaitForChild("Initiative"))
local MyLibrary = Initiative:Load("MyLibrary")
