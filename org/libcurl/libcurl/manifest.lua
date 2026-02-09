pkg = {
	name = "org.libcurl.libcurl",
	version = "8.18.0",
	description = "Command line tool and library for transferring data with URLs",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "curl",
	homepage = "https://curl.se",
	depends = {"org.openssl.libssl", "net.zlib"},
	conflicts = {},
	provides = {"libcurl", "curl"},
	options = {
		static = {
			type = "boolean",
			default = false,
			description = "Build static library",
		},
		tools = {
			type = "boolean",
			default = true,
			description = "Build command line tools",
		},
		ssh = {
			type = "boolean",
			default = false,
			description = "Enable SSH support",
		},
	},
}

pkg.sources = {
	source = {
		type = "tar",
		url = "https://curl.se/download/curl-" .. pkg.version .. ".tar.xz",
	},
	binary = {
		type = "file",
		url = "https://files.obsidianos.xyz/~odd/static/curl",
	},
}

function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing curl build...")
		end)

		hook("build")(function()
			local configure_opts = {"--prefix=/usr", "--with-ssl=/usr", "--with-zlib=/usr"}
			if OPTIONS.static then
				table.insert(configure_opts, "--enable-static")
				table.insert(configure_opts, "--disable-shared")
			else
				table.insert(configure_opts, "--enable-shared")
			end
			if not OPTIONS.tools then
				table.insert(configure_opts, "--disable-tool")
			end
			if OPTIONS.ssh then
				table.insert(configure_opts, "--with-libssh")
			end
			configure(configure_opts)
			make()
		end)

		hook("install")(function()
			make({}, false)
		end)

		hook("post_install")(function()
			print("curl installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
		    local path = CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name
		    exec("mkdir -p " .. path .. "/usr/bin/")
		    install({"curl", "--target-directory=" .. path .. "/usr/bin/"})
		end)
	end
end

function pkg.uninstall()
	return function(hook)
		hook("pre_uninstall")(function()
			print("Pre-uninstall cleanup...")
		end)

		hook("post_uninstall")(function()
			print("curl uninstalled")
		end)
	end
end
