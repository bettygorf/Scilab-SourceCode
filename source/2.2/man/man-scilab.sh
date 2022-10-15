#!/bin/sh

for jj in 1 2 3 4 5 6 7 8
do 
	for f in Man-Part1/cat$jj/*
	do
		expand $f > totototo
		mv -f totototo $f
	done 
done

for jj in 1 2 3 4 5
do 
	for f in Man-Part2/cat$jj/*
	do
		expand $f > totototo
		mv -f totototo $f
	done 
done
