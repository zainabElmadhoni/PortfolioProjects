
/* 
	Cleaning Data in SQL
*/


select *
from NashVilleHousing

-----------------------------------
-- Standardize Date Format

select SaleDate, CONVERT(Date,SaleDate)
from NashVilleHousing

alter table NashVilleHousing 
add SaleDateConverted Date;

update NashVilleHousing
set SaleDateConverted = CONVERT(Date,SaleDate)

------------------------------------------------

-- Populate Property Address data

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashVilleHousing a
join NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashVilleHousing a
join NashVilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ]<> b.[UniqueID ]
where a.PropertyAddress is null


----------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

select PropertyAddress
from NashVilleHousing

SELECT
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as City
from NashVilleHousing;

alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

update NashVilleHousing
set PropertySplitAddress= SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1);

update NashVilleHousing
set PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress));


----------------------------------------------------------------------------------------------------------------
select OwnerAddress 
from NashVilleHousing

select PARSENAME(replace(ownerAddress,',', '.' ),3)
, PARSENAME(replace(ownerAddress,',', '.' ),2)
, PARSENAME(replace(ownerAddress,',', '.' ),1)
from NashVilleHousing

alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);


alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

update NashVilleHousing
set OwnerSplitAddress= PARSENAME(replace(ownerAddress,',', '.' ),3);

update NashVilleHousing
set OwnerSplitCity= PARSENAME(replace(ownerAddress,',', '.' ),2);

update NashVilleHousing
set OwnerSplitState= PARSENAME(replace(ownerAddress,',', '.' ),1);

select OwnerAddress,OwnerSplitState, OwnerSplitCity,OwnerSplitAddress
from NashVilleHousing

--------------------------------------------------------------------------
-- Turn 'Y' and 'N' to 'Yes' and 'No' in "Sold as Vacant" field

select distinct(SoldAsVacant), COUNT(soldasvacant)
from NashVilleHousing
group by SoldAsVacant
order by 2


update NashVilleHousing
set SoldAsVacant = case when  SoldAsVacant = 'y' then 'yes'
       when SoldAsVacant = 'n' then 'no'
	   else SoldAsVacant
	   end

------------------------------------------------------------------------------
-- Delete duplicates
WITH RowNumCTE as (
select *,
		ROW_NUMBER() over (
		partition by ParcelID,
					 Propertyaddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 order by 
							UniqueID
						) row_num
from NashVilleHousing 
)
delete from RowNumCTE
where row_num>1

---------------------------------------------------------------------------

