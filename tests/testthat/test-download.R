# list_layers() and info_layer() replay recorded ERDDAP responses via vcr (see
# helper-vcr.R), so they run offline and on CRAN.
#
# download_layers() is intentionally NOT mocked here: rerddap's internal
# erd_up_GET() calls quit(status = 1) on any HTTP error, which cannot be caught
# and would turn a cassette mismatch (e.g. after a server-side change) into a
# hard check failure. Its argument handling is covered offline in
# test-validation.R, and the live smoke test below exercises a real download
# when a network is available (skipped on CRAN).

# Config
dataset_id = "tas_baseline_2000_2020_depthsurf"
time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
latitude = c(10, 11)
longitude = c(120, 121)
variables = c("tas_mean")
constraints = list(time, latitude, longitude)
names(constraints) = c("time", "latitude", "longitude")

test_that("list_layers works", {
  vcr::use_cassette("list_layers", {
    memoise::forget(list_layers)
    test <- list_layers()
    memoise::forget(list_layers)
    test_search <- list_layers("temperature")
    memoise::forget(list_layers)
    test_search_full <- list_layers("temperature", simplify = FALSE)
  })

  expect_true(memoise::is.memoised(list_layers))
  expect_s3_class(test, "data.frame")
  expect_equal(ncol(test), 3)
  expect_s3_class(test_search, "data.frame")
  expect_s3_class(test_search_full, "data.frame")
  expect_gt(ncol(test_search_full), 3)
})

test_that("info_layer works", {
  vcr::use_cassette("info_layer", {
    test <- info_layer(dataset_id)
  })

  expect_type(test, "list")
  expect_s3_class(test, "info")
})

test_that("download_layers works against the live server", {
  skip_on_cran()
  skip_if_offline()

  memoise::forget(list_layers)

  test_csv <- download_layers(dataset_id, variables, constraints, fmt = "csv")
    expect_s3_class(test_csv, "griddap_csv")
    expect_s3_class(test_csv, "data.frame")

  test_nc <- download_layers(dataset_id, variables, constraints, fmt = "nc")
    expect_s3_class(test_nc, "griddap_nc")

  test_ras <- download_layers(dataset_id, variables, constraints, fmt = "raster")
    expect_s4_class(test_ras, "SpatRaster")

  # Custom directory and filename
  temp_dir <- normalizePath(tempdir())
  test_dir <- download_layers(dataset_id, variables, constraints, fmt = "nc",
                              directory = temp_dir)
    expect_equal(normalizePath(dirname(test_dir$summary$filename)), temp_dir)

  test_name <- download_layers(dataset_id, variables, constraints, fmt = "nc",
                               directory = temp_dir, filename = "test_layer")
    expect_equal(basename(test_name$summary$filename), "test_layer.nc")
    expect_true(file.exists(file.path(temp_dir, "test_layer.nc")))
})
