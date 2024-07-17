#
# Copyright (C) 2019 The LineageOS Project
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

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

OMNI_ROOT="$MY_DIR"/../../..

HELPER="$OMNI_ROOT"/vendor/omni/build/tools/extract_utils.sh

if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

if [ -z "$1" ]; then
    echo "No input image supplied"
    exit 1
fi

if [ -z "$2" ]; then
    echo "No output filename supplied"
    exit 1
fi

VENDOR_SKIP_FILES_COMMON=(

    # Asus setenforce
    "bin/sar_setting"
    "bin/savelogs.sh"
    "bin/savelogmtp.sh"
    "bin/setenforce.sh"

    # Audio
    "etc/boot_sound/boot_sound_1.wav"
    "etc/boot_sound/boot_sound_2.wav"
    "etc/boot_sound/boot_sound_3.wav"
    "etc/boot_sound/boot_sound_4.wav"
    "etc/boot_sound/boot_sound_5.wav"
    "etc/boot_sound/boot_sound_6.wav"
    "etc/boot_sound/boot_sound_7.wav"
    "etc/audio/audio_policy_configuration.xml"
    "etc/audio/audio_policy_configuration_ZS670KS.xml"
    "etc/audio_effects.xml"
    "etc/audio_effects_ZS670KS.xml"
    "etc/audio_io_policy.conf"
    "etc/audio_policy_configuration.xml"
    "etc/audio_policy_configuration_ZS670KS.xml"
    "etc/audio_policy_volumes.xml"
    "etc/audio_policy_volumes_ZS670KS.xml"
    "etc/audio_tuning_mixer.txt"
    "etc/permissions/android.hardware.bluetooth.xml"
    "etc/permissions/android.hardware.bluetooth_le.xml"
    "etc/bluetooth_qti_audio_policy_configuration.xml"
    "bin/hw/android.hardware.audio.service"
    "etc/init/android.hardware.audio.service.rc"
    "lib/android.hardware.audio.common-util.so"
    "lib/android.hardware.audio.common@2.0-util.so"
    "lib/android.hardware.audio.common@4.0-util.so"
    "lib/android.hardware.audio.common@5.0-util.so"
    "lib/android.hardware.audio.common@6.0-util.so"
    "lib/libbluetooth_audio_session.so"
    "lib/libcodec2_hidl@1.0.so"
    "lib/libcodec2_vndk.so"
    "lib/hw/android.hardware.audio.effect@2.0-impl.so"
    "lib/hw/android.hardware.audio.effect@4.0-impl.so"
    "lib/hw/android.hardware.audio.effect@5.0-impl.so"
    "lib/hw/android.hardware.audio.effect@6.0-impl.so"
    "lib/hw/android.hardware.audio@2.0-impl.so"
    "lib/hw/android.hardware.audio@4.0-impl.so"
    "lib/hw/android.hardware.audio@5.0-impl.so"
    "lib/hw/android.hardware.audio@6.0-impl.so"
    "lib/hw/android.hardware.bluetooth.audio@2.0-impl.so"
    "lib64/android.hardware.audio.common-util.so"
    "lib64/android.hardware.audio.common@2.0-util.so"
    "lib64/android.hardware.audio.common@4.0-util.so"
    "lib64/android.hardware.audio.common@5.0-util.so"
    "lib64/android.hardware.audio.common@6.0-util.so"
    "lib64/libbluetooth_audio_session.so"
    "lib64/libcodec2_hidl@1.0.so"
    "lib64/libcodec2_vndk.so"
    "lib64/hw/android.hardware.audio.effect@2.0-impl.so"
    "lib64/hw/android.hardware.audio.effect@4.0-impl.so"
    "lib64/hw/android.hardware.audio.effect@5.0-impl.so"
    "lib64/hw/android.hardware.audio.effect@6.0-impl.so"
    "lib64/hw/android.hardware.audio@2.0-impl.so"
    "lib64/hw/android.hardware.audio@4.0-impl.so"
    "lib64/hw/android.hardware.audio@5.0-impl.so"
    "lib64/hw/android.hardware.audio@6.0-impl.so"
    "lib64/hw/android.hardware.bluetooth.audio@2.0-impl.so"
    "lib/hw/audio.bluetooth.default.so"
    "lib64/hw/audio.bluetooth.default.so"
    "lib/hw/audio.primary.default.so"
    "lib64/hw/audio.primary.default.so"
    "lib/libeffects.so"
    "lib/libeffectsconfig.so"
    "lib64/libeffects.so"
    "lib64/libeffectsconfig.so"
    "lib/libnbaio_mono.so"
    "lib64/libnbaio_mono.so"

    # Binary
    "bin/acpi"
    "bin/applypatch"
    "bin/asus_mediaflag.sh"
    "bin/base64"
    "bin/basename"
    "bin/boringssl_self_test32"
    "bin/boringssl_self_test64"
    "bin/btnvtool"
    "bin/blockdev"
    "bin/cal"
    "bin/cat"
    "bin/chattr"
    "bin/chcon"
    "bin/checkpoint_gc"
    "bin/chgrp"
    "bin/chmod"
    "bin/chown"
    "bin/chroot"
    "bin/chrt"
    "bin/cksum"
    "bin/clear"
    "bin/cmp"
    "bin/comm"
    "bin/cp"
    "bin/cpio"
    "bin/cut"
    "bin/country.sh"
    "bin/cplay"
    "bin/csc/erase_batinfo.sh"
    "bin/csc/restore_batinfo.sh"
    "bin/cscclearlog.sh"
    "bin/ddr_info.sh"
    "bin/debug-diag"
    "bin/date"
    "bin/dd"
    "bin/df"
    "bin/diff"
    "bin/dirname"
    "bin/devmem"
    "bin/dmesg"
    "bin/dos2unix"
    "bin/du"
    "bin/echo"
    "bin/egrep"
    "bin/env"
    "bin/expand"
    "bin/expr"
    "bin/fallocate"
    "bin/false"
    "bin/fastrpc_tests_apps"
    "bin/fastrpc_tests_apps32"
    "bin/firmware_version.sh"
    "bin/fgrep"
    "bin/file"
    "bin/find"
    "bin/flock"
    "bin/fmt"
    "bin/free"
    "bin/fsync"
    "bin/getconf"
    "bin/getenforce"
    "bin/getevent"
    "bin/getprop"
    "bin/groups"
    "bin/gunzip"
    "bin/gzip"
    "bin/head"
    "bin/hostname"
    "bin/hwclock"
    "bin/i2cdetect"
    "bin/i2cdump"
    "bin/i2cget"
    "bin/i2cset"
    "bin/iconv"
    "bin/id"
    "bin/ifconfig"
    "bin/inotifyd"
    "bin/insmod"
    "bin/install"
    "bin/install_key_server"
    "bin/ionice"
    "bin/iorenice"
    "bin/irsc_util"
    "bin/is_hdcp_valid"
    "bin/kill"
    "bin/killall"
    "bin/ln"
    "bin/load_policy"
    "bin/log"
    "bin/logname"
    "bin/losetup"
    "bin/ls"
    "bin/lsattr"
    "bin/lsmod"
    "bin/lsof"
    "bin/lspci"
    "bin/lsusb"
    "bin/md5sum"
    "bin/microcom"
    "bin/mkdir"
    "bin/mkfifo"
    "bin/mknod"
    "bin/mkswap"
    "bin/mktemp"
    "bin/modinfo"
    "bin/modprobe"
    "bin/more"
    "bin/mount"
    "bin/mountpoint"
    "bin/mv"
    "bin/nc"
    "bin/netcat"
    "bin/netstat"
    "bin/newfs_msdos"
    "bin/nice"
    "bin/nl"
    "bin/nohup"
    "bin/nproc"
    "bin/nsenter"
    "bin/od"
    "bin/paste"
    "bin/patch"
    "bin/pgrep"
    "bin/pidof"
    "bin/pkill"
    "bin/pmap"
    "bin/prepare_asusdebug.sh"
    "bin/printenv"
    "bin/printf"
    "bin/ps"
    "bin/pwd"
    "bin/qmi-framework-tests/qmi_test_mt_client_init_instance"
    "bin/readlink"
    "bin/readelf"
    "bin/realpath"
    "bin/renice"
    "bin/restorecon"
    "bin/rm"
    "bin/rmdir"
    "bin/rmmod"
    "bin/runcon"
    "bin/sed"
    "bin/sendevent"
    "bin/seq"
    "bin/setenforce"
    "bin/setprop"
    "bin/setsid"
    "bin/sha1sum"
    "bin/sha224sum"
    "bin/sha256sum"
    "bin/sha384sum"
    "bin/sha512sum"
    "bin/sleep"
    "bin/sort"
    "bin/split"
    "bin/start"
    "bin/stat"
    "bin/stop"
    "bin/strings"
    "bin/stty"
    "bin/swapoff"
    "bin/swapon"
    "bin/sync"
    "bin/sysctl"
    "bin/tac"
    "bin/tail"
    "bin/tar"
    "bin/taskset"
    "bin/tee"
    "bin/test"
    "bin/test_BinMerge"
    "bin/test_DualCamQcomAECali"
    "bin/test_ShadingCaliForQcom"
    "bin/test_aeCali"
    "bin/test_afCaliDB"
    "bin/test_chkCali"
    "bin/test_diag"
    "bin/test_genCali"
    "bin/test_qafCali"
    "bin/testapp_diag_senddata"
    "bin/time"
    "bin/timeout"
    "bin/top"
    "bin/touch"
    "bin/touch_ver.sh"
    "bin/tr"
    "bin/true"
    "bin/truncate"
    "bin/tty"
    "bin/ulimit"
    "bin/umount"
    "bin/uname"
    "bin/uniq"
    "bin/unix2dos"
    "bin/unlink"
    "bin/unshare"
    "bin/uptime"
    "bin/usleep"
    "bin/uudecode"
    "bin/uuencode"
    "bin/uuidgen"
    "bin/UTSdumpstate.sh"
    "bin/UpdateAttestationKey"
    "bin/UpdateDeviceName"
    "bin/ubwcconvert"
    "bin/ufs_info.sh"
    "bin/vmstat"
    "bin/watch"
    "bin/wc"
    "bin/which"
    "bin/whoami"
    "bin/WifiAntenna.sh"
    "bin/WifiMac.sh"
    "bin/WifiSARPower.sh"
    "bin/xargs"
    "bin/xxd"
    "bin/yes"
    "bin/zcat"

    # build.prop for Region specific
    "build_eu.prop"
    "build_ru_0.prop"
    "build_ru_1.prop"
    "default.prop"

    # Camera
    "etc/init/android.hardware.camera.provider@2.4-service_64.rc"
    "lib/vendor.qti.hardware.camera.postproc@1.0-service-impl.so"

    # Cas
    "bin/hw/android.hardware.cas@1.2-service"
    "etc/init/android.hardware.cas@1.2-service.rc"
    "etc/vintf/manifest/android.hardware.cas@1.2-service.xml"

    # config.fs
    "etc/fs_config_dirs"
    "etc/fs_config_files"
    "etc/group"
    "etc/passwd"

    # ConfigStore
    "bin/hw/android.hardware.configstore@1.1-service"
    "bin/hw/capabilityconfigstoretest"
    "etc/init/android.hardware.configstore@1.1-service.rc"
    "etc/seccomp_policy/configstore@1.1.policy"

    # Crypto and Km
    "bin/hw/android.hardware.keymaster@3.0-service-qti"
    "bin/hw/android.hardware.keymaster@4.1-service-qti"
    "bin/hw/android.hardware.keymaster@4.0-strongbox-service-qti"
    "lib/hw/android.hardware.keymaster@3.0-impl-qti.so"
    "lib64/hw/android.hardware.keymaster@3.0-impl-qti.so"
    "lib/libkeymasterdeviceutils.so"
    "lib/libkeymasterprovision.so"
    "lib/libkeymasterutils.so"
    "lib/libqtikeymaster4.so"
    "lib/libspcom.so"
    "bin/hw/vendor.qti.hardware.cryptfshw@1.0-service-qti"
    "etc/init/vendor.qti.hardware.cryptfshw@1.0-service-qti.rc"
    "lib/libcryptfshwcommon.so"
    "lib/libcryptfshwhidl.so"
    "lib64/libcryptfshwcommon.so"
    "lib64/libcryptfshwhidl.so"
    "lib/vendor.qti.hardware.cryptfshw@1.0.so"
    "lib64/vendor.qti.hardware.cryptfshw@1.0.so"

    # Display
    "lib/libqdMetaData.so"
    "lib64/libqdMetaData.so"
    "lib/libgralloc.qti.so"
    "lib64/libgralloc.qti.so"
    "lib/libdisplayconfig.qti.so"
    "lib64/libdisplayconfig.qti.so"
    "lib/vendor.display.config@1.0.so"
    "lib/vendor.display.config@1.1.so"
    "lib/vendor.display.config@1.10.so"
    "lib/vendor.display.config@1.11.so"
    "lib/vendor.display.config@1.2.so"
    "lib/vendor.display.config@1.3.so"
    "lib/vendor.display.config@1.4.so"
    "lib/vendor.display.config@1.5.so"
    "lib/vendor.display.config@1.6.so"
    "lib/vendor.display.config@1.7.so"
    "lib/vendor.display.config@1.8.so"
    "lib/vendor.display.config@1.9.so"
    "lib/vendor.display.config@2.0.so"
    "lib64/vendor.display.config@1.0.so"
    "lib64/vendor.display.config@1.1.so"
    "lib64/vendor.display.config@1.10.so"
    "lib64/vendor.display.config@1.11.so"
    "lib64/vendor.display.config@1.2.so"
    "lib64/vendor.display.config@1.3.so"
    "lib64/vendor.display.config@1.4.so"
    "lib64/vendor.display.config@1.5.so"
    "lib64/vendor.display.config@1.6.so"
    "lib64/vendor.display.config@1.7.so"
    "lib64/vendor.display.config@1.8.so"
    "lib64/vendor.display.config@1.9.so"
    "lib64/vendor.display.config@2.0.so"
    "etc/init/vendor.qti.hardware.display.allocator-service.rc"
    "etc/init/vendor.qti.hardware.display.composer-service.rc"
    "etc/vintf/manifest/vendor.qti.hardware.display.composer-service.xml"
    "etc/vintf/manifest/android.hardware.graphics.mapper-impl-qti-display.xml"
    "etc/vintf/manifest/vendor.qti.hardware.display.allocator-service.xml"
    "lib64/vendor.qti.hardware.display.composer@1.0.so"
    "lib64/vendor.qti.hardware.display.composer@2.0.so"
    "lib64/vendor.qti.hardware.display.composer@2.1.so"
    "lib64/vendor.qti.hardware.display.composer@3.0.so"
    "lib/vendor.qti.hardware.display.composer@1.0.so"
    "lib/vendor.qti.hardware.display.composer@2.0.so"
    "lib/vendor.qti.hardware.display.composer@2.1.so"
    "etc/init/android.hardware.memtrack@1.0-service.rc"
    "bin/hw/android.hardware.memtrack@1.0-service"
    "bin/hw/vendor.qti.hardware.display.allocator-service"
    "bin/hw/vendor.qti.hardware.display.composer-service"
    "lib64/hw/android.hardware.memtrack@1.0-impl.so"
    "lib/hw/android.hardware.memtrack@1.0-impl.so"
    "lib64/hw/android.hardware.renderscript@1.0-impl.so"
    "lib/hw/android.hardware.renderscript@1.0-impl.so"
    "lib/hw/android.hardware.graphics.mapper@3.0-impl-qti-display.so"
    "lib/hw/android.hardware.graphics.mapper@4.0-impl-qti-display.so"
    "lib64/hw/android.hardware.graphics.mapper@3.0-impl-qti-display.so"
    "lib64/hw/android.hardware.graphics.mapper@4.0-impl-qti-display.so"
    "lib64/hw/gralloc.kona.so"
    "lib/hw/gralloc.kona.so"
    "lib64/hw/memtrack.kona.so"
    "lib/hw/memtrack.kona.so"
    "lib64/hw/lights.kona.so"
    "lib/hw/lights.kona.so"
    "lib64/libdrm.so"
    "lib64/libdrmutils.so"
    "lib64/libgpu_tonemapper.so"
    "lib64/libgralloccore.so"
    "lib64/libgrallocutils.so"
    "lib64/libqdutils.so"
    "lib64/libqservice.so"
    "lib64/libdisplaydebug.so"
    "lib64/libhistogram.so"
    "lib/libdrm.so"
    "lib/libdrmutils.so"
    "lib/libgpu_tonemapper.so"
    "lib/libgralloccore.so"
    "lib/libgrallocutils.so"
    "lib/libqdutils.so"
    "lib/libqservice.so"
    "lib/libdisplaydebug.so"
    "lib/libhistogram.so"
    "bin/irisConfig"
    "etc/irissoft_o.fw"
    "etc/irissoft_t.fw"
    "lib/libirisService.so"
    "lib/libpwiriscalibrate.so"
    "lib/libpwirissoft.so"
    "lib/libpwsnapdragoncolor.so"
    "lib/libpwsoftirisPCS.so"
    "lib64/libirisService.so"
    "lib64/libpwiriscalibrate.so"
    "lib64/libpwirissoft.so"
    "lib64/libpwsnapdragoncolor.so"
    "lib64/libpwsoftirisPCS.so"
    "lib/vendor.pixelworks.hardware.display@1.0.so"
    "lib64/vendor.pixelworks.hardware.display@1.0.so"
    "lib/vendor.qti.hardware.display.allocator@1.0.so"
    "lib/vendor.qti.hardware.display.allocator@3.0.so"
    "lib/vendor.qti.hardware.display.mapper@1.0.so"
    "lib/vendor.qti.hardware.display.mapper@1.1.so"
    "lib/vendor.qti.hardware.display.mapper@2.0.so"
    "lib/vendor.qti.hardware.display.mapper@3.0.so"
    "lib/vendor.qti.hardware.display.mapper@4.0.so"
    "lib/vendor.qti.hardware.display.mapperextensions@1.0.so"
    "lib/vendor.qti.hardware.display.mapperextensions@1.1.so"
    "lib64/vendor.qti.hardware.display.allocator@1.0.so"
    "lib64/vendor.qti.hardware.display.allocator@3.0.so"
    "lib64/vendor.qti.hardware.display.allocator@4.0.so"
    "lib64/vendor.qti.hardware.display.mapper@1.0.so"
    "lib64/vendor.qti.hardware.display.mapper@1.1.so"
    "lib64/vendor.qti.hardware.display.mapper@2.0.so"
    "lib64/vendor.qti.hardware.display.mapper@3.0.so"
    "lib64/vendor.qti.hardware.display.mapper@4.0.so"
    "lib64/vendor.qti.hardware.display.mapperextensions@1.0.so"
    "lib64/vendor.qti.hardware.display.mapperextensions@1.1.so"
    "lib64/libsdedrm.so"
    "lib64/libsdmcore.so"
    "lib64/libsdmutils.so"
    "lib/libsdedrm.so"
    "lib/libsdmcore.so"
    "lib/libsdmutils.so"

    # DRM
    "bin/hw/android.hardware.drm@1.3-service.clearkey"
    "etc/init/android.hardware.drm@1.3-service.clearkey.rc"
    "etc/vintf/manifest/manifest_android.hardware.drm@1.3-service.clearkey.xml"

    # Fingerprint
    "bin/hw/android.hardware.biometrics.fingerprint@2.1-service"
    "etc/init/android.hardware.biometrics.fingerprint@2.1-service.rc"
    "etc/vintf/manifest/android.hardware.biometrics.fingerprint@2.1-service.xml"

    # Health
    "bin/hw/android.hardware.health@2.1-service"
    "etc/init/android.hardware.health@2.1-service.rc"
    "etc/vintf/manifest/android.hardware.health@2.1.xml"
    "lib/hw/android.hardware.health@2.0-impl-2.1.so"
    "lib64/hw/android.hardware.health@2.0-impl-2.1.so"

    # Init Scripts
    "bin/init.asus.check_asdf.sh"
    "bin/init.asus.check_last.sh"
    "bin/init.asus.checkdevcfg.sh"
    "bin/init.class_main.sh"
    "bin/init.qcom.early_boot.sh"
    "bin/init.qcom.post_boot.sh"
    "bin/init.qcom.sh"
    "etc/init/init.asus.rc"
    "etc/init/hw/init.asus.debugtool.rc"
    "etc/init/hw/init.qcom.rc"
    "etc/init/hw/init.target.rc"

    # Launcher
    "etc/workspace_grid_setting.xml"
    "etc/CN/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/CN/ASUS/Launcher/default_workspace/phone_workspace.xml"
    "etc/CN/ASUS/Launcher/default_workspace/phone_workspace_single.xml"
    "etc/EU/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/EU/ASUS/Launcher/default_workspace/phone_workspace.xml"
    "etc/Generic/Launcher/default_workspace/default_allapp.xml"
    "etc/Generic/Launcher/default_workspace/phone_workspace.xml"
    "etc/ID/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/ID/ASUS/Launcher/default_workspace/phone_workspace.xml"
    "etc/JP/ACJ/Launcher/default_workspace/default_allapp.xml"
    "etc/JP/ACJ/Launcher/default_workspace/phone_workspace.xml"
    "etc/JP/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/JP/ASUS/Launcher/default_workspace/phone_workspace.xml"
    "etc/RU/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/RU/ASUS/Launcher/default_workspace/phone_workspace.xml"
    "etc/TW/APTG/Launcher/default_workspace/default_allapp.xml"
    "etc/TW/APTG/Launcher/default_workspace/phone_workspace.xml"
    "etc/TW/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/TW/ASUS/Launcher/default_workspace/phone_workspace.xml"
    "etc/US/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/US/ASUS/Launcher/default_workspace/phone_workspace.xml"
    "etc/WW/ASUS/Launcher/default_workspace/default_allapp.xml"
    "etc/WW/ASUS/Launcher/default_workspace/phone_workspace.xml"

    # Logs
    "bin/init.asus.checkdatalog.sh"
    "bin/init.asus.checklogsize.sh"
    "bin/init.asus.kernelmessage.sh"

    # Manifest
    "etc/vintf/manifest.xml"
    "etc/vintf/manifest/manifest.xml"

    # Media
    "bin/hw/android.hardware.media.omx@1.0-service"
    "etc/init/android.hardware.media.omx@1.0-service.rc"
    "lib/libstagefright_bufferpool@2.0.1.so"
    "lib/libstagefright_soft_aacdec.so"
    "lib/libstagefright_soft_aacenc.so"
    "lib/libstagefright_soft_amrdec.so"
    "lib/libstagefright_soft_amrnbenc.so"
    "lib/libstagefright_soft_amrwbenc.so"
    "lib/libstagefright_soft_avcdec.so"
    "lib/libstagefright_soft_avcenc.so"
    "lib/libstagefright_soft_flacdec.so"
    "lib/libstagefright_soft_flacenc.so"
    "lib/libstagefright_soft_g711dec.so"
    "lib/libstagefright_soft_gsmdec.so"
    "lib/libstagefright_soft_hevcdec.so"
    "lib/libstagefright_soft_mp3dec.so"
    "lib/libstagefright_soft_mpeg2dec.so"
    "lib/libstagefright_soft_mpeg4dec.so"
    "lib/libstagefright_soft_mpeg4enc.so"
    "lib/libstagefright_soft_opusdec.so"
    "lib/libstagefright_soft_rawdec.so"
    "lib/libstagefright_soft_vorbisdec.so"
    "lib/libstagefright_soft_vpxdec.so"
    "lib/libstagefright_soft_vpxenc.so"
    "lib/libstagefright_softomx.so"
    "lib/libstagefright_softomx_plugin.so"
    "lib64/libstagefright_bufferpool@2.0.1.so"
    "lib64/libstagefright_softomx.so"
    "lib/vndk/libstagefright_foundation.so"
    "lib/vndk/libstagefright_omx.so"

    # Modules
    "lib/modules/audio_adsp_loader.ko"
    "lib/modules/audio_apr.ko"
    "lib/modules/audio_bolero_cdc.ko"
    "lib/modules/audio_hdmi.ko"
    "lib/modules/audio_machine_kona.ko"
    "lib/modules/audio_mbhc.ko"
    "lib/modules/audio_native.ko"
    "lib/modules/audio_pinctrl_lpi.ko"
    "lib/modules/audio_pinctrl_wcd.ko"
    "lib/modules/audio_platform.ko"
    "lib/modules/audio_q6.ko"
    "lib/modules/audio_q6_notifier.ko"
    "lib/modules/audio_q6_pdr.ko"
    "lib/modules/audio_rx_macro.ko"
    "lib/modules/audio_snd_event.ko"
    "lib/modules/audio_stub.ko"
    "lib/modules/audio_swr.ko"
    "lib/modules/audio_swr_ctrl.ko"
    "lib/modules/audio_tfa9874.ko"
    "lib/modules/audio_tx_macro.ko"
    "lib/modules/audio_usf.ko"
    "lib/modules/audio_va_macro.ko"
    "lib/modules/audio_wcd938x.ko"
    "lib/modules/audio_wcd938x_slave.ko"
    "lib/modules/audio_wcd9xxx.ko"
    "lib/modules/audio_wcd_core.ko"
    "lib/modules/audio_wsa_macro.ko"
    "lib/modules/gspca_main.ko"
    "lib/modules/lcd.ko"
    "lib/modules/llcc_perfmon.ko"
    "lib/modules/modules.alias"
    "lib/modules/modules.dep"
    "lib/modules/modules.load"
    "lib/modules/modules.softdep"
    "lib/modules/mpq-adapter.ko"
    "lib/modules/mpq-dmx-hw-plugin.ko"
    "lib/modules/qca_cld3_qca6390.ko"
    "lib/modules/qca_cld3_qca6490.ko"
    "lib/modules/rdbg.ko"
    "lib/modules/rmnet_perf.ko"
    "lib/modules/rmnet_shs.ko"
    "lib/modules/texfat.ko"
    "lib/modules/tntfs.ko"

    # Other services
    "ueventd.rc"
    "bin/asus_osinfo"
    "bin/hw/android.hardware.atrace@1.0-service"
    "etc/init/android.hardware.atrace@1.0-service.rc"
    "etc/vintf/manifest/android.hardware.atrace@1.0-service.xml"
    "bin/netutild"
    "etc/init/netutild.rc"
    "bin/hw/vendor.asus.wifi.netutil@1.0-service"
    "etc/init/vendor.asus.wifi.netutil@1.0-service.rc"
    "lib64/vendor.asus.wifi.netutil@1.0.so"
    "bin/hw/vendor.ims.glovemode@1.0-service"
    "etc/init/vendor.ims.glovemode@1.0-service.rc"
    "lib64/vendor.ims.glovemode@1.0.so"
    "bin/hw/vendor.ims.zenmotion@1.0-service"
    "etc/init/vendor.ims.zenmotion@1.0-service.rc"
    "lib64/vendor.ims.zenmotion@1.0.so"
    "bin/hw/vendor.ims.twinviewdock@1.0-service"
    "etc/init/vendor.ims.twinviewdock@1.0-service.rc"
    "lib64/vendor.ims.twinviewdock@1.0.so"
    "bin/hw/vendor.ims.wifiantennamode@1.0-service"
    "etc/init/vendor.ims.wifiantennamode@1.0-service.rc"
    "lib64/vendor.ims.wifiantennamode@1.0.so"
    "etc/init/vendor_flash_recovery.rc"
    "etc/init/vndservicemanager.rc"
    "bin/vndservice"
    "bin/vndservicemanager"
    "etc/ftm_test_config"
    "etc/ftm_test_config_qrd"
    "lib/libhidltransport.so"
    "lib64/libhidltransport.so"
    "lib/libhwbinder.so"
    "lib64/libhwbinder.so"
    "lib/libavservices_minijail.so"
    "lib64/libavservices_minijail.so"
    "lib/libavservices_minijail_vendor.so"
    "etc/init/boringssl_self_test.rc"
    "app/CACertService/oat/arm64/CACertService.odex"
    "app/CACertService/oat/arm64/CACertService.vdex"
    "app/CneApp/oat/arm64/CneApp.odex"
    "app/CneApp/oat/arm64/CneApp.vdex"
    "app/IWlanService/oat/arm64/IWlanService.odex"
    "app/IWlanService/oat/arm64/IWlanService.vdex"
    "app/TimeService/oat/arm64/TimeService.odex"
    "app/TimeService/oat/arm64/TimeService.vdex"
    "app/ifaa_service/oat/arm64/ifaa_service.odex"
    "app/ifaa_service/oat/arm64/ifaa_service.vdex"
    "bin/hw/vendor.ims.airtrigger@1.2-service"
    "etc/init/vendor.ims.airtrigger@1.2-service.rc"
    "lib64/vendor.ims.airtrigger@1.0.so"
    "lib64/vendor.ims.airtrigger@1.1.so"
    "lib64/vendor.ims.airtrigger@1.2.so"
    "lib/vendor.qti.hardware.perf@2.0.so"
    "lib/vendor.qti.hardware.perf@2.1.so"
    "lib/vendor.qti.hardware.perf@2.2.so"
    "lib64/vendor.qti.hardware.perf@2.0.so"
    "lib64/vendor.qti.hardware.perf@2.1.so"
    "lib64/vendor.qti.hardware.perf@2.2.so"

    # Overlays
    "overlay/FrameworksResTarget.apk"
    "overlay/WifiResTarget.apk"

    # rfs
    "rfs/apq/gnss/hlos"
    "rfs/apq/gnss/ramdumps"
    "rfs/apq/gnss/readonly/firmware"
    "rfs/apq/gnss/readonly/vendor/firmware"
    "rfs/apq/gnss/readwrite"
    "rfs/apq/gnss/shared"
    "rfs/mdm/adsp/hlos"
    "rfs/mdm/adsp/ramdumps"
    "rfs/mdm/adsp/readonly/firmware"
    "rfs/mdm/adsp/readonly/vendor/firmware"
    "rfs/mdm/adsp/readwrite"
    "rfs/mdm/adsp/shared"
    "rfs/mdm/cdsp/hlos"
    "rfs/mdm/cdsp/ramdumps"
    "rfs/mdm/cdsp/readonly/firmware"
    "rfs/mdm/cdsp/readwrite"
    "rfs/mdm/cdsp/shared"
    "rfs/mdm/mpss/hlos"
    "rfs/mdm/mpss/ramdumps"
    "rfs/mdm/mpss/readonly/firmware"
    "rfs/mdm/mpss/readonly/vendor/firmware"
    "rfs/mdm/mpss/readwrite"
    "rfs/mdm/mpss/shared"
    "rfs/mdm/slpi/hlos"
    "rfs/mdm/slpi/ramdumps"
    "rfs/mdm/slpi/readonly/firmware"
    "rfs/mdm/slpi/readwrite"
    "rfs/mdm/slpi/shared"
    "rfs/mdm/tn/hlos"
    "rfs/mdm/tn/ramdumps"
    "rfs/mdm/tn/readonly/firmware"
    "rfs/mdm/tn/readwrite"
    "rfs/mdm/tn/shared"
    "rfs/msm/adsp/hlos"
    "rfs/msm/adsp/ramdumps"
    "rfs/msm/adsp/readonly/firmware"
    "rfs/msm/adsp/readonly/vendor/firmware"
    "rfs/msm/adsp/readwrite"
    "rfs/msm/adsp/shared"
    "rfs/msm/cdsp/hlos"
    "rfs/msm/cdsp/ramdumps"
    "rfs/msm/cdsp/readonly/firmware"
    "rfs/msm/cdsp/readonly/vendor/firmware"
    "rfs/msm/cdsp/readwrite"
    "rfs/msm/cdsp/shared"
    "rfs/msm/mpss/hlos"
    "rfs/msm/mpss/ramdumps"
    "rfs/msm/mpss/readonly/firmware"
    "rfs/msm/mpss/readonly/vendor/firmware"
    "rfs/msm/mpss/readwrite"
    "rfs/msm/mpss/shared"
    "rfs/msm/slpi/hlos"
    "rfs/msm/slpi/ramdumps"
    "rfs/msm/slpi/readonly/firmware"
    "rfs/msm/slpi/readonly/vendor/firmware"
    "rfs/msm/slpi/readwrite"
    "rfs/msm/slpi/shared"

    # Sepolicy
    "etc/selinux/plat_pub_versioned.cil"
    "etc/selinux/plat_sepolicy_vers.txt"
    "etc/selinux/precompiled_sepolicy"
    "etc/selinux/precompiled_sepolicy.plat_sepolicy_and_mapping.sha256"
    "etc/selinux/precompiled_sepolicy.product_sepolicy_and_mapping.sha256"
    "etc/selinux/precompiled_sepolicy.system_ext_sepolicy_and_mapping.sha256"
    "etc/selinux/selinux_denial_metadata"
    "etc/selinux/vendor_file_contexts"
    "etc/selinux/vendor_hwservice_contexts"
    "etc/selinux/vendor_mac_permissions.xml"
    "etc/selinux/vendor_property_contexts"
    "etc/selinux/vendor_seapp_contexts"
    "etc/selinux/vendor_sepolicy.cil"
    "etc/selinux/vendor_service_contexts"
    "etc/selinux/vndservice_contexts"

    # Symlink
    "asusfw"
    "factory"
    "odm"

    # Vibrator
    "etc/init/vendor.qti.hardware.vibrator.service.rc"
    "etc/vintf/manifest/vendor.qti.hardware.vibrator.service.xml"
    "bin/hw/vendor.qti.hardware.vibrator.service"
    "lib64/vendor.qti.hardware.vibrator.impl.so"

    # Wifi
    "bin/wifilearner"
    "bin/hw/android.hardware.wifi@1.0-service"
    "etc/init/android.hardware.wifi@1.0-service.rc"
    "etc/vintf/manifest/android.hardware.wifi@1.0-service.xml"
    "etc/init/vendor.qti.hardware.wifi.wifilearner@1.0-service.rc"
    "etc/wifi/qca6390/WCNSS_qcom_cfg.ini"
    "etc/wifi/qca6490/WCNSS_qcom_cfg.ini"
    "lib64/vendor.qti.hardware.wifi.wifilearner@1.0.so"
    "bin/hostapd_cli"
    "bin/hw/hostapd"
    "etc/hostapd/hostapd.accept"
    "etc/hostapd/hostapd.deny"
    "etc/hostapd/hostapd_default.conf"
    "etc/init/hostapd.android.rc"
    "bin/fstman"
    "etc/init/vendor.qti.hardware.fstman@1.0-service.rc"
    "etc/wifi/fstman.ini"
    "lib64/vendor.qti.hardware.fstman@1.0.so"
    "etc/wifi/aoa_cldb_falcon.bin"
    "etc/wifi/aoa_cldb_swl14.bin"
    "etc/wifi/icm.conf"
    "etc/wifi/wpa_supplicant_overlay.conf"
    "bin/hw/wpa_supplicant"
    "firmware/wlan/qca_cld/COUNTRY"
    "firmware/wlan/qca_cld/qca6390/WCNSS_qcom_cfg.ini"
    "firmware/wlan/qca_cld/qca6390/wlan_mac.bin"
    "firmware/wlan/qca_cld/qca6490/wlan_mac.bin"
    "lib64/libkeystore-engine-wifi-hidl.so"
    "lib64/libkeystore-wifi-hidl.so"
    "lib/libwifi-hal-ctrl.so"
    "lib/libwifi-hal-qcom.so"
    "lib/libwpa_client.so"
    "lib64/libwpa_client.so"
    "lib64/libwifi-hal.so"
    "lib64/libwifi-hal-ctrl.so"
    "lib64/libwifi-hal-qcom.so"

    # WifiDisplay
    "bin/wfdhdcphalservice"
    "bin/wfdvndservice"
    "bin/wifidisplayhalservice"
    "etc/ArmHDCP_QTI_Android.cfg"
    "etc/init/android.hardware.drm@1.1-service.wfdhdcp.rc"
    "etc/init/com.qualcomm.qti.wifidisplayhal@1.0-service.rc"
    "etc/init/wfdvndservice.rc"
    "etc/seccomp_policy/wfdhdcphalservice.policy"
    "etc/seccomp_policy/wfdvndservice.policy"
    "etc/seccomp_policy/wifidisplayhalservice.policy"
    "etc/wfdconfig.xml"
    "etc/wfdconfig_720.xml"
    "etc/wfdconfig_MI.xml"
    "lib/libDxHdcp.so"
    "lib/libFileMux_proprietary.so"
    "lib/libmm-hdcpmgr.so"
    "lib/libmmrtpdecoder_proprietary.so"
    "lib/libmmrtpencoder_proprietary.so"
    "lib/libwfdaac_vendor.so"
    "lib/libwfdcodecv4l2_proprietary.so"
    "lib/libwfdcommonutils_proprietary.so"
    "lib/libwfdconfigutils_proprietary.so"
    "lib/libwfddisplayconfig_proprietary.so"
    "lib/libwfdhdcpcp.so"
    "lib/libwfdhdcpservice_proprietary.so"
    "lib/libwfdmminterface_proprietary.so"
    "lib/libwfdmmservice_proprietary.so"
    "lib/libwfdmmsrc_proprietary.so"
    "lib/libwfdmodulehdcpsession.so"
    "lib/libwfdrtsp_proprietary.so"
    "lib/libwfdsessionmodule.so"
    "lib/libwfdsourcesession_proprietary.so"
    "lib/libwfdsourcesm_proprietary.so"
    "lib/libwfduibcinterface_proprietary.so"
    "lib/libwfduibcsink_proprietary.so"
    "lib/libwfduibcsinkinterface_proprietary.so"
    "lib/libwfduibcsrc_proprietary.so"
    "lib/libwfduibcsrcinterface_proprietary.so"
    "lib/libwfdutils_proprietary.so"
    "lib/vendor.qti.hardware.wifidisplaysession@1.0.so"
    "lib/vendor.qti.hardware.wifidisplaysessionl@1.0-halimpl.so"
    "lib64/libmm-hdcpmgr.so"
    "lib64/libwfddisplayconfig_proprietary.so"
    "lib64/libwfdhdcpcp.so"
    "lib64/vendor.qti.hardware.wifidisplaysession@1.0.so"
)
ALL_SKIP_FILES=("${VENDOR_SKIP_FILES_COMMON[@]}" "${VENDOR_SKIP_FILES_DEVICE[@]}")

generate_prop_list_from_image "$1" "$2" ALL_SKIP_FILES

# Fixups
_output_file=$2
function presign() {
    sed -i "s|vendor/$1$|vendor/$1;PRESIGNED|g" $_output_file
}
function as_module() {
    sed -i "s|vendor/$1$|-vendor/$1|g" $_output_file
}

presign "app/com.qualcomm.qti.gpudrivers.lahaina.api30/com.qualcomm.qti.gpudrivers.lahaina.api30.apk"

as_module "lib/libthermalclient.so"
as_module "lib64/libthermalclient.so"

