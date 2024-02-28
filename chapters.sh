#!/bin/zsh

quarto render src --profile julia-language --to julia-pdf
mv src/_chapters/Basics-of-the-Julia-Language.pdf build/Chapter1-latest.pdf

quarto render src --profile type-system --to julia-pdf
mv src/_chapters/Julia-s-Type-System.pdf build/Chapter2-latest.pdf

quarto render src --profile methods-multiple-dispatch --to julia-pdf
mv src/_chapters/Methods---Multiple-Dispatch.pdf build/Chapter3-latest.pdf

quarto render src --profile arrays --to julia-pdf
mv src/_chapters/Working-with-Arrays.pdf build/Chapter4-latest.pdf
