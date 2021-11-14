/* Database TravelOnTheGo - totg*/

drop database  if exists `totg` ;

create database  `totg` ;

use `totg`;

create table if not exists PASSENGER 
(
Passenger_Name varchar(50),
Category varchar(6),
Gender varchar(1),
Boarding_City varchar(50),
Destination_City varchar(50),
Distance int,
Bus_Type varchar(10) );

create table if not exists PRICE (
Bus_Type varchar(10), 
Distance int ,
Price int,
unique(Bus_Type,Distance,Price)
);
-- ('Sitting',500, 620 ), 
-- Duplicate rows found and there for used unique(Bus_Type, Distance,Price) defined have table creation. 
Insert into PASSENGER  (Passenger_Name, Category,Gender, Boarding_City, Destination_City, Distance, Bus_Type)
values
('Sejal' , 'AC' ,'F' ,'Bengaluru','Chennai',350,'Sleeper') ,
('Anmol' , 'Non-AC' ,'M' ,'Mumbai','Hyderabad',700 ,'Sitting'),
('Pallavi' , 'AC' ,'F' ,'Panaji','Bengaluru',600,'Sleeper') ,
('Khusboo' , 'AC' ,'F' ,'Chennai','Mumbai',1500,'Sleeper') ,
('Udit' , 'Non-AC' ,'M' ,'Trivandrum','Panaji',1000,'Sleeper') ,
('Ankur' , 'AC' ,'M' ,'Nagpur','Hyderabad',500,'Sitting') ,
('Hemant' , 'Non-AC' ,'M' ,'Panaji','Mumbai',700,'Sleeper'),
('Manish' , 'Non-AC' ,'M' ,'Hyderabad','Bengaluru',500,'Sitting') ,
('Piyush', 'AC', 'M', 'Pune', 'Nagpur', 700, 'Sitting')
;

Insert into PRICE (Bus_Type, Distance,Price)
values 
('Sleeper', 350 ,770 ),
('Sleeper',500, 1100 ),
('Sleeper',600, 1320 ), 
('Sleeper',700, 1540 ),
('Sleeper',1000, 2200 ),
('Sleeper',1200, 2640 ),
('Sleeper',350, 434),
('Sitting',500, 620 ),
('Sitting',600 ,744 ),
('Sitting',700 ,868 ),
('Sitting',1000 ,1240 ),
('Sitting',1200, 1488 ),
('Sitting',1500 ,1860 );


-- Since in requrenment it was mention that for same distance, bus_type we can have differnt price
-- but found duplicate row and there for removed one while insertion.

-- Write queries for the following:
-- 3) How many females and how many male passengers travelled for a minimum distance of 600 KM s?
select case when Gender = 'M' then 'Male' else 'Female' end as Gender, count(Gender) as Total_Count  from Passenger
where Distance >= 600
group by Gender;

-- 4) Find the minimum ticket price for Sleeper Bus.
-- Select * from price ;
select MIN(Price) as Min_Price , Bus_Type from Price 
where Bus_Type = 'Sleeper';


-- 5) Select passenger names whose names start with character 'S'
Select Passenger_Name from Passenger
where Passenger_Name like 'S%';

/* 6) Calculate price charged for each passenger displaying Passenger name, Boarding City,
 Destination City, Bus_Type, Price in the output
In solution we used left outer join to get khusboo record and price is null. Since no entry found in price table.
*/

select ps.Passenger_Name , ps.Boarding_City,
ps.Destination_City, ps.Bus_Type , ps.distance, pr.Price from Passenger ps 
left outer join Price as pr  
on ps.Distance = pr.Distance and ps.Bus_Type = pr.Bus_Type;

/*
7) What is the passenger name and his/her ticket price who travelled in Sitting bus for a
distance of 1000 KM s 
*/

-- Ans - Zero rows returned since distance 1000 and above is travelled by passenger in only Sleeper bus_type in passenger table.

select ps.Passenger_Name , ps.Boarding_City, ps.Destination_City, ps.Bus_Type , pr.Price , ps.Distance
from Passenger  as ps left outer join Price as pr on (ps.Bus_Type = pr.Bus_Type and ps.Distance = pr.Distance)
where ps.Distance >= 1000 and ps.Bus_Type = 'Sitting';



-- 8) What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to Panaji?
-- Ans Pallavi is travlleing for 600 KM.  In passenger table its panji to banglore but price is only categorized by bus_type and distance.

-- Solution 1 - Only considering distance and price and excluding city in query.

select  ps.Passenger_Name , ps.Distance , pr.Bus_Type , pr.Price from Passenger  as ps join Price as pr on ps.Distance = pr.Distance
where ps.Passenger_Name = 'Pallavi';

-- Solution 2 - If we consider exact bording and destination city in where clause as per question for pallavi then it will return zero rows.

select  ps.Passenger_Name , ps.Distance , pr.Bus_Type , pr.Price , ps.Boarding_City, ps.Destination_City
 from Passenger  as ps join Price as pr on ps.Distance = pr.Distance
where ps.Passenger_Name = 'Pallavi'
and ps.Boarding_City = 'Bangalore' and ps.Destination_City = 'Panaji';

/* 9) List the distances from the "Passenger" table which are unique (non-repeated
distances) in descending order.*/

select distinct ps.Distance  from Passenger ps order by ps.Distance desc;

/* 10) Display the passenger name and percentage of distance travelled by that passenger
from the total distance travelled by all passengers without using user variables
*/
-- Solution 1
select p.Passenger_Name , p.Distance, round((p.Distance*100)/p.Total_Distance,2)  as Total_Compared_Percentage
, Total_Distance  from 
(select Passenger_Name , Distance , sum(distance)over() as Total_Distance from Passenger  ) as p;
-- Solution 2
with 
ps as (select Passenger_Name  , Distance , round((Distance/sum(Distance)over())*100,2) 
as Total_Compared_Percentage  from Passenger )
select * from ps;

/* 11) Display the distance, price in three categories in table Price
a) Expensive if the cost is more than 1000
 b) Average Cost if the cost is less than 1000 and greater than 500
c) Cheap otherwise
*/
select  Bus_Type, Distance , Price , 
case when  Price > 1000 then 'Expensive'
when Price > 500 then 'Average Cost'
else 'Cheap' end as Cost_Category
from Price;

