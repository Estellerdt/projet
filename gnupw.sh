#!/usr/bin/gnuplot
 
 
		set datafile separator ","
		# Ajouter des titres aux axes et au graphique
		set xlabel 'vitesse en km/h'
		set ylabel 'id station'
		set title 'vitesse du vent moyen\'
		set terminal png
		set output 'vent.png'
		
		plot "data_w.csv" 
		
