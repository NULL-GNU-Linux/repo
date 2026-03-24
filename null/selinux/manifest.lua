pkg = {
	name = "null.selinux",
	version = "3.10",
	description = "A flexible Mandatory Access Control system built into the Linux Kernel",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://github.com/SELinuxProject/selinux",
	depends = {},
	conflicts = {},
	provides = { "libselinux", "selinux" },
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/SELinuxProject/selinux/archive/refs/tags/libselinux-"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-selinux.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("build")(function()
            make({"PREFIX=/usr", "DISABLE_AUDIT=y"})
		end)

		hook("install")(function()
			make({}, false)
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			install({ "*", INSTALL }, "cp -r")
		end)
	end
end
