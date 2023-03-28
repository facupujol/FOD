{6. Agregar al menú del programa del ejercicio 5, opciones para:
a. Añadir uno o más celulares al final del archivo con sus datos ingresados por
teclado.
b. Modificar el stock de un celular dado.
c. Exportar el contenido del archivo binario a un archivo de texto denominado:
”SinStock.txt”, con aquellos celulares que tengan stock 0.
NOTA: Las búsquedas deben realizarse por nombre de celular.}

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
		writeln(texto, c.nom);
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
			writeln('Codigo: ', c.cod, 'Precio: ', c.precio, 'Marca: ', c.marca, 'Stock Disponible: ', c.stockDisp, 'Stock Minimo: ', c.stockMin, 'Descripcion: ', c.desc,'Nombre: ', c.nom);
	end;
end;

procedure agregarCelulares (var arc: archivo); // Inciso 6A
var
    c: celular:
begin
    reset(arc);
    writeln('Ingrese el nombre del celular ("fin" para finalizar)'); readln(c.nom);
    while ( c.nom <> 'fin') do
    begin
        writeln('Ingrese el codigo del celular'); readln(c.cod);
        writeln('Ingrese el precio del celular'); readln(c.precio);
        writeln('Ingrese la marca del celular'); readln(c.marca);
        writeln('Ingrese el stock disponible del celular'); readln(c.stockDisp);
        writeln('Ingrese el stock minimo del celular'); readln(c.stockMin);
        writeln('Ingrese la descripcion del celular'); readln(c.descripcion);
        seek(arc, filesize(arc));  // Me posiciono al final del archivo para agregar al final el nuevo celular
        write(arc, c);
        writeln('Ingrese el nombre del celular ("fin" para finalizar)'); readln(c.nom);
    end;

end;

procedure modificarStock (var arc: archivo); // Inciso 6B
var
    num: integer; nom: string; c: celular; encontre: boolean;
begin
    encontre: false;  // Declaro esta variable para que, una vez encontrado el celular, no siga recorriendo el archivo en vano.
    writeln('Ingrese el nombre del celular del cual desea modificar el stock.');
    readln(nom);
    reset(arc);
    while ((not eof(arc)) and (encontre = false)) do
    begin
        read(arc, c);
        if (c.nom = nom) then
        begin
            encontre:= true;
            writeln('Ingrese el nombre del nuevo stock disponible'); readln(c.stockDisp);
            writeln('Ingrese el nombre del nuevo stock minimo'); readln(c.stockMin); // Leo el nuevo stock y lo guardo en un registro de celular.
            seek(arc, filePos(arc)-1); // Me vuelvo a posicionar en el celular que quiero modificar.
            write(arc, c); // Sobreescribo el registro de celular que quiero cambiar con el actualizado.
        end;
    end;
    close(arc);

end;

procedure exportarSinStock (var arc: archivo);
begin
    assign(texto, 'SinStock.txt');
	reset(arc);
	rewrite(texto);
	while (not eof(arc)) do
	begin
		read(arc, c);
        if (c.stockDisp = 0) then
        begin
		    writeln(texto, c.cod, ' ', c.precio, ' ', c.marca);
		    writeln(texto, c.stockDisp, ' ', c.stockMin, ' ', c.desc); // Una linea por cada string
		    writeln(texto, c.nom);
        end;
	end;
	writeln('Archivo de texto generado');
	close(arc);
	close(texto);

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
    writeln('5 - Agregar celulares al archivo');
    writeln('6 - Modificar el stock de un celular');
    writeln('7 - Exportar celulares sin stock a un archivo de texto');
	case o of
		1: textoABinario(arc);
		2: listarCelularesMenores(arc);
		4: binarioATexto(arc);
		5: agregarCelulares(arc);
		6: modificarStock(arc);
		7: exportarSinStock(arc);
	else
		writeln('Opcion invalida');
	end;

end;

var 
	arch: archivo;
BEGIN
	
	mostrarMenu(arch);
	
END.