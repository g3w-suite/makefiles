# makefiles v0.0.2

A collection of reusable makefiles and tasks designed to make managing your python and docker projects easier.

## Installation

Add a main `Makefile` in your working directory and download the individual files you need as follows:

```Makefile
install: Makefile.semver.mk Makefile.foo.mk

Makefile.semver.mk Makefile.foo.mk:
	wget https://raw.githubusercontent.com/g3w-suite/makefiles/master/$@

include Makefile.semver.mk
include Makefile.foo.mk
```

After that, use the `make` command to finalize the installation of those files:

```sh
make install
```

**NB** on Microsoft you'll need to open a [Windows Subsystem for Linux](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux) terminal (bash shell) before you can run those commands

## Configuration

Update the download URL to always get a specific version of the file:

```sh
# unstable branch (master)
wget https://raw.githubusercontent.com/g3w-suite/makefiles/master/Makefile.semver.mk

# tagged release (v1.0.0)
wget https://raw.githubusercontent.com/g3w-suite/makefiles/v1.0.0/Makefile.semver.mk

# untagged commit (file permalink)
wget https://raw.githubusercontent.com/g3w-suite/makefiles/71aea4e60b7d4c05e9e7357e0f94eaf82af70a21/Makefile.semver.mk

# API SCHEME:
# wget https://raw.githubusercontent.com/:org/:repo/:branch/:path
```

For more info: [getting permanent links to files](https://docs.github.com/en/repositories/working-with-files/using-files/getting-permanent-links-to-files)

## Publish

Create a new `git tag` that is appropriate for the version you intend to publish, eg:

```sh
make version v=1.1.0
```

Refer to [Makefile.semver.mk](./Makefile.semver.mk) file for a complete list of available tasks.

## Related resources

Repositories from which to get inspiration:

- [fordnox/Makefile.semver.mk](https://gist.github.com/fordnox/837ded1d02eff3ff7b378e296e159a4a)
- [httpie/Makefile](https://github.com/httpie/httpie/blob/master/Makefile)
- [dbosk/makefiles](https://github.com/dbosk/makefiles)

Quick Makefile reference:

- [gnu.org](https://www.gnu.org/software/make/manual/make.html)
- [makefiletutorial.com](https://makefiletutorial.com/)
- [wikipedia.org](https://en.wikipedia.org/wiki/Make_(software))

Additional configuration for Microsoft Windows users:

- [setup Git Credential Manager on WSL2](https://learn.microsoft.com/en-us/windows/wsl/tutorials/wsl-git#git-credential-manager-setup)

---

**License:** MPL-2
