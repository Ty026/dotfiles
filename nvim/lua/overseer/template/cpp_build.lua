return {
	name = "cpp_build",
	builder = function()
		return {
			cmd = { "cmake" },
			args = { "--build", "build" },
			components = { { "on_output_quickfix", close = true, open = true }, "default" },
		}
	end,
	condition = {
		filetype = { "cpp", "c" },
	},
}
