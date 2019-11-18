USE Northwind
GO
--13.1 �������� ���������, ������� ���������� ����� ������� ����� ��� ������� �� ��������� �� ������������ ���. � ����������� �� ����� ���� ��������� ������� ������ ��������, ������ 
--���� ������ ���� � ����� �������. � ����������� ������� ������ ���� �������� ��������� �������: ������� � ������ � �������� �������� (FirstName � LastName � ������: Nancy Davolio),
--����� ������ � ��� ���������. � ������� ���� ��������� Discount ��� ������� �������. ��������� ���������� ���, �� ������� ���� ������� �����, � ���������� ������������ �������. 
--���������� ������� ������ ���� ����������� �� �������� ����� ������. ��������� ������ ���� ����������� � �������������� ��������� SELECT � ��� ������������� ��������.
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
--13.2 �������� ���������, ������� ���������� ������ � ������� Orders, �������� ���������� ����� �������� � ���� (������� ����� OrderDate � ShippedDate).  � ����������� ������ 
--���� ���������� ������, ���� ������� ��������� ���������� �������� ��� ��� �������������� ������. �������� �� ��������� ��� ������������� ����� 35 ����. �������� ��������� 
--ShippedOrdersDiff. ��������� ������ ����������� ��������� �������: OrderID, OrderDate, ShippedDate, ShippedDelay (�������� � ���� ����� ShippedDate � OrderDate), SpecifiedDelay 
--(���������� � ��������� ��������).  ���������� ������������������ ������������� ���� ���������.
CREATE OR ALTER PROCEDURE ShippedOrdersDiff(@DAY INT = 35)
AS BEGIN
SELECT o.OrderID, o.OrderDate, o.ShippedDate,
	DAY(o.ShippedDate - o.OrderDate) AS 'ShippedDelay',
	@DAY AS 'SpecifiedDelay'
FROM Orders AS o
WHERE DAY(o.ShippedDate - o.OrderDate) > @DAY OR o.ShippedDate IS NULL
END;
GO






