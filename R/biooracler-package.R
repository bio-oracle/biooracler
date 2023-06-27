#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL

#' @name ERDDAP
#' @title Bio-Oracle ERDDAP Server
#'
#' @description
#' The [Bio-Oracle](https://bio-oracle.org/) dataset is made available via an ERDDAP
#' server hosted by the [Flanders Marine Institute (VLIZ)](https://www.vliz.be).
#'
#' ERDDAP is a data server that gives you simple, consistent way to download subsets
#' of scientific datasets in common file formats and make graphs and maps. The Bio-Oracle
#' ERDDAP installation is available online at:
#'
#' http://erddap.bio-oracle.org/erddap/
#'
#' ERDDAP offers a REST API that can be consumed by other software For instance,
#' there is an R package that reads data from ERDDAP named [rerddap]. This package is
#' the backbone behind `biooracler`: In fact, `biooracler` just wraps [rerddap] in a
#' convenient way to only read data from the Bio-Oracle ERDDAP server. But the Bio-Oracle
#' ERDDAP server is independent from the `biooracler` package.
#'
#' You are welcome to access the Bio-Oracle ERDDAP server in your preferred way,
#' including via the [rerddap] R package. This will ease the combination of the
#' Bio-Oracle dataset with several other ERDDAP servers.
#'
#' In addition, there is a Python extension that mimics the methods of `biooracler`. You
#' can access it at:
#'
#' https://github.com/bio-oracle/pyo_oracle/
#'
#' Each dataset in the Bio-Oracle ERDDAP server is identified by a [dataset_id].
#'
#' @return Returns a help page
#'
#' @examples \dontrun{?ERDDAP}
NULL

#' @name dataset_id
#' @title Unique Identifier of a Bio-Oracle dataset in the ERDDAP Server
#'
#' @description
#' The [Bio-Oracle](https://bio-oracle.org/) datasets have an unique identifier in the
#' [ERDDAP] server where they are hosted.
#'
#' Despite the title and summary of the dataset (See [list_layers()]) already describe
#' the data included in the dataset, the `dataset_id` follow a certain naming that
#' indicate the information included inside. For instance:
#'
#' - `phyc_baseline_2000_2020_depthsurf`
#'
#' - `thetao_ssp119_2020_2100_depthmean`
#'
#' - `thetao_baseline_2020_2019_depthsurf`
#'
#'
#' ## Environmental variable
#' Indicated the first part of the naming (e.g. `phyc`, `thetao`). The equivalences are:
#' - `chl` = Chlorophyll
#' - `clt` = Total Cloud Fraction
#' - `dfe` = Dissolved Iron
#' - `mlotst` = Mixed Layer Depth
#' - `no3` = Nitrate
#' - `o2` = Dissolved Molecular Oxygen
#' - `ph` = pH
#' - `phyc` = Total Phytoplankton
#' - `phyc` = Phytoplankton
#' - `po4` = Phosphate
#' - `si` = Silicate
#' - `siconc` = Sea Ice Cover
#' - `sithick` = Sea Ice Thickness
#' - `so` = Salinity
#' - `sws` = Sea Water Speed
#' - `tas` = Air Temperature
#' - `terrain` = Terrain
#' - `thetao` = Ocean Temperature
#'
#' ## Time: Present/Past baseline or Future CMIIP6 Climate Change Projection projection
#'
#' The part with `baseline` or `ssp119` indicates if the layer contains present or past
#' decades, or future climate change projections under the provisions of the
#' [Intergovernmental Panel on Climate Change](https://www.ipcc.ch/) (IPCC) 6th report. This report features the
#' 6th generation of [Coupled Model Intercomparison Projects](https://www.carbonbrief.org/qa-how-do-climate-models-work#cmip) (CMIP6)
#' and describes a few [Shared Socioeconomic Pathways](https://www.carbonbrief.org/explainer-how-shared-socioeconomic-pathways-explore-future-climate-change/) (SSPs), which are different
#' climate change scenarios.
#'
#' The Bio-Oracle dataset predicts the environmental variables for 8 future decades
#' (2020-2100) and for 6 SSPs scenarios: `ssp119`, `ssp126`, `ssp245`, `ssp370`, `ssp460` and `ssp585`.
#'
#' On the other hand, `baseline` refers to the conditions of the environmental variable
#' for the decades of 2000 to 2010 and 2010 to 2020, as interpolated from the
#' [Copernicus Marine Service](https://marine.copernicus.eu/) data. It is named baseline
#' as this interpolated layers are the baseline to model the future predictions.
#'
#' ## Surface or Benthic
#'
#' The Bio-Oracle datasets includes modelled environmental data for the surface sea water
#' layer (`depthsurf`), but also for the bottom of the ocean. Note that all datasets with
#' the subfixes `depthmin`, `depthmean` and `depthmax` refer to the benthic layer and
#' *never refer to different depths of the ocean*. In other words: Bio-Oracle offers you
#' data from the ocean surface or the bottom, but *never different levels of depth*.
#'
#' The subfixes `min`, `mean` and `max` refer to the depth value used during modelling:
#' Bio-Oracle uses bathymetry data from [GEBCO](https://www.gebco.net/), which has a
#' higher resolution than the resolution of Bio-Oracle. Hence, for each grid cell of
#' the Bio-Oracle dataset there are more than one value of bathymetry Three different
#' bathymetry values were selected to fit the models: either the minimal value
#' (`depthmin`), an average of all the bathymetry values (`depthmean`) or the maximum
#' value (`depthmax`).
#'
#' @return Returns a help page
#'
#' @examples \dontrun{?dataset_id}
NULL
