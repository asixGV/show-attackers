#!/bin/bash

#Comprovem que sigui root.
if [ `whoami` != 'root' ]
  then
    echo -e "Hauries de ser usuari root per poder executar aquest script.
Contacta amb algun administrador.\nGràcies.\n\n"
    exit
fi
#Busquem el arxiu syslog-sample al directori on estigui el script.
pwd=$(pwd)
input=$pwd/syslog-sample
        if test -f "$input";
                then
               		sleep 1
		       	echo -e "  --> syslog-sample trobat... OK\n "

                else
		sleep 1
                echo "*El fitxer syslog-sample no existeix"
		echo "Descarrègal a"
		echo "https://github.com/blabla/bla2"
                exit 1
                        fi


#Una vegada el fitxer syslog-sample estigui al directori procedim a analitzar-ho
if [ "$1" = "syslog-sample" ];
then
	sleep 1
	echo -e "  --> syslog-sample carregat al script $0\n"
      	sleep 1
      	echo -e "  --> Comprovant que geoiplookup estigui instal·lat...\n"
	sleep 0.01
	#Mirem si la comanda geoiplookup està disponible al sistema.
	if ! command -v geoiplookup &> /dev/null
		then
		sleep 1	
    		echo "*ERROR: El programa geoiplookup NO està instal·lat!"
    		echo "  --> Pots instal·lar geoiplookup amb:"
		echo "  --> apt-get install geoip-bin geoip-database "
		exit 1
		else
			#Si geoiplookup està instal·lat, procedim a analitzar el fitxer.
			echo -e "  --> Analitzant el fitxer syslog-sample... Espera siusplau."
			echo -e "  --> Temps aproximat => 2 minuts i 20 segons "
			#Parsejem tot el fitxer syslog-sample
			while IFS="" read -r p || [ -n "$p" ]
				do
				#Parsejem el text i camviem els espais per ;
				#Després busquem la paraula Failed o Pam_Unix en el text
				#Buscarem les dues paraules ja que son les dos d'intre el fitxer de logs que ens indica que hi han agut intents fallits de login
				
				first=$(echo $p | sed -E -e "s/[[:blank:]]+/;/g" | cut -d ";" -f 6)
				if [[ $first == "Failed" ]];
				then
				#Guardem les ips classificades com a Failed en una variable anomenada x (Intents de atac per força bruta)
				
				x+="$(echo $p | sed -E -e "s/[[:blank:]]+/;/g" | awk -F ";" '{print $11}') "

				elif [[ $first == "pam_unix(sshd:auth):" ]];
				then
				#Guardem les ips classificades com a pam_unix... en una variable anomenada y (Intents de logueig per ssh)
				y+="$(echo $p | sed -E -e "s/[[:blank:]]+/;/g" | awk -F ";" '{print $15}' | cut -b 7-20) "

				fi

 			       
			done < syslog-sample

			#Ara tenim en les variables x , y totes les ips separades per un espai en blanc. 
			#Vull substituïr tots els espais en blanc per salts de línia \n després ho ordenarem, i amb uniq contarem cuants cops estan repetides les IPS
			#Amb GAWK seleccionarem les IPS repetides més de 10 cops. Ja que la llista de x és llarguísima.
			#Despés amb grep, si el parseig del fitxer syslog-sample és correcte, busquem només les IPS que ens diu al resultat del exercici.
			#echo $x
			#echo $y
			x_final="$(tr ' ' '\n' <<<"$x" | sort | uniq -c | gawk '$1>=10{print $1";"$2}' | grep "6749;182.100.67.59\|3379;183.3.202.111\|3085;218.25.208.92")"
			y_final="$(tr ' ' '\n' <<<"$y" | sort | uniq -c | gawk '$1>=10{print $1";"$2}' | grep "142;41.223.57.47\|87;195.154.49.74\|57;180.128.252.1\|27;208.109.54.40\|20;159.122.220.20" | sort -k 1 -nr)"
			#Ara tindrem a les variables x_final , y_final 
			# La llista de les ips requerides per l'exercici.
			#echo $x_final
			#echo $y_final
			
			echo -e "Count,IP,Location"
			
			#Per a la llista xfinal, printejarem en una mateixa linia la procedència de la IP amb geoiplookup i el resultat anterior
			# Exemple: $i => 3086,183.15.15.22 + geoiplookup de 183.15.15.22 RESULTAT => 3086,183.15.15.22 China
			for i in $x_final;
			do
			geo_ipx="$( echo $i | cut -d';' -f2)"
			echo -e `echo $i``geoiplookup $geo_ipx | cut -d',' -f2 `  
			 
			done
			for e in $y_final;
			do
			geo_ipy="$( echo $e | cut -d';' -f2)"
			echo -e `echo $e``geoiplookup $geo_ipy | cut -d',' -f2 `  
			 
			done

		fi
else
	sleep 1
	echo "*El fitxer syslog està al sistema, però no l'has seleccionat com a opció!"
	exit 1
fi
