------------------------------------------------------------
----SORGULARDA VER�TABANI OLARAK NORTHWIND KULLNILMI�TIR----
------------------------------------------------------------
--1.�al��an say�s� listele
select count(*) AS calisanSayisi from Employees

--2.�al��an ad soyad birle�tir
select FirstName+ SPACE(1) + LastName AS [Ad Soyad]from Employees

--3.Kad�n �al��anlar� listele
select * from Employees where TitleOfCourtesy in ('Ms.','Mrs.')

--4.Erkek �al��anlar� listele
select FirstName + LastName AS adSoyad from Employees where TitleOfCourtesy ='Mr.'

--5.Erkek �al��anlar�n say�s�n� listele
select count(*) from Employees where TitleOfCourtesy='Mr.'

--6.�al��anlar ka� farkl� �ehirde �al���yor listele
select distinct City from Employees

--7.Do�um tarihi 1960'dan b�y�k olan �al��anlar� g�ster
select * from Employees where BirthDate > '1960'

--8.Adresi i�inde House ge�en ki�ileri listele
select * from Employees where Address like '%house%'

--9.�al��anlar�n ya�lar�n� bul
select DATEDIFF(YEAR,BirthDate,GETDATE()) from Employees 

--10.Region kolonu null olanlar� listele
select Region from Employees where Region is null

--11.�al��anlar�n adlar�n� a>z s�rala
select FirstName from Employees order by FirstName ASC;

--12.�al��anlar�n ortalama ya��
select AVG(DATEDIFF(Year,BirthDate,GETDATE())) AS YasORT from Employees

--13.Fax ve Region � nullolan �irketler
select * from Customers where Region is null or Fax is null

--14.CustomerID leri AA ile biten m��terileri listele
select * from Customers where CustomerID like '%AA'

--15.�r�nlerin kdv dahil fiyatlar�n� yazd�r
select UnitPrice*0.18 as KDV from Products 

--16.KdvSi 10 tlden d���k olan �r�nler
select * from Products where ((UnitPrice*0.18) < 10)

--17.En pahal� 5 �r�n
select Top 5 * from Products order by UnitPrice DESC;

--18.Sto�u olmayan �r�nler ka� tanedir?
select COUNT(*) from Products where UnitsInStock='0' and UnitsInStock is null  

--19.Stoklar� 20 ile 50 aras�ndaki �r�nler listele
select * from Products where UnitsInStock>20 and UnitsInStock<50 order by UnitsInStock DESC

--20.Ka� �e�it �r�n var
select count(*) from Products 

--21.Almanyadan ve Bel�ikadan �r�n alan m��teriler
select ContactName, ShipCountry from Customers 
inner join Orders
on Customers.CustomerID=Orders.CustomerID;

--22.en pahal� �r�n� g�ster
select TOP 1 * from Products order by UnitPrice DESC;

--23.�lkelere g�re m��teri say�lar�
select Country, count(CustomerID) AS Total from Customers group by Country;

--24.her kategoriden ka� tane �r�n var
select * from Categories
select * from Products

select C.CategoryName, count(P.ProductID) AS total from Products AS P
inner join Categories AS C on P.CategoryID=C.CategoryID
group by CategoryName;

--25.�al��anlar ne kadar sat�� yapt�
select * from Employees
select * from Orders
select * from [Order Details]

select E.FirstName+ space(1)+E.LastName, SUM(OD.Quantity) AS toplam from Employees AS E
inner join Orders AS O on E.EmployeeID=O.EmployeeID
inner join [Order Details] AS OD on O.OrderID=OD.OrderID
group by FirstName, LastName

--Test
select SUM(OD.Quantity) from Orders 
inner join [Order Details] AS OD on OD.OrderID=Orders.OrderID
where EmployeeID=5

--26.Hangi sipari� bana ne kadar kazand�rd�
select * from Orders
select * from [Order Details]

select OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS Kazanc from [Order Details] group by OrderID

--27.50den fazla sat�� yapan �al��anlar�m� listele
select * from Employees
select * from Orders
select * from [Order Details]

select E.FirstName + E.LastName AS [Ad Soyad], Count(O.OrderID) AS Satis from Orders O
inner join Employees E on E.EmployeeID=O.EmployeeID
group by E.FirstName + E.LastName 
having Count(O.OrderID)>50

--28.100$ dan b�y�k �r�nler
select * from Products

select ProductName, UnitPrice from Products  where UnitPrice>100

--29.Stok de�erleri 15in alt�nda olan �r�nlerin ad�,fiyat�,stok bilgisi
select * from Products
select UnitsInStock, UnitPrice,ProductName,UnitPrice from Products where UnitPrice<15 

--30.Brezilyada bulunan m��terilerin adres,�ehir,temsilci ad� bilgileri
select ContactName, City, [Address] from Customers where Country='Brazil'

--31.Londra ve Paris m��terilerini listele
select * from Customers where City in ('London' , 'Paris')

--32. Ad� A ile ba�layan m��terileri listele
select * from Customers where ContactName like 'a%'

--33. 50 lira ile 100 lira aras�ndaki �r�nleri listele
select ProductName from Products where UnitPrice  between 20 and 100

--34. Brezilyada olmayan m��terileri listele
select ContactName from Customers where Country!= 'Brasil'

--35.usa'den gelen sipari�lerin orderid, customerid al, ko�ul-> usa!!
SELECT OrderID, CustomerID FROM Orders WHERE ShipCountry = 'USA';

--36.Ka� farkl� �lkeye ihracat yap�l�yor
select count (distinct ShipCountry) from Orders 

--37.ALFKI CustomerID'sine sahip m��terimin sipari� say�s� nedir?
select * from Customers
select count(OrderID) from Orders where CustomerID='ALFKI'

--38.En uzun isimli m��terimin ad� nedir?
select TOP 1 ContactName, Len(ContactName) AS Uzunluk from Customers order by Uzunluk DESC;

--39. 1000den fazla sat�lan �r�nler hangisidir?
SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS SatisAdedi 
FROM [Order Details] AS OD
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductID, P.ProductName
HAVING SUM(OD.Quantity) > 1000;

--40.sipari�lerin detaylar�n� ald���n sorgu -> �r�n ad�,�r�n adedi, m��teri ad�

SELECT Customers.ContactName, Products.ProductName, SUM([Order Details].Quantity) AS TotalQuantity FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
GROUP BY Customers.ContactName, Products.ProductName;

--41.1996 y�l�n�n son �eyre�inde meksikaya g�nderilen �r�nleri listele

SELECT Customers.CompanyName, Orders.OrderDate, Products.ProductName, [Order Details].Quantity
FROM Customers, Orders, [Order Details], Products
WHERE Customers.CustomerID = Orders.CustomerID
  AND Orders.OrderID = [Order Details].OrderID
  AND [Order Details].ProductID = Products.ProductID
  AND Customers.Country = 'Mexico'
  AND YEAR(Orders.OrderDate) = 1996
  AND DATEPART(QUARTER, Orders.OrderDate) = 4;

--42.sipari�i olmayan m��terilerin ad�
SELECT ContactName , SUM([Order Details].Quantity) AS Total FROM Customers 
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
LEFT JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID 
WHERE [Order Details].Quantity is Null 
GROUP BY Customers.ContactName;


--43. Sat��� yap�lmayan �r�nler listesi
select ProductName from Products	where Discontinued=1 and UnitsInStock>0

--44.Ortalama sat�� fiyat�ndan ucuza sat�lan �r�nleri listele
select * from Products
select ProductName, UnitPrice from Products where UnitPrice < (select AVG(UnitPrice) from Products) 

--45.Sipari� vermeyen kullan�c�lar
select * from Customers where CustomerID not in (select distinct CustomerID from Orders)

--46.hangi �r�n hangi kategoride
select ProductName, CategoryName from Products P
inner join Categories C on P.CategoryID=C.CategoryID
group by ProductName, CategoryName

--47.Nakliyecilerin listesi
select CompanyName from Shippers

--48.Hangi �al��an hangi b�lgeden?
select * from Employees 
select * from EmployeeTerritories

--49.Hangi tedarik�i hangi �r�n� sa�l�yor?
select CompanyName, ProductName  from Suppliers S
inner join Products P on S.SupplierID=P.SupplierID 
group by CompanyName, ProductName 

--50.Beverages kategorisine ait �r�nler
select * from Products
select * from Categories

select ProductName, CategoryName from Products P
inner join Categories C on P.CategoryID=C.CategoryID
group by ProductName, CategoryName 
having CategoryName='Beverages'

--51 Michael ya da Laura ile hem�ehri olan �al��anlar?
select * from Employees
select FirstName, City from Employees where City in ('Seattle','London')






