## check_packages.R
## Run before building the site to confirm every R package used in course
## materials is installed.  Exits non-zero if anything is missing.

cran_pkgs <- c(
  "broom", "caret", "data.table", "devtools", "doParallel",
  "dplyr", "dslabs", "emmeans", "forcats", "geomtextpath",
  "gganimate", "ggExtra", "ggplot2", "ggrepel", "ggridges",
  "ggthemes", "gridExtra", "gsheet", "gtools", "HistData",
  "httr2", "janitor", "jsonlite", "kableExtra", "knitr",
  "Lahman", "lattice", "lpSolve", "lubridate", "maps",
  "MASS", "matrixStats", "NHANES", "purrr", "randomForest",
  "RColorBrewer", "readr", "readxl", "remotes", "reshape2",
  "rpart", "rvest", "scales", "shiny", "tidyr", "tidyverse",
  "VennDiagram"
)

# Packages installed from GitHub (check by name only)
github_pkgs <- c("excessmort", "ThemePark")

all_pkgs <- c(cran_pkgs, github_pkgs)

missing <- all_pkgs[!vapply(all_pkgs, requireNamespace, logical(1), quietly = TRUE)]

if (length(missing) == 0) {
  cat("OK: all", length(all_pkgs), "packages are available.\n")
} else {
  cat("MISSING packages (", length(missing), "):\n", sep = "")
  for (pkg in missing) {
    if (pkg %in% github_pkgs) {
      src <- switch(pkg,
        excessmort = "rafalab/excessmort",
        ThemePark  = "MatthewBJane/ThemePark"
      )
      cat("  ", pkg, "  [GitHub:", src, "]\n")
    } else {
      cat("  ", pkg, "\n")
    }
  }
  cat("\nInstall CRAN packages with:\n")
  cran_missing <- missing[missing %in% cran_pkgs]
  if (length(cran_missing))
    cat('  install.packages(c(', paste0('"', cran_missing, '"', collapse = ", "), '))\n')
  gh_missing <- missing[missing %in% github_pkgs]
  if (length(gh_missing)) {
    cat("Install GitHub packages with:\n")
    for (pkg in gh_missing) {
      src <- switch(pkg,
        excessmort = "rafalab/excessmort",
        ThemePark  = "MatthewBJane/ThemePark"
      )
      cat('  remotes::install_github("', src, '")\n', sep = "")
    }
  }
  quit(status = 1)
}
