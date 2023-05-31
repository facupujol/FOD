{11. A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.
NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.}

program P2E11;

uses SysUtils;

const 

    valorAlto = 'ZZZZ';
    N = 2;

type

    regDetalle = record
        nombreProvincia: string[20];
        codigoLocalidad, cantAlfabetizados, cantEncuestados: integer;
    end;

    regMaestro = record
        nombreProvincia: string[20];
        totalAlfabetizados, totalEncuestados: integer;
    end;

    archivoDetalle = File of regDetalle;
    archivoMaestro = File of regMaestro;

    vectorArchivos = array [1..N] of archivoDetalle;    // Un poco innecesario hacer vectores, pero para practicar
    vectorRegistros = array [1..N] of regDetalle;

procedure leer (var arc: archivoDetalle; var reg: regDetalle);
begin
    if (not EOF(arc)) then
        read(arc, reg)
    else
        reg.nombreProvincia:= valorAlto;
end;

procedure leerMaestro (var arc: archivoMaestro; var reg: regMaestro);
begin
    if (not EOF(arc)) then
        read(arc, reg)
    else
        reg.nombreProvincia:= valorAlto;
end;

procedure inicializarDetalles(var vec: vectorArchivos);
var
    i: integer;
begin
    for i:= 1 to N do
    begin
        assign(vec[i], 'detalle' + IntToStr(i));
        reset(vec[i]);
    end;
end;

procedure minimo (var archivos: vectorArchivos; var registros: vectorRegistros; var min: regDetalle);
var
    i, indiceMin: integer;
begin
    min.nombreProvincia:= valorAlto;
    indiceMin:= 0;
    for i:= 1 to N do   // Innecesario hacer con un for porque son solo 2, pero para practicar sintaxis
    begin
        if (registros[i].nombreProvincia < min.nombreProvincia) then
        begin
            min:= registros[i];
            indiceMin:= i;
        end;
    end;
    if (indiceMin <> 0) then
        leer(archivos[indiceMin], registros[indiceMin]);
end;

procedure actualizarMaestro (var m: archivoMaestro);
var
    i, totalEncuestadosProvincia, totalAlfabetizadosProvincia: integer; regM: regMaestro; min: regDetalle;
    provinciaActual: string[20];
    detalles: vectorArchivos; registros: vectorRegistros;
begin
    assign(m, 'maestro');
    inicializarDetalles(detalles);
    for i:= 1 to N do
        leer(detalles[i], registros[i]);
    minimo(detalles, registros, min);
    while (min.nombreProvincia <> valorAlto) do
    begin
        provinciaActual:= min.nombreProvincia;
        totalAlfabetizadosProvincia:= 0;
        totalEncuestadosProvincia:= 0;
        while (provinciaActual = min.nombreProvincia) do
        begin
            totalAlfabetizadosProvincia+= min.cantAlfabetizados;
            totalEncuestadosProvincia+= min.cantEncuestados;
            minimo(detalles, registros, min);
        end;
        leerMaestro(m, regM);
        while (regM.nombreProvincia <> provinciaActual) do
            leerMaestro(m, regM);
        regM.totalAlfabetizados+= totalAlfabetizadosProvincia;
        regM.totalEncuestados+= totalEncuestadosProvincia;
        seek(m, filePos(m)-1);
        write(m, regM);
    end;
    for i:= 1 to N do
        close(detalles[i]);
    close(m);
end;
        
var
    m: archivoMaestro;
begin
    actualizarMaestro(m);
END.

// Compila, pero no funciona por falta de archivos