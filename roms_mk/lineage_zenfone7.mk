# Copyright (C) 2010 The Android Open Source Project
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
Rom_Name := lineage
# For CrdroidAndroid
WITH_GAPPS := true
# For Matrixx
WITH_GMS := true

AB_OTA_UPDATER := true

# Overlay
PRODUCT_ENFORCE_RRO_TARGETS := *
PRODUCT_ENFORCE_RRO_OVERLAYS += \
    device/asus/zenfone7/roms_overlays/overlay-lineage/lineage-sdk

# Sample: This is where we'd set a backup provider if we had one
# $(call inherit-product, device/sample/products/backup_overlay.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Soong namespaces
vendor_build_soong := $(wildcard vendor/*/build/soong)
PRODUCT_SOONG_NAMESPACES += \
    $(vendor_build_soong)

# SIM Toolkit
PRODUCT_PACKAGES += \
    Stk

# Inherit from the common Open Source product configuration
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base_telephony.mk)

# must be before including omni part
TARGET_BOOTANIMATION_SIZE := 1080p
TARGET_BOOT_ANIMATION_RES := 1080

# Depending on kind of rom , there are a case that both of common_full_phone.mk and common.mk
# or another case that only common.mk.
# So if common_full_phone.mk exists, prioritize it.
vendor_common_full_phone_mk := $(wildcard vendor/*/config/common_full_phone.mk)
vendor_common_mk := $(wildcard vendor/*/config/common.mk)
ifeq ($(vendor_common_full_phone_mk),)
include $(vendor_common_mk)
else
include $(vendor_common_full_phone_mk)
endif

# Inherit from hardware-specific part of the product configuration
$(call inherit-product, device/asus/zenfone7/device.mk)
$(call inherit-product, device/asus/sm8250-common/omni_common.mk)

# Discard inherited values and use our own instead.
PRODUCT_DEVICE := zenfone7
PRODUCT_NAME := $(Rom_Name)_zenfone7
PRODUCT_BRAND := asus
PRODUCT_MODEL := ASUS_I002D
PRODUCT_MANUFACTURER := asus

PRODUCT_GMS_CLIENTID_BASE := android-asus

TARGET_DEVICE := WW_I002D
PRODUCT_SYSTEM_DEVICE := ASUS_I002D
PRODUCT_SYSTEM_NAME := WW_I002D

PRODUCT_BUILD_PROP_OVERRIDES := \
    BuildFingerprint=asus/WW_I002D/ASUS_I002D:12/SKQ1.210821.001/31.0210.0210.324:user/release-keys \
    DeviceName=$(PRODUCT_SYSTEM_DEVICE) \
    DeviceProduct=$(PRODUCT_SYSTEM_NAME) \
    SystemDevice=$(PRODUCT_SYSTEM_DEVICE) \
    SystemName=$(PRODUCT_SYSTEM_NAME)

# Security patch level from stock
PLATFORM_SECURITY_PATCH_OVERRIDE := 2022-07-05
