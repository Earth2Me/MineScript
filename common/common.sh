#!/bin/bash

debug()
{
	(( $debug )) || return 0
	echo "[DEBUG] $*" >&2
}

success()
{
	echo $'\e[32m'"$*"$'\e[m' >&2
}

warning()
{
	echo $'\e[33m'"$*"$'\e[m' >&2
}

error()
{
	echo $'\e[31m'"$*"$'\e[m' >&2
}

fatal()
{
	error "$*"
	exit 1
}

if [[ "$1" == 'debug' ]]; then
	shift
	debug=1
	warning 'Debug mode enabled.'
else
	debug=0
fi

F=$'\xa7'

srcdir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" || fatal 'Failed to determine include directory.'
mcdir="$(dirname "$srcdir")" || fatal 'Failed to determine Minecraft root directory.'
allserversdir="$mcdir/servers"
server="$1"
serverdir="$allserversdir/$server"

[[ -n "$server" ]] || fatal "Usage: $0 SERVER_NAME"
[[ -d "$serverdir" ]] || fatal "Server '$server' does not exist in $allserversdir."
[[ "$(readlink -f "$allserversdir")" == "$(cd "$serverdir" && cd .. && readlink -f "$PWD")" ]] || fatal "Server '$server' does not map to a valid server directory."

[[ -f "$srcdir/config.global.sh" ]] && . "$srcdir/config.global.sh" || fatal 'Failed to load global configuration.'
[[ -f "$serverdir/config.sh" ]] && . "$serverdir/config.sh" || fatal 'Server does not have a valid configuration file.'

has_io=0
require_io()
{
	(( $has_io )) && return 0

	if [[ ! -e "${config[input]}" ]]; then
		mkfifo "${config[input]}" || fatal 'Failed to create input pipe.  You do not have permission to initialize the server.'

		if ! chmod 620 "${config[input]}"; then
			rm "${config[input]}" 2> /dev/null
			fatal 'Failed to change permissions of input pipe.  You do not have permission to initialize the server.'
		fi
	fi

	if [[ ! -e "${config[output]}" ]]; then
		touch "${config[output]}" || fatal 'Failed to create output buffer.  You do not have permission to initialize the server.'

		if ! chmod 640 "${config[output]}"; then
			rm "${config[output]}" 2> /dev/null
			fatal 'Failed to change permissions of output buffer.  You do not have permission to initialize the server.'
		fi
	fi

	has_io=1
	return 0
}

clear_output()
{
	require_io

	if ! echo -n > "${config[output]}"; then
		warning 'Failed to clear output buffer.'
		return 1
	fi

	return 0
}

true # Send success upstream

