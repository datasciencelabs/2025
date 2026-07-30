## check_packages.R
## Run before building the site to confirm R packages are available.
##
## Two tiers:
##   build_pkgs  -- used in executed code chunks; missing ones WILL break render
##   student_pkgs -- referenced in eval:false exercise templates; students need
##                   them but the site renders fine without them
##
## Exits non-zero only if build-critical packages are missing.

build_pkgs <- c(
  "broom", "caret", "data.table", "devtools", "doParallel",
  "dplyr", "dslabs", "emmeans", "forcats", "geomtextpath",
  "ggplot2", "ggrepel", "ggridges", "ggthemes", "gridExtra",
  "gtools", "HistData", "httr2", "janitor", "jsonlite",
  "kableExtra", "knitr", "Lahman", "lattice", "lpSolve",
  "lubridate", "maps", "MASS", "matrixStats", "NHANES",
  "purrr", "randomForest", "RColorBrewer", "readr", "readxl",
  "remotes", "reshape2", "rpart", "rvest", "scales",
  "shiny", "ThemePark", "tidyr", "tidyverse", "VennDiagram"
)

# eval:false in student exercise templates — site renders without these,
# but students need them to complete the problem sets
student_pkgs <- c(
  "excessmort",  # pset-08 (install_github("rafalab/excessmort"))
  "gganimate",   # dataviz slide (eval:false demo)
  "gsheet"       # pset-07 (eval:false)
)

check <- function(pkgs) {
  pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
}

missing_build   <- check(build_pkgs)
missing_student <- check(student_pkgs)

if (length(missing_student) > 0) {
  cat("NOTE: student-exercise packages not installed (site will still render):\n")
  for (pkg in missing_student) cat("  ", pkg, "\n")
  cat("\n")
}

if (length(missing_build) == 0) {
  cat("OK: all", length(build_pkgs), "build-critical packages are available.\n")
} else {
  cat("ERROR: build-critical packages missing (", length(missing_build), ") -- render will fail:\n", sep = "")
  for (pkg in missing_build) cat("  ", pkg, "\n")
  cat("\nInstall with:\n")
  cat('  install.packages(c(', paste0('"', missing_build, '"', collapse = ", "), '))\n')
  quit(status = 1)
}
