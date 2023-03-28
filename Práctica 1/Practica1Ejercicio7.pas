{7. Realizar un programa que permita:
a. Crear un archivo binario a partir de la información almacenada en un archivo de texto.
El nombre del archivo de texto es: “novelas.txt”
b. Abrir el archivo binario y permitir la actualización del mismo. Se debe poder agregar
una novela y modificar una existente. Las búsquedas se realizan por código de novela.
NOTA: La información en el archivo de texto consiste en: código de novela, nombre,
género y precio de diferentes novelas argentinas. De cada novela se almacena la
información en dos líneas en el archivo de texto. La primera línea contendrá la siguiente
información: código novela, precio, y género, y la segunda línea almacenará el nombre
de la novela.}

program Practica1Ejercicio7;

type

    novela = record
        cod: integer;
        precio: integer;
        genero: string;
        nombre: string;
    end;

    archivo = File of novela;

procedure textoABinario (var arc: archivo);
var
    carga: Text; n: novela; nom: string;
begin
    assign(carga, 'novelas.txt');    // Cargo el archivo novelas.txt a la variable carga
    writeln('Ingrese el nombre del archivo binario a crear'); readln(nom);
    assign(arc, nom);         // Le pongo nombre al archivo binario
    reset(carga);             // Abro el archivo de texto
    rewrite(arc);             // Creo y abro el archivo binario
    while (not eof(carga)) do
    begin
        readln(carga, n.cod, n.precio, n.genero); // Leo en 2 lineas el contenido del archivo de texto ya que tiene 2 strings.
        readln(carga, n.nombre);
        write(arc, n); // Lo escribo en el archivo binario
    end;
    writeln('Archivo binario creado');
    close(arc);
    close(carga);
end;

procedure leerNovela(var n: novela);
begin
    writeln('Ingrese el codigo'); readln(n.cod);
    writeln('Ingrese el precio'); readln(n.precio);
    writeln('Ingrese el genero'); readln(n.genero);
    writeln('Ingrese el nombre'); readln(n.nombre);
end;

procedure agregarNovela (var arc: archivo);
var
    n: novela;
begin
    leerNovela(n); // Leo la novela a agregar
    reset(arc);    // Abro el archivo
    seek(arc, filesize(arc)); // Me posiciono al final
    write(arc, n); // Agrego la novela
end;

procedure modificarNovela(var arc: archivo);
var
    num: integer; encontre: boolean; n: novela;
begin
    encontre:= false;
    writeln('Ingrese el codigo de la novela que desea modificar'); readln(num);
    reset(arc); // Abro el archivo
    while ((not eof(arc)) and (encontre=false)) do
    begin
        read(arc, n);
        if (n.cod = num) then  // Cuando se encuentre la novela buscada entra al if
        begin
            encontre:= true; // Encontre la novela en true para finalizar el loop cuando finalice esta iteracion
            writeln('Se encontro la novela buscada. Ingrese los nuevos datos para actualizar el archivo');
            leerNovela(n); // Leo los nuevos datos
            seek(arc, filepos(arc)-1); // Me posiciono en la novela objetivo
            write(arc, n); // Sobreescribo la informacion
        end;
    end;
    close(arc) // Cierro el archivo
end;

procedure mostrarMenu (var arc: archivo);
var
    o: integer;
begin
    writeln('---------ELIJA UNA OPCION----------') ;
    writeln('1 - Crear un archivo binario a partir del archivo "novelas.txt"');
    writeln('2 - Agregar una novela al archivo binario.');
    writeln('3 - Modificar una novela ya existente en el archivo binario');
    readln(o);
    case o of
        1: textoABinario(arc);
        2: agregarNovela(arc);
        3: modificarNovela(arc);
    else
        writeln('Opcion invalida');
    end;
end;

var
    archive: archivo;
BEGIN

    mostrarMenu(archive);

END.