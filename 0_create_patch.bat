del release\patch_data\patch-d1.xdelta
del release\patch_data\patch-d2.xdelta
del release\patch_data\patch-d1-other.xdelta
del release\patch_data\patch-d2-other.xdelta
tools\xdelta3-3.0.11-x86_64.exe -9 -S none -B 1812725760 -e -vfs cd\Ancient-Roman-Disc-1_original.bin cd\Ancient-Roman-Disc-1_working.bin release\patch_data\patch-d1.xdelta
tools\xdelta3-3.0.11-x86_64.exe -9 -S none -B 1812725760 -e -vfs cd\Ancient-Roman-Disc-1_original-other.bin cd\Ancient-Roman-Disc-1_working.bin release\patch_data\patch-d1-other.xdelta

tools\xdelta3-3.0.11-x86_64.exe -9 -S none -B 1812725760 -e -vfs cd\Ancient-Roman-Disc-2_original.bin cd\Ancient-Roman-Disc-2_working.bin release\patch_data\patch-d2.xdelta
tools\xdelta3-3.0.11-x86_64.exe -9 -S none -B 1812725760 -e -vfs cd\Ancient-Roman-Disc-2_original-other.bin cd\Ancient-Roman-Disc-2_working.bin release\patch_data\patch-d2-other.xdelta