pkg = {
	name = "org.gnu.make",
	version = "4.4.1",
	description = "A tool which controls the generation of executables and other non-source files of a program from the program's source files",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://gnu.org/software/make",
	depends = { "sh" },
	conflicts = {},
	provides = { "gmake", "gnumake", "make", "gnu-make" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
		static = {
			type = "boolean",
			default = false,
			description = "compiles make statically",
		},
		disable_nls = {
			type = "boolean",
			default = false,
			description = "disables localization (gettext)",
		},
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://ftp.gnu.org/gnu/make/make-" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-gnu-make.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = { "--prefix=/usr" }
			if OPTIONS.static then
				table.insert(configure_opts, "LDFLAGS='-static'")
			end
			if OPTIONS.disable_nls then
				table.insert(configure_opts, "--disable-nls")
			end
			local configg = OPTIONS.config or ""
			table.insert(configure_opts, configg)
			configure(configure_opts)
		end)

		hook("build")(function()
			configure({}, "sh build.sh")
		end)

		hook("install")(function()
			make({}, false)
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			exec("mkdir -p " .. path .. "/usr/bin " .. path .. "/usr/share")
			install({ "bin", path .. "/usr/" }, "cp -r")
			install({ "share", path .. "/usr/" }, "cp -r")
		end)
	end
end
