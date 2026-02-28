pkg = {
	name = "null.utillinux",
	version = "2.41.3",
	description = "Essential system utilities for Linux",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://github.com/util-linux/util-linux",
	depends = {},
	conflicts = { "org.gnu.glibc" },
	provides = { "util-linux" },
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
		werror = {
			type = "boolean",
			default = false,
			description = "make all compiler warnings into errors",
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
		url = "https://github.com/util-linux/util-linux/archive/refs/tags/v" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-util-linux.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
		    exec("./autogen.sh")
			local configure_opts = { "--prefix=/usr", "--sbindir=/usr/bin", "--bindir=/usr/bin", "CFLAGS='-Wno-error=implicit-function-declaration -D_GNU_SOURCE'", "CC='gcc -std=gnu11'" }
            if ARCH == "x86_64" or ARCH == "aarch64" then
                table.insert(configure_opts, "--libdir=/usr/lib64")
            else 
                table.insert(configure_opts, "--libdir=/usr/lib")
            end
			if OPTIONS.disable_static then
				table.insert(configure_opts, "--disable-static")
			end
			if OPTIONS.werror then
				table.insert(configure_opts, "--enable-werror")
			end
			if OPTIONS.disable_shared then
				table.insert(configure_opts, "--disable-shared")
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
			exec("mkdir -p " .. INSTALL .. "/usr/")
			install({"*",INSTALL}, "cp -r")
		end)
	end
end
