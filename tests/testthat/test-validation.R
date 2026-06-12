# Input validation for download_layers(). These run offline: the checks below
# all fail before any request to the ERDDAP server is made.

valid_constraints <- list(
  time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z'),
  latitude = c(10, 11),
  longitude = c(120, 121)
)

test_that("download_layers rejects a malformed dataset_id", {
  expect_error(download_layers(123, constraints = valid_constraints))
  expect_error(download_layers(c("a", "b"), constraints = valid_constraints))
})

test_that("download_layers rejects an invalid fmt", {
  expect_error(
    download_layers("some_id", constraints = valid_constraints, fmt = "tiff")
  )
  expect_error(
    download_layers("some_id", constraints = valid_constraints, fmt = c("nc", "csv"))
  )
})

test_that("download_layers rejects a malformed filename", {
  expect_error(
    download_layers("some_id", constraints = valid_constraints, filename = 1)
  )
  expect_error(
    download_layers("some_id", constraints = valid_constraints,
                    filename = c("a", "b"))
  )
})

test_that("download_layers rejects malformed constraints", {
  # Empty constraints
  expect_error(download_layers("some_id", constraints = list()))
  # Unnamed constraints
  expect_error(download_layers("some_id", constraints = list(c(10, 11))))
  # Unknown constraint name
  expect_error(download_layers(
    "some_id",
    constraints = list(depth = c(0, 10))
  ))
})
