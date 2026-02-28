pkg = {
	name = "org.gnu.mpc",
	version = "1.3.1",
	description = "A library for multiprecision complex arithmetic with exact rounding",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-3.0",
	homepage = "https://www.multiprecision.org/mpc/",
	depends = {"org.gnu.mpfr", "org.gnu.gmp"},
	conflicts = { },
	provides = { "mpc" },
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
		url = "https://mirrors.dotsrc.org/gnu/mpc/mpc-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-mpc.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
            exec("mkdir -p build")
			local configure_opts = {
				"--prefix=/usr",
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
