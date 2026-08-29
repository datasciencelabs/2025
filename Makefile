.PHONY: render preview clean precheck check-cran check-legacy check-urls check-years

# Verify all R packages used in course materials are installed
precheck:
	@Rscript check_packages.R

# Verify CRAN packages are still listed on CRAN (catches archiving between course iterations)
# Requires internet access.  GitHub-sourced packages (ThemePark, excessmort) are excluded.
check-cran:
	@Rscript -e "\
	  source('check_packages.R', echo=FALSE); \
	  cat('Checking CRAN availability...\n'); \
	  avail <- rownames(available.packages(repos='https://cloud.r-project.org')); \
	  gone  <- setdiff(cran_build_pkgs, avail); \
	  also  <- setdiff(c('gganimate','gsheet'), avail); \
	  all_gone <- c(gone, also); \
	  if (length(all_gone) == 0) { \
	    cat('OK: all CRAN packages are still listed on CRAN.\n') \
	  } else { \
	    cat('WARNING: these packages no longer appear on CRAN:\n'); \
	    for (p in all_gone) cat('  ', p, '\n'); \
	    quit(status=1) \
	  }"

render:
	quarto render

preview:
	quarto preview

clean:
	rm -rf docs/

# Find any remaining datasciencelabs.github.io references
check-legacy:
	@echo "=== datasciencelabs.github.io references ==="
	@grep -rn "datasciencelabs.github.io" --include="*.qmd" --include="*.yml" . | grep -v "^\./docs/" || echo "None found."

# Frequency-sorted list of all external URLs (for audits)
check-urls:
	@echo "=== External absolute URLs ==="
	@grep -rohE "https?://[^)\"'> ]+" --include="*.qmd" . | grep -v "^\./docs/" | sort | uniq -c | sort -rn

# Find hardcoded year references to update at annual course refresh
check-years:
	@echo "=== Year references (may need updating) ==="
	@grep -rn "2025\|2024" --include="*.qmd" . | grep -v "^\./docs/" | grep -v "rafalab\|github\.com\|census\.gov\|cdc\.gov"
