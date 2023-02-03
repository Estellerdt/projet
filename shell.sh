somme() {
    somme_ = $(expr $1 + $2)
}

min() {
    num1=$1
    num2=$2
    if [ $(echo "$num1>$num2" | bc) -eq 1 ]; then
        min_=$num1
    else
        min_=$num2
    fi
}

max() {
    num1=$1
    num2=$2
    if [ $(echo "$num1>$num2" | bc) -eq 1 ]; then
        max_=$num1
    else
        max_=$num2
    fi
}

#verifier si la date existe et est sous le bon format 

correct_date() {
	date= -d
	for arg in $*; do
		if [ $arg = $date ]; then
		 	if [[ $arg =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]] && date -d "$arg" >/dev/null 2>&1; then
        			return 1
			else	
				echo "erreur de date"
        			return 0
    			fi
    		fi
   	done

}


# Associe l'argument lieu à son code postal qui est present dans le fichier csv 

filtre_lieu() {
    param=$1
    code=$2

    if [ -z "$code" ]; then #si la colonne date vide return 0
        return 0
    fi

    if [ $param = '-F' ]; then 
        if [ $code -ge 1000 ] && [ $code -le 75000 ]; then
            return 1
        fi
    fi

    if [ $param = '-G' ]; then
        if [ $code -ge 97300] && [ $code -le 97390 ]; then
            return 1
        fi
    fi

    if [ $param = '-S' ]; then
        if [ $code -eq 97500 ]; then
            return 1
        fi
    fi

    if [ $param = '-A' ]; then
        if [ $code -ge 97100] && [ $code -le 97235 ] || [ $code -eq 97801 ]; then
            return 1
        fi
    fi

    if [ $param = '-O' ]; then
        if [ $code -ge 98411] && [ $code -le 98415 ]; then
            return 1
        fi
    fi

    return 0
}

filtre_date() {
    min=$1
    max=$2

    val=${3:0:10} #extraire la premiere partie de la date

    if [ -z "$val" ]; then
        return 0
    fi

    if [[ ! "$val" < "$min" ]] && [[ ! "$val" > "$max" ]]; then
        return 1
    fi

}

scan_args() {
    # fonction pour lire les arguments et tester s'ils sont correctes
    # elle ramene 1 si c'est bon, 0 sinon

    # definir un dictionnaire pour la lecture des arguments

    # tester les arguments type de donnees:
    arg_type=()
    types=(-t1 -t2 -t3 -p1 -p2 -p3 -w -m -h)
    type_good=0
    for arg in $*; do
        for type in "${types[@]}"; do
            if [ $arg = $type ]; then
                type_good=1
                arg_type+=("$type")
            fi
        done
    done
    if [ $type_good -eq 0 ]; then
        echo 'erreur: parametre type de données abscent'
        return 0
    fi

   #fonction help
   	for arg in $*; do
        	if [[ $arg = "--help" ]]; then 
		echo "Option obligatoire : 
		fichier: 
		-f <nom.CSV> fichier d'entrée (fichier .csv )
		Les options météorologiques : (1 au minimum)
		-w : vent (wind )
		-h : altitude (height).
		-m : humidité (moisture )
		-t<mode> : température : mode 1,2 ou 3
		-p<mode> pression : Mode 1,2 ou 3

		Date:(facultatif)
		-d<min> <max> :dates dans la plage de dates [<min>..<max>]incluse.

		Le format des dates est une chaîne de type YYYY-MM-DD

		Options de limitation géographique (facultatif): -F -G -S - A - O - Q

		Les options de tri : ( facultatif, AVL par défaut, 1 au max)

		--tab --abr --avl "
   
		fi
	done

    # tester les arguments -geographie (optionnel, une au max)
    lieux=(-F -G -S -A -O -Q)
    lieu_good=0
    arg_lieu=""
    for arg in $*; do
        for lieu in "${lieux[@]}"; do
            if [ $arg = $lieu ]; then
                lieu_good=$(expr $lieu_good + 1)
                arg_lieu=$lieu
            fi
        done
    done
    if [ $lieu_good -gt 1 ]; then
        echo 'erreur: plusieurs lieux geographique specifies'
        return 0
    fi

    # tester s'il y a une date que c'est au bon format
    idx=0
    
    for arg in $*; do
        if [ $idx -eq 1 ]; then
            min_date=$arg
            idx=2
        elif [ $idx -eq 2 ]; then
            max_date=$arg
            break
        fi
        if [ $arg = '-d' ]; then
            idx=1
        fi
    done
   
    if [ $idx -gt 0 ]; then
        correct_date $min_date
        if [ $? -eq 0 ]; then
            echo 'erreur: incorrect date minimum'
            return 0
        fi
        correct_date $max_date
        if [ $? -eq 0 ]; then
            echo 'erreur: incorrect date maximum'
            return 0
        fi
    fi

    # tester argument algo de tris
    
    algos=(--tab --abr --avl)
    algo_good=0
    arg_algo='--avl'
    for arg in $*; do
        for algo in "${algos[@]}"; do
            if [ $arg = $algo ]; then
                algo_good=$(expr $algo_good + 1)
                arg_algo=$algo
            fi
        done
    done
    
    #verifier si plusieurs algo ont été choisit 
    
    if [ $algo_good -gt 1 ]; then
        echo 'erreur: plusieurs algorithmes de trie specifies'
        return 0
    fi

#Teste si les arguments sont corrects
##	for arg in $*; do
##if [ "$arg" == "$arg_lieu" ] || [ "$arg" == "$arg_type" ] || [ "$arg" == "$arg_fichier" ]|| [ "$arg" == "--help" ] || [ "$arg" == "arg_algo" ]; then
##    		return 1
##   	else
##    		echo "erreur arguments" 
##    		return 0
##    	fi
##    done

    # tester si l'argument -f <nom fichier> present et correcte
    moins_f=0
    for arg in $*; do
        if [ $moins_f -eq 1 ]; then
            arg_fichier="$arg"
            break
        fi
        if [ $arg = '-f' ]; then
            moins_f=1
        fi
    done
    if [ -z "$arg_fichier" ]; then
        echo "erreur: nom du fichier non specifié"
        return 0
    elif [ ! -f $arg_fichier ]; then
        echo "erreur: impossible d'ouvrir le fichier source de donnees"
        return 0
    fi

    return 1
    
    for arg in $*; do
    	if [ "$arg" == "$arg_lieu" ]; then
    		return 1
    	else
    		echo "erreur arguments" 
    		return 0
    	fi
    done
    
}
	

# le programme principal

# Etape de verifications
scan_args $*
if [ $? -eq 0 ]; then
    exit
fi

# Etape de lecture du fichier source
i=0
lignes=0
now=$(date +"%Y_%m_%d_%I_%M_%p")
#lis les differentes colonnes du fichier csv 
while IFS=';,' read f1 f2 f3 f4 f5 f6 f7 f8 f9 f10 f11 f12 f13 f14 f15 f16; do
    i=$(expr $i + 1)
    if [ $i -gt 1 ]; then

        # appliquer le filtre de lieu si precis
        if [ ! -z "$arg_lieu" ]; then
            filtre_lieu $arg_lieu $f16
            if [ $? -eq 0 ]; then
                continue
            fi
        fi

        # appliquer le filtre de date si precis
        if [ ! -z "$min_date" ]; then
            filtre_date $min_date $max_date $f2
            if [ $? -eq 0 ]; then
                continue
            fi
        fi

        # generer les fichiers de donnees pour chaque type de donnees contenant les colonnes necessaires 

 	    for type in "${arg_type[@]}"; do
 	    
            if [ $type == '-t1' ]; then
                echo "$f11" >> "data_t11.csv" #génére un fichier csv contenant les temperatures (meme principes pour toutes les boucles if qui suivent)
                make re 
               ./exec -f data_t11.csv -o data_t1.csv --tab #lance l algorithme de tri pour le fichier 	
                gnuplot gnupt1.sh #lance genuplot avec les temperatures trié par le langage c 
            fi
            if [ $type == '-t2' ]; then
                echo "$f12" >> "data_t22.csv"
               make re 
               ./exec -f data_t22.csv -o data_t2.csv --tab
                gnuplot gnupt2.sh
            fi
            if [ $type == '-t3' ]; then
                echo "$f11" >> "data_t33.csv"
                make re 
               ./exec -f data_t33.csv -o data_t3.csv --tab
                gnuplot gnupt3.sh
            fi
            if [ $type == '-p1' ]; then
                echo "$f3" >> "data_p11.csv"
                make re 
               ./exec -f data_p11.csv -o data_p1.csv --tab
                gnuplot gnupp1.sh
            fi
            if [ $type == '-p2' ]; then
                echo "$f7" >>"data_p22.csv"
               make re 
               ./exec -f data_p22.csv -o data_p2.csv --tab
                gnuplot gnupp2.sh
            fi
            if [ $type == '-p3' ]; then
                echo "$f7" >>"data_p33.csv"
              make re 
               ./exec -f data_p33.csv -o data_p3.csv --tab
                gnuplot gnupp3.sh
            fi
            if [ $type == '-w' ]; then
                echo "$f5" >>"data_w1.csv"
                 make re 
               ./exec -f data_w1.csv -o data_w1.csv --tab
                gnuplot gnupw2.sh
            fi
            if [ $type == '-m' ]; then
                echo "$f6" >>"data_m1.csv"
                make re 
               ./exec -f data_m1.csv -o data_m.csv --tab
                gnuplot gnupm.sh
            fi
            if [ $type == '-h' ]; then
                echo "$f14" >>"data_h1.csv"
                make re 
               ./exec -f data_h1.csv -o data_h.csv --tab
                gnuplot gnuph.sh
            fi
        done
  lignes=$(expr $lignes + 1)
    fi
done <$arg_fichier



# lancer l'executable C pour chaque fichier de donnees
for type in "${arg_type[@]}"; do
    echo " exec -f data_$now$type.csv -o data_$now$type-o.csv $arg_algo"
done



