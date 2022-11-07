#!/usr/bin/env bash

DEVICE_IMAGE="system-images;android-31;google_apis;x86_64"

echo "y" | "$ANDROID_HOME"/cmdline-tools/latest/bin/sdkmanager --install $DEVICE_IMAGE
echo "no" | "$ANDROID_HOME"/cmdline-tools/latest/bin/avdmanager -v create avd -n android_emulator -k $DEVICE_IMAGE -f
"$ANDROID_HOME"/emulator/emulator -list-avds

echo -e "\nStarting emulator and waiting for boot to complete..."
nohup "$ANDROID_HOME"/emulator/emulator -avd android_emulator -no-boot-anim -qemu -m 2048 > /dev/null 2>&1 &
$ANDROID_HOME/platform-tools/adb wait-for-device shell 'while [[ -z $(getprop sys.boot_completed | tr -d '\r') ]]; do sleep 1; done; input keyevent 82'

echo "Emulator has finished booting!"
$ANDROID_HOME/platform-tools/adb devices

# To kill the emulator run: adb -s emulator-5554 emu kill
