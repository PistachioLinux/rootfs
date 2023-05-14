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
cd $DIST
sudo tar --ignore-failed-read -czvf $TMPDIR/pistachio-$(date +%Y%m%d).tar.gz *

mkdir -p $BUILDDIR/build
mv -f $TMPDIR/pistachio-$(date +%Y%m%d).tar.gz $BUILDDIR/build
cd $BUILDDIR