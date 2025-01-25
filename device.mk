# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2019 The OmniRom Project
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
# This file is the build configuration for a full Android
# build for grouper hardware. This cleanly combines a set of
# device-specific aspects (drivers) with a device-agnostic
# product configuration (apps).
#

# Overlays
DEVICE_PACKAGE_OVERLAYS += \
    $(LOCAL_PATH)/overlay

PRODUCT_PACKAGES += \
    FrameworksResDeviceOverlay \
    FrameworksResVendorOverlay \
    SystemUIDeviceOverlay

ifeq ($(ROM_BUILDTYPE),$(filter $(ROM_BUILDTYPE),GAPPS))
# Android Auto
PRODUCT_PACKAGES += \
    AndroidAutoStub
endif

# Additional apps
PRODUCT_PACKAGES += \
    WallpaperCropper2 \
    MatLog \

# /system_ext packages
PRODUCT_PACKAGES += \
    Provision \
    WallpaperCropper

ifeq ($(ROM_BUILDTYPE),GAPPS)
PRODUCT_PACKAGES += \
    Launcher3QuickStepGoogle
else
PRODUCT_PACKAGES += \
    Launcher3QuickStepMock
endif

# Additional tools
PRODUCT_PACKAGES += \
    vim \
    e2fsck \
    mkfs.exfat \
    vncflinger \
    vncpasswd \
    fsck.exfat \
    mke2fs \
    tune2fs \
    lsof

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig
    
# Api
BOARD_SHIPPING_API_LEVEL := 29
PRODUCT_SHIPPING_API_LEVEL := $(BOARD_SHIPPING_API_LEVEL)

# audio
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio/audio_effects_ZS670KS.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_effects.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration_ZS670KS.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_configuration_ZS670KS.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(LOCAL_PATH)/audio/audio_policy_volumes_ZS670KS.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes_ZS670KS.xml

# Configstore
PRODUCT_PACKAGES += \
    disable_configstore

# DRM
PRODUCT_PACKAGES += \
    libcrypto_shim.vendor

# Fingerprint
PRODUCT_PACKAGES += \
    android.hardware.biometrics.fingerprint@2.1-service \
    libhidlbase_shim

# Input
PRODUCT_PACKAGES += \
    fts_ts.idc

PRODUCT_PACKAGES += \
    fts_ts.kl \
    goodixfp.kl

# Perf
PRODUCT_PACKAGES += \
    vendor.qti.hardware.perf@2.3 \
    vendor.qti.hardware.perf@2.3.vendor

# Prebuilt
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,device/asus/zenfone7/prebuilt/system,system) \
    $(call find-copy-subdir-files,*,device/asus/zenfone7/prebuilt/root,recovery/root) \
    $(call find-copy-subdir-files,*,device/asus/zenfone7/prebuilt/vendor,vendor)

PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi

# Shims
PRODUCT_PACKAGES += \
    libgui_shim

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH)

# Vibrator
PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service

# Inherit from asus sm8250-common
$(call inherit-product, device/asus/sm8250-common/common.mk)

# Inherit from vendor blobs
$(call inherit-product, vendor/asus/zenfone7/zenfone7-vendor.mk)
