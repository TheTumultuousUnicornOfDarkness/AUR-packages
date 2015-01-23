#!/usr/bin/sh

############################################################################
#			gotoaur
#
#	Generate a source-only tarball and upload it to AUR
############################################################################

upload() {
	burp -u Xorg -p $passwd -c $1 /tmp/srcdest/$pkg-*.src.tar.gz
}

mkdir -p /tmp/srcdest

for pkg in $@; do
	cd $(find `dirname $0` -name $pkg)
	ls -1 > /tmp/fileslist

	[[ $SUM != 0 ]] && updpkgsums && chmod 644 *
	makepkg --source && \
	mv $pkg-*.src.tar.gz /tmp/srcdest

	ls -1 >> /tmp/fileslist
	sort /tmp/fileslist | uniq -u | xargs rm
	cd $OLDPWD
done

echo "Password: "
read -s passwd
for pkg in $@; do
	case $pkg in
		cpu-x)					upload system;;
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
		lib32-libdispatch-clang-git)		upload lib;;
		lib32-libkqueue)			upload lib;;
		lib32-libpthread_workqueue-git)		upload lib;;
		libdispatch-clang-git)			upload lib;;
		man-pages-fr)				upload system;;
		manpages-fr-extra)			upload system;;
		memtest86-efi)				upload system;;
		memtest86-efi-beta)			upload system;;
		python2-mmkeys)				upload modules;;
		psensor)				upload system;;
		*)	echo -e "Wrong package name.\n" > /dev/stderr ; exit 1;;
	esac
done
