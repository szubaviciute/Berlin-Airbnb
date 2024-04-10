# Berlin Airbnb

### Overview

This data analysis project aims to provide insights into the Airbnb house listings in Berlin for one night stay. By analyzing various aspects of the listings I aimed to identify trends and gain a deeper understanding of the Berlin Airbnb status and how it might be affected by neighbourhood group, room type, bathroom number and other 

![Dashboard 1](https://github.com/szubaviciute/Berlin-Airbnb/assets/159541216/e6612464-9a6b-4a41-b8e4-1b5fc2cf1ffd)

### Data sources

The primary dataset used for this analysis is the "listings.csv" file, containing detailed information about each listing in Berlin. The data were scraped from officials of Airbnb (https://insideairbnb.com/get-the-data)

### Tools

- MS SQL - Data Cleaning, analysis 
- Tableau Public - Visualization

### Data Cleaning/Preparation

The initial data preparation phase included following tasks:

- Data loading and inspection
- Removing duplicates and not useful columns
- Handling NULL values
- Column formatting and data cleaning

### Exploratory Data Analysis

EDA involved exploring the Berlin Airbnb listing data to answer key questions, such as:

1. Which month has the most bookings in a year by neighbourhood group 
2. What is the average price for one night stay by neighbourhood group
3. What neighbourhood group has the most listings for one night stay

### Data Analysis snippet

``` sql
UPDATE Portfolio..listings_berlin
SET host_city = SUBSTRING(host_location, 1 ,
CASE WHEN CHARINDEX(', ', host_location) = 0 THEN LEN(host_location) 
ELSE CHARINDEX(', ', host_location) -1 END) 
FROM Portfolio..listings_berlin;

SELECT host_city
FROM Portfolio..listings_berlin;
```

### Results

The analysis results are summarized as follows:
1. December has undoubtedly the most housings booked compared with other months where the most popular neighbourhood group is Friedrichshain-Kreuzberg
2. The most expensive neighbourhood group is Mitte with 153 € average listing price for one night, while the least expensive is Reinickendorf with 69 € average listing price
3. Neighbourhood group with the top listings for one night is Mitte with total 278 housing listing for one night stay

### Recommendations

Based on the performed analysis, it seems that:

1. Christmas holiday season is the most booked in Berlin, thus the planning for holiday stay should be prepared in advance
2. For cheap one night stay people should choose Reinickendorf neighbourhood, while Mitte stays the most expensive

### Limitations

Since not all house listings accepted only one night booking, the minimum nights were filtered for only 1, to check for one night stay possibility

### References

- https://www.r-bloggers.com/2023/08/the-substring-function-in-r/](https://www.w3schools.com/sql/sql_case.asp
