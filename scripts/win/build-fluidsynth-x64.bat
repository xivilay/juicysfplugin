@echo off

set BUILD_DIR="../../build"
set FLUIDSYNTH_BUILD_DIR=%BUILD_DIR%\fluidsynth
set FLUIDSYNTH_DIR=..\..\external\fluidsynth

mkdir %BUILD_DIR%
rmdir %FLUIDSYNTH_BUILD_DIR% /s/q
mkdir %FLUIDSYNTH_BUILD_DIR%
cd /d %FLUIDSYNTH_BUILD_DIR%

cmake  -A x64 ^
    %FLUIDSYNTH_DIR% ^
    -Denable-floats=1 ^
    -Denable-libsndfile=1 ^
    -Denable-threads=1 ^
    -Denable-pkgconfig=1 ^
    -Denable-aufile=0 ^
    -Denable-dbus=0 ^
    -Denable-dsound=0 ^
    -Denable-ipv6=0 ^
    -Denable-jack=0 ^
    -Denable-ladspa=0 ^
    -Denable-libinstpatch=0 ^
    -Denable-midishare=0 ^
    -Denable-network=0 ^
    -Denable-openmp=0 ^
    -Denable-oss=0 ^
    -Denable-pulseaudio=0 ^
    -Denable-readline=0 ^
    -Denable-sdl2=0 ^
    -Denable-wasapi=0 ^
    -Denable-waveout=0 ^
    -Denable-winmidi=0 ^
    -DPKG_CONFIG_EXECUTABLE=%PKG_CONFIG_EXECUTABLE% ^
    -DCMAKE_TOOLCHAIN_FILE=%CMAKE_TOOLCHAIN_FILE% ^
    && ^
cmake --build . --config Release