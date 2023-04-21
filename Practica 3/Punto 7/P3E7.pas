{7. Se cuenta con un archivo que almacena información sobre especies de aves en
vía de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las especies a
eliminar. Deberá realizar todas las declaraciones necesarias, implementar todos los
procedimientos que requiera y una alternativa para borrar los registros. Para ello deberá
implementar dos procedimientos, uno que marque los registros a borrar y posteriormente
otro procedimiento que compacte el archivo, quitando los registros marcados. Para
quitar los registros se deberá copiar el último registro del archivo en la posición del registro
a borrar y luego eliminar del archivo el último registro de forma tal de evitar registros
duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000}

program P3E7;

const valorAlto = 9999;

type
    ave = record
        cod: integer;
        nombre: string[20];
        familia: string[20];
        desc: string[20];
        zona: string[20];
    end;

    archivo = File of ave;

procedure leerAve (var a: ave);
begin
    writeln('Ingrese el codigo del ave (-1 para finalizar)');
    readln(a.cod);
    if (a.cod <> -1) then
    begin
        writeln('Ingrese el nombre del ave');
        readln(a.nombre);
        writeln('Ingrese la familia del ave');
        readln(a.familia);
    end;
end;

procedure leer (var arc: archivo; var a: ave);
begin
    if (not EOF(arc)) then
        read(arc, a)
    else
        a.cod:= valorAlto;
end;

procedure cargarArchivo (var arc: archivo);
var
    a: ave;
begin
    assign(arc, 'aves.dat');
    rewrite(arc);
    leerAve(a);
    while (a.cod <> -1) do
    begin
        write(arc, a);
        leerAve(a);
    end;
    close(arc);
end;

procedure listarArchivo (var arc: archivo);
var
    a: ave;
begin
    reset(arc);
    leer(arc, a);
    while (a.cod <> valorAlto) do
    begin
        if (a.cod > 0) then
            writeln('Codigo:', a.cod, ' Nombre:', a.nombre, ' Familia:', a.familia);
        leer(arc, a);
    end;
    close(arc);
end;

procedure eliminarAves (var arc: archivo);
var
    a: ave; cod: integer;
begin
    reset(arc);
    writeln('Ingrese el codigo a ingresar (-1 para finalizar)'); // Pido el codigo del ave a eliminar
    readln(cod);
    while (cod <> -1) do // Mientras no sea 50000 elimino registros
    begin
        leer(arc, a);   // Comienzo a buscar en el archivo el ave pedida
        while ((a.cod <> cod)and(a.cod <> valorAlto)) do    // Mientras no encontre y el archivo no termine, busco
            leer(arc, a);
        if (a.cod = cod) then // Si lo encontre
        begin
            a.cod:= -a.cod; // Pongo en negativo el codigo
            seek(arc, filePos(arc)-1);  // Me posiciono y escribo
            write(arc, a);  
            seek(arc, 0); // Vuelvo al inicio del archivo para la proxima iteracion
        end
        else    // Si no encontre el registro que estaba buscando
            writeln('No se encontro el codigo');
        writeln('Ingrese el codigo a ingresar (-1 para finalizar)'); // Pido el siguiente codigo
        readln(cod);
    end;
    close(arc);
end;

procedure compactarArchivo (var arc: archivo);
var
    a, ultimo: ave; cant, posUltimo: integer; hayEspacio: boolean;
begin
    hayEspacio:= true;  // Hay espacio para hacer el reacomodamiento comienza en true
    cant:= 1;   // Cantidad de archivos reacomodados
    posUltimo:= 0;    // Posicion del ultimo archivo reacomodado, comienza en 0 para empezar desde 0
    reset(arc);
    while (hayEspacio = true) do    // Mientras haya espacio
    begin
        seek(arc, fileSize(arc) - cant);    // Voy a la ultima posicion - la cantidad de archivos ya reacomodados
        leer(arc, ultimo);  // Lo leo y guardo en una variable ultimo
        seek(arc, posUltimo);   //  Me posiciono en la posicion de el ultimo archivo reacomodado
        leer(arc, a);
        while ((a.cod > 0)and(a.cod <> valorAlto)) do   // Mientras no encuentre un archivo logicamente borrado y no llegue al final, busco
            leer(arc, a);
        if (a.cod < 0) then // Si encontre lugar
        begin
            posUltimo:= filePos(arc);   // Me guardo la posicion para la proxima iteracion arrancar a buscar desde aca
            seek(arc, filePos(arc)-1);  // Me posiciono y sobreescribo
            write(arc, ultimo);
        end
        else    // Si no encontre lugar (a.cod = valorAlto)
            hayEspacio:= false; // Ya no hay espacio
    end;
    seek(arc, fileSize(arc) - (cant+1)); // Me posiciono en el final - la cantidad de archivos borrados + 1 (asi tambien agarro al ultimo de los que ya movi)
    Truncate(arc);  // Trunco el archivo
    close(arc);
end;

var
    arc: archivo;
BEGIN
    writeln('----------- COMIENZA LA CARGA DEL ARCHIVO -----------');
    cargarArchivo(arc);
    writeln('----------- LISTADO -----------');
    listarArchivo(arc);
    writeln('----------- COMIENZA ELIMINACION -----------');
    eliminarAves(arc);
    writeln('----------- LISTADO -----------');
    listarArchivo(arc);
    writeln('----------- COMIENZA COMPACTACION -----------');
    compactarArchivo(arc);
    writeln('----------- LISTADO COMPACTADO -----------');
    listarArchivo(arc);
END.

// Funciona perfecto