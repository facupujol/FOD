{1. Modificar el ejercicio 4 de la práctica 1 (programa de gestión de empleados),
agregándole una opción para realizar bajas copiando el último registro del archivo en
la posición del registro a borrar y luego truncando el archivo en la posición del último
registro de forma tal de evitar duplicados}

program Practica1Ejercicio4;

type
	empleado = record
		num: integer;
		edad: integer;
		dni: integer;
		apellido: string[20];
		nombre: string[20];
		end;
	
	archivo = file of empleado;

procedure leerEmpleado (var e: empleado);
begin
	writeln('Ingrese el apellido del empleado');
	readln(e.apellido);
	writeln('Ingrese el nombre del empleado');
	readln(e.nombre);
	writeln('Ingrese el numero del empleado');
	readln(e.num);
	writeln('Ingrese el edad del empleado');
	readln(e.edad);
	writeln('Ingrese el DNI del empleado');
	readln(e.dni);

end;

procedure cargar (var arc: archivo);
var
	e: empleado;
begin
	reset(arc);
	leerEmpleado(e);
	while (e.apellido <> 'fin') do
	begin
		write(arc, e);
		leerEmpleado(e);
	end;
	close(arc);
end;

procedure crearArchivo(var arch: archivo);
var
	nom: string;
begin
	writeln('Ingrese el nombre del archivo:');
	readln(nom);
	assign(arch, nom);
	rewrite(arch);
	cargar(arch);
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

function existeEmpleado (var arc: archivo; e: empleado): boolean;
var
  ok: boolean; emp: empleado;
begin
	ok:= false;
	reset(arc);
	while (not eof(arc)) and (ok = false) do
	begin
		read(arc, emp);
		if (e.num = emp.num) then
			ok:= true;
	end;
	close(arc);
    existeEmpleado:= ok;
end;


procedure agregarEmpleado(var arc: archivo); // Inciso 4A
var
	e: empleado;
begin
	leerEmpleado(e);
	while (e.nombre <> 'fin') do
	begin
		if (not existeEmpleado(arc,e)) then
		begin
			reset(arc);
			seek(arc, filePos(arc));
			write(arc,e);
		end;
		leerEmpleado(e);
	end;
end;

procedure exportarArhivo (var arc: archivo);
var
	carga: Text; e: empleado;
begin
	reset(arc);
	assign(carga, 'todos_empleados.txt');
	rewrite(carga);
	while (not eof(arc)) do
	begin
		read(arc, e);
		writeln(carga, e.num, ' ', e.edad, ' ', e.dni, ' ', e.apellido);
		writeln(e.nombre);
	end;
	close(arc);
	close(carga);
end;

procedure exportarEmpleadosSinDNI(var arc: archivo);
var
	carga: Text; e: empleado;
begin
	reset(arc);
	assign(carga, 'faltaDNIEmpleado.txt');
	rewrite(carga);
	while (not eof(arc)) do
	begin
		read(arc, e);
		if (e.DNI = 00) then
		begin
			writeln(carga, e.num, ' ', e.edad, ' ', e.dni, ' ', e.apellido);
			writeln(e.nombre);
		end;
	end;
	close(arc);
	close(carga);
end;

procedure modificarEdad(var arc: archivo);
var
	edad, num: integer; e: empleado;
begin
	writeln('Ingrese el numero de empleado');
	readln(num);
	while (num <> 0) do
	begin
		writeln('Ingrese la nueva edad');
		readln(edad);
		reset(arc);
		while (not eof(arc)) do
		begin
			read(arc, e);
			if (e.num = num) then
			begin
				seek(arc, FilePos(arc)-1);
				e.edad:= edad;
				write(arc, e);
			end;
		end;
		writeln('Ingrese el numero de empleado (ingrese 0 para finalizar)');
		readln(edad);
	end;
	close(arc);
end;
			
// -------------- INCISO PARA EJERCICIO 1 DE PRACTICA 3 --------------

procedure eliminarEmpleado(var arc: archivo);
var
    aux, e: empleado; num, pos: integer;
begin
    writeln('Ingrese el codigo del empleado a eliminar');
    readln(num);
    reset(arc);
	seek(arc, fileSize(arc));	// Busco el ultimo registro
	read(arc, aux);		// Lo guardo en la variable aux
	seek(arc, 0);	// Vuelvo al principio
	read(arc, e);	// Empiezo a buscar al empleado
	while (e.num <> num) do	// Mientras no lo encuentro loopeo, leyendo empleados
		read(arc, e);
	seek(arc, filePos(arc)-1);	// Me posiciono en la posicion del registro a borrar
	write(arc, aux); // Sobreescribo el registro
	seek(arc, fileSize(arc)-1); // Me posiciono en la anteultima posicion, asi queda afuera el registro que acabo de utilizar
	truncate(arc); // Trunco dejando afuera el registro utilizado para la sobreescripcion 
end;

var 

arch_ej3: archivo; o: integer;

BEGIN

	writeln('Elija una opcion 1-9');
	writeln('1- Crear un archivo de registros de empleados');
	writeln('2- Listar los empleados con un nombre o apellido determinados');
	writeln('3- Listar los empleados');
	writeln('4- Listar los empleados mayores a 70 años');
	writeln('5- Anadir empleados');
	writeln('6- Cambiar la edad de uno o mas empleados');
	writeln('7- Exportar todos los empleados sin DNI a archivo de texto');
	writeln('8- Exportar todos los empleados a archivo de texto');
    writeln('9- Eliminar un empleado del archivo');
	readln(o);
	case o of
		1: crearArchivo(arch_ej3);
		2: listarNomAp(arch_ej3);
		3: listarTodos(arch_ej3);
		4: listarMayores(arch_ej3);
		5: agregarEmpleado(arch_ej3);
		6: modificarEdad(arch_ej3);
		7: exportarArhivo(arch_ej3);
		8: exportarEmpleadosSinDNI(arch_ej3);
        9: eliminarEmpleado(arch_ej3);
	else
		writeln('Opcion invalida');
		end;

END.

// Corre pero no funciona
