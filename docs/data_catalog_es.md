# Catálogo de Datos

## Resumen

La capa Gold contiene el modelo dimensional listo para el análisis y la generación de reportes.

Está compuesta por tres tablas principales:

- Dimensión de Clientes
- Dimensión de Productos
- Tabla de Hechos de Ventas

El modelo sigue un esquema en estrella (Star Schema), donde las dimensiones almacenan información descriptiva y la tabla de hechos almacena las transacciones del negocio.

---

# 1. gold.dim_customers

## Propósito

Almacena la información de los clientes enriquecida con datos provenientes de los sistemas CRM y ERP.

Cada registro representa la versión más reciente del cliente después del proceso de limpieza y estandarización.

| Nombre de Columna | Tipo de Dato | Descripción |
|-------------------|--------------|-------------|
| customer_key | INT | Clave sustituta que identifica de forma única a cada cliente. |
| customer_id | INT | Identificador del cliente proveniente del CRM. |
| customer_number | VARCHAR | Identificador de negocio compartido entre CRM y ERP. |
| first_name | VARCHAR | Nombre del cliente. |
| last_name | VARCHAR | Apellido del cliente. |
| country | VARCHAR | País de residencia del cliente. |
| marital_status | VARCHAR | Estado civil del cliente. |
| gender | VARCHAR | Género del cliente estandarizado. |
| birthdate | DATE | Fecha de nacimiento del cliente. |
| create_date | DATE | Fecha de creación del cliente en el CRM. |

---

# 2. gold.dim_products

## Propósito

Almacena el catálogo actual de productos enriquecido con información de categorías proveniente del ERP.

Solo se incluyen productos activos.

| Nombre de Columna | Tipo de Dato | Descripción |
|-------------------|--------------|-------------|
| product_key | INT | Clave sustituta que identifica de forma única cada producto. |
| product_id | INT | Identificador del producto proveniente del CRM. |
| product_number | VARCHAR | Identificador de negocio del producto. |
| product_name | VARCHAR | Nombre del producto. |
| category_id | VARCHAR | Identificador de la categoría. |
| category | VARCHAR | Categoría del producto. |
| subcategory | VARCHAR | Subcategoría del producto. |
| maintenance | VARCHAR | Clasificación de mantenimiento del producto. |
| cost | NUMERIC | Costo estándar del producto. |
| product_line | VARCHAR | Línea del producto. |
| start_date | DATE | Fecha de activación del producto. |

---

# 3. gold.fact_sales

## Propósito

Almacena las transacciones de ventas relacionadas con las dimensiones de clientes y productos.

Cada registro representa una línea de una orden de venta.

| Nombre de Columna | Tipo de Dato | Descripción |
|-------------------|--------------|-------------|
| order_number | VARCHAR | Identificador de la orden de venta. |
| product_key | INT | Clave foránea que referencia la dimensión de productos. |
| customer_key | INT | Clave foránea que referencia la dimensión de clientes. |
| order_date | DATE | Fecha en que se realizó la orden. |
| shipping_date | DATE | Fecha de envío del pedido. |
| due_date | DATE | Fecha estimada de entrega. |
| sales_amount | NUMERIC | Monto total de la venta. |
| quantity | INT | Cantidad vendida. |
| price | NUMERIC | Precio unitario de venta. |

---

# Esquema en Estrella

```

dim_customers
|
|
dim_products -------- fact_sales

```

---

# Notas

- La información de clientes se estandariza durante la capa Silver.
- La dimensión de productos contiene únicamente productos activos.
- La tabla de hechos utiliza claves sustitutas provenientes de ambas dimensiones.
- La capa Gold está optimizada para consultas analíticas y herramientas de visualización como Power BI.
