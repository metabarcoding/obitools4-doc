---
title: "Designing new barcodes"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
bibFile: bibliography/bibliography.json 
---

# Designing new barcodes using Ecoprimers

[`ecoPrimers`](http://metabarcoding.org/ecoprimers) {{< cite "Riaz2011-gn" >}} is a tool to design new DNA metabarcodes. 
It is able to deal with a collection of mitochondrial genomes, of chloroplast genomes, or of rRNA
nuclear cluster. It is a alignment free method, which guaranty for its efficiency.

[`ecoPrimers`](http://metabarcoding.org/ecoprimers) was developed to be used in conjunction with the initial OBITools. Therefore, using them with the new {{% obitools4 %}} requires some special care in preparing the data.
In that recipe, we will use [`ecoPrimers`](http://metabarcoding.org/ecoprimers) to design a new bony fish DNA metabarcode.

## Getting [`ecoPrimers`](http://metabarcoding.org/ecoprimers)

[`ecoPrimers`](http://metabarcoding.org/ecoprimers) is available at the [Git metabarcoding](https://git.metabarcoding.org) site at the following:

- https://git.metabarcoding.org/obitools/ecoprimers

Installation can be done by cloning the project

```bash
git clone https://git.metabarcoding.org/obitools/ecoprimers.git
```

It will create a new `ecoprimers` directory with a `src` subdirectory containing the source code.
You have to change your current working directory to this `ecoprimers/src` directory.

```bash
cd ecoprimers/src
```

It's now possible to compile the ecoPrimers program using the make command

```bash
make
```
```
global.mk:21: ecoprimer.P: No such file or directory
gcc -DMAC_OS_X -M  -o ecoprimer.d ecoprimer.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecoprimer.o ecoprimer.c
/Library/Developer/CommandLineTools/usr/bin/make -C libecoPCR
../global.mk:21: ecodna.P: No such file or directory
../global.mk:21: ecoError.P: No such file or directory
../global.mk:21: ecoIOUtils.P: No such file or directory
../global.mk:21: ecoMalloc.P: No such file or directory
../global.mk:21: ecorank.P: No such file or directory
../global.mk:21: ecoseq.P: No such file or directory
../global.mk:21: ecotax.P: No such file or directory
../global.mk:21: ecofilter.P: No such file or directory
../global.mk:21: econame.P: No such file or directory
gcc -DMAC_OS_X -M  -o econame.d econame.c
gcc -DMAC_OS_X -M  -o ecofilter.d ecofilter.c
gcc -DMAC_OS_X -M  -o ecotax.d ecotax.c
gcc -DMAC_OS_X -M  -o ecoseq.d ecoseq.c
gcc -DMAC_OS_X -M  -o ecorank.d ecorank.c
gcc -DMAC_OS_X -M  -o ecoMalloc.d ecoMalloc.c
gcc -DMAC_OS_X -M  -o ecoIOUtils.d ecoIOUtils.c
gcc -DMAC_OS_X -M  -o ecoError.d ecoError.c
gcc -DMAC_OS_X -M  -o ecodna.d ecodna.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecodna.o ecodna.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecoError.o ecoError.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecoIOUtils.o ecoIOUtils.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecoMalloc.o ecoMalloc.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecorank.o ecorank.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecoseq.o ecoseq.c
ecoseq.c:150:25: warning: comparison of integers of different signs: 'int32_t' (aka 'int') and 'unsigned long' [-Wsign-compare]
  150 |     for (c=seq->SQ,i=0;i<seqlength;c++,i++)
      |                        ~^~~~~~~~~~
1 warning generated.
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecotax.o ecotax.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ecofilter.o ecofilter.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o econame.o econame.c
ar -cr libecoPCR.a ecodna.o ecoError.o ecoIOUtils.o ecoMalloc.o ecorank.o ecoseq.o ecotax.o ecofilter.o econame.o
ranlib libecoPCR.a
/Library/Developer/CommandLineTools/usr/bin/make -C libecoprimer
../global.mk:21: goodtaxon.P: No such file or directory
../global.mk:21: readdnadb.P: No such file or directory
../global.mk:21: smothsort.P: No such file or directory
../global.mk:21: sortword.P: No such file or directory
../global.mk:21: hashsequence.P: No such file or directory
../global.mk:21: strictprimers.P: No such file or directory
../global.mk:21: aproxpattern.P: No such file or directory
../global.mk:21: merge.P: No such file or directory
../global.mk:21: queue.P: No such file or directory
../global.mk:21: libstki.P: No such file or directory
../global.mk:21: sortmatch.P: No such file or directory
../global.mk:21: pairtree.P: No such file or directory
../global.mk:21: pairs.P: No such file or directory
../global.mk:21: taxstats.P: No such file or directory
../global.mk:21: apat_search.P: No such file or directory
../global.mk:21: filtering.P: No such file or directory
../global.mk:21: PrimerSets.P: No such file or directory
../global.mk:21: ahocorasick.P: No such file or directory
gcc -DMAC_OS_X -M  -o ahocorasick.d ahocorasick.c
gcc -DMAC_OS_X -M  -o PrimerSets.d PrimerSets.c
gcc -DMAC_OS_X -M  -o filtering.d filtering.c
gcc -DMAC_OS_X -M  -o apat_search.d apat_search.c
gcc -DMAC_OS_X -M  -o taxstats.d taxstats.c
gcc -DMAC_OS_X -M  -o pairs.d pairs.c
gcc -DMAC_OS_X -M  -o pairtree.d pairtree.c
gcc -DMAC_OS_X -M  -o sortmatch.d sortmatch.c
gcc -DMAC_OS_X -M  -o libstki.d libstki.c
gcc -DMAC_OS_X -M  -o queue.d queue.c
gcc -DMAC_OS_X -M  -o merge.d merge.c
gcc -DMAC_OS_X -M  -o aproxpattern.d aproxpattern.c
gcc -DMAC_OS_X -M  -o strictprimers.d strictprimers.c
gcc -DMAC_OS_X -M  -o hashsequence.d hashsequence.c
gcc -DMAC_OS_X -M  -o sortword.d sortword.c
gcc -DMAC_OS_X -M  -o smothsort.d smothsort.c
gcc -DMAC_OS_X -M  -o readdnadb.d readdnadb.c
gcc -DMAC_OS_X -M  -o goodtaxon.d goodtaxon.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o goodtaxon.o goodtaxon.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o readdnadb.o readdnadb.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o smothsort.o smothsort.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o sortword.o sortword.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o hashsequence.o hashsequence.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o strictprimers.o strictprimers.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o aproxpattern.o aproxpattern.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o merge.o merge.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o queue.o queue.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o libstki.o libstki.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o sortmatch.o sortmatch.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o pairtree.o pairtree.c
pairtree.c:46:13: warning: function 'deletepairlist' is not needed and will not be emitted [-Wunneeded-internal-declaration]
   46 | static void deletepairlist(ppairlist_t list)
      |             ^~~~~~~~~~~~~~
1 warning generated.
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o pairs.o pairs.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o taxstats.o taxstats.c
taxstats.c:18:61: warning: unused parameter 'level' [-Wunused-parameter]
   18 | void delete_twalkaction (const void *node, VISIT order, int level)
      |                                                             ^
taxstats.c:277:43: warning: unused parameter 'order' [-Wunused-parameter]
  277 | void twalkaction (const void *node, VISIT order, int level)
      |                                           ^
taxstats.c:277:54: warning: unused parameter 'level' [-Wunused-parameter]
  277 | void twalkaction (const void *node, VISIT order, int level)
      |                                                      ^
taxstats.c:286:44: warning: unused parameter 'order' [-Wunused-parameter]
  286 | void twalkaction2 (const void *node, VISIT order, int level)
      |                                            ^
taxstats.c:286:55: warning: unused parameter 'level' [-Wunused-parameter]
  286 | void twalkaction2 (const void *node, VISIT order, int level)
      |                                                       ^
5 warnings generated.
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o apat_search.o apat_search.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o filtering.o filtering.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o PrimerSets.o PrimerSets.c
PrimerSets.c:636:52: warning: unused parameter 'pparams' [-Wunused-parameter]
  636 | void print_set_info (pairset *pair_set, SetParams *pparams)
      |                                                    ^
1 warning generated.
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o ahocorasick.o ahocorasick.c
ar -cr libecoprimer.a goodtaxon.o readdnadb.o smothsort.o sortword.o hashsequence.o strictprimers.o aproxpattern.o merge.o queue.o libstki.o sortmatch.o pairtree.o pairs.o taxstats.o apat_search.o filtering.o PrimerSets.o ahocorasick.o
ranlib libecoprimer.a
/Library/Developer/CommandLineTools/usr/bin/make -C libthermo
../global.mk:21: nnparams.P: No such file or directory
../global.mk:21: thermostats.P: No such file or directory
gcc -DMAC_OS_X -M  -o thermostats.d thermostats.c
gcc -DMAC_OS_X -M  -o nnparams.d nnparams.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o nnparams.o nnparams.c
gcc -DMAC_OS_X -W -Wall -m64 -g -c -o thermostats.o thermostats.c
ar -cr libthermo.a nnparams.o thermostats.o
ranlib libthermo.a
gcc -g  -O5 -m64 -o ecoPrimers ecoprimer.o -LlibecoPCR -Llibecoprimer -Llibthermo -L/usr/local/lib -lecoprimer -lecoPCR -lthermo -lz -lm 
```


## Preparing the data

### What do we need ?

To design a new animal DNA metabarcode we download from the NCBI the following data

-   The complete set of whole mitochondrial genomes
-   The NCBI taxonomy

## We need also:

-   a UNIX computer: a Mac or a Linux box
-   A UNIX terminal window for typing commands
-   Installed on the computer
    -   The OBITools --- <http://github.com/metabarcoding/obitools4>
    -   ecoPrimers --- <http://metabarcoding.org/ecoprimers>
    -   R --- <http://wwww.r-project.org>

## Downloading the mitochondrial genomes

We can use an internet browser and download the files from NCBI FTP website

![](ncbi-ftp.png){fig-align="center"}


## Downloading the mitochondrial genomes

We can use an internet browser and download the files from NCBI FTP website

or run the following command lines

```bash
curl 'https://ftp.ncbi.nlm.nih.gov/genomes/refseq/mitochondrion/mitochondrion.1.genomic.gbff.gz' \
     > mito.all.gb.gz
```

```bash
zless mito.all.gb.gz
```

```
LOCUS       NW_009243181           45189 bp    DNA     linear   CON 06-OCT-2014
DEFINITION  Fonticula alba strain ATCC 38817 mitochondrial scaffold
            supercont2.211, whole genome shotgun sequence.
ACCESSION   NW_009243181 NZ_AROH01000000
VERSION     NW_009243181.1
DBLINK      BioProject: PRJNA262900
            Assembly: GCF_000388065.1
KEYWORDS    WGS; RefSeq.
SOURCE      mitochondrion Fonticula alba
  ORGANISM  Fonticula alba
            Eukaryota; Rotosphaerida; Fonticulaceae; Fonticula.
REFERENCE   1  (bases 1 to 45189)
```


## Downloading the complete taxonomy

```bash
obitaxonomy --download-ncbi
```
```
INFO[0000] Number of workers set 16                     
INFO[0000] Downloading NCBI Taxdump to ncbitaxo_20250211.tgz 
downloading 100% ████████████████████████████████████████| (66/66 MB, 5.1 MB/s)   
```

The NCBI taxonomy contains all the relationship between taxa.
Each taxon is identified by a unique numerical id: `taxid`


## The archive contains several files

file: `nodes.dmp`
```
1  |  1  |  no rank  |		|	8	|	0	| ...
2	|	131567	|	superkingdom	|		|	0	|	0	|
6	|	335928	|	genus	|		|	0	|	1	|
7	|	6	|	species	|	AC	|	0	|	1	|
9	|	32199	|	species	|	BA	|	0	|
10	|	135621	|	genus	|		|	0	|
11	|	1707	|	species	|	CG	|	0	|	1	|
13	|	203488	|	genus	|		|	0	|	1	|
14	|	13	|	species	|	DT	|	0	|	1	|
```

## file: `names.dmp`

```
1	|	root	|		|	scientific name	|
2	|	Bacteria	|	Bacteria <prokaryote>	|	scientific name	|
2	|	Monera	|	Monera <Bacteria>	|	in-part	|
2	|	Procaryotae	|	Procaryotae <Bacteria>	|	in-part	|
2	|	Prokaryota	|	Prokaryota <Bacteria>	|	in-part	|
2	|	Prokaryotae	|	Prokaryotae <Bacteria>	|	in-part	|
2	|	bacteria	|	bacteria <blast2>	|	blast name	|
2	|	eubacteria	|		|	genbank common name	|
2	|	prokaryote	|	prokaryote <Bacteria>	|	in-part	|
...
10	|	Cellvibrio	|		|	scientific name	|
11	|	[Cellvibrio] gilvus	|		|	scientific name	|
13	|	Dictyoglomus	|		|	scientific name	|
14	|	Dictyoglomus thermophilum	|		|	scientific name	|
```

## Preparing the set of complete genomes

```bash
obiconvert --skip-empty \
           --update-taxid \
           -t ncbitaxo_20250211.tgz \
           mito.all.gb.gz \
       > mito.all.fasta
head -5 mito.all.fasta
```

five first lines of the new `mito.all.fasta` file

```
>NC_072933 {"definition":"Echinosophora koreensis mitochondrion, complete genome.","scientific_name":"mitochondrion Echinosophora koreensis","taxid":228658}
ctttcgggtcggaaatagaagatctggattagatcccttctcgatagctttagtcagagc
tcatccctcgaaaaagggagtagtgagatgagaaaagggtgactagaatacggaaattca
actagtgaagtcagatccgggaattccactattgaagttatccgtcttaggcttcaagca
agctatctttcaaggaagtcagtctaagccctaagccaagatctgctttttgccagtcaa
```

## We want:

* annotate sequences by their species `taxid`
* keep a single genome per species
* extract only vertebrate genome

## Looking for the **Vertebrata**'s taxid

```bash
obitaxonomy -t ncbitaxo_20250211.tgz \
              --fixed \
              'vertebrata'
```
```csv
taxid,parent,taxonomic_rank,scientific_name
taxon:1261581 [Vertebrata]@genus,taxon:2008651 [Polysiphonioideae]@subfamily,genus,Vertebrata
taxon:7742 [Vertebrata]@clade,taxon:89593 [Craniata]@subphylum,clade,Vertebrata
```

## Looking for the **Vertebrata**'s taxid

```bash
obitaxonomy -t ncbitaxo_20250211.tgz \
              --fixed \
              'vertebrata' \
    | csvlook
```
```csv
| taxid                            | parent                                      | taxonomic_rank | scientific_name |
| -------------------------------- | ------------------------------------------- | -------------- | --------------- |
| taxon:1261581 [Vertebrata]@genus | taxon:2008651 [Polysiphonioideae]@subfamily | genus          | Vertebrata      |
| taxon:7742 [Vertebrata]@clade    | taxon:89593 [Craniata]@subphylum            | clade          | Vertebrata      |
```

## A genus called **Vertebrata**

```bash
obitaxonomy -t ncbitaxo_20250211.tgz \
              -p 2008651 \
      | csvlook
```
```csv
| taxid                                       | parent                                      | taxonomic_rank | scientific_name    |
| ------------------------------------------- | ------------------------------------------- | -------------- | ------------------ |
| taxon:2008651 [Polysiphonioideae]@subfamily | taxon:2803 [Rhodomelaceae]@family           | subfamily      | Polysiphonioideae  |
| taxon:2803 [Rhodomelaceae]@family           | taxon:2802 [Ceramiales]@order               | family         | Rhodomelaceae      |
| taxon:2802 [Ceramiales]@order               | taxon:2045261 [Rhodymeniophycidae]@subclass | order          | Ceramiales         |
| taxon:2045261 [Rhodymeniophycidae]@subclass | taxon:2806 [Florideophyceae]@class          | subclass       | Rhodymeniophycidae |
| taxon:2806 [Florideophyceae]@class          | taxon:2763 [Rhodophyta]@phylum              | class          | Florideophyceae    |
| taxon:2763 [Rhodophyta]@phylum              | taxon:2759 [Eukaryota]@superkingdom         | phylum         | Rhodophyta         |
| taxon:2759 [Eukaryota]@superkingdom         | taxon:131567 [cellular organisms]@no rank   | superkingdom   | Eukaryota          |
| taxon:131567 [cellular organisms]@no rank   | taxon:1 [root]@no rank                      | no rank        | cellular organisms |
| taxon:1 [root]@no rank                      | taxon:1 [root]@no rank                      | no rank        | root               |
```

## Reannotation and selection of the genomes
```bash
obiannotate -t ncbitaxo_20250211.tgz \
            --with-taxon-at-rank=species \
            mito.all.fasta | \
  obiannotate -S 'ori_taxid=annotations.taxid' | \
  obiannotate -S 'taxid=annotations.species_taxid' | \
  obiuniq -c taxid > mito.one.fasta
```

## Species representation

```bash
obicsv -k taxid mito.one.fasta \
     | tail -n +2 \
     | sort \
     | uniq -c \
     | sort -nk1 \
     | cut -w -f 2 \
     | uplot count
```

```
     ┌                                        ┐ 
   1 ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 17769.0   
   2 ┤ 90.0                                     
   3 ┤ 17.0                                     
   4 ┤ 5.0                                      
   5 ┤ 4.0                                      
   6 ┤ 2.0                                      
   7 ┤ 1.0                                      
     └                                        ┘ 
```

## Selection of the vertebrata genomes

```bash
obigrep -t ncbitaxo_20250211.tgz \
        -r 7742 \
        mito.one.fasta > mito.vert.fasta
```

```bash
obicount mito.vert.fasta \
   | csvlook
```
```
| entities |           n |
| -------- | ----------- |
| variants |       7,822 |
| reads    |       7,823 |
| symbols  | 131,378,756 |
```

## Prepare data for ecoPrimers 1/3

```bash
mkdir ncbitaxo_20250211
cd ncbitaxo_20250211
tar zxvf ../ncbitaxo_20250211.tgz 
cd ..
```

## Prepare data for ecoPrimers 2/3

```bash
obiconvert -O mito.vert.fasta > mito.vert.old.fasta
```

```bash
head -5 mito.vert.old.fasta
```
```csv
>NC_071784 taxid=taxon:2065826 [Sineleotris saccharae]@species; count=1; ori_taxid=taxon:2065826 [Sineleotris saccharae]@species; scientific_name=mitochondrion Sineleotris saccharae; species_name=Sineleotris saccharae; species_taxid=taxon:2065826 [Sineleotris saccharae]@species;  Sineleotris saccharae mitochondrion, complete genome.
gctagcgtagcttaaccaaagcataacactgaagatgttaagatgggccctagaaagccc
cgcaagcacaaaagcttggtcctggctttactatcagcttaggctaaacttacacatgca
agtatccgcatccccgtgagaatgcccttaagctcccaccgctaacaggagtcaaggagc
cggtatcaggcacaaccctgagttagcccacgacaccttgctcagccacacccccaaggg
```

## Prepare data for ecoPrimers 3/3

```bash
ecoPCRFormat -t ncbitaxo_20250211 \
             -f \
             -n vertebrata \
             mito.vert.old.fasta
```

```bash
ls -l vertebrata*
```
```
-rw-r--r--@ 1 coissac  staff  260899785 Feb 11 11:53 vertabrata.ndx
-rw-r--r--@ 1 coissac  staff        546 Feb 11 11:53 vertabrata.rdx
-rw-r--r--@ 1 coissac  staff  121379751 Feb 11 11:53 vertabrata.tdx
-rw-r--r--@ 1 coissac  staff   40446318 Feb 11 11:54 vertabrata_001.sdx
```

## Looking for the *Teleostei* `taxid`

```bash
obitaxonomy -t ncbitaxo_20250211.tgz \
              --fixed \
              'Teleostei' \
    | csvlook
```
```csv
| taxid                              | parent                             | taxonomic_rank | scientific_name |
| ---------------------------------- | ---------------------------------- | -------------- | --------------- |
| taxon:32443 [Teleostei]@infraclass | taxon:41665 [Neopterygii]@subclass | infraclass     | Teleostei       |
```

## Selecting the best primer pairs

```bash
ecoPrimers -d vertebrata \
           -e 3 -3 2 \
           -l 30 -L 150 \
           -r 32443 \
           -c > Teleostei.ecoprimers

- Total pair count : 9407
- Total good pair count : 407


```bash
head -35 Teleostei.ecoprimers
```
```csv
#
# ecoPrimer version 0.5
# Rank level optimisation : species
# max error count by oligonucleotide : 3
#
# Restricted to taxon:
#     32443 : Teleostei (infraclass)
#
# strict primer quorum  : 0.70
# example quorum        : 0.90
# counterexample quorum : 0.10
#
# database : vertebrata
# Database is constituted of  3909 examples        corresponding to  3876 species
#                        and     0 counterexamples corresponding to     0 species
#
# amplifiat length between [30,150] bp
# DB sequences are considered as circular
# Pairs having specificity less than 0.60 will be ignored
#
     0  AGAGTGACGGGCGGTGTG      CGTCAGGTCGAGGTGTAG      62.8    42.4    57.5    34.1    12      11      GG      3864    0       0.988   3832    0       0.989   2731    0.713      134     146     138.22
     1  CGTCAGGTCGAGGTGTAG      GAGTGACGGGCGGTGTGT      57.5    34.1    63.1    42.9    11      12      GG      3863    0       0.988   3831    0       0.988   2730    0.713      133     145     137.22
     2  CGTCAGGTCGAGGTGTAG      GGGAGAGTGACGGGCGGT      57.5    34.1    64.5    37.0    11      13      GG      3811    0       0.975   3779    0       0.975   2689    0.712      137     149     141.22
     3  CGTCAGGTCGAGGTGTAG      GGGGAGAGTGACGGGCGG      57.5    34.1    65.5    38.4    11      14      GG      3804    0       0.973   3772    0       0.973   2682    0.711      138     149     142.22
     4  ACACCGCCCGTCACTCTC      ACCTTCCGGTACACTTAC      62.5    36.8    54.0    16.6    12      9       GG      3850    0       0.985   3818    0       0.985   2658    0.696      46      132     66.51
     5  AACGTCAGGTCGAGGTGT      AGAGTGACGGGCGGTGTG      58.8    28.4    62.8    41.7    10      12      GG      3779    0       0.967   3746    0       0.966   2653    0.708      137     148     140.23
     6  ACACCGCCCGTCACTCTC      CACCTTCCGGTACACTTA      62.5    36.8    54.0    16.6    12      9       GG      3846    0       0.984   3814    0       0.984   2654    0.696      47      133     67.51
     7  AACGTCAGGTCGAGGTGT      GAGTGACGGGCGGTGTGT      58.8    28.4    63.1    42.1    10      12      GG      3778    0       0.966   3745    0       0.966   2652    0.708      136     147     139.23
     8  ACCTTCCGGTACACTTAC      CACACCGCCCGTCACTCT      54.0    16.6    62.8    37.3    9       12      GG      3845    0       0.984   3813    0       0.984   2653    0.696      47      133     67.51
     9  ACACCGCCCGTCACTCTC      TCCGGTACACTTACCATG      62.5    36.8    54.1    18.1    12      9       GG      3851    0       0.985   3819    0       0.985   2651    0.694      42      128     62.51
    10  ACACCGCCCGTCACTCTC      CCGGTACACTTACCATGT      62.5    36.8    54.4    18.6    12      9       GG      3851    0       0.985   3819    0       0.985   2651    0.694      41      127     61.51
    11  ACACCGCCCGTCACTCTC      CCAAGTGCACCTTCCGGT      62.5    36.8    60.7    28.9    12      11      GG      3837    0       0.982   3805    0       0.982   2650    0.696      54      140     74.51
    12  ACACCGCCCGTCACTCTC      GCACCTTCCGGTACACTT      62.5    36.8    57.7    22.5    12      10      GG      3842    0       0.983   3810    0       0.983   2650    0.696      48      134     68.51
    13  ACACCGCCCGTCACTCTC      CGGTACACTTACCATGTT      62.5    36.8    52.4    15.7    12      8       GG      3850    0       0.985   3818    0       0.985   2650    0.694      40      126     60.51
    14  ACACCGCCCGTCACTCTC      CACTTACCATGTTACGAC      62.5    36.8    51.1    27.7    12      8       GG      3850    0       0.985   3817    0       0.985   2649    0.694      35      121     55.51
```
  
* Primer ID :  11 

&nbsp;

   Primer  | sequence           | tm max | tm min | GC count 
  ---------|--------------------|--------|--------|----------
   Forward | ACACCGCCCGTCACTCTC |   62.5 |   36.8 |  12      
   Reverse | CCAAGTGCACCTTCCGGT |   60.7 |   28.9 |  11      
 
&nbsp;
 
* amplifying  3837/3909 sequences    
* identify    2650/3876 Species
* Size ranging from 54bp to 140bp (mean: 74.75 bp)
 
## Testing the new primer pair

```bash
obipcr --forward ACACCGCCCGTCACTCTC \
       --reverse CCAAGTGCACCTTCCGGT \
       -e 5 \
       -l 30 -L 150 \
       -c \
       mito.vert.fasta \
       > Teleostei_11.fasta
```
```bash
head Teleostei_11.fasta
```
```csv
>NC_022183_sub[925..998] {"count":1,"definition":"Acrossocheilus hemispinus mitochondrion, complete genome.","direction":"forward","forward_error":1,"forward_match":"acaccgcccgtcaccctc","forward_primer":"ACACCGCCCGTCACTCTC","ori_taxid":"taxon:356810 [Acrossocheilus hemispinus]@species","reverse_error":0,"reverse_match":"ccaagtgcaccttccggt","reverse_primer":"CCAAGTGCACCTTCCGGT","scientific_name":"mitochondrion Acrossocheilus hemispinus","species_name":"Acrossocheilus hemispinus","species_taxid":"taxon:356810 [Acrossocheilus hemispinus]@species","taxid":"taxon:356810 [Acrossocheilus hemispinus]@species"}
cccgtcaaaatacaccaaaaatacttaatacaataacactaacaaggggaggcaagtcgt
aacatggtaagtgt
>NC_018560_sub[916..988] {"count":1,"definition":"Astatotilapia calliptera mitochondrion, complete genome.","direction":"forward","forward_error":0,"forward_match":"acaccgcccgtcactctc","forward_primer":"ACACCGCCCGTCACTCTC","ori_taxid":"taxon:8154 [Astatotilapia calliptera]@species","reverse_error":1,"reverse_match":"ccaagtacaccttccggt","reverse_primer":"CCAAGTGCACCTTCCGGT","scientific_name":"mitochondrion Astatotilapia calliptera (eastern happy)","species_name":"Astatotilapia calliptera","species_taxid":"taxon:8154 [Astatotilapia calliptera]@species","taxid":"taxon:8154 [Astatotilapia calliptera]@species"}
cccaagccaacaacatcctataaataatacattttaccggtaaaggggaggcaagtcgta
acatggtaagtgt
>NC_056117_sub[923..997] {"count":1,"definition":"Pseudocrossocheilus tridentis mitochondrion, complete genome.","direction":"forward","forward_error":0,"forward_match":"acaccgcccgtcactctc","forward_primer":"ACACCGCCCGTCACTCTC","ori_taxid":"taxon:887881 [Pseudocrossocheilus tridentis]@species","reverse_error":0,"reverse_match":"ccaagtgcaccttccggt","reverse_primer":"CCAAGTGCACCTTCCGGT","scientific_name":"mitochondrion Pseudocrossocheilus tridentis","species_name":"Pseudocrossocheilus tridentis","species_taxid":"taxon:887881 [Pseudocrossocheilus tridentis]@species","taxid":"taxon:887881 [Pseudocrossocheilus tridentis]@species"}
ccctgtcaaaaagcatcaaatatatataataaattagcaatgacaaggggaggcaagtcg
taacacggtaagtgt
>NC_045904_sub[919..997] {"count":1,"definition":"Eospalax fontanierii mitochondrion, complete genome.","direction":"forward","forward_error":1,"forward_match":"acaccgcccgtcgctctc","forward_primer":"ACACCGCCCGTCACTCTC","ori_taxid":"taxon:146134 [Eospalax fontanierii]@species","reverse_error":4,"reverse_match":"ccaagcacactttccagt","reverse_primer":"CCAAGTGCACCTTCCGGT","scientific_name":"mitochondrion Eospalax fontanierii","species_name":"Eospalax fontanierii","species_taxid":"taxon:146134 [Eospalax fontanierii]@species","taxid":"taxon:146134 [Eospalax fontanierii]@species"}
```

convert the fasta file to CSV

```bash
obicsv --auto -s -i Teleostei_11.fasta > Teleostei_11.csv
```

and display the beginning of the table

```bash
head Teleostei_11.csv | csvlook
```
```csv
| id                        | count | direction | forward_error | forward_match      | forward_primer     | ori_taxid                                            | reverse_error | reverse_match      | reverse_primer     | scientific_name                                        | species_name                  | species_taxid                                        | taxid                                                | sequence                                                                        |
| ------------------------- | ----- | --------- | ------------- | ------------------ | ------------------ | ---------------------------------------------------- | ------------- | ------------------ | ------------------ | ------------------------------------------------------ | ----------------------------- | ---------------------------------------------------- | ---------------------------------------------------- | ------------------------------------------------------------------------------- |
| NC_022183_sub[925..998]   |  True | forward   |          True | acaccgcccgtcaccctc | ACACCGCCCGTCACTCTC | taxon:356810 [Acrossocheilus hemispinus]@species     |             0 | ccaagtgcaccttccggt | CCAAGTGCACCTTCCGGT | mitochondrion Acrossocheilus hemispinus                | Acrossocheilus hemispinus     | taxon:356810 [Acrossocheilus hemispinus]@species     | taxon:356810 [Acrossocheilus hemispinus]@species     | cccgtcaaaatacaccaaaaatacttaatacaataacactaacaaggggaggcaagtcgtaacatggtaagtgt      |
| NC_018560_sub[916..988]   |  True | forward   |         False | acaccgcccgtcactctc | ACACCGCCCGTCACTCTC | taxon:8154 [Astatotilapia calliptera]@species        |             1 | ccaagtacaccttccggt | CCAAGTGCACCTTCCGGT | mitochondrion Astatotilapia calliptera (eastern happy) | Astatotilapia calliptera      | taxon:8154 [Astatotilapia calliptera]@species        | taxon:8154 [Astatotilapia calliptera]@species        | cccaagccaacaacatcctataaataatacattttaccggtaaaggggaggcaagtcgtaacatggtaagtgt       |
| NC_056117_sub[923..997]   |  True | forward   |         False | acaccgcccgtcactctc | ACACCGCCCGTCACTCTC | taxon:887881 [Pseudocrossocheilus tridentis]@species |             0 | ccaagtgcaccttccggt | CCAAGTGCACCTTCCGGT | mitochondrion Pseudocrossocheilus tridentis            | Pseudocrossocheilus tridentis | taxon:887881 [Pseudocrossocheilus tridentis]@species | taxon:887881 [Pseudocrossocheilus tridentis]@species | ccctgtcaaaaagcatcaaatatatataataaattagcaatgacaaggggaggcaagtcgtaacacggtaagtgt     |
| NC_045904_sub[919..997]   |  True | forward   |          True | acaccgcccgtcgctctc | ACACCGCCCGTCACTCTC | taxon:146134 [Eospalax fontanierii]@species          |             4 | ccaagcacactttccagt | CCAAGTGCACCTTCCGGT | mitochondrion Eospalax fontanierii                     | Eospalax fontanierii          | taxon:146134 [Eospalax fontanierii]@species          | taxon:146134 [Eospalax fontanierii]@species          | ctcaagtacataaacttggatatattcttaataacccaacaaaaatattagaggagataagtcgtaacaaggtaagcat |
| NC_018546_sub[916..987]   |  True | forward   |         False | acaccgcccgtcactctc | ACACCGCCCGTCACTCTC | taxon:30732 [Oryzias melastigma]@species             |             0 | ccaagtgcaccttccggt | CCAAGTGCACCTTCCGGT | mitochondrion Oryzias melastigma (Indian medaka)       | Oryzias melastigma            | taxon:30732 [Oryzias melastigma]@species             | taxon:30732 [Oryzias melastigma]@species             | cccgacccattttaaaaattaaataaaagatttcaggaactaaggggaggcaagtcgtaacatggtaagtgt        |
| NC_044151_sub[922..993]   |  True | forward   |         False | acaccgcccgtcactctc | ACACCGCCCGTCACTCTC | taxon:2597641 [Sicyopterus squamosissimus]@species   |             0 | ccaagtgcaccttccggt | CCAAGTGCACCTTCCGGT | mitochondrion Sicyopterus squamosissimus (cling goby)  | Sicyopterus squamosissimus    | taxon:2597641 [Sicyopterus squamosissimus]@species   | taxon:2597641 [Sicyopterus squamosissimus]@species   | cccaaaacaaacacacacataaataagaaaaaatgaaaataaaggggaggcaagtcgtaacatggtaagtgt        |
| NC_044152_sub[922..994]   |  True | forward   |         False | acaccgcccgtcactctc | ACACCGCCCGTCACTCTC | taxon:2597642 [Sicyopterus stiphodonoides]@species   |             0 | ccaagtgcaccttccggt | CCAAGTGCACCTTCCGGT | mitochondrion Sicyopterus stiphodonoides (cling goby)  | Sicyopterus stiphodonoides    | taxon:2597642 [Sicyopterus stiphodonoides]@species   | taxon:2597642 [Sicyopterus stiphodonoides]@species   | cccaaaacaaacacacacataaataagaaaaaantgaaaataaaggggaggcaagtcgtaacatggtaagtgt       |
| NC_026976_sub[1453..1531] |  True | forward   |          True | acaccgcccgtcactccc | ACACCGCCCGTCACTCTC | taxon:9545 [Macaca nemestrina]@species               |             1 | ccaagtgcaccttccagt | CCAAGTGCACCTTCCGGT | mitochondrion Macaca nemestrina (pig-tailed macaque)   | Macaca nemestrina             | taxon:9545 [Macaca nemestrina]@species               | taxon:9545 [Macaca nemestrina]@species               | ctcaaatatatttaaggaacatcttaactaaacgccctaatatttatatagaggggataagtcgtaacatggtaagtgt |
| NC_031553_sub[921..995]   |  True | forward   |         False | acaccgcccgtcactctc | ACACCGCCCGTCACTCTC | taxon:643337 [Puntioplites proctozystron]@species    |             0 | ccaagtgcaccttccggt | CCAAGTGCACCTTCCGGT | mitochondrion Puntioplites proctozystron               | Puntioplites proctozystron    | taxon:643337 [Puntioplites proctozystron]@species    | taxon:643337 [Puntioplites proctozystron]@species    | ccctgtcaaaacgcactaaaaatatctaatacaaaagcaccgacaaggggaggcaagtcgtaacacggtaagtgt     |
```

## References

{{< bibliography cited >}}
