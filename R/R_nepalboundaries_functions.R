#' Get Nepal Country Boundary
#'
#' Retrieves the country boundary of Nepal.
#'
#' @return An sf object with Nepal's country boundary geometry
#'
#' @examples
#' \dontrun{
#'   nepal <- nb_country()
#'   plot(nepal)
#' }
#'
#' @export
nb_country <- function() {
  # Load country boundary data
  nepal_boundary <- load_nb_data("country")
  return(nepal_boundary)
}

#' Get Nepal Provincial Boundaries
#'
#' Retrieves administrative boundaries for Nepal's provinces.
#'
#' @param province Character. Optional filter for specific province(s).
#'                 If NULL, returns all provinces.
#'
#' @return An sf object with province boundaries
#'
#' @examples
#' \dontrun{
#'   # Get all provinces
#'   provinces <- nb_province()
#'   plot(provinces)
#'   
#'   # Get specific province
#'   kathmandu <- nb_province("Bagmati")
#' }
#'
#' @export
nb_province <- function(province = NULL) {
  prov_data <- load_nb_data("province")
  
  if (!is.null(province)) {
    prov_data <- prov_data %>%
      dplyr::filter(province_name %in% province)
    
    if (nrow(prov_data) == 0) {
      warning("No provinces found matching: ", paste(province, collapse = ", "))
    }
  }
  
  return(prov_data)
}

#' Get Nepal District Boundaries
#'
#' Retrieves administrative boundaries for Nepal's districts.
#'
#' @param district Character. Optional filter for specific district(s).
#' @param province Character. Optional filter for districts in specific province(s).
#'
#' @return An sf object with district boundaries
#'
#' @examples
#' \dontrun{
#'   # Get all districts
#'   districts <- nb_district()
#'   
#'   # Get specific district
#'   bhaktapur <- nb_district("Bhaktapur")
#'   
#'   # Get districts in a province
#'   bagmati_districts <- nb_district(province = "Bagmati")
#' }
#'
#' @export
nb_district <- function(district = NULL, province = NULL) {
  dist_data <- load_nb_data("district")
  
  if (!is.null(province)) {
    dist_data <- dist_data %>%
      dplyr::filter(province_name %in% province)
  }
  
  if (!is.null(district)) {
    dist_data <- dist_data %>%
      dplyr::filter(district_name %in% district)
    
    if (nrow(dist_data) == 0) {
      warning("No districts found matching criteria")
    }
  }
  
  return(dist_data)
}

#' Get Nepal Municipal Boundaries
#'
#' Retrieves administrative boundaries for Nepal's municipalities.
#'
#' @param municipality Character. Optional filter for specific municipality/ies.
#' @param district Character. Optional filter for municipalities in specific district(s).
#' @param province Character. Optional filter for municipalities in specific province(s).
#'
#' @return An sf object with municipality boundaries
#'
#' @examples
#' \dontrun{
#'   # Get all municipalities
#'   municipalities <- nb_municipality()
#'   
#'   # Get specific municipality
#'   kathmandu <- nb_municipality("Kathmandu")
#'   
#'   # Get municipalities in a district
#'   bhaktapur_municipalities <- nb_municipality(district = "Bhaktapur")
#' }
#'
#' @export
nb_municipality <- function(municipality = NULL, district = NULL, province = NULL) {
  mun_data <- load_nb_data("municipality")
  
  if (!is.null(province)) {
    mun_data <- mun_data %>%
      dplyr::filter(province_name %in% province)
  }
  
  if (!is.null(district)) {
    mun_data <- mun_data %>%
      dplyr::filter(district_name %in% district)
  }
  
  if (!is.null(municipality)) {
    mun_data <- mun_data %>%
      dplyr::filter(municipality_name %in% municipality)
    
    if (nrow(mun_data) == 0) {
      warning("No municipalities found matching criteria")
    }
  }
  
  return(mun_data)
}

#' Get Nepal Ward Boundaries
#'
#' Retrieves administrative boundaries for Nepal's wards.
#'
#' @param ward Character. Optional filter for specific ward(s).
#' @param municipality Character. Optional filter for wards in specific municipality/ies.
#' @param district Character. Optional filter for wards in specific district(s).
#' @param province Character. Optional filter for wards in specific province(s).
#'
#' @return An sf object with ward boundaries
#'
#' @examples
#' \dontrun{
#'   # Get all wards
#'   wards <- nb_ward()
#'   
#'   # Get wards in a municipality
#'   kathmandu_wards <- nb_ward(municipality = "Kathmandu")
#'   
#'   # Get specific ward
#'   ward_1 <- nb_ward(ward = "1", municipality = "Kathmandu")
#' }
#'
#' @export
nb_ward <- function(ward = NULL, municipality = NULL, district = NULL, province = NULL) {
  ward_data <- load_nb_data("ward")
  
  if (!is.null(province)) {
    ward_data <- ward_data %>%
      dplyr::filter(province_name %in% province)
  }
  
  if (!is.null(district)) {
    ward_data <- ward_data %>%
      dplyr::filter(district_name %in% district)
  }
  
  if (!is.null(municipality)) {
    ward_data <- ward_data %>%
      dplyr::filter(municipality_name %in% municipality)
  }
  
  if (!is.null(ward)) {
    ward_data <- ward_data %>%
      dplyr::filter(ward_number %in% ward)
    
    if (nrow(ward_data) == 0) {
      warning("No wards found matching criteria")
    }
  }
  
  return(ward_data)
}

#' Get Multiple Administrative Levels
#'
#' Retrieves boundaries for multiple administrative levels at once.
#'
#' @param levels Character vector. Specify which levels to retrieve.
#'                Options: "country", "province", "district", "municipality", "ward"
#'
#' @return A list of sf objects, one for each requested level
#'
#' @examples
#' \dontrun{
#'   boundaries <- nb_get_multiple(c("province", "district"))
#' }
#'
#' @export
nb_get_multiple <- function(levels = c("province", "district")) {
  valid_levels <- c("country", "province", "district", "municipality", "ward")
  
  if (!all(levels %in% valid_levels)) {
    stop("Invalid level. Valid options are: ", paste(valid_levels, collapse = ", "))
  }
  
  result <- list()
  
  for (level in levels) {
    result[[level]] <- switch(level,
                             "country" = nb_country(),
                             "province" = nb_province(),
                             "district" = nb_district(),
                             "municipality" = nb_municipality(),
                             "ward" = nb_ward())
  }
  
  return(result)
}

#' Get Summary Information about Nepal Boundaries
#'
#' Provides summary statistics about administrative divisions in Nepal.
#'
#' @param level Character. The administrative level to summarize.
#'
#' @return A data frame with summary information
#'
#' @examples
#' \dontrun{
#'   nb_summary("district")
#'   nb_summary("municipality")
#' }
#'
#' @export
nb_summary <- function(level = "district") {
  valid_levels <- c("province", "district", "municipality", "ward")
  
  if (!level %in% valid_levels) {
    stop("Invalid level. Valid options are: ", paste(valid_levels, collapse = ", "))
  }
  
  data <- load_nb_data(level)
  
  # Remove geometry column for summary
  data_summary <- sf::st_drop_geometry(data)
  
  summary_stats <- data.frame(
    level = level,
    total_features = nrow(data),
    columns = paste(names(data_summary), collapse = ", ")
  )
  
  return(summary_stats)
}

#' Internal function to load data
#'
#' @param level Administrative level
#'
#' @keywords internal
load_nb_data <- function(level) {
  # Try to load from system.file (data bundled with package)
  data_path <- system.file("data", paste0(level, ".rds"), package = "nepalboundaries")
  
  if (file.exists(data_path)) {
    return(readRDS(data_path))
  }
  
  # Alternative: load from package data objects if pre-loaded
  tryCatch({
    return(get(paste0("nepal_", level), envir = asNamespace("nepalboundaries")))
  }, error = function(e) {
    stop("Data for ", level, " not found. Please ensure data files are properly installed.")
  })
}
