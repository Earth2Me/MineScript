#!/bin/bash

pids=( )

for f in "$serverdir"/*/.input; do
	[[ -e "$f" ]] || continue

	echo '! save-all' > "$f" &
	pids+=( $! )
done

if (( ${#pids[@]} )); then
	sleep 30s
	kill "${pids[@]}" &> /dev/null
fi

rdiff-backup "${backupconfig[from]}" "${backupconfig[to]}"

