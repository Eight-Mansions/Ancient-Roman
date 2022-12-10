del cd\Ancient-Roman-Disc-1_working.bin
del /s /q cd\Ancient-Roman-Disc-1\*
xcopy /s cd\Ancient-Roman-Disc-1_original\* cd\Ancient-Roman-Disc-1

del /s /q cd\Ancient-Roman-Disc-1\S00\*
copy ins\D1_S00\*.DAT cd\Ancient-Roman-Disc-1\S00\

::Build files
echo Building final bin file...
pushd cd
..\tools\psximager\psxbuild.exe "Ancient-Roman-Disc-1.cat" "Ancient-Roman-Disc-1_working.bin">> build.log
popd
echo:

echo Build complete!
echo: