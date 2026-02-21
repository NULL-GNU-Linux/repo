pkg = {
	name = "org.libc.musl",
	version = "1.2.5",
	description = "musl is lightweight, fast, simple, free, and strives to be correct in the sense of standards-conformance and safety.",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "MIT",
	homepage = "https://musl.libc.org",
	depends = {},
	conflicts = { "org.gnu.glibc" },
	provides = { "linker", "ld-linux", "libc", "musl", "musl-libc" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
		disable_static = {
			type = "boolean",
			default = false,
			description = "disables compiling statically",
		},
		wrapper = {
			type = "boolean",
			default = true,
			description = "produces musl-gcc wrapper",
		},
		disable_shared = {
			type = "boolean",
			default = false,
			description = "disables compiling shared libs",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://musl.libc.org/releases/musl-" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://musl.cc/" .. ARCH .. "-linux-musl-native.tgz",
		args = "--strip-components=1",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = { "--prefix=/usr" }
			if OPTIONS.disable_static then
				table.insert(configure_opts, "--disable-static")
			end
			if OPTIONS.wrapper then
				table.insert(configure_opts, "--enable-wrapper=all")
			end
			if OPTIONS.disable_shared then
				table.insert(configure_opts, "--disable-shared")
			end
			configure(configure_opts)
		end)

		hook("build")(function()
			make({ "syslibdir=/usr/lib" })
		end)

		hook("install")(function()
			make({}, false)
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			install({ "bin", path .. "/usr/" }, "cp -r")
			install({ "lib", path .. "/usr/" }, "cp -r")
			install({ "libexec", path .. "/usr/" }, "cp -r")
			install({ "include", path .. "/usr/" }, "cp -r")
			install({ "share", path .. "/usr/" }, "cp -r")
			install({ "*-linux-musl", path .. "/usr/" }, "cp -r")
		end)
	end
end
