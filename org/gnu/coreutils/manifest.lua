pkg = {
	name = "org.gnu.coreutils",
	version = "9.9",
	description = "GNU Core Utilities",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://gnu.org/software/coreutils",
	depends = {},
	conflicts = {},
	provides = {
        "coreutils",
        		"ls",
				"cat",
				"cp",
				"mv",
				"rm",
				"mkdir",
				"rmdir",
				"ln",
				"touch",
				"chmod",
				"chown",
				"chgrp",
				"dd",
				"df",
				"du",
				"echo",
				"false",
				"true",
				"pwd",
				"sync",
				"uname",
				"hostname",
				"sleep",
				"basename",
				"dirname",
				"head",
				"tail",
				"cut",
				"sort",
				"uniq",
				"wc",
				"tr",
				"tee",
				"yes",
				"seq",
				"printenv",
				"env",
				"id",
				"whoami",
				"groups",
				"users",
				"who",
				"date",
				"test",
				"[",
				"expr",
				"factor",
				"md5sum",
				"sha1sum",
				"sha256sum",
				"sha512sum",
				"b2sum",
				"base64",
				"base32",
				"stat",
				"readlink",
				"realpath",
				"nohup",
				"nice",
				"stty",
				"tty",
				"mktemp",
				"install",
				"shred",
				"timeout",
				"truncate",
				"split",
				"csplit",
				"paste",
				"join",
				"fmt",
				"pr",
				"fold",
				"expand",
				"unexpand",
				"nl",
				"od",
				"ptx",
				"tsort",
				"shuf",
				"numfmt",
				"comm",
				"pathchk",
				"pinky",
				"logname",
				"chcon",
				"runcon",
				"mkfifo",
				"mknod",
				"link",
				"unlink",
				"dir",
				"vdir",
				"dircolors",
    },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		}
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://mirrors.dotsrc.org/gnu/coreutils/coreutils-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-coreutils.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
                "ac_cv_header_stropts_h=no"
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
			install({ "*", INSTALL }, "cp -r")
		end)
	end
end
