pkg = {
	name = "com.redhat.efivar",
	version = "39",
	description = "Tools and libraries to work with EFI variables",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "LGPL-2.1",
	homepage = "https://github.com/rhboot/efivar",
	depends = { "libc" },
	conflicts = {},
	provides = { "efivar" },
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/rhboot/efivar/archive/refs/tags/" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://archlinux.org/packages/core/x86_64/efivar/download",
	},
}
function pkg.source()
	return function(hook)
        hook("build")(function()
			make({"ERRORS=''"})
		end)

		hook("install")(function()
			make({"libdir=/usr/lib/", "bindir=/usr/bin/", "mandir=/usr/share/man/", "includedir=/usr/include/"}, false)
            install({"-Dm 644", "README.md", "--target-directory="..INSTALL.."usr/share/doc/efivar/"})
            install({"-Dm 644", "TODO", "--target-directory="..INSTALL.."usr/share/doc/efivar/"})
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
            exec("cd "..INSTALL.." && mkdir -p usr")
            install({"usr/*", INSTALL .. "/usr/"}, "cp -r")
		end)
	end
end
