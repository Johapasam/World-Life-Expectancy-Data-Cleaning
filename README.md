World Life Expectancy Data Cleaning Project

This project focuses on cleaning and preparing the World Life Expectancy dataset for analysis. The goal is to handle issues such as duplicate records, missing values, and inconsistencies in the data to ensure it is ready for further processing and analysis.

Project Overview

The World Life Expectancy dataset contains information on life expectancy by country, year, and development status. However, the raw data may contain missing values, duplicates, and other issues that need to be addressed before performing any analysis. This project handles these problems using SQL queries for data cleaning and transformation.

Steps Taken

1. Removing Duplicate Entries
Identified and removed duplicate entries for the same country-year combination.
Used SQL's ROW_NUMBER() function to rank duplicates and kept the highest-ranked record.
2. Handling Missing Values in the Status Column
Filled in missing values in the Status column (either 'Developed' or 'Developing') based on existing country information.
Updated missing status fields by using available data from the same country.
3. Handling Missing Values in the Lifeexpectancy Column
For countries with missing life expectancy values, the missing data was interpolated by taking the average of the life expectancy in the previous and following years.
SQL's JOIN functionality was used to calculate the median for missing values based on neighboring years.
4. Ensuring Data Integrity
Ensured the integrity of the data by verifying that only one row per country and year exists after the cleaning process.
Corrected the dataset to make it ready for analysis and future use.
How to Run the Queries

To clean the data, follow these steps:

Set up your MySQL environment or any SQL-compatible tool.
Import the worldlifeexpectancy dataset into your database.
Run the provided SQL scripts in the following order:
Remove duplicates from the dataset.
Handle missing values for the Status column.
Handle missing values for the Lifeexpectancy column.


Columns:
Country: Name of the country.
Year: Year of the data.
Lifeexpectancy: Life expectancy value.
Status: Development status ('Developed' or 'Developing').
Prerequisites


This project is licensed under the MIT License

