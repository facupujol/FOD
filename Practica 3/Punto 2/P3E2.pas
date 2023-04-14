{2. Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.}

program P3E2;

const valorAlto = 9999;

type

    asistente = record
        nro: integer;
        apellido: string;
        nombre: string;
        email: string;
        telefono: integer;
        dni: integer;
    end;

    archivo = File of asistente;

procedure leerAsistente (var a: asistente);
begin
    writeln('Ingrese el numero del asistente (-1 para finalizar)');
    readln(a.nro);
    if (a.nro <> -1) then
    begin
        writeln('Ingrese el apellido');
        readln(a.apellido);
        writeln('Ingrese el nombre');
        readln(a.nombre);
        writeln('Ingrese el email');
        readln(a.email);
        writeln('Ingrese el telefono (solo numeros)');
        readln(a.telefono);
        writeln('Ingrese el DNI');
        readln(a.dni);
    end;
end;

procedure leer (var arc: archivo; var a: asistente);
begin
    if (not EOF(arc)) then
        read(arc, a)
    else
        a.nro:= valorAlto;
end;

procedure cargarArchivo (var arc: archivo);
var
    a: asistente;
begin
    writeln('----------- COMIENZA LA CARGA DEL ARCHIVO DE ASISTENTES -----------');
    assign(arc, 'asistentes.dat');
    rewrite(arc);
    leerAsistente(a);
    while (a.nro <> -1) do
    begin
        write(arc, a);
        leerAsistente(a);
    end;
end;

procedure listarArchivo (var arc: archivo);
var
    a: asistente;
begin
    writeln('----------- COMIENZA EL LISTADO DEL ARCHIVO DE ASISTENTES -----------');
    reset(arc);
    leer(arc, a);
    while (a.nro <> valorAlto) do
    begin
        if (a.apellido[1] <> '@') then
            writeln('Nro: ', a.nro, ' Apellido: ', a.apellido, ' Nombre: ', a.nombre);
        leer(arc, a);
    end;
end;

procedure eliminarMenoresAMil (var arc: archivo);
var
    a: asistente;
begin
    reset(arc);
    leer(arc, a);
    while (a.nro <> valorAlto) do
    begin
        if (a.nro < 1000) then
        begin
            Insert('@', a.apellido, 1);
            seek(arc, filePos(arc)-1);
            write(arc, a);
        end;
        leer(arc, a);
    end;
end;

var
    arc: archivo;
BEGIN
    cargarArchivo(arc);
    listarArchivo(arc);
    writeln('---- SE ELIMINARAN LOS ASISTENTES CON NUMERO MENOR A 1000 ----');
    eliminarMenoresAMil(arc);
    listarArchivo(arc);
END.

// Funciona perfectamente