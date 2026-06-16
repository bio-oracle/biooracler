# Getting started with biooracler

## What is Bio-Oracle?

[Bio-Oracle](https://bio-oracle.org/) provides marine environmental
layers (temperature, salinity, nutrients, ice cover, and more) for both
present-day conditions and future climate-change projections. The data
are served through an [ERDDAP](https://erddap.bio-oracle.org/erddap/)
server hosted by the Flanders Marine Institute (VLIZ).

`biooracler` is a thin wrapper around
[`rerddap`](https://docs.ropensci.org/rerddap/) that makes it convenient
to search, inspect, and download these layers from R.

``` r

library(biooracler)
```

## Listing and searching layers

Every dataset on the server has a unique `dataset_id`. Use
[`list_layers()`](https://bio-oracle.github.io/biooracler/reference/list_layers.md)
to see what is available, or pass a free-text query to narrow the
search.

``` r

# All layers
list_layers()

# Free-text search
list_layers("Ocean Temperature")
```

The naming of a `dataset_id` encodes the variable, time period, and
depth, for example `thetao_ssp585_2020_2100_depthsurf` (ocean
temperature, SSP5-8.5 scenario, 2020-2100, surface). See
[`?dataset_id`](https://bio-oracle.github.io/biooracler/reference/dataset_id.md)
for the full convention.

## Inspecting a single layer

[`info_layer()`](https://bio-oracle.github.io/biooracler/reference/info_layer.md)
returns the metadata for one dataset, including its variables and the
ranges of its dimensions (time, latitude, longitude). Use it to find
valid constraint values before downloading.

``` r

info_layer("thetao_baseline_2000_2019_depthsurf")
```

## Downloading data

[`download_layers()`](https://bio-oracle.github.io/biooracler/reference/download_layers.md)
is the main function. You give it a `dataset_id`, the `variables` you
want, and a list of `constraints` on the `time`, `latitude`, and
`longitude` dimensions.

``` r

dataset_id <- "thetao_baseline_2000_2019_depthsurf"

constraints <- list(
  time      = c("2000-01-01T00:00:00Z", "2010-01-01T00:00:00Z"),
  latitude  = c(40, 50),
  longitude = c(-10, 0)
)

layers <- download_layers(
  dataset_id,
  variables   = c("thetao_mean"),
  constraints = constraints
)

layers
```

By default the result is a
[`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html),
ready for mapping and analysis:

``` r

terra::plot(layers)
```

### Output formats

The `fmt` argument controls the return type:

- `"raster"` (default): a
  [`terra::SpatRaster`](https://rspatial.github.io/terra/reference/SpatRaster-class.html).
- `"nc"`: the parsed NetCDF object from `rerddap`.
- `"csv"`: a `data.frame` of the values.

``` r

df <- download_layers(dataset_id, "thetao_mean", constraints, fmt = "csv")
head(df)
```

### Choosing where files are saved

Downloads are cached on disk. Pass `directory` to choose where, and
`filename` to give the file a human-readable name instead of the default
cache hash.

``` r

download_layers(
  dataset_id, "thetao_mean", constraints,
  directory = tempdir(),
  filename  = "thetao_baseline_NE_atlantic"
)
```

## A note on the `time` constraint

The `time` constraint is a **range**: every time step that falls within
it is returned as a separate layer. Decadal baseline datasets store
snapshots on decade boundaries, so a range that spans two snapshots
returns two layers. To get a single time step, set the start and end of
`time` to the same value.

## Learn more

- [`?download_layers`](https://bio-oracle.github.io/biooracler/reference/download_layers.md),
  [`?list_layers`](https://bio-oracle.github.io/biooracler/reference/list_layers.md),
  [`?info_layer`](https://bio-oracle.github.io/biooracler/reference/info_layer.md)
  for function reference.
- [`?dataset_id`](https://bio-oracle.github.io/biooracler/reference/dataset_id.md)
  for the dataset naming convention.
- The [Bio-Oracle website](https://bio-oracle.org/) for the science
  behind the data.
