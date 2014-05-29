#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")"/common.sh || { echo 'Failed to load common.sh.' >&2; exit 2; }

if [[ ! -e "${config[output]}" ]]; then
	warning "Output buffer doesn't exist yet.  Waiting for initialization..."

	while [[ ! -e "${config[output]}" ]]; do
		sleep 2s
	done

	success 'Initialization complete.'
fi

while true; do
	warning 'Attaching to output buffer...'
	exec 4< "${config[output]}"
	success 'Attached and streaming.'
	exec 4>&-

	tail -fn 20 "${config[output]}"
done

