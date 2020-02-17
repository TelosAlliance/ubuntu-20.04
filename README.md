# Ubuntu 20.04 LTS build container

This container is based on Ubuntu 20.04, but contains many additional packages for software development, some of which are not part of the official repositories.
It is intended to serve as build environment for many of our projects.

## Tools

- Version Control: `git`
- Build Systems: `autotools`, `cmake`, `make`
- Compilers: `g++`, `gcc`, `golang`
- Scripting Languages: `nodejs`/`npm`/`yarn`/`pnmp`, `perl`, `python`
- Debug / Analysis: `cppcheck`, `gdb`, `shellcheck`, `valgrind`

## Prequisites

Make sure you have `docker` installed, and you are part of the `docker` group.
Running as root is not recommended.

## Environment Variables

This container can be used in many different ways by adjusting the environment variables and mounts.
It can be configured using the following environment variables, all of which are optional:

| Variable     | Description |
| ------------ | ----------- |
| `LINUX_USER` | Username inside container |
| `LINUX_UID`  | UID for `LINUX_USER` |
| `LINUX_GROUP`| Default group inside container |
| `LINUX_GID`  | GID for `LINUX_GROUP` |
| `LINUX_DIR`  | Directory to start in |

## Usage

### GitLab CI

To run a CI job using this image, add the following to your `.gitlab-ci.yml` file under the target job:

```yaml
image: telosalliance/ubuntu-20.04:latest
tags:
 - docker
```

### As a Shell Script

This shell script will launch the container and execute shell or any other command from inside:

```bash
#!/bin/sh
# Usage: run-docker [cmd [arg0 [arg1 ...]]]
# Run any command inside our CI container

# NOTE: Requires $PWD to be under $HOME

docker run -it \
    --env LINUX_USER="$(id -un)" \
    --env LINUX_UID="$(id -u)" \
    --env LINUX_GROUP="$(id -gn)" \
    --env LINUX_GID="$(id -g)" \
    --env LINUX_DIR="$PWD" \
    --mount "src=$HOME,target=$HOME,type=bind" \
    telosalliance/ubuntu-20.04:latest "$@"
```

### From Makefiles

You can use this container to execute any target by adding these lines to your `Makefile`:

```makefile
# Run any target by prefixing it with `docker-`
docker-%:
	docker run \
		--env LINUX_USER=$(shell id -un) \
		--env LINUX_UID=$(shell id -u) \
		--env LINUX_GROUP=$(shell id -gn) \
		--env LINUX_GID=$(shell id -g) \
		--env LINUX_DIR="$(PWD)" \
		--mount "src=$(HOME),target=$(HOME),type=bind" \
		telosalliance/ubuntu-20.04:latest \
		make $(@:docker-%=%)
```

### Building from Source

If you need to make changes, you can also clone this repository and build it yourself.

#### Building

```shell
make
```

#### Running

To run the image you built in the previous step, type:

```shell
make run
```

This will also set up a user and bind mount your /home directory inside the container.

You can optionally set extra args to pass to `docker` by calling `make` with `ARGS=<args>`.
For example, if you are having network problems you can try using the host's network:

```shell
make run ARGS="--network=host"
```
