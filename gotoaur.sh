#!/usr/bin/sh

############################################################################
#			gotoaur
#
#	Generate a source-only tarball and upload it to AUR
############################################################################

upload() {
	burp -u X0rg -p $passwd -c $1 /tmp/srcdest/$pkg-*.src.tar.gz
}

mkdir -p /tmp/srcdest

for pkg in $@; do
	cd $(find `dirname $0` -name $pkg)
	updpkgsums
	mkaurball -f && \
	mv $pkg-*.src.tar.gz /tmp/srcdest
done

echo "Password: "
read -s passwd
for pkg in $@; do
	case $pkg in
		darling-git)				upload emulators;;
		darling-multilib-git)			upload emulators;;
		dmg2dir)				upload system;;
		frozenway)				upload system;;
		gnustep-make-clang-svn)			upload devel;;
		gnustep-libobjc2-clang-svn)		upload devel;;
		gnustep-base-clang-svn)			upload devel;;
		gnustep-gui-clang-svn)			upload devel;;
		gnustep-corebase-clang-svn)		upload devel;;
		gnustep-make-multilib-clang-svn)	upload devel;;
		gnustep-libobjc2-multilib-clang-svn)	upload devel;;
		gnustep-base-multilib-clang-svn)	upload devel;;
		gnustep-gui-multilib-clang-svn)		upload devel;;
		gnustep-corebase-multilib-clang-svn)	upload devel;;
		libdispatch-clang-git)			upload lib;;
		libpthread_workqueue-libpthread)	upload lib;;
		man-pages-fr)				upload system;;
		manpages-fr-extra)			upload system;;
		memtest86-efi)				upload system;;
		psensor)				upload system;;
		*)	echo -e "Wrong package name.\n" > /dev/stderr ; exit 1;;
	esac
done
