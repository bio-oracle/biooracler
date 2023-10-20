
<!-- README.md is generated from README.Rmd. Please edit that file -->

# biooracler

<!-- badges: start -->
<!-- badges: end -->

`biooracler` provides access to the
[Bio-Oracle](https://bio-oracle.org/) dataset via ERDDAP server. It will
partly replace
[sdmpredictors](https://github.com/lifewatch/sdmpredictors).

## Installation

You can install the development version of biooracler from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("bio-oracle/biooracler")
```

## List Layers

You can look-up available layers or search specific environmental
variables.

### Search available layers

``` r
library(biooracler)
list_layers("Ocean Temperature")
#> # A tibble: 28 × 3
#>    dataset_id                          title                             summary
#>    <chr>                               <chr>                             <chr>  
#>  1 thetao_baseline_2000_2019_depthmax  Bio-Oracle OceanTemperature [dep… "Uses …
#>  2 thetao_ssp119_2020_2100_depthmax    Bio-Oracle OceanTemperature [dep… "Uses …
#>  3 thetao_ssp126_2020_2100_depthmax    Bio-Oracle OceanTemperature [dep… "Uses …
#>  4 thetao_ssp245_2020_2100_depthmax    Bio-Oracle OceanTemperature [dep… "Uses …
#>  5 thetao_ssp370_2020_2100_depthmax    Bio-Oracle OceanTemperature [dep… "Uses …
#>  6 thetao_ssp460_2020_2100_depthmax    Bio-Oracle OceanTemperature [dep… "Uses …
#>  7 thetao_ssp585_2020_2100_depthmax    Bio-Oracle OceanTemperature [dep… "Uses …
#>  8 thetao_baseline_2000_2019_depthmean Bio-Oracle OceanTemperature [dep… "Uses …
#>  9 thetao_ssp119_2020_2100_depthmean   Bio-Oracle OceanTemperature [dep… "Uses …
#> 10 thetao_ssp126_2020_2100_depthmean   Bio-Oracle OceanTemperature [dep… "Uses …
#> # ℹ 18 more rows
```

### See all available layers

``` r
list_layers()
#> # A tibble: 321 × 3
#>    dataset_id                       title                                summary
#>    <chr>                            <chr>                                <chr>  
#>  1 tas_baseline_2000_2020_depthsurf Bio-Oracle AirTemperature [depthSur… "Uses …
#>  2 tas_ssp119_2020_2100_depthsurf   Bio-Oracle AirTemperature [depthSur… "Uses …
#>  3 tas_ssp126_2020_2100_depthsurf   Bio-Oracle AirTemperature [depthSur… "Uses …
#>  4 tas_ssp245_2020_2100_depthsurf   Bio-Oracle AirTemperature [depthSur… "Uses …
#>  5 tas_ssp370_2020_2100_depthsurf   Bio-Oracle AirTemperature [depthSur… "Uses …
#>  6 tas_ssp460_2020_2100_depthsurf   Bio-Oracle AirTemperature [depthSur… "Uses …
#>  7 tas_ssp585_2020_2100_depthsurf   Bio-Oracle AirTemperature [depthSur… "Uses …
#>  8 chl_baseline_2000_2018_depthsurf Bio-Oracle Chlorophyll [depthSurf] … "Uses …
#>  9 chl_ssp119_2020_2100_depthsurf   Bio-Oracle Chlorophyll [depthSurf] … "Uses …
#> 10 chl_ssp126_2020_2100_depthsurf   Bio-Oracle Chlorophyll [depthSurf] … "Uses …
#> # ℹ 311 more rows
```

### See all information of all layers

``` r
list_layers(simplify = FALSE)
#> # A tibble: 321 × 16
#>    griddap          subset tabledap make_a_graph wms   files title summary fgdc 
#>    <chr>            <chr>  <chr>    <chr>        <chr> <chr> <chr> <chr>   <chr>
#>  1 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  2 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  3 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  4 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  5 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  6 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  7 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  8 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#>  9 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#> 10 https://erddap.… ""     ""       https://erd… http… http… Bio-… "Uses … http…
#> # ℹ 311 more rows
#> # ℹ 7 more variables: iso_19115 <chr>, info <chr>, background_info <chr>,
#> #   rss <chr>, email <chr>, institution <chr>, dataset_id <chr>
```

## Layer information

``` r
info_layer("tas_baseline_2000_2020_depthsurf")
#> <ERDDAP info> tas_baseline_2000_2020_depthsurf 
#>  Base URL: http://erddap.bio-oracle.org/erddap 
#>  Dataset Type: griddap 
#>  Dimensions (range):  
#>      time: (2000-01-01T00:00:00Z, 2010-01-01T00:00:00Z) 
#>      latitude: (-89.975, 89.975) 
#>      longitude: (-179.975, 179.975) 
#>  Variables:  
#>      tas_ltmax: 
#>          Units: K 
#>      tas_ltmin: 
#>          Units: K 
#>      tas_max: 
#>          Units: K 
#>      tas_mean: 
#>          Units: K 
#>      tas_min: 
#>          Units: K 
#>      tas_range: 
#>          Units: K
```

## Download layers

First you need to define dataset to download together with the time,
latitude and longitude constrains

``` r
dataset_id <- "tas_baseline_2000_2020_depthsurf"

time = c('2001-01-01T00:00:00Z', '2010-01-01T00:00:00Z')
latitude = c(10, 20)
longitude = c(120, 130)

constraints = list(time, latitude, longitude)
names(constraints) = c("time", "latitude", "longitude")
```

Define also the variables to download:

``` r
variables = c("tas_max", "tas_min")
```

Perform download

``` r
layers <- download_layers(dataset_id, variables, constraints)
#> Selected dataset tas_baseline_2000_2020_depthsurf.
#> Dataset info available at: http://erddap.bio-oracle.org/erddap/griddap/tas_baseline_2000_2020_depthsurf.html
#> Selected 2 variables: tas_max, tas_min
```

You can modify the download path and the output type with the arguments
`directory` and `fmt` respectively.

``` r
dir <- tempdir()
download_layers(dataset_id, variables, constraints, fmt = "csv", directory = dir)
#> Selected dataset tas_baseline_2000_2020_depthsurf.
#> Dataset info available at: http://erddap.bio-oracle.org/erddap/griddap/tas_baseline_2000_2020_depthsurf.html
#> Selected 2 variables: tas_max, tas_min
#> <ERDDAP griddap> tas_baseline_2000_2020_depthsurf
#>    Path: [C:\Users\SALVAD~1\AppData\Local\Temp\RtmpEjAOFu\8774b92c003f15b9f929254b0341496f.csv]
#>    Last updated: [2023-10-20 12:31:25.224197]
#>    File size:    [5.59 mb]
#>    Dimensions:   [80802 X 5]
#> 
#> # A tibble: 80,802 × 5
#>    time                 latitude longitude tas_max tas_min
#>    <chr>                   <dbl>     <dbl>   <dbl>   <dbl>
#>  1 2000-01-01T00:00:00Z     10.0      120.    29.5    27.1
#>  2 2000-01-01T00:00:00Z     10.0      120.    29.5    27.1
#>  3 2000-01-01T00:00:00Z     10.0      120.    29.5    27.1
#>  4 2000-01-01T00:00:00Z     10.0      120.    29.5    27.1
#>  5 2000-01-01T00:00:00Z     10.0      120.    29.6    27.2
#>  6 2000-01-01T00:00:00Z     10.0      120.    29.6    27.2
#>  7 2000-01-01T00:00:00Z     10.0      120.    29.6    27.2
#>  8 2000-01-01T00:00:00Z     10.0      120.    29.6    27.2
#>  9 2000-01-01T00:00:00Z     10.0      120.    29.6    27.2
#> 10 2000-01-01T00:00:00Z     10.0      120.    29.6    27.2
#> # ℹ 80,792 more rows


download_layers(dataset_id, variables, constraints, fmt = "raster", directory = dir)
#> Selected dataset tas_baseline_2000_2020_depthsurf.
#> Dataset info available at: http://erddap.bio-oracle.org/erddap/griddap/tas_baseline_2000_2020_depthsurf.html
#> Selected 2 variables: tas_max, tas_min
#> class       : SpatRaster 
#> dimensions  : 201, 201, 4  (nrow, ncol, nlyr)
#> resolution  : 0.04999996, 0.05  (x, y)
#> extent      : 120, 130.05, 10, 20.05  (xmin, xmax, ymin, ymax)
#> coord. ref. : lon/lat WGS 84 
#> sources     : f9db8428abb69301c6f80584b16feaf5.nc:tas_max  (2 layers) 
#>               f9db8428abb69301c6f80584b16feaf5.nc:tas_min  (2 layers) 
#> varnames    : tas_max (Maximum AirTemperature) 
#>               tas_min (Minimum AirTemperature) 
#> names       : tas_max_1, tas_max_2, tas_min_1, tas_min_2 
#> unit        :         K,         K,         K,         K 
#> time        : 2000-01-01 to 2010-01-01 UTC
```
