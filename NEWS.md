# biooracler (development version)

* `download_layers()` gains a `filename` argument to save downloaded files under a
  human-readable name instead of the cryptic cache hash (#13).
* `download_layers()` now reports clearer error messages when the Bio-Oracle ERDDAP
  server is unreachable or constraints fall outside the dataset range, and warns when
  a query returns no data (#3).
* Documentation clarifies that the `time` constraint is a range (one layer per time
  step within it, #18) and that the raster extent reaches half a cell beyond nominal
  bounds because ERDDAP reports cell-center coordinates (#20).
