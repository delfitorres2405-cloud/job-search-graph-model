:begin
CREATE CONSTRAINT UNIQUE_IMPORT_NAME FOR (node:`UNIQUE IMPORT LABEL`) REQUIRE (node.`UNIQUE IMPORT ID`) IS UNIQUE;
:commit

CALL db.awaitIndexes(300);

:begin
UNWIND [
  {_id:0, properties:{Habilidad:"Excel"}}, 
  {_id:1, properties:{Habilidad:"Java"}}, 
  {_id:2, properties:{Habilidad:"Testing"}}, 
  {_id:3, properties:{Habilidad:"Scrum"}}, 
  {_id:8, properties:{Habilidad:"Python"}}, 
  {_id:9, properties:{Habilidad:"SQL"}}, 
  {_id:10, properties:{Habilidad:"Power BI"}}, 
  {_id:11, properties:{Habilidad:"Google Analytics"}}, 
  {_id:28, properties:{Habilidad:"Docker"}}, 
  {_id:30, properties:{Habilidad:"Figma"}}, 
  {_id:31, properties:{Habilidad:"Diseño UX"}}, 
  {_id:32, properties:{Habilidad:"Adobe XD"}}
] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:HABILIDAD;

UNWIND [
  {_id:12, properties:{Ciudad:"Rosario", Pais:"Argentina"}}, 
  {_id:13, properties:{Ciudad:"Buenos Aires", Pais:"Argentina"}}, 
  {_id:14, properties:{Ciudad:"Cordoba", Pais:"Argentina"}}
] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:UBICACION;

UNWIND [
  {_id:15, properties:{Empresa:"PwC"}}, 
  {_id:16, properties:{Empresa:"Banco Santander"}}, 
  {_id:17, properties:{Empresa:"Globant"}}, 
  {_id:18, properties:{Empresa:"Mercado Libre"}}
] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:EMPRESA;

UNWIND [
  {_id:23, properties:{Anios_experiencia:2, Salario_mensual:2000000, Cod_oferta:100, Puesto:"Analista de Datos", Modalidad:"Hibrido", Horas_semanales:35}}, 
  {_id:24, properties:{Anios_experiencia:3, Salario_mensual:2200000, Cod_oferta:101, Puesto:"Desarrollador Backend", Modalidad:"Remoto", Horas_semanales:40}}, 
  {_id:25, properties:{Anios_experiencia:3, Salario_mensual:2200000, Cod_oferta:103, Puesto:"Desarrollador Frontend", Modalidad:"Presencial", Horas_semanales:42}}, 
  {_id:26, properties:{Anios_experiencia:1, Salario_mensual:1700000, Cod_oferta:102, Puesto:"Analista QA", Modalidad:"Remoto", Horas_semanales:40}}, 
  {_id:27, properties:{Anios_experiencia:3, Salario_mensual:2500000, Cod_oferta:110, Porcentaje_carrera_min:75, Puesto:"Desarrollador Backend", Modalidad:"Remoto", Horas_semanales:40, Estado:"Cerrada"}}, 
  {_id:29, properties:{Anios_experiencia:2, Salario_mensual:1900000, Cod_oferta:120, Puesto:"Diseñador UX/UI", Modalidad:"Hibrido", Horas_semanales:30}}
] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:OFERTA;

UNWIND [
  {_id:19, properties:{Nombre:"Juan", Edad:26, Mail:"juan.lopez@example.com", Apellido:"Lopez"}}, 
  {_id:20, properties:{Nombre:"Ana", Edad:28, Mail:"ana.garcia@example.com", Apellido:"Garcia"}}, 
  {_id:21, properties:{Nombre:"Lucia", Edad:24, Mail:"lucia.perez@example.com", Apellido:"Perez"}}, 
  {_id:22, properties:{Nombre:"Martin", Edad:27, Mail:"martin.gomez@example.com", Apellido:"Gomez"}}
] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:USUARIO;

UNWIND [
  {_id:4, properties:{Carrera:"Ingenieria en Ciencias de Datos"}}, 
  {_id:5, properties:{Carrera:"Licenciatura en Sistemas"}}, 
  {_id:6, properties:{Carrera:"Analista de Marketing"}}, 
  {_id:7, properties:{Carrera:"Tecnicatura en Programacion"}}
] AS row
CREATE (n:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row._id}) SET n += row.properties SET n:ESTUDIO;

:commit

:begin
UNWIND [
  {start: {_id:23}, end: {_id:8}, properties:{}}, 
  {start: {_id:23}, end: {_id:9}, properties:{}}, 
  {start: {_id:23}, end: {_id:10}, properties:{}}, 
  {start: {_id:23}, end: {_id:11}, properties:{}}, 
  {start: {_id:24}, end: {_id:1}, properties:{}}, 
  {start: {_id:24}, end: {_id:9}, properties:{}}, 
  {start: {_id:26}, end: {_id:2}, properties:{}}, 
  {start: {_id:26}, end: {_id:3}, properties:{}},
  {start: {_id:27}, end: {_id:1}, properties:{}}, 
  {start: {_id:27}, end: {_id:9}, properties:{}}, 
  {start: {_id:27}, end: {_id:28}, properties:{}}, 
  {start: {_id:29}, end: {_id:30}, properties:{}}, 
  {start: {_id:29}, end: {_id:31}, properties:{}}, 
  {start: {_id:29}, end: {_id:32}, properties:{}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:REQUIERE]->(end) SET r += row.properties;

UNWIND [
  {start: {_id:23}, end: {_id:12}, properties:{}}, 
  {start: {_id:24}, end: {_id:13}, properties:{}}, 
  {start: {_id:26}, end: {_id:14}, properties:{}}, 
  {start: {_id:29}, end: {_id:14}, properties:{}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:UBICADO_EN]->(end) SET r += row.properties;

UNWIND [
  {start: {_id:19}, end: {_id:12}, properties:{}}, 
  {start: {_id:20}, end: {_id:12}, properties:{}}, 
  {start: {_id:21}, end: {_id:13}, properties:{}}, 
  {start: {_id:22}, end: {_id:14}, properties:{}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:VIVE_EN]->(end) SET r += row.properties;

UNWIND [
  {start: {_id:19}, end: {_id:15}, properties:{Antiguedad_meses:6, Fecha_fin:date('2026-05-31'), Fecha_inicio:date('2025-01-01'), Antiguedad_anios:1, Puesto:"Ingeniero de Datos"}}, 
  {start: {_id:19}, end: {_id:18}, properties:{Antiguedad_meses:10, Fecha_fin:date('2025-12-31'), Fecha_inicio:date('2024-02-01'), Antiguedad_anios:1, Puesto:"Analista de Datos Jr"}}, 
  {start: {_id:20}, end: {_id:16}, properties:{Antiguedad_meses:3, Fecha_fin:date('2026-06-01'), Fecha_inicio:date('2023-03-01'), Antiguedad_anios:3, Puesto:"Analista de Marketing"}}, 
  {start: {_id:21}, end: {_id:17}, properties:{Antiguedad_meses:0, Fecha_fin:date('2026-01-01'), Fecha_inicio:date('2024-01-01'), Antiguedad_anios:2, Puesto:"Analista de Datos Jr"}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:TRABAJO_EN]->(end) SET r += row.properties;

UNWIND [
  {start: {_id:15}, end: {_id:26}, properties:{}}, 
  {start: {_id:15}, end: {_id:29}, properties:{}}, 
  {start: {_id:16}, end: {_id:23}, properties:{}}, 
  {start: {_id:17}, end: {_id:27}, properties:{}}, 
  {start: {_id:18}, end: {_id:24}, properties:{}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:BUSCA]->(end) SET r += row.properties;

UNWIND [
  {start: {_id:19}, end: {_id:4}, properties:{Universidad:"Universidad de Palermo", Porcentaje_aprobado:75}}, 
  {start: {_id:20}, end: {_id:6}, properties:{Universidad:"Universidad Nacional de Rosario", Porcentaje_aprobado:80}}, 
  {start: {_id:21}, end: {_id:5}, properties:{Universidad:"Universidad de Buenos Aires", Porcentaje_aprobado:92}}, 
  {start: {_id:22}, end: {_id:7}, properties:{Universidad:"Universidad de Cordoba", Porcentaje_aprobado:93}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:ESTUDIA]->(end) SET r += row.properties;

UNWIND [
  {start: {_id:19}, end: {_id:8}, properties:{}}, 
  {start: {_id:19}, end: {_id:9}, properties:{}}, 
  {start: {_id:20}, end: {_id:0}, properties:{}}, 
  {start: {_id:20}, end: {_id:10}, properties:{}}, 
  {start: {_id:21}, end: {_id:8}, properties:{}}, 
  {start: {_id:21}, end: {_id:9}, properties:{}}, 
  {start: {_id:21}, end: {_id:11}, properties:{}}, 
  {start: {_id:22}, end: {_id:1}, properties:{}}, 
  {start: {_id:22}, end: {_id:2}, properties:{}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:POSEE]->(end) SET r += row.properties;

UNWIND [
  {start: {_id:19}, end: {_id:23}, properties:{Fecha_postulacion:date('2026-06-20')}}, 
  {start: {_id:21}, end: {_id:23}, properties:{Fecha_postulacion:date('2026-06-23')}}, 
  {start: {_id:22}, end: {_id:26}, properties:{Fecha_postulacion:date('2026-06-19')}}, 
  {start: {_id:22}, end: {_id:27}, properties:{Fecha_postulacion:date('2026-06-21')}}
] AS row
MATCH (start:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.start._id})
MATCH (end:`UNIQUE IMPORT LABEL`{`UNIQUE IMPORT ID`: row.end._id})
CREATE (start)-[r:POSTULO_A]->(end) SET r += row.properties;

:commit

:begin
MATCH (n:`UNIQUE IMPORT LABEL`) WITH n LIMIT 20000 REMOVE n:`UNIQUE IMPORT LABEL` REMOVE n.`UNIQUE IMPORT ID`;
:commit

:begin
DROP CONSTRAINT UNIQUE_IMPORT_NAME;
:commit