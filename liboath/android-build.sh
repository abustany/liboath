#!/bin/sh

cd $(dirname $0)
rm -fr generated libs obj
make -f ~/.local/android-studio/android-ndk-r9c/build/core/build-local.mk APP_BUILD_SCRIPT=Android.mk V=1
