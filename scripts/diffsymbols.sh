#!/usr/bin/sh

############################################################################
#			diffsymbols
#
#	Compare 2 ELF files (like librarires) and show:
#	- symbols in reference_elf which are not in second_elf
#	- symbols in second_elf which are not in reference_elf
#	Then, count to easily view differences between this 2 ELF files.
############################################################################

if [[ $# < 2 ]]; then
	echo -e "$0: usage: reference_elf second_elf\n" > /dev/stderr
	exit 1
fi

if [[ ! -f $1 ]] || [[ ! -f $2 ]]; then
	echo -e "You need to use ELF files !\n" > /dev/stderr
	exit 1
fi


readelf -Ws $1 | awk '{print $8}' > /tmp/symbref
readelf -Ws $2 | awk '{print $8}' > /tmp/symbplus

for i in $(cat /tmp/symbref); do
	if ! grep -q "$i" /tmp/symbplus; then
		((cpt1++))
		echo $i
	fi
done

echo -e "\n\nInverse\n\n"
sleep 1

for i in $(cat /tmp/symbplus); do
	if ! grep -q "$i" /tmp/symbref; then
		((cpt2++))
		echo $i
	fi
done

echo -e "\n\n\t$1 : $cpt1\n\t$2 : $cpt2\n\n"

rm /tmp/symbref /tmp/symbplus
