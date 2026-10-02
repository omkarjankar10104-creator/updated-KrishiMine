# How to run KrishiMind

## Every session, in this order

**1. Start the emulator.**
In VS Code press `Ctrl + Shift + P`, type `Flutter: Select Device`, choose **Pixel 7**.
Wait until the phone's home screen is showing.

**2. Run the app.**
Press **F5**. That uses the saved configuration in `.vscode/launch.json`, so it never
asks which device to use.

Or from a terminal:

```powershell
flutter run -d emulator-5554
```

**3. After editing code**
| You changed | Press |
|---|---|
| Dart code only | `r` — hot reload |
| A new file, an image, or anything read at startup | `R` — hot restart |
| `pubspec.yaml` | `q`, then `flutter pub get`, then run again |

Press these in the terminal running `flutter run` — **not** the one running the emulator.

---

## Things that are NOT errors

**"Connected devices: Windows / Chrome / Edge ... Please choose one"**
Flutter is asking which device to use, because the emulator is not running. Start the
emulator first. Running the four `flutter config --no-enable-*` commands below removes
the desktop and web options permanently:

```powershell
flutter config --no-enable-web
flutter config --no-enable-windows-desktop
flutter config --no-enable-linux-desktop
flutter config --no-enable-macos-desktop
```

**A long silence after `flutter run`**
Gradle is compiling. After adding a package this takes 10–15 minutes and prints
nothing. Do not press Ctrl+C and do not close VS Code — that starts it over.

**`Ignore IPv6 address: ...` repeated many times**
Normal emulator noise.

---

## Real problems, and their fixes

**The app never appears, or Flutter says the device is gone**

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" devices
```

* `offline` → `adb reconnect offline`, then check again
* not listed → the emulator is not running, start it
* still stuck → Android Studio > Device Manager > the arrow beside Pixel 7 > **Cold Boot Now**

**"The Android emulator exited with code 1 during startup"**
A previous emulator process is still holding the device. Kill it and clear the locks:

```powershell
Get-Process qemu-system-x86_64, emulator, crashpad_handler -ErrorAction SilentlyContinue | Stop-Process -Force
Remove-Item "$env:USERPROFILE\.android\avd\Pixel_7.avd\*.lock" -Recurse -Force -ErrorAction SilentlyContinue
```

**Reading a long emulator log**
Search for `FATAL` first, then `ERROR`. Everything marked `DEBUG` or `INFO` is noise.

---

## Before showing anyone the app

Do this fifteen minutes before, not while they are watching:

1. Start the emulator and let it finish booting
2. Press F5 and wait for the app to open
3. Open the voice screen and the chat screen once each, so both are warm
4. Then **hide VS Code** and show only the phone

Nobody needs to see the terminal. If someone asks to see the code, open the files —
not the build output.
