#/bin/bash
INSTALL_BIN="install -oroot -groot -m0755"
INSTALL_SUID="install -oroot -groot -m4755"
INSTALL_DIR="install -oroot -groot -d -m0755"
INSTALL_DATA="install -oroot -groot -m0644"
INSTALL_CONF="install -oroot -groot -m0600"
# TAG=${GITHUB_REF#refs/tags/}
# echo ::set-output name=tag_name::${TAG}
[ -d /tmp/static-device-names ] && rm -rf /tmp/static-device-names
mkdir /tmp/static-device-names && cd /tmp/static-device-names && $INSTALL_DIR etc/init.d/ etc/hotplug.d/net/ usr/share/doc/static-device-names/ CONTROL && cd $GITHUB_WORKSPACE
[ -f $GITHUB_WORKSPACE/files/static-device-names.config ] && $INSTALL_CONF $GITHUB_WORKSPACE/files/static-device-names.config /tmp/static-device-names/etc/init.d/static-device-names
[ -f $GITHUB_WORKSPACE/files/static-device-names.hotplug ] && $INSTALL_BIN $GITHUB_WORKSPACE/files/static-device-names.hotplug /tmp/static-device-names/etc/hotplug.d/net/static-device-names
[ -f $GITHUB_WORKSPACE/files/static-device-names.init ] && $INSTALL_BIN $GITHUB_WORKSPACE/files/static-device-names.init /tmp/static-device-names/etc/init.d/static-device-names
[ -f $GITHUB_WORKSPACE/README.md ] && $INSTALL_DATA $GITHUB_WORKSPACE/README.md /tmp/static-device-names/usr/share/doc/static-device-names/
PKG_NAME=$(sed -n 's/^\s*PKG_NAME\s*:=\s*//p' ./Makefile)
PKG_VERSION=$(sed -n 's/^\s*PKG_VERSION\s*:=\s*//p' ./Makefile)
PKG_RELEASE=$(sed -n 's/^\s*PKG_RELEASE\s*:=\s*//p' ./Makefile)
PKG_MAINTAINER=$(sed -n 's/^\s*PKG_MAINTAINER\s*:=\s*//p' ./Makefile)
PKG_LICENSE=$(sed -n 's/^\s*PKG_LICENSE\s*:=\s*//p' ./Makefile)
PKG_LICENSE_FILES=$(sed -n 's/^\s*PKG_LICENSE_FILES\s*:=\s*//p' ./Makefile)
SECTION=$(sed -n 's/^\s*SECTION\s*:=\s*//p' ./Makefile)
PKGARCH=$(sed -n 's/^\s*PKGARCH\s*:=\s*//p' ./Makefile)
cat >/tmp/static-device-names/CONTROL/control <<EOF
Package: ${PKG_NAME}
Version: ${PKG_VERSION}-${PKG_RELEASE}
Architecture: ${PKGARCH}
Maintainer: ${PKG_MAINTAINER}
Source: feeds/packages/utils/static-device-names
SourceName: static-device-names
License: ${PKG_LICENSE}
LicenseFiles: ${PKG_LICENSE_FILES}
Section: ${SECTION}
Installed-Size: 0
Description:   This package contains a utility to automatically rename device names based on predetermined rules such as MAC addresses or PCI IDs.
EOF
wget -O /tmp/ipkg-build https://raw.githubusercontent.com/openwrt/openwrt/master/scripts/ipkg-build && \
chmod +x /tmp/ipkg-build && /tmp/ipkg-build -m "" /tmp/static-device-names /tmp