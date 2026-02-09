pkg = {
	name = "org.libpng.png",
	version = "1.6.44",
	description = "Official PNG reference library",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "libpng-2.0",
	homepage = "https://libpng.org",
	depends = {"net.zlib"},
	conflicts = {},
	provides = {"libpng", "png"},
	options = {
		static = {
			type = "boolean",
			default = false,
			description = "Build static library",
		},
		tests = {
			type = "boolean",
			default = false,
			description = "Build test programs",
		},
	},
}

pkg.sources = {
	source = {
		type = "tar",
		url = "https://download.sourceforge.net/libpng/libpng-" .. pkg.version .. ".tar.xz",
	},
	binary = {
		type = "file",
		url = "https://download.sourceforge.net/libpng/libpng-" .. pkg.version .. "-linux-x86_64.tar.xz",
	},
}

function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing libpng build...")
		end)

		hook("build")(function()
			local configure_opts = "--prefix=/usr"
			if OPTIONS.static then
				configure_opts = configure_opts .. " --enable-static"
			end
			if not OPTIONS.tests then
				configure_opts = configure_opts .. " --disable-test"
			end
			configure(configure_opts)
			make()
		end)

		hook("install")(function()
			make({}, false)
		end)

		hook("post_install")(function()
			print("libpng installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			exec("tar -xf libpng-" .. pkg.version .. "-linux-x86_64.tar.xz -C " .. ROOT .. "usr")
		end)
	end
end

function pkg.uninstall()
	return function(hook)
		hook("pre_uninstall")(function()
			print("Pre-uninstall cleanup...")
		end)

		hook("post_uninstall")(function()
			print("libpng uninstalled")
		end)
	end
end
