


SELECT *
FROM Nashvillehousing

....................................................................................................................
 --standardizing sales date

 
SELECT SaleDateconverted, CONVERT(date, saledate)
FROM Nashvillehousing

update Nashvillehousing
set saledate = CONVERT(date, saledate)

alter table nashvillehousing
add saledateconverted date

update Nashvillehousing
set saledateconverted = CONVERT(date, saledate)

--------------------------------------------------------------------------------------------

--Populating the property address

SELECT *
FROM Nashvillehousing
--where PropertyAddress is null
order by ParcelID

select nash.parcelid, nash.propertyaddress, ville.parcelid, ville.PropertyAddress,
isnull(nash.propertyaddress, ville.propertyaddress)
from Nashvillehousing Nash
join Nashvillehousing ville
  on nash.parcelid = ville.parcelid
  and nash.uniqueid <> ville.uniqueid
where nash.propertyaddress is null 

update nash
set propertyaddress = isnull(nash.propertyaddress, ville.propertyaddress)
from Nashvillehousing Nash
join Nashvillehousing ville
  on nash.parcelid = ville.parcelid
  and nash.uniqueid <> ville.uniqueid
where nash.propertyaddress is null

-----------------------------------------------------------------------------------------------
--Breaking out the Adress into individual column (Address, City, State)

SELECT PropertyAddress
FROM Nashvillehousing
--where PropertyAddress is null
--order by ParcelID

SELECT
  substring(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as address
 , SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)
 +1, len(propertyaddress)) as address
 from Nashvillehousing

 alter table nashvillehousing
add propertysplitaddress nvarchar(255)

update Nashvillehousing
set propertysplitaddress =  substring(propertyaddress, 1, CHARINDEX(',', 
propertyaddress) -1) 

alter table nashvillehousing
add propertysplitcity nvarchar(255)

update Nashvillehousing
set propertysplitcity =  SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)
 +1, len(propertyaddress))

 select *
 from Nashvillehousing



 select *
 from Nashvillehousing

 select
 PARSENAME (replace(owneraddress, ',', '.'),3),
 PARSENAME (replace(owneraddress, ',', '.'),2),
 PARSENAME (replace(owneraddress, ',', '.'),1)
 from Nashvillehousing

alter table nashvillehousing
add ownersplitaddress nvarchar(255)

update Nashvillehousing
set ownersplitaddress =  PARSENAME (replace(owneraddress, ',', '.'),3)

 alter table nashvillehousing
add ownersplitcity nvarchar(255)

update Nashvillehousing
set ownersplitcity = PARSENAME (replace(owneraddress, ',', '.'),2)


 alter table nashvillehousing
add ownersplitstate nvarchar(255)

update Nashvillehousing
set ownersplitstate = PARSENAME (replace(owneraddress, ',', '.'),1) 


select *
from Nashvillehousing


--------------------------------------------------------------------------------------------
--Changing Y and Y to Yes and No to 'soldasvacant' Column


select soldasvacant, count(soldasvacant)
from Nashvillehousing
group by SoldAsVacant


select soldasvacant,
case
    when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant 
end
from Nashvillehousing

update Nashvillehousing
set SoldAsVacant = case
    when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant 
end

---------------------------------------------------------------------------------------------
--Removing Duplicates

with rownumcte as (
select *,
row_number() over (
partition by parcelid,
             propertyaddress,
			 saleprice,
			 saledate,
			 legalreference
			 order by 
			     uniqueid
				 ) row_num
from lproject..nashvillehousing
--order by parcelid    
)
select *
from rownumcte
where row_num > 1
--order by propertyaddress

--------------------------------------------------------------------------------------------
--Deleting Irrelevant Columns

select *
from Nashvillehousing

alter table nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress

alter table nashvillehousing
drop column saledate
