# geonepal - Administrative Boundaries of Nepal

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![R Package](https://img.shields.io/badge/R-ready-blue.svg)]()
[![Python Package](https://img.shields.io/badge/Python-ready-blue.svg)]()

A collection of geospatial packages (R and Python) providing easy access to administrative boundaries of Nepal at multiple levels: country, provincial, district, municipal, and ward.

Inspired by the excellent [rgeoboundaries](https://github.com/wmgeolab/rgeoboundaries) package but tailored specifically for Nepal with local data.

## Features

- **Multi-level administrative boundaries**: Country, Province, District, Municipality, Ward
- **Easy filtering**: Get boundaries by name or geographic hierarchy
- **Clean spatial data**: All boundaries standardized to WGS84 (EPSG:4326)
- **Integrated analysis**: Works seamlessly with spatial analysis packages
- **Multiple formats**: Supports GeoJSON, GeoPackage, and Shapefile formats
- **Both R and Python**: Same functionality across two major data science languages

## Installation

### R Package

```r
# From GitHub
remotes::install_github("Lalitgis/geonepal")
```
## Quick Start

### R

```r
library(geonepal)
library(ggplot2)

# Get all provinces
provinces <- nb_province()
provinces %>%
  ggplot() +
  geom_sf(fill = "lightblue", color = "black") +
  geom_sf_label(aes(label = province_name)) +
  theme_minimal()

# Get districts in Bagmati Province
bagmati_districts <- nb_district(province = "Bagmati")
plot(bagmati_districts)

# Get wards in Kathmandu
kathmandu_wards <- nb_ward(municipality = "Kathmandu")
```

## Available Functions

### R Package

| Function | Description |
|----------|-------------|
| `nb_country()` | Get Nepal's country boundary |
| `nb_province(province = NULL)` | Get provincial boundaries |
| `nb_district(district = NULL, province = NULL)` | Get district boundaries |
| `nb_municipality(municipality = NULL, district = NULL, province = NULL)` | Get municipality boundaries |
| `nb_ward(ward = NULL, municipality = NULL, district = NULL, province = NULL)` | Get ward boundaries |
| `nb_get_multiple(levels = c("province", "district"))` | Get multiple levels at once |
| `nb_summary(level = "district")` | Get summary information |

## Data Structure

The package includes standardized spatial data with the following administrative levels:

```
Nepal (Country)
├── 7 Provinces
│   ├── 77 Districts
│   │   ├── 753 Municipalities + Protected Areas of Nepal
│   │   │   └── ~6,743 Wards
```

### Column Names by Level

#### Province
- `province_name`: Name of the province
- `province_code`: ISO/standard province code (if available)
- `area_km2`: Area in square kilometers

#### District
- `district_name`: Name of the district
- `district_code`: District code
- `province_name`: Parent province name
- `area_km2`: Area in square kilometers

#### Municipality
- `municipality_name`: Name of the municipality
- `municipality_code`: Municipality code
- `district_name`: Parent district name
- `province_name`: Parent province name
- `area_km2`: Area in square kilometers

#### Ward
- `ward_number`: Ward number (1-X)
- `ward_name`: Ward name (if available)
- `municipality_name`: Parent municipality name
- `district_name`: Parent district name
- `province_name`: Parent province name

## Detailed Examples

### R - Advanced Usage

```r
library(nepalboundaries)
library(sf)
library(dplyr)

# Get districts and calculate statistics
districts <- nb_district() %>%
  mutate(area_km2 = as.numeric(st_area(geometry)) / 1e6)

# Find the largest districts
top_districts <- districts %>%
  st_drop_geometry() %>%
  arrange(desc(area_km2)) %>%
  head(10)

# Spatial join to find which district contains a point
point <- st_point(c(85.3240, 27.7172)) %>%  # Kathmandu
  st_sfc(crs = 4326) %>%
  st_as_sf()

district_containing_point <- st_join(point, districts)

# Find adjacent districts
kathmandu <- districts[districts$district_name == "Kathmandu", ]
adjacent <- districts[st_touches(kathmandu, districts, sparse = FALSE)[1, ], ]
```

## Data Sources and Preparation

The package includes data prepared from official Nepal administrative boundary datasets. 

### Preparing Your Own Data

If you want to rebuild the package with updated data:

#### R
```r
# Run the data preparation script
source("data_preparation_R.R")
# This will create RDS files in the data/ directory
```

## Coordinate Reference System

All data in this package uses the **WGS84 projection** (EPSG:4326, latitude/longitude).

If you need a different projection, transform it using:

**R:**
```r
districts_projected <- st_transform(districts, crs = 32645)  # UTM Zone 45N
```


## Data Export

### R
```r
# Save as shapefile
st_write(districts, "nepal_districts.shp")

# Save as GeoJSON
st_write(districts, "nepal_districts.geojson", driver = "GeoJSON")

# Save as GeoPackage
st_write(districts, "nepal_districts.gpkg")

# Save as CSV (without geometry)
districts %>%
  st_drop_geometry() %>%
  write.csv("nepal_districts.csv")
```

## Interactive Visualization

### R - Using Leaflet
```r
library(leaflet)

leaflet(data = nb_district()) %>%
  addTiles() %>%
  addPolygons(
    popup = ~district_name,
    color = "blue",
    weight = 1,
    opacity = 0.8
  )
```


## Package Structure

```
nepalboundaries/
├── R/
│   ├── DESCRIPTION           # Package metadata
│   ├── NAMESPACE             # Package namespace
│   ├── R/
│   │   └── functions.R       # Main functions
│   ├── data/
│   │   ├── country.rds
│   │   ├── province.rds
│   │   ├── district.rds
│   │   ├── municipality.rds
│   │   └── ward.rds
│   ├── man/                  # Documentation
│   └── README.md
│
├── README.md
└── LICENSE
```

## License

MIT License - See LICENSE file for details

## Citation

If you use this package in your research, please cite:

```bibtex
@software{geonepal 2026,
  title={geonepal: Administrative Boundaries of Nepal},
  author={Lalit BC},
  year={2026},
  url={https://github.com/Lalitgis/geonepal}
}
```

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Issues and Support

For bugs, feature requests, or questions, please open an issue on GitHub:
[Issues](https://github.com/Lalitgis/geonepal/issues)

## Inspiration

This package is inspired by and follows the design principles of:
- [rgeoboundaries](https://github.com/wmgeolab/rgeoboundaries) - Global administrative boundaries for R
- [geobounds](https://dieghernan.github.io/geobounds/) - Alternative R implementation

## Related Resources

- [Nepal Central Bureau of Statistics](https://cbs.gov.np/)
- [OpenStreetMap Nepal](https://wiki.openstreetmap.org/wiki/Nepal)
- [HDX Nepal Data](https://data.humdata.org/dataset?tags=nepal)

## Acknowledgments

- Nepal administrative boundary data sources and contributors (Survey Department of Nepal)
- The R geospatial communities
- sf, geopandas, and related package developers

---

**Last Updated**: 2026
**Version**: 0.1.0
