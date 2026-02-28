pkg = {
	name = "org.gnu.grub",
	version = "2.14",
	description = "GNU GRand Unified Bootloader",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://gnu.org/software/grub",
	depends = {},
	conflicts = { },
	provides = { "grub", "bootloader", "bl", "bootmanager", "grub-common", "grub-efi", "grub-bios" },
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
        },
        device_mapper = {
            type = "boolean",
            default = false,
            description = "enable DeviceMapper support"
        },
        nls = {
            type = "boolean",
            default = true,
            description = "enable NLS"
        }
	},
}
pkg.sources = {
	source = {{
		type = "tar",
		url = "https://mirrors.dotsrc.org/gnu/grub/grub-"..pkg.version..".tar.xz",
		args = "--strip-components=1",
	}, {
        type = "tar",
        url = "https://repo.or.cz/grub-extras.git/snapshot/8a245d5c1800627af4cefa99162a89c7a46d8842.tar.gz",
    }},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-grub.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
            exec("rm -rf grub-extras/lua")
            curl("https://raw.githubusercontent.com/NULL-GNU-Linux/extras/refs/heads/main/grub", "grub.default", {"-fsSL"})
            exec("sed -i '1i /^PO-Revision-Date:/ d' po/*.sed")
            exec("sed 's|/usr/share/fonts/dejavu|/usr/share/fonts/dejavu /usr/share/fonts/TTF|g' -i \"configure.ac\"")
            exec("./linguas.sh")
            exec("echo depends bli part_gpt > grub-core/extra_deps.lst")
			local configure_opts = {
				"--prefix=/usr",
                "--sbindir=/usr/bin",
                "--sysconfdir=/etc",
                "--disable-efiemu",
                "--enable-boot-time",
                "--enable-cache-stats",
                "--disable-werror",
                "--with-bootdir=\"/boot\"",
                "--with-grubdir=\"grub\"",
                "--enable-boot-time",
                "PACKAGE_VERSION="..pkg.version,
                "--target="..ARCH
			}
            if OPTIONS.uefi then
                table.insert(configure_opts, "--with-platform=\"efi\"")
            else
                table.insert(configure_opts, "--with-platform=\"pc\"")
            end               
            if OPTIONS.device_mapper then
                table.insert(configure_opts, "--enable-device-mapper")
            end
            if OPTIONS.nls then
                table.insert(configure_opts, "--enable-nls")
            else
                table.insert(configure_opts, "--disable-nls")
            end
			local configg = OPTIONS.config or ""
			table.insert(configure_opts, configg)
			configure(configure_opts)
		end)

		hook("build")(function()
            make()
		end)

		hook("install")(function()
			make({"bashcompletiondir=/usr/share/bash-completion/completions"}, false)
            exec("mkdir -p "..INSTALL.."/usr/bin/ "..INSTALL.."/etc/default/")
            install({"-m755", "grub-mount", INSTALL.."/usr/bin/"})
            install({"-m755", "grub-mkfont", INSTALL.."/usr/bin/"})
            install({"-m644", "grub.defaullt", INSTALL.."/etc/default/grub"})
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
