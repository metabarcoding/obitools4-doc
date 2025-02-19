---
title: "EMBL Flat File format"
weight: 50
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
url: "/formats/embl"
---

# The *EMBL-ENA* Flat File format

The [EMBL (European Molecular Biology Laboratory) Flat File format](https://ena-docs.readthedocs.io/en/latest/submit/fileprep/flat-file-example.html) is a widely used text-based format for storing nucleotide and protein sequence data. It is primarily utilized in the [European Nucleotide Archive (ENA)](https://www.ebi.ac.uk/ena/browser/home) database for the exchange of biological sequence information including their associated metadata.

## Overview

The EMBL format is designed to be human-readable and machine-readable, making it suitable for both manual inspection and automated processing. Each flat file contains a sequence record that includes metadata about the sequence, as well as the sequence itself. Each file is composed of a single record or a series of records, separated by a line containing only a `//` (slash-slash) string.

{{% code "sample.embl" embl true %}}

## Structure of the EMBL Flat File record

An EMBL flat file consists of several sections, each containing specific information about the sequence. The main sections include:

###  Header section

The header section contains essential metadata about the sequence. The following fields are commonly found in this section:

- **ID**: A unique identifier for the sequence. This field is mandatory and typically includes the sequence type (*e.g.*, mRNA, DNA, protein) and its length.
- **AC**: Accession number(s) associated with the sequence. This field can contain multiple accession numbers separated by semicolons.
- **DE**: Description of the sequence, providing a brief overview of its biological significance or function.
- **KW**: Keywords associated with the sequence, which can help in categorizing and searching for the sequence in databases.
- **OS**: Organism name, indicating the species from which the sequence is derived.
- **OC**: Organism classification, providing a taxonomic hierarchy (*e.g.*, domain, kingdom, phylum).
- **RN**: Reference number for citations, linking the sequence to relevant literature.
- **RP**: Reference position, indicating the specific positions in the sequence that are referenced.
- **RA**: Authors of the reference, listing the individuals who contributed to the cited work.
- **RL**: Reference line, providing the complete citation for the reference.

```
ID   HQ324066; SV 1; linear; genomic DNA; STD; PLN; 84 BP.
XX
AC   HQ324066;
XX
DT   30-MAR-2011 (Rel. 108, Created)
DT   20-NOV-2011 (Rel. 110, Last updated, Version 2)
XX
DE   Trinia glauca tRNA-Leu (trnL) gene, intron; chloroplast.
XX
KW   .
XX
OS   Trinia glauca
OC   Eukaryota; Viridiplantae; Streptophyta; Embryophyta; Tracheophyta;
OC   Spermatophyta; Magnoliopsida; eudicotyledons; Gunneridae; Pentapetalae;
OC   asterids; campanulids; Apiales; Apiaceae; Apioideae; apioid superclade;
OC   Selineae; Trinia.
OG   Plastid:Chloroplast
XX
RN   [1]
RP   1-84
RA   Raye G., Miquel C., Coissac E., Redjadj C., Loison A., Taberlet P.;
RT   "New insights on diet variability revealed by DNA barcoding and
RT   high-throughput pyrosequencing: chamois diet in autumn as a case study";
RL   Ecol. Res. 26(2):265-276(2011).
XX
RN   [2]
RP   1-84
RA   Raye G.;
RT   ;
RL   Submitted (25-SEP-2010) to the INSDC.
RL   LECA, Universite Joseph Fourier, Bp 53, 2233 rue de la Piscine, Grenoble
RL   38041, France
XX
DR   MD5; f2c1ac0a050529656590007b565d327d.
XX
```

###  Feature table section

The feature table section contains information about the annotations or features of the sequence, such as genes, transcripts, or regions. Each feature is represented by a set of fields splitted over multiple lines. The first line of each feature contains the feature type, such as "gene", "transcript", or "region" and its location in the sequence. The subsequent lines contain the feature-specific information, such as the gene name, gene function, cross-references to other databases, or its translation to protein for protein-coding genes.

```
FH   Key             Location/Qualifiers
FH
FT   source          1..84
FT                   /organism="Trinia glauca"
FT                   /organelle="plastid:chloroplast"
FT                   /mol_type="genomic DNA"
FT                   /country="France"
FT                   /db_xref="taxon:1000432"
FT   gene            <1..>84
FT                   /gene="trnL"
FT                   /note="tRNA-Leu; tRNA-Leu(UAA)"
FT   intron          <1..>84
FT                   /gene="trnL"
FT                   /note="P6 loop"
XX
```

###  Sequence section

The sequence section contains the actual nucleotide sequence. This section is formatted to enhance readability and is represented in lines of 60 characters. The sequence letters represent nucleotides (A, T, C, G for DNA; A, U, C, G for RNA).

The sequence section begins with **SQ** in first line and includes metadata about the sequence, such as its length and the count of each nucleotide. The sequence itself follows, formatted in lines of 60 characters for clarity. The number on the right of each of the sequence lines indicates the end position of the line in the sequence.

```
SQ   Sequence 84 BP; 35 A; 16 C; 20 G; 13 T; 0 other;
     gggcaatcct gagccaaatc ctattttaca aaaacaaaca aaggcccaga aggtgaaaaa        60
     aggataggtg cagagactca atgg                                               84
```

###  Terminator

The record concludes with a `//` line, indicating the end of the record. This terminator is crucial for distinguishing between multiple records in a single file.

```
//
```

## Converting EMBL Flat File to FASTA format

To convert a EMBL flat file to {{% fasta %}} format, you can use the {{< obi obiconvert >}} command.
The {{% obi obiconvert %}} command extracts from the source feature present in each EMBL record the taxid and scientific name associated with the record to store them in the `taxid` and `scientific_name` tags within the FASTA header.

```bash
obiconvert sample.embl
```

{{% code "sample.fasta" fasta false %}}

## References

For more detailed specifications and guidelines regarding the EMBL Flat File Format, refer to the following resources:

- [EMBL (European Molecular Biology Laboratory) Flat File Format](https://ena-docs.readthedocs.io/en/latest/submit/fileprep/sequence-flatfile.html)
- [EMBL-EBI Sequence Databases](https://www.ebi.ac.uk/ena)