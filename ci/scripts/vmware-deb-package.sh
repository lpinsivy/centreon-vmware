#!/bin/sh
set -ex

if [ -z "$VERSION" -o -z "$RELEASE" -o -z "$DISTRIB" ] ; then
  echo "You need to specify VERSION / RELEASE / DISTRIB variables"
  exit 1
fi

echo "################################################## PACKAGING COLLECT ##################################################"

AUTHOR="Luiz Costa"
AUTHOR_EMAIL="me@luizgustavo.pro.br"

if [ -d /build ]; then
  rm -rf /build
fi
mkdir -p /build
cd /build

mkdir -p /build/centreon-plugin-virtualization-vmware-daemon
(cd /src && tar czvpf - centreon-plugin-virtualization-vmware-daemon) | dd of=centreon-plugin-virtualization-vmware-daemon-$VERSION.tar.gz
cp -rv /src/centreon-vmware /build/
cp -rv /src/centreon-vmware/ci/debian /build/centreon-plugin-virtualization-vmware-daemon/

ls -lart
cd /build/centreon-plugin-virtualization-vmware-daemon
debmake -f "${AUTHOR}" -e "${AUTHOR_EMAIL}" -u "$VERSION" -y -r "$RELEASE"
debuild-pbuilder
cd /build

if [ -d "$DISTRIB" ] ; then
  rm -rf "$DISTRIB"
fi
mkdir $DISTRIB
mv /build/*.deb $DISTRIB/
mv /build/$DISTRIB/*.deb /src
