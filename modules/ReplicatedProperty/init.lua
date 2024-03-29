local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Fusion = require(ReplicatedStorage.Packages.Fusion)

local Value = Fusion.Value
local Observer = Fusion.Observer

return function(RemoteProperty: table, DefaultValue: any?)
	local ValueObject = Value(DefaultValue)

	Observer(ValueObject):onChange(function()
		RemoteProperty:Set(ValueObject:get())
	end)

	return ValueObject
end
