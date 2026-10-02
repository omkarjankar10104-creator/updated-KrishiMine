@echo off
REM ===========================================================
REM  KrishiMind - start everything with one command
REM
REM  Type this in the terminal:      .\run.bat
REM
REM  It does the four things that kept going wrong by hand:
REM    1. kills any leftover emulator holding the device lock
REM    2. deletes the stale .lock files that leftover leaves behind
REM    3. starts the emulator WITH working DNS, so the app has internet
REM    4. waits for Android to boot, then runs the app
REM ===========================================================
setlocal
set "SDK=%LOCALAPPDATA%\Android\Sdk"
set "AVD=Pixel_7"

echo.
echo  [1/4] Closing any leftover emulator...
taskkill /F /IM qemu-system-x86_64.exe  >nul 2>&1
taskkill /F /IM emulator.exe            >nul 2>&1
taskkill /F /IM crashpad_handler.exe    >nul 2>&1

echo  [2/4] Clearing lock files...
for /d %%L in ("%USERPROFILE%\.android\avd\%AVD%.avd\*.lock") do rmdir /s /q "%%L" >nul 2>&1
del /q "%USERPROFILE%\.android\avd\%AVD%.avd\*.lock" >nul 2>&1

echo  [3/4] Starting the emulator (with internet)...
start "KrishiMind emulator" "%SDK%\emulator\emulator.exe" -avd %AVD% -dns-server 8.8.8.8,8.8.4.4

echo        Waiting for the phone to appear...
"%SDK%\platform-tools\adb.exe" wait-for-device
echo        Waiting for Android to finish booting (about 30 seconds)...
timeout /t 30 /nobreak >nul

echo  [4/4] Running KrishiMind...
echo.
flutter run -d emulator-5554

endlocal
