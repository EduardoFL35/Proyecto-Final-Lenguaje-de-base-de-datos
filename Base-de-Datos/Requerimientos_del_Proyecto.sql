/* Se crean en la conexion de PROYECTO para que se almacenen en la base de datos  */

/*************** Vistas ****************/
--- CURSOS 
create or replace view Mostrar_nombre_curso AS
select nombrecurso from CURSOS;




--- INCIDENTES
create or replace view Mostrar_incidente AS
select descripcion from incidentes;

--- PROFESOR 
/* Diego */
CREATE OR REPLACE VIEW Vista_Profesores_Cursos_Tareas AS
SELECT p.nombreProf, p.apellidosProf, c.nombreCurso, t.descripcion, t.fechaIngreso, t.fechaRealizar, t.estado
FROM Profesor p
INNER JOIN Cursos c ON p.idProfesor = c.idProfesor
INNER JOIN Tareas t ON c.idCurso = t.idCurso;

create or replace view Mostrar_Profesores AS
select nombreprof, apellidosprof from PROFESOR;

-- SEDES 
create or replace view Mostrar_Sede AS
select nombresede, ubicacion from sedes;

-- TAREAS 
create or replace view Mostrar_tareas AS
select descripcion, idcurso from tareas;

-- TAREAS_ASIGNADAS 
create or replace view Mostrar_Tareas_Asignadas AS
select * from tareas_asignadas;

/* Andrés */
create or replace view tareas_asignadas_recientemenete as 
select FECHAINGRESO FROM tareas_asignadas
ORDER BY fechaingreso ASC;

/*************** Funciones ***************/



/*************** Procedimientos almacenados ***************/ 
-- CURSOS 
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
    
CREATE or REPLACE PROCEDURE actualizar_cursos(act_id_curso in INT,nombre_curso IN VARCHAR,id_sede IN INT,id_profesor IN INT)
is
BEGIN
    UPDATE cursos SET NOMBRECURSO = nombre_curso, IDSEDE = id_sede, IDPROFESOR = id_profesor 
    WHERE IDCURSO = act_id_curso;
END;
/    

-- INCIDENTES 
CREATE OR REPLACE PROCEDURE Inserta_Incidente
AS 
    IDINCIDENTE int;
    DESCRIPCION varchar (256);
    IDTAREA INT;
    IDCURSO INT;
    IDPROFESOR int;
begin
    insert into proyecto.INCIDENTES(
    IDINCIDENTE, 
    DESCRIPCION,
    IDTAREA,
    IDCURSO, 
    IDPROFESOR
    ) values (
                     IDINCIDENTE, 
                     DESCRIPCION,
                    IDTAREA,
                    IDCURSO, 
                     IDPROFESOR);                                                                                                                                                                                                                                                                                                        
    end;
    /
    
    
CREATE OR REPLACE PROCEDURE actualizar_incidentes(
    id_incidente IN INT,
    descripcion IN VARCHAR,
    id_tarea IN INT,
    id_curso IN INT,
    id_profesor IN INT
)
IS
BEGIN
    UPDATE INCIDENTES
    SET DESCRIPCION = descripcion,
        IDTAREA = id_tarea,
        IDCURSO = id_curso,
        IDPROFESOR = id_profesor
    WHERE IDINCIDENTE = id_incidente;
END;
/

-- PROFESOR 
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
    
CREATE OR REPLACE PROCEDURE actualizar_profesor( p_idProfesor IN NUMBER, p_nombreProf IN VARCHAR2, p_apellidosProf IN VARCHAR2, p_idSede IN NUMBER, p_contraseña IN VARCHAR2 ) 
IS 
BEGIN 
UPDATE profesor SET nombreProf = p_nombreProf, apellidosProf = p_apellidosProf, idSede = p_idSede, contraseña = p_contraseña 
WHERE idProfesor = p_idProfesor; 
COMMIT; 
DBMS_OUTPUT.PUT_LINE('Profesor actualizado exitosamente'); 
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error al actualizar profesor: ' || SQLERRM); 
END;
/  

CREATE OR REPLACE PROCEDURE eliminar_profesor( p_idProfesor IN NUMBER ) 
IS 
BEGIN 
DELETE FROM profesor
WHERE idProfesor = p_idProfesor; 
COMMIT; 
DBMS_OUTPUT.PUT_LINE('Profesor eliminado exitosamente'); 
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error al eliminar profesor: ' || SQLERRM); 
END;
/

-- SEDES 
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
    
CREATE OR REPLACE PROCEDURE actualizar_sede( p_id_sede IN NUMBER, p_nombre IN VARCHAR2, p_ubicacion IN VARCHAR2 ) 
IS 
BEGIN 
UPDATE sedes SET nombreSede = p_nombre, ubicacion = p_ubicacion 
WHERE idSede = p_id_sede; 
COMMIT; 
DBMS_OUTPUT.PUT_LINE('Sede actualizada exitosamente');
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error al actualizar sede: ' || SQLERRM); 
END;
/   

CREATE OR REPLACE PROCEDURE eliminar_sede( p_id_sede IN NUMBER ) 
IS 
begin
DELETE FROM sedes WHERE idSede = p_id_sede; 
COMMIT; 
DBMS_OUTPUT.PUT_LINE('Sede eliminada exitosamente'); 
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error al eliminar sede: ' || SQLERRM); 
END;
/

-- TAREAS 
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
     
CREATE OR REPLACE PROCEDURE ActualizarTareas
(
    IDTarea IN INT,
    Descripcion IN VARCHAR,
    FechaIngreso IN DATE,
    FechaRealizar IN DATE,
    Estado IN VARCHAR,
    IDCurso IN INT
)
IS
BEGIN
    UPDATE TAREAS
    SET
        DESCRIPCION = Descripcion,
        FECHAINGRESO = FechaIngreso,
        FECHAREALIZAR = FechaRealizar,
        ESTADO = Estado,
        IDCURSO = IDCurso
    WHERE IDTAREA = IDTarea;
END;
/
-- TAREAS_ASIGNADAS
CREATE OR REPLACE PROCEDURE Inserta_Tarea_asignadas
AS 
    p_descripcion varchar(70);
    p_fechaIngreso date;
    p_estado VARCHAR(15);
    p_fechaRealizar DATE;
    p_idCurso NUMBER;
begin
    insert into proyecto.tareas_asignadas(
    descripcion, fechaIngreso, estado, fechaRealizar, idCurso
    ) values (
                      
                     p_descripcion,
                    p_fechaIngreso,
                    p_estado, 
                     p_fechaRealizar,
                     p_idCurso);    
    end;
    /
    
    
CREATE OR REPLACE PROCEDURE actualizar_tarea_asignada( p_id_tarea_asig IN NUMBER, p_descripcion IN VARCHAR2, p_fechaIngreso IN DATE, p_estado IN VARCHAR2, p_fechaRealizar IN DATE, p_idCurso IN NUMBER ) 
IS 
BEGIN 
UPDATE tareas_asignadas SET descripcion = p_descripcion, fechaIngreso = p_fechaIngreso, estado = p_estado, fechaRealizar = p_fechaRealizar, idCurso = p_idCurso 
WHERE id_tarea_asig = p_id_tarea_asig; 
COMMIT; 
DBMS_OUTPUT.PUT_LINE('Tarea asignada actualizada exitosamente'); 
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error al actualizar tarea asignada: ' || SQLERRM); 
END;
/

CREATE OR REPLACE PROCEDURE eliminar_tarea_asignada( p_id_tarea_asig IN NUMBER ) 
IS 
BEGIN 
DELETE FROM tareas_asignadas 
WHERE id_tarea_asig = p_id_tarea_asig; 
COMMIT; 
DBMS_OUTPUT.PUT_LINE('Tarea asignada eliminada exitosamente'); 
EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error al eliminar tarea asignada: ' || SQLERRM); 
END;
/


   
/*************** Paquetes ***************/

/*************** Cursores ***************/

/* Fabricio */
DECLARE
    -- CURSOR
    G_tipoTarea Tareas.idTarea%type;
    CURSOR Tarea_Cursor IS
        SELECT idTarea
        FROM Tareas T
        WHERE NOT  EXISTS(SELECT idCurso FROM Cursos WHERE idCurso = T.idCurso);
BEGIN
    -- ABRE EL CURSOR
    OPEN Tarea_Cursor;
    LOOP
        -- RECORRE EL CURSOR
        FETCH Tarea_Cursor INTO G_tipoTarea;
        EXIT WHEN Tarea_Cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(G_tipoTarea);
    END LOOP;
    -- CIERRA EL CURSOR
    CLOSE Tarea_Cursor;
END;
/

/*************** Triggers ***************/

/* Andrés */
CREATE OR REPLACE TRIGGER no_tareas_fecha_pasada_trigger
BEFORE INSERT ON TAREAS
FOR EACH ROW
DECLARE
    fecha_actual DATE;
BEGIN
    fecha_actual := SYSDATE;
    IF:NEW.FECHAINGRESO < fecha_actual THEN
        RAISE_APPLICATION_ERROR(-20001, 'No se puede insertar una tarea con fecha de ingreso que ya pasó.');
    END IF;
END;
