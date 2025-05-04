The following typical local manifests are available for the Lineage-22.1 branch.
For the remove-project name block, you will need to customize it for different types of rom.
```
<?xml version="1.0" encoding="UTF-8"?>
<!--Please do not manually edit this file-->
<manifest>
  <remote name="BrightTwikling"  fetch="https://github.com/BrightTwikling" />
  <remote name="LineageOS2"      fetch="https://github.com/LineageOS" />
  <remote name="crdroidandroid2" fetch="https://github.com/crdroidandroid" />

  <!-- remove-project name -->
  <remove-project name="LineageOS/android_hardware_qcom_audio"   />
  <remove-project name="LineageOS/android_hardware_qcom_display" />
  <remove-project name="LineageOS/android_hardware_qcom_media"   />
  <remove-project name="LineageOS/android_hardware_qcom_wlan"    />

  <!-- Main repository -->
  <project path="device/asus/zenfone7"                           name="omnirom_device_asus_zenfone7"                             remote="BrightTwikling"  revision="lineage-22.1"      />
  <project path="kernel/asus/sm8250"                             name="omnirom_kernel_asus_sm8250"                               remote="BrightTwikling"  revision="android-15"        />
  <project path="hardware/qcom-caf/sm8250/display"               name="omnirom_hardware_qcom_display"                            remote="BrightTwikling"  revision="android-15-sm8250" />

  <!-- clang -->
  <remove-project name="platform/prebuilts/clang/host/linux-x86" />
  <project path="prebuilts/clang/host/linux-x86"                 name="platform/prebuilts/clang/host/linux-x86"                  remote="aosp"            clone-depth="1" />

  <!-- Additional clang -->
  <project path="prebuilts/clang/host/linux-x86/clang-r416183b1" name="BlissRoms_prebuilts_clang_host_linux-x86_clang-r416183b1" remote="BrightTwikling"  revision="universe"          />

  <!-- hardware/qcom*/wlan -->
  <project path="hardware/qcom/wlan"                             name="android_hardware_qcom_wlan"                               remote="LineageOS2"      revision="lineage-22.2"      />
  <project path="hardware/qcom-caf/wlan"                         name="android_hardware_qcom_wlan"                               remote="LineageOS2"      revision="lineage-22.2-caf"  />

  <!-- packages/apps/Matlog -->
  <project path="packages/apps/Matlog"                           name="android_packages_apps_Matlog"                             remote="crdroidandroid2" revision="15.0"              />

</manifest>
```
