{4. Dada la siguiente estructura:
type
reg_flor = record
nombre: String[45];
codigo:integer;
tArchFlores = file of reg_flor;
Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.
a. Implemente el siguiente módulo:
Abre el archivo y agrega una flor, recibida como parámetro manteniendo la política descripta anteriormente
procedure agregarFlor (var a: tArchFlores ; nombre: string;
codigo:integer);
b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
5. Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:
Abre el archivo y elimina la flor recibida como parámetro manteniendo la política descripta anteriormente
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);}

program P3E45;

const valorAlto = 9999;

type
    reg_flor = record
        nombre: String[45];
        codigo:integer;
        end;
    
    tArchFlores = file of reg_flor;

procedure leer (var arc: tArchFlores; var f: reg_flor);
begin
    if (not EOF(arc)) then
        read(arc, f)
    else
        f.codigo:= valorAlto;
end;

// Inciso 4A
procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
    f, cabecera, aux: reg_flor; pos: integer;
begin
    f.nombre:= nombre;
    f.codigo:= codigo;
    reset(a);
    read(a, cabecera);
    if (cabecera.codigo <> 0) then
    begin
        pos:= -cabecera.codigo;
        seek(a, pos);
        read(a, aux);
        cabecera.codigo:= aux.codigo;
        seek(a, filePos(a)-1);
        write(a, f);
        reset(a);
        write(a, cabecera);
    end
    else
    begin
        seek(a, fileSize(a));
        write(a, f);
    end;
    close(a);
end;

//  Inciso 4B
procedure listarFlores (var arc: tArchFlores);
var
    f: reg_flor;
begin
    reset(arc);
    seek(arc, 1);
    leer(arc, f);
    while (f.codigo <> valorAlto) do
    begin
        if (f.codigo > 0) then
            writeln('Nombre:', f.nombre, ' Codigo:', f.codigo);
        leer(arc, f);
    end;
    close(arc);
end;

// Para cargar el archivo
procedure leerFlor(var f: reg_flor);
begin
    writeln('Ingrese el codigo de la flor (-1 para finalizar)');
    readln(f.codigo);
    if (f.codigo <> -1) then
    begin
        writeln('Ingrese el nombre de la flor');
        readln(f.nombre);
    end;
end;

procedure cargarArchivo (var arc: tArchFlores);
var
    f: reg_flor;
begin
    assign(arc, 'flores.dat');
    rewrite(arc);
    f.codigo:= 0;
    write(arc, f); // Actua como cabecera
    leerFlor(f);
    while (f.codigo <> -1) do
    begin
        write(arc, f);
        leerFlor(f);
    end;
    close(arc);
end;

procedure eliminarFlor (var a: tArchFlores; flor: reg_flor);
var
    cabecera, f, aux: reg_flor;
begin
    reset(a);
    leer(a, cabecera);
    leer(a, f);
    while ((f.codigo <> flor.codigo)and(f.codigo <> valorAlto)) do
        leer(a, f);
    if (f.codigo = flor.codigo) then    // Si encontre el codigo que buscaba
    begin
        seek(a, filePos(a)-1);  // Me vuelvo a posicionar en el lugar
        aux.codigo:= -filePos(a); // Me guardo la posicion como numero negativo para la lista invertida en aux
        f:= cabecera;
        write(a, f); // Escribo lo que estaba en la cabecera en su lugar
        reset(a);
        write(a, aux);  // Escribo la posicion del nuevo registro eliminado en la cabecera
    end
    else
        writeln('Flor no encontrada');
    close(a);
end;

procedure listarMenu (var arc: tArchFlores);
var
    o, cod: integer; nom: string[20]; f: reg_flor;
begin
    o:= 0;
    while (o <> -1) do
    begin
        writeln('Elija una opcion del 1-4 (-1 para finalizar)');
        writeln('1 - Crear y cargar un archivo de flores nuevo');
        writeln('2 - Agregar una nueva flor');
        writeln('3 - Eliminar una flor');
        writeln('4 - Listar el archivo');
        readln(o);
        case o of
            1: cargarArchivo(arc);
            2: 
            begin
                writeln('Ingrese el codigo de la flor');
                readln(cod);
                if (cod > 0) then
                begin
                    writeln('Ingrese el nombre de la flor');
                    readln(nom);
                    agregarFlor(arc, nom, cod);
                end
                else
                    writeln('Ingrese un codigo valido (mayor a 0)');
            end;
            3: 
            begin
                writeln('Ingrese el codigo de la flor');
                readln(f.codigo);
                if (f.codigo > 0) then
                begin
                    writeln('Ingrese el nombre de la flor');
                    readln(f.nombre);
                    eliminarFlor(arc, f);
                end
                else
                    writeln('Ingrese un codigo valido (mayor a 0)');
            end;
            4: listarFlores(arc);
        end;
    end;
end;

var
    archivo: tArchFlores;
BEGIN
    listarMenu(archivo);
END.

// Funciona perfecto
