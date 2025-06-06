SHELL := /bin/bash
FTPNCBI=ftp.ncbi.nlm.nih.gov
GBURL=https://$(FTPNCBI)/genbank
GBRELEASE_URL=$(GBURL)/GB_Release_Number

TAXOURL=https://$(FTPNCBI)/pub/taxonomy/taxdump.tar.gz

GBRELEASE:=$(shell curl $(GBRELEASE_URL))

GBDIV_ALL:=$(shell curl -L ${GBURL} \
                  | grep -E 'gb.+\.seq\.gz' \
				  | sed -E 's@^.*<a href="gb([^0-9]+)[0-9]+\.seq.gz.*$$@\1@' \
				  | sort \
				  | uniq)

GBDIV=bct inv mam phg pln pri rod vrl vrt
DIRECTORIES=fasta fasta_fgs

GBFILE_ALL:=$(shell curl -L ${GBURL} \
					| grep -E "gb($$(tr ' ' '|' <<< "${GBDIV}"))[0-9]+" \
					| sed -E 's@^<a href="(gb.+.seq.gz)">.*$$@\1@')


SUFFIXES += .d
NODEPS:=clean taxonomy
DEPFILES:=$(wildcard Release_$(GBRELEASE)/depends/*.d)

ifeq (0, $(words $(findstring $(MAKECMDGOALS), $(NODEPS))))
    #Chances are, these files don't exist.  GMake will create them and
    #clean up automatically afterwards
    -include $(DEPFILES)
endif


all: depends directories FORCE
	@make downloads

downloads: taxonomy fasta_files 
	@echo Genbank Release number $(GBRELEASE)
	@echo all divisions : $(GBDIV_ALL)

FORCE:
	@sleep 1

.PHONY: all directories depends taxonomy fasta_files FORCE

depends: directories Release_$(GBRELEASE)/depends/gbfiles.d Makefile

division: $(GBDIV)

taxonomy: directories Release_$(GBRELEASE)/taxonomy

directories: Release_$(GBRELEASE)/fasta Release_$(GBRELEASE)/stamp Release_$(GBRELEASE)/tmp 

Release_$(GBRELEASE):
	@mkdir -p $@ 
	@echo Create $@ directory

Release_$(GBRELEASE)/fasta: Release_$(GBRELEASE)
	@mkdir -p $@ 
	@echo Create $@ directory

Release_$(GBRELEASE)/stamp: Release_$(GBRELEASE)
	@mkdir -p $@ 
	@echo Create $@ directory

Release_$(GBRELEASE)/tmp: Release_$(GBRELEASE)
	@mkdir -p $@ 
	@echo Create $@ directory

Release_$(GBRELEASE)/depends/gbfiles.d: Makefile
	@echo Create depends directory
	@mkdir -p Release_$(GBRELEASE)/depends
	@for f in ${GBFILE_ALL} ; do \
	            echo -e "Release_$(GBRELEASE)/stamp/$$f.stamp:" ; \
				echo -e "\t@echo Downloading file : $$f..." ; \
				echo -e "\t@mkdir -p Release_$(GBRELEASE)/tmp" ; \
				echo -e "\t@mkdir -p Release_$(GBRELEASE)/stamp" ; \
				echo -e "\t@curl -L ${GBURL}/$$f > Release_$(GBRELEASE)/tmp/$$f && touch \$$@"  ; \
				echo ; \
				div=$$(sed -E 's@^gb(...).*$$@\1@' <<< $$f) ; \
				fasta="Release_$(GBRELEASE)/fasta/$$div/$${f/.seq.gz/.fasta.gz}" ; \
				fasta_fgs="Release_$(GBRELEASE)/fasta_fgs/$$div/$${f/.seq.gz/.fasta.gz}" ; \
				fasta_files="$$fasta_files $$fasta" ; \
				fasta_fgs_files="$$fasta_fgs_files $$fasta_fgs" ; \
				echo -e "$$fasta: Release_$(GBRELEASE)/stamp/$$f.stamp" ; \
				echo -e "\t@echo converting file : \$$< in fasta" ; \
				echo -e "\t@mkdir -p Release_$(GBRELEASE)/fasta/$$div" ; \
				echo -e "\t@obiconvert -Z --fasta-output --skip-empty  \\" ; \
				echo -e "\t            Release_$(GBRELEASE)/tmp/$$f > Release_$(GBRELEASE)/tmp/$${f/.seq.gz/.fasta.gz} \\" ; \
				echo -e "\t            && mv Release_$(GBRELEASE)/tmp/$${f/.seq.gz/.fasta.gz} \$$@  \\" ; \
				echo -e "\t            && rm -f Release_$(GBRELEASE)/tmp/$$f  \\" ; \
				echo -e "\t            || rm -f \$$@" ; \
				echo -e "\t@echo conversion of $$@ done." ; \
				echo ; \
				done > $@ ; \
				echo >> $@ ; \
				echo "fasta_files: $$fasta_files" >> $@ ; 

Release_$(GBRELEASE)/taxonomy: 
	mkdir -p $@
	curl -iL $(TAXOURL) \
	| tar -C $@ -zxf -  
