{1. Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program P2E1;

const valorAlto = 9999;

type
    empleado = record 
        cod: integer;
        nombre: string;
        monto: integer;
        end;
    
    archivo = File of empleado;

procedure leer (var arc: archivo; var dato: empleado);
begin
    if (not EOF(arc)) then
        read(arc, dato)
    else
        dato.cod:= valorAlto;
end;

procedure leerEmpleado (var e: empleado);
begin
    writeln('Ingrese el codigo del empleado (finaliza con codigo -1)'); readln(e.cod);
    if (e.cod <> -1)then
    begin
        writeln('Ingrese el nombre del empleado'); readln(e.nombre);
        writeln('Ingrese el monto de la comision'); readln(e.monto);
    end;
end;

procedure cargarArchivo (var arc: archivo);
var
    e: empleado; nom: string;
begin
    writeln('Ingrese el nombre del archivo a crear'); readln(nom);
    assign(arc, nom);
    rewrite(arc);
    leerEmpleado(e);
    while (e.cod <> -1) do
    begin
        write(arc, e);
        leerEmpleado(e);
    end;
    close(arc);
end;

procedure imprimirArchivo (var arc: archivo);
var
    e: empleado;
begin
    reset(arc);
    leer(arc, e);
    while (e.cod <> valorAlto) do
    begin
        writeln('Codigo:', e.cod, ' Nombre:', e.nombre, ' Monto:', e.monto);
        leer(arc, e);
    end;
    close(arc);
end;

procedure compactarArchivo (var arc, compacto: archivo);
var
    e, actual: empleado; nom: string; total: integer;
begin
    writeln('Ingrese el nombre que tendra el archivo compactado'); readln(nom);
    assign(compacto, nom);
    rewrite(compacto);  // Creo el archivo que va a tener la info comapctada
    reset(arc);
    leer(arc, e);  // Leo primero el valor del archivo original
    while (e.cod <> valorAlto) do  // Verifico que no se termine
    begin
        total:= 0;  // Inicializo la variable que va a calcular el monto total de cada empleado
        actual:= e; // Variable que va a tener la info compactada y el codigo sirve para hacer el corte de control
        while (actual.cod = e.cod) do
        begin
            total:= total + e.monto;  // Actualizo el total del monto
            leer(arc, e); // Leo el siguiente
        end;
        actual.monto:= total;  // Actualizo el monto con el final de los empleados con codigo igual
        write(compacto, actual);
    end;
    close(arc); close(compacto);
end;

var
    arc, compacto: archivo;
BEGIN 
    cargarArchivo(arc);  // Hace falta escribir los codigos de empleado en orden para comprobar si funciona (ya que se supone que el archivo esta ordenado)
    imprimirArchivo(arc);
    compactarArchivo(arc, compacto);
    imprimirArchivo(compacto);
END.

    

