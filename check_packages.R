## check_packages.R
##
## Verifies R packages used in course materials are installed.
## Run via:  make precheck
##
## PACKAGE PROVENANCE
## ------------------
## The vast majority of packages below are from CRAN and can be installed with
## install.packages().  Two packages come from GitHub and carry a sustainability
## risk: if the author's repository is removed or renamed, the package becomes
## unavailable and course materials that reference it will need to be updated.
##
## GitHub dependencies (non-CRAN):
##   ThemePark  -- MatthewBJane/ThemePark (BUILD-CRITICAL: used in 08-ggplot2 slides)
##                 remotes::install_github("MatthewBJane/ThemePark")
##   excessmort -- rafalab/excessmort      (STUDENT-ONLY:  eval:false in pset-08)
##                 remotes::install_github("rafalab/excessmort")
##
## All other packages are from CRAN.  Use `make check-cran` to verify they are
## still listed on CRAN (catches archiving/removal between course iterations).
##
## TWO TIERS
## ---------
##   build_pkgs   packages executed during `quarto render`; missing = broken build
##   student_pkgs packages in eval:false exercise templates; students need them,
##                the site renders without them

## --- CRAN packages (build-critical) -----------------------------------------
cran_build_pkgs <- c(
  "broom", "caret", "data.table", "devtools", "doParallel",
  "dplyr", "dslabs", "emmeans", "forcats", "geomtextpath",
  "ggplot2", "ggrepel", "ggridges", "ggthemes", "gridExtra",
  "gtools", "HistData", "httr2", "janitor", "jsonlite",
  "kableExtra", "knitr", "Lahman", "lattice", "lpSolve",
  "lubridate", "maps", "MASS", "matrixStats", "NHANES",
  "purrr", "randomForest", "RColorBrewer", "readr", "readxl",
  "remotes", "reshape2", "rpart", "rvest", "scales",
  "shiny", "tidyr", "tidyverse", "VennDiagram"
)

## --- GitHub packages (build-critical) ----------------------------------------
github_build_pkgs <- c(
  "ThemePark"   # MatthewBJane/ThemePark -- risk: author-hosted, not on CRAN
)

## --- Packages only needed by students (eval:false in QMD sources) -------------
student_pkgs <- c(
  "gganimate",  # CRAN -- dataviz slide (eval:false demo)
  "gsheet",     # CRAN -- pset-07 (eval:false)
  "excessmort"  # GitHub: rafalab/excessmort -- pset-08 (eval:false)
)

build_pkgs <- c(cran_build_pkgs, github_build_pkgs)

## --- Check function ----------------------------------------------------------
missing_pkgs <- function(pkgs) {
  pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
}

missing_build   <- missing_pkgs(build_pkgs)
missing_student <- missing_pkgs(student_pkgs)

## --- Report ------------------------------------------------------------------
if (length(missing_student) > 0) {
  cat("NOTE: student-exercise packages not installed (site will still render):\n")
  for (pkg in missing_student) cat("  ", pkg, "\n")
  cat("\n")
}

if (length(missing_build) == 0) {
  cat("OK: all", length(build_pkgs), "build-critical packages are available.\n")
  cat("   (", length(cran_build_pkgs), "from CRAN,",
      length(github_build_pkgs), "from GitHub:", paste(github_build_pkgs, collapse = ", "), ")\n")
} else {
  cat("ERROR: build-critical packages missing (", length(missing_build),
      ") -- render will fail:\n", sep = "")
  for (pkg in missing_build) cat("  ", pkg, "\n")
  cat("\nInstall CRAN packages with:\n")
  cran_missing <- intersect(missing_build, cran_build_pkgs)
  if (length(cran_missing))
    cat('  install.packages(c(', paste0('"', cran_missing, '"', collapse = ", "), '))\n')
  gh_missing <- intersect(missing_build, github_build_pkgs)
  if (length(gh_missing)) {
    cat("Install GitHub packages with:\n")
    for (pkg in gh_missing) {
      src <- switch(pkg, ThemePark = "MatthewBJane/ThemePark")
      cat('  remotes::install_github("', src, '")\n', sep = "")
    }
  }
  quit(status = 1)
}
