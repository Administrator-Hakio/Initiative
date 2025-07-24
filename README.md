# Initiative Main Frame

> ⚙️ Roblox script framework to automatically collect tagged modules and assign them to game services like `StarterPlayerScripts` and `StarterCharacterScripts`.

## 📦 Features

- Auto-loads modules tagged `"Initiative"`
- Replicates modules tagged `"Replicate"` to `ReplicatedStorage`
- Supports `StarterPlayerScripts` & `StarterCharacterScripts` tagging
- Exposes a `Load()` method for module requiring
- Works regardless of the module’s location in the hierarchy

## 📁 Structure

Modules tagged `"Initiative"` are automatically registered by the system.

> 🧠 Think of it as an advanced `require()` system.  
> By simply tagging a module with `"Initiative"`, it becomes globally accessible through `Initiative:Load("ModuleName")`, no matter where it's placed in the game.

Recognized tags:
- `Initiative` → registers the module for use with the system
- `Replicate` → copies the module to `ReplicatedStorage.Libraries` to be shared with client sided scripts
- `StarterPlayerScripts` → inserts the LoadScript into `StarterPlayer.StarterPlayerScripts` to automatically load client scripts into StarterPlayerScripts
- `StarterCharacterScripts` → inserts the LoadScript into `StarterPlayer.StarterCharacterScripts` to automatically load client scripts StarterCharacterScripts

## 🚀 Usage

```lua
local Initiative = require(game.ReplicatedStorage:WaitForChild("Initiative"))
local MyLibrary = Initiative:Load("MyLibrary")
