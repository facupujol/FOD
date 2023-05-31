{9. Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____
Código de Provincia
Código de Localidad Total de Votos
................................ ......................
Total de Votos Provincia: ___
…………………………………………………………..
Total General de Votos: ___
NOTA: La información se encuentra ordenada por código de provincia y código de
localidad.}

program P2E9;

const valorAlto = 9999;

type

    mesa = record
        provincia, localidad, numero, cantidad: integer;
    end;

    archivo = File of mesa;

procedure leer (var arc: archivo; var reg: mesa);
begin
    if (not EOF(arc)) then
        read(arc, reg)
    else
        reg.provincia:= valorAlto;
end;

procedure informarVotos (var arc: archivo);
var
    reg: mesa;
    provActual, localidadActual, totalVotos, totalProvincia, totalLocalidad: integer;
begin
    assign(arc, 'votos');   // Asumo que lo tengo
    reset(arc);
    leer(arc, reg);
    totalVotos:= 0;
    while (reg.provincia <> valorAlto) do 
    begin
        provActual:= reg.provincia;
        totalProvincia:= 0;
        writeln(provActual);
        while (reg.provincia = provActual) do
        begin
            totalLocalidad:= 0;
            localidadActual:= reg.localidad;
            write(localidadActual, 'Total de Votos: ');
            while ((reg.provincia = provActual)and(reg.localidad = localidadActual)) do
            begin
                totalLocalidad+= reg.cantidad;
                leer(arc, reg);
            end;
            writeln(totalLocalidad);
            totalProvincia+= totalLocalidad;
        end;
        writeln('Total de Votos Provincia: ', totalProvincia);
        totalVotos+= totalProvincia;
    end;
    writeln('Total de Votos: ', totalVotos);
end;

var
    arc: archivo;
begin
    informarVotos(arc);
END.

// Compila, no funciona por falta de archivos