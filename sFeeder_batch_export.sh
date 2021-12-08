#!/bin/bash

for fdrs in 2 4 6 8
do
	for tpw in 8 12 16
	do
		echo "Number of feeders:  $fdrs, Tape Width: $tpw [mm]"
		openscad -DbankID=-1 -DtapeWidth=$tpw -DnumberOfFeeders=$fdrs -o stl/sFeeder_${tpw}mm_${fdrs}ganged.stl sFeeder.scad
		echo -e "\n"
	done
done

openscad -DbankID=1 -DtapeWidth=8 -DnumberOfFeeders=8 -o New_stl/sFeeder_8mm_8ganged_1bankID.stl sFeeder.scad

