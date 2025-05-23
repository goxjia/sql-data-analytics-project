
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
-- Retrieve a list of unique countries from which customers originate
SELECT
	DISTINCT country
FROM
	customers c;

-- Retrieve a list of unique categories, subcategories, and products
SELECT
	DISTINCT category,
	subcategory,
	product_name
FROM
	products p
ORDER BY
	category,
	subcategory,
	product_name;
