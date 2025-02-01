---
title: "Genbank Flat file format"
weight: 40
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
url: "/formats/genbank"
---

# The *GenBank* flat file format

The [GenBank Flat File Format](https://www.ncbi.nlm.nih.gov/nuccore) is a widely used text-based format for storing nucleotide sequence data and their associated annotations. It is maintained by the National Center for Biotechnology Information (NCBI) and serves as a primary repository for sequence data in the United States.

## Overview

The GenBank format is designed to be both human-readable and machine-readable, making it suitable for manual inspection and automated processing. Each flat file contains a sequence record that includes metadata about the sequence, as well as the sequence itself. Each file can contain one or more records, with each record separated by a line containing only a `//` (slash-slash) string.

{{% code "sample.gb" genbank true %}}


## Structure of the GenBank Flat File record

A GenBank flat file consists of several sections, each containing specific information about the sequence. The main sections include:

### Header Section

The header section contains essential metadata about the sequence. The following fields are commonly found in this section:

- **LOCUS**: A unique identifier for the sequence, including its length, type (e.g., DNA, RNA), and whether it is linear or circular.
- **DEFINITION**: A brief description of the sequence, summarizing its biological significance.
- **ACCESSION**: Accession number(s) associated with the sequence, which can be used to retrieve the record.
- **VERSION**: The version number of the sequence record, indicating updates or changes.
- **KEYWORDS**: Keywords associated with the sequence, aiding in categorization and searchability.
- **SOURCE**: The organism from which the sequence is derived, including the scientific name.
- **REFERENCE**: Citations for the sequence, linking it to relevant literature.

````
LOCUS       HQ324066                  84 bp    DNA     linear   PLN 18-NOV-2011
DEFINITION  Trinia glauca tRNA-Leu (trnL) gene, intron; chloroplast.
ACCESSION   HQ324066
VERSION     HQ324066.1
KEYWORDS    .
SOURCE      chloroplast Trinia glauca
  ORGANISM  Trinia glauca
            Eukaryota; Viridiplantae; Streptophyta; Embryophyta; Tracheophyta;
            Spermatophyta; Magnoliopsida; eudicotyledons; Gunneridae;
            Pentapetalae; asterids; campanulids; Apiales; Apiaceae; Apioideae;
            apioid superclade; Selineae; Trinia.
REFERENCE   1  (bases 1 to 84)
  AUTHORS   Raye,G., Miquel,C., Coissac,E., Redjadj,C., Loison,A. and
            Taberlet,P.
  TITLE     New insights on diet variability revealed by DNA barcoding and
            high-throughput pyrosequencing: chamois diet in autumn as a case
            study
  JOURNAL   Ecol. Res. 26 (2), 265-276 (2011)
REFERENCE   2  (bases 1 to 84)
  AUTHORS   Raye,G.
  TITLE     Direct Submission
  JOURNAL   Submitted (25-SEP-2010) LECA, Universite Joseph Fourier, Bp 53,
            2233 rue de la Piscine, Grenoble 38041, France
````

### The feature table section

The feature table section contains information about the annotations or features of the sequence, such as genes, transcripts, or regions. Each feature is represented by a set of fields splitted over multiple lines. The first line of each feature contains the feature type, such as "gene", "transcript", or "region" and its location in the sequence. The subsequent lines contain the feature-specific information, such as the gene name, gene function, cross-references to other databases, or its translation to protein for protein-coding genes.

```
FEATURES             Location/Qualifiers
     source          1..84
                     /organism="Trinia glauca"
                     /organelle="plastid:chloroplast"
                     /mol_type="genomic DNA"
                     /db_xref="taxon:1000432"
                     /geo_loc_name="France"
     gene            <1..>84
                     /gene="trnL"
                     /note="tRNA-Leu; tRNA-Leu(UAA)"
     intron          <1..>84
                     /gene="trnL"
                     /note="P6 loop"
```

### Sequence Section


The sequence section contains the actual sequence data. It is starting at a line containing only the keyword `ORIGIN` (uppercase), followed by the sequence data. The sequence data is separated by spaces every 10 characters and each line contains 60 nucleotides. The number on the left of the sequence lines indicates the start position of the line in the sequence.

```
ORIGIN      
        1 gggcaatcct gagccaaatc ctattttaca aaaacaaaca aaggcccaga aggtgaaaaa
       61 aggataggtg cagagactca atgg
```

###  Terminator

The record concludes with a `//` line, indicating the end of the record. This terminator is crucial for distinguishing between multiple records in a single file.

```
//
```

## Converting GenBank flat file to {{% fasta %}} format

To convert a GenBank flat file to FASTA format, you can use the {{< obi obiconvert >}} command.
The {{% obi obiconvert %}} command extracts from the source feature present in each GenBank record the taxid and scientific name associated with the record to store them in the `taxid` and `scientific_name` tags within the FASTA header.

```bash
obiconvert sample.gb
```
{{% code "sample.fasta" fasta false %}}

> [!NOTE] the DDBJ database uses a format very similar to GenBank, 
> so {{< obi obiconvert >}} recognizes it as a GenBank file and correctly 
> converts it to FASTA.


## References

For more detailed specifications and guidelines regarding the GenBank Flat File Format, refer to the following resource:

- [GenBank Flat File Format](https://www.ncbi.nlm.nih.gov/genbank/samplerecord/)
