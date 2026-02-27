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
			make({ "INSTALL_PATH=" .. INSTALL .. "/boot", "install" })
			if not OPTIONS.no_modules then
				make({ "INSTALL_MOD_PATH=" ..INSTALL .. "/usr", "modules_install" })
			end
			if not OPTIONS.no_headers then
			    make({"headers_install", "ARCH=" .. ARCH, "INSTALL_HDR_PATH=" .. INSTALL .. "/usr"})
			end
		end)

		hook("post_install")(function()
			print("Kernel installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			exec("mkdir -p " .. INSTALL .. "/usr")
			exec("mkdir -p " .. INSTALL .. "/boot")
			if not OPTIONS.no_modules then
			   local ok, result = pcall(function() install({ "lib", INSTALL .. "/usr/" }, "cp -r") end)
			   if not ok then
					install({"usr/lib", INSTALL}, "cp -r")
			   end
			end
			if not OPTIONS.no_headers then
			    install({ "usr/include", INSTALL .. "/usr/include" }, "cp -r")
			end
			local ok1, result = pcall(function() install({ "vmlinuz-" .. pkg.version .. "-null", "--target-directory=" .. INSTALL .. "/boot" }) end)
			if not ok1 then
			    install({ "boot/vmlinuz-" .. pkg.version .. "-null", "--target-directory=" .. INSTALL .. "/boot" })
			end
			local ok2, result = pcall(function() install({ "config-" .. pkg.version .. "-null", "--target-directory=" .. INSTALL .. "/boot" }) end)
			if not ok2 then
			    install({ "config-" .. pkg.version .. "-null", "--target-directory=" .. INSTALL .. "/boot" })
			end
			local ok3, result = pcall(function() install({ "System.map-" .. pkg.version .. "-null", "--target-directory=" .. INSTALL .. "/boot" }) end)
			if not ok3 then
			    install({ "System.map-" .. pkg.version .. "-null", "--target-directory=" .. INSTALL .. "/boot" })
			end
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
