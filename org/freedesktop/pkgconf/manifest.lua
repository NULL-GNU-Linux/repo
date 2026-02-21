pkg = {
	name = "org.freedesktop.pkgconf",
	version = "2.5.1",
	description = "musl is lightweight, fast, simple, free, and strives to be correct in the sense of standards-conformance and safety.",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://musl.libc.org",
	depends = {},
	conflicts = {},
	provides = { "pkgconf", "pkg-config" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
		static = {
			type = "boolean",
			default = true,
			description = "enables compiling statically",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://distfiles.ariadne.space/pkgconf/pkgconf-" .. pkg.version .. ".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-pkgconfig.tar.xz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = { "--prefix=/usr" }
			if OPTIONS.static then
				table.insert(configure_opts, "--enable-static")
			end
			configure(configure_opts)
		end)

		hook("build")(function()
			make()
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
			install({ "usr/*", path .. "/usr/" }, "cp -r")
		end)
	end
end
