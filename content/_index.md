---
title: 'OBITools4 Documentation'
date: 2024-10-04T17:50:53+02:00
draft: false
BookToC: false
# bookFlatSection: true
# bookHidden: true
# bookCollapseSection: true
bookComments: true
bookSearchExclude: true
---


![Welcome obitools4](images/welcome_obitools4.jpg)

{{% button relref="/docs/about" %}}About{{% /button %}} {{% button relref="/docs/installation" %}}Installation{{% /button %}} {{% button relref="/docs/principles" %}}OBITools principles{{% /button %}} {{% button relref="/docs/commands" %}}The OBITools commands{{% /button %}} {{% button relref="/docs" %}}Full documentation{{% /button %}} {{% button relref="/docs/cookbook" %}}Cookbook{{% /button %}} {{% button href="https://github.com/metabarcoding/obitools4-doc" %}}Contribute to the doc{{% /button %}}

{{< gloentry "OBITools4" >}} are a suite of UNIX command-line tools for processing DNA metabarcoding data, developed at {{< gloentry LECA >}} ([University of Grenoble](https://www.univ-grenoble-alpes.fr/)). Following the philosophy of standard UNIX tools such as `grep`, `uniq` or `wc`, each command performs a single, well-defined operation on sequence records, and is fully parameterisable by a large set of options. Written in [Go](https://go.dev/), {{< gloentry "OBITools4" >}} take full advantage of modern multi-core architectures to handle the large datasets produced by today's high-throughput sequencers. Rather than imposing a fixed pipeline, {{< gloentry "OBITools4" >}} provide the building blocks that let you compose your own analysis workflow tailored to your biological questions.

## Commands overview

### Basics

| Command | Description |
|---------|-------------|
| {{< obi obiannotate >}} | Adds, deletes, or modifies annotations, identifiers, and sequences. |
| {{< obi obicomplement >}} | Computes the reverse complement of every sequence. |
| {{< obi obiconvert >}} | Converts sequence files between bioinformatics formats (FASTA, FASTQ, JSON…). |
| {{< obi obicount >}} | Counts sequence records, reporting variants, reads, and total nucleotides. |
| {{< obi obicsv >}} | Converts sequence datasets into CSV format. |
| {{< obi obidemerge >}} | Reverses {{< obi obiuniq >}} merging by expanding each merged entry into individual sequences. |
| {{< obi obidistribute >}} | Splits sequences into multiple output files based on annotations or hash sharding. |
| {{< obi obigrep >}} | Filters sequences based on ID, annotations, sequence content, length, or taxonomy. |
| {{< obi obijoin >}} | Enriches a sequence dataset with annotations imported from a secondary file. |
| {{< obi obimatrix >}} | Builds a sample × sequence count matrix (OTU table) from annotated sequences. |
| {{< obi obisummary >}} | Provides a statistical overview of a sequence dataset. |
| {{< obi obiuniq >}} | Dereplicates sequences, grouping identical sequences and recording their abundance. |

### Demultiplexing

| Command | Description |
|---------|-------------|
| {{< obi obimultiplex >}} | Demultiplexes sequencing reads by identifying sample-specific tags and primers. |
| {{< obi obitagpcr >}} | Demultiplexes paired-end reads by assigning them to samples based on primers and barcodes. |

### Alignments

| Command | Description |
|---------|-------------|
| {{< obi obiclean >}} | Denoises PCR-amplified sequences by filtering out most of the spurious and chimeric sequences. |
| {{< obi obipcr >}} | Performs in silico PCR, returning amplicon sequences for given primer pairs. |
| {{< obi obipairing >}} | Aligns forward and reverse paired-end reads into full-length amplicons. |
| {{< obi obitag >}} | Assigns taxonomic annotations by searching a reference database with LCA inference. |

### Taxonomy

| Command | Description |
|---------|-------------|
| {{< obi obitaxonomy >}} | Loads, inspects, and queries a taxonomy database. |

### Advanced

| Command | Description |
|---------|-------------|
| {{< obi obiscript >}} | Applies custom Lua scripts to process sequence records with full programmable logic. |

### Others

| Command | Description |
|---------|-------------|
| {{< obi obimicrosat >}} | Scans DNA sequences for simple sequence repeats (microsatellites). |

<!--### Experimental
| Command | Description |
|---------|-------------|
| {{< obi obiconsensus >}} | Denoises MinION data by constructing consensus sequences. |
| {{< obi obicleandb >}} | Cleans a sequence reference database of trivial wrong taxonomic annotations. |
| {{< obi obilandmark >}} | *(not yet documented)* |
| {{< obi obirefidx >}} | *(not yet documented)* |
| {{< obi obisplit >}} | *(not yet documented)* |
-->

> [!Note] Contribute to the OBITools4 documentation:
> Don't hesitate to contribute and comment on [GitHub](https://github.com/metabarcoding/obitools4-doc)
