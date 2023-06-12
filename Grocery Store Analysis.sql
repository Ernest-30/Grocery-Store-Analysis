USE Grocery_store
--------------------------------------------------------------------------------------------------------------------------------------------
/* Cleaning the Date columns, Getting the Duration before Shipping and spliting the Order_Date column into Day, Month and Year */

/*Standardizing the Date column */

UPDATE [Sales Records]
SET Order_Date = CONVERT (Date, Order_Date),
	Ship_Date = CONVERT (Date, Ship_Date)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Adding The Day, Month,Year, Quarter, Duration and IsWeekend Column */


ALTER TABLE [Sales Records]
ADD [Day] VARCHAR (255);  
UPDATE [Sales Records]
SET [Day] = DATENAME(WEEKDAY, Order_Date)


ALTER TABLE [Sales Records]
ADD [Month] VARCHAR (255);  
UPDATE [Sales Records]
SET [Month] = DATENAME(Month, Order_Date)


ALTER TABLE [Sales Records]
ADD [Year] INT;  
UPDATE [Sales Records]
SET [Year] = YEAR (Order_Date)


ALTER TABLE [Sales Records]
ADD Duration INT;  
UPDATE [Sales Records]
SET Duration = DATEDIFF (Day,Order_Date,Ship_Date)


ALTER TABLE [Sales Records]
ADD IsWeekend VARCHAR (255);
UPDATE [Sales Records]
SET IsWeekend = CASE 
				WHEN DATEPART(WEEKDAY, Order_Date) IN (1,7) THEN 'Yes' 
				ELSE 'No'
				END

ALTER TABLE [Sales Records]
ADD [Quarter] NVARCHAR (255);
UPDATE [Sales Records]
SET [Quarter] = CASE
				WHEN DATEPART(QUARTER,Order_Date) = 1 THEN 'Q1'
				WHEN DATEPART(QUARTER,Order_Date) = 2 THEN 'Q2'
				WHEN DATEPART(QUARTER,Order_Date) = 3 THEN 'Q3'
				WHEN DATEPART(QUARTER,Order_Date) = 4 THEN 'Q4'
				END

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* What is the Overall Sales Performance by Year? */

SELECT [Year],COUNT ([Order_ID]) AS Total_Orders, 
		ROUND(SUM([Total_Cost]),0) AS Total_COGS,
		SUM(Units_Sold) AS Quantity_Sold,
		ROUND (SUM(Total_Profit),0) AS Total_Profit,
		ROUND (SUM(Total_Revenue),0) AS Total_Revenue
FROM [Sales Records]
GROUP BY [YEAR]
ORDER BY 6 DESC

/* The year 2011 stands out as the highest-performing year, demonstrating exceptional sales growth. 
Conversely, 2017 experienced the lowest sales figures, reflecting a challenging period for the company. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Which month recorded the highest sales activities? */

SELECT [Month],COUNT ([Order_ID]) AS Total_Orders,
		SUM(Units_Sold) AS Quantity_Sold,
		ROUND (SUM(Total_Profit),0) AS Total_Profit,
		ROUND (SUM(Total_Revenue),0) AS Total_Revenue
FROM [Sales Records]
GROUP BY [Month]
ORDER BY 5 DESC

/* May emerges as the top-performing month, exhibiting remarkable sales performance. It showcases the 
highest sales figures compared to other months, highlighting its significance in driving business success. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Which day has the highest revenue contribution? */

SELECT [Day],COUNT ([Order_ID]) AS Total_Orders,
		SUM(Units_Sold) AS Quantity_Sold,
		ROUND (SUM(Total_Profit),0) AS Total_Profit,
		ROUND (SUM(Total_Revenue),0) AS Total_Revenue		
FROM [Sales Records]
GROUP BY [Day]
ORDER BY 5 DESC

/* Friday takes the lead in terms of revenue contribution, making it the most lucrative day of the week. Its strong performance 
establishes Friday as the top revenue-generating day, showcasing its significance in driving business success. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* What is the overall revenue trend in 2015? */

/* Revenue by Quarters in 2015 */

SELECT[Quarter], ROUND(SUM(Total_Revenue),0) AS Revenue
FROM [Sales Records]
WHERE [Year] = 2015
GROUP BY [Quarter]
ORDER BY 2 DESC

/* Q1 accounts for the highest revenue generated in 2015, while the least revenue generated was in Q2. */                                                                                                                                                                                          

/* Revenue by Months in 2015 */
SELECT [Month],ROUND (SUM(Total_Revenue),0) AS Total_Revenue
FROM [Sales Records]
WHERE [Year] = 2015
GROUP BY [Month]
ORDER BY 2 DESC

/* January emerges as the month with the highest revenue, fueled by increased consumer spending during the Christmas and New Year holiday season. 
Conversely, February experiences the lowest revenue, reflecting a decline in purchasing activity after the festive period. */

/* Revenue by Day in 2015 */
SELECT [Day],ROUND (SUM(Total_Revenue),0) AS Total_Revenue
FROM [Sales Records]
WHERE [Year] = 2015
GROUP BY [Day]
ORDER BY 2 DESC

/* In 2015, Fridays stood out as the day with the highest revenue generated, indicating strong sales performance and customer activity. 
On the other hand, Thursdays recorded the lowest revenue, suggesting comparatively lower sales during that day of the week. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* What it the Percentage of Orders received during Weekends? */ 

SELECT COUNT ([Order_ID]) AS Total_Orders,
		SUM(CASE WHEN IsWeekend = 'Yes' THEN 1 ELSE 0 END) AS Weekend_Orders,
		(SUM(CASE WHEN IsWeekend = 'Yes' THEN 1 ELSE 0 END)*100)/ COUNT ([Order_ID]) AS Percentage_of__Weekend_Orders
FROM [Sales Records]

/* 28% of the total orders received came in during weekends */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Where is the most profitable Region? */

SELECT Region,COUNT ([Order_ID]) AS Total_Orders,
		SUM(Units_Sold) AS Quantity_Sold,
		ROUND (SUM(Total_Revenue),0) AS Total_Revenue,
		ROUND (SUM(Total_Profit),0) AS Total_Profit		
FROM [Sales Records]
GROUP BY Region
ORDER BY 5 DESC

/* The Sub-Saharan Africa region stands out as the most lucrative, showcasing the highest number of received orders, units sold, revenue generated, and profit earned. 
This indicates a strong market presence and successful performance in that region. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* What is the Percentage of Orders with late delivery (45 days and above)? */

SELECT COUNT (Order_ID) AS Total_Orders, 
		SUM(CASE WHEN [Duration] >= 45 THEN 1 ELSE 0 END) AS Late_Delivery,
		SUM(CASE WHEN [Duration] >= 45 THEN 1 ELSE 0 END)*100/COUNT (Order_ID) AS Late_Percentage
FROM [Sales Records]

/* Approximately 11% of the total orders received experienced delayed shipping, indicating a need for improved logistics and fulfillment processes to ensure timely delivery. 
Efforts should be made to minimize such delays and enhance the overall customer experience by focusing on efficient shipping practices. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* Which Country has the Fastest Order processing to Shipping? */

SELECT TOP 5 Country, AVG(Duration) AS Avg_Duration_Days
FROM [Sales Records]
GROUP BY Country
ORDER BY 2

/* The countries with the fastest order processing to shipping time on the average are Vietnam, Dominica and Kazakhstan where orders are processed and shipped within 22 days, 
ensuring prompt delivery to customers. This efficient process reflects a streamlined logistics operation and a commitment to delivering orders in a timely manner. */    


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* What is the Top performing Item Type by Revenue? */

SELECT Item_Type, ROUND(SUM(Total_Revenue),0) As Revenue
FROM [Sales Records]
GROUP BY Item_Type
ORDER BY 2 DESC

/* Household items have emerged as the top-performing category in terms of revenue, showcasing their strong demand and profitability. On the other hand, fruits items have 
shown comparatively lower performance in terms of revenue, suggesting potential areas for improvement or adjustments in pricing, marketing, or product offerings within this category. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/* What is the Order Contribution by Sales Channel on the Top Performing Item by Revenue? */

SELECT Sales_Channel, COUNT (Order_ID) AS Total_Orders 
FROM [Sales Records]
WHERE Item_Type = 'Household'
GROUP BY Sales_Channel

/* The offline channel has slightly contributed more than the online channel in terms of the number of orders received for the top-performing item (household) in terms of revenue. 
This indicates that customers are still inclined towards traditional brick-and-mortar stores when purchasing household items, despite the growing popularity of online shopping. */

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

