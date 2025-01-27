TERMUX_PKG_HOMEPAGE=http://www.leptonica.com/
TERMUX_PKG_DESCRIPTION="Library for image processing and image analysis"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_LICENSE_FILE="leptonica-license.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.83.0
TERMUX_PKG_SRCURL=https://github.com/DanBloomberg/leptonica/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=14cf531c2219a1414e8e3c51a3caa5cf021a52e782c4a6561bf64d0ef2119282
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="giflib, libjpeg-turbo, libpng, libtiff, libwebp, openjpeg, zlib"
TERMUX_PKG_BREAKS="leptonica-dev"
TERMUX_PKG_REPLACES="leptonica-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=6

	local v=$(sed -En 's/^.*set_target_properties\s*\(leptonica PROPERTIES SOVERSION ([0-9]+).*$/\1/p' \
			src/CMakeLists.txt)
	if [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	# Silence tmpfile warnings:
	find src -name '*.c' | xargs -n 1 \
		sed -i 's/L_INFO("work-around: writing to a temp file\\n", __func__)/((void)0)/'

	./autogen.sh
}
