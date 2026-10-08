# 1. Calcular la media diaria de la cuantía de las distribuciones
SELECT ROUND(AVG(Importe_venta), 2) AS Media_diaria
FROM (SELECT DAY(tiempo_venta) AS Dia_venta, SUM(precio_venta) AS Importe_venta
FROM venta
WHERE tiempo_venta IS NOT NULL AND tiempo_venta >= '2025-09-01' AND tiempo_venta < '2025-10-01'
GROUP BY Dia_venta) AS subconsulta;
# Resultado: Importe venta medio diario durante el mes de abril de 7950,76

# 2. Calcular la cuantía total de las distribuciones
SELECT SUM(precio_venta) AS Importe_venta
FROM venta;
# Resultado: Importe total de venta 24.415,90€

# 3. ¿Qué días del mes se han producido más distribuciones y cuántas?
SELECT DATE(tiempo_venta) AS Dia_venta, COUNT(id_venta) AS N_ventas
FROM venta
WHERE tiempo_venta IS NOT NULL AND tiempo_venta >= '2025-09-01' AND tiempo_venta <= '2025-09-30'
GROUP BY Dia_venta
HAVING N_ventas = 
	(SELECT MAX(N_ventas) AS Conteo_ventas
	FROM (SELECT DATE(tiempo_venta) AS Dia_venta, COUNT(id_venta) AS N_ventas
		FROM venta
		WHERE tiempo_venta IS NOT NULL AND tiempo_venta >= '2025-09-01' AND tiempo_venta <= '2025-09-30'
		GROUP BY Dia_venta) 
	AS subconsulta)
;
# Resultado: Se resuelve como el día que más número de distribuciones se han producido que es el 19/09/2025 con un total de 2.385 distribuciones.
# También se podría haber interpretado este KPI desde el punto de vista del importe venta pero consideramos que tiene más sentido logísticamente enfocarlo de este modo.

# 4. ¿A qué horas del día se producen más recogidas de alimentos y cuántas?
SELECT HOUR(tiempo_recogida) AS Hora_recogida, COUNT(id_producto) AS N_recogida
FROM producto
WHERE tiempo_recogida IS NOT NULL AND tiempo_recogida >= '2025-09-01' AND tiempo_recogida <= '2025-09-30'
GROUP BY Hora_recogida
HAVING N_recogida = 
	(SELECT MAX(N_recogida)
	FROM (SELECT HOUR(tiempo_recogida) AS Hora_recogida, COUNT(id_producto) AS N_recogida
		FROM producto
		WHERE tiempo_recogida IS NOT NULL AND tiempo_recogida >= '2025-09-01' AND tiempo_recogida <= '2025-09-30'
		GROUP BY Hora_recogida) 
	AS subconsulta)
;
# Resultado: La hora con más número de recogidas es la 13 con 2905 entradas.

# 5. ¿Cuáles son los 5 clientes que más dinero han gastado comprando la fruta y cuánto?
SELECT c.nombre, SUM(precio_venta) AS importe_venta
FROM venta v
INNER JOIN cliente c ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY importe_venta DESC
LIMIT 5;

# 6. ¿Cuáles son los 5 clientes que menos dinero han gastado comprando la fruta y cuánto?
SELECT c.nombre, SUM(precio_venta) AS importe_venta
FROM venta v
INNER JOIN cliente c ON v.id_cliente = c.id_cliente
GROUP BY c.id_cliente, c.nombre
ORDER BY importe_venta ASC
LIMIT 5;

# 7. ¿Cuáles son los 10 proveedores que han recibido más dinero y cuánto?
SELECT p.nombre, SUM(pd.coste_inicial) AS importe_compra
FROM producto pd
INNER JOIN proveedor p ON pd.id_proveedor = p.id_proveedor
GROUP BY p.id_proveedor, p.nombre
ORDER BY importe_compra DESC
LIMIT 10;

SELECT * FROM venta;
SELECT * FROM tipo;
# 8. ¿Cuáles son los 3 productos con mayor beneficio a lo largo del mes (aquellos que al restarle al coste de venta el precio de compra se quedan con un mejor resultado) 
	#y cuál ha sido su balance? 
SELECT  t.nombre, SUM(v.precio_venta) AS importe_venta, SUM(pd.coste_inicial) AS importe_compra, SUM(v.precio_venta) - SUM(pd.coste_inicial) AS beneficio
FROM venta v
INNER JOIN producto pd ON v.id_producto = pd.id_producto
INNER JOIN tipo t ON pd.id_tipo = t.id_tipo
GROUP BY t.nombre
ORDER BY beneficio DESC
LIMIT 3;

# 9. ¿Cuáles son los 3 productos con peor beneficio a lo largo de todo el mes y cuál ha sido?
SELECT  t.nombre, SUM(v.precio_venta) AS importe_venta, SUM(pd.coste_inicial) AS importe_compra, SUM(v.precio_venta) - SUM(pd.coste_inicial) AS beneficio
FROM venta v
INNER JOIN producto pd ON v.id_producto = pd.id_producto
INNER JOIN tipo t ON pd.id_tipo = t.id_tipo
GROUP BY t.nombre
ORDER BY beneficio ASC
LIMIT 3;

# 10. ¿Cuál es el precio de venta medio de cada fruta?

SELECT  t.nombre, ROUND(AVG(v.precio_venta),4) AS precio_medio_venta
FROM venta v
INNER JOIN producto pd ON v.id_producto = pd.id_producto
INNER JOIN tipo t ON pd.id_tipo = t.id_tipo
GROUP BY t.nombre
ORDER BY precio_medio_venta DESC;
# Adicionalmente se podría calcular el precio medio KG.alter

# 11. Suponiendo que si no se dispone de información de venta se trata de una fruta que no ha podido venderse por haber sido dañada durante la distribución, 
#¿cuánta fruta de cada tipo ha sido dañada?
SELECT t.nombre, COUNT(v.id_producto) AS unidades_dañadas
FROM producto pd
LEFT JOIN venta v ON pd.id_producto = v.id_producto
INNER JOIN tipo t ON pd.id_tipo = t.id_tipo
WHERE v.precio_venta IS NULL
GROUP BY t.id_tipo, t.nombre
ORDER BY unidades_dañadas DESC
;

# 12. ¿Cuál ha sido la pérdida total de la fruta dañada?
SELECT t.nombre, COUNT(v.id_producto) AS unidades_dañadas, SUM(pd.coste_inicial) AS importe_dañadas
FROM producto pd
LEFT JOIN venta v ON pd.id_producto = v.id_producto
INNER JOIN tipo t ON pd.id_tipo = t.id_tipo
WHERE v.precio_venta IS NULL
GROUP BY t.id_tipo, t.nombre
ORDER BY importe_dañadas DESC
;

# 13. ¿Cuál es la cuantía total de cada tipo de fruta que han comprado los 5 clientes que más dinero han gastado?
SELECT c.nombre AS cliente, t.nombre AS tipo_fruta, SUM(precio_venta) AS importe_venta
FROM venta v
INNER JOIN cliente c ON v.id_cliente = c.id_cliente
INNER JOIN producto pd ON v.id_producto = pd.id_producto
INNER JOIN tipo t ON pd.id_tipo = t.id_tipo
WHERE v.id_cliente IN (
	SELECT id_cliente 
    FROM (SELECT c.id_cliente
		FROM venta v
		INNER JOIN cliente c ON v.id_cliente = c.id_cliente
		GROUP BY c.id_cliente
		ORDER BY SUM(precio_venta) DESC
		LIMIT 5) AS top_clientes)
GROUP BY c.id_cliente, c.nombre, t.id_tipo, t.nombre
ORDER BY c.nombre, importe_venta DESC
;

# 14. Para cada producto, calcular el porcentaje de beneficio.
SELECT  t.nombre, ROUND(((SUM(v.precio_venta) - SUM(pd.coste_inicial)) / SUM(v.precio_venta))*100,2) AS porcentaje_beneficio
FROM venta v
INNER JOIN producto pd ON v.id_producto = pd.id_producto
INNER JOIN tipo t ON pd.id_tipo = t.id_tipo
GROUP BY t.nombre
ORDER BY porcentaje_beneficio DESC
;