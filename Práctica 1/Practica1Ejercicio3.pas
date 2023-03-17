{3. Realizar un programa que presente un menú con opciones para:
a. Crear un archivo de registros no ordenados de empleados y completarlo con
datos ingresados desde teclado. De cada empleado se registra: número de
empleado, apellido, nombre, edad y DNI. Algunos empleados se ingresan con
DNI 00. La carga finaliza cuando se ingresa el String ‘fin’ como apellido.
b. Abrir el archivo anteriormente generado y
i. Listar en pantalla los datos de empleados que tengan un nombre o apellido
determinado.
ii. Listar en pantalla los empleados de a uno por línea.
iii. Listar en pantalla empleados mayores de 70 años, próximos a jubilarse.
NOTA: El nombre del archivo a crear o utilizar debe ser proporcionado por el usuario.}

program Practica1Ejercicio3;

type
	empleado = record
		num: integer;
		apellido: string[20];
		nombre: string[20];
		edad: integer;
		dni: integer;
		end;
	
	archivo: file of empleado;

procedure cargar (var arc: archivo);
var
	e: empleado;
begin
	writeln('Ingrese el apellido del empleado');
	readln(e.apellido);
	while (e.apellido <> 'fin') do
	begin
		writeln('Ingrese el nombre del empleado');
		readln(e.nombre);
		writeln('Ingrese el numero del empleado');
		readln(e.num);
		writeln('Ingrese el edad del empleado');
		readln(e.edad);
		writeln('Ingrese el DNI del empleado');
		readln(e.dni);
		write(arc, e);
		writeln('Ingrese el apellido del empleado');
		readln(e.apellido);
	end;
	close(arc);
end;

procedure crearArchivo(var arch: archivo);
var
	nom: string;
begin
	writeln('Ingrese el nombre del archivo:');
	readln(nom);
	assign(arch_ej3, nom);
	rewrite(arch_ej3);
	cargar(arch_ej3);
end;

procedure listarNomAp (var arc: archivo);
var
	nom, cadena: string[20];
	e: empleado;
	
begin
	writeln('Ingrese el nombre del archivo a trabajar');
	readln(nom);
	assign(arc, nom);
	rewrite(arc);
	writeln('Ingrese la cadena a buscar');
	readln(cadena);

	while (not eof(arc)) do
	begin
		read(arc, e);
		if ((e.nombre = cadena) or (e.apellido = cadena)) then
			writeln('Nombre: ', e.nombre, ' - Apellido: ', e.apellido, ' - Numero: ', e.num, ' - Edad: ', e.edad, ' - DNI: ', e.dni);
	end;
	
	close(arc);
end;

procedure listarTodos (var arc: archivo);
var
	e: empleado; nom: string[20];
begin
	writeln('Ingrese el nombre del archivo a trabajar');
	readln(nom);
	assign(arc, nom);
	rewrite(arc);
	
	while (not eof(arc)) do
	begin
		read(arc, e);
		writeln('Nombre: ', e.nombre, ' - Apellido: ', e.apellido, ' - Numero: ', e.num, ' - Edad: ', e.edad, ' - DNI: ', e.dni);
	end;
	
	close(arc);
	
end;

procedure listarMayores (var arc: archivo);
var
	e: empleado; nom: string[20];
begin
	writeln('Ingrese el nombre del archivo a trabajar');
	readln(nom);
	assign(arc, nom);
	rewrite(arc);

	while (not eof(arc)) do
	begin
		read(arc, e);
		if (e.edad > 70) then
			writeln('Nombre: ', e.nombre, ' - Apellido: ', e.apellido, ' - Numero: ', e.num, ' - Edad: ', e.edad, ' - DNI: ', e.dni);
	end;
	
	close(arc);
end;

var 

arch_ej3: archivo; o: integer;

BEGIN

	writeln('Elija una opcion 1-4');
	writeln('1- Crear un archivo de registros de empleados');
	writeln('2- Listar los empleados con un nombre o apellido determinados');
	writeln('3- Listar los empleados');
	writeln('4- Listar los empleados mayores a 70 años');
	readln(o);
	case o of
		1: crearArchivo(arch_ej3);
		2: listarNomAp(arch_ej3);
		3: listarTodos(arch_ej3);
		4: listarMayores(arch_ej3);
	else
		writeln('Opcion invalida');
		end;
	
END.

