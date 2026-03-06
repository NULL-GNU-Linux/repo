pkg = {
	name = "org.nongnu.acl",
	version = "2.3.2",
	description = "Access control list utilities, libraries, and headers",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-2.1 or GPL-2.0",
	homepage = "https://savannah.nongnu.org/projects/acl",
	depends = {},
	conflicts = {},
	provides = { "acl" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
        disable_nls = {
			type = "boolean",
			default = false,
			description = "disables NLS (Native Language Support)",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://download.savannah.nongnu.org/releases/acl/acl-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/"..ARCH.."-acl.tar.gz",
	}
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
                "--libdir=/usr/lib64",
			}
            if OPTIONS.disable_nls then
                table.insert(configure_opts, "--disable-nls")
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
			exec("cp -r * "..INSTALL.."/")
		end)
	end
end
