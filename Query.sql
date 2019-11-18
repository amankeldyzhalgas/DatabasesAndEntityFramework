USE Northwind
--1.1 Выбрать в таблице Orders заказы, которые были доставлены после 6 мая 1998 года (колонка ShippedDate) включительно и которые доставлены с ShipVia >= 2. Формат указания даты 
--должен быть верным при любых региональных настройках, согласно требованиям статьи “Writing International Transact-SQL Statements” в Books Online раздел “Accessing and Changing 
--Data Overview”. Этот метод использовать далее для всех заданий. Запрос должен высвечивать только колонки OrderID, ShippedDate и ShipVia. 
--Пояснить почему сюда не попали заказы с NULL-ом в колонке ShippedDate.
SELECT OrderID, ShippedDate,  ShipVia  
FROM Orders
WHERE ShippedDate >= CONVERT(DATETIME, '19980506', 101) 
AND ShipVia > = 2
--Под выборку поподают только те записи, для которых выражение после WHERE возвращает TRUE
--сравнение с NULL возвращает UNKNOWN значение

--1.2 Написать запрос, который выводит только недоставленные заказы из таблицы Orders. В результатах запроса высвечивать для колонки ShippedDate вместо значений NULL строку 
--‘Not Shipped’ – использовать системную функцию CASЕ. Запрос должен высвечивать только колонки OrderID и ShippedDate.
SELECT OrderID, 
	CASE WHEN ShippedDate  IS NULL
		THEN 'Not Shipped' 
			END ShippedDate
FROM Orders
WHERE ShippedDate IS NULL

--1.3 Выбрать в таблице Orders заказы, которые были доставлены после 6 мая 1998 года (ShippedDate) не включая эту дату или которые еще не доставлены. В запросе должны высвечиваться 
--только колонки OrderID (переименовать в Order Number) и ShippedDate (переименовать в Shipped Date). В результатах запроса высвечивать для колонки ShippedDate вместо значений NULL 
--строку ‘Not Shipped’, для остальных значений высвечивать дату в формате по умолчанию.
SELECT OrderID AS 'Order Number',
CASE WHEN ShippedDate IS NULL 
	THEN 'Not Shipped'
	ELSE CONVERT(char,ShippedDate)
END AS 'Shipped Date' 
FROM Orders 
WHERE (ShippedDate > CONVERT(DATETIME, '19980506', 101))
OR (ShippedDate IS NULL)

--2.1 Выбрать из таблицы Customers всех заказчиков, проживающих в USA и Canada. Запрос сделать с только помощью оператора IN. Высвечивать колонки с именем пользователя и названием 
--страны в результатах запроса. Упорядочить результаты запроса по имени заказчиков и по месту проживания.
SELECT ContactName, Country
FROM Customers
WHERE Country IN ('USA', 'Canada')
ORDER BY ContactName, Address

--2.2 Выбрать из таблицы Customers всех заказчиков, не проживающих в USA и Canada. Запрос сделать с помощью оператора IN. Высвечивать колонки с именем пользователя и названием 
--страны в результатах запроса. Упорядочить результаты запроса по имени заказчиков. 
SELECT ContactName, Country
FROM Customers
WHERE Country NOT IN ('USA', 'Canada')
ORDER BY ContactName 

--2.3 Выбрать из таблицы Customers все страны, в которых проживают заказчики. Страна должна быть упомянута только один раз и список отсортирован по убыванию. Не использовать 
--предложение GROUP BY. Высвечивать только одну колонку в результатах запроса. 
SELECT DISTINCT Country
FROM Customers
ORDER BY Country DESC

--3.1 Выбрать все заказы (OrderID) из таблицы Order Details (заказы не должны повторяться), где встречаются продукты с количеством от 3 до 10 включительно – это колонка Quantity 
--в таблице Order Details. Использовать оператор BETWEEN. Запрос должен высвечивать только колонку OrderID. 
SELECT DiSTINCT OrderID
FROM [Order Details]
WHERE Quantity BETWEEN 3 AND 10

--3.2 Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона b и g. Использовать оператор BETWEEN. Проверить, что в результаты 
--запроса попадает Germany. Запрос должен высвечивать только колонки CustomerID и Country и отсортирован по Country.
SELECT CustomerID, Country
FROM Customers
WHERE SUBSTRING(Country, 1, 1) BETWEEN 'b' AND 'g'
ORDER BY Country

--3.3 Выбрать всех заказчиков из таблицы Customers, у которых название страны начинается на буквы из диапазона b и g, не используя оператор BETWEEN. С помощью опции “Execution Plan”
--определить какой запрос предпочтительнее 3.2 или 3.3 – для этого надо ввести в скрипт выполнение текстового Execution Plan-a для двух этих запросов, результаты выполнения Execution 
--Plan надо ввести в скрипт в виде комментария и по их результатам дать ответ на вопрос – по какому параметру было проведено сравнение. Запрос должен высвечивать только колонки 
--CustomerID и Country и отсортирован по Country. 
--TODO
SELECT CustomerID, Country
FROM Customers
WHERE SUBSTRING(Country, 1, 1) > 'b' AND SUBSTRING(Country, 1, 1) < 'g'
ORDER BY Country

--4.1 В таблице Products найти все продукты (колонка ProductName), где встречается подстрока 'chocolade'. Известно, что в подстроке 'chocolade' может быть изменена одна буква 'c' в 
--середине - найти все продукты, которые удовлетворяют этому условию. Подсказка: результаты запроса должны высвечивать 2 строки. 
SELECT ProductName
FROM Products
WHERE ProductName 
LIKE '%cho_olade%'

--5.1 Найти общую сумму всех заказов из таблицы Order Details с учетом количества закупленных товаров и скидок по ним. Результат округлить до сотых и высветить в стиле 1 для типа
--данных money.  Скидка (колонка Discount) составляет процент из стоимости для данного товара. Для определения действительной цены на проданный продукт надо вычесть скидку из
--указанной в колонке UnitPrice цены. Результатом запроса должна быть одна запись с одной колонкой с названием колонки 'Totals'. 
SELECT ROUND(SUM((UnitPrice - UnitPrice * Discount) * Quantity),2) AS 'Totals'
FROM [Order Details]

--5.2 По таблице Orders найти количество заказов, которые еще не были доставлены (т.е. в колонке ShippedDate нет значения даты доставки). Использовать при этом запросе только 
--оператор COUNT. Не использовать предложения WHERE и GROUP. 
SELECT COUNT(*) - COUNT(ShippedDate) 
AS 'Not shipped'
FROM Orders

--5.3 По таблице Orders найти количество различных покупателей (CustomerID), сделавших заказы. Использовать функцию COUNT и не использовать предложения WHERE и GROUP. 
SELECT COUNT(DISTINCT CustomerID) 
AS 'Unique customers'
FROM Orders

--6.1 По таблице Orders найти количество заказов с группировкой по годам. В результатах запроса надо высвечивать две колонки c названиями Year и Total. Написать проверочный запрос,
--который вычисляет количество всех заказов.
SELECT YEAR(OrderDate) AS 'Year', COUNT(OrderID) AS 'Total'
FROM Orders
GROUP BY (YEAR(OrderDate))

SELECT COUNT(*) AS 'Total'
FROM Orders

--6.2 По таблице Orders найти количество заказов, cделанных каждым продавцом. Заказ для указанного продавца – это любая запись в таблице Orders, где в колонке EmployeeID задано
--значение для данного продавца. В результатах запроса надо высвечивать колонку с именем продавца (Должно высвечиваться имя полученное конкатенацией LastName & FirstName. Эта строка
--LastName & FirstName должна быть получена отдельным запросом в колонке основного запроса. Также основной запрос должен использовать группировку по EmployeeID.) с названием колонки 
--‘Seller’ и колонку c количеством заказов высвечивать с названием 'Amount'. Результаты запроса должны быть упорядочены по убыванию количества заказов. 
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

--6.3 По таблице Orders найти количество заказов, cделанных каждым продавцом и для каждого покупателя. Необходимо определить это только для заказов сделанных в 1998 году. В 
--результатах запроса надо высвечивать колонку с именем продавца (название колонки ‘Seller’), колонку с именем покупателя (название колонки ‘Customer’)  и колонку c количеством 
--заказов высвечивать с названием 'Amount'. В запросе необходимо использовать специальный оператор языка T-SQL для работы с выражением GROUP (Этот же оператор поможет выводить 
--строку “ALL” в результатах запроса). Группировки должны быть сделаны по ID продавца и покупателя. Результаты запроса должны быть упорядочены по продавцу, покупателю и по убыванию 
--количества продаж. В результатах должна быть сводная информация по продажам. Т.е. в резульирующем наборе должны присутствовать дополнительно к информации о продажах продавца для 
--каждого покупателя
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

--6.4 Найти покупателей и продавцов, которые живут в одном городе. Если в городе живут только один или несколько продавцов или только один или несколько покупателей, то информация 
--о таких покупателя и продавцах не должна попадать в результирующий набор. Не использовать конструкцию JOIN. В результатах запроса необходимо вывести следующие заголовки для 
--результатов запроса: ‘Person’, ‘Type’ (здесь надо выводить строку ‘Customer’ или  ‘Seller’ в завимости от типа записи), ‘City’. Отсортировать результаты запроса по колонке ‘City’ 
--и по ‘Person’.
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

--6.5 Найти всех покупателей, которые живут в одном городе. В запросе использовать соединение таблицы Customers c собой - самосоединение. Высветить колонки CustomerID и City.
--Запрос не должен высвечивать дублируемые записи. Для проверки написать запрос, который высвечивает города, которые встречаются более одного раза в таблице Customers. Это позволит
--проверить правильность запроса.
SELECT c1.CustomerID, c1.City
FROM Customers AS c1 JOIN Customers AS c2
ON c1.City = c2.City AND c1.CustomerID <> c2.CustomerID
GROUP BY c1.City, c1.CustomerID

--Проверочный запрос
SELECT City, COUNT(*) AS 'Count'
FROM Customers
GROUP BY City
HAVING COUNT(*) > 1

--6.6 По таблице Employees найти для каждого продавца его руководителя, т.е. кому он делает репорты. Высветить колонки с именами 'User Name' (LastName) и 'Boss'. В колонках должны
--быть высвечены имена из колонки LastName. Высвечены ли все продавцы в этом запросе?
SELECT e1.LastName AS 'User Name' ,e2.LastName AS 'Boss'
FROM Employees e1 JOIN Employees e2
ON e1.ReportsTo = e2.EmployeeID

--Проверочный запрос
Select LastName
From Employees
--Не высвечен Fuller, т.к. он никому не делает репорты (нет руководитедля).

--7.1 Определить продавцов, которые обслуживают регион 'Western' (таблица Region). Результаты запроса должны высвечивать два поля: 'LastName' продавца и название обслуживаемой 
--территории ('TerritoryDescription' из таблицы Territories). Запрос должен использовать JOIN в предложении FROM. Для определения связей между таблицами Employees и Territories 
--надо использовать графические диаграммы для базы Northwind.
SELECT e.LastName, t.TerritoryDescription
FROM EmployeeTerritories et INNER JOIN Employees e
ON et.EmployeeID = e.EmployeeID
INNER JOIN Territories t
ON et.TerritoryID = t.TerritoryID

--8.1 Высветить в результатах запроса имена всех заказчиков из таблицы Customers и суммарное количество их заказов из таблицы Orders. Принять во внимание, что у некоторых заказчиков
--нет заказов, но они также должны быть выведены в результатах запроса. Упорядочить результаты запроса по возрастанию количества заказов.
SELECT c.ContactName, COUNT(o.OrderID) AS 'Sum'
FROM Customers AS c LEFT JOIN Orders AS o
ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.ContactName
ORDER BY Sum

--9.1 Высветить всех поставщиков колонка CompanyName в таблице Suppliers, у которых нет хотя бы одного продукта на складе (UnitsInStock в таблице Products равно 0). Использовать 
--вложенный SELECT для этого запроса с использованием оператора IN. Можно ли использовать вместо оператора IN оператор '=' ?
SELECT CompanyName
FROM Suppliers
WHERE SupplierID IN
	(SELECT SupplierID
		FROM Products
		WHERE UnitsInStock = 0)

--10.1 Высветить всех продавцов, которые имеют более 150 заказов. Использовать вложенный коррелированный SELECT.
SELECT EmployeeID  
FROM Employees AS e
WHERE (SELECT COUNT(OrderID) 
        FROM Orders AS o
        WHERE e.EmployeeID = o.EmployeeID) > 150;

--11.1 Высветить всех заказчиков (таблица Customers), которые не имеют ни одного заказа (подзапрос по таблице Orders). Использовать коррелированный SELECT и оператор EXISTS.
SELECT ContactName 
FROM Customers
WHERE EXISTS 
	(SELECT EmployeeID 
	FROM Orders
	WHERE ShippedDate IS NULL);

--12.1 Для формирования алфавитного указателя Employees высветить из таблицы Employees список только тех букв алфавита, с которых начинаются фамилии Employees (колонка LastName ) 
--из этой таблицы. Алфавитный список должен быть отсортирован по возрастанию.
SELECT DISTINCT SUBSTRING(LastName,1,1) AS 'ALPH'
FROM Employees
ORDER BY 'ALPH'

--13.1 Написать процедуру, которая возвращает самый крупный заказ для каждого из продавцов за определенный год. В результатах не может быть несколько заказов одного продавца, должен 
--быть только один и самый крупный. В результатах запроса должны быть выведены следующие колонки: колонка с именем и фамилией продавца (FirstName и LastName – пример: Nancy Davolio),
--номер заказа и его стоимость. В запросе надо учитывать Discount при продаже товаров. Процедуре передается год, за который надо сделать отчет, и количество возвращаемых записей.
--Результаты запроса должны быть упорядочены по убыванию суммы заказа. Процедура должна быть реализована с использованием оператора SELECT и БЕЗ ИСПОЛЬЗОВАНИЯ КУРСОРОВ. 
EXEC GreatestOrders @YEAR = 1998, @COUNT = 5
--Проверочный запрос
SELECT e.FirstName + ' ' + e.LastName AS 'Name', od.OrderID,
	od.UnitPrice * od.Quantity * (1 - od.Discount) AS 'Price'
FROM Employees AS e
JOIN Orders AS o
	ON e.EmployeeID = o.EmployeeID
JOIN [Order Details] AS od
	ON o.OrderID = od.OrderID
WHERE YEAR(o.OrderDate) = '1998'
ORDER BY Price DESC

--13.2 Написать процедуру, которая возвращает заказы в таблице Orders, согласно указанному сроку доставки в днях (разница между OrderDate и ShippedDate).  В результатах должны 
--быть возвращены заказы, срок которых превышает переданное значение или еще недоставленные заказы. Значению по умолчанию для передаваемого срока 35 дней. Название процедуры 
--ShippedOrdersDiff. Процедура должна высвечивать следующие колонки: OrderID, OrderDate, ShippedDate, ShippedDelay (разность в днях между ShippedDate и OrderDate), SpecifiedDelay 
--(переданное в процедуру значение).  Необходимо продемонстрировать использование этой процедуры.
EXEC ShippedOrdersDiff @DAY = 7

--13.3 Написать процедуру, которая высвечивает всех подчиненных заданного продавца, как непосредственных, так и подчиненных его подчиненных. В качестве входного параметра функции
--используется EmployeeID. Необходимо распечатать имена подчиненных и выровнять их в тексте (использовать оператор PRINT) согласно иерархии подчинения. Продавец, для которого надо
--найти подчиненных также должен быть высвечен. Название процедуры SubordinationInfo. В качестве алгоритма для решения этой задачи надо использовать пример, приведенный в Books 
--Online и рекомендованный Microsoft для решения подобного типа задач. Продемонстрировать использование процедуры.





