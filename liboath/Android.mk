LOCAL_PATH := $(call my-dir)
OATH_SOURCE_DIR := $(LOCAL_PATH)

include $(CLEAR_VARS)
LOCAL_MODULE := liboath
LOCAL_MODULE_TAGS := optional
LOCAL_MODULE_CLASS := SHARED_LIBRARIES
LOCAL_SRC_FILES := \
	aux.c \
	coding.c \
	errors.c \
	global.c \
	hotp.c \
	totp.c \
	usersfile.c \
	gl/base32.c \
	gl/c-ctype.c \
	gl/gc-gnulib.c \
	gl/getdelim.c \
	gl/getline.c \
	gl/hmac-sha1.c \
	gl/hmac-sha256.c \
	gl/hmac-sha512.c \
	gl/memxor.c \
	gl/sha1.c \
	gl/sha256.c \
	gl/sha512.c \
	gl/strverscmp.c

OATH_VERSION := $(shell $(OATH_SOURCE_DIR)/../build-aux/oath-toolkit-version ../.tarball-version)
OATH_VERSION_NUMBER := $(shell $(OATH_SOURCE_DIR)/../build-aux/oath-toolkit-version ../.tarball-version vn)
OATH_GENERATED_INCLUDE_DIR := $(LOCAL_PATH)/generated

$(OATH_GENERATED_INCLUDE_DIR)/oath.h:
	mkdir -p $(dir $@)
	sed -e "s,@VERSION_NUMBER@,$(OATH_VERSION_NUMBER),g" -e "s,@VERSION@,$(OATH_VERSION),g" $(OATH_SOURCE_DIR)/oath.h.in > $@

$(OATH_GENERATED_INCLUDE_DIR)/stdalign.h: $(OATH_SOURCE_DIR)/gl/stdalign.in.h
	mkdir -p $(dir $@)
	cp $< $@

$(OATH_SOURCE_DIR)/coding.c: $(OATH_GENERATED_INCLUDE_DIR)/oath.h $(OATH_GENERATED_INCLUDE_DIR)/stdalign.h

LOCAL_CFLAGS := \
	-D_GL_ATTRIBUTE_CONST="__attribute__ ((__const__))" \
	-Drestrict="" \
	-D_GL_INLINE_HEADER_BEGIN="" \
	-D_GL_INLINE_HEADER_END="" \
	-DGNULIB_GC_HMAC_SHA1 \
	-DGNULIB_GC_HMAC_SHA256 \
	-DGNULIB_GC_HMAC_SHA512 \
	-fPIC

LOCAL_C_INCLUDES := \
	$(OATH_GENERATED_INCLUDE_DIR) \
	$(OATH_SOURCE_DIR)/gl

include $(BUILD_STATIC_LIBRARY)
