@echo off
set BUILD_DIR="../../build"

rmdir %BUILD_DIR% /s/q
mkdir %BUILD_DIR%
cd /d %BUILD_DIR%

cmake -A Win32 ../ && cmake --build . --config Release