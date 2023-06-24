local modules = {
	"config.options",
	"config.lazy",
}

for _, req in ipairs(modules) do
	require(req)
end
