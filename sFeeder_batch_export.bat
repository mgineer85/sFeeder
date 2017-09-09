REM @echo off

for /l %%x in (2, 2, 8) do (
	for /l %%y in (8, 4, 16) do (
		echo numberOfFeeders %%x tapeWidth %%y
		openscad -DbankID=-1 -DtapeWidth=%%y -DnumberOfFeeders=%%x -o stl\sFeeder_%%ymm_%%xganged.stl sFeeder.scad
	)
)

openscad -DbankID=1 -DtapeWidth=8 -DnumberOfFeeders=8 -o stl\sFeeder_8mm_8ganged_1bankID.stl sFeeder.scad

pause