-- Consulta 1- Resumen ejecutivo mensual
SELECT MONTH (fecha_venta) AS mes,
SUM (cantidad * precio_unitario) AS total_facturado,
COUNT (*) AS cantidad_pedidos,
AVG (cantidad * precio_unitario) AS ticket_promedio
FROM dbo.ventas
GROUP BY MONTH (fecha_venta);

--Consulta 2- Ranking de productos
SELECT TOP 5
id_producto,
SUM (cantidad * precio_unitario) AS total_generado,
SUM (cantidad) AS unidades_vendidas
FROM dbo.ventas
GROUP BY id_producto
ORDER BY total_generado DESC;

--Consulta 3- Clientes recurrentes
SELECT id_cliente,
COUNT (*) AS cantidad_pedidos,
SUM (cantidad * precio_unitario) AS total_gastado
FROM dbo.ventas
GROUP BY id_cliente
HAVING COUNT (*) > 1;

--Consulta 4- Productos por encima/por debajo del promedio
WITH FacturacionPorProducto AS (
SELECT id_producto,
SUM (cantidad * precio_unitario) AS total_producto
FROM dbo.ventas
GROUP BY id_producto ),
PromedioGeneral AS (
SELECT AVG (total_producto) AS promedio_total
FROM FacturacionPorProducto )
SELECT f.id_producto,
f.total_producto,
CASE
WHEN f.total_producto > p.promedio_total THEN 'por encima'
ELSE 'por debajo'
END AS rendimiento
FROM FacturacionPorProducto f
CROSS JOIN PromedioGeneral p
ORDER BY f.total_producto DESC;

--El mes analizado cerro con una facturacion total de 6444,00 a traves de 10 transacciones, manteniendo el ticket promedio de compra de 644,400000
--El ranking de productos muestra que el producto 1 es nuestro articulo estrella, generando por si solo 3600 en ingresos.
--Mediante analisis del promedio general, determinamos que 2 prodcutos se posicionan con un rendimiento superior a la media, meintras que los demas requieren de una revision de estrategia comercial o promociones para impulsar sus ventas.




