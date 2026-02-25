pkg = {
	name = "io.neovim",
	version = "0.11.6",
	description = "Hyprextendable Vim-based text editor.",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "Apache-2.0",
	homepage = "https://neovim.io",
	depends = {},
	conflicts = {},
	provides = { "editor", "neovim", "nvim" },
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/neovim/neovim/archive/refs/tags/v" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://github.com/neovim/neovim/releases/v" .. pkg.version .. "/nvim-linux-" .. ARCH .. ".tar.gz",
		args = "--strip-components=1",
	},
}
function pkg.source()
	return function(hook)
		hook("build")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			exec("mkdir -p " .. path .. "/usr/")
			make({ "CMAKE_BUILD_TYPE=RelWithDebInfo", "CMAKE_INSTALL_PREFIX=" .. path .. "/usr/" })
		end)

		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			make({ "CMAKE_INSTALL_PREFIX=" .. path .. "/usr/" }, false)
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			exec("mkdir -p " .. path .. "/usr/")
			install({ "bin", path .. "/usr/" }, "cp -r")
			install({ "lib", path .. "/usr/" }, "cp -r")
			install({ "share", path .. "/usr/" }, "cp -r")
		end)
	end
end
