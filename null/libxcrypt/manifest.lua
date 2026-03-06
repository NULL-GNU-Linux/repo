pkg = {
	name = "null.libxcrypt",
	version = "4.5.2",
	description = "A modern library for one-way hashing of passwords",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-2.1",
	homepage = "https://github.com/besser82/libxcrypt",
	depends = {},
	conflicts = {},
	provides = { "libxcrypt", "xcrypt", "crypt", "libcrypt", "crypt_r" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/besser82/libxcrypt/releases/download/v"..pkg.version.."/libxcrypt-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/"..ARCH.."-libxcrypt.tar.gz",
	}
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
                "--libdir=/usr/lib64",
			}
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
            exec("cp -r * "..INSTALL.."/")
		end)
	end
end
