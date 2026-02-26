pkg = {
	name = "org.gnu.glibc",
	version = "2.43",
	description = "GNU libc C library",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-2.1",
	homepage = "https://gnu.org/software/libc",
	depends = {},
	conflicts = { "org.libc.musl" },
	provides = { "libc", "glibc", "ld-linux", "linker", "gnulibc", "gnu-libc" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
		shared = {
			type = "boolean",
			default = false,
			description = "enable shared library (default if GNU ld)",
		},
		memtag = {
			type = "boolean",
			default = false,
			description = "enables memory tagging if supported by the architecture",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/bminor/glibc/archive/refs/tags/glibc-" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-glibc.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
			}
			if OPTIONS.shared then
				table.insert(configure_opts, "--enable-shared")
			end
			if OPTIONS.memtag then
				table.insert(configure_opts, "--enable-memory-tagging")
			end
			local configg = OPTIONS.config or ""
			table.insert(configure_opts, configg)
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
			exec("mkdir -p " .. path .. "/usr/")
			install({ "usr/*", path .. "/usr/" }, "cp -r")
		end)
	end
end
