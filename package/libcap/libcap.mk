#############################################################
#
# libcap
#
#############################################################

LIBCAP_VERSION = 2.22
# Until kernel.org is completely back up use debian mirror
#LIBCAP_SITE = http://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2
LIBCAP_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/libc/libcap2
LIBCAP_SOURCE = libcap2_$(LIBCAP_VERSION).orig.tar.gz
LIBCAP_LICENSE = GPLv2 or BSD-3c
LIBCAP_LICENSE_FILES = License

LIBCAP_DEPENDENCIES = host-libcap
LIBCAP_INSTALL_STAGING = YES

define LIBCAP_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		LIBATTR=no BUILD_CC="$(HOSTCC)" BUILD_CFLAGS="$(HOST_CFLAGS)"
endef

define LIBCAP_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) LIBATTR=no DESTDIR=$(STAGING_DIR) \
		prefix=/usr lib=lib install
endef

define LIBCAP_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) LIBATTR=no DESTDIR=$(TARGET_DIR) \
		prefix=/usr lib=lib install
endef

# progs use fork()
define LIBCAP_DISABLE_PROGS
	$(SED) '/-C progs/d' $(@D)/Makefile
endef

LIBCAP_POST_PATCH_HOOKS += LIBCAP_DISABLE_PROGS

define HOST_LIBCAP_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) LIBATTR=no
endef

define HOST_LIBCAP_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) LIBATTR=no DESTDIR=$(HOST_DIR) \
		prefix=/usr lib=lib install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
