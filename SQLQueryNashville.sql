--Cleaning Data in SQL Queries


Select *
From PortfolioProject.dbo.NashvilleHousing

--Standardize Date Format

Select SaleDateConverted, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing

Update NashvilleHousing
SET SaleDate = Convert(Date, SaleDate)

Alter Table NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = Convert(Date, SaleDate)

--Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is Null
Order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
Join PortfolioProject.dbo.NashvilleHousing b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

--Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is Null
--Order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address   
From PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

Alter Table NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
From PortfolioProject.dbo.NashvilleHousing





Select OwnerAddress
From PortfolioProject.dbo.NashvilleHousing

Select
PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 1)
From PortfolioProject.dbo.NashvilleHousing


Alter Table NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 3)

Alter Table NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 2)

Alter Table NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' ,'.') , 1)


Select *
From PortfolioProject.dbo.NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.NashvilleHousing
Group by SoldAsVacant
order by 2


Select SoldAsVacant
, Case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End
From PortfolioProject.dbo.NashvilleHousing


Update NashvilleHousing
SET SoldAsVacant =Case when SoldAsVacant = 'Y' Then 'Yes'
       when SoldAsVacant = 'N' Then 'No'
	   Else SoldAsVacant
	   End


--Remove Duplicates


With RowNumCTE AS(
Select *,
ROW_NUMBER() Over (
Partition by ParcelID,
             PropertyAddress,
             SalePrice,
             SaleDate,
             LegalReference
			 Order by
			      UniqueID
				  ) row_num

From PortfolioProject.dbo.NashvilleHousing
)
Select *
From RowNumCTE
Where row_num >1
--order by PropertyAddress



--Delete Unused Columns

Select *
From PortfolioProject.dbo.NashvilleHousing

Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress


Alter Table PortfolioProject.dbo.NashvilleHousing
Drop Column SaleDate





Select *
From PortfolioProject.dbo.NashvilleHousing