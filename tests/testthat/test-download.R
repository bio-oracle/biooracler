# Config
dataset_id = "tas_baseline_2000_2020_depthsurf"
time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
latitude = c(10, 11)
longitude = c(120, 121)
variables = c("tas_mean")
constraints = list(time, latitude, longitude)
names(constraints) = c("time", "latitude", "longitude")

# Run
test_that("download dataset works", {
  skip_if_offline()
  skip_on_cran()

  # Test call
  test <- download_layers(dataset_id, variables, constraints, fmt = "csv")
    expect_type(test, "list")
    expect_s3_class(test, "griddap_csv")
    expect_s3_class(test, "data.frame")

  test <- download_layers(dataset_id, variables, constraints, fmt = "nc")
    expect_type(test, "list")
    expect_s3_class(test, "griddap_nc")
    expect_s3_class(test, "nc")

  test <- download_layers(dataset_id, variables, constraints, fmt = "raster")
    expect_type(test, "S4")
    expect_s4_class(test, "SpatRaster")


  # Test download to custom dir, and nc response
  temp_dir <- normalizePath(tempdir())
  test_dir <- download_layers(dataset_id, variables, constraints, fmt="nc", directory = temp_dir)
    expect_s3_class(test_dir, "griddap_nc")
    expect_s3_class(test_dir$data, "data.frame")

  out_dir <- normalizePath(dirname(test_dir$summary$filename))
    expect_equal(out_dir, temp_dir)
})

test_that("List layers work", {
  expect_true(memoise::is.memoised(list_layers))

  test <- list_layers()
  expect_s3_class(test, "data.frame")
  expect_equal(ncol(test), 3)

  test <- list_layers("temperature")
  expect_s3_class(test, "data.frame")

  test <- list_layers("temperature", simplify = FALSE)
  expect_s3_class(test, "data.frame")
  expect_gt(ncol(test), 3)
})

test_that("Info layer works", {
  test <- info_layer(dataset_id)
  expect_type(test, "list")
  expect_s3_class(test, "info")
})

