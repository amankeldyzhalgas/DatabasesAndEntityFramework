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

--13.3 �������� ���������, ������� ����������� ���� ����������� ��������� ��������, ��� ����������������, ��� � ����������� ��� �����������. � �������� �������� ��������� �������
--������������ EmployeeID. ���������� ����������� ����� ����������� � ��������� �� � ������ (������������ �������� PRINT) �������� �������� ����������. ��������, ��� �������� ����
--����� ����������� ����� ������ ���� ��������. �������� ��������� SubordinationInfo. � �������� ��������� ��� ������� ���� ������ ���� ������������ ������, ����������� � Books 
--Online � ��������������� Microsoft ��� ������� ��������� ���� �����. ������������������ ������������� ���������.
IF OBJECT_ID('SubordinationInfo') IS NOT NULL
	DROP PROCEDURE SubordinationInfo
GO
CREATE PROCEDURE SubordinationInfo @EmployeeID INT
AS
BEGIN
	DECLARE @EmpID int, @Employee nvarchar(128)
	SET @Employee = (
		SELECT LastName + ' ' + FirstName 
		FROM Employees
		WHERE EmployeeID = @EmployeeID)
	PRINT REPLICATE('-', @@NESTLEVEL * 1) + @Employee
	SET @EmpID = (SELECT MIN(EmployeeID) FROM Employees WHERE ReportsTo = @EmployeeID)
	WHILE @EmpID IS NOT NULL
		BEGIN
			EXEC SubordinationInfo @EmpID
			SET @EmpID = (SELECT MIN(EmployeeID) FROM Employees WHERE ReportsTo = @EmployeeID AND EmployeeID > @EmpID)
		END
END
GO

--13.4 �������� �������, ������� ����������, ���� �� � �������� �����������. ���������� ��� ������ BIT. � �������� �������� ��������� ������� ������������ EmployeeID. �������� ������� IsBoss.
-- ������������������ ������������� ������� ��� ���� ��������� �� ������� Employees.
IF OBJECT_ID('IsBoss') IS NOT NULL
	DROP FUNCTION IsBoss
GO
CREATE FUNCTION IsBoss(@EmployeeID AS int)
RETURNS BIT
AS
BEGIN
RETURN
(SELECT CASE WHEN EXISTS
	(SELECT *
		FROM Employees AS e
		WHERE e.ReportsTo = @EmployeeID)
		THEN 1 ELSE 0
		END)
END;
GO
