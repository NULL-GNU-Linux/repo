pkg = {
	name = "org.openssl.libssl",
	version = "3.6.1",
	description = "Cryptography and SSL/TLS toolkit",
	maintainer = "NEOAPPS <neo@obsidianos.xyz>",
	license = "Apache-2.0",
	homepage = "https://openssl.org",
	depends = {},
	conflicts = {},
	provides = {"libssl", "openssl", "libcrypto"},
	options = {
		static = {
			type = "boolean",
			default = false,
			description = "Build static library",
		},
		tests = {
			type = "boolean",
			default = false,
			description = "Build test programs",
		},
		fips = {
			type = "boolean",
			default = false,
			description = "Enable FIPS module",
		},
	},
}

pkg.sources = {
	source = {
		type = "tar",
		url = "https://github.com/openssl/openssl/releases/download/openssl-" .. pkg.version .. "/openssl-" .. pkg.version .. ".tar.gz",
	},
	binary = {
		type = "file",
		url = "https://files.obsidianos.xyz/~odd/static/openssl", -- static build of openssl by TheOddCell
	},
}

function pkg.source()
	return function(hook)
		hook("prepare")(function()
			print("Preparing OpenSSL build...")
		end)

		hook("build")(function()
			local configure_opts = {"--prefix=/usr", "--openssldir=/etc/ssl", "linux-x86_64"}
			if OPTIONS.static then
				table.insert(configure_opts, "no-shared")
			end
			if not OPTIONS.tests then
				table.insert(configure_opts, "no-tests")
			end
			if OPTIONS.fips then
				table.insert(configure_opts, "enable-fips")
			end
			configure(configure_opts)
			make()
		end)

		hook("install")(function()
			make({}, false)
		end)

		hook("post_install")(function()
			print("OpenSSL installed successfully")
		end)
	end
end

function pkg.binary()
	return function(hook)
		hook("install")(function()
		    install({"openssl", "--target-directory=" .. CONFIG.TEMP_INSTALL_PATH .. "/" .. pkg.name .. "/usr/bin/"})
		end)
	end
end

function pkg.uninstall()
	return function(hook)
		hook("pre_uninstall")(function()
			print("Pre-uninstall cleanup...")
		end)

		hook("post_uninstall")(function()
			print("OpenSSL uninstalled")
		end)
	end
end
