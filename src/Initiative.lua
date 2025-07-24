--// Initialization

local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IsClient = RunService:IsClient()

local Initiative = {
	Libraries = {},
	Storage = ReplicatedStorage:FindFirstChild("Libraries") or Instance.new("Folder", ReplicatedStorage)
}
Initiative.Storage.Name = "Libraries"

--// Variables

local Loaded = false

--// Functions

local function _GetTagged(Tag, Callback)
	if typeof(Tag) ~= "string" or typeof(Callback) ~= "function" then return end
	
	CollectionService:GetInstanceAddedSignal(Tag):Connect(Callback)

	for _, TaggedItem in ipairs(CollectionService:GetTagged(Tag)) do
		Callback(TaggedItem)
	end
end

if not Loaded then
	Loaded = true
	
	_GetTagged("Initiative", function(Object)
		if typeof(Object) ~= "Instance" or not Object:IsA("ModuleScript") then return end
		Initiative.Libraries[Object.Name] = Object

		if Object:HasTag("Replicate") then
			Object.Parent = Initiative.Storage
		end
	end)

	if not IsClient then
		_GetTagged("StarterCharacterScripts", function(Object)
			Object.Parent = StarterPlayer.StarterCharacterScripts
			Object:RemoveTag("StarterCharacterScripts")
		end)

		_GetTagged("StarterPlayerScripts", function(Object)
			Object.Parent = StarterPlayer.StarterPlayerScripts
			Object:RemoveTag("StarterPlayerScripts")
		end)
	end
end

function Initiative:Load(Index)
	--/ Returns the requested library from the name
	
	if self.Libraries[Index] then
		return require(self.Libraries[Index])
	else
		warn(`Unknow library "{tostring(Index)}."`)
		print(debug.traceback())
	end
end

return Initiative
