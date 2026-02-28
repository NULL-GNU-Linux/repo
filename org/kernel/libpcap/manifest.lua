pkg = {
	name = "org.kernel.libpcap",
	version = "2.77",
	description = "POSIX 1003.1e capabilities",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://sites.google.com/site/fullycapable/",
	depends = {},
	conflicts = {},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://git.kernel.org/pub/scm/libs/libcap/libcap.git/snapshot/libcap-"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-libpcap.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("build")(function()
            make()
		end)

		hook("install")(function()
			make({"prefix=/usr", "lib=lib"}, false)
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
