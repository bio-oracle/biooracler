# Downloads Bio-Oracle layers from the Bio-Oracle ERDDAP server

Downloads Bio-Oracle layers from the Bio-Oracle ERDDAP server

## Usage

``` r
download_layers(
  dataset_id,
  variables = NULL,
  constraints = list(),
  fmt = "raster",
  directory = NULL,
  filename = NULL,
  verbose = TRUE,
  debug = FALSE
)
```

## Arguments

- dataset_id:

  An unique identifier of the dataset in
  [ERDDAP](https://bio-oracle.github.io/biooracler/reference/ERDDAP.md).
  See
  [dataset_id](https://bio-oracle.github.io/biooracler/reference/dataset_id.md).

- variables:

  Variable names to retrieve from the dataset. If NULL (default), all
  variables are retrieved.

- constraints:

  List to query on dimensions time, latitude and longitude

- fmt:

  Output format. One of 'csv', 'nc' or 'raster' (default). See details.

- directory:

  Local directory where files are cached. If NULL (default), it is as in
  [rerddap::griddap](https://docs.ropensci.org/rerddap/reference/griddap.html)

- filename:

  Optional name (without extension) for the downloaded file. If NULL
  (default), the cryptic cache name from
  [rerddap::griddap](https://docs.ropensci.org/rerddap/reference/griddap.html)
  is kept. See details.

- verbose:

  Logical: Show info messages? Default is TRUE

- debug:

  Logical: Print extra information that helps debugging? Default is
  FALSE

## Value

A downloaded `csv` or `nc` file and an object of class `griddap_csv`,
`griddap_nc` or `SpatRast`

## Details

All Bio-Oracle layers retrieved are downloaded to a cache directory and
later read into memory in R. Depending on the output format selected on
the `fmt` argument you will obtain:

- `csv`: An object of class `griddap_csv`. In essence, a `data.frame`
  with extra info. A csv file will be downloaded to the cache directory.
  See
  [`rerddap::griddap()`](https://docs.ropensci.org/rerddap/reference/griddap.html).

- `nc`: An object of class `griddap_nc`. This is the unclassed output of
  [`ncdf4::nc_open()`](https://rdrr.io/pkg/ncdf4/man/nc_open.html). A
  [NetCDF](https://www.unidata.ucar.edu/software/netcdf) file will be
  downloaded to the cache directory. See
  [`rerddap::griddap()`](https://docs.ropensci.org/rerddap/reference/griddap.html).

- `raster`: An object of class `SpatRast`, obtained by reading the
  [NetCDF](https://www.unidata.ucar.edu/software/netcdf) file with
  [`terra::rast`](https://rspatial.github.io/terra/reference/rast.html).

By default, downloaded files are named with a cryptic hash (as in
[`rerddap::griddap()`](https://docs.ropensci.org/rerddap/reference/griddap.html)).
Pass `filename` to save a human-readable copy, e.g.
`filename = "chl_2040_ssp585"`. The copy is written to `directory` (or
the cache directory if `directory` is NULL) with the extension matching
`fmt`. The original cached file is preserved so caching still works.

The `time` constraint is a **range**: every time step that falls within
the `[start, end]` interval is returned as a separate layer. Decadal
baseline datasets store snapshots on decade boundaries, so a range like
`c('2000-01-01T00:00:00Z', '2010-01-01T00:00:00Z')` spans two snapshots
(two layers), while `c('2005-01-01T00:00:00Z', '2010-01-01T00:00:00Z')`
spans one (single layer). To get a single time step, set the start and
end of `time` to the same value.

ERDDAP reports coordinates at cell **centers**. As a result, the extent
of a returned `raster` reaches half a cell-width beyond the nominal
bounds (e.g. slightly past +/-180 longitude). This is expected: the data
covers the full grid and is not shifted.

## See also

[`list_layers()`](https://bio-oracle.github.io/biooracler/reference/list_layers.md),
[`info_layer()`](https://bio-oracle.github.io/biooracler/reference/info_layer.md),
[ERDDAP](https://bio-oracle.github.io/biooracler/reference/ERDDAP.md),
[dataset_id](https://bio-oracle.github.io/biooracler/reference/dataset_id.md)

## Examples

``` r
if (FALSE) { # \dontrun{
# Test variables
dataset_id = "tas_baseline_2000_2020_depthsurf"
time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
latitude = c(10, 20)
longitude = c(120, 130)
variables = c("tas_max", "tas_min")
constraints = list(time, latitude, longitude)
names(constraints) = c("time", "latitude", "longitude")

# Test call
download_layers(dataset_id, variables, constraints)
} # }
```
