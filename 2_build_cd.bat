REM Build disc 1
del /s /q cd\Ancient-Roman-Disc-1\S00\*
echo Copying over translated scripts...
copy ins\D1_S00\*.DAT cd\Ancient-Roman-Disc-1\S00\ 1>nul


echo Copying over font file...
del graphics\DATA0000\BASE.FBS
copy graphics\orig\DATA0000\BASE.FBS graphics\DATA0000\BASE.FBS
tools\timmer insert -i graphics\DATA0000\BASE.FBS -o graphics\DATA0000\BASE.FBS.1.5308.png -p 8 -c 0x5308 -b 4

del /q cd\Ancient-Roman-Disc-1\DATA0000\BASE.FBS
copy graphics\DATA0000\BASE.FBS cd\Ancient-Roman-Disc-1\DATA0000\BASE.FBS

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

echo Building final bin file...
pushd cd
..\tools\psximager\psxbuild.exe  Ancient-Roman-Disc-1.cat Ancient-Roman-Disc-1_working.bin >> build.log
popd
echo:

echo Build complete!

pause