SHELL:=/bin/bash
NXF_VER:=0.29.0

run: install
	./nextflow -log .nextflow.noError.log run email-noError.nf
	./nextflow -log .nextflow.brokenPipe.log run email-brokenPipe.nf 

./nextflow:
	if [ "$$( module > /dev/null 2>&1; echo $$?)" -eq 0 ]; then module unload java && module load java/1.8 ; fi ; \
	export NXF_VER="$(NXF_VER)" && \
	printf ">>> Intalling Nextflow in the local directory" && \
	curl -fsSL get.nextflow.io | bash

install: ./nextflow


clean: 
	[ -d work ] && mv work oldwork && rm -rf oldwork &
	[ -d output ] && mv output oldoutput && rm -rf oldoutput &	
	rm -f *.dot.*
	rm -f *.html.*
	rm -f .nextflow.log.*
	rm -f trace*.txt.*
	[ -d .nextflow ] && mv .nextflow .nextflowold && rm -rf .nextflowold &
	rm -f .nextflow.*log*
	rm -f *.png
	rm -f trace*.txt*
	rm -f *.html*
