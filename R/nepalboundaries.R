#' Get Nepal Country Boundary
#'
#' Retrieves the country boundary of Nepal.
#'
#' @return An sf object containing Nepal's country boundary geometry.
#'
#' @examples
#' \dontrun{
#'   nepal <- nb_country()
#'   plot(nepal)
#' }
#'
#' @export
nb_country <- function() {
  load_nb_data("country")
}


#' Get Nepal Provincial Boundaries
#'
#' Retrieves administrative boundaries for Nepal's provinces.
#'
#' @param province Character vector. Optional province name(s).
#'   If NULL, all provinces are returned.
#'
#' @return An sf object containing province boundaries.
#'
#' @examples
#' \dontrun{
#'   # Get all provinces
#'   provinces <- nb_province()
#'
#'   # Get Bagmati Province
#'   bagmati <- nb_province("Bagmati")
#' }
#'
#' @export
nb_province <- function(province = NULL) {

  prov_data <- load_nb_data("province")

  validate_columns(prov_data, "province_name")

  if (!is.null(province)) {

    prov_data <- prov_data |>
      dplyr::filter(
        tolower(province_name) %in% tolower(province)
      )

    if (nrow(prov_data) == 0) {
      warning(
        "No provinces found matching: ",
        paste(province, collapse = ", ")
      )
    }
  }

  prov_data
}


#' Get Nepal District Boundaries
#'
#' Retrieves administrative boundaries for Nepal's districts.
#'
#' @param district Character vector. Optional district name(s).
#' @param province Character vector. Optional province name(s).
#'
#' @return An sf object containing district boundaries.
#'
#' @examples
#' \dontrun{
#'   # Get all districts
#'   districts <- nb_district()
#'
#'   # Get Bhaktapur district
#'   bhaktapur <- nb_district("Bhaktapur")
#'
#'   # Get districts within Bagmati Province
#'   bagmati_districts <- nb_district(province = "Bagmati")
#' }
#'
#' @export
nb_district <- function(district = NULL, province = NULL) {

  dist_data <- load_nb_data("district")

  validate_columns(
    dist_data,
    c("province_name", "district_name")
  )

  if (!is.null(province)) {

    dist_data <- dist_data |>
      dplyr::filter(
        tolower(province_name) %in% tolower(province)
      )
  }

  if (!is.null(district)) {

    dist_data <- dist_data |>
      dplyr::filter(
        tolower(district_name) %in% tolower(district)
      )

    if (nrow(dist_data) == 0) {
      warning("No districts found matching criteria.")
    }
  }

  dist_data
}


#' Get Nepal Municipal Boundaries
#'
#' Retrieves administrative boundaries for Nepal's municipalities.
#'
#' @param municipality Character vector. Optional municipality name(s).
#' @param district Character vector. Optional district name(s).
#' @param province Character vector. Optional province name(s).
#'
#' @return An sf object containing municipality boundaries.
#'
#' @examples
#' \dontrun{
#'   # Get all municipalities
#'   municipalities <- nb_municipality()
#'
#'   # Get Kathmandu Metropolitan City
#'   kathmandu <- nb_municipality("Kathmandu")
#'
#'   # Get municipalities within Bhaktapur district
#'   bhaktapur_mun <- nb_municipality(district = "Bhaktapur")
#' }
#'
#' @export
nb_municipality <- function(
    municipality = NULL,
    district = NULL,
    province = NULL
) {

  mun_data <- load_nb_data("municipality")

  validate_columns(
    mun_data,
    c(
      "province_name",
      "district_name",
      "municipality_name"
    )
  )

  if (!is.null(province)) {

    mun_data <- mun_data |>
      dplyr::filter(
        tolower(province_name) %in% tolower(province)
      )
  }

  if (!is.null(district)) {

    mun_data <- mun_data |>
      dplyr::filter(
        tolower(district_name) %in% tolower(district)
      )
  }

  if (!is.null(municipality)) {

    mun_data <- mun_data |>
      dplyr::filter(
        tolower(municipality_name) %in% tolower(municipality)
      )

    if (nrow(mun_data) == 0) {
      warning("No municipalities found matching criteria.")
    }
  }

  mun_data
}


#' Get Nepal Ward Boundaries
#'
#' Retrieves administrative boundaries for Nepal's wards.
#'
#' @param ward Numeric or character vector. Optional ward number(s).
#' @param municipality Character vector. Optional municipality name(s).
#' @param district Character vector. Optional district name(s).
#' @param province Character vector. Optional province name(s).
#'
#' @return An sf object containing ward boundaries.
#'
#' @examples
#' \dontrun{
#'   # Get all wards
#'   wards <- nb_ward()
#'
#'   # Get wards within Kathmandu
#'   kathmandu_wards <- nb_ward(municipality = "Kathmandu")
#'
#'   # Get Ward 1 of Kathmandu
#'   ward_1 <- nb_ward(
#'     ward = 1,
#'     municipality = "Kathmandu"
#'   )
#' }
#'
#' @export
nb_ward <- function(
    ward = NULL,
    municipality = NULL,
    district = NULL,
    province = NULL
) {

  ward_data <- load_nb_data("ward")

  validate_columns(
    ward_data,
    c(
      "province_name",
      "district_name",
      "municipality_name",
      "ward_number"
    )
  )

  if (!is.null(province)) {

    ward_data <- ward_data |>
      dplyr::filter(
        tolower(province_name) %in% tolower(province)
      )
  }

  if (!is.null(district)) {

    ward_data <- ward_data |>
      dplyr::filter(
        tolower(district_name) %in% tolower(district)
      )
  }

  if (!is.null(municipality)) {

    ward_data <- ward_data |>
      dplyr::filter(
        tolower(municipality_name) %in% tolower(municipality)
      )
  }

  if (!is.null(ward)) {

    ward_data <- ward_data |>
      dplyr::filter(
        as.character(ward_number) %in%
          as.character(ward)
      )

    if (nrow(ward_data) == 0) {
      warning("No wards found matching criteria.")
    }
  }

  ward_data
}


#' Get Multiple Administrative Levels
#'
#' Retrieves multiple administrative boundary levels at once.
#'
#' @param levels Character vector specifying administrative levels.
#'   Options:
#'   "country", "province", "district",
#'   "municipality", "ward"
#'
#' @return A named list of sf objects.
#'
#' @examples
#' \dontrun{
#'   boundaries <- nb_get_multiple(
#'     c("province", "district")
#'   )
#' }
#'
#' @export
nb_get_multiple <- function(
    levels = c("province", "district")
) {

  valid_levels <- c(
    "country",
    "province",
    "district",
    "municipality",
    "ward"
  )

  if (!all(levels %in% valid_levels)) {

    stop(
      "Invalid level(s). Valid options are: ",
      paste(valid_levels, collapse = ", ")
    )
  }

  result <- list()

  for (level in levels) {

    result[[level]] <- switch(
      level,

      country = nb_country(),

      province = nb_province(),

      district = nb_district(),

      municipality = nb_municipality(),

      ward = nb_ward()
    )
  }

  result
}


#' Get Summary Information About Nepal Boundaries
#'
#' Provides summary statistics for a selected
#' administrative boundary level.
#'
#' @param level Character. Administrative level.
#'
#' @return A data frame containing summary information.
#'
#' @examples
#' \dontrun{
#'   nb_summary("district")
#'   nb_summary("municipality")
#' }
#'
#' @export
nb_summary <- function(level = "district") {

  valid_levels <- c(
    "province",
    "district",
    "municipality",
    "ward"
  )

  level <- match.arg(level, valid_levels)

  data <- load_nb_data(level)

  data_summary <- sf::st_drop_geometry(data)

  summary_stats <- data.frame(
    level = level,
    total_features = nrow(data),
    total_columns = ncol(data_summary),
    crs_epsg = sf::st_crs(data)$epsg,
    column_names = paste(
      names(data_summary),
      collapse = ", "
    )
  )

  summary_stats
}


#' Get Province Headquarters
#'
#' Retrieves province headquarters locations.
#'
#' @param province Character vector.
#'   Optional province name(s).
#'
#' @return An sf object containing province headquarters.
#'
#' @examples
#' \dontrun{
#'   hq <- nb_province_headquarters()
#'   bagmati_hq <- nb_province_headquarters("Bagmati")
#' }
#'
#' @export
nb_province_headquarters <- function(
    province = NULL
) {

  data <- readRDS(
    system.file(
      "data",
      "province_headquarters.rds",
      package = "nepalboundaries"
    )
  )

  validate_columns(data, "province_name")

  if (!is.null(province)) {

    data <- data |>
      dplyr::filter(
        tolower(province_name) %in%
          tolower(province)
      )
  }

  data
}


#' Get District Headquarters
#'
#' Retrieves district headquarters locations.
#'
#' @param district Character vector.
#'   Optional district name(s).
#' @param province Character vector.
#'   Optional province name(s).
#'
#' @return An sf object containing district headquarters.
#'
#' @examples
#' \dontrun{
#'   district_hq <- nb_district_headquarters()
#'   bhaktapur_hq <- nb_district_headquarters(
#'     district = "Bhaktapur"
#'   )
#' }
#'
#' @export
nb_district_headquarters <- function(
    district = NULL,
    province = NULL
) {

  data <- readRDS(
    system.file(
      "data",
      "district_headquarters.rds",
      package = "nepalboundaries"
    )
  )

  validate_columns(
    data,
    c("province_name", "district_name")
  )

  if (!is.null(province)) {

    data <- data |>
      dplyr::filter(
        tolower(province_name) %in%
          tolower(province)
      )
  }

  if (!is.null(district)) {

    data <- data |>
      dplyr::filter(
        tolower(district_name) %in%
          tolower(district)
      )
  }

  data
}


#' Internal Function to Load Nepal Boundary Data
#'
#' @param level Character. Administrative level.
#'
#' @return An sf object.
#'
#' @keywords internal
load_nb_data <- function(level) {

  data_path <- system.file(
    "data",
    paste0(level, ".rds"),
    package = "nepalboundaries"
  )

  if (nzchar(data_path)) {
    return(readRDS(data_path))
  }

  tryCatch({

    get(
      paste0("nepal_", level),
      envir = asNamespace("nepalboundaries")
    )

  }, error = function(e) {

    stop(
      "Data for '",
      level,
      "' not found. ",
      "Please ensure package data files are installed correctly. ",
      "Expected: ",
      paste0(level, ".rds")
    )
  })
}


#' Validate Required Columns
#'
#' Internal helper function used to validate
#' required dataset columns.
#'
#' @param data Data frame or sf object.
#' @param required_cols Character vector of required columns.
#'
#' @keywords internal
validate_columns <- function(
    data,
    required_cols
) {

  missing_cols <- setdiff(
    required_cols,
    names(data)
  )

  if (length(missing_cols) > 0) {

    stop(
      "Missing required column(s): ",
      paste(missing_cols, collapse = ", ")
    )
  }
}
