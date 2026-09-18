#!/bin/zsh

quarto render src --profile all-chapters --to julia-pdf
mv src/_book/Modern-Scientific-Computing-with-Julia.pdf build/Book-latest.pdf
