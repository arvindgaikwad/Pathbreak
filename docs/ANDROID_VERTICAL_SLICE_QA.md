# Pathbreak — Android Vertical-Slice Export and QA

**Status:** Active verification guide  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## Goal

Validate the approved five-level Pathbreak vertical slice on real Android hardware before building the production level pipeline or final launch UI.

The current Android preset is intentionally a **debug/testing preset**, not the final Google Play release configuration.

## Current project configuration

`project.godot` already targets:

- 720×1280 design viewport;
- portrait handheld orientation;
- `canvas_items` stretch mode;
- mobile renderer;
- touch emulation from mouse for desktop development.

`export_presets.cfg` now adds:

- preset name: `Android Debug`;
- APK output: `builds/android/pathbreak-debug.apk`;
- ARMv7 + ARM64 builds;
- vibration permission for Pathbreak haptics;
- no Internet permission for the current offline vertical slice;
- explicit `*.json` export inclusion so canonical level files ship inside the APK.

### Temporary package identifier

The testing preset uses:

```text
com.pathbreak.verticalslice
```

This is deliberately temporary. Do not publish it to Google Play. The final application identifier must be chosen after final naming/trademark and publisher-domain decisions because Android treats a changed package identifier as a different application.

## Godot 4.7 Android requirements

For desktop Linux export, Godot 4.7 documentation recommends:

- OpenJDK 17;
- Android SDK Platform-Tools 35.0.0 or later;
- Android SDK Build-Tools 35.0.1;
- Android SDK Platform 35;
- Android SDK Command-line Tools latest;
- CMake 3.10.2.4988404;
- NDK r28b / 28.1.13356709;
- Godot export templates matching the installed editor version.

Configure **Editor Settings → Export → Android** with:

- Java SDK Path;
- Android SDK Path.

These settings are machine-local and are intentionally not committed to the project repository.

## Fast path

After pulling the branch:

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git switch codex/vertical-slice-level-review
git pull origin codex/vertical-slice-level-review
```

Run preflight:

```bash
bash tools/android_vertical_slice.sh check
```

Run parser and regression tests:

```bash
bash tools/android_vertical_slice.sh test
```

Export the APK:

```bash
bash tools/android_vertical_slice.sh export
```

Connect one authorized Android device and install:

```bash
bash tools/android_vertical_slice.sh install
```

Or perform the whole verified path in one command:

```bash
bash tools/android_vertical_slice.sh all
```

The helper uses the known local Godot path when present and also accepts:

```bash
GODOT="/absolute/path/to/Godot" bash tools/android_vertical_slice.sh all
```

## Device preparation

On the Android device:

1. Enable Developer options.
2. Enable USB debugging.
3. Connect by USB.
4. Accept the RSA authorization prompt.
5. Confirm the device appears under:

```bash
adb devices -l
```

If an older Pathbreak test APK with the same package ID was signed using a different debug key, uninstall that old build before installing again.

## Phone QA

Run the complete experience rather than testing only one board.

### Menu and layout

- [ ] App launches directly to Main Menu.
- [ ] Portrait orientation remains locked/appropriate.
- [ ] No camera cutout or system bar obscures important controls.
- [ ] Main Menu board is fully tappable.
- [ ] Start/Continue opens the same recommended level.
- [ ] Rapid taps do not double-navigate.
- [ ] 360×800-class display remains readable.

### Touch

- [ ] Straight path taps select the intended path.
- [ ] Bent path taps select the intended path.
- [ ] Close neighboring paths use nearest-path selection correctly.
- [ ] Multi-touch does not remove/count one path twice.
- [ ] Restart button is reliable.
- [ ] Hint/refill buttons are reliable.

### Snake escape

- [ ] L-shaped path head leads.
- [ ] Tail feeds through the corner.
- [ ] Corner travels through the body.
- [ ] No diagonal shortcut appears.
- [ ] Straightened body exits smoothly.
- [ ] Repeated animations do not stutter noticeably.
- [ ] Automatic final clear still waits for the intended animation flow.

### Lifecycle and persistence

- [ ] Complete a level, return to menu, reopen gameplay: progress persists.
- [ ] Consume a normal hint: count persists.
- [ ] Background the app and resume: current UI remains valid.
- [ ] Force-close and reopen: save is intact.
- [ ] Sound toggle persists after restart.
- [ ] Haptics toggle persists after restart.
- [ ] Reduce Motion persists after restart.
- [ ] High Contrast persists after restart.

### Android Back

- [ ] Back closes hint-refill popup before leaving gameplay.
- [ ] Back closes pause/settings overlay correctly.
- [ ] Back does not accidentally trigger duplicate navigation.

### Feedback

- [ ] Success haptic feels light/appropriate.
- [ ] Blocked-path haptic feels distinct.
- [ ] Celebration haptic is not excessive.
- [ ] Sound effects are audible at normal media volume.

## Tablet QA

Target Samsung Galaxy Tab S6 Lite or another Android tablet.

- [ ] 800×1280-class portrait layout remains centered.
- [ ] Board does not become excessively large or too small.
- [ ] HUD remains reachable and visually balanced.
- [ ] Popup size is appropriate.
- [ ] Finger selection remains accurate.
- [ ] Stylus tapping selects the intended path.
- [ ] Snake animations remain smooth.
- [ ] Main Menu and Level Select do not leave problematic dead space.
- [ ] Pause/refill/result flows remain readable.
- [ ] Suspend/resume works.

## Accessibility regression

### Reduce Motion

- [ ] Direction remains understandable without travelling animation.
- [ ] Successful escape uses the simpler short translation/fade.
- [ ] Automatic final clear remains understandable.

### High Contrast

- [ ] Shaft remains distinct from board dots.
- [ ] Triangle head remains obvious.
- [ ] Tail remains visually secondary.
- [ ] Hint marker remains identifiable.

## Debugging a device-only problem

Use:

```bash
bash tools/android_vertical_slice.sh logcat
```

For an unfiltered Android log:

```bash
adb logcat
```

When reporting a device-only defect, record:

- device model;
- Android version;
- screen resolution/orientation;
- exact level/screen;
- reproduction steps;
- whether Reduce Motion / High Contrast were enabled;
- relevant logcat lines.

## Google Play is a later gate

The debug preset deliberately uses the prebuilt APK path because this phase is real-device QA.

Before Google Play release we still need:

- final globally unique package identifier;
- final app name clearance;
- release keystore stored securely outside Git;
- Gradle build template;
- AAB export;
- version-code policy;
- final launcher/adaptive/themed icons;
- Play target/API review;
- privacy/Data Safety configuration;
- closed testing track.

Do not commit release-keystore files or passwords.
