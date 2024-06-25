@echo off
set filename_1=Ancient-Roman-Disc-1-English
set filename_2=Ancient-Roman-Disc-2-English
set file_type=BIN
set patch_file_1=patch-d1.xdelta
set patch_file_2=patch-d2.xdelta

set found_disc=

pushd %~dp0
if "%~1"=="" goto :NOISO

:: Iterate over all files that get dragged onto here
for %%A in (%*) do (
    echo Patching %%A...
    echo:

    patch_data\xdelta.exe -d -f -s %%A patch_data\%patch_file_1% "%filename_1%.bin" 2>nul
    if not errorlevel 1 (
        set found_disc=true

        echo Disc 1 found!

        echo FILE "%filename_1%.bin" BINARY>%filename_1%.cue
        echo   TRACK 01 MODE2/2352>>%filename_1%.cue
        echo     INDEX 01 00:00:00>>%filename_1%.cue
        echo.
    )

    patch_data\xdelta.exe -d -f -s %%A patch_data\%patch_file_2% "%filename_2%.bin" 2>nul
    if not errorlevel 1 (
        set found_disc=true
        
        echo Disc 2 found!

        echo FILE "%filename_2%.bin" BINARY>%filename_2%.cue
        echo   TRACK 01 MODE2/2352>>%filename_2%.cue
        echo     INDEX 01 00:00:00>>%filename_2%.cue
        echo.
    )
)

if not defined found_disc goto :NOPATCHFOUND

echo Success!
echo:
echo ---
echo One or more of the following %file_type% files should have been created next to the bat file:
echo * %filename_1%(.bin/.cue)
echo * %filename_2%(.bin/.cue)
echo ---
echo:
echo Load up the .cue file for the disc you wish to play and enjoy!
echo If a disc image is missing, please verify you used the 1st BIN track of the original CD.
echo:
goto :EXIT

:NOISO
echo To patch %file_type% don't run this bat file.
echo Simply drag and drop %file_type% on it and the patch process will start.
goto :EXIT

:NOPATCHFOUND
echo No patch found suitable for those files.
echo Please make sure to drag in clean BIN files of either disc 1 or 2.
echo:
echo If the problem persists, go throw a sad puppy at SnowyAria ; _;

:EXIT
popd
echo:
echo Press any key to close this window
pause >nul
exit
