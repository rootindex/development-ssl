#!/usr/bin/env bash


# Warn if the DOCKER_HOST socket does not exist
if [[ $DOCKER_HOST = unix://* ]]; then
	socket_file=${DOCKER_HOST#unix://}
	if ! [ -S ${socket_file} ]; then
		cat >&2 <<-EOT
			ERROR: you need to share your Docker host socket with a volume at $socket_file
			Typically you should run your containers with with: \`-v /var/run/docker.sock:${socket_file}:ro\`
		EOT
		socketMissing=1
	fi
fi


if [[ ! -d /app/ssl ]]; then
    mkdir /app/ssl
fi

if [[ ! -d /app/ssl/root ]]; then
    mkdir /app/ssl/root
fi

if [[ ! -d /app/ssl/out ]]; then
    mkdir /app/ssl/out
fi

/app/generate-dhparam.sh $DHPARAM_BITS

# If the user has run the default command and the socket doesn't exist, fail
if [ "$socketMissing" = 1 -a "$1" = forego -a "$2" = start -a "$3" = '-r' ]; then
	exit 1
fi

exec "$@"