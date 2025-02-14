#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
#           (C) 2018 The Omnirom Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

DEVICE=zenfone7
VENDOR=asus

# Load extractutils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

CM_ROOT="$MY_DIR"/../../..

HELPER="$CM_ROOT"/vendor/omni/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# Default to sanitizing the vendor folder before extraction
CLEAN_VENDOR=true

while [ "$1" != "" ]; do
    case $1 in
        -p | --path )           shift
                                SRC=$1
                                ;;
        -s | --section )        shift
                                SECTION=$1
                                CLEAN_VENDOR=false
                                ;;
        -n | --no-cleanup )     CLEAN_VENDOR=false
                                ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

function blob_fixup() {
    case "${1}" in
    # Fix xml version
    system_ext/etc/permissions/vendor.qti.hardware.data.connection-V1.0-java.xml | system_ext/etc/permissions/vendor.qti.hardware.data.connection-V1.1-java.xml)
        sed -i 's|system/product|system_ext|g' "${2}"
        sed -i 's|xml version="2.0"|xml version="1.0"|g' "${2}"
        ;;
    vendor/etc/seccomp_policy/qspm.policy)
        echo "gettid: 1" >> "${2}"
        ;;
    vendor/lib64/libvendor.goodix.hardware.biometrics.fingerprint@2.1.so)
        sed -i "s/libhidltransport.so/libhidlbase_shim.so/" "${2}"
        ;;
    vendor/lib64/libwvhidl.so)
        "${PATCHELF}" --add-needed "libcrypto_shim.so" "${2}"
        ;;
    vendor/lib64/vendor.qti.hardware.camera.postproc@1.0-service-impl.so)
        "${SIGSCAN}" -p "13 0A 00 94" -P "1F 20 03 D5" -f "${2}"
        ;;
    esac
}

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$CM_ROOT" false "$CLEAN_VENDOR"

extract "$MY_DIR"/proprietary-files-vendor.txt "$SRC" "$SECTION"
extract "$MY_DIR"/proprietary-files-product.txt "$SRC" "$SECTION"
extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"

"$MY_DIR"/setup-makefiles.sh
