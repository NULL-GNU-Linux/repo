pkg = {
	name = "null.limine.entrytool",
	version = "1.30.0",
	description = "Entry management for the Limine bootloader.",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-3.0",
	homepage = "https://gitlab.com/Zesko/limine-entry-tool",
	depends = {"null.limine", "com.redhat.efibootmgr"},
	conflicts = {},
	provides = { "limine-entry-tool", "limine-install", "limine-scan", "limine-update", "limine-enroll-config", "limine-reset-enroll" },
}
pkg.sources = {
	binary = {
		type = "tar",
        url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-limine-entry-tool.tar.gz" -- based on https://packages.cachyos.org/package/cachyos/x86_64/limine-entry-tool
	},
}

function pkg.binary()
	return function(hook)
		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
            exec("cp -r usr " .. path)
            exec("cp -r etc " .. path)
		end)
	end
end
