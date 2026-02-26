pkg = {
	name = "com.redhat.efibootmgr",
	version = "18",
	description = "Linux user-space application to modify the EFI Boot Manager",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0-or-later",
	homepage = "https://github.com/rhboot/efivar",
	depends = { "efivar", "org.rpm.popt" },
	conflicts = {},
	provides = { "efibootmgr" },
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/rhboot/efibootmgr/archive/refs/tags/" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://archlinux.org/packages/core/x86_64/efibootmgr/download",
	},
}
function pkg.source()
	return function(hook)
        hook("build")(function()
			make({"libdir=/usr/lib", "sbindir=/usr/bin", "EFIDIR=null"})
		end)

		hook("install")(function()
            local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			make({"libdir=/usr/lib/", "sbindir=/usr/bin/", "EFIDIR=null"}, false)
            install({"-Dm 644", "README.md", "--target-directory="..path.."usr/share/doc/efibootmgr/"})
            install({"-Dm 644", "TODO", "--target-directory="..path.."usr/share/doc/efibootmgr/"})
            install({"-Dm 644", "AUTHORS", "--target-directory="..path.."usr/share/doc/efibootmgr/"})
            install({"-Dm 644", "README", "--target-directory="..path.."usr/share/doc/efibootmgr/"})
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
            install({"usr/*", path .. "/usr/"}, "cp -r")
		end)
	end
end
