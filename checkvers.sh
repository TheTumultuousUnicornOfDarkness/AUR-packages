#!/usr/bin/zsh

############################################################################
#			checkvers
#
#	Automatically check for newer version of programs
############################################################################

# Global variables
cr="\033[1;31m"
cg="\033[1;32m"
ce="\033[0m"
cpt=0
[[ $1 == "-q" ]] && quiet=1

cd `dirname $0`

# Script output: start
[[ ! $quiet ]] && printf "%36s %8s   %8s\n" "Package" "PkgVer" "PrgVer"

showver() {
	curver=$(grep "pkgver=" --color=never $1/PKGBUILD | cut -d "=" -f2)
	col=$cr
	[[ $curver == $2 ]] && col=$cg || cpt=$[ cpt + 1 ]
	[[ ! $quiet ]] && printf "%35s: $col%8s$ce | $cg%8s$ce\n" $1 $curver $2
}


# Check versions

# CPU-X
newver=$(elinks -dump -no-references "https://github.com/X0rg/CPU-X/tags" | grep "]v" --color=never \
	| awk '{ print $1 }' | cut -d "v" -f2 | head -n1)
showver cpu-x $newver

# DMG2DIR
newver=$(elinks -dump -no-references "https://github.com/X0rg/dmg2dir/tags" | grep "]v" --color=never \
	| awk '{ print $1 }' | cut -d "v" -f2 | head -n1)
showver dmg2dir $newver
	
# FrozenWay
newver=$(elinks -dump -no-references "http://www.frozenway.com/index.php?module=download" \
	| grep "]FrozenWay" --color=never | awk '{ print $2 }' | head -n1)
showver frozenway $newver

# Lib32-LibKqueue
newver=$(elinks -dump -no-references "https://github.com/mheily/libkqueue/tags" | grep "]v" --color=never \
	| awk '{ print $1 }' | cut -d "v" -f2 | head -n1)
showver lib32-libkqueue $newver

# LibPthread Workqueue
www=$(elinks -dump -no-references "http://sourceforge.net/projects/libpwq/files/" \
	| grep "]libpthread_workqueue-" --color=never | cut -d "-" -f2 | awk '{ print $1 }' | head -n1)
newver=${www%%".tar.gz"}
showver libpthread_workqueue-libpthread $newver

# Man-Pages-FR
newver=$(elinks -dump -no-references "https://alioth.debian.org/projects/perkamon/" \
	| grep "man-pages-fr" --color=never | tail -n1 | awk '{ print $2 }' | cut -d "-" -f1)
showver man-pages-fr $newver

# ManPages-FR-Extra
newver=$(elinks -dump -no-references "http://anonscm.debian.org/cgit/pkg-manpages-fr/manpages-fr-extra.git/refs/tags" \
	| grep "commit " --color=never | awk '{ print $1 }' | cut -d "]" -f2 | head -n1)
showver manpages-fr-extra $newver

# MemTest86
newver=$(elinks -dump -no-references "http://www.memtest86.com/download.htm" | grep "MemTest86 V" --color=never |
	grep "Free Edition" --color=never | awk '{ print $2 }' | cut -d "V" -f2)
showver memtest86-efi $newver

# MemTest86 BETA
www=$(elinks -dump -no-references "http://www.memtest86.com/downloads/beta/?C=M;O=D")
newver=$(echo $www | grep "GZIP compressed docume" --color=never | grep "iso-" --color=never \
	| awk '{ print $2 }' | cut -d "]" -f2 | cut -c15-19 | head -n1)
showver memtest86-efi-beta $newver

# Python2-MMKeys
www=$(elinks -dump -no-references "http://sourceforge.net/projects/sonata.berlios/files/" \
	| grep "sonata" | awk '{ print $1 }' | cut -d "]" -f2 | cut -d "-" -f2 | grep ".tar.gz" | head -n1)
newver=${www%%".tar.gz"}
showver python2-mmkeys $newver

# Psensor
www=$(elinks -dump -no-references "http://wpitchoune.net/psensor/files/")
www=$(echo $www | awk '{ print $2 }' | grep "psensor-" --color=never | cut -c14- | tail -n1)
newver=${www%%".tar.gz.asc"*}
showver psensor $newver


# Script output: end
if [[ $quiet ]]; then
	echo -e "$cpt"
else
	[[ $cpt == 0 ]] && col=$cg || col=$cr
	echo -e "\nOut-of-date packages : $col$cpt$ce"
fi
