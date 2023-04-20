{6. Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado
con la información correspondiente a las prendas que se encuentran a la venta. De
cada prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las prendas
a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las prendas que
quedarán obsoletas. Deberá implementar un procedimiento que reciba ambos archivos
y realice la baja lógica de las prendas, para ello deberá modificar el stock de la prenda
correspondiente a valor negativo.
Por último, una vez finalizadas las bajas lógicas, deberá efectivizar las mismas
compactando el archivo. Para ello se deberá utilizar una estructura auxiliar, renombrando
el archivo original al finalizar el proceso.. Solo deben quedar en el archivo las prendas
que no fueron borradas, una vez realizadas todas las bajas físicas.}

program P3E6;

const valorAlto = 9999;

type

    prenda = record
        cod_prenda: integer;
        desc: string[20];
        colores: string[20];
        tipo: string[20];
        stock: integer;
        precio: integer;
    end;

    arcMaestro = File of prenda;
    arcDetalle = File of integer;

procedure leer (var arc: arcDetalle; var n: integer);
begin
    if (not EOF(arc)) then
        read(arc, n)
    else
        n:= valorAlto;
end;

procedure actualizarMaestro (var maestro: arcMaestro; var detalle: arcDetalle);
var
    n: integer; p: prenda;
begin
    assign(maestro, 'maestro'); // Abro los dos archivos al principio
    reset(maestro);
    assign(detalle, 'detalle');
    reset(detalle);
    leer(detalle, n);   // Leo el primer detalle
    while (n <> valorAlto) do   // Mientras no termine el archivo de detalles
    begin
        read(maestro, p);
        while (p.cod_prenda <> n) do    // Busco la prenda del detalle en el maestro
            read(maestro, p);
        p.stock := -p.stock;    // Pongo el stock de la prenda en negativo
        seek(maestro, filePos(maestro)-1);  // Me posiciono para sobreescribir en el registro indicado
        write(maestro, p); 
        reset(maestro); // Vuelvo al principio del maestro (asumo que el detalle no esta ordenado)
        leer(detalle, n);   // Sigo leyendo el detalle
    end;
    close(maestro); // Cierro ambos archivos
    close(detalle);
end;

procedure compactarMaestro (var maestro: arcMaestro);
var
    p: prenda; aux: arcMaestro;
begin
    assign(aux, 'maestro_nuevo');
    rewrite(aux);
    assign(maestro, 'maestro');
    reset(maestro);
    while (not EOF(maestro)) do
    begin
        read(maestro, p);
        if (p.stock > 0) then
            write(aux, p);
    end;
    Erase(maestro);
    assign(aux, 'maestro');
    close(aux);
end;

var
    maestro: arcMaestro; detalle: arcDetalle;
BEGIN
    actualizarMaestro(maestro, detalle);
    compactarMaestro(maestro);
END.

// Compila bien, pero como falta cargar los archivos no corre bien y tira error.