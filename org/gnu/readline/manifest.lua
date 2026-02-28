pkg = {
	name = "org.gnu.readline",
	version = "8.3",
	description = "Another cute console display library",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://git.savannah.gnu.org/cgit/readline.git",
	depends = {},
	conflicts = {},
	provides = { "readline" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
        static = {
			type = "boolean",
			default = true,
			description = "enable static",
		},
        multibyte = {
			type = "boolean",
			default = true,
			description = "enable multibyte support",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://mirrors.dotsrc.org/gnu/readline/readline-"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-readline.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
                "--libdir=/usr/lib64",
			}
            if OPTIONS.static then
                table.insert(configure_opts, "--enable-static")
            end
            if not OPTIONS.multibyte then
                table.insert(configure_opts, "--disable-multibyte")
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
			install({ "*", INSTALL }, "cp -r")
		end)
	end
end
