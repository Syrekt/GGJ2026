@echo off
setlocal

:: ==== CONFIG ====
set GODOT_EXE=C:\Programs\Godot\Godot_v4.6-stable_win64.exe
set EXPORT_PRESET=Windows
set PROJECT_DIR=C:\Users\Administrator\Documents\ggj-2026
set BUILD_DIR=C:\Users\Administrator\Desktop\GGJ2026
set BUILD_EXE=ggj2026.exe
:: =================

:: Get version
set /p VERSION=Enter version number: 

if "%VERSION%"=="" (
	echo Version cannot be empty!
	exit /b 1
)

set ZIP_FILE=C:\Users\Administrator\Desktop\GGJ2026v%VERSION%.zip

:: Clean build directory
if exist "%BUILD_DIR%" (
	echo Removing old build...
	rmdir /s /q "%BUILD_DIR%"
)

mkdir "%BUILD_DIR%"

:: Export
echo Exporting Godot project...

"%GODOT_EXE%" --headless --path "%PROJECT_DIR%" --export-release "%EXPORT_PRESET%" "%BUILD_DIR%\%BUILD_EXE%"

if errorlevel 1 (
	echo Export failed!
	exit /b 1
)

echo Export completed successfully!

:: Delete old zip if exists
if exist "%ZIP_FILE%" (
	echo Deleting old zip...
	del /f /q "%ZIP_FILE%"
)

:: Zip build
echo Zipping build...
powershell -Command "Compress-Archive -Path '%BUILD_DIR%\*' -DestinationPath '%ZIP_FILE%' -Force"

if errorlevel 1 (
	echo Zipping failed!
	exit /b 1
)

echo Build %VERSION% is done as %BUILD_DIR% -- %ZIP_FILE%!
pause
