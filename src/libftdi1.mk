# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libftdi1
$(PKG)_WEBSITE  := https://www.intra2net.com/en/developer/libftdi/index.php
$(PKG)_DESCR    := LibFTDI1
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.5
$(PKG)_CHECKSUM := 7c7091e9c86196148bd41177b4590dccb1510bfe6cea5bf7407ff194482eb049
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://www.intra2net.com/en/developer/libftdi/download/$($(PKG)_FILE)
$(PKG)_DEPS     := cc libusb1

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.intra2net.com/en/developer/libftdi/download.php' | \
    $(SED) -n 's,.*libftdi1-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(TARGET)-cmake' . \
        -DSHAREDLIBS=$(CMAKE_SHARED_BOOL) \
        -DSTATICLIBS=$(CMAKE_STATIC_BOOL) \
        -DLIBUSB_INCLUDE_DIR=$(PREFIX)/$(TARGET)/include/libusb-1.0 \
        -DDOCUMENTATION=no \
        -DBUILD_TESTS=no \
        -DEXAMPLES=no \
        -DFTDIPP=no \
        -DFTDI_EEPROM=no \
        -DPYTHON_BINDINGS=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install VERBOSE=1

    '$(TARGET)-gcc' \
        -W -Wall -Wextra -Werror \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libftdi1.exe' \
        `'$(TARGET)-pkg-config' libftdi1 --cflags --libs`
endef
