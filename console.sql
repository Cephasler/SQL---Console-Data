/* Using where, round */
select *, round(NA_Sales+EU_Sales+JP_Sales+Other_Sales,2) as Total_Sales from console where Publisher = 'Nintendo';


/* Using round, sum, group by, order by and limit*/
select Publisher, round(sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales),2) as Total_Sales 
from console group by Publisher
order by Total_Sales desc
Limit 5;

/* Calculating % of global sales that were made in the respective regions */
select round((select sum(NA_Sales) from console)/sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales)*100,2) as NA_pct,
round((select sum(EU_Sales) from console)/sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales)*100,2) as EU_pct,
round((select sum(JP_Sales) from console)/sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales)*100,2) as JP_pct,
round((select sum(Other_Sales) from console)/sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales)*100,2) as Other_pct
from console;

/* Extract a view of the console game titles ordered by platform name in ascending order and year of release in descending order */
select Name as Title, Platform, Year from console
order by Platform asc, Year desc;

/* For each game title extract the first four letters of the publisher's name */
select Name, substring(Publisher,1,4) as Publisher from console;


/* List the games and count the number of times that it has been published; include the total sales */
select Name, round(sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales),2) as Total_Sales, count(*) as Times
from console group by Name
order by Times desc;


/* Using CTE to perform calculation using the previous table; finding only the LEGO movies */
With cte as 
(select Name, round(sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales),2) as Total_Sales, count(*) as Times
from console group by Name
order by Times desc)

Select * from cte where Name like '%LEGO%';


/* Creating a view with just sports games, followed by using the view to select the group by platform an publisher and totalling the sales*/
Create view sports as
select * from console where Genre = 'Sports';
select Platform, Publisher, round(sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales),2) as Total_Sales from sports
group by Platform, Publisher
order by Total_Sales desc;



/* Creating another view to demonsrate join */
Create view platform as
select Platform, round(sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales),2) as Total_Sales from console
group by Platform
order by Total_Sales desc;

/* Joining a cte table derived from sports to the platform view */
With cte1 as
(select Platform, round(sum(NA_Sales+EU_Sales+JP_Sales+Other_Sales),2) as Sports_Sales from sports
group by Platform
order by Sports_Sales desc
)

select cte1.Platform, cte1.Sports_Sales, p.Total_Sales, round((cte1.Sports_Sales/p.Total_Sales)*100,2) as sports_pct from cte1
join platform p
on p.platform = cte1.platform;


/* Ranking each game based on NA_Sales within its platform within the console table as an add-on and listing only the top 5 in each platform */
select *, rank() over (partition by platform order by NA_Sales) as ranking
from console
where (select rank() over (partition by platform order by NA_Sales) as ranking from console) <= 5;


/* Converting the platform view into a saved table with defined varaibles */

DROP Table if exists platform_save;
Create Table platform_save
( Platform nvarchar(255),
Total_Sales float(24)
);

insert into platform_save
Select * from platform;
