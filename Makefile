.PHONY: render preview clean check-legacy check-urls check-years

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
