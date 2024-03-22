local Players = game:GetService("Players")

local DEFAULT_SOUNDS = {
	Brick = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	Climb = {
		SoundId = "rbxassetid://145180175",
		Volume = 0.3,
	},
	Cobblestone = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	Concrete = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	CorrodedMetal = {
		SoundId = "rbxassetid://16829038373",
		Volume = 1.2,
	},
	DiamondPlate = {
		SoundId = "rbxassetid://16829038373",
		Volume = 1.2,
	},
	Fabric = {
		SoundId = "rbxassetid://16829153060",
		Volume = 0.7,
	},
	Foil = {
		SoundId = "rbxassetid://16829153060",
		Volume = 0.8,
	},
	ForceField = {
		SoundId = "rbxassetid://16829153060",
		Volume = 0.8,
	},
	Glass = {
		SoundId = "rbxassetid://16829038373",
		Volume = 1.2,
	},
	Granite = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	Grass = {
		SoundId = "rbxassetid://16829038667",
		Volume = 0.35,
	},
	Ice = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	LeafyGrass = {
		SoundId = "rbxassetid://16829038202",
		Volume = 0.35,
	},
	Marble = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	Metal = {
		SoundId = "rbxassetid://16829038373",
		Volume = 1.2,
	},
	Neon = {
		SoundId = "rbxassetid://16829153060",
		Volume = 0.8,
	},
	Pebble = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	Plastic = {
		SoundId = "rbxassetid://16829153060",
		Volume = 0.8,
	},
	Sand = {
		SoundId = "rbxassetid://16829037901",
		Volume = 0.35,
	},
	Slate = {
		SoundId = "rbxassetid://16829037315",
		Volume = 0.4,
	},
	SmoothPlastic = {
		SoundId = "rbxassetid://16829153060",
		Volume = 0.8,
	},
	Snow = {
		SoundId = "rbxassetid://16829038510",
		Volume = 0.3,
	},
	Wood = {
		SoundId = "rbxassetid://16829037092",
		Volume = 0.45,
	},
	WoodPlanks = {
		SoundId = "rbxassetid://16829037092",
		Volume = 0.45,
	},
}

local Footstepper = {}

function Footstepper:UpdateSounds(Sounds: table, SoundProperties: table)
	for _, Sound in ipairs(Sounds) do
		local SoundInfo = SoundProperties[Sound.Name]
		if SoundInfo then
			for Name, Value in SoundInfo do
				if Sound[Name] then
					Sound[Name] = Value
				end
			end
		end
	end
end

function Footstepper:_HandleCharacter(Character: Model)
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")

	if Humanoid and HumanoidRootPart then
		local Sounds = self:_SetUpSounds(HumanoidRootPart)

		local DefaultSound = HumanoidRootPart:WaitForChild("Running")
		if DefaultSound then
			DefaultSound:Destroy()
		end

		local FloorMaterial: Enum.Material = Enum.Material.Plastic
		local WalkSpeed: number = 0
		local LastFloorMaterial: Enum.Material = Enum.Material.Plastic
		local LastWalkSpeed: number = 0

		Humanoid.Running:Connect(function(Speed: number)
			WalkSpeed = Speed

			if WalkSpeed ~= LastWalkSpeed then
				self:_UpdatePlayingSound(Sounds, WalkSpeed, FloorMaterial)
			end
			LastWalkSpeed = WalkSpeed
		end)
		Humanoid:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
			FloorMaterial = Humanoid.FloorMaterial

			if FloorMaterial ~= LastFloorMaterial then
				self:_UpdatePlayingSound(Sounds, WalkSpeed, FloorMaterial)
			end
			LastFloorMaterial = FloorMaterial
		end)
	end
end

function Footstepper:_UpdatePlayingSound(Sounds: Attachment, WalkSpeed: number, FloorMaterial: Enum.Material)
	for _, Sound in ipairs(Sounds:GetChildren()) do
		Sound.Playing = false
		Sound.Looped = false
	end

	if WalkSpeed >= WalkSpeed / 2 then
		local Sound = Sounds:FindFirstChild(string.split(tostring(FloorMaterial), "Enum.Material.")[2])

		if Sound then
			Sound.PlaybackSpeed = WalkSpeed / 13
			Sound.Playing = true
			Sound.Looped = true
		end
	end
end

function Footstepper:_SetUpSounds(HumanoidRootPart: BasePart)
	local SoundGroup = Instance.new("SoundGroup")
	SoundGroup.Name = "FootstepSounds"
	SoundGroup.Volume = 4

	local Sounds = Instance.new("Attachment")
	Sounds.Name = "Sounds"
	Sounds.Parent = HumanoidRootPart

	for Name, _ in pairs(DEFAULT_SOUNDS) do
		local Sound = Instance.new("Sound")
		Sound.Name = Name
		Sound.Looped = true
		Sound.RollOffMaxDistance = 100
		Sound.RollOffMinDistance = 10
		Sound.SoundGroup = SoundGroup
		Sound.Parent = Sounds
	end

	SoundGroup.Parent = HumanoidRootPart

	self:UpdateSounds(Sounds:GetChildren(), DEFAULT_SOUNDS)

	return Sounds
end

function Footstepper:_HandlePlayer(Player: Player)
	Player.CharacterAdded:Connect(function(Character)
		self:_HandleCharacter(Character)
	end)

	if Player.Character then
		self:_HandleCharacter(Player.Character)
	end
end

function Footstepper:Start()
	Players.PlayerAdded:Connect(function(Player)
		self:_HandlePlayer(Player)
	end)

	for _, Player in ipairs(Players:GetPlayers()) do
		self:_HandlePlayer(Player)
	end
end

return Footstepper
