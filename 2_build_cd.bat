REM Build disc 1
del /s /q cd\Ancient-Roman-Disc-1\S00\*
copy ins\D1_S00\*.DAT cd\Ancient-Roman-Disc-1\S00\ 1>nul


echo Copying over font file...
del graphics\DATA0000\BASE.FBS
copy graphics\orig\DATA0000\BASE.FBS graphics\DATA0000\BASE.FBS
tools\timmer insert -i graphics\DATA0000\BASE.FBS -o graphics\DATA0000\BASE.FBS.1.5308.png -p 8 -c 0x5308 -b 4 -m 14
tools\timmer insert -i graphics\DATA0000\BASE.FBS -o graphics\DATA0000\BASE.FBS.2.6F08.png -p 8 -c 0x6F08 -b 4 -m 13

del /q cd\Ancient-Roman-Disc-1\DATA0000\BASE.FBS
copy graphics\DATA0000\BASE.FBS cd\Ancient-Roman-Disc-1\DATA0000\BASE.FBS

tools\ancient_roman_generate_movie_subtitles.exe videos tools\movie_mapping.txt

pushd code\ancient-roman
pmake -e RELMODE=DEBUG clean
mkdir Debug
mkdir obj
pmake -e RELMODE=DEBUG -e OUTFILE=main -e OPTIMIZE=2
popd

del exe\SLPS_011.08
copy exe\orig\SLPS_011.08 exe\SLPS_011.08
copy /y NUL cd\Ancient-Roman-Disc-1\CODE.DAT >NUL
tools\armips.exe code\ancient-roman-1.asm

tools\ancient_roman_exe_text_merge.exe trans\en\SLPS_011.08.po trans\orig\SLPS_011.08.txt trans\SLPS_011.08.txt
tools\ancient_roman_exe_text_merge.exe trans\en\SLPS_011.08_000818A4.po trans\orig\SLPS_011.08_000818A4.txt trans\SLPS_011.08_000818A4.txt
tools\ancient_roman_exe_text_merge.exe trans\en\SLPS_011.08.po trans\orig\SLPS_011.09.txt trans\SLPS_011.09.txt

del exe_error.txt
echo trans\SLPS_011.08.txt.txt >> exe_error.txt
tools\atlas exe\SLPS_011.08 trans\SLPS_011.08.txt >> exe_error.txt
tools\atlas exe\SLPS_011.08 trans\SLPS_011.08_000818A4.txt >> exe_error.txt

del cd\Ancient-Roman-Disc-1\SLPS_011.08
copy exe\SLPS_011.08 cd\Ancient-Roman-Disc-1\SLPS_011.08

echo Building final bin file...
pushd cd
..\tools\psximager\psxbuild.exe  Ancient-Roman-Disc-1.cat Ancient-Roman-Disc-1_working.bin >> build.log
popd
echo:


REM Build disc 2
del /s /q cd\Ancient-Roman-Disc-2\S00\*
copy ins\D1_S00\*.DAT cd\Ancient-Roman-Disc-2\S00\ 1>nul

del exe\SLPS_011.09
copy exe\orig\SLPS_011.09 exe\SLPS_011.09
copy /y NUL cd\Ancient-Roman-Disc-2\CODE.DAT >NUL
REM tools\armips.exe code\ancient-roman-1.asm

del cd\Ancient-Roman-Disc-2\SLPS_011.09
copy exe\SLPS_011.09 cd\Ancient-Roman-Disc-2\SLPS_011.09

echo Building final bin file...
pushd cd
..\tools\psximager\psxbuild.exe  Ancient-Roman-Disc-2.cat Ancient-Roman-Disc-2_working.bin >> build.log
popd
echo:


echo Build complete!