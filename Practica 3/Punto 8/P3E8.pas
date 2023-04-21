{8. Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse.
Este archivo debe ser mantenido realizando bajas lógicas y utilizando la técnica de
reutilización de espacio libre llamada lista invertida.
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve verdadero si
la distribución existe en el archivo o falso en caso contrario.
AltaDistribución: módulo que lee por teclado los datos de una nueva distribución y la
agrega al archivo reutilizando espacio disponible en caso de que exista. (El control de
unicidad lo debe realizar utilizando el módulo anterior). En caso de que la distribución que
se quiere agregar ya exista se debe informar “ya existe la distribución”.
BajaDistribución: módulo que da de baja lógicamente una distribución cuyo nombre se
lee por teclado. Para marcar una distribución como borrada se debe utilizar el campo
cantidad de desarrolladores para mantener actualizada la lista invertida. Para verificar
que la distribución a borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no
existir se debe informar “Distribución no existente”.}

program P3E8;

const   valorAlto = 'ZZZZ';

type
    distribucion = record
        nombre: string[20];
        anio: integer;
        kernel: string[20];
        devs: integer;
        desc: string[20];
    end;
    
    archivo = File of distribucion;

procedure leer (var arc: archivo; var d: distribucion);
begin
    if (not EOF(arc)) then
        read(arc, d)
    else
        d.nombre:= valorAlto;
end;

procedure leerDistribucion (var d: distribucion);
begin
    writeln('Ingrese el nombre de la distribucion (ZZZ para finalizar)');
    readln(d.nombre);
    if (d.nombre <> 'ZZZ') then
    begin
        writeln('Ingrese el anio de la distribucion');
        readln(d.anio);
        {writeln('Ingrese el kernel de la distribucion');
        readln(d.kernel);
        writeln('Ingrese la cantidad de desarrolladores de la distribucion');
        readln(d.devs);
        writeln('Ingrese la desccripcion de la distribucion');
        readln(d.desc);}
    end;
end;

function ExisteDistribucion (var arc: archivo; d: distribucion):boolean;
var
    dActual: distribucion; encontre: boolean;
begin
    reset(arc);
    encontre:= false;
    leer(arc, dActual);
    while ((dActual.nombre <> valorAlto)and(not encontre)) do
    begin
        if (dActual.nombre = d.nombre) then
            encontre:= true;
        leer(arc, dActual);
    end;
    close(arc);
    ExisteDistribucion:= encontre;
end;

procedure AltaDistribucion (var arc: archivo);
var
    d, cabecera, aux: distribucion; pos: integer;
begin
    leerDistribucion(d);
    if (not ExisteDistribucion(arc, d)) then
    begin
        reset(arc);
        leer(arc, cabecera);
        if (cabecera.anio <> 0) then
        begin
            pos:= -cabecera.anio;
            seek(arc, pos);
            leer(arc, aux);
            cabecera.anio:= aux.anio;
            seek(arc, filePos(arc)-1);
            write(arc, d);
            seek(arc, 0);
            write(arc, cabecera);
        end
        else
        begin
            seek(arc, fileSize(arc));
            write(arc, d);
        end;
        close(arc);
    end
    else
        writeln('Ya existe la distribucion');
end;

procedure BajaDistribucion (var arc: archivo);
var
    dBaja, dActual, cabecera, aux: distribucion;
begin
    writeln('Ingrese el nombre de la distribucion a eliminar');
    readln(dBaja.nombre);
    if (ExisteDistribucion(arc, dBaja)) then
    begin
        reset(arc);
        leer(arc, cabecera);
        leer(arc, dActual);
        while (dActual.nombre <> dBaja.nombre) do
            leer(arc, dActual);
        seek(arc, filePos(arc)-1);
        aux.anio:= -filePos(arc);
        dActual:= cabecera;
        write(arc, dActual);
        seek(arc, 0);
        write(arc, aux);
        close(arc);
    end
    else
        writeln('Distribucion no existente');
end;

procedure cargarArchivo (var arc: archivo);
var
    d, cabecera: distribucion;
begin
    assign(arc, 'distribuciones.dat');
    rewrite(arc);
    cabecera.anio:= 0;
    write(arc, cabecera);
    leerDistribucion(d);
    while (d.nombre <> 'ZZZ') do
    begin
        write(arc, d);
        leerDistribucion(d);
    end;
    close(arc);
end;

procedure listarArchivo (var arc: archivo);
var
    d: distribucion;
begin
    reset(arc);
    leer(arc, d);
    while (d.nombre <> valorAlto) do
    begin
        if (d.anio > 0) then
            writeln('Nombre:', d.nombre, ' Anio:', d.anio);
        leer(arc, d);
    end;
    close(arc);
end;

var
    arc: archivo;
BEGIN
    writeln('----------- COMIENZA LA CARGA DEL ARCHIVO -----------');
    cargarArchivo(arc);
    writeln('----------- LISTADO -----------');
    listarArchivo(arc);
    writeln('----------- ELIMINAR DISTRIBUCION -----------');
    BajaDistribucion(arc);
    writeln('----------- LISTADO -----------');
    listarArchivo(arc);
    writeln('----------- AGREGAR DISTRIBUCION -----------');
    AltaDistribucion(arc);
    writeln('----------- LISTADO -----------');
    listarArchivo(arc);
END.

// Funciona perfectamente (lo unico dudoso es la comparacion en ExisteDistribucion que es por nombre en lugar del registro entero)



