all: README.pdf READ.FRENCH.NFI.pdf RECRUIT.FORMAT.pdf FORMAT.NFI.FUNDIV.pdf


README.pdf: README.md include.tex
	pandoc $<   --template=include.tex --variable mainfont="Times New Roman" --variable sansfont=Arial --variable fontsize=12pt --latex-engine=xelatex -o $@

READ.FRENCH.NFI.md: READ.FRENCH.NFI.Rmd
	Rscript  -e "library(knitr);  knit('READ.FRENCH.NFI.Rmd', output = 'READ.FRENCH.NFI.md')"	

READ.FRENCH.NFI.pdf: READ.FRENCH.NFI.md include.tex
	pandoc $<   --template=include.tex --variable mainfont="Times New Roman" --variable sansfont=Arial --variable fontsize=12pt --latex-engine=xelatex -o $@

SIMPLIF.RECRUIT.FORMAT.md: SIMPLIF.RECRUIT.FORMAT.Rmd
	Rscript  -e "library(knitr);  knit('SIMPLIF.RECRUIT.FORMAT.Rmd', output = 'SIMPLIF.RECRUIT.FORMAT.md')"	

SIMPLIF.RECRUIT.FORMAT.pdf: SIMPLIF.RECRUIT.FORMAT.md include.tex
	pandoc $<  --template=include.tex --variable mainfont="Times New Roman" --variable sansfont=Arial --variable fontsize=12pt --latex-engine=xelatex -o $@

FORMAT.NFI.FUNDIV.md: FORMAT.NFI.FUNDIV.Rmd
	Rscript  -e "library(knitr);  knit('FORMAT.NFI.FUNDIV.Rmd', output = 'FORMAT.NFI.FUNDIV.md')"	

FORMAT.NFI.FUNDIV.pdf: FORMAT.NFI.FUNDIV.md include.tex
	pandoc $<  --template=include.tex --variable mainfont="Times New Roman" --variable sansfont=Arial --variable fontsize=12pt --latex-engine=xelatex -o $@


clean:
	rm -f *.pdf
