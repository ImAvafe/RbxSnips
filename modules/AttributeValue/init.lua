local Fusion = require(script.Parent.Fusion)

local Value = Fusion.Value

return function(Instance: Instance, AttributeName: string, DefaultValue: any?)
	if Instance:GetAttribute(AttributeName) == nil then
		Instance:SetAttribute(AttributeName, DefaultValue)
	end

	local AttributeValue = Value(Instance:GetAttribute(AttributeName))

	Instance:GetAttributeChangedSignal(AttributeName):Connect(function()
		AttributeValue:set(Instance:GetAttribute(AttributeName))
	end)

	return AttributeValue
end
