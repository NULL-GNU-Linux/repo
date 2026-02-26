pkg = {
	name = "null.limine",
	version = "10.8.2",
	description = "Modern, advanced, portable, multiprotocol bootloader and boot manager.",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "BSD-2-Clause",
	homepage = "https://codeberg.org/Limine/Limine",
	depends = {},
	conflicts = {},
	provides = { "limine", "bootloader", "bl", "bootmanager", "boot-manager" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
	    bios = {
			type = "boolean",
			default = false,
			description = "enables BIOS support",
		},
        uefi = {
            type = "boolean",
            default = true,
            description = "enables UEFI support"
        },
        all = {
            type = "boolean",
            default = false,
            description = "enables ALL ports and targets"
        }
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://codeberg.org/Limine/Limine/releases/download/v" .. pkg.version .. "/limine-" .. pkg.version .. ".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://codeberg.org/Limine/Limine/archive/v" .. pkg.version .. "-binary.tar.gz",
		args = "--strip-components=1",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = { "--prefix=/usr" }
			if OPTIONS.bios then
				table.insert(configure_opts, "--enable-bios")
			end
			if OPTIONS.uefi then
				table.insert(configure_opts, "--enable-uefi-" .. ARCH)
			end
			if OPTIONS.all then
				table.insert(configure_opts, "--enable-all")
			end
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
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			exec("mkdir -p usr/bin/ efi/EFI usr/lib/limine usr/share/limine usr/include")
            exec("make") -- no need for pkglet's specific make()
            install({"limine", "--target-directory="..path.."/usr/bin/"})
            if OPTIONS.uefi then
                install({"BOOT*.EFI", "--target-directory="..path.."/efi/EFI/"})
                install({"BOOT*.EFI", "--target-directory="..path.."/usr/share/limine/"})
            end
            if OPTIONS.bios then
                install({"limine-bios-*.bin", "--target-directory="..path.."/usr/lib/limine/"})
                install({"*.sys", "--target-directory="..path.."/usr/lib/limine/"})
                install({"*.h", "--target-directory="..path.."/usr/include/"})
            end
		end)
	end
end
