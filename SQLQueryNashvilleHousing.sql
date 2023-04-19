-- Standardize Date Format: Adds a new column to the table and updates it with a standardized date format.

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE, SaleDate);

-- Populate Property Address data: Updates null values in the PropertyAddress column with the corresponding value from another row with the same ParcelID.

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM NashvilleHousing AS a
JOIN NashvilleHousing AS b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID] <> b.[UniqueID]
WHERE a.PropertyAddress IS NULL;

-- Breaking out Property Address into individual columns (Address, City): Adds two new columns to the table and updates them with the address and city portions of the PropertyAddress column.

ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(250),
    PropertySplitCity NVARCHAR(250);

UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1),
    PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

-- Breaking out Owner Address into individual columns (Address, City, State): Adds three new columns to the table and updates them with the address, city, and state portions of the OwnerAddress column.

ALTER TABLE NashvilleHousing
ADD OwnerSplitAddress NVARCHAR(250),
    OwnerSplitCity NVARCHAR(250),
    OwnerSplitState NVARCHAR(250);

UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
    OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
    OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);


-- Change Y and N to Yes and No in 'Sold as Vacant' field: Converts 'Y' and 'N' values in the SoldAsVacant column to 'Yes' and 'No', respectively.

SELECT DISTINCT(SoldAsVacant), 
	COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY COUNT(SoldAsVacant);

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END
FROM NashvilleHousing;

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	 WHEN SoldAsVacant = 'N' THEN 'No'
	 ELSE SoldAsVacant
	 END;

-- Remove Duplicates: Removes duplicate rows from the table based on specific column values.

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY UniqueID
				 ) row_num
FROM NashvilleHousing
)

DELETE
FROM RowNumCTE
WHERE row_num > 1;

-- Remove Unused Columns: Drops several columns from the table that are no longer needed.

SELECT *
FROM NashvilleHousing;

ALTER TABLE NashvilleHousing 
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict, SaleDate;

