# job-search-graph-model
Modelo de grafo en Neo4j de una plataforma de búsqueda de empleo: conecta usuarios, ofertas laborales, empresas, habilidades, ubicaciones y estudios mediante relaciones en Cypher.

✨ Este proyecto fue desarrollado para un trabajo práctico de una materia de la carrera **Ingeniería en Ciencia de Datos**.

## Caso de uso

El caso propuesto es una **plataforma de búsqueda de empleo**, donde conviven usuarios, empresas que publican ofertas laborales, y un conjunto de atributos que los conectan: habilidades técnicas, formación académica y ubicaciones geográficas. 

## Paradigma elegido: base de datos orientada a grafos, Neo4j

La base de datos elegida para almacenar los datos provenientes de la plataforma no consiste únicamente en almacenar los datos aislados de las entidades mencionadas, sino en analizar las múltiples relaciones entre ellas. Lo que define a este dominio es que **el valor de la información está en las conexiones, no solo en los datos aislados**.
Mediante Cypher, podremos hacer consultas como:
1. ¿Qué empresas tienen publicadas ofertas para el puesto de 'Analista de Datos' en la ciudad de Rosario?
2. ¿Cuáles son las ofertas laborales publicadas por la empresa 'Mercado Libre' con modalidad remota?
3. ¿Qué habilidades tiene el usuario 'Juan Lopez' que coincidan con las solicitadas por la oferta de trabajo de 'Desarrollador Backend' publicada por 'Globant'?

### Por qué un grafo y no un modelo relacional

1. En un modelo relacional, una relación (por ejemplo, qué habilidades requiere una oferta) se resuelve con tablas intermedias y JOINs. Cada consulta que atraviesa varios niveles de relación (usuario → habilidad → oferta → empresa) implica múltiples JOINs encadenados, lo que da lugar a consultas de mayor complejidad. En un grafo, cada relación es un puntero físico entre nodos: independientemente de cuántos "saltos" se hagan, la consulta con Cypher resulta más sencilla.

2. No todos los usuarios cargan los mismos datos: algunos completan su correo electrónico, otros no; algunos tienen estudios cargados, otros no. En un modelo relacional esto obliga a definir columnas nullable para cada campo opcional, generando filas con muchos campos vacíos, o modificaciones del esquema para incorporar esos campos opcionales. En Neo4j, en cambio, cada nodo guarda únicamente las propiedades que efectivamente tiene, sin necesidad de forzar un esquema rígido y uniforme para todos los registros.

3. El dominio es naturalmente un grafo, no una jerarquía de tablas. Usuarios, ofertas, empresas, habilidades, ubicaciones y estudios se conectan entre sí en múltiples direcciones (un usuario vive en una ubicación, pero una oferta también está ubicada ahí; un usuario posee una habilidad, pero una oferta también la requiere). Modelarlo como grafo respeta la forma real de los datos en vez de forzarlos a una estructura tabular.

## Modelo de datos

### Nodos (etiquetas)

- `USUARIO`
- `EMPRESA`
- `OFERTA`
- `HABILIDAD`
- `ESTUDIO`
- `UBICACION`

### Relaciones

- `(USUARIO)-[:POSEE]->(HABILIDAD)`
- `(USUARIO)-[:ESTUDIA]->(ESTUDIO)`
- `(USUARIO)-[:VIVE_EN]->(UBICACION)`
- `(USUARIO)-[:TRABAJO_EN]->(EMPRESA)`
- `(USUARIO)-[:POSTULO_A]->(OFERTA)`
- `(OFERTA)-[:REQUIERE]->(HABILIDAD)`
- `(OFERTA)-[:UBICADO_EN]->(UBICACION)`
- `(EMPRESA)-[:BUSCA]->(OFERTA)`

## Scripting

El archivo [`grafo_empleos.cypher`](./grafo_empleos.cypher) contiene el script completo, ejecutable en Neo4j Browser o `cypher-shell`.

Los ejemplos de creación de nodos y relaciones que se muestran más adelante representan la forma en que se modeló manualmente el grafo utilizando Cypher. El archivo `grafo_empleos.cypher` incluido en el repositorio corresponde a la exportación automática realizada por Neo4j, por lo que emplea instrucciones `UNWIND` y metadatos temporales generados por la herramienta de exportación para reconstruir el mismo modelo de datos.

## Configuración del ambiente
1. Constraint temporal de unicidad, para poder enlazar relaciones sin ambigüedad durante la carga:
   
```cypher
CREATE CONSTRAINT UNIQUE_IMPORT_NAME
FOR (node:`UNIQUE IMPORT LABEL`)
REQUIRE (node.`UNIQUE IMPORT ID`) IS UNIQUE;
```

2. Se espera la disponibilidad del índice generado (CALL db.awaitIndexes(300)), y cada etapa de carga se ejecuta en transacciones independientes (:begin / :commit).
3. Al finalizar la carga, se eliminan los metadatos temporales (UNIQUE IMPORT LABEL / UNIQUE IMPORT ID) y se elimina la constraint, dejando el grafo únicamente con el modelo de datos final.

## Creación de nodos y relaciones 

Aclaración: tanto para crear como para buscar relaciones que involucren a un usuario (como puede ser otro nodo de otra entidad), en los ejemplos para buscarlo se utiliza su nombre por motivos de legibilidad, dado que en este conjunto de datos de prueba no existen duplicados. En un sistema real, sin embargo, se recomienda filtrar por un identificador único (como ID o DNI) para evitar ambigüedades.

### Ejemplos de creación de nodos:

**USUARIO:**

```cypher
CREATE (:USUARIO {Nombre: 'Ana', Apellido:'Garcia', Edad:28, Mail:'ana.garcia@example.com'})
```

**EMPRESA:**
```cypher
CREATE (:EMPRESA {Empresa: 'Banco Santander'})
CREATE (:EMPRESA {Empresa: 'Montagne'})
```

**HABILIDAD:**

```cypher
CREATE (:HABILIDAD {Habilidad: 'Power BI'})
CREATE (:HABILIDAD {Habilidad: 'Excel'})
CREATE (:HABILIDAD {Habilidad: 'A/B testing'})
CREATE (:HABILIDAD {Habilidad: 'Full-funnel marketing'})
```

**ESTUDIO:**

```cypher
CREATE (:ESTUDIO {Carrera: 'Analista de Marketing'})
```

**UBICACION:**

```cypher
CREATE (:UBICACION {Ciudad: 'Rosario', Pais: 'Argentina'})
CREATE (:UBICACION {Ciudad: 'Bariloche', Pais: 'Argentina'})
```

**OFERTA:**

```cypher
CREATE (:OFERTA {Puesto: 'Growth Marketing Manager', Cod_oferta: 130, Horas_semanales: 35, Modalidad: 'Remoto', Anios_experiencia: 2, Salario_mensual: 2000000})
```

### Ejemplos de creación de relaciones:

**USUARIO-HABILIDAD:**

```cypher
MATCH (u:USUARIO {Nombre: 'Ana'}) 
MATCH (h:HABILIDAD {Habilidad: 'Power BI'}) 
MATCH (b:HABILIDAD {Habilidad: 'Excel'})
CREATE (u)-[:POSEE]->(h), (u)-[:POSEE]->(b)
```

**USUARIO-ESTUDIO:**

```cypher
MATCH (u:USUARIO {Nombre: 'Ana'}) 
MATCH (e:ESTUDIO {Carrera: 'Analista de Marketing'})
CREATE (u)-[:ESTUDIA{Universidad:'Universidad Nacional de Rosario', Porcentaje_aprobado:80}]->(e)
```

**USUARIO-UBICACION:**

```cypher
MATCH (u:USUARIO {Nombre: 'Ana'})
MATCH (c:UBICACION {Ciudad: 'Rosario'})
CREATE (u)-[:VIVE_EN]->(c)
```

**USUARIO-EMPRESA:**

```cypher
MATCH (u:USUARIO {Nombre: 'Ana'})
MATCH (e:EMPRESA {Empresa: 'Banco Santander'})
CREATE (u)-[:TRABAJO_EN {Puesto: 'Analista de Marketing', Fecha_inicio: date('2023-03-01'), Fecha_fin: date('2026-06-01'), Antiguedad_anios: 3, Antiguedad_meses: 3}]->(e)
```

**OFERTA-HABILIDAD:**

```cypher
MATCH (O:OFERTA {Puesto: 'Growth Marketing Manager'})
MATCH (A:HABILIDAD {Habilidad: 'Power BI'})
MATCH (B:HABILIDAD {Habilidad: 'Excel'})
MATCH (C:HABILIDAD {Habilidad: 'A/B testing'})
MATCH (D:HABILIDAD {Habilidad: 'Full-funnel marketing'})
CREATE (O)-[:REQUIERE]->(A), (O)-[:REQUIERE]->(B), (O)-[:REQUIERE]->(C), (O)-[:REQUIERE]->(D)
```

**OFERTA-UBICACION:**

```cypher
MATCH (o:OFERTA {Puesto: 'Growth Marketing Manager'})
MATCH (c:UBICACION {Ciudad: 'Bariloche'})
CREATE (o)-[:UBICADO_EN]->(c)
```

**EMPRESA-OFERTA:**

```cypher
MATCH (e:EMPRESA {Empresa: 'Montagne'}) MATCH (o:OFERTA {Puesto: 'Growth Marketing Manager'})
CREATE (e)-[:BUSCA]->(o)
```

**USUARIO-OFERTA:**

```cypher
MATCH (u:USUARIO {Nombre: 'Ana'}) MATCH (o:OFERTA {Puesto: 'Growth Marketing Manager'})
CREATE (u)-[:POSTULO_A {Fecha_postulacion:date('2026-07-25')}]->(o)
```

### Ejemplos de consultas y modificaciones

**Consultas**

**1. ¿Qué empresas tienen publicadas ofertas para el puesto de 'Analista de Datos' en la ciudad de Rosario?**

```cypher
MATCH (e:EMPRESA)-[:BUSCA]->(o:OFERTA {Puesto: 'Analista de Datos'})-[:UBICADO_EN]->(:UBICACION {Ciudad: "Rosario"})
WHERE o.Estado IS NULL OR o.Estado <> "Cerrada"
RETURN e.Empresa, o.Puesto, o.Salario_mensual, o.Modalidad
```

**2. ¿Cuáles son las ofertas laborales publicadas por la empresa 'Mercado Libre' con modalidad remota?**

```cypher
MATCH (e:EMPRESA {Empresa: 'Mercado Libre'})-[:BUSCA]->(o:OFERTA {Modalidad: 'Remoto'})
WHERE o.Estado IS NULL OR o.Estado <> "Cerrada"
RETURN o.Puesto, o.Salario_mensual, o.Modalidad
```

**3. ¿Qué habilidades tiene el usuario 'Juan Lopez' que coincidan con las solicitadas por la oferta de trabajo de 'Desarrollador Backend' publicada por 'Globant'?**

```cypher
MATCH (u:USUARIO {Nombre: 'Juan', Apellido: 'Lopez'})-[:POSEE]->(h:HABILIDAD)
MATCH (:EMPRESA {Empresa: 'Globant'})-[:BUSCA]->(o:OFERTA {Puesto: 'Desarrollador Backend'})-[:REQUIERE]->(h)
RETURN u.Nombre, u.Apellido, o.Puesto, collect(h.Habilidad) AS habilidades_coincidentes
```

**4. ¿Qué candidatos cumplen con TODOS los requisitos de una oferta particular?**

```cypher
MATCH (o:OFERTA {Cod_oferta: 100})-[:REQUIERE]->(h:HABILIDAD)
WITH o, collect(h) AS requeridas
MATCH (u:USUARIO)-[:POSEE]->(j:HABILIDAD)
WHERE j IN requeridas
WITH u, o, count(DISTINCT j) AS coincidencias, size(requeridas) AS total
WHERE coincidencias = total
RETURN u.Nombre, u.Apellido, o.Puesto
```

**Modificaciones**

**5. Actualizar el salario de una oferta:**

```cypher
MATCH (o:OFERTA {Cod_oferta: 102})
SET o.Salario_mensual = 1850000
```

**6. Cerrar una oferta:**

```cypher
MATCH (o:OFERTA {Cod_oferta: 101})
SET o.Estado = "Cerrada"
```

## Tecnología

- **Motor:** Neo4j
- **Lenguaje de consulta:** Cypher

## Conclusión

Dentro de mi experiencia en el campo de las ciencias de datos, aprender sobre bases de datos no relacionales me permitió ampliar mi perspectiva sobre el diseño y modelado de bases de datos. Ahora sé que el modelo relacional no es la única opción a la hora de armar una base, y que la elección del paradigma depende de los objetivos del negocio y del tipo de datos que se necesita representar. En este caso, el uso de Neo4j resultó esencial para representar los datos de la plataforma de búsqueda de empleo y realizar consultas.
