pkg = {
	name = "org.gnu.gcc",
	version = "15.2.0",
	description = "The GNU Compiler Collection",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://gcc.gnu.org",
	depends = {},
	conflicts = { },
	provides = { "gcc", "g++", "ada", "fortran", "go", "objc", "c++", "c", "obj-c++", "m2" },
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
		url = "https://mirrors.dotsrc.org/gnu/gcc/gcc-"..pkg.version.."/gcc-"..pkg.version.."/.tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-gcc.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
            exec("sed -i 's/char [*]q/const &/' libgomp/affinity-fmt.c") -- for glibc >=2.43
            if ARCH == "x86_64" then
                exec("sed -e '/m64=/s/lib64/lib/' -i.orig gcc/config/i386/t-linux64")
            end
			local configure_opts = {
				"--prefix=/usr",
                "LD=ld",
                "--disable-multilib",
                "--with-system-zlib",
                "--enable-default-pie",
                "--enable-default-ssp",
                "--enable-host-pie",
                "--disable-fixincludes",
                "--enable-languages=c,c++,fortran,go,objc,obj-c++,m2"
			}
			local configg = OPTIONS.config or ""
			table.insert(configure_opts, configg)
			configure(configure_opts, "configure || mkdir -p build && cd build && ./configure ")
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
