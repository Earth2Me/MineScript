#!/bin/bash
set -e
cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

self="$0"

cmd_help()
{
	cat <<EOD
Syntax: $self [COMMAND]

COMMAND can be any of:
  help               Displays this help text.
  attach             Attaches to the server consoles.
EOD
}

cmd_attach()
{
	./attach.sh
}

case "$1" in
	''|help|--help)
		cmd_help
		;;

	attach)
		cmd_attach
		;;

	*)
		echo "Unrecognized command: $1" >&2
		cmd_help
		exit 1
		;;
esac

