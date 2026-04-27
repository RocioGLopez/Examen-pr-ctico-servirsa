-- =========================================
-- 1. CREAR BASE DE DATOS
-- =========================================
create database asistencia_Empleados;
use	asistencia_Empleados;

-- =========================================
-- 2. CREACIÓN DE TABLAS
-- =========================================

#tabla empleados
create table empleados (
	id_empleado int primary key auto_increment,
    nombre varchar(50),
    apellido varchar(50),
    dpi varchar(20),
    puesto varchar(100),
    fecha_ingreso date
    );

#tabla de centros de trabajo 
create	table centro_trabajo (
	id_centro int primary key auto_increment,
    nombre varchar (100)
    );
    
#tabla de planificacion
create table planificacion(
	id_plani int primary key auto_increment,
	id_empleado int,
    id_centro int,
    fecha date,
    horas_planificadas int,

    foreign key (id_empleado) references empleados(id_empleado),
    foreign key (id_centro) references centro_trabajo(id_centro)
);

#tabla asistencias
create table asistencia (
    id_asistencia int primary key auto_increment,
    id_empleado int,
    id_centro int,
    fecha date,
    horas_trabajadas int,

    foreign key (id_empleado) references empleados(id_empleado),
    foreign key (id_centro) references centro_trabajo(id_centro)
);

-- =========================================
-- 3. DATOS DE TABLAS
-- =========================================
#Empleados
insert into empleados (nombre, apellido, dpi, puesto, fecha_ingreso)
 value
('Juan', 'Garcia', '1234567890101', 'Operador', '2022-01-10'),
('Carlos', 'Blanco', '9876543210101', 'Supervisor', '2021-03-15'),
('Ruben', 'Gonzales', '3218027850101', 'Limpieza', '2020-02-01'),
('Karin', 'Dovinish', '3019026190101', 'Operador', '2021-10-02');
select * from empleados;

#Centros
insert into  centro_trabajo (nombre) 
value
('Centro Norte'),
('Centro Sur'),
('Amatitlan'),
('Coatepeque');

select * from centro_trabajo;

# Planificación
insert into planificacion (id_empleado, id_centro, fecha, horas_planificadas) 
value
(1, 1, '2024-05-01', 8),
(3, 2, '2024-05-02', 8),
(2, 3, '2024-05-01', 8);

insert into planificacion (id_empleado, id_centro, fecha, horas_planificadas) 
value
(1, 1, '2024-05-02', 8),
(1, 1, '2024-05-03', 8),
(3, 2, '2024-05-03', 8),
(2, 3, '2024-05-02', 8);


select * from planificacion;


# Asistencia
insert into asistencia (id_empleado, id_centro, fecha, horas_trabajadas) 
value
(1, 1, '2024-05-01', 9),  -- llegó e hizo extras
(3, 2, '2024-05-02', 8),  -- llegó normal
-- (4, 2, '2024-05-02') -- inasistencia
(2, 3, '2024-05-01', 7);  -- llegó pero trabajó menos

insert into asistencia (id_empleado, id_centro, fecha, horas_trabajadas) 
value
(1, 1, '2024-05-02', 8),
(1, 1, '2024-05-03', 10), -- más horas extra
(3, 2, '2024-05-03', 8),
(2, 3, '2024-05-02', 8);


select * from asistencia;

-- =========================================
-- 4. CONSULTAS 
-- =========================================


-- 1. Centro con más horas trabajadas
select c.nombre, SUM(a.horas_trabajadas) as total_horas
from asistencia a
join centro_trabajo c on a.id_centro = c.id_centro
group by c.nombre
order by total_horas desc
limit 1;


-- 2. Empleado con más inasistencias por centro
select c.nombre as centro,
    concat(e.nombre, ' ', e.apellido) as empleado,
    count(*) as inasistencias
from planificacion p
join empleados e on p.id_empleado = e.id_empleado
join centro_trabajo c on p.id_centro = c.id_centro
left join asistencia a 
    on p.id_empleado = a.id_empleado 
    and p.fecha = a.fecha
where a.id_asistencia is null
group by c.nombre, empleado
order by inasistencias desc;

-- 3. Horas extras por empleado
select 
    concat(e.nombre, ' ', e.apellido) as empleado,
    sum(a.horas_trabajadas) - SUM(p.horas_planificadas) as horas_extras
from empleados e
join planificacion p on e.id_empleado = p.id_empleado
join asistencia a 
    on p.id_empleado = a.id_empleado 
    and p.fecha = a.fecha
group by empleado;


#prueba para vverificar empleado y asistencia 
SELECT 
    p.id_empleado,
    p.fecha,
    a.horas_trabajadas
FROM planificacion p
LEFT JOIN asistencia a 
    ON p.id_empleado = a.id_empleado 
    AND p.fecha = a.fecha;


