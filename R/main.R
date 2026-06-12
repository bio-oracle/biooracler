#' Downloads Bio-Oracle layers from the Bio-Oracle ERDDAP server
#'
#' @param dataset_id An unique identifier of the dataset in [ERDDAP]. See [dataset_id].
#' @param variables Variable names to retrieve from the dataset. If NULL (default), all variables are retrieved.
#' @param constraints List to query on dimensions time, latitude and longitude
#' @param fmt Output format. One of 'csv', 'nc' or 'raster' (default). See details.
#' @param directory Local directory where files are cached. If NULL (default), it is as in [rerddap::griddap]
#' @param filename Optional name (without extension) for the downloaded file. If NULL
#'   (default), the cryptic cache name from [rerddap::griddap] is kept. See details.
#' @param verbose Logical: Show info messages? Default is TRUE
#' @param debug Logical: Print extra information that helps debugging? Default is FALSE
#'
#' @details
#'
#' All Bio-Oracle layers retrieved are downloaded to a cache directory and later read
#' into memory in R. Depending on the output format selected on the `fmt` argument you
#' will obtain:
#'
#' - `csv`: An object of class `griddap_csv`. In essence, a `data.frame` with extra info.
#'   A csv file will be downloaded to the cache directory. See [rerddap::griddap()].
#' - `nc`: An object of class `griddap_nc`. This is the unclassed output of [ncdf4::nc_open()].
#'  A [NetCDF](https://www.unidata.ucar.edu/software/netcdf) file will be downloaded to the cache directory. See [rerddap::griddap()].
#' - `raster`: An object of class `SpatRast`, obtained by reading the [NetCDF](https://www.unidata.ucar.edu/software/netcdf) file with `terra::rast`.
#'
#' By default, downloaded files are named with a cryptic hash (as in [rerddap::griddap()]).
#' Pass `filename` to save a human-readable copy, e.g. `filename = "chl_2040_ssp585"`. The
#' copy is written to `directory` (or the cache directory if `directory` is NULL) with the
#' extension matching `fmt`. The original cached file is preserved so caching still works.
#'
#' The `time` constraint is a **range**: every time step that falls within the
#' `[start, end]` interval is returned as a separate layer. Decadal baseline datasets
#' store snapshots on decade boundaries, so a range like `c('2000-01-01T00:00:00Z',
#' '2010-01-01T00:00:00Z')` spans two snapshots (two layers), while
#' `c('2005-01-01T00:00:00Z', '2010-01-01T00:00:00Z')` spans one (single layer). To get a
#' single time step, set the start and end of `time` to the same value.
#'
#' ERDDAP reports coordinates at cell **centers**. As a result, the extent of a returned
#' `raster` reaches half a cell-width beyond the nominal bounds (e.g. slightly past +/-180
#' longitude). This is expected: the data covers the full grid and is not shifted.
#'
#' @return A downloaded `csv` or `nc` file and an object of class `griddap_csv`, `griddap_nc` or `SpatRast`
#' @export
#'
#' @seealso [list_layers()], [info_layer()], [ERDDAP], [dataset_id]
#'
#' @examples \dontrun{
#' # Test variables
#' dataset_id = "tas_baseline_2000_2020_depthsurf"
#' time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
#' latitude = c(10, 20)
#' longitude = c(120, 130)
#' variables = c("tas_max", "tas_min")
#' constraints = list(time, latitude, longitude)
#' names(constraints) = c("time", "latitude", "longitude")
#'
#' # Test call
#' download_layers(dataset_id, variables, constraints)
#' }
download_layers = function(dataset_id,
                                    variables = NULL,
                                    constraints = list(),
                                    fmt = "raster",
                                    directory = NULL,
                                    filename = NULL,
                                    verbose = TRUE,
                                    debug = FALSE
) {
  # Assertions. Cheap local argument checks run first, so calls with bad
  # arguments fail fast before contacting the ERDDAP server.
  checkmate::assert_character(dataset_id, len = 1)
  checkmate::assert_list(constraints, min.len = 1, any.missing = FALSE, unique = TRUE)
  checkmate::assert_names(names(constraints), "unique", subset.of = c("time", "longitude", "latitude"))
  checkmate::assert_character(fmt, len = 1)
  checkmate::assert_choice(fmt, c("csv", "nc", "raster"))
  checkmate::assert_character(filename, len = 1, null.ok = TRUE)
  checkmate::assert_logical(verbose, len = 1)
  checkmate::assert_logical(debug, len = 1)
  # This check queries the server for the list of available datasets.
  checkmate::assert_choice(dataset_id, list_layers()$dataset_id)

  # Config
  printer = function(message, verbose=parent.frame()$verbose) {
    if(verbose) { message(message) }
  }

  is_raster <- FALSE
  if(fmt == "raster"){
    is_raster <- TRUE
    fmt <- "nc"
  }

  dataset_id <- tolower(dataset_id)

  # Args to be passed to griddap call later on
  docallargs = list()
  docallargs[["fmt"]] = fmt
  out = tryCatch(
    rerddap::info(datasetid = dataset_id, url = erddap.bio_oracle.org()),
    error = function(e) stop(
      "Could not retrieve dataset info from the Bio-Oracle ERDDAP server. ",
      "Check your internet connection or the server status at ",
      "https://erddap.bio-oracle.org/ .\nOriginal error: ",
      conditionMessage(e), call. = FALSE))
  docallargs[["datasetx"]] = out

  printer(sprintf("Selected dataset %s.", dataset_id))
  printer(sprintf("Dataset info available at: %s/griddap/%s.html", out$base_url, dataset_id))

  # Setting constraints that match
  for (constraint in names(constraints)) {
    docallargs[[constraint]]= get(constraint, constraints)
  }

  # The same for variables
  if (!is.null(variables)) {
    for(variable in variables){
      checkmate::assert_choice(variable, out$variables$variable_name)
    }
    docallargs[["fields"]] = variables
    printer(sprintf("Selected %s variables: %s", length(variables), toString(variables)))
  }

  # Set directory for storing data
  if (!is.null(directory)) {
    checkmate::assert_directory_exists(directory, "w")
    cache_dir <- hoardr::hoard()
    cache_dir$cache_path_set(full_path=directory)
    docallargs[["store"]] = rerddap::disk(cache_dir$cache_path_get())
  }

  # Debug flag to check args if needed
  if (debug) {
    print(docallargs)
  }

  # Call
  res = tryCatch(
    suppressMessages(do.call(rerddap::griddap, docallargs)),
    error = function(e) stop(
      "The download from the Bio-Oracle ERDDAP server failed. This is usually ",
      "caused by an unreachable server or constraints (time/latitude/longitude) ",
      "outside the dataset range.\nOriginal error: ",
      conditionMessage(e), call. = FALSE))

  # Warn if the query returned no data
  res_data <- res$data
  if (!is.null(res_data) && is.data.frame(res_data) && nrow(res_data) == 0) {
    warning("The query returned no data. Check that your constraints ",
            "(time, latitude, longitude) fall within the dataset range.",
            call. = FALSE)
  }

  # Optionally save a human-readable copy of the downloaded file
  if (!is.null(filename)) {
    src <- res$summary$filename
    ext <- tools::file_ext(src)
    dest_dir <- if (!is.null(directory)) directory else dirname(src)
    dest <- file.path(dest_dir, paste0(filename, ".", ext))
    file.copy(src, dest, overwrite = TRUE)
    res$summary$filename <- dest
    printer(sprintf("Saved file as %s", dest))
  }

  if(is_raster) res <- griddap_to_terra(res)

  return(res)
}

griddap_to_terra <- function(res){
  terra::rast(res$summary$filename)
}



.list_layers <- function(..., simplify = TRUE){
  checkmate::assert_logical(simplify, len = 1)

  # Retrieve either full list of layers or look-up by free-text search
  if(missing(...)){
    layers <- rerddap::ed_datasets(which = "griddap", url = erddap.bio_oracle.org())
  }else{
    layers <- rerddap::ed_search_adv(..., url = erddap.bio_oracle.org())
    layers <- dplyr::bind_rows(layers$alldata)
  }

  # Aftermath
  layers <- colnames_normalize(layers)
  if(simplify) layers <- do_simplify(layers)

  layers
}

colnames_normalize <- function(df){
  colnames(df) <- tolower(colnames(df))
  colnames(df) <- gsub(".","_", colnames(df), fixed = TRUE)
  df
}

do_simplify <- function(df){
  cols_desired <- c("dataset_id", "title", "summary")
  cols_desired_exist <- all(cols_desired %in% colnames(df))

  if(cols_desired_exist){
    df <- df[, cols_desired]
  }

  df
}

#' List the layers in the Bio-Oracle dataset
#'
#' @param ... Free text search or pass params to [rerddap::ed_search_adv]
#' @param simplify Logical. Return only basic information? Default is TRUE. See format section.
#'
#' @format ## `list_layers()`
#' A data frame with at least three columns
#' \describe{
#'   \item{dataset_id}{Unique identifier of the Bio-Oracle layer, see [dataset_id]. Use in [download_layers()] or [info_layer()]}
#'   \item{title}{Title of the Bio-Oracle layer}
#'   \item{summary}{Description of the Bio-Oracle layer}
#'   \item{...}{More columns, output from [rerddap::ed_search_adv()]}
#' }
#'
#' @return A data frame with the dataset ID that can be later passed to [download_layers()]
#' @export
#'
#' @seealso [download_layers()], [ERDDAP], [dataset_id]
#'
#' @examples \dontrun{
#' list_layers()
#' list_layers("Ocean Temperature 2100")
#' list_layers("Ocean Temperature 2100", simplify = FALSE)
#' list_layers("thetao_ssp119_2020_2100_depthmean")
#' }
list_layers <- memoise(.list_layers)


#' Gets detailed information about a single Bio-Oracle layer
#'
#' @param dataset_id An unique identifier of the dataset in [ERDDAP]. See [dataset_id].
#'
#' @return An object of class [info] from the [rerddap] package
#' @export
#'
#' @seealso [list_layers()], [download_layers()], [ERDDAP], [dataset_id]
#'
#' @examples \dontrun{
#' info_layer("thetao_ssp119_2020_2100_depthmean")
#' }
info_layer <- function(dataset_id){
  checkmate::assert_character(dataset_id, len = 1)
  rerddap::info(dataset_id, erddap.bio_oracle.org())
}
