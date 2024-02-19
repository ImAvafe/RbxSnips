local TYPE_CLASSES = {
	int = "IntValue",
	number = "NumberValue",
	string = "StringValue",
	boolean = "BoolValue",
	Instance = "ObjectValue",
	BrickColor = "BrickColorValue",
	Color3 = "Color3Value",
	Vector3 = "Vector3Value",
}

local LeaderStats = {
	_PlayerStats = {},
}

function LeaderStats.new(Player: Player)
	local self = table.clone(LeaderStats)

	self.Player = Player
	self.Stats = {}

	self.Folder = Player:FindFirstChild("leaderstats")
	if self.Folder == nil then
		self.Folder = Instance.new("Folder")
		self.Folder.Name = "leaderstats"
		self.Folder.Parent = self.Player
	end

	for _, PreexistingStat in ipairs(self.Folder:GetChildren()) do
		local StatType = typeof(PreexistingStat.Value)
		if TYPE_CLASSES[StatType] then
			self:SetStat(PreexistingStat.Name, PreexistingStat.Value)
		end
	end

	return self
end

function LeaderStats:Destroy()
	self.Folder:Destroy()
	self = nil
end

function LeaderStats:SetStat(Name: string, Value: any)
	local Stat = self.Stats[Name] or self.Folder:FindFirstChild(Name)

	if TYPE_CLASSES[typeof(Value)] == nil then
		warn("Invalid Stat type: ", typeof(Value))
	end

	if Stat == nil then
		Stat = Instance.new(TYPE_CLASSES[typeof(Value)])
		Stat.Name = Name
		Stat.Parent = self.Folder
	end

	if Value then
		Stat.Value = Value
	else
		Stat:Destroy()
	end

	self.Stats[Name] = Stat
end

function LeaderStats:GetStat(Name: string)
	local StatObject = self.Stats[Name]
	if StatObject then
		return StatObject.Value
	end
end

function LeaderStats:GetStatChangedSignal(Name: string)
	local StatObject = self.Stats[Name]
	if StatObject then
		return StatObject:GetPropertyChangedSignal("Value")
	end
end

return LeaderStats
