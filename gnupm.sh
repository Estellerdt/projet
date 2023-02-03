#!/usr/bin/gnuplot
 
 
		set datafile separator ","
		# Ajouter des titres aux axes et au graphique
		set xlabel 'Heure'
		set ylabel 'Température (°C)'
		set title 'Pression au cours minimales, maximales et moyennes par station\'
		set terminal png
		set output 'pression.png'
		
		plot "data_m.csv"
