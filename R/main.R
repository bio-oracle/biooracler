#' Downloads a griddap dataset from an ERDDAP server
#'
#' @param dataset
#' @param variables
#' @param constraints
#' @param fmt
#' @param directory
#' @param verbose
#'
#' @return
#' @export
#'
#' @seealso [list_layers]
#'
#' @examples \dontrun{
#' # Test variables
#' datasetid = "tas_baseline_2000_2020_depthsurf"
#' time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
#' latitude = c(10, 20)
#' longitude = c(120, 130)
#' variables = c("tas_max", "tas_min")
#' constraints = list(time, latitude, longitude)
#' names(constraints) = c("time", "latitude", "longitude")
#'
#' # Test call
#' download_dataset(datasetid, variables, constraints)
#' }
download_dataset = function(dataset,
                                    variables,
                                    constraints,
                                    fmt="nc",
                                    directory=FALSE,
                                    verbose=TRUE,
                                    debug=FALSE
) {

  printer = function(message, verbose=parent.frame()$verbose) {
    if(verbose) { message(message) }
  }

  if(fmt == "raster"){
    is_raster <- TRUE
    fmt <- "nc"
  }

  # Args to be passed to griddap call later on
  docallargs = list()
  docallargs[["fmt"]] = fmt
  out = rerddap::info(datasetid=dataset, url = erddap.bio_oracle.org())
  docallargs[["datasetx"]] = out

  printer(sprintf("Selected dataset %s.", dataset))
  printer(sprintf("Dataset info available at: %s/griddap/%s.html", out$base_url, dataset))


  # Setting constraints that match
  for (constraint in names(constraints)) {
    if (constraint %in% names(out$alldata)) {
      docallargs[[constraint]]= get(constraint, constraints)
    }
  }

  # The same for variables
  valid_variables = c()
  for (variable in variables) {
    if (variable %in% out$variables$variable_name) {
      valid_variables = c(valid_variables, variable)
    }
  }

  if (length(valid_variables) > 0) {docallargs[["fields"]] = valid_variables}
  printer(sprintf("Selected %s variables: %s", length(valid_variables), toString(valid_variables)))

  # Set directory for storing data

  if (!isFALSE(directory)) {
    cache_dir <- hoardr::hoard()
    cache_dir$cache_path_set(full_path=directory)
    docallargs[["store"]] = rerddap::disk(cache_dir$cache_path_get())
  }

  # Debug flag to check args if needed
  if (debug) {
    print(docallargs)
  }

  # Call
  res = do.call(rerddap::griddap, docallargs)

  if(is_raster) res <- griddap_to_terra(res)

  return(res)
}

griddap_to_terra <- function(res){
  terra::rast(x$summary$filename)
}



.list_layers <- function(..., simplify = TRUE){

  # Retrieve either full list of layers or loop-up by free-text search
  if(missing(...)){
    layers <- rerddap::ed_datasets(which = "griddap", url = erddap.bio_oracle.org())
  }else{
    layers <- rerddap::ed_search_adv(..., url = erddap.bio_oracle.org())
    layers <- dplyr::bind_rows(layers$alldata)
    attr(layers, "class")
  }

  # Aftermath
  layers <- colnames_normalize(layers)
  if(simplify) layers <- simplify(layers)

  layers
}

colnames_normalize <- function(df){
  colnames(df) <- df %>% colnames() %>% tolower()
  colnames(df) <- gsub(".","_", colnames(df), fixed = TRUE)
  df
}

simplify <- function(df){
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
#'
#' @return a data frame with the dataset ID that can be later passed to [download_layers]
#' and further information
#' @export
#'
#' @seealso [download_layers]
#'
#' @examples \dontrun{
#' list_layers()
#' list_layers("Ocean Temperature 2100")
#' list_layers("thetao_ssp119_2020_2100_depthmean")
#' }
list_layers <- memoise::memoise(.list_layers)
