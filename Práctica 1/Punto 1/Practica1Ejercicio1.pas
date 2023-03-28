{Realizar un algoritmo que cree un archivo de números enteros no ordenados y permita
incorporar datos al archivo. Los números son ingresados desde teclado. El nombre del
archivo debe ser proporcionado por el usuario desde teclado. La carga finaliza cuando
se ingrese el número 30000, que no debe incorporarse al archivo.}

program Practica1Ejercicio1;

type
  archivo = file of integer;

var
arch_logico: archivo; arch_fisico: string[20]; num: integer;

BEGIN

writeln('Ingrese el nombre del archivo:');
readln(arch_fisico);

assign(arch_logico, arch_fisico); // Conecto nombre logico con nombre fisico
rewrite(arch_logico); // Creo el archivo

writeln('Ingrese un numero');
readln(num);

while (num <> 30000) do
	begin
	write(arch_logico, num);
	writeln('Ingrese un numero');
	readln(num);
	end;

close(arch_logico); // Cierro el archivo

END.

