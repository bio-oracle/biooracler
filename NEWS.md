# biooracler 1.0.0

First stable release.

## New features

* `download_layers()` gains a `filename` argument to save downloaded files under a
  human-readable name instead of the cryptic cache hash (#13).

## Improvements

* `download_layers()` now reports clearer error messages when the Bio-Oracle ERDDAP
  server is unreachable or constraints fall outside the dataset range, and warns when
  a query returns no data (#3).
* The Bio-Oracle ERDDAP server is now contacted over HTTPS.

## Documentation

* Clarified that the `time` constraint is a range (one layer per time step within it,
  #18) and that the raster extent reaches half a cell beyond nominal bounds because
  ERDDAP reports cell-center coordinates (#20).
* Fixed the `dataset_id` reference (duplicate `phyc` entry and a transposed year in an
  example).

## Infrastructure

* Added a GitHub Actions `R-CMD-check` workflow across Linux, macOS and Windows.
* Added `BugReports`, tidied `DESCRIPTION` metadata, and removed unused dependencies
  and dead code.
