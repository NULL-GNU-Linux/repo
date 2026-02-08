pkg = {
	name = "com.git-scm.git",
	version = "2.51.0",
	description = "A free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://git-scm.com",
	depends = {},
	conflicts = {},
	provides = { "git" },
	options = {
		static = {
			type = "boolean",
			default = false,
			description = "compile git statically",
		},
	},
}

pkg.sources = {
	binary = {
		type = "tar",
		url = "https://example.com/something.tar.gz",
	},
	source = {
		type = "tar",
		url = "https://www.kernel.org/pub/software/scm/git/git-" .. pkg.version .. ".tar.gz",
	},
}

function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing kernel build...")
		end)

		hook("build")(function()
			local static = ""
			if OPTIONS.static then
				static = "LD_FLAGS='-static'"
			else
				static = ""
			end
			configure({
				static,
				"NO_SHARED=1",
				"--prefix=/usr",
				"--with-openssl",
				"--with-curl",
				"--with-expat",
			})
			make()
		end)

		hook("install")(function()
			make()
		end)
	end
end

function pkg.binary()
	return function(hook) end
end

function pkg.uninstall()
	return function(hook) end
end
