#!/bin/bash

set -e

# Pistachio Linux rootfs creation script
# requires some stuff, like debootstrap.
# a lot of this was taken from https://salsa.debian.org/debian/WSL/-/blob/master/create-targz.sh. 

BUILDDIR=$(pwd)
TMPDIR=$(mktemp -d)

DIST="testing"

cd $TMPDIR

sudo debootstrap --arch "amd64" --exclude=debfoster --include sudo,locales,curl $DIST $DIST http://deb.debian.org/debian
sudo chroot $DIST apt-get clean
sudo chroot $DIST /bin/bash -c "update-locale LANGUAGE=en_US.UTF-8 LC_ALL=C"
sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"
sudo chroot $DIST apt install -y podman
sudo chroot $DIST apt install -y distrobox 
sudo cp $BUILDDIR/files/sources.list $TMPDIR/$DIST/etc/apt/sources.list
sudo cp $BUILDDIR/files/wsl.conf $TMPDIR/$DIST/etc/wsl.conf
sudo curl -L https://raw.githubusercontent.com/PistachioLinux/pistachio-scripts/master/pistachio-manager -o $TMPDIR/$DIST/usr/bin/pistachio-manager
sudo curl -L https://raw.githubusercontent.com/PistachioLinux/pistachio-scripts/master/pistachio-update -o $TMPDIR/$DIST/usr/bin/pistachio-update
sudo chmod +x $TMPDIR/$DIST/usr/bin/pistachio-manager
sudo chmod +x $TMPDIR/$DIST/usr/bin/pistachio-update
sudo cp $BUILDDIR/files/.bashrc $TMPDIR/$DIST/etc/skel/.bashrc
cd $DIST
sudo tar --ignore-failed-read -czvf $TMPDIR/pistachio-$(date +%Y%m%d).tar.gz *

mkdir -p $BUILDDIR/build
mv -f $TMPDIR/pistachio-$(date +%Y%m%d).tar.gz $BUILDDIR/build
cd $BUILDDIR