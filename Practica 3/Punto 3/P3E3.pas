{3. Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:
a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:
i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.
ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.
c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.}

program P3E3;

const valorAlto = 9999;

type
    novela = record
        codigo: integer;
        genero: string[20];
        nombre: string[20];
        duracion: integer;
        director: string[20];
        precio: real;
    end;

    archivo = File of novela;

procedure leerNovela(var n: novela);
begin
    writeln('Ingrese el codigo de la novela (-1 para finalizar)');
    readln(n.codigo);
    if (n.codigo <> -1) then
    begin
        writeln('Ingrese el genero');
        readln(n.genero);
        writeln('Ingrese el nombre');
        readln(n.nombre);
        writeln('Ingrese la duracion');
        readln(n.duracion);
        writeln('Ingrese el director');
        readln(n.director);
        writeln('Ingrese el precio');
        readln(n.precio);
    end;
end;

procedure leer(var arc: archivo; var n: novela);
begin
    if (not EOF(arc)) then
        read(arc, n)
    else
        n.codigo:= valorAlto;
end;

procedure cargarArchivo (var arc: archivo);
var
    n, cabecera: novela;  nombre: string[20];
begin
    cabecera.codigo:= 0;
    writeln('Ingrese el nombre del archivo a crear');
    readln(nombre);
    assign(arc, nombre);
    rewrite(arc);
    write(arc, cabecera);
    leerNovela(n);
    while (n.codigo <> -1) do
    begin
        write(arc, n);
        leerNovela(n);
    end;
    close(arc);
end;

procedure agregarNovela(var arc: archivo);
var
    n, cabecera, aux: novela; pos: integer; nombre: string[20];
begin
    writeln('Ingrese el nombre del archivo con el que trabajar');
    readln(nombre);
    assign(arc, nombre);
    writeln('A continuacion se le pedira la informacion de la novela a agregar');
    leerNovela(n);
    reset(arc);
    read(arc, cabecera);    // Leo la cabecera
    if (cabecera.codigo <> 0) then  // Si hay espacio libre
    begin
        pos:= -cabecera.codigo; // La posicion que voy a utilizar es la que tiene la cabecera (saco el valor positivo)
        seek(arc, pos);
        read(arc, aux); // Me posiciono y leo el valor siguiente en la lista de posiciones disponibles
        cabecera.codigo:= aux.codigo;   // La cabecera ahora actualizo la lista
        seek(arc, filePos(arc)-1);  // Me posiciono de nuevo en el lugar para escribir la novela que quiero agregar
        write(arc, n);
        reset(arc);
        write(arc, cabecera);   // Sobreescribo la cabecera para actualizar la lista
    end
    else    // Si no hay espacio libre
        begin
        seek(arc, fileSize(arc));   // Escribo en el final
        write(arc, n);
        end;
    close(arc);
end;

procedure modificarNovela (var arc: archivo);
var
    n, aux: novela; nom: string[20];
begin
    writeln('Ingrese el nombre del archivo con el que trabajar');
    readln(nom);
    assign(arc, nom);
    writeln('El codigo de novela no sera modificado y sera utilizado para buscar la novela a modificar');
    leerNovela(n);
    reset(arc);
    leer(arc, aux);
    while ((aux.codigo <> n.codigo)and(aux.codigo <> valorAlto))do
        leer(arc, aux);
    if (aux.codigo = n.codigo) then
    begin
        seek(arc, filePos(arc)-1);
        write(arc, n);
    end
    else
        writeln('No se encontro la novela');
    close(arc);
end;
        
procedure eliminarNovela(var arc: archivo);
var
    nom: string[20];  cabecera, n, pos: novela; codigo: integer;
begin
    writeln('Ingrese el nombre del archivo con el que trabajar');
    readln(nom);
    assign(arc, nom);
    reset(arc);
    read(arc, cabecera);    // Leo la cabecera
    writeln('Ingrese el codigo de la novela a eliminar');
    readln(codigo);
    leer(arc, n);
    while ((codigo <> n.codigo)and(n.codigo <> valorAlto)) do
        leer(arc, n);
    if (n.codigo = codigo) then // Si encontre el codigo
    begin
        seek(arc, filepos(arc)-1);    // Me vuelvo a posicionar en el lugar
        pos.codigo:= -filePos(arc); // Me guardo la posicion para guardarla en la cabecera como un numero negativo
        n:= cabecera;     // Pongo en el lugar lo que estaba en el registro cabecera
        write(arc, n);  // Lo escribo en el lugar y queda como borrado
        reset(arc); // Vuelvo al inicio del archivo
        write(arc, pos);    // Escribo la posicion que acabo de eliminar
    end
    else    // Si no encontre el codigo
        writeln('No se encontro la novela con el codigo ingresado');
    close(arc);
end;

procedure pasarATexto (var arc: archivo);
var
    texto: Text; n: novela; nom: string[20];
begin
    writeln('Ingrese el nombre del archivo a trabajar');
    readln(nom);
    assign(arc, nom);
    reset(arc);
    assign(texto, 'novelas.txt');
    rewrite(texto);
    leer(arc, n); // Skippeo la cabecera
    leer(arc, n);
    while (n.codigo <> valorAlto) do
    begin
        if (n.codigo > 0) then
        begin
            writeln(texto, n.codigo, ' ', n.genero);
            writeln(texto, n.nombre);
            writeln(texto, n.duracion, ' ', n.director);
            writeln(texto, n.precio);
            leer(arc, n);
        end
        else
        begin
            writeln(texto, '');
            leer(arc, n);
        end;
    end;
    close(arc);
    close(texto);
end;

procedure listarMenu (var arc: archivo);
var
    o: integer;
begin
    writeln('Ingrese una opcion 1-5 ');
    writeln('1 - Crear y cargar un archivo de novelas');
    writeln('2 - Agregar una novela a un archivo ya existente');
    writeln('3 - Modificar una novela de un archivo ya existente');
    writeln('4 - Eliminar una novela de un archivo ya existente');
    writeln('5 - Generar un archivo de texto a partir de un archivo ya existente');
    readln(o);
    case o of
        1: cargarArchivo(arc);
        2: agregarNovela(arc);
        3: modificarNovela(arc);
        4: eliminarNovela(arc);
        5: pasarATexto(arc);
    else
        writeln('Opcion invalida');
        end;
end;

var
    arc: archivo;
BEGIN
    listarMenu(arc);
END.

// Compila bien, el unico metodo que no funciona bien es el modificarNovela