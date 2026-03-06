pkg = {
	name = "org.nongnu.attr",
	version = "2.5.2",
	description = "Extended attributes tools",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-2.1",
	homepage = "https://savannah.nongnu.org/projects/attr",
	depends = {},
	conflicts = {},
	provides = { "attr" },
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
		url = "https://download.savannah.nongnu.org/releases/attr/attr-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/"..ARCH.."-attr.tar.gz",
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
