--Cleaning data in SQL Queries

Select * 
From PortfolioProject.dbo.NashvilleHousing

----Standarize Date Format

Select SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER Table NashvilleHousing
ADD SaleDateConverted Date
 
Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)   


----Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is NULL
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)	
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


---Breaking out Address in oindivideual column (Address,city,State)


Select propertyaddress
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is NULL
---Order by ParcelID

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address, -- substring or Left(PropertyAddress,CHARINDEX(',',PropertyAddress)-1) as Address
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress)) as Address
From PortfolioProject.dbo.NashvilleHousing


ALTER Table NashvilleHousing
ADD PropertySplitAddress Nvarchar(255)
 
Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


ALTER Table NashvilleHousing
ADD PropertySplitCity Nvarchar(255)
 
Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,Len(PropertyAddress))  

SELECT *
From PortfolioProject.dbo.NashvilleHousing

SELECT OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(Replace(Owneraddress,',','.'),3),
PARSENAME(Replace(Owneraddress,',','.'),2),
PARSENAME(Replace(Owneraddress,',','.'),1)
From PortfolioProject.dbo.NashvilleHousing


ALTER Table NashvilleHousing
ADD OwnerAddressSplitAddress Nvarchar(255)
 
Update NashvilleHousing
SET OwnerAddressSplitAddress = PARSENAME(Replace(Owneraddress,',','.'),3)


ALTER Table NashvilleHousing
ADD OwnerAddressSplitCity Nvarchar(255)
 
Update NashvilleHousing
SET OwnerAddressSplitCity = PARSENAME(Replace(Owneraddress,',','.'),2)


ALTER Table NashvilleHousing
ADD OwnerAddressSplitState Nvarchar(255)
 
Update NashvilleHousing
SET OwnerAddressSplitState = PARSENAME(Replace(Owneraddress,',','.'),1) 

SELECT *
From PortfolioProject.dbo.NashvilleHousing


----Select Y and N to Yes and No in "Sold as Vaccant" field

Select distinct(SoldAsVacant), COUNT(SoldAsvacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by COUNT(SoldAsvacant) 


Select SoldAsVacant,
Case 
	when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END 
From PortfolioProject.dbo.NashvilleHousing



UPDATE NashvilleHousing
SET SoldAsVacant=Case 
	when SoldAsVacant = 'Y' Then 'Yes'
	when SoldAsVacant = 'N' Then 'No'
	Else SoldAsVacant
	END 

Select distinct(SoldAsVacant), COUNT(SoldAsvacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
Order by COUNT(SoldAsvacant) 




-----Remove Duplicates

 WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress


----DELETE Unused Columns


SELECT *
From PortfolioProject.dbo.NashvilleHousing

ALTER table PortfolioProject.dbo.NashvilleHousing
DROP Column OwnerAddress,PropertyAddress,TaxDistrict

ALTER table PortfolioProject.dbo.NashvilleHousing
DROP Column Saledate