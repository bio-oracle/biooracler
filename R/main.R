#' Downloads a griddap dataset from an ERDDAP server
#'
#' @param url
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
#' @examples
#'
#' # Test variables
#' url = "https://erddap-test.emodnet.eu/erddap/"
#' datasetid = "biooracle_dmo_ds"
#' time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
#' latitude = c(10, 20)
#' longitude = c(120, 130)
#' variables = c("o2_mean")
#' constraints = list(time, latitude, longitude)
#' fmt = "nc"
#' names(constraints) = c("time", "latitude", "longitude")
#' # Test call
#' download_dataset(datasetid, variables, constraints)
download_dataset = function(dataset,
                                    variables,
                                    constraints,
                                    url="https://erddap-test.emodnet.eu/erddap/",
                                    fmt="nc",
                                    directory=FALSE,
                                    verbose=TRUE,
                                    debug=FALSE
) {

  printer = function(message, verbose=parent.frame()$verbose) {
    if(verbose) { message }
  }
  # Args to be passed to griddap call later on
  docallargs = list()
  docallargs[["fmt"]] = fmt
  out = rerddap::info(datasetid=dataset, url=url)
  docallargs[["x"]] = out

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
  print(res)
  return(res)
}


list_layers = function(url = "https://erddap-test.emodnet.eu/erddap/", filter_biooracle=TRUE) {
  response = rerddap::ed_datasets("griddap", url=url)
  if (isTRUE(filter_biooracle)) {
    response = response %>% filter(grepl("biooracle",Dataset.ID))
  }
  return(response)
}