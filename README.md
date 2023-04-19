# Nashville-Housing

This script standardizes and transforms the NashvilleHousing dataset. It performs the following operations:
  1. Standardizes the date format by creating a new column called SaleDateConverted and converting the SaleDate column to a DATE data type.
  2. Populates missing Property Address data by joining on the ParcelID and updating the null values with non-null values.
  3. Splits the Property Address and Owner Address columns into individual columns for Address, City, and State.
  4. Changes the 'Sold as Vacant' column values from Y and N to Yes and No.
  5. Removes duplicate rows from the dataset based on a combination of selected columns.
  6. Drops unused columns from the dataset such as PropertyAddress, OwnerAddress, TaxDistrict, and SaleDate.
  
These transformations make the data more consistent, complete, and easier to analyze.
