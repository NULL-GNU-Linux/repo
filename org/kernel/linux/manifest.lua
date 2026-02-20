pkg = {
	name = "org.kernel.linux",
	version = "6.19.3",
	description = "The Linux Kernel",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://kernel.org",
	depends = {},
	conflicts = {},
	provides = { "linux", "kernel" },
	options = {
		menuconfig = {
			type = "boolean",
			default = false,
			description = "shows a config menu before compiling",
		},
		defconfig = {
		    type = "boolean",
			default = false,
			description = "use kernel's default config rather than NULL's",
		},
		no_modules = {
			type = "boolean",
			default = false,
			description = "disables compiling modules",
		},
		no_headers = {
		    type = "boolean",
			default = false,
			description = "disables installing kernel headers"
		}
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://cdn.kernel.org/pub/linux/kernel/v"
			.. pkg.version:match("^(%d+)")
			.. ".x/linux-"
			.. pkg.version
			.. ".tar.xz",
	},
	binary = {
	    type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-linux.tar",
		sha256sum = "73b7203c351926f282aa2f1007de977f2fffe473c46ca1d14d6bba31e7d6f793",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing kernel build...")
		end)

		hook("build")(function()
			make({ "defconfig" })
			if not OPTIONS.defconfig then
			    curl("https://raw.githubusercontent.com/NULL-GNU-Linux/linux/refs/heads/main/" .. ARCH .. ".conf", ".config", {"-fsSL"})
			    make({ "oldconfig" }, true, nil, "yes \"\" |")
			end
			if OPTIONS.menuconfig then
				make({ "menuconfig" })
			end
			make()
		end)

		hook("pre_install")(function()
			print("Pre-install steps...")
		end)

		hook("install")(function()
			make({ "INSTALL_PATH=" .. CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name, "install" })
			if not OPTIONS.no_modules then
				make({ "INSTALL_MOD_PATH=" .. CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name, "modules_install" })
			end
			if not OPTIONS.no_headers then
			    make({"headers_install", "ARCH=" .. ARCH, "INSTALL_HDR_PATH=" .. CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name .. "/usr"})
			end
		end)

		hook("post_install")(function()
			print("Kernel installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("pre_install")(function()
			print("Preparing binary installation...")
		end)

		hook("install")(function()
			print("Installing binary package...")
		end)

		hook("post_install")(function()
			print("Binary package installed")
		end)
	end
end

function pkg.uninstall()
	return function(hook)
		hook("pre_uninstall")(function()
			print("Pre-uninstall cleanup...")
		end)

		hook("post_uninstall")(function()
			print("Kernel uninstalled")
		end)
	end
end
