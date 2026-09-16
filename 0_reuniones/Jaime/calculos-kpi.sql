# • Calcular la media diaria de la cuantía de las distribuciones 
SELECT DATE(tiempo_venta) as dia_venta, AVG(precio_venta)
FROM venta
GROUP BY DATE(tiempo_venta)
ORDER BY DATE(tiempo_venta);

# Resultado: 
# Resuelto por:


# • Calcular la cuantía total de las distribuciones 
SELECT ROUND(SUM(precio_venta), 2)
FROM venta;

# Resultado:
# Resuelto por:


# • ¿Qué días del mes se han producido más distribuciones y cuántas? 
SELECT DATE(tiempo_venta) as dia_venta, COUNT(precio_venta) as num_distribuciones
FROM venta
GROUP BY DATE(tiempo_venta)
HAVING num_distribuciones = (
    SELECT MAX(num_distribuciones)
    FROM (
        SELECT COUNT(precio_venta) as num_distribuciones
        FROM venta
        GROUP BY DATE(tiempo_venta)
    ) subquery
)
ORDER BY DATE(tiempo_venta);


# Resultado: 
# Resuelto por:


# • ¿A qué horas del día se producen más recogidas de alimentos y cuántas? ***** PREGUNAR FECHAS PARA LIMPIEZA DE DATOS
SELECT HOUR(tiempo_recogida) as hora_del_dia, COUNT(*) as total_recogidas
FROM producto
GROUP BY hora_del_dia
HAVING total_recogidas = (SELECT MAX(cont_recogida) 
        FROM (
            SELECT COUNT(*) AS cont_recogida 
            FROM producto 
            GROUP BY HOUR(tiempo_recogida)
        ) AS subconsulta
);

# Resultado: 
# Resuelto por:


# • ¿Cuáles son los 5 clientes que más dinero han gastado comprando la fruta y cuánto? 
SELECT  c.id_cliente, c.nombre AS cliente, SUM(v.precio_venta) AS total_gastado
FROM  venta v
INNER JOIN  cliente c ON v.id_cliente = c.id_cliente
INNER JOIN  producto p ON v.id_producto = p.id_producto
GROUP BY  c.id_cliente, c.nombre
ORDER BY  total_gastado DESC
LIMIT 5;

# Resultado: 
# Resuelto por:


# • ¿Cuáles son los 5 clientes que menos dinero han gastado comprando la fruta y cuánto? 

SELECT  c.id_cliente, c.nombre AS cliente, SUM(v.precio_venta) AS total_gastado
FROM  venta v
INNER JOIN  cliente c ON v.id_cliente = c.id_cliente
INNER JOIN  producto p ON v.id_producto = p.id_producto
GROUP BY  c.id_cliente, c.nombre
ORDER BY  total_gastado ASC
LIMIT 5;

# Resultado: 
# Resuelto por:

# • ¿Cuáles son los 10 proveedores que han recibido más dinero y cuánto? 
SELECT  p.id_proveedor, p.nombre AS proveedor, SUM(v.precio_venta) AS dinero_recibido
FROM  venta v
INNER JOIN  producto prod ON v.id_producto = prod.id_producto
INNER JOIN  proveedor p ON prod.id_proveedor = p.id_proveedor
GROUP BY  p.id_proveedor, p.nombre
ORDER BY  dinero_recibido DESC
LIMIT 10;

# Resultado: 
# Resuelto por:

# • ¿Cuáles son los 3 productos con mayor beneficio a lo largo del mes (aquellos que al restarle 
# al coste de venta el precio de compra se quedan con un mejor resultado) y cuál ha sido su 
# balance? *** Cambiar a Roberto
SELECT  p.id_producto, p.t_id AS codigo_producto, SUM(v.precio_venta - p.coste_inicial) AS balance_beneficio
FROM  venta v
INNER JOIN  producto p ON v.id_producto = p.id_producto
GROUP BY  p.id_producto,  p.t_id
ORDER BY balance_beneficio DESC
LIMIT 3;

# Resultado: 
# Resuelto por:



# • ¿Cuáles son los 3 productos con peor beneficio a lo largo de todo el mes y cuál ha sido? *** Cambiar a Roberto
SELECT  p.id_producto, p.t_id AS codigo_producto, SUM(v.precio_venta - p.coste_inicial) AS balance_beneficio
FROM  venta v
INNER JOIN  producto p ON v.id_producto = p.id_producto
GROUP BY  p.id_producto,  p.t_id
HAVING balance_beneficio IS NOT NULL
ORDER BY balance_beneficio ASC
LIMIT 3;

# Resultado: 
# Resuelto por:

# • ¿Cuál es el precio de venta medio de cada fruta? 
SELECT t.id_tipo, t.nombre AS tipo_producto, AVG(v.precio_venta) AS precio_venta_medio
FROM venta v
INNER JOIN producto p ON v.id_producto = p.id_producto
INNER JOIN tipo t ON p.id_tipo = t.id_tipo
GROUP BY t.id_tipo, t.nombre;

# Resultado: 
# Resuelto por:


# • Suponiendo  que  si  no  se  dispone  de  información  de  venta se trata  de  una  fruta  que  no  ha 
# podido venderse por haber sido dañada durante la distribución, ¿cuánta fruta de cada tipo ha sido dañada? 
SELECT t.id_tipo, t.nombre AS tipo_producto, COUNT(p.id_producto) AS cantidad_danada
FROM tipo t
INNER JOIN producto p ON t.id_tipo = p.id_tipo
LEFT JOIN venta v ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL
GROUP BY t.id_tipo, t.nombre;

# Resultado: 
# Resuelto por:


# • ¿Cuál ha sido la pérdida total de la fruta dañada? 


# Resultado: 
# Resuelto por:

# • ¿Cuál es la cuantía total de cada tipo de fruta que han comprado los 5 clientes que más dinero han gastado? ****
SELECT t.id_tipo, t.nombre AS tipo_producto, SUM(v.precio_venta) AS cuantia_total_gastada
FROM venta v
INNER JOIN producto p ON v.id_producto = p.id_producto
INNER JOIN tipo t ON p.id_tipo = t.id_tipo
WHERE v.id_cliente IN (
        SELECT id_cliente
        FROM (
            SELECT id_cliente
            FROM venta
            GROUP BY id_cliente
            ORDER BY SUM(precio_venta) DESC
            LIMIT 5
        ) AS top_clientes
    )
GROUP BY t.id_tipo, t.nombre
ORDER BY cuantia_total_gastada DESC;

# Resultado: 
# Resuelto por:


# • Para cada producto, calcular el porcentaje de beneficio. *****
SELECT p.id_producto, p.t_id AS codigo_producto, p.coste_inicial,
    AVG(v.precio_venta) AS precio_venta_promedio,
    ROUND(
        ((AVG(v.precio_venta) - p.coste_inicial) / p.coste_inicial) * 100, 
        2
    ) AS porcentaje_beneficio
FROM producto p
INNER JOIN venta v ON p.id_producto = v.id_producto
WHERE p.coste_inicial > 0
GROUP BY p.id_producto, p.t_id, p.coste_inicial;

# Resultado: 
# Resuelto por:

