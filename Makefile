# Build the paper: The Staging Line Is Compactness (ACM TOCL; acmart).
#   The venue is set at the top of mss.tex: acm (default), msc, lmcs or article.
#   make          build mss.pdf (latexmk runs pdflatex and bibtex as needed)
#   make check    build, then report errors, undefined refs/cites, and overfull boxes
#   make watch    rebuild on every save
#   make dist     source tarball: mss.tex, mss.bbl, mss.bib, the class files
#   make clean    remove build byproducts, keep mss.pdf
#   make distclean  remove mss.pdf and the tarball too

MAIN    := mss
LATEXMK := latexmk -pdf -interaction=nonstopmode -halt-on-error -file-line-error
SOURCES := $(MAIN).tex $(MAIN).bib $(wildcard *.cls)
DIST    := staging-compactness

.PHONY: all check watch dist clean distclean

all: $(MAIN).pdf

$(MAIN).pdf: $(SOURCES)
	$(LATEXMK) $(MAIN).tex
	bibtex $(MAIN)
	$(LATEXMK) $(MAIN).tex
	$(LATEXMK) $(MAIN).tex

check: $(MAIN).pdf
	@echo '--- errors'; grep -n '^!' $(MAIN).log || echo none
	@echo '--- undefined references and citations'; grep -n -i 'undefined' $(MAIN).log || echo none
	@echo '--- overfull hboxes (under msc.cls, the class adds harmless per-page overflows)'; grep -n 'Overfull .hbox' $(MAIN).log || echo none
	@grep -o 'Output written on .*' $(MAIN).log

watch:
	$(LATEXMK) -pvc -view=none $(MAIN).tex

dist: $(MAIN).pdf
	rm -rf $(DIST) && mkdir $(DIST)
	cp $(MAIN).tex $(MAIN).bbl $(MAIN).bib $(wildcard *.cls) $(DIST)/
	tar czf $(DIST).tar.gz $(DIST) && rm -rf $(DIST)
	@echo wrote $(DIST).tar.gz

clean:
	latexmk -c $(MAIN).tex
	rm -f $(MAIN).bbl $(MAIN).run.xml build.log build.out

distclean: clean
	rm -f $(MAIN).pdf $(DIST).tar.gz
