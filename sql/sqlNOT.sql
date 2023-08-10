--SQL--
---------------------------------------------------------------------
--NOTLAR ALINIRKEN ÖRNEK VERİTABANI OLARAK NORTHWIND KULLNILMIŞTIR.--
---------------------------------------------------------------------

--bütün kategorileri getir
select * from NORTHWND.dbo.Categories;
--kategori tablosunun içinden kategori sütununu getir
select CategoryName From Categories
--kisiler tablosunda soyad sutununu goster
select kisiler.soyad from kisiler
-- kisiler tablosundan ad soyadı birleştir sutun adına toplam de
select ad + soyad as toplam from kisiler;
--Customers tablosunda City sütununun Paris veya London olan ve OrderDate sütununun 2023-01-01 ile 2023-01-31 arasında olan tüm müşterileri seçer
SELECT * FROM Customers WHERE City IN ('Paris', 'London') AND OrderDate BETWEEN '2023-01-01' AND '2023-01-31';


--Northwnd veritabanını kullan, go alttaki komut için, kisiler tablosundan rumuzu z olanı sil
use NORTHWND
go
delete from kisiler where rumuz='z';


--Yeni veritabanı oluşturma bir data bir log dosyası oluşturur.
CREATE DATABASE YENIVT
ON PRIMARY
(
	Name, Filename, Size, Maxsize, Filegrowth
)
LOG ON
(
	Name, Filename, Size, Maxsize, Filegrowth
)


--kisiler adlı tablo oluştur
CREATE TABLE kisiler
(
	id int,
	ad varchar(255),
	soyad varchar(255),
	rumuz varchar(255),

);


--kisiler tablosuna doğum tarihi ekle
ALTER TABLE kisiler ADD dogumtarihi date

--kisiler tablosunu sil
DROP TABLE kisiler


--kisiler tablosuna değer ekle
insert into kisiler values('1','x','y','z');
insert into kisiler values('2','x2','y2','z2')


--update ile kisiler tablosunun 2 id numaralı kişinin rumuzu güncellendi. 
update kisiler set rumuz='z3' where id=2;


--login yaratmak
create login northlogin with password ='12345'
--user yaratmak
create user northuser for login northlogin;


--employe id ve last name alıp küçükten sırala
select EmployeeID, LastName from Employees order by EmployeeID ASC;
--employe id ve last name alıp büyükten sırala
select EmployeeID, LastName from Employees order by EmployeeID DESC;


--rumuz sutunu backuplandı
select kisiler.rumuz into kisiler_backup from kisiler;

select*from kisiler_backup  


--kisilerde firstnamei aynı olanları siler, teke indirir
select distinct firstname from kisiler


--londradaki çalışanları göster/union all tekrar farketmeksizin getirir ama union tekrar etmez
select * from Employees where City='london'
union all
select * from Employees where City='london'


--OR / AND 
SELECT * FROM Customers WHERE ContactName = 'Maria' OR ContactName = 'Ana';
SELECT * FROM Customers WHERE ContactName LIKE 'a%'; --yüzde iki yanda kelimenin herhangi yerinde geçsin


--TOP 4 ü gösterir
SELECT TOP 4 * FROM Customers


--CAST/Çalışanların doğum tarihlerini DATE veri türüne çevirme
SELECT FirstName, LastName, CAST(BirthDate AS DATE) AS BirthDate FROM Employees;
--Siparişler tablosundaki OrderDate alanını string olarak alıp DATE veri türüne çevirme
SELECT OrderID, CONVERT(DATE, OrderDate, 103) AS OrderDateFormatted FROM Orders;


-- Ürünler tablosundan 10 ile 20 arasında birim fiyatı olan ürünleri seç
SELECT * FROM Products WHERE UnitPrice BETWEEN 10 AND 20;

--Müşteriler tablosundan 'Germany' ve 'France' ülkeleri dışındaki müşterileri seç
SELECT * FROM Customers WHERE Country NOT IN ('Germany', 'France');


-- İsimlerin arasına boşluk ekleyerek yeni bir sütun oluşturma
SELECT FirstName, LastName, FirstName + SPACE(1) + LastName AS FullName FROM Employees;


-- Siparişler tablosundan sevk tarihi bilgisi olmayan siparişleri seç
SELECT * FROM Orders WHERE ShippedDate IS NULL;


-- Siparişler tablosundan sevk tarihi boş olan kayıtlar için sevk tarihi yerine sipariş tarihini kullan
SELECT OrderID, COALESCE(ShippedDate, OrderDate) AS ActualShipDate FROM Orders;


-- Siparişler tablosundan sevk tarihi ile teslim tarihi aynı olan kayıtları NULL olarak döndür
SELECT OrderID, NULLIF(ShippedDate, ShippedDate) AS NullIfShippedDate FROM Orders;

--------------------------------------------------------------------
--Primary Key / Foreign Key
--"Primary key" (birincil anahtar), bir tablodaki her bir satırın benzersiz bir şekilde tanımlandığı bir sütundur ve verilerin doğruluğunu sağlar. 
--"Foreign key" (yabancı anahtar) ise, farklı bir tabloya referans sağlayarak ilişkili veriler arasında bağlantı kurar ve veritabanındaki ilişkilerin sağlamlaştırılmasına yardımcı olur.
--primary key benzersizdir/"kisiler2" tablosuna "StudentID" adında bir foreign anahtar eklenmiştir ve bu foreign anahtar, 
--"Students" tablosunun "StudentID" alanına referans göstermektedir. Bu şekilde "kisiler2" tablosundaki "StudentID" alanı, 
--"Students" tablosunun birincil anahtarına bağlıdır ve iki tablo arasında bir ilişki kurulmuş olur.
CREATE TABLE kisiler3 (
    StudentID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
	 -- Yabancı anahtar eklemesi
    FOREIGN KEY (StudentID) REFERENCES kisiler3(StudentID)
);

--------------------------------------------------------------------

--Declare değişken oluşturur
DECLARE @myvar INT = 10;
DECLARE @name varchar(15);
set @name = 'Ali'
print 'Ali'

--Karar Yapıları, Begin/End parantez aç/kapa işlevi görür
--if/else
DECLARE @ORTALAMAFİYAT DECIMAL(15,2)
SELECT @ORTALAMAFİYAT=AVG(UnitPrice) FROM Products
PRINT 'ORTALAMA BİRİM FİYATI = ' + CAST(@ORTALAMAFİYAT AS VARCHAR(5))
IF(@ORTALAMAFİYAT<30)
BEGIN
    PRINT 'DÜŞÜK FİYAT'
END
ELSE
BEGIN
    PRINT 'YÜKSEK FİYAT'
END

--case yapısı
CASE WHEN koşul1 THEN sonuc
     WHEN koşul2 THEN sonuc
     ...
     ELSE sonuc
END

--case örnek
SELECT FirstName,HireDate, 'Durum' =
CASE 
    WHEN HireDate BETWEEN '1994-01-01' AND '1995-01-01' THEN 'Yeni Çalışan'
    WHEN HireDate BETWEEN '1993-01-01' AND '1994-01-01' THEN 'Eski Çalışan'
    WHEN HireDate BETWEEN '1992-01-01' AND '1993-01-01' THEN 'Çok Eski Çalışan'
END
FROM Employees;

--IF EXIST örnek
IF EXISTS (SELECT * FROM Categories WHERE CategoryName = 'Beverages')
    PRINT 'Beverages category exists.';
ELSE
    PRINT 'Beverages category does not exist.';




--@ sembolü, kullanıcı tarafından oluşturulan bir değişkeni temsil eder, oysa @@ sembolü, veritabanı tarafından oluşturulan bir değişkeni temsil eder.
--Server'da aktif olan bağlantıların sayısını döndürür
select @@CONNECTIONS


--row number satır sayısını gösterir/customer id ve orderdateleri getir bunların satır numaralarını al
select row_number() over(order by CustomerID) AS SatırNo, OrderDate From Orders;


--geçici tablo kopyalar
SELECT * INTO Customers_new FROM Customers;


--CAST ve CONVERT işlevleri, bir veri türünü başka bir veri türüne dönüştürmek için kullanılır. BKZ;aşağıdaki sorgu, bir tarihi bir metin tarihine dönüştürür:
SELECT CAST(GETDATE() AS VARCHAR(255));

--intersect ile iki farklı tablo karşılaştırılır.(mesela ortak müşteriler)
SELECT ContactName
FROM Customers
INTERSECT
SELECT ShipName
FROM Orders;

--except iki tabloyu karşılaştırır farklı sonuçları döndürür.(mesela farklı müşteriler)
SELECT ContactName
FROM Customers
EXCEPT
SELECT ShipName
FROM Orders;

--pivot:verileri yataydan dikeye dönüştürmek 
--unpivot: dikeyden yataya veri dönüşümü yapar

--------------------------------------------------------------------
--group by / order by
--group by 1250-1300 orderid/ group by all ise filtreleri dikkate almaz
select OrderID, CustomerID from orders where OrderID between 10250 and 10300 group by OrderID, CustomerID;

-- ProductName, QuantityPerUnit ve UnitPrice sütunlarına göre gruplandırılmış Products tablosundaki veriler olacak
SELECT ProductName, QuantityPerUnit, UnitPrice
FROM Products
GROUP BY ProductName, QuantityPerUnit, UnitPrice;

--sipariş detaylarını grupla
select * from [Order Details]
select UnitPrice, Discount, Count(*) AS adet from [Order Details] group by Discount, UnitPrice

--siparişleri grupla
select * from Orders
select EmployeeID, ShipVia, ShipCountry from Orders group by  EmployeeID, ShipVia, ShipCountry order by ShipVia DESC;

--çalışanları unvanlarına göre grupla ve k>b sırala
select * from Employees
select TitleOfCourtesy, Count(*) AS Adet  from Employees group by TitleOfCourtesy  order by Adet ASC;


--group by all için filtre yapmak istiyorsak having kullanmalıyız, syntax sıralaması where->groupby->having

--------------------------------------------------------------------

--AVG: Bir sütundaki değerlerin ortalamasını hesaplar. BKZ:aşağıdaki sorgu, Products tablosundaki UnitPrice sütunundaki değerlerin ortalamasını hesaplar:
SELECT AVG(UnitPrice)
FROM Products;
--SUM: Bir sütundaki değerlerin toplamını hesaplar. BKZ: aşağıdaki sorgu, Products tablosundaki UnitPrice sütunundaki değerlerin toplamını hesaplar:
SELECT SUM(UnitPrice)
FROM Products;
--COUNT: Bir sütundaki satır sayısını hesaplar. BKZ:aşağıdaki sorgu, Products tablosundaki ProductID sütunundaki satır sayısını hesaplar:
SELECT COUNT(ProductID)
FROM Products;
--MAX: Bir sütundaki en büyük değeri hesaplar. BKZ:aşağıdaki sorgu, Products tablosundaki UnitPrice sütunundaki en büyük değeri hesaplar:
SELECT MAX(UnitPrice)
FROM Products;
--MIN: Bir sütundaki en küçük değeri hesaplar. BKZ:aşağıdaki sorgu, Products tablosundaki UnitPrice sütunundaki en küçük değeri hesaplar:
SELECT MIN(UnitPrice)
FROM Products;

--------------------------------------------------------------------

--Math fonksiyonları 
--ABS: Mutlak değeri döndürür.
SELECT ABS(-5);
--SQRT: Kökü döndürür.
SELECT SQRT(25);
--LOG: Logaritmayı döndürür.
SELECT LOG(100);
--EXP: Exponansiyeli döndürür.
SELECT EXP(2);
--SIN: Sinüs değerini döndürür.
SELECT SIN(PI / 2);
--COS: Kosinüs değerini döndürür.
SELECT COS(PI / 2);
--TAN: Tanjant değerini döndürür.
SELECT TAN(PI / 4);
--ASIN: Sinüs ark değerini döndürür.
SELECT ASIN(1);
--CEILING: Bir sayıyı en yakın tam sayıya yuvarlar.
SELECT CEILING(3.14);
--FLOOR: Bir sayıyı en yakın tam sayıya aşağı yuvarlar.
SELECT FLOOR(3.14);
--ROUND: Bir sayıyı en yakın tam sayıya yuvarlar.
SELECT ROUND(3,14);
--MOD: Bir sayının bir başka sayı ile bölümünden kalanı döndürür.
SELECT MOD(10, 3);
--POWER: Bir sayıyı bir başka sayıya yükseltir.
SELECT POWER(2, 3);

--------------------------------------------------------------------

--GETDATE işlevi, geçerli tarih ve saati döndürür. 
SELECT GETDATE();
--DATEADD işlevi, bir tarihe belirli bir süre ekler.
SELECT DATEADD(DAY, 1, GETDATE());
--DATEDIFF işlevi, iki tarih arasındaki farkı hesaplar.
SELECT DATEDIFF(DAY, '2023-01-01', GETDATE());
--DATENAME işlevi, bir tarihten belirli bir tarih parçasını döndürür. 
SELECT DATENAME(DAY, GETDATE());
--DAY işlevi, bir tarihten gün sayısını döndürür. 
SELECT DAY(GETDATE());
--GETUTCDATE işlevi, UTC saat diliminde geçerli tarih ve saati döndürür.
SELECT GETUTCDATE();
--MONTH işlevi, bir tarihten ayı döndürür.
SELECT MONTH(GETDATE());
--YEAR işlevi, bir tarihten yılı döndürür.
SELECT YEAR(GETDATE());

--------------------------------------------------------------------

--İç İçe Sorgular, bir SQL sorgusunun içine başka bir SQL sorgusu yerleştirilerek kullanılan yapıları ifade eder. 
--1 Ağustos 1997'ten sonra sipariş vermemiş olan tüm müşterileri seç
SELECT * FROM Customers
WHERE CustomerID IN (SELECT CustomerID FROM Orders WHERE OrderDate > '1997-08-01');

--Customers tablosundan Almanya'da bulunan müşterileri seçiyoruz. İç içe sorguda ise [Order Details] ve Orders tablolarını kullanarak her bir müşterinin siparişlerinin toplam miktarını hesaplıyoruz. 
--İç içe sorgunun sonucu, her bir müşteri için toplam sipariş miktarını gösteren "TotalQuantity" sütunu olarak döner
SELECT ContactName, CompanyName, (
    SELECT SUM(Quantity)
    FROM [Order Details] od
    INNER JOIN Orders o ON od.OrderID = o.OrderID
    WHERE o.CustomerID = c.CustomerID
) AS TotalQuantity
FROM Customers c
WHERE Country = 'Germany';

--toplam quantity hesapla ve grupla
select * from [Order Details]
select ProductID, OrderID, (select SUM(Quantity) AS total from [Order Details]) AS TotalValue 
from [Order Details] group by ProductID, OrderID

--------------------------------------------------------------------

--JOIN'ler
--JOIN/INNER JOIN: tabloların kesişimi.

SELECT P.ProductName, P.QuantityPerUnit
FROM Products AS P
INNER JOIN Suppliers  AS S ON S.SupplierID=P.SupplierID;

--Left Join:Sol taraftaki tablo koşulsuz gelir sağ taraftaki tablodan sadece kesişimdeki kısım gelir 
SELECT * FROM ORDERS AS O
LEFT OUTER JOIN CUSTOMERS AS C ON C.CUSTOMERID=O.CUSTOMERID;

--Rigth Join:Sağ taraftaki tablo koşulsuz gelir sol taraftaki tablodan sadece kesişimdeki kısım gelir

SELECT * FROM ORDERS AS O
RIGHT OUTER JOIN CUSTOMERS AS C ON C.CUSTOMERID=O.CUSTOMERID;


-- Tedarikçilere ait ürünleri ürün adıyla birlikte listeleme (ürün olmasa da listele)
SELECT S.CompanyName, P.ProductName
FROM Suppliers AS S
RIGHT JOIN Products AS P ON S.SupplierID = P.SupplierID;


-- Müşterilere ait siparişleri müşteri adıyla birlikte listeleme (müşteri olmasa da listele)/Sol taraftaki tablonun tüm verilerini ve sağ taraftaki tabloya eşleşen verileri getirir
SELECT C.CompanyName, O.OrderID, O.OrderDate
FROM Customers AS C
LEFT JOIN Orders AS O ON C.CustomerID = O.CustomerID;

--customers tablosundaki id sütununun orders tablosundaki customer_id sütununa eşit olduğu ve customers tablosundaki country sütununun orders tablosundaki country sütununa eşit olduğu satırları seçer
SELECT * FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
    AND Customers.Country = Orders.ShipCountry;

--category ve orderdetails den categorname&quantity birleştir
select * from Categories
select * from [Order Details]

select Categories.CategoryName, [Order Details].Quantity from Categories
inner join [Order Details] on Categories.CategoryID=[Order Details].ProductID;

select Categories.CategoryName, [Order Details].Quantity from Categories
right join [Order Details] on Categories.CategoryID=[Order Details].ProductID;

select Categories.CategoryName, [Order Details].Quantity from Categories
left join [Order Details] on Categories.CategoryID=[Order Details].ProductID;



--------------------------------------------------------------------
















