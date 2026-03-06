pkg = {
	name = "org.gnu.bash",
	version = "5.3",
	description = "GNU Bourne Again Shell",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://gnu.org/software/bash",
	depends = {"org.gnu.readline", "org.gnu.ncurses"},
	conflicts = {},
	provides = { "bash", "sh" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
        static = {
			type = "boolean",
			default = false,
			description = "enable static linking",
		},
        multibyte = {
			type = "boolean",
			default = true,
			description = "enable multibyte support",
		},
        extendedglob = {
            type = "boolean",
            default = true,
            description = ""
        }
	},
}
pkg.sources = {
	source = {{
		type = "tar",
		url = "https://mirrors.dotsrc.org/gnu/bash/bash-"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	}, {
        type = "file",
        url = "https://raw.githubusercontent.com/NULL-GNU-Linux/extras/refs/heads/main/bashrc"
    }},
	binary = {{
		type = "file",
		url = "https://files.obsidianos.xyz/~odd/static/bash",
	}, {
        type = "file",
        url = "https://raw.githubusercontent.com/NULL-GNU-Linux/extras/refs/heads/main/bashrc"
    }},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
                "--libdir=/usr/lib64",
                "--with-curses",
                "--enable-readline",
                "--with-installed-readline",
			}
            if OPTIONS.static then
                table.insert(configure_opts, "--enable-static-link")
            end
            if OPTIONS.multibyte then
                table.insert(configure_opts, "--enable-multibyte")
            end 
            if OPTIONS.extendedglob then
                table.insert(configure_opts, "--enable-extended-glob-default")
            end
			local configg = OPTIONS.config or ""
			table.insert(configure_opts, configg)
			configure(configure_opts, "configure --help && CFLAGS='-DSYS_BASHRC=\"/etc/bash/bashrc\"' ./confgure")
		end)

		hook("build")(function()
            make()
		end)

		hook("install")(function()
			make({}, false)
            install({"-Dm644", "bashrc", INSTALL.."/etc/bash/bashrc"})
            exec("ln -s bash \""..INSTALL.."/usr/bin/sh\" || true")
            exec("ln -s bash \""..INSTALL.."/usr/bin/rbash\"")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			install({ "-Dm755", "bash", INSTALL.."/usr/bin/bash" })
            install({"-Dm644", "bashrc", INSTALL.."/etc/bashrc.bash"})
		end)
	end
end
