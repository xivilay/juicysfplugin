@echo off
SET ANDROID_PATH=%cd%\..\..\..\android
SET vsTools=C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\Common7\Tools
C:\Windows\system32\cmd.exe  /k " cd /d "%vsTools%\..\.." & "%vsTools%\vsdevcmd.bat" & cd %ANDROID_PATH% & gradlew build" 