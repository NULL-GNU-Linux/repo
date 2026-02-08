# `repo`
This is the main NULL GNU/Linux [pkglet](https://github.com/NULL-GNU-Linux/pkglet) repo.

## How to add it?
By running the following commands that append the repo to the config and clones the repo:
```sh
echo "main /var/db/pkglet/repos/main" | sudo tee /etc/pkglet/repos.conf
sudo mkdir -p /var/db/pkglet/repos/
sudo git config --global --add safe.directory /var/db/pkglet/repos/main
sudo git clone https://github.com/NULL-GNU-Linux/repo /var/db/pkglet/repos/main
```

## How to update it via pkglet?
By running the following command:
```sh
sudo pkglet S
```

## How does a pkglet repo look like?
Like this repo. Packages are in reversed Internet domain name convention. So, for example, if your domain is `myapp.example.com`, package name will be `com.example.myapp`.
As you can see in this repo, we have this example:
```
org/kernel/linux   # pkglet interprets . as a directory
```

## How to submit a package to this repo?
By forking it, adding your package (follow the name convention!) and then opening a Pull Request.
