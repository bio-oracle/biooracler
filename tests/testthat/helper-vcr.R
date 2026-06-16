# vcr records the HTTP interactions with the Bio-Oracle ERDDAP server into
# tests/fixtures/*.yml so the metadata tests (list_layers / info_layer) replay
# offline and on CRAN. preserve_exact_body_bytes keeps responses byte-exact.
library(vcr)

invisible(vcr::vcr_configure(
  dir = vcr::vcr_test_path("fixtures"),
  preserve_exact_body_bytes = TRUE
))
