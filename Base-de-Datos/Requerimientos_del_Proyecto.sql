/* Se crean en la conexion de PROYECTO para que se almacenen en la base de datos  */

/* Vistas */

/* Andrés */
create or replace view tareas_asignadas_recientemenete as 
select FECHAINGRESO FROM tareas_asignadas
ORDER BY fechaingreso ASC;

/* Diego */
CREATE OR REPLACE VIEW Vista_Profesores_Cursos_Tareas AS
SELECT p.nombreProf, p.apellidosProf, c.nombreCurso, t.descripcion, t.fechaIngreso, t.fechaRealizar, t.estado
FROM Profesor p
INNER JOIN Cursos c ON p.idProfesor = c.idProfesor
INNER JOIN Tareas t ON c.idCurso = t.idCurso;

/* Funciones */



/* Procedimientos almacenados */ 
CREATE OR REPLACE PROCEDURE Insertar_Sede
AS 
    id INT;
    nombre varchar (20);
    ubicacionSede varchar(20);
begin
    insert into proyecto.sedes(
    idSede, 
    nombreSede,
    ubicacion
    ) values (
                        id, 
                        nombre, 
                        ubicacionSede);
    end;
    /


CREATE OR REPLACE PROCEDURE Inserta_Profe
AS 
    cedula int;
    password varchar (8);
    nombre varchar(20);
    apellidos varchar(20);
    idSede int;
begin
    insert into proyecto.Profesor(
    idProfesor, 
    contraseña,
    nombreProf,
    apellidosProf, 
    idSede
    ) values (
                      cedula,
                      password,
                      nombre, 
                      apellidos,
                      idSede );                                                                                                                                                                                                                                                                                                        
    end;
    /
    
CREATE OR REPLACE PROCEDURE Inserta_Cursos
AS 
    cod_Curso int;
    nombre varchar (40);
begin
    insert into proyecto.Cursos(
    idCurso, 
    nombreCurso
    ) values (
                        cod_Curso, 
                        nombre);
    end;
    /
    
CREATE OR REPLACE PROCEDURE Inserta_Tareas
AS 
    id int;
    descripcion varchar (70);
    fecha_asignada date;
    fecha_entrega date;
    estado varchar(15);
    id_curso int;
begin
    insert into proyecto.Tareas(
    idTarea, 
    descripcion,
    fechaIngreso,
    fechaRealizar,
    estado,
    idCurso
    ) values (   
                        id,
                        descripcion,
                        fecha_asignada,
                        fecha_entrega,
                        estado,
                        id_curso);
    end;
    /    
/* Paquetes */

/* Cursores */

/* Triggers */

/* Andrés */
CREATE OR REPLACE TRIGGER no_tareas_fecha_pasada_trigger
BEFORE INSERT ON TAREAS
FOR EACH ROW
DECLARE
    fecha_actual DATE;
BEGIN
    fecha_actual := SYSDATE;
    IF :NEW.FECHAINGRESO < fecha_actual THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede insertar una tarea con fecha de ingreso que ya pasó.');
    END IF;
END;
