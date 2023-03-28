{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program Practica1Ejercicio2;

type

	archivo = file of integer;
	


procedure recorrerArchivo (var arc: archivo);

var
	num, menores, total: integer; promedio: real; nom: string;
	
begin

	total:= 0;	menores:= 0;
	writeln('Ingrese el nombre del archivo a recorrer');
	readln(nom);
	assign(arc, nom);
	reset(arc);
	while (not eof(arc)) do
	begin
		read(arc, num);
		writeln(num); // Muestro el contenido del archivo en pantalla
		if (num < 1500) then
			menores:= menores + 1; // Cuento numeros menores a 1500
		total:= total + num; // Calculo la suma total de los numeros del archivo para luego sacar el promedio
	end;
	
	promedio:= total/FileSize(arc);
	close(arc);
	
	writeln('Cantidad de numeros menores a 1500: ', menores);
	writeln('Promedio de los numeros ingresados: ', promedio);
	
end;

var
	arc: archivo;

BEGIN

	recorrerArchivo(arc);
	
END.

