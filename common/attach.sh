#!/bin/bash

tmux()
{
	echo tmux "$@" >&2
	command tmux "$@"
}

if [[ $# -eq 0 ]]; then
	if tmux -L mc -q has-session &> /dev/null; then
		echo 'Found existing session; attaching' >&2
		tmux -L mc attach
		exit $?
	fi

	self="$(readlink -f "${BASH_SOURCE[0]}")"
	srcdir="$(dirname "$self")"
	mcdir="$(dirname "$srcdir")"
	allserversdir="$mcdir/servers"

	cd "$allserversdir"

	for server in *; do
		[[ -e "$server/config.sh" ]] || continue

		"$self" "$server" || exit $?
	done

	echo "Finished with all servers; attaching" >&2
	tmux -L mc attach
	exit $?
fi

. "$(dirname "${BASH_SOURCE[0]}")"/common.sh || { echo 'Failed to load common.sh.' >&2; exit 2; }


if tmux -L mc -q has-session &> /dev/null; then
	echo "Creating new window for $server" >&2
	tmux -L mc new-window -k -n "$server" -c "$serverdir" "$srcdir/output.sh $server"
else
	echo "Creating new session and window for $server" >&2
	tmux -L mc new-session -d -n "$server" "$srcdir/output.sh $server"
fi

echo "Splitting off input window for $server" >&2
tmux -L mc split-window -c "$serverdir" -l 3 "$srcdir/input.sh $server"

