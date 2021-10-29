@echo off

set OUT_DIR="%~dp0/../../dist"
set BUILD_DIR="%~dp0/../../build"
set FLUIDSYNTH_DIR="%BUILD_DIR%/fluidsynth/src"
set PLUGIN_DIR="%BUILD_DIR%/juicysfplugin_artefacts"

rmdir %OUT_DIR% /s/q
mkdir %OUT_DIR%

cd /d %BUILD_DIR%

for /R "%PLUGIN_DIR%" %%f in (*.exe) do copy "%%f" %OUT_DIR%
for /R "%PLUGIN_DIR%" %%f in (*.vst3) do copy "%%f" %OUT_DIR%
for /R "%PLUGIN_DIR%" %%f in (*.dll) do copy "%%f" %OUT_DIR%
for /R "%FLUIDSYNTH_DIR%" %%f in (*.dll) do copy "%%f" %OUT_DIR%
