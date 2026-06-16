# List the layers in the Bio-Oracle dataset

List the layers in the Bio-Oracle dataset

## Usage

``` r
list_layers(..., simplify = TRUE)
```

## Format

### `list_layers()`

A data frame with at least three columns

- dataset_id:

  Unique identifier of the Bio-Oracle layer, see
  [dataset_id](https://bio-oracle.github.io/biooracler/reference/dataset_id.md).
  Use in
  [`download_layers()`](https://bio-oracle.github.io/biooracler/reference/download_layers.md)
  or
  [`info_layer()`](https://bio-oracle.github.io/biooracler/reference/info_layer.md)

- title:

  Title of the Bio-Oracle layer

- summary:

  Description of the Bio-Oracle layer

- ...:

  More columns, output from
  [`rerddap::ed_search_adv()`](https://docs.ropensci.org/rerddap/reference/ed_search_adv.html)

## Arguments

- ...:

  Free text search or pass params to
  [rerddap::ed_search_adv](https://docs.ropensci.org/rerddap/reference/ed_search_adv.html)

- simplify:

  Logical. Return only basic information? Default is TRUE. See format
  section.

## Value

A data frame with the dataset ID that can be later passed to
[`download_layers()`](https://bio-oracle.github.io/biooracler/reference/download_layers.md)

## See also

[`download_layers()`](https://bio-oracle.github.io/biooracler/reference/download_layers.md),
[ERDDAP](https://bio-oracle.github.io/biooracler/reference/ERDDAP.md),
[dataset_id](https://bio-oracle.github.io/biooracler/reference/dataset_id.md)

## Examples

``` r
if (FALSE) { # \dontrun{
list_layers()
list_layers("Ocean Temperature 2100")
list_layers("Ocean Temperature 2100", simplify = FALSE)
list_layers("thetao_ssp119_2020_2100_depthmean")
} # }
```
