pkg = {
	name = "net.busybox",
	version = "1.36.1",
	description = "The Swiss Army Knife of Embedded Linux",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://busybox.net",
	depends = {},
	conflicts = {},
	provides = { "busybox", "sh", "ls", "cat", "vi", "chmod", "chown", "modprobe", "insmod" },
	options = {
		menuconfig = {
			type = "boolean",
			default = false,
			description = "shows a config menu before compiling",
		},
		oldconfig = {
			type = "boolean",
			default = false,
			description = "use existing config and update for new options",
		},
		config = {
			type = "string",
			default = "",
			description = "path to busybox config file to use",
		},
		defconfig = {
			type = "boolean",
			default = true,
			description = "use default busybox configuration",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/mirror/busybox/archive/refs/tags/" .. pkg.version:gsub("%.", "_") .. ".tar.gz",
	},
	binary = {
		type = "file",
		url = "https://files.obsidianos.xyz/~odd/static/busybox",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing BusyBox build...")
		end)

		hook("build")(function()
			if OPTIONS.config and OPTIONS.config ~= "" then
				if exec("test -f " .. OPTIONS.config) then
					exec("cp " .. OPTIONS.config .. " .config")
					if OPTIONS.oldconfig then
						make({ "oldconfig" })
					end
				else
					print("Warning: Config file " .. OPTIONS.config .. " not found, using defconfig")
					make({ "defconfig" })
				end
			elseif OPTIONS.defconfig or (not OPTIONS.menuconfig and not OPTIONS.oldconfig) then
				make({ "defconfig" })
			end
			if OPTIONS.menuconfig then
				make({ "menuconfig" })
			end
			make()
		end)

		hook("install")(function()
			make({}, false)
		end)

		hook("post_install")(function()
			print("BusyBox installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("pre_install")(function()
			print("Preparing BusyBox binary installation...")
		end)

		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			exec("mkdir -p " .. path .. "/usr/bin/")
			install({"busybox", "--target-directory=" .. path .. "/usr/bin/"})
		end)

		hook("post_install")(function()
			print("BusyBox binary installed")
		end)
	end
end

function pkg.uninstall()
	return function(hook)
		hook("pre_uninstall")(function()
			print("Removing BusyBox...")
		end)

		hook("post_uninstall")(function()
			print("BusyBox uninstalled")
		end)
	end
end
