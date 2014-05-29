#!/bin/bash

declare -A config='( )' || fatal 'Failed to declare config associative array.'
config=(
	[jar]="$srcdir/server.jar"
	[ms]=1G
	[mx]=8G
	[input]="$serverdir/.input"
	[output]="$serverdir/.output"
)

declare -A backupconfig='( )' || fatal 'Failed to declare backupconfig associative array.'
# TODO: Change backupconfig[to]
backupconfig=(
	[from]="$mcdir"
	[to]="/mnt/hdd/bak/mc-0/minecraft" 
)

true # Report success to common.sh

