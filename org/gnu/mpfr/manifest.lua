pkg = {
	name = "org.gnu.mpfr",
	version = "4.2.2",
	description = "Library for multiple-precision floating-point computations with exact rounding",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-3.0",
	homepage = "https://www.mpfr.org",
	depends = {},
	conflicts = { },
	provides = { "mpfr", "mpfrcx" },
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
		url = "https://mirrors.dotsrc.org/gnu/mpfr/mpfr-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-mpfr.tar.gz",
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
