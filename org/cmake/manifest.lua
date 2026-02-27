pkg = {
	name = "org.cmake",
	version = "4.2.3",
	description = "Cross-platform build system generator",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "BSD-3-Clause",
	homepage = "https://cmake.org",
	depends = {"org.openssl.libssl", "net.zlib", "se.curl.libcurl"},
	conflicts = {},
	provides = {"cmake"},
	options = {
		gui = {
			type = "boolean",
			default = false,
			description = "Build Qt-based GUI",
		},
	},
}

pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/Kitware/CMake/releases/download/v" .. pkg.version .. "/cmake-" .. pkg.version .. ".tar.gz",
	},
	binary = {
		type = "file",
		url = "https://github.com/Kitware/CMake/releases/download/v" .. pkg.version .. "/cmake-" .. pkg.version .. "-linux-x86_64.sh",
	},
}

function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing CMake build...")
		end)

		hook("build")(function()
			configure({"--prefix=/usr", "--mandir=/usr/share/man", "--docdir=/usr/share/doc/cmake", "--system-libs"})
			if OPTIONS.gui then
				configure({"--prefix=/usr", "--mandir=/usr/share/man", "--docdir=/usr/share/doc/cmake", "--system-libs", "--qt-gui"})
			end
			make()
		end)

		hook("install")(function()
			make({}, false)
		end)

		hook("post_install")(function()
			print("CMake installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			exec("sh cmake-" .. pkg.version .. "-linux-x86_64.sh --skip-license --prefix=" .. INSTALL .. "/usr")
		end)
	end
end

function pkg.uninstall()
	return function(hook)
		hook("pre_uninstall")(function()
			print("Pre-uninstall cleanup...")
		end)

		hook("post_uninstall")(function()
			print("CMake uninstalled")
		end)
	end
end
