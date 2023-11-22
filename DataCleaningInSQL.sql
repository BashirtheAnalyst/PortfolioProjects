SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

-- Standardize Date Format
ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted
FROM PortfolioProject.dbo.NashvilleHousing

--Populating Property Address
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing
WHERE PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)-- to fill empty PropertyAddress with the PropertyAddress values that share the same ParcelID 
FROM PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL

--Splitting PropertyAddress column into Address, City
SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address, -- Taking the values from position 1 until coma, but without coma
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS AddressCity -- Taking the characters from coma, but coma, till last value
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
ADD NewPropertyAddress Nvarchar(255), PropertyCity Nvarchar(255)

UPDATE NashvilleHousing
SET NewPropertyAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1),

UPDATE NashvilleHousing
SET PropertyCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


--Splitting OwnerAddress to address, city and state
SELECT 
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),--OwnerAddress has three columns joined. ParseName gets them from the back
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
FROM PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
ADD OwnerMainAddress Nvarchar(255), OwnerCity Nvarchar(255), OwnerState Nvarchar(255)

UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerMainAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)


UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)


UPDATE PortfolioProject.dbo.NashvilleHousing
SET OwnerState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

--Checking for all the alterations and updates
SELECT *
FROM PortfolioProject.dbo.NashvilleHousing

-- Converting values to another e.g Y to Yes
SELECT SoldAsVacant
,	CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
		 WHEN SoldAsVacant = 'N' THEN 'NO'
		 ELSE SoldAsVacant
	END AS NewSoldAsVacant
FROM PortfolioProject.dbo.NashvilleHousing


-- Removing Duplicates
WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
	ORDER BY
		UniqueID
			)AS Row_Num
FROM PortfolioProject.dbo.NashvilleHousing
)

DELETE 
FROM RowNumCTE
WHERE Row_Num > 1


-- Deleting Irrelevant Columns/Data
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate