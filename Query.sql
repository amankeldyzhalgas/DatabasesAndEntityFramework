USE Northwind
--1.1 ������� � ������� Orders ������, ������� ���� ���������� ����� 6 ��� 1998 ���� (������� ShippedDate) ������������ � ������� ���������� � ShipVia >= 2. ������ �������� ���� 
--������ ���� ������ ��� ����� ������������ ����������, �������� ����������� ������ �Writing International Transact-SQL Statements� � Books Online ������ �Accessing and Changing 
--Data Overview�. ���� ����� ������������ ����� ��� ���� �������. ������ ������ ����������� ������ ������� OrderID, ShippedDate � ShipVia. 
--�������� ������ ���� �� ������ ������ � NULL-�� � ������� ShippedDate.
SELECT OrderID, ShippedDate,  ShipVia  
FROM Orders
WHERE ShippedDate >= CONVERT(DATETIME, '19980506', 101) 
AND ShipVia > = 2
--��� ������� �������� ������ �� ������, ��� ������� ��������� ����� WHERE ���������� TRUE
--��������� � NULL ���������� UNKNOWN ��������

--1.2 �������� ������, ������� ������� ������ �������������� ������ �� ������� Orders. � ����������� ������� ����������� ��� ������� ShippedDate ������ �������� NULL ������ 
--�Not Shipped� � ������������ ��������� ������� CAS�. ������ ������ ����������� ������ ������� OrderID � ShippedDate.
SELECT OrderID, 
	CASE WHEN ShippedDate  IS NULL
		THEN 'Not Shipped' 
			END ShippedDate
FROM Orders
WHERE ShippedDate IS NULL

--1.3 ������� � ������� Orders ������, ������� ���� ���������� ����� 6 ��� 1998 ���� (ShippedDate) �� ������� ��� ���� ��� ������� ��� �� ����������. � ������� ������ ������������� 
--������ ������� OrderID (������������� � Order Number) � ShippedDate (������������� � Shipped Date). � ����������� ������� ����������� ��� ������� ShippedDate ������ �������� NULL 
--������ �Not Shipped�, ��� ��������� �������� ����������� ���� � ������� �� ���������.
SELECT OrderID AS 'Order Number',
CASE WHEN ShippedDate IS NULL 
	THEN 'Not Shipped'
	ELSE CONVERT(char,ShippedDate)
END AS 'Shipped Date' 
FROM Orders 
WHERE (ShippedDate > CONVERT(DATETIME, '19980506', 101))
OR (ShippedDate IS NULL)

--2.1 ������� �� ������� Customers ���� ����������, ����������� � USA � Canada. ������ ������� � ������ ������� ��������� IN. ����������� ������� � ������ ������������ � ��������� 
--������ � ����������� �������. ����������� ���������� ������� �� ����� ���������� � �� ����� ����������.
SELECT ContactName, Country
FROM Customers
WHERE Country IN ('USA', 'Canada')
ORDER BY ContactName, Address

--2.2 ������� �� ������� Customers ���� ����������, �� ����������� � USA � Canada. ������ ������� � ������� ��������� IN. ����������� ������� � ������ ������������ � ��������� 
--������ � ����������� �������. ����������� ���������� ������� �� ����� ����������. 
SELECT ContactName, Country
FROM Customers
WHERE Country NOT IN ('USA', 'Canada')
ORDER BY ContactName 

--2.3 ������� �� ������� Customers ��� ������, � ������� ��������� ���������. ������ ������ ���� ��������� ������ ���� ��� � ������ ������������ �� ��������. �� ������������ 
--����������� GROUP BY. ����������� ������ ���� ������� � ����������� �������. 
SELECT DISTINCT Country
FROM Customers
ORDER BY Country DESC

--3.1 ������� ��� ������ (OrderID) �� ������� Order Details (������ �� ������ �����������), ��� ����������� �������� � ����������� �� 3 �� 10 ������������ � ��� ������� Quantity 
--� ������� Order Details. ������������ �������� BETWEEN. ������ ������ ����������� ������ ������� OrderID. 
SELECT DiSTINCT OrderID
FROM [Order Details]
WHERE Quantity BETWEEN 3 AND 10

--3.2 ������� ���� ���������� �� ������� Customers, � ������� �������� ������ ���������� �� ����� �� ��������� b � g. ������������ �������� BETWEEN. ���������, ��� � ���������� 
--������� �������� Germany. ������ ������ ����������� ������ ������� CustomerID � Country � ������������ �� Country.
SELECT CustomerID, Country
FROM Customers
WHERE SUBSTRING(Country, 1, 1) BETWEEN 'b' AND 'g'
ORDER BY Country

--3.3 ������� ���� ���������� �� ������� Customers, � ������� �������� ������ ���������� �� ����� �� ��������� b � g, �� ��������� �������� BETWEEN. � ������� ����� �Execution Plan�
--���������� ����� ������ ���������������� 3.2 ��� 3.3 � ��� ����� ���� ������ � ������ ���������� ���������� Execution Plan-a ��� ���� ���� ��������, ���������� ���������� Execution 
--Plan ���� ������ � ������ � ���� ����������� � �� �� ����������� ���� ����� �� ������ � �� ������ ��������� ���� ��������� ���������. ������ ������ ����������� ������ ������� 
--CustomerID � Country � ������������ �� Country. 
--TODO
SELECT CustomerID, Country
FROM Customers
WHERE SUBSTRING(Country, 1, 1) > 'b' AND SUBSTRING(Country, 1, 1) < 'g'
ORDER BY Country

--4.1 � ������� Products ����� ��� �������� (������� ProductName), ��� ����������� ��������� 'chocolade'. ��������, ��� � ��������� 'chocolade' ����� ���� �������� ���� ����� 'c' � 
--�������� - ����� ��� ��������, ������� ������������� ����� �������. ���������: ���������� ������� ������ ����������� 2 ������. 
SELECT ProductName
FROM Products
WHERE ProductName 
LIKE '%cho_olade%'

--5.1 ����� ����� ����� ���� ������� �� ������� Order Details � ������ ���������� ����������� ������� � ������ �� ���. ��������� ��������� �� ����� � ��������� � ����� 1 ��� ����
--������ money.  ������ (������� Discount) ���������� ������� �� ��������� ��� ������� ������. ��� ����������� �������������� ���� �� ��������� ������� ���� ������� ������ ��
--��������� � ������� UnitPrice ����. ����������� ������� ������ ���� ���� ������ � ����� �������� � ��������� ������� 'Totals'. 
SELECT ROUND(SUM((UnitPrice - UnitPrice * Discount) * Quantity),2) AS 'Totals'
FROM [Order Details]

--5.2 �� ������� Orders ����� ���������� �������, ������� ��� �� ���� ���������� (�.�. � ������� ShippedDate ��� �������� ���� ��������). ������������ ��� ���� ������� ������ 
--�������� COUNT. �� ������������ ����������� WHERE � GROUP. 
SELECT COUNT(*) - COUNT(ShippedDate) 
AS 'Not shipped'
FROM Orders

--5.3 �� ������� Orders ����� ���������� ��������� ����������� (CustomerID), ��������� ������. ������������ ������� COUNT � �� ������������ ����������� WHERE � GROUP. 
SELECT COUNT(DISTINCT CustomerID) 
AS 'Unique customers'
FROM Orders

--6.1 �� ������� Orders ����� ���������� ������� � ������������ �� �����. � ����������� ������� ���� ����������� ��� ������� c ���������� Year � Total. �������� ����������� ������,
--������� ��������� ���������� ���� �������.
SELECT YEAR(OrderDate) AS 'Year', COUNT(OrderID) AS 'Total'
FROM Orders
GROUP BY (YEAR(OrderDate))

SELECT COUNT(*) AS 'Total'
FROM Orders

--6.2 �� ������� Orders ����� ���������� �������, c�������� ������ ���������. ����� ��� ���������� �������� � ��� ����� ������ � ������� Orders, ��� � ������� EmployeeID ������
--�������� ��� ������� ��������. � ����������� ������� ���� ����������� ������� � ������ �������� (������ ������������� ��� ���������� ������������� LastName & FirstName. ��� ������
--LastName & FirstName ������ ���� �������� ��������� �������� � ������� ��������� �������. ����� �������� ������ ������ ������������ ����������� �� EmployeeID.) � ��������� ������� 
--�Seller� � ������� c ����������� ������� ����������� � ��������� 'Amount'. ���������� ������� ������ ���� ����������� �� �������� ���������� �������. 
SELECT
(
	SELECT LastName + ' ' +  FirstName
	FROM Employees
	WHERE Employees.EmployeeID = Orders.EmployeeID
) AS 'Seller'
,COUNT(*) AS 'Amount'
FROM Orders
GROUP BY EmployeeID
ORDER BY Amount DESC

--6.3 �� ������� Orders ����� ���������� �������, c�������� ������ ��������� � ��� ������� ����������. ���������� ���������� ��� ������ ��� ������� ��������� � 1998 ����. � 
--����������� ������� ���� ����������� ������� � ������ �������� (�������� ������� �Seller�), ������� � ������ ���������� (�������� ������� �Customer�)  � ������� c ����������� 
--������� ����������� � ��������� 'Amount'. � ������� ���������� ������������ ����������� �������� ����� T-SQL ��� ������ � ���������� GROUP (���� �� �������� ������� �������� 
--������ �ALL� � ����������� �������). ����������� ������ ���� ������� �� ID �������� � ����������. ���������� ������� ������ ���� ����������� �� ��������, ���������� � �� �������� 
--���������� ������. � ����������� ������ ���� ������� ���������� �� ��������. �.�. � ������������� ������ ������ �������������� ������������� � ���������� � �������� �������� ��� 
--������� ����������
SELECT
(CASE
    WHEN Orders.EmployeeID is null THEN 'ALL'
	ELSE
    	(SELECT LastName + ' ' +  FirstName
	    FROM Employees
     	WHERE Employees.EmployeeID = Orders.EmployeeID)
END) AS 'Seller'
,(CASE
    WHEN Orders.CustomerID is null THEN 'ALL'
	ELSE
	    (SELECT CompanyName
    	FROM Customers
	    WHERE Customers.CustomerID = Orders.CustomerID)
END) AS 'Customer'
,COUNT(*) AS 'Amount'
FROM Orders
WHERE YEAR(OrderDate) = 1998
GROUP BY grouping SETS ((), (EmployeeID), (CustomerID), (EmployeeID, CustomerID))
ORDER BY Seller, Customer, Amount DESC

--6.4 ����� ����������� � ���������, ������� ����� � ����� ������. ���� � ������ ����� ������ ���� ��� ��������� ��������� ��� ������ ���� ��� ��������� �����������, �� ���������� 
--� ����� ���������� � ��������� �� ������ �������� � �������������� �����. �� ������������ ����������� JOIN. � ����������� ������� ���������� ������� ��������� ��������� ��� 
--����������� �������: �Person�, �Type� (����� ���� �������� ������ �Customer� ���  �Seller� � ��������� �� ���� ������), �City�. ������������� ���������� ������� �� ������� �City� 
--� �� �Person�.
SELECT Person, Type, City
FROM
    (SELECT LastName + ' ' +  FirstName AS 'Person' ,'Seller' AS 'Type' ,City
    FROM Employees
    UNION
    SELECT CompanyName AS 'Person' ,'Customer' AS 'Type' ,City
    FROM Customers) AS Result
WHERE Result.City in 
    (SELECT City FROM Employees
	 INTERSECT
	 SELECT City FROM Customers)
ORDER BY City, Person

--6.5 ����� ���� �����������, ������� ����� � ����� ������. � ������� ������������ ���������� ������� Customers c ����� - ��������������. ��������� ������� CustomerID � City.
--������ �� ������ ����������� ����������� ������. ��� �������� �������� ������, ������� ����������� ������, ������� ����������� ����� ������ ���� � ������� Customers. ��� ��������
--��������� ������������ �������.
SELECT c1.CustomerID, c1.City
FROM Customers AS c1 JOIN Customers AS c2
ON c1.City = c2.City AND c1.CustomerID <> c2.CustomerID
GROUP BY c1.City, c1.CustomerID

--����������� ������
SELECT City, COUNT(*) AS 'Count'
FROM Customers
GROUP BY City
HAVING COUNT(*) > 1

--6.6 �� ������� Employees ����� ��� ������� �������� ��� ������������, �.�. ���� �� ������ �������. ��������� ������� � ������� 'User Name' (LastName) � 'Boss'. � �������� ������
--���� ��������� ����� �� ������� LastName. ��������� �� ��� �������� � ���� �������?
SELECT e1.LastName AS 'User Name' ,e2.LastName AS 'Boss'
FROM Employees e1 JOIN Employees e2
ON e1.ReportsTo = e2.EmployeeID

--����������� ������
Select LastName
From Employees
--�� �������� Fuller, �.�. �� ������ �� ������ ������� (��� �������������).

--7.1 ���������� ���������, ������� ����������� ������ 'Western' (������� Region). ���������� ������� ������ ����������� ��� ����: 'LastName' �������� � �������� ������������� 
--���������� ('TerritoryDescription' �� ������� Territories). ������ ������ ������������ JOIN � ����������� FROM. ��� ����������� ������ ����� ��������� Employees � Territories 
--���� ������������ ����������� ��������� ��� ���� Northwind.
SELECT e.LastName, t.TerritoryDescription
FROM EmployeeTerritories et INNER JOIN Employees e
ON et.EmployeeID = e.EmployeeID
INNER JOIN Territories t
ON et.TerritoryID = t.TerritoryID

--8.1 ��������� � ����������� ������� ����� ���� ���������� �� ������� Customers � ��������� ���������� �� ������� �� ������� Orders. ������� �� ��������, ��� � ��������� ����������
--��� �������, �� ��� ����� ������ ���� �������� � ����������� �������. ����������� ���������� ������� �� ����������� ���������� �������.
SELECT c.ContactName, COUNT(o.OrderID) AS 'Sum'
FROM Customers AS c LEFT JOIN Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName
ORDER BY Sum

--9.1 ��������� ���� ����������� ������� CompanyName � ������� Suppliers, � ������� ��� ���� �� ������ �������� �� ������ (UnitsInStock � ������� Products ����� 0). ������������ 
--��������� SELECT ��� ����� ������� � �������������� ��������� IN. ����� �� ������������ ������ ��������� IN �������� '=' ?
SELECT CompanyName
FROM Suppliers
WHERE SupplierID IN
	(SELECT SupplierID
		FROM Products
		WHERE UnitsInStock = 0)

--10.1 ��������� ���� ���������, ������� ����� ����� 150 �������. ������������ ��������� ��������������� SELECT.
SELECT EmployeeID  
FROM Employees AS e
WHERE (SELECT COUNT(OrderID) 
        FROM Orders AS o
        WHERE e.EmployeeID = o.EmployeeID) > 150;

--11.1 ��������� ���� ���������� (������� Customers), ������� �� ����� �� ������ ������ (��������� �� ������� Orders). ������������ ��������������� SELECT � �������� EXISTS.
SELECT ContactName 
FROM Customers
WHERE EXISTS 
	(SELECT EmployeeID 
	FROM Orders
	WHERE ShippedDate IS NULL);

--12.1 ��� ������������ ����������� ��������� Employees ��������� �� ������� Employees ������ ������ ��� ���� ��������, � ������� ���������� ������� Employees (������� LastName ) 
--�� ���� �������. ���������� ������ ������ ���� ������������ �� �����������.
SELECT DISTINCT SUBSTRING(LastName,1,1) AS 'ALPH'
FROM Employees
ORDER BY 'ALPH'

--13.1 �������� ���������, ������� ���������� ����� ������� ����� ��� ������� �� ��������� �� ������������ ���. � ����������� �� ����� ���� ��������� ������� ������ ��������, ������ 
--���� ������ ���� � ����� �������. � ����������� ������� ������ ���� �������� ��������� �������: ������� � ������ � �������� �������� (FirstName � LastName � ������: Nancy Davolio),
--����� ������ � ��� ���������. � ������� ���� ��������� Discount ��� ������� �������. ��������� ���������� ���, �� ������� ���� ������� �����, � ���������� ������������ �������.
--���������� ������� ������ ���� ����������� �� �������� ����� ������. ��������� ������ ���� ����������� � �������������� ��������� SELECT � ��� ������������� ��������. 
EXEC GreatestOrders @YEAR = 1998, @COUNT = 5
--����������� ������
SELECT e.FirstName + ' ' + e.LastName AS 'Name', od.OrderID,
	od.UnitPrice * od.Quantity * (1 - od.Discount) AS 'Price'
FROM Employees AS e
JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = '1998'
ORDER BY Price DESC

--13.2 �������� ���������, ������� ���������� ������ � ������� Orders, �������� ���������� ����� �������� � ���� (������� ����� OrderDate � ShippedDate).  � ����������� ������ 
--���� ���������� ������, ���� ������� ��������� ���������� �������� ��� ��� �������������� ������. �������� �� ��������� ��� ������������� ����� 35 ����. �������� ��������� 
--ShippedOrdersDiff. ��������� ������ ����������� ��������� �������: OrderID, OrderDate, ShippedDate, ShippedDelay (�������� � ���� ����� ShippedDate � OrderDate), SpecifiedDelay 
--(���������� � ��������� ��������).  ���������� ������������������ ������������� ���� ���������.
EXEC ShippedOrdersDiff @DAY = 7

--13.3 �������� ���������, ������� ����������� ���� ����������� ��������� ��������, ��� ����������������, ��� � ����������� ��� �����������. � �������� �������� ��������� �������
--������������ EmployeeID. ���������� ����������� ����� ����������� � ��������� �� � ������ (������������ �������� PRINT) �������� �������� ����������. ��������, ��� �������� ����
--����� ����������� ����� ������ ���� ��������. �������� ��������� SubordinationInfo. � �������� ��������� ��� ������� ���� ������ ���� ������������ ������, ����������� � Books 
--Online � ��������������� Microsoft ��� ������� ��������� ���� �����. ������������������ ������������� ���������.





