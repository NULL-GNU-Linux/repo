pkg = {
	name = "org.kernel.kmod",
	version = "34.2",
	description = "Linux kernel module handling ",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-2.1",
	homepage = "https://github.com/kmod-project/kmod",
	depends = {},
	conflicts = {},
    provides = {"kmod", "modprobe", "insmod", "depmod", "modinfo", "lsmod", "rmmod"},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://git.kernel.org/pub/scm/utils/kernel/kmod/kmod.git/snapshot/kmod-"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-kmod.tar.gz",
	},
}
function pkg.source()
	return function(hook)
        hook("prepare")(function()
            meson({"setup", "--buildtype", "release", "builddir/"})
        end)
		hook("build")(function()
            meson({"compile", "-C", "builddir/"})
		end)

		hook("install")(function()
			meson({"install", "--destdir="..INSTALL, "-C", "builddir/"})
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
