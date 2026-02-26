pkg = {
	name = "org.rpm.popt",
	version = "1.19",
	description = "A commandline option parser",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "MIT",
	homepage = "https://github.com/rpm-software-management/popt",
	depends = {"libc"},
	conflicts = {},
	provides = { "popt" },
}
pkg.sources = {
	source = {
		type = "tar",
		url = "https://ftp.osuosl.org/pub/rpm/popt/releases/popt-1.x/popt-" .. pkg.version .. ".tar.gz",
		args = "--strip-components=1",
	},
	binary = {
		type = "tar",
		url = "https://archlinux.org/packages/core/x86_64/popt/download",
	},
}
function pkg.source()
	return function(hook)
        hook("prepare")(function()
            configure({"--prefix=/usr"})
        end)
        hook("build")(function()
			make()
		end)

		hook("install")(function()
            local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
			make({}, false)
            exec("mkdir -p " .. path .. "usr/share/licenses/popt")
            install({"-Dm 644", "COPYING", path.."usr/share/licenses/popt/LICENSE"})
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
            exec("cd "..path.." && mkdir -p usr")
            install({"usr/*", path .. "/usr/"}, "cp -r")
		end)
	end
end
