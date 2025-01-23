---
title: "Prepare a local copy of Genbank"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

## Prepare a local copy of Genbank

> [!caution] A local copy of the Genbank database requires a lot of disk space.
> A whole copy of genbank stored as compressed {{% fasta %}} files takes up about 1TB of disk
> space.

Three bioinformatics centres distribute all publicly available DNA sequences worldwide. They are

- NCBI](https://www.ncbi.nlm.nih.gov/genome/) : distributes GenBank
- EMBL-EBI](https://www.ebi.ac.uk/ena/data/view/home) : distributes EMBL
- DDBJ](https://www.ddbj.nig.ac.jp/ddbj/index-e.html) : distributes DDBJ

The three centres are associated in an international agreement, the International Nucleotide Sequence Database Collaboration ([INSDC](https://www.insdc.org/)). This agreement allows the three centres to share the sequences submitted by biologists. As a result, all sequences are available in the three databases, where they are identified by the same accession number.

The content of these databases is available through a web interface but it can also be downloaded to keep a local copy. Genbank and EMBL have two different strategies to distribute the data. EMBL is distributing fewer huge files, when Genbank prefer to distribute plenty of small files. Therefore, here we have decided to download Genbank.

Each of these databases are divided into several taxonomic divisions. The main Genbank divisions useful for metabarcoding are:

- `bct`: *Bacteria*
- `inv`: *Invertebrates*
- `mam`: *Mammals*
- `phg`: *phages*
- `pln`: *Plants*
- `pri`: *Primates*
- `rod`: *Rodents*
- `vrl`: *Viruses*
- `vrt`: *Vertebrates*

Other divisions exist, but are less useful for metabarcoding.

### Download Genbank

Genbank is distributed in two main formats: {{% fasta %}} and {{% genbank %}}. The {{% fasta %}} format as the advantage to be smaller than the {{% genbank %}} format, because all the sequences annotation stored in the {{% genbank %}} format not present in the {{% fasta %}} format. But for metabarcoding, the drawback is that the {{% fasta %}} format does not contain the sequence taxonomic information stored as a taxon identifier (taxid).

To combine the advantages of both formats, we will download the {{% genbank %}} format and use the {{< obi obiconvert >}} command to convert it to {{% fasta %}} format. The {{< obi obiconvert >}} command takes care during the conversion to keep the taxonomic information.

Because downloading all the files is a long process, it has a high chance to fail because of network disruption. 

```bash
make GBDIV=mam depends
make
```


{{% code "Makefile" make true %}}