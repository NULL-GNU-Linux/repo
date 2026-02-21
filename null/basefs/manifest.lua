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
}

function basefs()
	local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
	exec(
		"cd "
			.. path
			.. " && mkdir -p usr/bin usr/lib usr/lib64 home var/spool/main var/www root proc sys var/cache var/db var/tmp srv boot mnt opt media run etc"
	)
	exec("cd " .. path .. " && ln -s usr/bin bin")
	exec("cd " .. path .. " && ln -s usr/bin sbin")
	exec("cd " .. path .. " && ln -s usr/lib lib")
	exec("cd " .. path .. " && ln -s usr/lib64 lib64")
	exec("cd " .. path .. " && ln -s usr/bin usr/sbin")
	exec("cd " .. path .. " && ln -s var/tmp tmp")
	install({ "passwd", "-m 644", "--target-directory=" .. path .. "/etc/" })
	install({ "shadow", "-m 644", "--target-directory=" .. path .. "/etc/" })
	install({ "group", "-m 644", "--target-directory=" .. path .. "/etc/" })
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
