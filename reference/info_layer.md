# Gets detailed information about a single Bio-Oracle layer

Gets detailed information about a single Bio-Oracle layer

## Usage

``` r
info_layer(dataset_id)
```

## Arguments

- dataset_id:

  An unique identifier of the dataset in
  [ERDDAP](https://bio-oracle.github.io/biooracler/reference/ERDDAP.md).
  See
  [dataset_id](https://bio-oracle.github.io/biooracler/reference/dataset_id.md).

## Value

An object of class
[rerddap::info](https://docs.ropensci.org/rerddap/reference/info.html)
from the
[rerddap::rerddap](https://docs.ropensci.org/rerddap/reference/rerddap.html)
package

## See also

[`list_layers()`](https://bio-oracle.github.io/biooracler/reference/list_layers.md),
[`download_layers()`](https://bio-oracle.github.io/biooracler/reference/download_layers.md),
[ERDDAP](https://bio-oracle.github.io/biooracler/reference/ERDDAP.md),
[dataset_id](https://bio-oracle.github.io/biooracler/reference/dataset_id.md)

## Examples

``` r
if (FALSE) { # \dontrun{
info_layer("thetao_ssp119_2020_2100_depthmean")
} # }
```
