-- creating Table.

CREATE TABLE uber_rides (
    
    vehicle_type VARCHAR(50) NOT NULL,
    pickup_location VARCHAR(100) NOT NULL,
    drop_location VARCHAR(100) NOT NULL,
    avg_vtat DECIMAL(10, 2),
    avg_ctat DECIMAL(10, 2),
    cancelled_rides_by_customer DECIMAL(10,2),
    reason_for_cancelling_by_customer VARCHAR(255),
    cancelled_rides_by_driver DECIMAL(10,2),
    driver_cancellation_reason VARCHAR(255),
    incomplete_rides DECIMAL(10,2),
    incomplete_rides_reason VARCHAR(255),
    booking_value DECIMAL(10,2),
    ride_distance DECIMAL(10, 2),
    driver_ratings DECIMAL(10, 1),
    customer_rating DECIMAL(10, 1),
    payment_method VARCHAR(50)
	);

------------- ------------- Overview/Analysis of Data.-------------- ------------

-- 1.Checking that all the rows are present.

SELECT COUNT(*) FROM uber_rides;

-- 2. All vehical type.

SELECT
DISTINCT vehicle_type 
FROM uber_rides;
 
-- 3. creting view 
CREATE VIEW rides_status
AS
(
SELECT	
      COUNT(*) AS total_ride_appeared,
	  
	  COUNT(CASE WHEN cancelled_rides_by_customer > 0 THEN 1 END)
	  		AS customer_cancelations,
	  
	  COUNT(CASE WHEN cancelled_rides_by_driver > 0  THEN 1 END) 
	  		AS driver_cancellations,
			  
	  COUNT(CASE WHEN incomplete_rides > 0 THEN 1 END) 
	  		AS incomplete_rides,
			  
	  COUNT(CASE WHEN cancelled_rides_by_customer > 0 THEN 1 END) + 
      COUNT(CASE WHEN cancelled_rides_by_driver > 0 THEN 1 END)
	  		AS  total_cancelled,
	  
	  count(*) -(COUNT(CASE WHEN cancelled_rides_by_customer > 0 THEN 1 END)+
	  COUNT(CASE WHEN cancelled_rides_by_driver > 0  THEN 1 END)) 
	  		AS attempted_rides,
			  
	  count(*) -(COUNT(CASE WHEN cancelled_rides_by_customer > 0 THEN 1 END)+
	  COUNT(CASE WHEN cancelled_rides_by_driver > 0  THEN 1 END)+
	  COUNT(CASE WHEN incomplete_rides > 0 THEN 1 END))
	  		AS completed_rides
	  
FROM  uber_rides)
;

SELECT * FROM rides_status;

-- 4. Ride Performance

SELECT
    ROUND((customer_cancelations * 100.0) / total_ride_appeared, 2) AS customer_cancel_rate,
    ROUND((driver_cancellations * 100.0) / total_ride_appeared, 2) AS driver_cancel_rate,
    ROUND((completed_rides * 100.0) / total_ride_appeared, 2) AS completion_rate,
	ROUND((incomplete_rides * 100.0)/ total_ride_appeared, 2) AS incompelete_ride_rate
FROM rides_status;


-- 4. Vehicle Type Analysis

select 
	vehicle_type,
	count(*) As total_rides
from uber_rides
group by vehicle_type
order by count(*) desc;

-- 5 . Revenue by Vehicle Type.

SELECT
    vehicle_type,
    COUNT(*) AS rides,
    SUM(booking_value) AS revenue
FROM uber_rides
GROUP BY vehicle_type
ORDER BY revenue DESC;

-- 6. Average Ride Distance by Vehicle
SELECT
    vehicle_type,
    ROUND(AVG(ride_distance),2) AS avg_distance
FROM uber_rides
GROUP BY vehicle_type
ORDER BY avg_distance DESC;

-- 7. Average Ratings by Vehicle
-- customer/driver cancellation reason and count of cancellation.

SELECT
    vehicle_type,
    ROUND(AVG(driver_ratings),2) AS avg_driver_rating,
    ROUND(AVG(customer_rating),2) AS avg_customer_rating
FROM uber_rides
GROUP BY vehicle_type;

-- 8. Top 10 Pickup Locations

SELECT
    pickup_location,
    COUNT(*) AS total_rides
FROM uber_rides
GROUP BY pickup_location
ORDER BY total_rides DESC
LIMIT 10;

-- 9. Top Drop Locations

SELECT
    drop_location,
    COUNT(*) AS total_rides
FROM uber_rides
GROUP BY drop_location
ORDER BY total_rides DESC
LIMIT 10;

-- 10 . Cancellation Reasons 


SELECT
    'Customer Cancellation' AS category,
    reason_for_cancelling_by_customer AS reason,
    COUNT(*) AS total
FROM uber_rides
WHERE cancelled_rides_by_customer > 0
GROUP BY reason_for_cancelling_by_customer

UNION ALL

SELECT
    'Driver Cancellation',
    driver_cancellation_reason,
    COUNT(*)
FROM uber_rides
WHERE cancelled_rides_by_driver > 0
GROUP BY driver_cancellation_reason

UNION ALL

SELECT
    'Incomplete Ride',
    incomplete_rides_reason,
    COUNT(*)
FROM uber_rides
WHERE incomplete_rides > 0
GROUP BY incomplete_rides_reason

ORDER BY total DESC;


-- 11 . Revenue by Payment Method.

select
       payment_method,
	   count(*) as no_of_use,
	   sum(booking_value) as total_amount
from uber_rides
where booking_value is not null
group by payment_method
order by sum(booking_value) desc;

-- 12. Operational Averages.

SELECT
    vehicle_type,
    ROUND(AVG(avg_vtat),2) AS avg_vtat,
    ROUND(AVG(avg_ctat),2) AS avg_ctat
FROM uber_rides
GROUP BY vehicle_type;
	   






	