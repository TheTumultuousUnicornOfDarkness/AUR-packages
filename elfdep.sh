#!/usr/bin/sh

############################################################################
#			elfdep
#
#	Show dependencies of an ELF file thanks to Pacman.
############################################################################


if [[ $# < 1 ]]; then
	echo -e "$0: usage: elf\n" > /dev/stderr
	exit 1
fi

if [[ ! -f $1 ]]; then
	echo -e "You need to use ELF file !\n" > /dev/stderr
	exit 1
fi

for arg in $@; do
	echo -e "\033[1m$arg:\033[0m"

	for file in `ldd $arg | awk '{print $3}'`; do
		pacman -Qqo $file >> /tmp/dep
	done

	sort /tmp/dep -u
	rm /tmp/dep
	echo
done
