------------------------------------------------------------
----SORGULARDA VERÝTABANI OLARAK NORTHWIND KULLNILMIÞTIR----
------------------------------------------------------------
--1.Çalýþan sayýsý listele
select count(*) AS calisanSayisi from Employees

--2.Çalýþan ad soyad birleþtir
select FirstName+ SPACE(1) + LastName AS [Ad Soyad]from Employees

--3.Kadýn çalýþanlarý listele
select * from Employees where TitleOfCourtesy in ('Ms.','Mrs.')

--4.Erkek çalýþanlarý listele
select FirstName + LastName AS adSoyad from Employees where TitleOfCourtesy ='Mr.'

--5.Erkek çalýþanlarýn sayýsýný listele
select count(*) from Employees where TitleOfCourtesy='Mr.'

--6.Çalýþanlar kaç farklý þehirde çalýþýyor listele
select distinct City from Employees

--7.Doðum tarihi 1960'dan büyük olan çalýþanlarý göster
select * from Employees where BirthDate > '1960'

--8.Adresi içinde House geçen kiþileri listele
select * from Employees where Address like '%house%'

--9.Çalýþanlarýn yaþlarýný bul
select DATEDIFF(YEAR,BirthDate,GETDATE()) from Employees 

--10.Region kolonu null olanlarý listele
select Region from Employees where Region is null

--11.Çalýþanlarýn adlarýný a>z sýrala
select FirstName from Employees order by FirstName ASC;

--12.Çalýþanlarýn ortalama yaþý
select AVG(DATEDIFF(Year,BirthDate,GETDATE())) AS YasORT from Employees

--13.Fax ve Region ý nullolan þirketler
select * from Customers where Region is null or Fax is null

--14.CustomerID leri AA ile biten müþterileri listele
select * from Customers where CustomerID like '%AA'

--15.Ürünlerin kdv dahil fiyatlarýný yazdýr
select UnitPrice*0.18 as KDV from Products 

--16.KdvSi 10 tlden düþük olan ürünler
select * from Products where ((UnitPrice*0.18) < 10)

--17.En pahalý 5 ürün
select Top 5 * from Products order by UnitPrice DESC;

--18.Stoðu olmayan ürünler kaç tanedir?
select COUNT(*) from Products where UnitsInStock='0' and UnitsInStock is null  

--19.Stoklarý 20 ile 50 arasýndaki ürünler listele
select * from Products where UnitsInStock>20 and UnitsInStock<50 order by UnitsInStock DESC

--20.Kaç çeþit ürün var
select count(*) from Products 

--21.Almanyadan ve Belçikadan ürün alan müþteriler
select ContactName, ShipCountry from Customers 
inner join Orders
on Customers.CustomerID=Orders.CustomerID;

--22.en pahalý ürünü göster
select TOP 1 * from Products order by UnitPrice DESC;

--23.ülkelere göre müþteri sayýlarý
select Country, count(CustomerID) AS Total from Customers group by Country;

--24.her kategoriden kaç tane ürün var
select * from Categories
select * from Products

select C.CategoryName, count(P.ProductID) AS total from Products AS P
inner join Categories AS C on P.CategoryID=C.CategoryID
group by CategoryName;

--25.çalýþanlar ne kadar satýþ yaptý
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

--26.Hangi sipariþ bana ne kadar kazandýrdý
select * from Orders
select * from [Order Details]

select OrderID, SUM(UnitPrice*Quantity*(1-Discount)) AS Kazanc from [Order Details] group by OrderID

--27.50den fazla satýþ yapan çalýþanlarýmý listele
select * from Employees
select * from Orders
select * from [Order Details]

select E.FirstName + E.LastName AS [Ad Soyad], Count(O.OrderID) AS Satis from Orders O
inner join Employees E on E.EmployeeID=O.EmployeeID
group by E.FirstName + E.LastName 
having Count(O.OrderID)>50

--28.100$ dan büyük ürünler
select * from Products

select ProductName, UnitPrice from Products  where UnitPrice>100

--29.Stok deðerleri 15in altýnda olan ürünlerin adý,fiyatý,stok bilgisi
select * from Products
select UnitsInStock, UnitPrice,ProductName,UnitPrice from Products where UnitPrice<15 

--30.Brezilyada bulunan müþterilerin adres,þehir,temsilci adý bilgileri
select ContactName, City, [Address] from Customers where Country='Brazil'

--31.Londra ve Paris müþterilerini listele
select * from Customers where City in ('London' , 'Paris')

--32. Adý A ile baþlayan müþterileri listele
select * from Customers where ContactName like 'a%'

--33. 50 lira ile 100 lira arasýndaki ürünleri listele
select ProductName from Products where UnitPrice  between 20 and 100

--34. Brezilyada olmayan müþterileri listele
select ContactName from Customers where Country!= 'Brasil'

--35.usa'den gelen sipariþlerin orderid, customerid al, koþul-> usa!!
SELECT OrderID, CustomerID FROM Orders WHERE ShipCountry = 'USA';

--36.Kaç farklý ülkeye ihracat yapýlýyor
select count (distinct ShipCountry) from Orders 

--37.ALFKI CustomerID'sine sahip müþterimin sipariþ sayýsý nedir?
select * from Customers
select count(OrderID) from Orders where CustomerID='ALFKI'

--38.En uzun isimli müþterimin adý nedir?
select TOP 1 ContactName, Len(ContactName) AS Uzunluk from Customers order by Uzunluk DESC;

--39. 1000den fazla satýlan ürünler hangisidir?
SELECT P.ProductID, P.ProductName, SUM(OD.Quantity) AS SatisAdedi 
FROM [Order Details] AS OD
INNER JOIN Products AS P ON P.ProductID = OD.ProductID
GROUP BY P.ProductID, P.ProductName
HAVING SUM(OD.Quantity) > 1000;

--40.sipariþlerin detaylarýný aldýðýn sorgu -> ürün adý,ürün adedi, müþteri adý

SELECT Customers.ContactName, Products.ProductName, SUM([Order Details].Quantity) AS TotalQuantity FROM Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
GROUP BY Customers.ContactName, Products.ProductName;

--41.1996 yýlýnýn son çeyreðinde meksikaya gönderilen ürünleri listele

SELECT Customers.CompanyName, Orders.OrderDate, Products.ProductName, [Order Details].Quantity
FROM Customers, Orders, [Order Details], Products
WHERE Customers.CustomerID = Orders.CustomerID
  AND Orders.OrderID = [Order Details].OrderID
  AND [Order Details].ProductID = Products.ProductID
  AND Customers.Country = 'Mexico'
  AND YEAR(Orders.OrderDate) = 1996
  AND DATEPART(QUARTER, Orders.OrderDate) = 4;

--42.sipariþi olmayan müþterilerin adý
SELECT ContactName , SUM([Order Details].Quantity) AS Total FROM Customers 
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
LEFT JOIN [Order Details] ON Orders.OrderID = [Order Details].OrderID 
WHERE [Order Details].Quantity is Null 
GROUP BY Customers.ContactName;


--43. Satýþý yapýlmayan ürünler listesi
select ProductName from Products	where Discontinued=1 and UnitsInStock>0

--44.Ortalama satýþ fiyatýndan ucuza satýlan ürünleri listele
select * from Products
select ProductName, UnitPrice from Products where UnitPrice < (select AVG(UnitPrice) from Products) 

--45.Sipariþ vermeyen kullanýcýlar
select * from Customers where CustomerID not in (select distinct CustomerID from Orders)

--46.hangi ürün hangi kategoride
select ProductName, CategoryName from Products P
inner join Categories C on P.CategoryID=C.CategoryID
group by ProductName, CategoryName

--47.Nakliyecilerin listesi
select CompanyName from Shippers

--48.Hangi çalýþan hangi bölgeden?
select * from Employees 
select * from EmployeeTerritories

--49.Hangi tedarikçi hangi ürünü saðlýyor?
select CompanyName, ProductName  from Suppliers S
inner join Products P on S.SupplierID=P.SupplierID 
group by CompanyName, ProductName 

--50.Beverages kategorisine ait ürünler
select * from Products
select * from Categories

select ProductName, CategoryName from Products P
inner join Categories C on P.CategoryID=C.CategoryID
group by ProductName, CategoryName 
having CategoryName='Beverages'

--51 Michael ya da Laura ile hemþehri olan çalýþanlar?
select * from Employees
select FirstName, City from Employees where City in ('Seattle','London')






