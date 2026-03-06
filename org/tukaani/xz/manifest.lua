pkg = {
	name = "org.tukaani.xz",
	version = "5.8.2",
	description = "A general-purpose data-compression library",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "0BSD",
	homepage = "https://tukaani.org/xz/",
	depends = {},
	conflicts = {},
	provides = { "xz", "xz-utils", "lzma", "lzma2", "liblzma", "xzdiff", "xzgrep", "xzdec", "xzless", "xzmore", "xzcmp", "lzmainfo" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/tukaani-project/xz/releases/download/v"..pkg.version.."/xz-"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/"..ARCH.."-xz.tar.gz",
	}
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
                "--libdir=/usr/lib64",
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
            exec("cp -r * "..INSTALL.."/")
		end)
	end
end
