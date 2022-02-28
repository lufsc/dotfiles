#!/usr/bin/bash

set -e
#set -o xtrace

source_dir=$(dirname $(realpath -s $0))
target_dir=$(realpath -s $1)

if [ $# -ne 1 ] || [ $1 = '-h' ] || [ $1 = '--help' ]
then
	echo "Usage: $0 [target_dir]"
	exit
fi

# usage: link_dir src_path target_path
link_dir() {
	if [ ! -d $2 ]
	then
		echo "Creating directory $2"
		mkdir "$2"
	fi
	for f in $(ls -A $1)
	do
		if [ -f "$1/$f" ]
		then
			link_file "$1/$f" "$2/$f"
		elif [ -d "$1/$f" ]
		then
			link_dir "$1/$f" "$2/$f"
		fi
	done
}

# usage link_file src target
link_file() {
	echo "Linking '$1' -> '$2'"
	ln -sf $1 $2
}

for f in $(ls -A)
do
	if [ -f "$f" ]
	then
		if [ "$f" = "$(basename $0)" ]
		then
			continue
		fi
		link_file "$source_dir/$f" "$target_dir/$f"
	elif [ -d "$f" ]
	then
		if [ "$f" = ".git" ]
		then
			continue
		fi
		link_dir "$source_dir/$f" "$target_dir/$f"
	fi
done

