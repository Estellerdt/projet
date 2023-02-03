#!/usr/bin/gnuplot
 
 
		set datafile separator ","
		# Ajouter des titres aux axes et au graphique
		set xlabel 'Pression'
		set ylabel 'id station'
		set title 'Pression au cours minimales, maximales et moyennes par station\'
		set terminal png
		set output 'pression1.png'
		
		plot "data_p1.csv"
