pkg = {
	name = "net.zlib",
	version = "1.3.1",
	description = "Massively spiffy yet delicately unobtrusive compression library",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "Zlib",
	homepage = "https://zlib.net",
	depends = {},
	conflicts = {},
	provides = {"zlib"},
	options = {
		static = {
			type = "boolean",
			default = false,
			description = "Build static library",
		},
	},
}

pkg.sources = {
	source = {
		type = "tar",
		url = "https://zlib.net/zlib-" .. pkg.version .. ".tar.gz",
	},
	binary = {
		type = "file", -- to not make pkglet automatically uncompress and unarchive
		url = "https://zlib.net/zlib-" .. pkg.version .. "-linux-x86_64.tar.xz",
	},
}

function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing zlib build...")
		end)

		hook("build")(function()
			if OPTIONS.static then
			    configure({"--static", "--prefix=/usr"})
			else
			    configure({"--prefix=/usr"})
			end
			make()
		end)

		hook("install")(function()
			make({}, false)
		end)

		hook("post_install")(function()
			print("zlib installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			exec("tar -xf zlib-" .. pkg.version .. "-linux-x86_64.tar.xz -C " .. INSTALL .. "/usr")
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
