#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRESET="Android Debug"
APK_PATH="$PROJECT_ROOT/builds/android/pathbreak-debug.apk"
KNOWN_GODOT="/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64"

find_godot() {
  if [[ -n "${GODOT:-}" && -x "${GODOT}" ]]; then
    printf '%s\n' "$GODOT"
    return
  fi
  if [[ -x "$KNOWN_GODOT" ]]; then
    printf '%s\n' "$KNOWN_GODOT"
    return
  fi
  if command -v godot >/dev/null 2>&1; then
    command -v godot
    return
  fi
  if command -v godot4 >/dev/null 2>&1; then
    command -v godot4
    return
  fi
  return 1
}

find_sdk_root() {
  if [[ -n "${ANDROID_SDK_ROOT:-}" && -d "${ANDROID_SDK_ROOT}" ]]; then
    printf '%s\n' "$ANDROID_SDK_ROOT"
    return
  fi
  if [[ -n "${ANDROID_HOME:-}" && -d "${ANDROID_HOME}" ]]; then
    printf '%s\n' "$ANDROID_HOME"
    return
  fi
  if [[ -d "$HOME/Android/Sdk" ]]; then
    printf '%s\n' "$HOME/Android/Sdk"
    return
  fi
  return 1
}

print_header() {
  printf '\n== %s ==\n' "$1"
}

check_project() {
  print_header "Project"
  [[ -f "$PROJECT_ROOT/project.godot" ]] || {
    echo "ERROR: project.godot not found at $PROJECT_ROOT"
    exit 1
  }
  [[ -f "$PROJECT_ROOT/export_presets.cfg" ]] || {
    echo "ERROR: export_presets.cfg is missing."
    exit 1
  }
  grep -q 'name="Android Debug"' "$PROJECT_ROOT/export_presets.cfg" || {
    echo "ERROR: Android Debug export preset is missing."
    exit 1
  }
  grep -q 'include_filter="\*.json"' "$PROJECT_ROOT/export_presets.cfg" || {
    echo "ERROR: JSON level files are not included by the export preset."
    exit 1
  }
  grep -q '^window/handheld/orientation=1$' "$PROJECT_ROOT/project.godot" || {
    echo "ERROR: Pathbreak mobile orientation is not locked to portrait (SCREEN_PORTRAIT = 1)."
    exit 1
  }
  echo "Project, portrait orientation, and Android Debug preset found."
}

check_godot() {
  print_header "Godot"
  GODOT_BIN="$(find_godot || true)"
  if [[ -z "$GODOT_BIN" ]]; then
    echo "ERROR: Godot executable not found. Set GODOT=/absolute/path/to/Godot."
    exit 1
  fi
  echo "Godot: $GODOT_BIN"
  "$GODOT_BIN" --version
}

find_java() {
  if command -v java >/dev/null 2>&1; then
    command -v java
    return
  fi
  if [[ -x "$HOME/.local/opt/android-studio/jbr/bin/java" ]]; then
    printf '%s\n' "$HOME/.local/opt/android-studio/jbr/bin/java"
    return
  fi
  if [[ -x "$HOME/android-studio/jbr/bin/java" ]]; then
    printf '%s\n' "$HOME/android-studio/jbr/bin/java"
    return
  fi
  return 1
}

check_java() {
  print_header "Java"
  JAVA_BIN="$(find_java || true)"
  if [[ -z "$JAVA_BIN" ]]; then
    echo "ERROR: Java not found. Godot 4.7 recommends OpenJDK 17 for Android export."
    exit 1
  fi
  export PATH="$(dirname "$JAVA_BIN"):$PATH"
  "$JAVA_BIN" -version 2>&1 | head -n 1
}

check_android_sdk() {
  print_header "Android SDK"
  SDK_ROOT="$(find_sdk_root || true)"
  if [[ -z "$SDK_ROOT" ]]; then
    echo "ERROR: Android SDK not found. Set ANDROID_SDK_ROOT or ANDROID_HOME."
    echo "Typical Linux Android Studio path: $HOME/Android/Sdk"
    exit 1
  fi
  export ANDROID_SDK_ROOT="$SDK_ROOT"
  export ANDROID_HOME="$SDK_ROOT"
  echo "Android SDK: $SDK_ROOT"

  ADB="$SDK_ROOT/platform-tools/adb"
  if [[ ! -x "$ADB" ]]; then
    echo "ERROR: $ADB not found. Install Android SDK Platform-Tools."
    exit 1
  fi
  "$ADB" version | head -n 1

  local sdkmanager="$SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"
  if [[ -x "$sdkmanager" ]]; then
    echo "sdkmanager: $sdkmanager"
  else
    echo "WARNING: cmdline-tools/latest/bin/sdkmanager not found."
  fi
}

check_device() {
  print_header "Connected Android devices"
  "$ADB" devices -l
  local count
  count="$("$ADB" devices | awk 'NR>1 && $2=="device" {count++} END {print count+0}')"
  if [[ "$count" -eq 0 ]]; then
    echo "WARNING: no authorized Android device is connected."
    echo "Enable Developer options + USB debugging, connect USB, then accept the RSA prompt."
  else
    echo "$count authorized device(s) detected."
  fi
}

run_regression() {
  print_header "Godot parser and regression suite"
  cd "$PROJECT_ROOT"
  "$GODOT_BIN" --headless --path . --editor --quit
  "$GODOT_BIN" --headless --path . --script tests/test_mobile_project_settings.gd
  "$GODOT_BIN" --headless --path . --script tools/path_level_migration_preview.gd
  "$GODOT_BIN" --headless --path . --script tests/test_path_visual_geometry.gd
  "$GODOT_BIN" --headless --path . --script tests/test_movement_validator.gd
  "$GODOT_BIN" --headless --path . --script tests/test_level_data_validator.gd
  "$GODOT_BIN" --headless --path . --script tests/test_vertical_slice_levels.gd
  "$GODOT_BIN" --headless --path . --script tests/test_satisfaction_feedback.gd
  "$GODOT_BIN" --headless --path . --script tests/test_release_polish.gd
  "$GODOT_BIN" --headless --path . --script tests/test_completion_finish.gd
  "$GODOT_BIN" --headless --path . --script tests/test_level_studio_analysis.gd
}

export_apk() {
  print_header "Android debug export"
  mkdir -p "$(dirname "$APK_PATH")"
  cd "$PROJECT_ROOT"
  "$GODOT_BIN" --headless --path . --export-debug "$PRESET" "$APK_PATH"
  [[ -f "$APK_PATH" ]] || {
    echo "ERROR: Godot returned without creating $APK_PATH"
    exit 1
  }
  ls -lh "$APK_PATH"
  echo "APK created: $APK_PATH"
}

install_apk() {
  print_header "Install APK"
  [[ -f "$APK_PATH" ]] || {
    echo "ERROR: APK not found. Run: bash tools/android_vertical_slice.sh export"
    exit 1
  }
  local count
  count="$("$ADB" devices | awk 'NR>1 && $2=="device" {count++} END {print count+0}')"
  if [[ "$count" -eq 0 ]]; then
    echo "ERROR: no authorized Android device connected."
    exit 1
  fi
  "$ADB" install -r "$APK_PATH"
  echo "Installed $APK_PATH"
}

show_logcat() {
  print_header "Pathbreak logcat"
  echo "Press Ctrl+C to stop."
  "$ADB" logcat | grep --line-buffered -E 'Godot|Pathbreak|godot'
}

usage() {
  cat <<'EOF'
Usage:
  bash tools/android_vertical_slice.sh check
  bash tools/android_vertical_slice.sh test
  bash tools/android_vertical_slice.sh export
  bash tools/android_vertical_slice.sh install
  bash tools/android_vertical_slice.sh all
  bash tools/android_vertical_slice.sh logcat

Commands:
  check    Verify portrait config, Godot, Java, Android SDK, export preset, and connected devices.
  test     Run the Pathbreak parser + automated regression suites.
  export   Run checks and create builds/android/pathbreak-debug.apk.
  install  Install the existing APK to an authorized Android device.
  all      Check, run tests, export, then install.
  logcat   Stream Android logs filtered for Godot/Pathbreak.
EOF
}

command_name="${1:-check}"

check_project
check_godot
check_java
check_android_sdk

case "$command_name" in
  check)
    check_device
    ;;
  test)
    run_regression
    ;;
  export)
    export_apk
    ;;
  install)
    check_device
    install_apk
    ;;
  all)
    check_device
    run_regression
    export_apk
    install_apk
    ;;
  logcat)
    check_device
    show_logcat
    ;;
  *)
    usage
    exit 2
    ;;
esac
