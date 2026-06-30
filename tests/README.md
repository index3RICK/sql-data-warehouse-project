Purpose

These SQL scripts profile the raw data stored in the Bronze layer before loading it into the Silver layer.

The goal is to identify:

- Duplicate primary keys
- Null values
- Invalid dates
- Invalid business values
- Leading and trailing spaces
- Inconsistent categorical values
- Data quality issues requiring cleansing

Execution Order

1. Run the data quality checks.
2. Review the identified issues.
3. Apply the cleansing rules in the Silver ETL process.
4. Validate the transformed data.

====================================================================================

Propósito

Estos scripts SQL analizan los datos sin procesar almacenados en la capa Bronze antes de cargarlos en la capa Silver.

El objetivo es identificar:

- Claves primarias duplicadas
- Valores nulos
- Fechas no válidas
- Valores de negocio no válidos
- Espacios al inicio y al final
- Valores categóricos inconsistentes
- Problemas de calidad de datos que requieren limpieza

Orden de ejecución

1. Ejecutar las validaciones de calidad de datos.
2. Revisar los problemas detectados.
3. Aplicar las reglas de limpieza durante el proceso ETL hacia Silver.
4. Validar los datos transformados.
