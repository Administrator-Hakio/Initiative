--[[
	Initiative Main Frame © 2023 Administrator_Hakio — Licensed under the MIT License.

 ___  ___  ________  ___  __    ___  ________          ___  ________   ________  ___  ___  ________  _________  ________  ___  _______   ________      
|\  \|\  \|\   __  \|\  \|\  \ |\  \|\   __  \        |\  \|\   ___  \|\   ___ \|\  \|\  \|\   ____\|\___   ___\\   __  \|\  \|\  ___ \ |\   ____\     
\ \  \\\  \ \  \|\  \ \  \/  /|\ \  \ \  \|\  \       \ \  \ \  \\ \  \ \  \_|\ \ \  \\\  \ \  \___|\|___ \  \_\ \  \|\  \ \  \ \   __/|\ \  \___|_    
 \ \   __  \ \   __  \ \   ___  \ \  \ \  \\\  \       \ \  \ \  \\ \  \ \  \ \\ \ \  \\\  \ \_____  \   \ \  \ \ \   _  _\ \  \ \  \_|/_\ \_____  \   
  \ \  \ \  \ \  \ \  \ \  \\ \  \ \  \ \  \\\  \       \ \  \ \  \\ \  \ \  \_\\ \ \  \\\  \|____|\  \   \ \  \ \ \  \\  \\ \  \ \  \_|\ \|____|\  \  
   \ \__\ \__\ \__\ \__\ \__\\ \__\ \__\ \_______\       \ \__\ \__\\ \__\ \_______\ \_______\____\_\  \   \ \__\ \ \__\\ _\\ \__\ \_______\____\_\  \ 
    \|__|\|__|\|__|\|__|\|__| \|__|\|__|\|_______|        \|__|\|__| \|__|\|_______|\|_______|\_________\   \|__|  \|__|\|__|\|__|\|_______|\_________\
                                                                                             \|_________|                                  \|_________|
--]]


--// Initialization

local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IsClient = RunService:IsClient()

local Initiative = setmetatable({
	Libraries = {},
	Cache = {},
	Storage = ReplicatedStorage:FindFirstChild("Libraries") or Instance.new("Folder", ReplicatedStorage)
}, {
	["__newindex"] = function(self, Index, Value)
		rawset(self, Index, Value)

		for Event, EventName in pairs(self.Cache) do
			if Index == EventName then
				EventName:Fire(Value)
				EventName:Destroy()
			end
		end
	end
})

Initiative.Storage.Name = "Libraries"

--// Functions

local function GetTagged(Tag, Callback)
	assert(typeof(Tag) == "string", "Expected TagLabel to be a string.")
	assert(typeof(Callback) == "function", "Expected Callback to be a function.")

	if typeof(Tag) ~= "string" or typeof(Callback) ~= "function" then return end
	local Objects = {}

	CollectionService:GetInstanceAddedSignal(Tag):Connect(Callback)

	for _, Object in ipairs(CollectionService:GetTagged(Tag)) do
		if table.find(Objects, Object.Name) then continue end
		table.insert(Objects, Object.Name)

		Callback(Object)
	end
end

function Initiative:Load(Index)
	--/ Returns the requested library from the name

	repeat task.wait() until script:GetAttribute("Loaded") == true

	if self.Libraries[Index] then
		local Success, Output = pcall(function()
			return require(self.Libraries[Index])
		end)

		if Success then
			return Output
		else
			warn(`An error has occured while loading library "{tostring(Index)}". Error: {tostring(Output)}`)
		end
	else
		warn(`Unknow library "{tostring(Index)}".`)
		print(debug.traceback())

		local BindableEvent = Instance.new("BindableEvent", script)
		self.Cache[BindableEvent] = Index

		return require(BindableEvent.Event:Wait())
	end
end

--/ Preloaders

if not IsClient and not script:GetAttribute("Loaded") then
	GetTagged("Initiative", function(Object)
		if typeof(Object) ~= "Instance" or not Object:IsA("ModuleScript") then return end
		Initiative.Libraries[Object.Name] = Object

		if Object:HasTag("Replicate") then
			Object.Parent = Initiative.Storage
		end
	end)

	GetTagged("StarterCharacterScripts", function(Object)
		Object:RemoveTag("StarterCharacterScripts")
		Object.Parent = StarterPlayer.StarterCharacterScripts
	end)

	GetTagged("StarterPlayerScripts", function(Object)
		Object:RemoveTag("StarterPlayerScripts")
		Object.Parent = StarterPlayer.StarterPlayerScripts
	end)

	script:SetAttribute("Loaded", true)
elseif IsClient and not script:GetAttribute("ClientLoaded") then
	GetTagged("PreloadClient", function(Object)
		if typeof(Object) ~= "Instance" or not Object:IsA("ModuleScript") then return end

		task.spawn(require,Object)
	end)

	script:SetAttribute("ClientLoaded", true)
end

delay(2, function()
	GetTagged("Preload", function(Object)
		if typeof(Object) ~= "Instance" or not Object:IsA("ModuleScript") then return end
		Object:RemoveTag("Preload")
		pcall(require, Object)
	end)
end)

return Initiative
