test_that("download dataset works", {
  skip_if_offline()
  skip_on_cran()

  # Test variables
  url = "https://erddap-test.emodnet.eu/erddap/"
  datasetid = "biooracle_dmo_ds"
  time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
  latitude = c(10, 20)
  longitude = c(120, 130)
  variables = c("o2_mean")
  constraints = list(time, latitude, longitude)
  names(constraints) = c("time", "latitude", "longitude")

  # Test call
  server_is_working <- httr::status_code(httr::HEAD(url)) == 200
  if(server_is_working){
    test <- download_griddap_dataset(url, datasetid, variables, constraints)

    expect_type(test, "list")
    expect_s3_class(test, "griddap_nc")
    expect_s3_class(test$data, "data.frame")

    # Test download to custom dir
    temp_dir <- normalizePath(tempdir())
    test_dir <- download_griddap_dataset(directory = temp_dir, url, datasetid, variables, constraints)

    out_dir <- normalizePath(dirname(test_dir$summary$filename))
    expect_equal(out_dir, temp_dir)
  }

})
