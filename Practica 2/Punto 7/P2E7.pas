{7- El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran todos
los productos que comercializa. De cada producto se maneja la siguiente información:
código de producto, nombre comercial, precio de venta, stock actual y stock mínimo.
Diariamente se genera un archivo detalle donde se registran todas las ventas de productos
realizadas. De cada venta se registran: código de producto y cantidad de unidades vendidas.
Se pide realizar un programa con opciones para:
a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
● Ambos archivos están ordenados por código de producto.
● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del
archivo detalle.
● El archivo detalle sólo contiene registros que están en el archivo maestro.
b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
stock actual esté por debajo del stock mínimo permitido.}

program P2E7;

const valorAlto = 9999;

type
    venta = record
        codigo, cant: integer;
    end;

    producto = record
        codigo, stockActual, stockMinimo: integer;
        nombre: string[20];
        precio: real;
    end;

    detalle = File of venta;
    maestro = File of producto;

procedure leerDetalle (var arc: detalle; var reg: venta);
begin
    if (not EOF(arc)) then
        read(arc, reg)
    else
        reg.codigo:= valorAlto;
end;

procedure leerMaestro (var arc: maestro; var reg: producto);
begin
    if (not EOF(arc)) then
        read(arc, reg)
    else
        reg.codigo:= valorAlto;
end;

procedure actualizarMaestro (var m: maestro);
var
    d: detalle; v: venta; p: producto;
    totalVentas, codigoActual: integer;
begin
    assign(d, 'detalle');
    reset(d);
    assign(m, 'maestro');
    reset(m);
    leerDetalle(d, v);
    while (v.codigo <> valorAlto) do
    begin
        codigoActual:= v.codigo;
        totalVentas:= 0;
        while (v.codigo = codigoActual) do
        begin
            totalVentas+= v.cant;
            leerDetalle(d, v);
        end;
        leerMaestro(m, p);
        while (p.codigo <> codigoActual) do
            leerMaestro(m, p);
        p.stockActual-= totalVentas;
        seek(m, filePos(m)-1);
        write(m, p);
    end;
    close(d);
    close(m);
end;

procedure listarStockInsuficiente (var m: maestro);
var
    texto: Text; p: producto;
begin
    reset(m);
    assign(texto, 'stock_minimo.txt');
    rewrite(texto);
    leerMaestro(m, p);
    while (p.codigo <> valorAlto) do
    begin
        if (p.stockActual < p.stockMinimo) then
        begin
            write(texto, p.codigo, '', p.stockActual, ' ', p.stockMinimo, ' ', p.nombre);
            write(texto, p.precio);
        end;
        leerMaestro(m, p);
    end;
    close(m);
    close(texto);
end;

var
    m: maestro;
begin
    actualizarMaestro(m);
    listarStockInsuficiente(m);
END.

// Compila, no funciona por falta de archivos
