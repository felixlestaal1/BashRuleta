#!/bin/bash
#Esta madre es para declarar un array iuuuuuuuuuuuuuu
#declare -a 

#Aqui estamos declarando una variable de tipo entereo especificamente
declare -i v1=8

#Aui va a marcar un error el cual por la configuracion anterior
v1 = "ocho"

#Aqui lo imprimimos xdn't
echo $v1

#Aqui declaramos un valor llamado numero que sea solo posible leerlo
declare -r number="Prueba"

#Aqui dara error porque debe de ser solo lectura esta madre no modificacion
number="prueba"


#Esta madre es para declarar los arrays es como de las mejores formas a mi parreder
declare -a myArray=(1 2 3 4)

#EN este caso va a mostrar solo el primer valor pero
echo $myArray

#Si queremos mostrar todos los valores almacenados en nuestra variable bastaria con un
echo ${myArray[@]}

for element in ${myArray[@]}; do 
	echo "[+]Elemento $element"
done

posicion=0
for element in ${myArray[@]}; do
	echo "[+]Elemento en la posicion [$posicion]: $element"
	#Para ir incrementando el valor de posicion
	let posicion+=1
done

#Esta madre sirve para saber el total de elementos de un array
echo ${#myArray[@]}

#Aqui seria para imprimir el primero y ultimo elemento de nuestro array
echo "${myArray[0]} ${myArray[-1]}"

#Para aregar algo a nuestro array seria
declare -a myArray=(1 2 3 4)

myArray+=(5)
echo ${myArray[@]}

#Para quitar elementos es con 
unset myArray[0]
unset myArray[-1]
echo ${myArray[0]}

#Para que no se tenga conflicto de que llegue a tener memoria la computadora en los arrays cuando llegas a quitar algo entonces lo que se tiene que realizar es un
#Asi es igualarlo a si mismo para que tipo se resetee y no entre en conflicto
myArray=(${myArray[@]})





