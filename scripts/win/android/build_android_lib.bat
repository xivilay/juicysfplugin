@echo off

SET BUILD_PATH=%~dp0\..\..\..\build\
SET VS_TOOLS_PATH=%ProgramFiles(x86)%\Microsoft Visual Studio\2019\BuildTools\Common7\Tools
SET NDK_PATH=%LocalAppData%\Android\Sdk\ndk\21.4.7075529
SET TOOLCHAIN_PATH=%NDK_PATH%\build\cmake\android.toolchain.cmake
SET ANDROID_API_VERSION=24
SET ANDROID_ABI=arm64-v8a

cd /d "%VS_TOOLS_PATH%\..\.." & "%VS_TOOLS_PATH%\vsdevcmd.bat" & cd %BUILD_PATH% & ^
cmake .. ^
    -G=Ninja ^
    -DCMAKE_SYSTEM_NAME=Android ^
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ^
    -DCMAKE_SYSTEM_VERSION=%ANDROID_API_VERSION% ^
    -DANDROID_ABI=%ANDROID_ABI% ^
    -DCMAKE_ANDROID_ARCH_ABI=%ANDROID_ABI% ^
    -DANDROID_NDK=%NDK_PATH% ^
    -DCMAKE_ANDROID_NDK=%NDK_PATH% ^
    -DCMAKE_TOOLCHAIN_FILE=%TOOLCHAIN_PATH% ^
    -DANDROID_PLATFORM=android-%ANDROID_API_VERSION% ^
    -DANDROID_STL=c++_shared ^
    -DANDROID_ARM_MODE=arm ^
    -DANDROID_ARM_NEON=TRUE ^
    -DCMAKE_CXX_FLAGS_RELEASE=-O3 ^
    -DCMAKE_C_FLAGS_RELEASE=-O3 ^
    -DJUCE_BUILD_CONFIGURATION=RELEASE ^
    & ^
cmake --build . --config Release