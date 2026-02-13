pkg = {
	name = "net.busybox",
	version = "1.37.0",
	description = "The Swiss Army Knife of Embedded Linux",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://busybox.net",
	depends = {},
	conflicts = {},
	provides = {
		"busybox",
		"sh",
		"ls",
		"cat",
		"cp",
		"vi",
		"chmod",
		"chown",
		"modprobe",
		"insmod",
		"ash",
		"runit",
		"init",
		"clear",
		"switch_root",
		"pivot_root",
		"install",
		"coreutils",
		"util-linux",
	},
	options = {
		menuconfig = {
			type = "boolean",
			default = false,
			description = "shows a config menu before compiling",
		},
		oldconfig = {
			type = "boolean",
			default = true,
			description = "use existing config and update for new options",
		},
		config = {
			type = "string",
			default = "config",
			description = "path to busybox config file to use",
		},
		defconfig = {
			type = "boolean",
			default = false,
			description = "use default busybox configuration",
		},
	},
}
pkg.sources = {
	source = {
		{
			type = "tar",
			url = "https://mirrors.slackware.com/slackware/slackware64-current/source/a/mkinitrd/busybox-"
				.. pkg.version
				.. ".tar.bz2",
			patches = {
				{
					url = "https://raw.githubusercontent.com/NULL-GNU-Linux/busybox/refs/heads/main/gcc15.patch",
					sha256sum = "e431c8cf88e7d171db9513fd2deb0a10c22bed5288e02cffd4df4dc4c5ac5502",
					nofail = true,
				},
			},
		},
		{
			type = "file",
			url = "https://raw.githubusercontent.com/NULL-GNU-Linux/busybox/refs/heads/main/" .. pkg.version,
			name = "config",
		},
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
			if OPTIONS.config ~= "" then
				if exec("test -f " .. OPTIONS.config) then
					exec("cp " .. OPTIONS.config .. " .config")
					if OPTIONS.oldconfig then
						make({ "oldconfig" })
					end
				else
					curl("https://raw.githubusercontent.com/NULL-GNU-Linux/busybox/refs/heads/main/" .. pkg.version, ".config", {"-fsSL"})
					make({ "oldconfig" })
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
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			exec("mkdir -p " .. path .. "/usr/bin/")
			install({ "busybox", "--target-directory=" .. path .. "/usr/bin/" })
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
			install({ "busybox", "--target-directory=" .. path .. "/usr/bin/" })
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
