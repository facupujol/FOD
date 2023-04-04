{2. Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:
a. Actualizar el archivo maestro de la siguiente manera:
i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado.
ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin
final.
b. Listar en un archivo de texto los alumnos que tengan más de cuatro materias
con cursada aprobada pero no aprobaron el final. Deben listarse todos los campos.
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez.}

program P2E2;

const valorAlto = 9999;

type

    alumno = record
        cod: integer;
        apellido: string;
        nombre: string;
        cursadas: integer;
        aprobadas: integer;
    end;

    materia = record
        codAlum: integer;
        aproboCursada: boolean;
        aproboFinal: boolean;
    end;

    arcAlumnos = File of alumno;
    arcMateria = File of materia;

procedure leerAlumno (var a: alumno);
begin
    writeln('Ingrese el codigo de alumno (-1 para finalizar)'); readln(a.cod);
    if (a.cod <> -1) then
    begin
        writeln('Ingrese el apellido del alumno'); readln(a.apellido);
        writeln('Ingrese el nombre del alumno'); readln(a.nombre);
        writeln('Ingrese la cantidad de materias cursadas del alumno'); readln(a.cursadas);
        writeln('Ingrese la cantidad de materias con final aprogbado del alumno'); readln(a.aprobadas);
    end;
end;

procedure leerMateria (var m: materia);
var
    n: integer;
begin
 writeln('Ingrese el codigo de alumno (-1 para finalizar)'); readln(m.codAlum);
    if (m.codAlum <> -1) then
    begin
        writeln('Ingrese si el alumno aprobo la cursada');  readln(n);
        if (n = 0) then
            m.aproboCursada:= false
        else
            m.aproboCursada:= true;
        writeln('Ingrese si el alumno aprobo el final'); readln(n);
        if (n = 0) then
            m.aproboFinal:= false
        else
            m.aproboFinal:= true;
    end;
end;

procedure cargarArchivoAlumnos (var arc: arcAlumnos);
var
    a: alumno;
begin
    assign(arc, 'maestro');
    rewrite(arc);
    leerAlumno(a);
    while (a.cod <> -1) do
    begin
        write(arc, a);
        leerAlumno(a);
    end;
    close(arc);
end;

procedure cargarArchivoMaterias (var arc: arcMateria);
var
    m: materia;
begin
    assign(arc, 'detalle');
    rewrite(arc);
    leerMateria(m);
    while (m.codAlum <> -1) do
    begin
        write(arc, m);
        leerMateria(m);
    end;
    close(arc);
end;

procedure leer (var arc: arcMateria; var m: materia);
begin
    if (not EOF(arc))then
        read(arc, m)
    else
        m.codAlum:= valorAlto;
end;

procedure imprimirArchivoAlumnos (var arc: arcAlumnos);
var
    a: alumno;
begin
    reset(arc);
    while (not EOF(arc)) do
    begin
        read(arc, a);
        writeln('Codigo:', a.cod, ' Apellido:', a.apellido, ' Nombre:', a.nombre, ' Cursadas:', a.cursadas, ' Aprobadas:', a.aprobadas);
    end;
    close(arc);
end;

procedure imprimirArchivoMaterias (var arc: arcMateria);
var
    m: materia;
begin
    reset(arc);
    leer(arc, m);
    while (m.codAlum <> valorAlto) do
    begin
        writeln('Codigo:', m.codAlum, ' Aprobo cursada:', m.aproboCursada, ' Aprobo final:', m.aproboFinal);
        read(arc, m);
    end;
    close(arc);
end;

procedure actualizarMaestro (var arcAlum: arcAlumnos; var arcMat: arcMateria);
var
    regD: materia; regM: alumno; totalC, totalF, aux: integer;
begin
    reset(arcAlum); reset(arcMat); // Los dos comienzan en el principio
    read(arcAlum, regM); leer(arcMat, regD); // Leo ambos
    while (regD.codAlum <> valorAlto) do // Loopeo mientras el detalle no termine
    begin
        aux:= regD.codAlum; totalF:= 0; totalC:= 0;
        while (regD.codAlum = aux) do // Loopeo mientras el detalle siga trabajando sobre el mismo alumno
        begin
            if (regD.aproboCursada = true) then
                totalC:= totalC + 1;  // Si aprobo la cursada sumo uno a sus cursadas aprobadas
            if (regD.aproboFinal = true) then
                totalF:= totalF + 1;  // Si aprobo el final sumo uno a sus materias aprobadas
            leer(arcMat, regD);
        end;
        while (regM.cod <> aux) do // Una vez obtenida toda la info sobre las materias, busco al alumno en el maestro
        begin
            read(arcAlum, regM);
        end;
        regM.cursadas:= regM.cursadas + totalC;
        regM.aprobadas:= regM.aprobadas + totalF; // Actualizo los valores de ambos campos con lo obtenido en el detalle
        seek(arcAlum, filepos(arcAlum) - 1);
        write(arcAlum, regM); // Me posiciono y lo escribo
        if (not EOF(arcAlum)) then
            read(arcAlum, regM);
    end;
end;

var
    maestro: arcAlumnos; detalle: arcMateria;
BEGIN
    writeln('--------------------COMIENZA CARGA DEL ARCHIVO MAESTRO--------------------');
    cargarArchivoAlumnos(maestro);
    imprimirArchivoAlumnos(maestro);
    writeln('--------------------COMIENZA CARGA DEL ARCHIVO DETALLE--------------------');
    cargarArchivoMaterias(detalle);
    imprimirArchivoMaterias(detalle);
    writeln('--------------------ARCHIVO MAESTRO CAMBIADO--------------------');
    actualizarMaestro(maestro, detalle);
    imprimirArchivoAlumnos(maestro);
END.








