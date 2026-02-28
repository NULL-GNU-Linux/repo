pkg = {
	name = "org.gnu.gmp",
	version = "6.3.0",
	description = "The GNU Multiple Precision Arithmetic Library",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-3.0 and GPL-2.0",
	homepage = "https://gmplib.org",
	depends = {},
	conflicts = { },
	provides = { "gmp" },
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
		url = "https://mirrors.dotsrc.org/gnu/gmp/gmp-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-gmp.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
            exec("mkdir -p build")
			local configure_opts = {
				"--prefix=/usr",
                "--enable-cxx",
                "CC='gcc -std=gnu17'"
			}
			local configg = OPTIONS.config or ""
			table.insert(configure_opts, configg)
			configure(configure_opts, "configure --fail-please || cd build && ../configure ")
		end)

		hook("build")(function()
            make({}, true, nil, "cd build &&")
		end)

		hook("install")(function()
			make({}, false, nil, "cd build &&")
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
