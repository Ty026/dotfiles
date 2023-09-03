return {
	name = "cmake",
	builder = function()
		return {
			cmd = { "cmake" },
			args = { "-B", "build", "-G", "Ninja" },
			components = { { "on_output_quickfix", close = true, open = true }, "default" },
		}
	end,
	condition = {
		filetype = { "cpp", "c" },
	},
}
