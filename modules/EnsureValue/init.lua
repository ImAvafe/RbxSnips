local Fusion = require(script.Parent.Fusion)

return function(Value: any, Type: string, Default: any?)
	if Value == nil then
		return Fusion.Value(Default)
	elseif typeof(Value) == Type then
		return Fusion.Value(Value)
	else
		return Value
	end
end
