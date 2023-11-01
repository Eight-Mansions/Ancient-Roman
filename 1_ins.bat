@echo off

echo Formatting disc 1 scripts...
tools\ancient_roman_script_insert.exe orig\D1_S00 ins\D1_S00 sjis.tbl

tools\ancient_roman_dat_insert.exe ins

pushd code\ancient-roman
pmake -e RELMODE=DEBUG clean
mkdir Debug
mkdir obj
pmake -e RELMODE=DEBUG -e OUTFILE=main -e OPTIMIZE=2
popd

del exe_error.txt
del exe\SLPS_011.08
copy exe\orig\SLPS_011.08 exe\SLPS_011.08
tools\armips.exe code\ancient-roman-1.asm

echo: