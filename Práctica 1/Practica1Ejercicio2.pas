{2. Realizar un algoritmo, que utilizando el archivo de números enteros no ordenados
creados en el ejercicio 1, informe por pantalla cantidad de números menores a 1500 y el
promedio de los números ingresados. El nombre del archivo a procesar debe ser
proporcionado por el usuario una única vez. Además, el algoritmo deberá listar el
contenido del archivo en pantalla.}

program Practica1Ejercicio2;

type

	archivo: file of integer;
	
procedure carga (var arc: archivo);
var
	n_fisico: string[20]; num: integer;
begin
	writeln('Ingrese el nombre del archivo:');
	readln(n_fisico);

	assign(arc, n_fisico); // Conecto nombre logico con nombre fisico
	rewrite(arc); // Creo el archivo

	writeln('Ingrese un numero');
	readln(num);

	while (num <> 30000) do
		begin
		write(arc, num);
		writeln('Ingrese un numero');
		readln(num);
		end;

	close(arch_logico); // Cierro el archivo

end;

procedure recorrerArchivo (var arc: archivo);

var
	num, menores, total: integer; promedio: real;
	
begin

	total:= 0;	menores:= 0;
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

	carga(arc);
	recorrerArchivo(arc);
	
END.

