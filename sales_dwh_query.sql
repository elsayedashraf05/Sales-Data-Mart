create database Sales_DWH;
use Sales_DWH;
go

-- Create DimCustomer Table
create table DimCustomer 
(
   CustomerID int primary key,
   FullName varchar(50),
   Phone varchar(50),
   Email varchar(50),
   GenderName varchar(50),
)

-- Create DimProduct Table

create table DimProduct (
   ProductID int primary key,
   ProductName varchar(50),
   Price Float,
   SubCategoryName varchar(50),
   CategoryName varchar(50),
)

-- Create DimSalesMan Table

create table DimSalesMan (
   SalesManID int primary key,
   FullName varchar(50),
   Email varchar(50),
   Phone varchar(50),
   City varchar(50),
)

-- Create Dim_Date Table

create table Dim_Date
(
  Date_SK int primary key,
  Full_Date date not null,
  Year int,
  Quarter int ,
  Month_Number int,
  Month_Name nvarchar(50),
  Day_of_Week int,
  Day_Name nvarchar(50),
  Day_of_Month int,
  Week_of_Year int,
  Is_Weekend bit
)

-- Create FactOrders Table

create table FactOrders (
  FactOrderSK int identity(1,1) primary key, -- Surgate key as order ID Is repititive
  OrderID int,
  ProductID int foreign key references DimProduct(ProductID),
  CustomerID int foreign key references DimCustomer(CustomerID),
  SalesManID int foreign key references DimSalesMan(SalesManID),
  Order_Date int foreign key references Dim_Date(Date_SK),
  Quantity float,
  TotalPrice float,
)


-- Simple stored procedure to populate date dimension
CREATE PROCEDURE sp_PopulateDateDimension
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    DECLARE @CurrentDate DATE = @StartDate;
    
    WHILE @CurrentDate <= @EndDate
    BEGIN
        INSERT INTO Dim_Date (
            Date_SK,
            Full_Date,
            Year,
            Quarter,
            Month_Number,
            Month_Name,
            Day_of_Week,
            Day_Name,
            Day_of_Month,
            Week_of_Year,
            Is_Weekend
        )
        VALUES (
            CONVERT(INT, FORMAT(@CurrentDate, 'yyyyMMdd')),
            @CurrentDate,
            YEAR(@CurrentDate),
            DATEPART(QUARTER, @CurrentDate),
            MONTH(@CurrentDate),
            DATENAME(MONTH, @CurrentDate),
            DATEPART(WEEKDAY, @CurrentDate),
            DATENAME(WEEKDAY, @CurrentDate),
            DAY(@CurrentDate),
            DATEPART(WEEK, @CurrentDate),
            CASE WHEN DATEPART(WEEKDAY, @CurrentDate) IN (1, 7) THEN 1 ELSE 0 END
        );
        
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
END;
GO


-- Populate dimensions
EXEC sp_PopulateDateDimension '2023-01-01', '2030-12-31';


select * from Dim_Date
select * from DimCustomer
select * from DimProduct
select * from DimSalesMan
select * from FactOrders
