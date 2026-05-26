# Data Preparation Script for nepalboundaries Package
# This script prepares your boundary shapefiles/geojson files for the package

library(sf)
library(dplyr)

# ====================================================================
# PREPARE YOUR DATA - UPDATE THESE PATHS TO YOUR DATA FILES
# ====================================================================

# Set your data directory
data_dir <- "/path/to/your/nepal/boundary/files"

# Load your boundary files
# Update these paths based on your actual files (can be .shp, .geojson, .gpkg, etc.)

# Country boundary
country_boundary <- st_read(file.path(data_dir, "country_boundary.geojson")) %>%
  rename_with(tolower) %>%  # Convert column names to lowercase
  select(geometry, everything())  # Move geometry to end

# Provincial boundaries
province_boundary <- st_read(file.path(data_dir, "province_boundary.geojson")) %>%
  rename_with(tolower) %>%
  select(geometry, everything())

# District boundaries
district_boundary <- st_read(file.path(data_dir, "district_boundary.geojson")) %>%
  rename_with(tolower) %>%
  select(geometry, everything())

# Municipal boundaries
municipality_boundary <- st_read(file.path(data_dir, "municipality_boundary.geojson")) %>%
  rename_with(tolower) %>%
  select(geometry, everything())

# Ward boundaries
ward_boundary <- st_read(file.path(data_dir, "ward_boundary.geojson")) %>%
  rename_with(tolower) %>%
  select(geometry, everything())

# ====================================================================
# STANDARDIZE COLUMN NAMES
# ====================================================================
# Rename columns to standard names. Adjust based on your actual column names!

province_boundary <- province_boundary %>%
  rename(
    province_name = name,  # Adjust 'name' to your actual column name
    province_code = code   # Adjust 'code' if you have it
  ) %>%
  arrange(province_name)

district_boundary <- district_boundary %>%
  rename(
    district_name = name,
    district_code = code,
    province_name = province
  ) %>%
  arrange(district_name)

municipality_boundary <- municipality_boundary %>%
  rename(
    municipality_name = name,
    municipality_code = code,
    district_name = district,
    province_name = province
  ) %>%
  arrange(municipality_name)

ward_boundary <- ward_boundary %>%
  rename(
    ward_number = ward_id,  # Adjust based on your columns
    ward_name = name,
    municipality_name = municipality,
    district_name = district,
    province_name = province
  ) %>%
  arrange(municipality_name, ward_number)

# ====================================================================
# ADD ADDITIONAL METADATA IF NEEDED
# ====================================================================

# Example: Add area calculation
province_boundary <- province_boundary %>%
  mutate(area_km2 = as.numeric(st_area(geometry)) / 1e6)

district_boundary <- district_boundary %>%
  mutate(area_km2 = as.numeric(st_area(geometry)) / 1e6)

# ====================================================================
# ENSURE CRS IS CORRECT
# ====================================================================
# Set to WGS84 (EPSG:4326) for consistency

country_boundary <- st_transform(country_boundary, crs = 4326)
province_boundary <- st_transform(province_boundary, crs = 4326)
district_boundary <- st_transform(district_boundary, crs = 4326)
municipality_boundary <- st_transform(municipality_boundary, crs = 4326)
ward_boundary <- st_transform(ward_boundary, crs = 4326)

# ====================================================================
# VALIDATE DATA
# ====================================================================

cat("Country boundary:\n")
print(country_boundary)

cat("\nProvince boundary:\n")
print(head(province_boundary))

cat("\nDistrict boundary:\n")
print(head(district_boundary))

cat("\nMunicipality boundary:\n")
print(head(municipality_boundary))

cat("\nWard boundary:\n")
print(head(ward_boundary))

# Check for valid geometries
if (!all(st_is_valid(country_boundary))) warning("Invalid geometries in country boundary!")
if (!all(st_is_valid(province_boundary))) warning("Invalid geometries in province boundary!")
if (!all(st_is_valid(district_boundary))) warning("Invalid geometries in district boundary!")
if (!all(st_is_valid(municipality_boundary))) warning("Invalid geometries in municipality boundary!")
if (!all(st_is_valid(ward_boundary))) warning("Invalid geometries in ward boundary!")

# ====================================================================
# SAVE DATA AS RDS FILES FOR PACKAGE
# ====================================================================
# Create data directory in package if it doesn't exist
pkg_data_dir <- "data"
dir.create(pkg_data_dir, showWarnings = FALSE)

# Save as RDS files (compressed binary format)
saveRDS(country_boundary, file.path(pkg_data_dir, "country.rds"))
saveRDS(province_boundary, file.path(pkg_data_dir, "province.rds"))
saveRDS(district_boundary, file.path(pkg_data_dir, "district.rds"))
saveRDS(municipality_boundary, file.path(pkg_data_dir, "municipality.rds"))
saveRDS(ward_boundary, file.path(pkg_data_dir, "ward.rds"))

cat("\nData files saved successfully to:", pkg_data_dir, "\n")

# ====================================================================
# ALTERNATIVE: SAVE AS LAZY-LOADED PACKAGE DATA
# ====================================================================
# This makes the data available as `nepal_country`, `nepal_province`, etc.

nepal_country <- country_boundary
nepal_province <- province_boundary
nepal_district <- district_boundary
nepal_municipality <- municipality_boundary
nepal_ward <- ward_boundary

usethis::use_data(nepal_country, overwrite = TRUE)
usethis::use_data(nepal_province, overwrite = TRUE)
usethis::use_data(nepal_district, overwrite = TRUE)
usethis::use_data(nepal_municipality, overwrite = TRUE)
usethis::use_data(nepal_ward, overwrite = TRUE)

cat("Lazy-loaded data created successfully!\n")
