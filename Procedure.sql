USE Northwind
GO
--13.1 Написать процедуру, которая возвращает самый крупный заказ для каждого из продавцов за определенный год. В результатах не может быть несколько заказов одного продавца, должен 
--быть только один и самый крупный. В результатах запроса должны быть выведены следующие колонки: колонка с именем и фамилией продавца (FirstName и LastName – пример: Nancy Davolio),
--номер заказа и его стоимость. В запросе надо учитывать Discount при продаже товаров. Процедуре передается год, за который надо сделать отчет, и количество возвращаемых записей. 
--Результаты запроса должны быть упорядочены по убыванию суммы заказа. Процедура должна быть реализована с использованием оператора SELECT и БЕЗ ИСПОЛЬЗОВАНИЯ КУРСОРОВ.
CREATE OR ALTER PROCEDURE GreatestOrders @YEAR INT, @COUNT INT
AS BEGIN
SELECT DISTINCT TOP(@COUNT) res.Name, MAX(res.Price)  AS 'Max Price'
FROM (SELECT e.FirstName + ' ' + e.LastName AS 'Name', od.OrderID,
	od.UnitPrice * od.Quantity * (1 - od.Discount) AS 'Price'
FROM Employees AS e
JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = @YEAR)
AS res
GROUP BY Name
ORDER BY [Max Price] DESC
END;
GO
--13.2 Написать процедуру, которая возвращает заказы в таблице Orders, согласно указанному сроку доставки в днях (разница между OrderDate и ShippedDate).  В результатах должны 
--быть возвращены заказы, срок которых превышает переданное значение или еще недоставленные заказы. Значению по умолчанию для передаваемого срока 35 дней. Название процедуры 
--ShippedOrdersDiff. Процедура должна высвечивать следующие колонки: OrderID, OrderDate, ShippedDate, ShippedDelay (разность в днях между ShippedDate и OrderDate), SpecifiedDelay 
--(переданное в процедуру значение).  Необходимо продемонстрировать использование этой процедуры.
CREATE OR ALTER PROCEDURE ShippedOrdersDiff(@DAY INT = 35)
AS BEGIN
SELECT o.OrderID, o.OrderDate, o.ShippedDate,
	DAY(o.ShippedDate - o.OrderDate) AS 'ShippedDelay',
	@DAY AS 'SpecifiedDelay'
FROM Orders AS o
WHERE DAY(o.ShippedDate - o.OrderDate) > @DAY OR o.ShippedDate IS NULL
END;
GO






