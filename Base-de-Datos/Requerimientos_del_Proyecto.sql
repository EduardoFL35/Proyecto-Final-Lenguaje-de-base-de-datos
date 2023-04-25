/*************** Vistas ****************/
--- SEDES
CREATE VIEW V_SEDES AS
SELECT * FROM SEDES;

CREATE VIEW V_NOMBRE_SEDE AS
SELECT nombreSede FROM SEDES;

CREATE VIEW v_ubicacionesSedes AS
SELECT ubicacion FROM SEDES;

-- PROFESOR
CREATE VIEW V_PROFESOR AS
SELECT * FROM PROFESOR;

CREATE VIEW V_NOMBRE_PROFESOR AS
SELECT nombreProf FROM PROFESOR;

CREATE VIEW V_APELLIDOS_PROFESORES AS
SELECT apellidosProf FROM PROFESOR;

--- CURSOS 
create or replace view Mostrar_nombre_curso AS
select nombrecurso from CURSOS;

CREATE VIEW v_cursos AS
SELECT * FROM Cursos;

/* Cursos por sede */
CREATE VIEW v_cursosPorSede AS
SELECT Sedes.nombreSede, Cursos.nombreCurso
FROM Sedes
INNER JOIN Cursos ON Sedes.idSede = Cursos.idSede;

--TAREAS
CREATE VIEW v_tareas AS
SELECT * FROM Tareas;

/*Descripción y estado de todas las tareas*/
CREATE VIEW v_descripcionEstadoTareas AS
SELECT descripcion, estado FROM Tareas;

/*Tareas por curso*/
CREATE VIEW v_tareasPorCurso AS
SELECT Cursos.nombreCurso, Tareas.descripcion, Tareas.fechaIngreso, Tareas.fechaRealizar
FROM Cursos
INNER JOIN Tareas ON Cursos.idCurso = Tareas.idCurso;

--- INCIDENTES
create or replace view Mostrar_incidente AS
select descripcion from INCIDENTES;

CREATE VIEW v_incidentes AS
SELECT * FROM INCIDENTES;

/* Incidentes por profesor */
CREATE VIEW v_incidentesPorProfesor AS
SELECT Profesor.nombreProf, Incidentes.descripcion
FROM Profesor
INNER JOIN Incidentes ON Profesor.idProfesor = Incidentes.idProfesor;

--TAREAS ASIGNADAS
CREATE VIEW v_tareasAsignadas AS
SELECT * FROM tareas_asignadas;

/*Descripción y estado de todas las tareas asignadas*/
CREATE VIEW v_descripcionEstadoTareasAsignadas AS
SELECT descripcion, estado FROM tareas_asignadas;

CREATE VIEW v_tareasAsignadasPorCurso AS
SELECT Cursos.nombreCurso, tareas_asignadas.descripcion, tareas_asignadas.fechaIngreso, tareas_asignadas.fechaRealizar
FROM Cursos
INNER JOIN tareas_asignadas ON Cursos.idCurso = tareas_asignadas.idCurso;

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

/* Número de cursos asignados por profesor */
CREATE FUNCTION num_cursos_asignados_profesor(id_profesor IN INT) RETURN INTEGER
IS
    num_cursos INT;
BEGIN
    SELECT COUNT(*) INTO num_cursos FROM Cursos 
    WHERE idProfesor = id_profesor;
RETURN num_cursos;
END;
/

/* Número de tareas pendientes de un curso */
CREATE FUNCTION num_tareas_pendientes_curso(id_curso IN INT) RETURN INTEGER
IS
    num_tareas INT;
BEGIN
    SELECT COUNT(*) INTO num_tareas FROM Tareas
    WHERE idCurso = id_curso AND estado = 'pendiente';
RETURN num_tareas;
END;
/

/* Promedio de incidentes por tarea de un curso */
CREATE FUNCTION promedio_incidentes_tarea_curso(id_curso IN INT) RETURN NUMBER
IS
    promedio NUMBER;
BEGIN
    SELECT AVG(num_incidentes) INTO promedio FROM (
    SELECT COUNT(*) AS num_incidentes FROM Incidentes 
    WHERE idCurso = id_curso GROUP BY idTarea);
RETURN promedio;
END;
/

/* Devuelve el número de tareas asignadas a un curso con una fecha en específico */ 
CREATE FUNCTION num_tareas_asignadas_curso_fecha(id_curso IN INT, fecha_asignacion IN DATE) RETURN INTEGER
IS
    num_tareas INT;
BEGIN
    SELECT COUNT(*) INTO num_tareas FROM tareas_asignadas 
    WHERE idCurso = id_curso AND fechaIngreso = fecha_asignacion;
RETURN num_tareas;
END;
/


/*************** Procedimientos almacenados ***************/ 
-- CURSOS 
/*-*-*-*-*-*-**/
CREATE OR REPLACE PROCEDURE Inserta_Cursos(cod_Curso IN idCurso%TYPE,
                                           nombre IN nombreCurso%TYPE,
                                           idSede IN idSede%TYPE, 
                                           idProfesor IN idProfesor%TYPE)
AS 
begin
    insert into Cursos(
    idCurso, 
    nombreCurso,
    idSede, 
    idProfesor
    ) values (
                cod_Curso, 
                nombre,
                idSede, 
                idProfesor);
end;
/

CREATE OR REPLACE PROCEDURE consultar_cursos( p_idCurso IN Cursos.idCurso%TYPE,
                                            p_nombre OUT Cursos.nombreCurso%TYPE,
                                            p_idSede OUT Cursos.idSede%TYPE,
                                            p_idProfesor OUT Cursos.idProfesor%TYPE)
IS
BEGIN
    SELECT nombreCurso, idSede, idProfesor
    INTO p_nombre, p_idSede, p_idProfesor
    FROM Cursos
    WHERE idCurso = p_idCurso;
END consultar_cursos;
  
/*-*-*-*-*-*-**/    
CREATE or REPLACE PROCEDURE actualizar_cursos(act_id_curso in idCurso%TYPE,
                                              nombre_curso IN nombreCurso%TYPE,
                                              id_sede IN idSede%TYPE,
                                              id_profesor IN idProfesor%TYPE) 
AS
BEGIN
    UPDATE Cursos SET nombreCurso = nombre_curso, idSede = id_sede, idProfesor = id_profesor 
    WHERE idCurso = act_id_curso;
END;
/    

CREATE PROCEDURE eliminar_curso (p_idCurso IN Cursos.idCurso%TYPE) 
AS
BEGIN
DELETE FROM Cursos
WHERE idCurso = p_idCurso;
COMMIT;
END;

-- INCIDENTES 
/*-*-*-*-*-*-**/
CREATE OR REPLACE PROCEDURE Inserta_Incidente(ID_INCIDENTE IN idIncidente%TYPE,
                                              DESCRIPCION IN descripcion%TYPE,
                                              ID_TAREA IN idTarea%TYPE,
                                              ID_CURSO IN idCurso%TYPE,
                                              ID_PROFESOR IN idProfesor%TYPE)
AS
begin
    insert into Incidentes(
    idIncidente, 
    descripcion,
    idTarea,
    idCurso, 
    idProfesor
    ) values (
                     ID_INCIDENTE, 
                     DESCRIPCION,
                     ID_TAREA,
                     ID_CURSO, 
                     ID_PROFESOR);                                                                                                                                                                                                                                                                                                        
    end;
    /

CREATE OR REPLACE PROCEDURE consultar_incidente (id_Incidente IN idIncidente%TYPE,
                                                 descripcion OUT descripcion%TYPE,
                                                 id_Tarea OUT idTarea%TYPE,
                                                 id_Curso OUT idCurso%TYPE,
                                                 id_Profesor OUT idProfesor%TYPE) 
AS
BEGIN
    SELECT descripcion, idTarea, idCurso, idProfesor
    INTO descripcion, id_Tarea, id_Curso, id_Profesor
    FROM Incidentes
    WHERE idIncidente = id_Incidente;
END;    
    
CREATE OR REPLACE PROCEDURE actualizar_incidentes(
    id_incidente IN INT,
    descripcion IN VARCHAR,
    id_tarea IN INT,
    id_curso IN INT,
    id_profesor IN INT
)
AS
BEGIN
    UPDATE INCIDENTES
    SET DESCRIPCION = descripcion,
        IDTAREA = id_tarea,
        IDCURSO = id_curso,
        IDPROFESOR = id_profesor
    WHERE IDINCIDENTE = id_incidente;
END;
/

CREATE OR REPLACE PROCEDURE borrar_incidente (id_Incidente IN INT) 
AS
BEGIN
    DELETE FROM Incidentes
    WHERE idIncidente = id_Incidente;
END;

-- PROFESOR 
CREATE OR REPLACE PROCEDURE Inserta_Profe
AS 
    cedula int;
    password varchar (8);
    nombre varchar(20);
    apellidos varchar(20);
    idSede int;
begin
    insert into Profesor(
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
    
CREATE OR REPLACE PROCEDURE consultar_profesor( p_id_profesor IN Profesor.idProfesor%TYPE,
                                                p_contraseña OUT Profesor.contraseña%TYPE,
                                                p_nombre_prof OUT Profesor.nombreProf%TYPE,
                                                p_apellidos_prof OUT Profesor.apellidosProf%TYPE,
                                                p_id_sede OUT Profesor.idSede%TYPE) 
AS
BEGIN
  SELECT contraseña, nombreProf, apellidosProf, idSede
  INTO p_contraseña, p_nombre_prof, p_apellidos_prof, p_id_sede
  FROM Profesor
  WHERE idProfesor = p_id_profesor;
END consultar_profesor;    

/*-*-*-*-*-*-**/    
CREATE OR REPLACE PROCEDURE actualizar_profesor( p_idProfesor IN NUMBER, p_nombreProf IN VARCHAR2, p_apellidosProf IN VARCHAR2, p_idSede IN NUMBER, p_contraseña IN VARCHAR2 ) 
IS 
BEGIN 
UPDATE profesor SET nombreProf = p_nombreProf, apellidosProf = p_apellidosProf, idSede = p_idSede, contraseña = p_contraseña 
WHERE idProfesor = p_idProfesor; 
COMMIT; 
END;
/  

/*-*-*-*-*-*-**/
CREATE OR REPLACE PROCEDURE eliminar_profesor( p_idProfesor IN NUMBER ) 
IS 
BEGIN 
DELETE FROM profesor
WHERE idProfesor = p_idProfesor; 
COMMIT; 
END;
/

-- SEDES 
/*-*-*-*-*-*-**/
CREATE OR REPLACE PROCEDURE Insertar_Sede(
  id_sede IN INT,
  nombre_sede IN VARCHAR2,
  ubicacion IN VARCHAR2
) AS
begin
    insert into proyecto.sedes(
    idSede, 
    nombreSede,
    ubicacion
    ) values (
                        id, 
                        nombre, 
                        ubicacionSede);
    COMMIT;
    end;
    /
    
CREATE OR REPLACE PROCEDURE consultar_sede(id_sede IN INT,nombre_sede OUT VARCHAR2,ubicacion OUT VARCHAR2) 
AS
BEGIN
  SELECT nombreSede, ubicacion
  INTO nombre_sede, ubicacion
  FROM Sedes
  WHERE idSede = id_sede;
END consultar_sede;

/*-*-*-*-*-*-**/  
CREATE OR REPLACE PROCEDURE actualizar_sede( p_id_sede IN NUMBER, p_nombre IN VARCHAR2, p_ubicacion IN VARCHAR2 ) 
IS 
BEGIN 
UPDATE sedes SET nombreSede = p_nombre, ubicacion = p_ubicacion 
WHERE idSede = p_id_sede; 
COMMIT; 
END;
/  

/*-*-*-*-*-*-**/  
CREATE OR REPLACE PROCEDURE eliminar_sede( p_id_sede IN NUMBER ) 
IS 
begin
DELETE FROM sedes WHERE idSede = p_id_sede; 
COMMIT; 
END;
/

-- TAREAS 
/*-*-*-*-*-*-**/  
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
COMMIT;
    end;
    /

CREATE OR REPLACE PROCEDURE consultar_tarea(  id_tarea IN Tareas.idTarea%TYPE,
                                            descripcion_tarea OUT Tareas.descripcion%TYPE,
                                            fecha_ingreso_tarea OUT Tareas.fechaIngreso%TYPE,
                                            fecha_realizar_tarea OUT Tareas.fechaRealizar%TYPE,
                                            estado_tarea OUT Tareas.estado%TYPE,
                                            id_curso OUT Tareas.idCurso%TYPE)
AS
BEGIN
    SELECT descripcion, fechaIngreso, fechaRealizar, estado, idCurso
    INTO descripcion_tarea, fecha_ingreso_tarea, fecha_realizar_tarea, estado_tarea, id_curso
    FROM Tareas
    WHERE idTarea = id_tarea;
END;
/

/*-*-*-*-*-*-**/       
CREATE OR REPLACE PROCEDURE ActualizarTareas
(
    ID_Tarea IN INT,
    Descripcion IN VARCHAR,
    Fecha_Ingreso IN DATE,
    Fecha_Realizar IN DATE,
    Estado IN VARCHAR,
    ID_Curso IN INT
)
IS
BEGIN
    UPDATE TAREAS
    SET
        DESCRIPCION = Descripcion,
        FECHAINGRESO = Fecha_Ingreso,
        FECHAREALIZAR = Fecha_Realizar,
        ESTADO = Estado,
        IDCURSO = ID_Curso
    WHERE IDTAREA = ID_Tarea;
    COMMIT;
END;
/

CREATE OR REPLACE PROCEDURE eliminar_tarea(
    id_tarea IN Tareas.idTarea%TYPE
)
AS
BEGIN
    DELETE FROM Tareas
    WHERE idTarea = id_tarea;
    COMMIT;
END;
/
-- TAREAS_ASIGNADAS
/*-*-*-*-*-*-**/ 
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
    COMMIT;
    end;
    /
    
CREATE OR REPLACE PROCEDURE consultar_tareas_asignadas(p_id_tarea_asig IN tareas_asignadas.id_tarea_asig%TYPE,
                                                  p_descripcion OUT tareas_asignadas.descripcion%TYPE,
                                                  p_fecha_ingreso OUT tareas_asignadas.fechaIngreso%TYPE,
                                                  p_estado OUT tareas_asignadas.estado%TYPE,
                                                  p_fecha_realizar OUT tareas_asignadas.fechaRealizar%TYPE,
                                                  p_id_curso OUT tareas_asignadas.idCurso%TYPE) 
AS
BEGIN
    SELECT descripcion, fechaIngreso, estado, fechaRealizar, idCurso
    INTO p_descripcion, p_fecha_ingreso, p_estado, p_fecha_realizar, p_id_curso
    FROM tareas_asignadas
    WHERE id_tarea_asig = p_id_tarea_asig;
END;
/ 

/*-*-*-*-*-*-**/     
CREATE OR REPLACE PROCEDURE actualizar_tarea_asignada( p_id_tarea_asig IN NUMBER, p_descripcion IN VARCHAR2, p_fechaIngreso IN DATE, p_estado IN VARCHAR2, p_fechaRealizar IN DATE, p_idCurso IN NUMBER ) 
IS 
BEGIN 
UPDATE tareas_asignadas SET descripcion = p_descripcion, fechaIngreso = p_fechaIngreso, estado = p_estado, fechaRealizar = p_fechaRealizar, idCurso = p_idCurso 
WHERE id_tarea_asig = p_id_tarea_asig; 
COMMIT; 
END;
/

/*-*-*-*-*-*-**/ 
CREATE OR REPLACE PROCEDURE eliminar_tarea_asignada( p_id_tarea_asig IN NUMBER ) 
IS 
BEGIN 
DELETE FROM tareas_asignadas 
WHERE id_tarea_asig = p_id_tarea_asig; 
COMMIT; 
END;
/


   
/*************** Paquetes ***************/
CREATE OR REPLACE PACKAGE PKG_Cursos AS
    PROCEDURE Inserta_Cursos(cod_Curso IN idCurso%TYPE,
                             nombre IN nombreCurso%TYPE,
                             idSede IN idSede%TYPE, 
                             idProfesor IN idProfesor%TYPE);
    PROCEDURE consultar_cursos( p_idCurso IN Cursos.idCurso%TYPE,
                                p_nombre OUT Cursos.nombreCurso%TYPE,
                                p_idSede OUT Cursos.idSede%TYPE,
                                p_idProfesor OUT Cursos.idProfesor%TYPE);
    PROCEDURE actualizar_cursos(act_id_curso IN idCurso%TYPE,
                                nombre_curso IN nombreCurso%TYPE,
                                id_sede IN idSede%TYPE,
                                id_profesor IN idProfesor%TYPE);
    PROCEDURE eliminar_curso (p_idCurso IN Cursos.idCurso%TYPE);
END PKG_Cursos;
/

CREATE OR REPLACE PACKAGE BODY PKG_Cursos AS
    PROCEDURE Inserta_Cursos(cod_Curso IN idCurso%TYPE,
                             nombre IN nombreCurso%TYPE,
                             idSede IN idSede%TYPE, 
                             idProfesor IN idProfesor%TYPE)
    AS 
    BEGIN
        INSERT INTO Cursos(idCurso, nombreCurso, idSede, idProfesor)
        VALUES (cod_Curso, nombre, idSede, idProfesor);
    END Inserta_Cursos;
    
    PROCEDURE consultar_cursos( p_idCurso IN Cursos.idCurso%TYPE,
                                p_nombre OUT Cursos.nombreCurso%TYPE,
                                p_idSede OUT Cursos.idSede%TYPE,
                                p_idProfesor OUT Cursos.idProfesor%TYPE)
    IS
    BEGIN
        SELECT nombreCurso, idSede, idProfesor
        INTO p_nombre, p_idSede, p_idProfesor
        FROM Cursos
        WHERE idCurso = p_idCurso;
    END consultar_cursos;
  
    PROCEDURE actualizar_cursos(act_id_curso IN idCurso%TYPE,
                                nombre_curso IN nombreCurso%TYPE,
                                id_sede IN idSede%TYPE,
                                id_profesor IN idProfesor%TYPE) 
    AS
    BEGIN
        UPDATE Cursos SET nombreCurso = nombre_curso, idSede = id_sede, idProfesor = id_profesor 
        WHERE idCurso = act_id_curso;
    END actualizar_cursos;
    
    PROCEDURE eliminar_curso (p_idCurso IN Cursos.idCurso%TYPE) 
    AS
    BEGIN
        DELETE FROM Cursos
        WHERE idCurso = p_idCurso;
        COMMIT;
    END eliminar_curso;
END PKG_Cursos;
/
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
    END if;
END;
/

CREATE OR REPLACE TRIGGER insertar_tarea
BEFORE INSERT ON Tareas
FOR EACH ROW
BEGIN
  SELECT SYSDATE INTO :new.fechaIngreso FROM dual;
END;
/

/* Este trigger se ejecutará antes de cada inserción en la tabla Tareas, 
y asignará automáticamente la fecha de ingreso de la tarea como la fecha actual del sistema. */
CREATE OR REPLACE TRIGGER insertar_tarea
BEFORE INSERT ON Tareas
FOR EACH ROW
BEGIN
  SELECT SYSDATE INTO :new.fechaIngreso FROM dual;
END;
/

CREATE OR REPLACE TRIGGER actualizar_estado_tarea
AFTER INSERT ON Incidentes
FOR EACH ROW
BEGIN
  UPDATE Tareas
  SET estado = 'pendiente'
  WHERE idTarea = :new.idTarea;
END;
