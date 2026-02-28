pkg = {
	name = "net.zstd",
	version = "1.5.7",
	description = "A fast compression algorithm",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "BSD-3-Clause or GPL-2.0",
	homepage = "https://zstd.net",
	depends = {},
	conflicts = {},
	provides = {"zstd", "zstandard", "libzstd"},
}

pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/facebook/zstd/releases/download/v"..pkg.version.."/zstd-"..pkg.version..".tar.gz",
        args = "--strip-components=1"
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/"..ARCH.."-zstd.tar.gz",
	},
}

function pkg.source()
	return function(hook)
		hook("build")(function()
			make({"PREFIX=/usr"})
		end)

		hook("install")(function()
			make({"PREFIX=/usr"}, false)
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
            exec("cp -r * "..INSTALL.."/")
		end)
	end
end

function pkg.uninstall()
	return function(hook)
		hook("pre_uninstall")(function()
			print("Pre-uninstall cleanup...")
		end)

		hook("post_uninstall")(function()
			print("zlib uninstalled")
		end)
	end
end
