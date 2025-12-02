DIAGRAMS := $(wildcard talk/diagrams/*.mmd)
SVGS := $(DIAGRAMS:.mmd=.svg)
MARP_MD := talk/talk.v1.marp.md
MARP_HTML := talk/talk.v1.marp.html

.PHONY: all clean watch

all: $(SVGS) $(MARP_HTML)

# Rule to convert .mmd to .svg
%.svg: %.mmd
	npx mmdc -p puppeteer-config.json -i $< -o $@ -b transparent

# Rule to convert .md to .html
$(MARP_HTML): $(MARP_MD)
	npx marp --html $< -o $@

# Watch mode:
# 1. Watch for changes in diagrams or markdown and run 'make all'
# 2. Run Marp preview server for live editing
watch:
	npx concurrently \
		"npx onchange 'talk/diagrams/*.mmd' '$(MARP_MD)' -- make all" \
		"npx marp -p $(MARP_MD)"
