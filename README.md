# Initiative Main Frame

> ⚙️ Roblox script framework to automatically collect tagged modules and assign them to game services like `StarterPlayerScripts` and `StarterCharacterScripts`.

## 📦 Features

- Auto-loads modules tagged `"Initiative"`
- Replicates modules tagged `"Replicate"` to `ReplicatedStorage` for client sided scripts
- Supports `StarterPlayerScripts` & `StarterCharacterScripts` tagging
- Exposes a `Load()` method for module requiring

## 📁 Structure

Modules tagged `"Initiative"` are automatically tracked. Example tags:
- `Replicate` → copied to `ReplicatedStorage.Libraries`
- `StarterPlayerScripts` → inserted into `StarterPlayer.StarterPlayerScripts`
- `StarterCharacterScripts` → inserted into `StarterPlayer.StarterCharacterScripts`

## 🚀 Usage

```lua
local Initiative = require(game.ReplicatedStorage:WaitForChild("Initiative"))
local MyLibrary = Initiative:Load("MyLibrary")
