{3. Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo.
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto.}

program P2E3;

const valorAlto = 9999;

uses SysUtils;

type

    producto = record
        cod, stockDisp, stockMin: integer;
        precio: real;
        nombre, desc: string;
    end;

    productoDetalle = record   
        codDet: integer;
        cant: integer;
    end;

    arcProd = File of producto;
    arcDet = File of productoDetalle;

    vectorDetalles = array [1..30] of arcDet;

procedure leer (var arc: arcDet; var d: productoDetalle);
begin
    if (not EOF(arc)) then
        read(arc, d)
    else
        d.codDet:= valorAlto;
end;

procedure actualizarMaestro (var detalle: arcDet; var maestro: arcProd);
var
    d: productoDetalle;
    m: producto;
    actual, cant: integer;
begin
    reset(maestro); reset(detalle); // Los dos archivos en su comienzo
    leer(detalle, d); read(maestro, m);
    while (d.codDet <> valorAlto) do  // Mientras no termine el detalle
    begin
        actual:= d.codDet;  // Agarro el codigo del producto actual para el corte de control
        cant:= 0;   // Inicializo la cantidad vendida en 0

        while (d.codDet = actual) do  // Sumo la cantidad total vendida ya que puede haber muchas ventas de un mismo producto
        begin
            cant:= cant + d.cant;
            leer(detalle, d);
        end;

        while (d.codDet <> actual) do    // Busco el maestro correspondiente al detalle
            read(maestro, m);

        m.stockDisp:= m.stockDisp - cant;   // Actualizo el stock del archivo maestro con el total de ventas
        seek(maestro, filePos(maestro)-1);  // Me posiciono en la posicion que quiero escribir
        write(maestro, m);
    end;

end;

procedure binarioATexto (var arc: arcProd);
var
    texto: Text; p: producto;
begin
    assign(texto, 'stockInvalido.txt');
    reset(arc); rewrite(texto);
    while (not EOF(arc)) do
    begin
        read(arc, p);
        if (p.stockDisp < p.stockMin) then
        begin
            writeln(texto, p.nombre);
            writeln(texto, p.desc);
            writeln(texto, p.stockDisp, ' ', p.precio);
        end;
    end;
end;


procedure recibirDetalles (var vec: vectorDetalles; var arc: arcProd);
var
    i: integer;
begin
    for i:= 1 to 30 do
    begin
        assign(vec[i], 'archivo' + IntToStr(i));
        actualizarMaestro(vec[i], arc);
    end;
end;


var
    vec: vectorDetalles;
    arc: arcProd;
BEGIN 

    recibirDetalles(vec, arc);
    binarioATexto(arc);

END.