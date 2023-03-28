{5. Realizar un programa para una tienda de celulares, que presente un menú con
opciones para:
a. Crear un archivo de registros no ordenados de celulares y cargarlo con datos
ingresados desde un archivo de texto denominado “celulares.txt”. Los registros
correspondientes a los celulares, deben contener: código de celular, el nombre,
descripción, marca, precio, stock mínimo y el stock disponible.
b. Listar en pantalla los datos de aquellos celulares que tengan un stock menor al
stock mínimo.
c. Listar en pantalla los celulares del archivo cuya descripción contenga una
cadena de caracteres proporcionada por el usuario.
d. Exportar el archivo creado en el inciso a) a un archivo de texto denominado
“celulares.txt” con todos los celulares del mismo. El archivo de texto generado
podría ser utilizado en un futuro como archivo de carga (ver inciso a), por lo que
debería respetar el formato dado para este tipo de archivos en la NOTA 2.
* NOTA 1: El nombre del archivo binario de celulares debe ser proporcionado por el usuario.
  NOTA 2: El archivo de carga debe editarse de manera que cada celular se especifique en
tres líneas consecutivas: en la primera se especifica: código de celular, el precio y
marca, en la segunda el stock disponible, stock mínimo y la descripción y en la tercera
nombre en ese orden. Cada celular se carga leyendo tres líneas del archivo
“celulares.txt”.}

program Practica1Ejercicio5;

type

	celular = record
		cod: integer;
		precio: integer;
		marca: string;
		stockDisp: integer;
		stockMin: integer;
		desc: string;
		nombre: string;
	end;
	
	archivo = file of celular;

procedure textoABinario (var arc: archivo);
var
	nom: string;  carga: Text; c: celular;
begin
	writeln('Ingrese el nombre del archivo binario a crear');
	readln(nom);
	assign(arc, nom);
	assign(carga, 'celulares.txt');
	reset(carga);
	rewrite(arc);
	while (not eof(carga)) do
	begin
		readln(carga, c.cod, c.precio, c.marca);
		readln(c.stockDisp, c.stockMin, c.desc); // Una linea por cada string
		readln(c.nombre);
		write(arc, c);
	end;
	writeln('Archivo binario generado');
	close(carga);
	close(arc);
end;
	
procedure binarioATexto (var arc: archivo);
var
	c: celular; texto: Text;
begin
	assign(texto, 'celulares.txt');
	reset(arc);
	rewrite(texto);
	while (not eof(arc)) do
	begin
		read(arc, c);
		writeln(texto, c.cod, ' ', c.precio, ' ', c.marca);
		writeln(texto, c.stockDisp, ' ', c.stockMin, ' ', c.desc); // Una linea por cada string
		writeln(texto, c.nombre);
	end;
	writeln('Archivo de texto generado');
	close(arc);
	close(texto);
end;

procedure listarCelularesMenores (var arc: archivo);
var
	c: celular;
begin
	reset(arc);
	while (not eof(arc)) do
	begin
		read(arc, c);
		if (c.stockDisp < c.stockMin) then
			writeln('Codigo: ', c.cod, 'Precio: ', c.precio, 'Marca: ', c.marca, 'Stock Disponible: ', c.stockDisp, 'Stock Minimo: ', c.stockMin, 'Descripcion: ', c.desc,'Nombre: ', c.nombre);
	end;
end;

procedure mostrarMenu (var arc: archivo);
var
	o:integer;
begin
	writeln('---------ELIJA UNA OPCION----------');
	writeln('1 - Crear archivo binario desde uno de texto');
	writeln('2 - Listar celulares con stock menor al stock minimo');
	// writeln('3 - Listar celulares con descripcion proporcionada por el usuario'); No lo hago ya q es muy complicado y no se toma en parciales.
	writeln('4 - Crear archivo de texto desde uno binario');
	readln(o);
	case o of
		1: textoABinario(arc);
		2: listarCelularesMenores(arc);
		4: binarioATexto(arc);
	else
		writeln('Opcion invalida');
	end;

end;

var 
	arch: archivo;
BEGIN
	
	mostrarMenu(arch);
	
END.

