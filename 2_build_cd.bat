@echo off
:: Parameters are passed via "2a_build_disc_1.bat" or "2b_build_disc_2.bat"
set name=%1
set disc=%2

echo Building disc %disc%
echo ###############
echo:

echo Clearing out the old files and creating a clean workspace...
:: del cd\%name%_working.bin 1>nul
:: del /s /q cd\%name%\* 1>nul
:: xcopy /s cd\%name%_original\* cd\%name% 1>nul
echo:

del /s /q cd\%name%\S00\*
echo Copying over translated scripts...
copy ins\D1_S00\*.DAT cd\%name%\S00\ 1>nul
echo:

echo Copying over font file...
del graphics\DATA0000\BASE.FBS
copy graphics\orig\DATA0000\BASE.FBS graphics\DATA0000\BASE.FBS
tools\timmer insert -i graphics\DATA0000\BASE.FBS -o graphics\DATA0000\BASE.FBS.1.5308.png -p 8 -c 0x5308 -b 4

del /q cd\%name%\DATA0000\BASE.FBS
copy graphics\DATA0000\BASE.FBS cd\%name%\DATA0000\BASE.FBS


pushd code\ancient-roman
pmake -e RELMODE=DEBUG clean
mkdir Debug
mkdir obj
pmake -e RELMODE=DEBUG -e OUTFILE=main -e OPTIMIZE=2
popd

del exe_error.txt
del exe\SLPS_011.08
copy exe\orig\SLPS_011.08 exe\SLPS_011.08
copy /y NUL cd\Ancient-Roman-Disc-1\CODE.DAT >NUL
tools\armips.exe code\ancient-roman-1.asm

del cd\Ancient-Roman-Disc-1\SLPS_011.08
copy exe\SLPS_011.08 cd\Ancient-Roman-Disc-1\SLPS_011.08

echo Building final bin file...
pushd cd
..\tools\psximager\psxbuild.exe "%name%.cat" "%name%_working.bin">> build.log
popd
echo:

echo Build complete!
echo: