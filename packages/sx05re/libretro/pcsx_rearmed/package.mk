# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2021-present Shanti Gilbert (https://github.com/shantigilbert)

PKG_NAME="pcsx_rearmed"
PKG_VERSION="cf71346b180ca485e67a43fc199232c51be9459b"
PKG_SHA256="fcffe92f60a111763416b47de642c2acabb91ffe696da96afe67b0a5a5c2f228"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPLv2"
PKG_SITE="https://github.com/libretro/pcsx_rearmed"
PKG_URL="$PKG_SITE/archive/$PKG_VERSION.tar.gz"
PKG_DEPENDS_TARGET="toolchain alsa"
PKG_SHORTDESC="ARM optimized PCSX fork"
PKG_LONGDESC="PCSX ReARMed is yet another PCSX fork based on the PCSX-Reloaded project, which itself contains code from PCSX, PCSX-df and PCSX-Revolution."
PKG_IS_ADDON="no"
PKG_TOOLCHAIN="make"
PKG_AUTORECONF="no"
PKG_BUILD_FLAGS="-gold"

PKG_MAKE_OPTS_TARGET="-f Makefile.libretro GIT_VERSION=${PKG_VERSION:0:7}"

pre_configure_target() {
 cd ${PKG_BUILD}
  if [ "${PROJECT}" = "Amlogic-ng" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=rpi4"
  elif [ "${PROJECT}" = "Amlogic" ]; then
    PKG_MAKE_OPTS_TARGET+=" platform=rpi3"
  else
    PKG_MAKE_OPTS_TARGET+=" platform=classic_armv7_a7"
  fi
}

make_target() {
cd ${PKG_BUILD}
if [ "${ARCH}" == "arm" ]; then
	if [ "${PROJECT}" == "Amlogic" ]; then
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=rpi3
	else
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=classic_armv7_a7
	fi
else
	if [ "${PROJECT}" == "Amlogic" ]; then
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=h5
	elif [ "${DEVICE}" == "OdroidGoAdvance" ] || [ "${DEVICE}" == "Gameforce" ]; then
		sed -i "s|cortex-a53|cortex-a35|g" Makefile.libretro
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=h5
	else
		make -f Makefile.libretro GIT_VERSION=${PKG_VERSION} platform=CortexA73_G12B
	fi
fi
}

makeinstall_target() {
INSTALLTO="/usr/lib/libretro"
mkdir -p ${INSTALL}${INSTALLTO}/

if [ "${ARCH}" == "arm" ]; then
    cp pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}/pcsx_rearmed_32b_libretro.so
else
    cp pcsx_rearmed_libretro.so ${INSTALL}${INSTALLTO}
fi
}
