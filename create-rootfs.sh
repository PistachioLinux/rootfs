#!/bin/bash

set -e

# Pistachio Linux rootfs creation script
# requires some stuff, like debootstrap.
# a lot of this was taken from https://salsa.debian.org/debian/WSL/-/blob/master/create-targz.sh. 

echo_info() {
    echo -e "[\e[34mINFO\e[39m] $1"
}

BUILDDIR=$(pwd)
TMPDIR=$(mktemp -d)

DIST="testing"

cd $TMPDIR

# start timer
start=$SECONDS

echo_info "📦 Creating Pistachio Linux rootfs. Timer started. Debian version: $DIST, build directory: $BUILDDIR, temporary directory: $TMPDIR. "

# initialize rootfs
sudo debootstrap --arch "amd64" --exclude=debfoster --include sudo,locales,curl $DIST $DIST http://deb.debian.org/debian
echo_info "📦 Rootfs initialized."
# clean up apt
sudo chroot $DIST apt-get clean
echo_info "📦 Cleaned up apt."
# set up locale
sudo chroot $DIST /bin/bash -c "update-locale LANGUAGE=en_US.UTF-8 LC_ALL=C"
sudo chroot $DIST /bin/bash -c "echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen"
echo_info "📦 Set up locale."
# start installing packages
sudo chroot $DIST apt install -y podman distrobox ca-certificates jq
echo_info "📦 Installed packages."
# move files
sudo cp $BUILDDIR/files/sources.list $TMPDIR/$DIST/etc/apt/sources.list
sudo cp $BUILDDIR/files/wsl.conf $TMPDIR/$DIST/etc/wsl.conf
sudo cp $BUILDDIR/files/containers.conf $TMPDIR/$DIST/etc/containers/containers.conf
sudo cp $BUILDDIR/files/motd $TMPDIR/$DIST/etc/motd
sudo chmod +x $TMPDIR/$DIST/etc/motd
echo_info "📦 Installed files."
# install pistachio scripts
sudo curl -L https://raw.githubusercontent.com/PistachioLinux/pistachio-scripts/master/pistachio-manager -o $TMPDIR/$DIST/usr/bin/pistachio-manager
sudo curl -L https://raw.githubusercontent.com/PistachioLinux/pistachio-scripts/master/pistachio-update -o $TMPDIR/$DIST/usr/bin/pistachio-update
sudo curl -L https://raw.githubusercontent.com/PistachioLinux/pistachio-scripts/master/pistachio-setup -o $TMPDIR/$DIST/usr/bin/pistachio-setup
sudo chmod +x $TMPDIR/$DIST/usr/bin/pistachio-manager
sudo chmod +x $TMPDIR/$DIST/usr/bin/pistachio-update
sudo chmod +x $TMPDIR/$DIST/usr/bin/pistachio-setup
echo_info "📦 Installed Pistachio scripts."
# pack it up
cd $DIST
echo_info "📦 Packing up rootfs."
sudo tar --ignore-failed-read -czvf $TMPDIR/pistachio-$(date +%Y%m%d).tar.gz *

echo_info "📦 Moving rootfs to build directory."
mkdir -p $BUILDDIR/build
mv -f $TMPDIR/pistachio-$(date +%Y%m%d).tar.gz $BUILDDIR/build
cd $BUILDDIR

# im like a math genius
duration=$(( SECONDS - start ))

echo_info "⏱️  Finished in $duration seconds."