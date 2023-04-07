{4. Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma
fue construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
Notas:
- Cada archivo detalle está ordenado por cod_usuario y fecha.
- Un usuario puede iniciar más de una sesión el mismo día en la misma o en diferentes
máquinas.
- El archivo maestro debe crearse en la siguiente ubicación física: /var/log.}

program P2E4;

uses SysUtils;

const   valorAlto = 9999;

type

    registroDetalle = record
        cod_usuario: integer;
        fecha: string;
        tiempo_sesion: integer;
    end;

    registroMaestro = record
        cod_usuario: integer;
        fecha: string;
        tiempo_total_de_sesiones_abiertas: integer;
    end;

    archivoDetalle = File of registroDetalle;
    archivoMaestro = File of registroMaestro;

    vectorDetalles = array [1..5] of archivoDetalle;
    vectorRegistros = array[1..5] of registroDetalle;

procedure leer (var archivo: archivoDetalle; var registro: registroDetalle);
begin
    if (not EOF(archivo)) then
        read(archivo, registro)
    else
        registro.cod_usuario:= valorAlto;
end;

procedure minimo (var vectorArchivos: vectorDetalles; var vectorReg: vectorRegistros; var min: registroDetalle);
var
    i, posMin: integer; 
begin
    min.cod_usuario:= valorAlto;
    for i:= 1 to 5 do
    begin
        if (vectorReg[i].cod_usuario < min.cod_usuario) then
        begin
            min:= vectorReg[i];
            posMin:= i;
        end;
    end;
    leer(vectorArchivos[posMin], vectorReg[posMin]);
end;

procedure inicializarDetalles (var vectorArchivos: vectorDetalles);
var
    i: integer;
begin
    for i:= 1 to 5 do
    begin
        assign(vectorArchivos[i], 'detalle' + IntToStr(i));
        rewrite(vectorArchivos[i]);
    end;
end;

procedure resetDetalles (var vector: vectorDetalles);
var
    i: integer;
begin
    for i:= 1 to 5 do
        reset(vector[i]);
end;


procedure crearMaestro (var maestro: archivoMaestro);
var
    aux: registroMaestro; min: registroDetalle; tiempoTotal, i: integer; vecDetalles: vectorDetalles; vectorReg: vectorRegistros;
begin
    assign(maestro, '/var/log/maestro');
    inicializarDetalles(vecDetalles);
    rewrite(maestro);
    resetDetalles(vecDetalles);
    for i:= 1 to 5 do
        leer(vecDetalles[i], vectorReg[i]);
    minimo(vecDetalles, vectorReg, min);
    while (min.cod_usuario <> valorAlto ) do
    begin
        aux.cod_usuario:= min.cod_usuario;
        aux.fecha:= min.fecha;
        tiempoTotal:= 0;
        while (aux.cod_usuario = min.cod_usuario) do
        begin
            tiempoTotal:= tiempoTotal + min.tiempo_sesion;
            minimo(vecDetalles, vectorReg, min);
        end;
        aux.tiempo_total_de_sesiones_abiertas:= tiempoTotal;
        write(maestro, aux);
    end;
end;

var

    maestro: archivoMaestro;

BEGIN
    crearMaestro(maestro);
END.


