--Cheking the imported data set

SELECT *
FROM Portfolio..listings_berlin;

-- Counting columns in data set

USE Portfolio;
exec sp_help 'Portfolio..listings_berlin';

 --Removing not useful columns

ALTER TABLE Portfolio..listings_berlin 
	DROP COLUMN 
	listing_url,
	scrape_id,
	last_scraped,
	[source],
	[description],
	neighborhood_overview,
	picture_url,
	host_url, 
	host_about, 
	host_response_time, 
	host_is_superhost, 
	host_thumbnail_url,
	host_picture_url, 
	host_verifications, 
	host_has_profile_pic, 
	host_identity_verified, 
	host_neighbourhood, 
	amenities, 
	calendar_updated, 
	has_availability, 
	availability_30,
	availability_60, 
	availability_90, 
	number_of_reviews_ltm,
	number_of_reviews_l30d, 
	first_review,  
	review_scores_accuracy, 
	review_scores_cleanliness,
	review_scores_checkin, 
	review_scores_communication, 
	review_scores_location, 
	review_scores_value, 
	license,
	instant_bookable,
	bathrooms;

-- Counting columns in data set

USE Portfolio;
exec sp_help 'Portfolio..listings_berlin'

 -- Removing duplicates in data set

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY id, neighbourhood, latitude, longitude
				 ORDER BY id
					) AS row_num
	FROM Portfolio..listings_berlin
)

--SELECT * for checking the row number
DELETE
FROM RowNumCTE
WHERE row_num > 1;
--ORDER BY [name]

-- Deleting NULL values in price and beds columns for future visualization
-- Also deleting rows where the minimum_nights are not 1, for visualization

DELETE FROM Portfolio..listings_berlin
WHERE price IS NULL;

DELETE FROM Portfolio..listings_berlin 
WHERE beds IS NULL;

DELETE FROM Portfolio..listings_berlin 
WHERE minimum_nights != 1;

-- Modifying bathrooms_text column

-- Creating syntax

SELECT bathrooms_text,
CASE WHEN bathrooms_text = 'Half-bath' THEN '1 half-bath'
	WHEN bathrooms_text = 'Private half-bath' THEN '1 private half-bath'
	WHEN bathrooms_text = 'Shared half-bath' THEN '1 shared half-bath'
	WHEN bathrooms_text = '0 shared baths' THEN '0'
	WHEN bathrooms_text = '0 baths' THEN '0'
	ELSE bathrooms_text + ''
	END
FROM Portfolio..listings_berlin;

-- Updating bathrooms_text column

UPDATE Portfolio..listings_berlin
SET bathrooms_text =
CASE WHEN bathrooms_text = 'Half-bath' THEN '1 half-bath'
	WHEN bathrooms_text = 'Private half-bath' THEN '1 private half-bath'
	WHEN bathrooms_text = 'Shared half-bath' THEN '1 shared half-bath'
	WHEN bathrooms_text = '0 shared baths' THEN '0'
	WHEN bathrooms_text = '0 baths' THEN '0'
	ELSE bathrooms_text + ''
	END
FROM Portfolio..listings_berlin;

SELECT bathrooms_text
FROM Portfolio..listings_berlin;

-- Extracting only number of baths from bathroom_text column

SELECT
    CAST(SUBSTRING(bathrooms_text, 1, CHARINDEX(' ', bathrooms_text)) AS FLOAT) AS baths_numeric
FROM Portfolio..listings_berlin;

ALTER TABLE Portfolio..listings_berlin
	ADD baths_split FLOAT;

UPDATE Portfolio..listings_berlin
SET baths_split = CAST(SUBSTRING(bathrooms_text, 1, CHARINDEX(' ', bathrooms_text)) AS FLOAT);

SELECT baths_split
FROM Portfolio..listings_berlin;

-- Modyfying host_location column to separate city and country

-- Separating city

SELECT 
	SUBSTRING(host_location, 1 ,
CASE WHEN CHARINDEX(', ', host_location) = 0 THEN LEN(host_location) 
ELSE CHARINDEX(', ', host_location) -1 END) AS host_city
FROM Portfolio..listings_berlin;

ALTER TABLE Portfolio..listings_berlin
	ADD host_city NVARCHAR(255);

UPDATE Portfolio..listings_berlin
SET host_city = SUBSTRING(host_location, 1 ,
CASE WHEN CHARINDEX(', ', host_location) = 0 THEN LEN(host_location) 
ELSE CHARINDEX(', ', host_location) -1 END) 
FROM Portfolio..listings_berlin;

SELECT host_city
FROM Portfolio..listings_berlin;

UPDATE Portfolio..listings_berlin
SET host_city = 'Not provided'
WHERE host_city = ''

-- Separating country

SELECT
	SUBSTRING(host_location, CHARINDEX(',', host_location) +1, LEN(host_location)) AS host_country
FROM Portfolio..listings_berlin;

ALTER TABLE Portfolio..listings_berlin
	ADD host_country NVARCHAR(255);

UPDATE Portfolio..listings_berlin
SET host_country = SUBSTRING(host_location, CHARINDEX(',', host_location) +1, LEN(host_location))
FROM Portfolio..listings_berlin;

SELECT host_country
FROM Portfolio..listings_berlin;

SELECT TRIM(host_country) AS host_country_trimmed
FROM Portfolio..listings_berlin;

ALTER TABLE Portfolio..listings_berlin
	ADD host_country_trimmed NVARCHAR(255);

UPDATE Portfolio..listings_berlin
SET host_country_trimmed = TRIM(host_country)
FROM Portfolio..listings_berlin;

SELECT host_country_trimmed
FROM Portfolio..listings_berlin;

-- Checking all the values in host_country for further data cleaning

SELECT DISTINCT host_country_trimmed FROM Portfolio..listings_berlin;

UPDATE Portfolio..listings_berlin
SET host_country_trimmed = 'United States'
WHERE LEN(host_country_trimmed) = 2; 

-- Further host_country_trimmed cleaning

UPDATE Portfolio..listings_berlin
SET host_country_trimmed = 'Not provided'
WHERE host_country_trimmed = ''

SELECT host_country_trimmed 
FROM Portfolio..listings_berlin;

SELECT *
FROM Portfolio..listings_berlin;

