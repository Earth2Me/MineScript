#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")"/common.sh || { echo 'Failed to load common.sh.' >&2; exit 2; }

if [[ ! -e "${config[input]}" ]]; then
	warning "Input stream doesn't exist yet.  Waiting for initialization..."

	while [[ ! -e "${config[input]}" ]]; do
		sleep 2s
	done

	success 'Initialization complete.'
fi

while true; do
	warning 'Waiting for connection to server...'
	exec 3> "${config[input]}"
	success 'Connected and ready for commands.'
	exec 3>&-

	while read -er -p '> ' line; do
		[[ -e "${config[input]}" ]] || break
		echo "$USER $line" > "${config[input]}"
	done
done

