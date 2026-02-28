pkg = {
	name = "org.gnu.ncurses",
	version = "6.6",
	description = "System V Release 4.0 curses emulation library",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "MIT",
	homepage = "https://invisible-island.net/ncurses/",
	depends = {},
	conflicts = {},
	provides = { "ncurses", "clear", "tput", "tabs", "infocmp", "tset", "tic", "toe" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
        widec = {
			type = "boolean",
			default = true,
			description = "wide character support",
		},
        cxx = {
			type = "boolean",
			default = true,
			description = "enable CXX bindings",
		},
        ext_colors = {
			type = "boolean",
			default = true,
			description = "enable extended colors",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://mirrors.dotsrc.org/gnu/ncurses/ncurses-"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-ncurses.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
                "--libdir=/usr/lib64",
                "--with-shared",
                "--without-debug",
                "--enable-pc-files",
                "--disable-werror",
                "--with-pkg-config-libdir=/usr/lib64/pkgconfig"
			}
            if OPTIONS.widec then
                table.insert(configure_opts, "--enable-widec")
            end
            if OPTIONS.cxx then
                table.insert(configure_opts, "--with-cxx-binding")
            end 
            if OPTIONS.ext_colors then
                table.insert(configure_opts, "--enable-ext-colors")
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
