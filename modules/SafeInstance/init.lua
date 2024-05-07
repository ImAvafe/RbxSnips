--!strict
-- Made with <3 by Avafe

local SafeInstance: SafeInstance = {
	_Type = "SafeInstance",
}

type SafeInstance = typeof(SafeInstance)

function SafeInstance:DescendantWhichIsA(Class: string)
	return self:Callback(function()
		return self.wrap(self.Instance:DescendantWhichIsA(Class))
	end)
end

function SafeInstance:DescendantOfClass(Class: string): SafeInstance
	return self:Callback(function()
		local DesiredDescendant

		for _, Descendant in ipairs(self.Instance:GetDescendants()) do
			if Descendant.ClassName == Class then
				DesiredDescendant = Descendant
			end
		end

		return self.wrap(DesiredDescendant)
	end)
end

function SafeInstance:Descendant(Name: string): SafeInstance
	return self:Callback(function()
		return self.wrap(self.Instance:FindFirstChild(Name, true))
	end)
end

function SafeInstance:AncestorWhichIsA(Class: string)
	return self:Callback(function()
		return self.wrap(self.Instance:AncestorWhichIsA(Class))
	end)
end

function SafeInstance:AncestorOfClass(Class: string): SafeInstance
	return self:Callback(function()
		return self.wrap(self.Instance:FindFirstAncestorOfClass(Class))
	end)
end

function SafeInstance:Ancestor(Name: string): SafeInstance
	return self:Callback(function()
		return self.wrap(self.Instance:FindFirstAncestor(Name))
	end)
end

function SafeInstance:ChildWhichIsA(Class: string)
	return self:Callback(function()
		return self.wrap(self.Instance:FindFirstChildWhichIsA(Class))
	end)
end

function SafeInstance:ChildOfClass(Class: string): SafeInstance
	return self:Callback(function()
		return self.wrap(self.Instance:FindFirstChildOfClass(Class))
	end)
end

function SafeInstance:Child(Name: string): SafeInstance
	return self:Callback(function()
		return self.wrap(self.Instance:FindFirstChild(Name))
	end)
end

function SafeInstance:Parent(): SafeInstance
	return self:Callback(function()
		return self.wrap(self.Instance.Parent)
	end)
end

function SafeInstance:Callback(Callback: (SafeInstance) -> SafeInstance | any): SafeInstance
	if typeof(self.Instance) == "Instance" then
		local ReturnValue = Callback(self)

		if typeof(ReturnValue) == "table" and ReturnValue._Type == "SafeInstance" then
			return ReturnValue
		elseif typeof(ReturnValue) == "Instance" then
			return self.wrap(ReturnValue)
		else
			return self.wrap(nil)
		end
	else
		return self.wrap(nil)
	end
end

function SafeInstance:Unwrap(): Instance | nil
	return self.Instance
end

function SafeInstance.new(Instance: any): SafeInstance
	return SafeInstance.wrap(Instance)
end

function SafeInstance.wrap(Instance: any): SafeInstance
	local self = table.clone(SafeInstance)

	self.Instance = Instance

	return self
end

return SafeInstance
