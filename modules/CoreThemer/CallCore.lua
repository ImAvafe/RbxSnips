local StarterGui = game:GetService("StarterGui")

local MAX_RETRIES = 8

return function(Method, ...)
	local Result = {}

	for _ = 1, MAX_RETRIES do
		Result = { pcall(StarterGui[Method], StarterGui, ...) }
		if Result[1] then
			break
		end
		task.wait()
	end

	return unpack(Result)
end
