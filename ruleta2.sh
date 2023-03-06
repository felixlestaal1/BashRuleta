#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "\n\n${redColour}[!]${endColour}${greenColour}Saliendo...${endColour}\n"
	tput cnorm; exit 1
}
#Ctrl+C
trap ctrl_c INT

function helpPanel(){
  cat ban.txt
  echo -e "\n${yellowColour}[+]${endColour}${turquoiseColour}Uso:$0${endColour}\n"
	echo -e "\t${yellowColour}-m)${endColour}${grayColour}Monto con el que se desea iniciar${endColour}"
	echo -e "\t${yellowColour}-t)${endColour}${grayColour}Técnica que se va a utilizar${endColour}${yellowColour}(${endColour}${redColour}Martingala${endColour}${yellowColour}/${endColour}${redColour}InverseLabrouchere${endColour}${yellowColour})${endColour}\n"
	exit 1
}
function martingala(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour}Dinero actual: $money$ ${endColour}"
	echo -ne "${yellowColour}[+]${endColour}${grayColour}Cuánto dinero tienes pensando apostar?${endColour}${yellowColour} -> ${endColour}" && read initial_bet
	echo -ne "${yellowColour}[+]${endColur}${grayColour}A qué deseas apostar continuamente (par/impar?${endColour}${grayColour} -> ${endColour}" && read par_impar
	echo -e "\n${yellowColour}[+]${endColour}${grayColour}Vamos a jugar con una cantidad inicial de ${endColour}$initial_bet$ ${grayColour}a${endColour} $par_impar"
	#backup bet es para tener una forma de respaldar aquello que manda el usuario para que asi lo podamos usar luego
	backup_bet=$initial_bet
	play_counter=1
	#En este caso es cadena vacia porque se le iran sumando valores xd
	jugadas_malas=""
	tput civis #Ocultar el cursor
	while true;do
		money=$(( $money - $initial_bet))
		#echo -e "\n${yellowColour}[+]${endColour}${grayColour}Acabas de apostar ${endColour}${yellowColour}$initial_bet$ ${endColour}${grayColour} y tienes ${endColour}${yellowColour}$money$ ${endColour}"
		random_number="$(( $RANDOM % 37 ))"
		#echo -e "${yellowColour}[+]${endColour}${grayColour}Ha salido el número${endColour}${grayColour} $random_number ${endColour}"
		
		#-le esto sirve para que diga menor o igual a 0 quiero que pase tal caso
		#-lt esto sirve para que tome el valor de inicio porque si no nos estara sacando a la 1era porque con una jugada del total del dinero nos sacaria de inicio el programa
		if [ ! "$money" -lt 0 ]; then
			if [ "$par_impar" == "par" ]; then
				#Toda esta definicio es para cuando apostemos por numeros pares
				if [ "$(($random_number % 2))" -eq 0 ]; then
					if [ "$random_number" -eq 0 ]; then
						#echo -e "${yellowColour}[+]${endColour}${redColour}Ha salido 0, por lo tanto lo hemos perdido todo como a ella ;-;${endColour}"
						initial_bet=$(($initial_bet*2))	
						jugadas_malas+="$random_number "
						#echo -e "${yellowColour}[+]${endColour}${grayColour}Ahora mismo te quedas en${endColour} ${yellowColour}$money$ ${endColour}"
					else
					#echo -e "${yellowColour}[+]${endColour}${grayColour}El numero que ha salido es par, ganas!${endColour}"
					reward=$(( $initial_bet*2 ))
					#echo -e "${yellowColour}[+]${endColour}${grayColour}Has ganado un total de ${endColour}${yellowColour}$reward$ ${endColour}"
					money=$(($money+$reward))
					#echo -e "${yellowColour}[+]${endColour}${grayColour}Tienes un total de${endColour} ${yellowColour}$money$ ${endColour}"
					initial_bet=$backup_bet
					jugadas_malas=""
					fi
				else
					#echo -e "${yellowColour}[+]${endColour}${redColour}El numero que ha salido es impar, pierdes!${endColour}"
					initial_bet=$(($initial_bet*2))
					jugadas_malas+="$random_number "
					#echo -e "${yellowColour}[+]${endColour}${grayColour}Ahora mismo te quedas en${endColour}${yellowColour} $money$ ${endColour}"
				fi
			else
				#Toda esta definicion es para cuando apostemos a numeros impares 
				if [ "$(($random_number % 2))" -eq 1 ]; then
					#echo -e "${yellowColour}[+]${endColour}${grayColour}El numero que ha salido es impar, ganas!${endColour}"	
				        reward=$(( $initial_bet*2 ))
					#echo -e "${yellowColour}[+]${endColour}${grayColour}Has ganado un total de ${endColour}${yellowColour}$reward$ ${endColour}"
					money=$(($money+$reward))
					#echo -e "${yellowColour}[+]${endColour}${grayColour}Tienes un total de${endColour} ${yellowColour}$money$ ${endColour}"
					initial_bet=$backup_bet
					jugadas_malas=""
				else
					#echo -e "${yellowColour}[+]${endColour}${redColour}El numero que ha salido es par, pierdes!${endColour}"
					initial_bet=$(($initial_bet*2))
					jugadas_malas+="$random_number "
					#echo -e "${yellowColour}[+]${endColour}${grayColour}Ahora mismo te quedas en${endColour}${yellowColour} $money$ ${endColour}"
				fi
			fi
		else
			#Nos quedamos sin dinero
			echo -e "\n${redColour}[!]Nos hemos quedado sin dinero, corre a vender el refri ${endColour}\n"
			echo -e "${yellowColour}[+]${endColour}${grayColour}Han habido un total de${endColour}${yellowColour} $(($play_counter-1)) ${endColour} ${grayColour}jugadas${endColour}"
			echo -e "\n${yellowColour}[+]${endColour}${grayColour}A continuación se van a representar las malas jugadas consecutivas que han salido:${endColour}\n"
			echo -e "${redColour}[ $jugadas_malas ] ${endColour}"
			tput cnorm;exit 0
		
		fi
		let play_counter+=1
		done
	tput cnorm #Recuparemos el cursor
}
function inverseLabrouchere(){
	echo -e "\n${yellowColour}[+]${endColour}${grayColour}Dinero actual: $money$ ${endColour}"
	echo -ne "${yellowColour}[+]${endColur}${grayColour}A qué deseas apostar continuamente (par/impar?${endColour}${grayColour} -> ${endColour}" && read par_impar

	declare -a my_sequence=(1 2 3 4)

	echo -e "\n${yellowColour}[+]${endColour}${grayColour}Comenzamos con la secuncia${endColour}${yellowColour} [${my_sequence[@]}]${endColour}"
	
	bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
	#De esta fora estamos diciendo que estamos restando la cantidad de lo que hemos depositado en este caso el primer y ultimo numero de la secuencia xdddddd
	my_sequence=(${my_sequence[@]})

	jugadas_totales=0

	
	bet_to_renew=$(($money+50)) #Dinero que una vez alcanzado hara que renovemos la secuencia a [1 2 3 4]
	
	echo -e "${yellowColour}[+]${endColour}${grayColour}El tope a renovar la secuencia esta establecido por encima de${endColour}${yellowColour} $bet_to_renew$ ${endColour}"
	
	#Ocultamos el cursor puntero como lo quieras llamar xd
	tput civis

	while true;do
		let jugadas_totales+=1
		random_number=$(($RANDOM % 37))
		money=$(($money - $bet))	
		if [ ! "$money" -lt 0 ]; then	
			echo -e "${yellowColour}[+]${endColour}${grayColour}Invertimos ${endColour} ${yellowColour}$bet ${endColour}"
			echo -e "${yellowColour}[+]${endColour}${grayColour}Tenemos${endColour} ${yellowColour}$money ${endColour}"
			
			echo -e "\n${yellowColour}[+]${endColour}${grayColour}Ha salido el numero $random_number ${endColour}"
			#Para que esta madre diga mientras random number no se igual a 0 el numero es par y ganas xd
			if [ "$par_impar" == "par" ] && [ "$random_number" -ne 0 ] ; then
				if [ "$(($random_number % 2))" -eq 0 ]; then
					echo -e "${yellowColour}[+]${endColour}${grayColour}El numero es par,ganas${endColour}"
					reward=$(($bet*2))
					let money+=$reward
					echo -e "${yellowColour}[+]${endColour}${grayColour}Tienes${endColour} ${yellowColour}$money${endColour}"

				if [ $money -gt $bet_to_renew ]; then
					echo "[+]Se ha superado el tope establecido de $bet_to_renew$ para renovar nuestra secuencia"
					bet_to_renew=$(($bet_to_renew + 50))
					echo -e "${yellowColour}[+]${endColour}${grayColour}El tope se a establecido en${endColour}${yellowColour}$bet_to_renew ${endColour}"
					my_sequence+=(1 2 3 4)
					bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					echo -e "${yellowColour}[+]${endColour}${grayColour}La secuencia ha sido restablecida a ${endColour} ${yellowColour}[${my_sequence[@]}]${endColour}"
				elif [ $money -lt $(($bet_to_renew-100)) ]; then
					#Esta madre es para mantener el rango y ver si bajas del rango reducir el tope previamente establecido
					echo -e "${yellowColour}[+]${endColour}${grayColour}Hemos llegado a un minimo critico,se prodece a reajustar el tope${endColour}"
					bet_to_renew=$(($bet_to_renew - 50))
					echo -e "${grayColour}El tope a sido renovado a${endColour}${yellowColour} $bet_to_renew$ ${endColour}"
					my_sequence+=($bet)
					my_sequence=(${my_sequence[@]})

					echo -e "${yellowColour}[+]${endColour}${grayColour}Nuestra nueva secuencia es${endColour} ${yellowColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${my_sequence[@]}" -eq 1 ]; then
						bet=${my_sequence[0]}
					else
						echo -e "${redColour}[!]Hemos perdido nuestra secuencia${endColour}"
						my_sequence=(1 2 3 4)
						echo -e "${yellowColour}[+]${endColour}${grayColour}Restablecemos la secuencia en [${my_sequence[@]}] ${endColour}"			
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						fi
				else
					my_sequence+=($bet)
					my_sequence=(${my_sequence[@]})

					echo -e "${yellowColour}[+]${endColour}${grayColour}Nuestra nueva secuencia es${endColour} ${yellowColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${my_sequence[@]}" -eq 1 ]; then
						bet=${my_sequence[0]}
					else
						echo -e "${redColour}[!]Hemos perdido nuestra secuencia${endColour}"
						my_sequence=(1 2 3 4)
						echo -e "${yellowColour}[+]${endColour}${grayColour}Restablecemos la secuencia en [${my_sequence[@]}] ${endColour}"			
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						fi
				fi

				elif [ "$((random_number % 2))" -eq 1 ] || [ "$random_number" -eq 0 ]; then
					if [ "$((random_number % 2))" -eq 1 ]; then
					echo -e "${redColour}[+]El numero es impar, pierdes${endColour}"
				else
					echo -e "${redColour}[!]Ha salido el numero 0,pierdes${endColour}"
					bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					fi

			
				if [ $money -lt $(($bet_to_renew-100)) ]; then
					#Esta madre es para mantener el rango y ver si bajas del rango reducir el tope previamente establecido
					echo -e "${yellowColour}[+]${endColour}${grayColour}Hemos llegado a un minimo critico,se prodece a reajustar el tope${endColour}"
					bet_to_renew=$(($bet_to_renew - 50))
					echo -e "${grayColour}El tope a sido renovado a${endColour}${yellowColour} $bet_to_renew$ ${endColour}"	
					unset my_sequence[0]
					unset my_sequence[1] 2>/dev/null
					my_sequence=(${my_sequence[@]})

					echo -e "${yellowColour}[+]${endColour}${grayColour}Nuestra nueva secuencia es${endColour} ${yellowColour}[${my_sequence[@]}]${endColour}"
						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${my_sequence[@]}" -eq 1 ]; then
						bet=${my_sequence[0]}
					else
						echo -e "${redColour}[!]Hemos perdido nuestra secuencia${endColour}"
						my_sequence=(1 2 3 4)
						echo -e "${yellowColour}[+]${endColour}${grayColour}Restablecemos la secuencia en [${my_sequence[@]}] ${endColour}"			
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
						fi
					
					else				
						unset my_sequence[0]
						unset my_sequence[1] 2>/dev/null
						
						my_sequence=(${my_sequence[@]})
						echo -e "\n${yellowColour}[+]${endColour}${grayColour}La secuencia queda de la siguiente manera${endColour} ${yellowColour}[${my_sequence[@]}]${endColour}\n"	

						if [ "${#my_sequence[@]}" -ne 1 ] && [ "${#my_sequence[@]}" -ne 0 ]; then
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
					elif [ "${#my_sequence[@]}" -eq 1 ]; then
						bet=${my_sequence[0]}
					else
						echo -e "${redColour}[!]Hemos perdido nuestra secuencia${endColour}"
						my_sequence=(1 2 3 4)
						echo -e "${yellowColour}[+]${endColour}${grayColour}Restablecemos la secuencia en [${my_sequence[@]}] ${endColour}"
						bet=$((${my_sequence[0]} + ${my_sequence[-1]}))

						fi
				fi
				fi
			fi
		else
			echo -e "\n${redColour}[!]Nos hemos quedado sin dinero, corre a vender el refri ${endColour}\n"
			echo -e "\n${yellowColour}[+]${endColour}${grayColour}En total han habido${endColour}${yellowColour} $jugadas_totales ${endColour}${grayColour}jugadas totales${endColour}\n"
			tput cnorm; exit 1
		fi
		#sleep 1
	done
	#Recuperamos el puntero

	tput cnorm
}

while getopts "m:t:h" arg; do
	case $arg in
		m) money=$OPTARG;;
		t) technique=$OPTARG;;
		h) helpPanel;;
	esac
done

if [ $money ] && [ "$technique" ]; then
	echo "Voy a jugar con $money dinero y con la tecnica $technique"
	if [ "$technique" == "martingala" ]; then
		martingala
	elif [ "$technique" == "inverseLabrouchere" ]; then
		inverseLabrouchere
	else
		echo -e "\n${redColour}[!]La técnica introducida no existe\n${endColour}"
		helpPanel
	fi
else
	helpPanel
fi
