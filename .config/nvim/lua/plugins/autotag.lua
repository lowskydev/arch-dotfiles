return {
	"windwp/nvim-ts-autotag",
	lazy = false,
	config = function()
		require("nvim-ts-autotag").setup({
			opts = {
				enable_close = true, -- <MyButton> → auto adds </MyButton>
				enable_rename = true, -- rename both tags simultaneously
				enable_close_on_slash = false, -- typing <MyButton/ does NOT auto close
			},
		})
	end,
}
