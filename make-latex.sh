#!/bin/sh
#assemble and preprocess all the sources files

pandoc text/pre.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/pre.tex
pandoc text/intro.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/intro.tex
pandoc text/bio.txt --top-level-division=chapter --to latex > latex/bio.tex

for filename in text/ch*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --lua-filter=comm.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"   
done

pandoc text/web.txt --lua-filter=epigraph.lua --to markdown | pandoc --top-level-division=chapter --to latex > latex/web.tex

for filename in text/apx*.txt; do
   [ -e "$filename" ] || continue
   pandoc --lua-filter=extras.lua "$filename" --to markdown | pandoc --lua-filter=extras.lua --to markdown | pandoc --lua-filter=epigraph.lua --to markdown | pandoc --lua-filter=figure.lua --to markdown | pandoc --filter pandoc-fignos --to markdown | pandoc --metadata-file=meta.yml --top-level-division=chapter --bibliography=bibliography/"$(basename "$filename" .txt).bib" --reference-location=section --to latex > latex/"$(basename "$filename" .txt).tex"   
done

pandoc -s latex/*.tex -o book_result/generated_book.tex

pandoc -N --quiet --variable "geometry=margin=1.2in" --variable mainfont="OpenSans-Regular.ttf" --variable sansfont="OpenSans-Regular.ttf" --variable monofont="OpenSans-Regular.ttf" --variable fontsize=12pt --variable version=2.0 book_result/generated_book.tex  --pdf-engine=xelatex --toc -o book_result/generated_book.pdf


#sed -i '' 's+Figure+Εικόνα+g' ./latex/ch0*