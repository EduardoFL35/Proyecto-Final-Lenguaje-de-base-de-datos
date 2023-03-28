/* Esto se ingresa en el usuario SYS para crear el usuario y su tablespace */

CREATE TABLESPACE TBL_PROY 
DATAFILE 'C:\PROY_LENGUAJES\tbl_proy.dbf' SIZE 100M 
DEFAULT STORAGE (INITIAL 1M NEXT 1M PCTINCREASE 0);

alter session set "_ORACLE_SCRIPT"=true;

CREATE USER PROYECTO IDENTIFIED BY 12345 
DEFAULT TABLESPACE TBL_PROY 
TEMPORARY TABLESPACE TEMP;

GRANT CONNECT,RESOURCE TO PROYECTO;

ALTER USER PROYECTO QUOTA UNLIMITED ON TBL_PROY;
GRANT DBA TO PROYECTO;

/* Se crea la conexión con el usuario PROYECTO para crear las tablas */

/* Creación de las tablas */

create table Sedes(
idSede int primary key not null,
nombreSede varchar(20) not null,
ubicacion varchar(20) not null); 

/* El login del Profe */
create table Profesor(
idProfesor int primary key not null,
contraseña varchar(8) not null,
nombreProf varchar(20) not null,
apellidosProf varchar(40) not null,
idSede int not null,
foreign key(idSede) references Sedes(idSede));
 
/* Cursos asignados al profesor */
create table Cursos(
idCurso int primary key not null,
nombreCurso varchar(40) not null,
idSede int not null,
idProfesor int not null,
foreign key(idSede) references Sedes(idSede),
foreign key(idProfesor) references Profesor(idProfesor)); 

/* Listado de las tareas */
create table Tareas(
idTarea int primary key not null,
descripcion varchar(70) not null,
fechaIngreso date not null,/* fecha de cuando se asigna la tarea */
fechaRealizar date not null,
estado varchar (15),
idCurso int not null,
foreign key(idCurso) references Cursos(idCurso)
);
 
/* Tabla de datos situacional por si el profesor quiere modificar las fechas de las asignaciones */
create table Incidentes(
idIncidente int primary key not null,
descripcion varchar(70) not null,
idTarea int not null,
idCurso int not null,
idProfesor int not null,
foreign key(idTarea) references Tareas(idTarea),
foreign key(idCurso) references Cursos(idCurso),
foreign key(idProfesor) references Profesor(idProfesor));


/* Listado de las tareas agendadas */
create table tareas_asignadas(
id_tarea_asig int primary key not null,
descripcion varchar(70) not null,
fechaIngreso date not null,/* fecha de cuando la asigna */
estado varchar (15),
fechaRealizar date not null,
idCurso int not null,
foreign key(idCurso) references Cursos(idCurso));