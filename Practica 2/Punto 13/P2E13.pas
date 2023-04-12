{13. Suponga que usted es administrador de un servidor de correo electrónico. En los logs
del mismo (información guardada acerca de los movimientos que ocurren en el server) que
se encuentra en la siguiente ruta: /var/log/logmail.dat se guarda la siguiente información:
nro_usuario, nombreUsuario, nombre, apellido, cantidadMailEnviados. Diariamente el
servidor de correo genera un archivo con la siguiente información: nro_usuario,
cuentaDestino, cuerpoMensaje. Este archivo representa todos los correos enviados por los
usuarios en un día determinado. Ambos archivos están ordenados por nro_usuario y se
sabe que un usuario puede enviar cero, uno o más mails por día.
a- Realice el procedimiento necesario para actualizar la información del log en
un día particular. Defina las estructuras de datos que utilice su procedimiento.
b- Genere un archivo de texto que contenga el siguiente informe dado un archivo
detalle de un día determinado:
nro_usuarioX…………..cantidadMensajesEnviados
………….
nro_usuarioX+n………..cantidadMensajesEnviados
Nota: tener en cuenta que en el listado deberán aparecer todos los usuarios que
existen en el sistema.}

program P2E14;

uses SysUtils;

const valorAlto = 9999;

type

    registroLog = record
        nro_usuario: integer;
        nombreUsuario: string;
        nombre: string;
        apellido: string;
        cantidadMailEnviados: integer;
    end;

    registroCorreo = record
        nro_usuario: integer;
        cuentaDestino: string;
        cuerpoMensaje: string;
    end;

    archivoLog = File of registroLog;
    archivoCorreo = File of registroCorreo;

procedure leerCorreo (var arc: archivoCorreo; var l: registroCorreo);
begin
    if (not EOF(arc)) then
        read(arc, l)
    else   
        l.nro_usuario:= valorAlto;
end;

procedure actualizarMaestro (var detalle: archivoCorreo; var maestro: archivoLog);
var
    d, actual: registroCorreo; cant: integer; m: registroLog; texto: Text;
begin
    assign(texto, 'informe_diario.txt');
    rewrite(texto);
    reset(detalle);
    reset(maestro);
    leerCorreo(detalle, d); read(maestro, m);
    while (d.nro_usuario <> valorAlto) do
    begin
        cant:= 0;
        actual:= d;
        while (d.nro_usuario = actual.nro_usuario) do
        begin
            cant:= cant + 1;
            leerCorreo(detalle, d);
        end;
        writeln(texto, 'nro_Usuario' + IntToStr(actual.nro_usuario), ' cantidadDeMensajesEnviados: ', cant);
        while (m.nro_usuario <> d.nro_usuario) do
            read(maestro, m);
        m.cantidadMailEnviados:= m.cantidadMailEnviados + cant;
        seek(maestro, filePos(maestro)-1);
        write(maestro, m);
    end;
end;

var
    detalle: archivoCorreo;
    maestro: archivoLog;

BEGIN
    assign(detalle, 'logmail.dat');
    actualizarMaestro(detalle, maestro);
END.
    

