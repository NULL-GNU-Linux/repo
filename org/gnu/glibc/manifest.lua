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
		url = "https://mirrors.dotsrc.org/gnu/glibc/glibc-"..pkg.version..".tar.xz",
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
            exec("mkdir -p build")
			configure(configure_opts, "configure || cd build && ../configure")
		end)

		hook("build")(function()
            make({}, true, nil, "cd build &&")
		end)

		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			make({}, false, nil, "cd build &&")
            exec("cd "..path.." && mkdir -p usr/lib64 usr/bin")
            exec("cd "..path.." && mv lib64/* usr/lib64/")
            exec("cd "..path.." && mv sbin/* usr/bin/")
            exec("cd "..path.." && mv usr/sbin/* usr/bin/")
            exec("cd "..path.." && rm -rf sbin lib64 usr/sbin")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			install({ "*", path }, "cp -r")
		end)
	end
end
