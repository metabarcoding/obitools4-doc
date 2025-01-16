---
title: "Embl Flat File Format"
weight: 40
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
url: "/formats/embl"
---

# The *EMBL-ENA* flat file format

The [EMBL (European Molecular Biology Laboratory) Flat File Format](https://ena-docs.readthedocs.io/en/latest/submit/fileprep/flat-file-example.html) is a widely used text-based format for storing nucleotide and protein sequence data. It is primarily utilized in the European Nucleotide Archive (ENA) database for the exchange of biological sequence information including their associated metadata.

## Overview

The EMBL format is designed to be human-readable and machine-readable, making it suitable for both manual inspection and automated processing. Each flat file contains a sequence record that includes metadata about the sequence, as well as the sequence itself. Each file is composed of a single record or a series of records, separated by a line containing only a `//` (slash-slash) string.

```
ID   XXX; XXX; {'linear' or 'circular'}; XXX; XXX; XXX; XXX.
XX
AC   XXX;
XX
AC * _{entry_name} (where entry_name=sequence name: e.g. _contig1 or _scaffold1)
XX
PR   Project:PRJEBNNNN;
XX
DE   XXX
XX
RN   [1]
RP   1-2149
RA   XXX;
RT   ;
RL   Submitted {(DD-MMM-YYYY)} to the INSDC.
XX
FH   Key           Location/Qualifiers
FH
FT   source        1..588788
FT                 /organism={"scientific organism name"}
FT                 /mol_type={"in vivo molecule type of sequence"}
XX
SQ   Sequence 588788 BP; 101836 A; 193561 C; 192752 G; 100639 T; 0 other;
     tgcgtactcg aagagacgcg cccagattat ataagggcgt cgtctcgagg ccgacggcgc        60
     gccggcgagt acgcgtgatc cacaacccga agcgaccgtc gggagaccga gggtcgtcga       120
     gggtggatac gttcctgcct tcgtgccggg aaacggccga agggaacgtg gcgacctgcg       180
[sequence truncated]...
//
```

## Structure of the EMBL Flat File record

An EMBL flat file consists of several sections, each containing specific information about the sequence. The main sections include:

###  Header Section


The header section contains essential metadata about the sequence. The following fields are commonly found in this section:

- **ID**: A unique identifier for the sequence. This field is mandatory and typically includes the sequence type (e.g., mRNA, DNA, protein) and its length.
- **AC**: Accession number(s) associated with the sequence. This field can contain multiple accession numbers separated by semicolons.
- **DE**: Description of the sequence, providing a brief overview of its biological significance or function.
- **KW**: Keywords associated with the sequence, which can help in categorizing and searching for the sequence in databases.
- **OS**: Organism name, indicating the species from which the sequence is derived.
- **OC**: Organism classification, providing a taxonomic hierarchy (e.g., domain, kingdom, phylum).
- **RN**: Reference number for citations, linking the sequence to relevant literature.
- **RP**: Reference position, indicating the specific positions in the sequence that are referenced.
- **RA**: Authors of the reference, listing the individuals who contributed to the cited work.
- **RL**: Reference line, providing the complete citation for the reference.

```
ID   XXX; XXX; {'linear' or 'circular'}; XXX; XXX; XXX; XXX.
XX
AC   XXX;
XX
AC * _{entry_name} (where entry_name=sequence name: e.g. _contig1 or _scaffold1)
XX
PR   Project:PRJEBNNNN;
XX
DE   XXX
XX
RN   [1]
RP   1-2149
RA   XXX;
RT   ;
RL   Submitted {(DD-MMM-YYYY)} to the INSDC.
XX
```

###  The feature table section

The feature table section contains information about the annotations or features of the sequence, such as genes, transcripts, or regions. Each feature is represented by a set of fields splitted over multiple lines. The first line of each feature contains the feature type, such as "gene", "transcript", or "region" and its location in the sequence. The subsequent lines contain the feature-specific information, such as the gene name, gene function, cross-references to other databases, or its translation to protein for protein-coding genes.

```
FH   Key           Location/Qualifiers
FH
FT   source        1..588788
FT                 /organism={"scientific organism name"}
FT                 /mol_type={"in vivo molecule type of sequence"}
XX
```

###  Sequence Section

The sequence section contains the actual nucleotide sequence. This section is formatted to enhance readability and is represented in lines of 60 characters. The sequence letters represent nucleotides (A, T, C, G for DNA; A, U, C, G for RNA).

- **SQ**: This line begins the sequence section and includes metadata about the sequence, such as its length and the count of each nucleotide.
- The sequence itself follows, formatted in lines of 60 characters for clarity.

```
SQ   Sequence 588788 BP; 101836 A; 193561 C; 192752 G; 100639 T; 0 other;
     tgcgtactcg aagagacgcg cccagattat ataagggcgt cgtctcgagg ccgacggcgc        60
     gccggcgagt acgcgtgatc cacaacccga agcgaccgtc gggagaccga gggtcgtcga       120
     gggtggatac gttcctgcct tcgtgccggg aaacggccga agggaacgtg gcgacctgcg       180
[sequence truncated]...
```

###  Terminator

The record concludes with a `//` line, indicating the end of the record. This terminator is crucial for distinguishing between multiple records in a single file.

```
//
```

## References

For more detailed specifications and guidelines regarding the EMBL Flat File Format, refer to the following resources:

- [EMBL (European Molecular Biology Laboratory) Flat File Format](https://ena-docs.readthedocs.io/en/latest/submit/fileprep/sequence-flatfile.html)
- [EMBL-EBI Sequence Databases](https://www.ebi.ac.uk/ena)

