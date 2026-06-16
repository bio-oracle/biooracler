# Bio-Oracle ERDDAP Server

The [Bio-Oracle](https://bio-oracle.org/) dataset is made available via
an ERDDAP server hosted by the [Flanders Marine Institute
(VLIZ)](https://www.vliz.be/en).

ERDDAP is a data server that gives you simple, consistent way to
download subsets of scientific datasets in common file formats and make
graphs and maps. The Bio-Oracle ERDDAP installation is available online
at:

https://erddap.bio-oracle.org/erddap/

ERDDAP offers a REST API that can be consumed by other software For
instance, there is an R package that reads data from ERDDAP named
[rerddap::rerddap](https://docs.ropensci.org/rerddap/reference/rerddap.html).
This package is the backbone behind `biooracler`: In fact, `biooracler`
just wraps
[rerddap::rerddap](https://docs.ropensci.org/rerddap/reference/rerddap.html)
in a convenient way to only read data from the Bio-Oracle ERDDAP server.
But the Bio-Oracle ERDDAP server is independent from the `biooracler`
package.

You are welcome to access the Bio-Oracle ERDDAP server in your preferred
way, including via the
[rerddap::rerddap](https://docs.ropensci.org/rerddap/reference/rerddap.html)
R package. This will ease the combination of the Bio-Oracle dataset with
several other ERDDAP servers.

In addition, there is a Python extension that mimics the methods of
`biooracler`. You can access it at:

https://github.com/bio-oracle/pyo_oracle/

Each dataset in the Bio-Oracle ERDDAP server is identified by a
[dataset_id](https://bio-oracle.github.io/biooracler/reference/dataset_id.md).

## Value

Returns a help page

## Examples

``` r
if (FALSE) ?ERDDAP # \dontrun{}
```
