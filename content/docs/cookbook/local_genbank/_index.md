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

- [NCBI](https://www.ncbi.nlm.nih.gov/genome/) : distributes GenBank
- [EMBL-EBI](https://www.ebi.ac.uk/ena/data/view/home) : distributes EMBL
- [DDBJ](https://www.ddbj.nig.ac.jp/ddbj/index-e.html) : distributes DDBJ

The three centres are associated in an international agreement, the International Nucleotide Sequence Database Collaboration ([INSDC](https://www.insdc.org/)). This agreement allows the three centres to share the sequences submitted by biologists. As a result, all sequences are available in the three databases, where they are identified by the same accession number.

The content of these databases is available via a web interface, but can also be downloaded to keep a local copy. Genbank and EMBL have two different strategies for distributing data. EMBL distributes fewer large files, whereas Genbank prefers to distribute many small files. This is why we have chosen to download from Genbank here.

Each of these databases is divided into several taxonomic divisions. The main Genbank divisions useful for metabarcoding are:

- `bct`: *Bacteria*
- `inv`: *Invertebrates*
- `mam`: *Mammals*
- `phg`: *Phages*
- `pln`: *Plants*
- `pri`: *Primates*
- `rod`: *Rodents*
- `vrl`: *Viruses*
- `vrt`: *Vertebrates*

Other divisions exist. However, they are less useful for metabarcoding.

### Download Genbank

Genbank is distributed in two main formats: {{% fasta %}} and {{% genbank %}}. The {{% fasta %}} format has the advantage of being smaller than the {{% genbank %}} format because all the sequence annotations stored in the {{% genbank %}} format are not present in the {{% fasta %}} format. For metabarcoding, however, the disadvantage is that the {{% fasta %}} format does not contain the sequence taxonomic information stored as a taxon identifier (taxid).

To combine the advantages of both formats, we will download the {{% genbank %}} format and convert it to the {{% fasta %}} format using the {{< obi obiconvert >}} command. The {{< obi obiconvert >}} command takes care to preserve the taxonomic information during the conversion.

As downloading all the files is a long process, there is a high chance that it will fail due to network interruptions. To solve this problem, here is a Make script that downloads the Genbank files and converts them to the {{% fasta %}} format. Using Make allows the download process to be restarted at the point of failure if it fails.

To download Genbank, copy the <a href="Makefile" type="text/x-makefile" download="Makefile">`Makefile`</a> file to your local computer in the directory where you want to put the Genbank files. 

> [!caution] The Makefile script must be called `Makefile` without any extension.

Execute the make command.

```bash
make
```

By default, the script will download all the genbank divisions listed above. If you want to download a specific division or a subset of genbank divisions, you can use the `GBDIV` variable. For example, to download only the `mam` division, you can use the following command

```bash
make GBDIV=mam
```

To download the `mam`  and the `rod` divisions, you can use the following command:

```bash
make GBDIV="mam rod"
```

If the download fails, you can restart the download process by using the `make` command again.  You don't need to specify the `GBDIV` variable.

```bash
make
```

The `Makefile` will create a directory called `Release_###`, where **###** is the number of the current release. This directory will contain the following files:

```
. 📂 Release_264
└── 📂 depends/
│  ├── 📄 gbfiles.d
│  ├── 📄 gbfiles.d.full
└── 📂 fasta/
│  └── 📂 mam/
│    ├── 📄 gbmam1.fasta.gz
│    ├── 📄 gbmam10.fasta.gz
│    └── 📄 ...
│  └── 📂 rod/
│    ├── 📄 gbrod1.fasta.gz
│    └── 📄 ...
└── 📂 stamp/
│  ├── 📄 gbmam1.seq.gz.stamp
│  ├── 📄 gbmam10.seq.gz.stamp
│  ├── 📄 gbrod1.seq.gz.stamp
└── 📂 taxonomy/
   ├── 📄 citations.dmp
   ├── 📄 delnodes.dmp
   ├── 📄 division.dmp
   ├── 📄 gc.prt
   ├── 📄 gencode.dmp
   ├── 📄 images.dmp
   ├── 📄 merged.dmp
   ├── 📄 names.dmp
   ├── 📄 nodes.dmp
   └── 📄 readme.txt
```

- The `taxonomy` directory contains a copy of the NCBI taxonomy database at the time of download. 
- The `fasta` directory contains the {{% fasta %}} files sorted by taxonomic division in subdirectories, here `mam` and `rod`. 
- The `stamp` directory allows the Makefile script to restart the download process if it fails, without having to download the whole genbank database again. To save space, the `stamp` directory can be deleted at the end of the download process.
- The `depends` directory contains a make script with all the instructions for downloading the genbank files. It is first created by the `Makefile` script. It contains instructions for downloading the files that need to be downloaded according to the specified genbank division. To save space, the `depends` directory can be deleted at the end of the download process.
- The `tmp` directory is used to store the downloaded genbank files before they are converted to the {{% fasta %}} format. It does not normally persist after the download process. To save space, the `tmp` directory can be deleted at the end of the download process if it persists.

### The Makefile script for downloading Genbank

{{% code "Makefile" make true %}}