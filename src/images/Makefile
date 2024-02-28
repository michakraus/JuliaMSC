
all: pdf png

pdf:
	xelatex -shell-escape memory-layout-column-major
	xelatex -shell-escape memory-layout-column-major-linear
	xelatex -shell-escape memory-layout-row-major
	xelatex -shell-escape memory-layout-row-major-linear
	xelatex -shell-escape memory-layout

png: pdf
	pdftocairo  -png -r 150 -transp -singlefile  memory-layout-column-major.pdf             memory-layout-column-major
	pdftocairo  -png -r 150 -transp -singlefile  memory-layout-column-major-linear.pdf      memory-layout-column-major-linear
	pdftocairo  -png -r 150 -transp -singlefile  memory-layout-row-major.pdf                memory-layout-row-major
	pdftocairo  -png -r 150 -transp -singlefile  memory-layout-row-major-linear.pdf         memory-layout-row-major-linear
	pdftocairo  -png -r 300 -transp -singlefile  memory-layout.pdf                          memory-layout

clean:
	rm -f *.aux
	rm -f *.fdb_latexmk
	rm -f *.fls
	rm -f *.log
	rm -f *.pdf
	rm -f *.synctex.gz
	rm -f *.xdv

empty: clean
	rm -f *.png
	rm -f *.svg
