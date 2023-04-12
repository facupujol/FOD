{8. Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente.
Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido por la
empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta.
El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras.}

{No se si entendi bien el problema, pero lo interprete como un archivo con informacion de clientes y sus compras, ordenado por codigo -> anio -> mes
donde debo recorrer el archivo informando lo pedido con corte de control}


program P2E8;

const valorAlto = 9999;

type

    cliente = record
        cod: integer;
        nombre: string;
        apellido: string;
    end;

    recordMaestro = record
        c: cliente;
        anio: integer;
        mes: integer;
        dia: integer;
        monto: real;
    end;

    archivo = File of recordMaestro;

procedure leer (var arc: archivo; var r: recordMaestro);
begin
    if (not EOF(arc)) then
        read(arc, r)
    else
        r.c.cod:= valorAlto;
end;

procedure informarVentas (var arc: archivo);
var
    totalMes, totalCliente, totalEmpresa, totalAnio: real; r: recordMaestro; mesActual, codActual, anioActual: integer;
begin
    assign(arc, 'maestro.dat'); // Asumo que el archivo maestro ya esta creado con la informacion requerida (pongo un nombre generico)
    reset(arc);
    totalEmpresa:= 0;
    leer(arc, r);
    while (r.c.cod <> valorAlto) do
    begin
        writeln('Cliente: ', r.c.cod, 'Nombre: ', r.c.nombre, 'Apellido: ', r.c.apellido);
        codActual:= r.c.cod;
        totalCliente:= 0;
        while (r.c.cod = codActual) do
        begin
            writeln('Anio: ', r.anio);
            anioActual:= r.anio;
            totalAnio:= 0;
            while (r.anio = anioActual) do
            begin
                writeln('Mes: ', r.mes);
                mesActual:= r.mes;
                totalMes:= 0;
                while (r.mes = mesActual) do
                begin
                    totalMes:= totalMes + r.monto;
                    leer(arc, r);
                end;
                writeln('Total Mes: ', totalMes);
                totalAnio:= totalAnio + totalMes;
            end;
            writeln('Total Anio: ', totalAnio);
            totalCliente:= totalCliente + totalAnio;
        end;
        totalEmpresa:= totalEmpresa + totalCliente;
    end;
    writeln('Total Empresa: ', totalEmpresa);
end;

var
    arc: archivo;
BEGIN
    informarVentas(arc);
END.




