{6- Se desea modelar la información necesaria para un sistema de recuentos de casos de
covid para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad casos
activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad casos activos, cantidad casos
nuevos, cantidad recuperados y cantidad de fallecidos.
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).}

program P3E6;

uses SysUtils;

const 
    valorAlto = 9999;
    N = 10;

type

    regDetalle = record
        localidad, cepa, activos, nuevos, recuperados, fallecidos: integer;
    end;

    regMaestro = record
        codLoc, codCepa, activos, nuevos, recuperados, fallecidos: integer;
        nomLoc, nomCepa: string[20];
    end;

    archivoDetalle = File of regDetalle;
    archivoMaestro = File of regMaestro;

    vectorArchivos = array [1..N] of archivoDetalle;
    vectorRegistros = array [1..N] of regDetalle;

procedure leerDetalle (var arc: archivoDetalle; var reg: regDetalle);
begin
    if (not EOF(arc)) then
        read(arc, reg)
    else
        reg.localidad:= valorAlto;
end;

procedure leerMaestro (var arc: archivoMaestro; var reg: regMaestro);
begin
    if (not EOF(arc)) then
        read(arc, reg)
    else
        reg.codLoc:= valorAlto;
end;  

procedure inicializarDetalles (var vec: vectorArchivos);
var
    i: integer;
begin
    for i:= 1 to N do
    begin
        assign(vec[i], 'detalle' + IntToStr(i));
        reset(vec[i]);
    end;
end;

procedure minimo (var archivos: vectorArchivos; var registros: vectorRegistros; min: regDetalle);
var
    i, indiceMin: integer;
begin
    min.localidad:= valorAlto;
    min.cepa:= valorAlto;
    indiceMin:= 0;
    for i:= 1 to N do
    begin
        if (registros[i].localidad <> valorAlto) then
        begin
            if ((registros[i].localidad < min.localidad)or((registros[i].localidad = min.localidad)and(registros[i].cepa < min.cepa))) then
            begin
                indiceMin:= i;
                min:= registros[i];
            end;
        end;
    end;
    if (indiceMin <> 0) then
        leerDetalle(archivos[indiceMin], registros[indiceMin]);
end;

procedure actualizarMaestro (var maestro: archivoMaestro; var detalles: vectorArchivos);
var
    i, totalFallecidos, totalRecuperados, activos, nuevos, locActual, cepaActual: integer; 
    min: regDetalle; regM: regMaestro;
    registros: vectorRegistros;
begin
    reset(maestro);
    for i:= 1 to N do
        leerDetalle(detalles[i], registros[i]);
    minimo(detalles, registros, min);
    while (min.localidad <> valorAlto) do
    begin
        locActual:= min.localidad;
        while (min.localidad = locActual) do
        begin
            cepaActual:= min.cepa;
            totalFallecidos:= 0; totalRecuperados:= 0;
            while ((cepaActual = min.cepa)and(min.localidad = locActual)) do
            begin
                totalFallecidos+= min.fallecidos;
                totalRecuperados+= min.recuperados;
                activos:= min.activos;
                nuevos:= min.nuevos;
                minimo(detalles, registros, min);
            end;
            leerMaestro(maestro, regM);
            while (locActual <> regM.codLoc) do
                leerMaestro(maestro, regM);
            while (cepaActual <> regM.codCepa) do
                leerMaestro(maestro, regM);
            regM.fallecidos+= totalFallecidos;
            regM.recuperados+= totalRecuperados;
            regM.activos:= activos;
            regM.nuevos:= nuevos;
            seek(maestro, filePos(maestro)-1);
            write(maestro, regM);
        end;
    end;
    for i:= 1 to N do
        close(detalles[i]);
    close(maestro);
end;

procedure informarLocalidades (var maestro: archivoMaestro);
var
    regM: regMaestro;
    locActual, activosTotal, totalLocalidades: integer;
begin
    reset(maestro);
    leerMaestro(maestro, regM);
    totalLocalidades:= 0;
    while (regM.codLoc <> valorAlto) do
    begin
        locActual:= regM.codLoc;
        activosTotal:= 0;
        while ((regM.codLoc = locActual)and(regM.codLoc <> valorAlto)) do
        begin
            activosTotal+= regM.activos;
            leerMaestro(maestro, regM);
        end;
        if (activosTotal > 50) then
            totalLocalidades:= totalLocalidades + 1;
    end;
    writeln('Cantidad de localidades con una cantidad de casos activos mayor a 50: ', totalLocalidades);   
    close(maestro);
end;

var
    maestro: archivoMaestro; detalles: vectorArchivos;
begin
    assign(maestro, 'maestro');
    inicializarDetalles(detalles);
    actualizarMaestro(maestro, detalles);
    informarLocalidades(maestro);
END.

// Compila (no corre bien porque no tengo los detalles ni el maestro que asumo que tengo en el programa)
     