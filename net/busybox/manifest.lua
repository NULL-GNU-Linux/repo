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
		no_symlinks = {
			type = "boolean",
			default = false,
			description = "disables creating symlinks for busybox applets",
		},
		compiler = {
			type = "string",
			default = "gcc",
			description = "program to compile busybox with",
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
            args = "--strip-components=1",
			patches = {
				{
					url = "https://raw.githubusercontent.com/NULL-GNU-Linux/busybox/refs/heads/main/gcc15.patch",
					sha256sum = "e5a3bebe7d975ecd03b9a04a8b797691cd8356fc0e7cbe422e20bd37d65c8727",
					nofail = true,
				},
			},
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
					curl(
						"https://raw.githubusercontent.com/NULL-GNU-Linux/busybox/refs/heads/main/" .. pkg.version,
						".config",
						{ "-fsSL" }
					)
					make({ "oldconfig" }, true, nil, 'yes "" |')
				end
			elseif OPTIONS.defconfig or (not OPTIONS.menuconfig and not OPTIONS.oldconfig) then
				make({ "defconfig" })
			end
			if OPTIONS.menuconfig then
				make({ "menuconfig" })
			end
			make({ "CC=" .. OPTIONS.compiler })
		end)

		hook("install")(function()
			exec("mkdir -p " .. INSTALL .. "/usr/bin/")
			install({ "busybox", "--target-directory=" .. INSTALL .. "/usr/bin/" })
			if not OPTIONS.no_symlinks then
				exec(
				    INSTALL
						.. "/usr/bin/busybox --list | grep -xv 'busybox' | grep -xv 'ar' | grep -xv 'strings' | while read applet; do "
						.. "[ ! -e '"
						.. INSTALL
						.. "/usr/bin/$applet' ] && ln -s /usr/bin/busybox \""
						.. INSTALL
						.. '/usr/bin/$applet" || true; '
						.. "done"
				)
			end
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
			exec("mkdir -p " .. INSTALL .. "/usr/bin/")
			install({ "busybox", "--target-directory=" .. INSTALL .. "/usr/bin/" })
			if not OPTIONS.no_symlinks then
				exec(
				    INSTALL
						.. "/usr/bin/busybox --list | grep -xv 'busybox' | grep -xv 'ar' | grep -xv 'strings' | while read applet; do "
						.. "[ ! -e '"
						.. INSTALL
						.. "/usr/bin/$applet' ] && ln -s /usr/bin/busybox \""
						.. INSTALL
						.. '/usr/bin/$applet" || true; '
						.. "done"
				)
			end
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
