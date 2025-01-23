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

Because downloading all the files is a long process, it has a high chance to fail because of network disruption. To tackle this problem, here is a Make script that downloads the Genbank files and convert them to {{% fasta %}} format. The use of Make allows for restarting the download process, if it fails, at the failure point.

To download Genbank, copy the <a href="Makefile" type="text/x-makefile" download="Makefile">`Makefile`</a> file to your local computer in the directory where you want to store the Genbank files. 

> [!caution] The Makefile script must be named `Makefile` without any extension.

Run the make command.

```bash
make
```

By default, the script will download all the cited above Genbank divisions. If you want to download a specific division or a subset of the Genbank divisions, you can use the `GBDIV` variable. For example, to download only the `mam` division, you can use the following command:

```bash
make GBDIV=mam
```

To download the `mam`  and the `rod` divisions, you can use the following command:

```bash
make GBDIV="mam rod"
```

If the download fails, you can restart the download process by using the `make` command again.  You don't need to specify the `GBDIV` variable

```bash
make
```

The `Makefile` file will create a directory named `Release_###` where ### is the number of the current release. The directory will contain the following files:

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

- The `taxonomy` directory contains a copy of the NCBI taxonomy database at the date of the download. 
- The `fasta` directory contains the {{% fasta %}} files sorted by taxonomic division in subdirectories, here `mam` and `rod`. 
- The `stamp` directory allows the Makefile script to restart the download process if it fails without having to download the whole Genbank database again. To save space the `stamp` directory can be deleted at the end of the download process.
- The `depends` directory contains a make script with all the instructions to download the Genbank files. It is generated at first by the `Makefile` script. It contains the files that have to be downloaded according to the specified Genbank divisions. To save space the `depends` directory can be deleted at the end of the download process.
- The `tmp` directory is used to store the downloaded Genbank files before they are converted to {{% fasta %}} format. It does not normally persist after the download process. To save space the `tmp` directory can be deleted at the end of the download process, if it persists.

{{% code "Makefile" make true %}}