pkg = {
	name = "null.lvmteam.lvm2",
	version = "2.03.39",
	description = "User-land utilities for LVM2 (device-mapper) software",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0",
	homepage = "https://gitlab.com/lvmteam/lvm2",
	depends = {"udev"},
	conflicts = {},
	provides = { "lvm", "lvm2", "device-mapper", "devicemapper", "libdevicemapper" },
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
		url = "https://gitlab.com/lvmteam/lvm2/-/archive/v"..string.gsub(pkg.version, "%.", "_").."/lvm2-v"..string.gsub(pkg.version, "%.", "_")..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-gnutar.tar.gz",
	},
}
function pkg.source()
	return function(hook)
		hook("prepare")(function()
			local configure_opts = {
				"--prefix=/usr",
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
			install({ "*", INSTALL }, "cp -r")
		end)
	end
end
