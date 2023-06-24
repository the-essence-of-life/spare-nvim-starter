local modules = {
	"config",
}

for _, req in ipairs(modules) do
	require(req)
end
