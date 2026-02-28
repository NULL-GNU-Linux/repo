pkg = {
	name = "org.gnu.grub",
	version = "2.14",
	description = "The GNU Compiler Collection",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://gcc.gnu.org",
	depends = {},
	conflicts = { },
	provides = { "grub", "bootloader", "bl", "bootmanager" },
	options = {
		config = {
			type = "string",
			default = "",
			description = "extra configuration options to pass to ./configure",
		},
        uefi = {
            type = "boolean",
            default = true,
            description = "enable UEFI support"
        }
	},
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://mirrors.dotsrc.org/gnu/grub/grub-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-grub.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
            exec("echo depends bli part_gpt > grub-core/extra_deps.lst")
			local configure_opts = {
				"--prefix=/usr",
                "--sysconfdir=/etc",
                "--disable-efiemu",
                "--disable-werror",
                "--target="..ARCH
			}
            if OPTIONS.uefi then
                table.insert(configure_opts, "--with-platform=efi")
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
            exec("mkdir -p "..INSTALL.."/usr/bin/ "..INSTALL.."/usr/share/grub/")
            install({"-m755", "grub-mount", INSTALL.."/usr/bin/"})
            install({"-m755", "grub-mkfont", INSTALL.."/usr/bin/"})
            install({"-m644", "ascii.h", "widthspec.h", "*.pf2", INSTALL.."/usr/share/grub/"})
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
