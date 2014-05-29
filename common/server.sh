#!/bin/bash

. "$(dirname "${BASH_SOURCE[0]}")"/common.sh || { echo 'Failed to load common.sh.' >&2; exit 2; }
require_io
input="${config[input]}"
output="${config[output]}"

send()
{
	echo "$*"
}

sendf()
{
	send "$(format "$*")"
}

format()
{
	line="$*"
	line="${line//&/$F}"
	line="${line//$F$F/&}"
	echo "$line"
}

get_ign()
{
	[[ "$1" == '!' ]] && echo -n '!' && return
	[[ -n "$1" && -r "$srcdir/users/$1.ign" ]] && ign="$(cat "$srcdir/users/$1.ign")" && echo -n "${ign[0]}" || echo -n "$1"
}

marshal_input()
{
	while (( running )); do
		read -r -t 1 line
		local -i x=$?

		(( x==142 )) && continue
		
		if (( x )); then
			warning 'Input stream closed prematurely'
			break
		fi

		if [[ -z "$line" ]]; then
			echo
			break
		fi
		
		args=( $line )
		user="${args[0]}"
		ign="$(get_ign "$user")"
		args=( "${args[@]:1}" )

		[[ -z "$ign" ]] && continue

		case "${args[0]}" in
			''|'#'*)
				continue
				;;
		esac

		echo "[CONSOLE:$user] >>> ${args[*]}" >&2

		case "${args[0]}" in
			say|esay|broadcast|ebroadcast|msg|emsg|t|et|tell|etell|whisper|ewhisper)
				send "${args[0]} [$ign] ${args[*]:1}"
				;;

			'.')
				sendf "say [$ign] ${args[*]:1}"
				;;

			*)
				send "${args[*]}"
				;;
		esac
	done
}

monitor()
{
	while (( running )) && read -r line; do
		[[ -z "$line" ]] && continue

		case "$line" in
			'['??:??:??' INFO]: Stopping server'*)
				echo "$line"
				sleep .1s

				(
					sleep .1s
					echo
				) >&4

				return 0
				;;
		esac

		echo "$line"
	done
}

run()
{
	success 'Starting server...'
	marshal_input | java -Xms"${config[ms]}" -Xmx"${config[mx]}" -jar "${config[jar]}" | monitor
	warning 'Server stopped.'
}

loop()
{
	while (( running )); do
		run
	done
}


cd "$serverdir" || fatal "Failed to open server directory: $serverdir"

echo > "$output"
exec 4<> "$input" 3< "$input" 9>&2 >> "$output" 2>&1

running=1

run <&3
#loop <&3

