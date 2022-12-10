@echo off
:: Parameters are passed via "2a_build_disc_1.bat" or "2b_build_disc_2.bat"
set name=%1
set disc=%2

echo Building disc %disc%
echo ###############
echo:

echo Clearing out the old files and creating a clean workspace...
del cd\%name%_working.bin 1>nul
del /s /q cd\%name%\* 1>nul
xcopy /s cd\%name%_original\* cd\%name% 1>nul
echo:

::del /s /q cd\%name%\S00\*
echo Copying over translated scripts...
copy ins\D1_S00\*.DAT cd\%name%\S00\ 1>nul
echo:

echo Building final bin file...
pushd cd
..\tools\psximager\psxbuild.exe "%name%.cat" "%name%_working.bin">> build.log
popd
echo:

echo Build complete!
echo: