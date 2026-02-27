pkg = {
	name = "null.basefs",
	version = "1.0.0",
	description = "Base filesystem structure for NULL",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "Unlicense",
	homepage = "https://null.obsidianos.xyz",
	depends = {},
	conflicts = {},
	provides = { "base-fs", "basefilesystem", "basefs", "group" },
	options = {},
}
pkg.sources = {
	binary = {
		type = "git",
		url = "https://github.com/NULL-GNU-Linux/basefs",
	},
	source = {
		type = "git",
		url = "https://github.com/NULL-GNU-Linux/basefs",
	},
}

function basefs()
    local cdpath = "cd " .. INSTALL .. " && "
	exec(
		cdpath .. " && mkdir -p usr/bin usr/lib usr/local/bin usr/local/lib usr/local/share opt/bin usr/lib64 home var/spool/main var/www root proc sys var/cache var/db var/tmp srv boot efi/EFI mnt opt media run etc"
	)
	exec(cdpath.."ln -s usr/bin bin")
	exec(cdpath.."ln -s usr/local/bin usr/local/sbin")
	exec(cdpath.."ln -s usr/bin sbin")
	exec(cdpath.."ln -s usr/lib lib")
	exec(cdpath.."ln -s usr/lib64 lib64")
	exec(cdpath.."ln -s usr/bin usr/sbin")
	exec(cdpath.."ln -s var/tmp tmp")
	install({ "env.d", INSTALL .. "/etc/" }, "cp -r")
	install({ "passwd", "-m 644", "--target-directory=" .. INSTALL .. "/etc/" })
	install({ "shadow", "-m 644", "--target-directory=" .. INSTALL .. "/etc/" })
	install({ "group", "-m 644", "--target-directory=" .. INSTALL .. "/etc/" })
	install({ "os-release", "-m 644", "--target-directory=" .. INSTALL .. "/etc/" })
	install({ "issue", "-m 644", "--target-directory=" .. INSTALL .. "/etc/" })
	install({ "hostname", "-m 644", "--target-directory=" .. INSTALL .. "/etc/" })
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
			basefs()
		end)
	end
end

function pkg.source()
	return function(hook)
		hook("install")(function()
			basefs()
		end)
	end
end
