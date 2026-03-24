pkg = {
	name = "com.redhat.audit",
	version = "4.1.4",
	description = "The Linux Audit System",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "GPL-2.0 or LGPL-2.1",
	homepage = "https://github.com/Linux-Audit/Audit-userspace",
	depends = {"coreutils", "python3"},
	conflicts = {},
	provides = { "audit-daemon", "audit" },
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/linux-audit/audit-userspace/archive/refs/tags/v"..pkg.version..".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://files.obsidianos.xyz/~neo/null/" .. ARCH .. "-audit.tar.gz",
	},
}
function pkg.source()
	return function(hook)
        hook("prepare")(function ()
            exec("autoreconf -f --install")
            configure({"--with-python3=yes", "--prefix=/usr", "--sbindir=/usr/bin", "--libdir=/usr/lib"})
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
