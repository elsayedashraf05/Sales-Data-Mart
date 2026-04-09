use Sales_OLTP;

select * from Customer;

select * 
from Customer c left outer join Gender g 
on c.GenderID = g.GenderID

select * 
from Product

create view prod_view
as
select ProductID, ProductName, Price, SubCategoryName,CategoryID
from Product p left outer join SubCategory s
on p.SubCategoryID = s.SubCategoryID 

select * from prod_view

select ProductID, ProductName, Price, SubCategoryName,CategoryName
from prod_view p left outer join Category c
on p.CategoryID = c.CategoryID 

create view salesman_view
as
select SalesmanID as SalesManID, CONCAT(FirstName,' ',LastName) as FullName,Email,PhoneNumber as Phone,City 
from
Salesman s left outer join Address a
on s.AddressID = a.AddressID

select * from salesman_view;

select * from dbo.Orders;

create view order_view
as
select o.OrderID,ProductID,CustomerID,SalesmanID as SalesManID, OrderDate as Order_Date,Quantity,TotalPrice
from Orders o left outer join OrderDetails d 
on o.OrderID = d.OrderID

select * from order_view;
