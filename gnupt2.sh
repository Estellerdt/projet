#!/usr/bin/gnuplot -persist
 
 
		set datafile separator ";"
		# Ajouter des titres aux axes et au graphique
		set xlabel 'Température (°C)'
		set xrange[ -50 : 50 ] noreverse writeback
		set ylabel 'Id station'
		set yrange[ 0 : 1000 ] noreverse writeback
		set title 'Température moyennes par station\'
		set terminal png
		set grid;
		set autoscale fix;
		
		set output 'temperaturet2.png'
		
		plot "data_t2.csv" 

