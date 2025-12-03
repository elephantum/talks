DIAGRAMS := $(wildcard diagrams/*.mmd)
SVGS := $(DIAGRAMS:.mmd=.svg)
MARP_MD := $(wildcard *.marp.md)
MARP_HTML := $(MARP_MD:.marp.md=.marp.html)

.PHONY: all clean watch

all: $(SVGS) $(MARP_HTML)

# Rule to convert .mmd to .svg
%.svg: %.mmd
	npx mmdc -p puppeteer-config.json -i $< -o $@ -b transparent

# Rule to convert .md to .html
%.marp.html: %.marp.md
	npx marp --html $< -o $@

# Watch mode:
# 1. Watch for changes in diagrams or markdown and run 'make all'
# 2. Run Marp preview server for live editing
watch:
	npx concurrently \
		"npx onchange 'diagrams/*.mmd' '*.marp.md' -- make all" \
		"npx marp -p -w talk.v2.marp.md"
