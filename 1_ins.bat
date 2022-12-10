@echo off
echo Formatting disc 1 scripts...
tools\ancient_roman_script_insert.exe orig\D1_S00 ins\D1_S00 sjis.tbl

echo Formatting disc 2 scripts...
tools\ancient_roman_script_insert.exe orig\D2_S00 ins\D2_S00 sjis.tbl
tools\ancient_roman_dat_insert.exe ins
echo: