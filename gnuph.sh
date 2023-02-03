#!/usr/local/bin/gnuplot -persist
 
 
		set datafile separator ";"
		# Ajouter des titres aux axes et au graphique
		set xlabel 'ID station'
		set xrange [ 0 : 1000 ]
		set ylabel 'altitude'
		set yrange [ -1000 : 1000 ]
		set title 'altitude des stations n\'
		set terminal png
		set output 'altitude.png'

		
		
		plot "data_h.csv" 
