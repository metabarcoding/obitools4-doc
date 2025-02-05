---
title: "CSV format"
weight: 90
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---

# The *CSV* sequence file format

The [CSV (Comma-Separated Values)](https://en.wikipedia.org/wiki/Comma-separated_values) files are formatted as plain text where each line represents a data record, and each field within that record is separated by a comma.

## Converting FASTA file to CSV

Use the {{% obi obicsv %}} command to convert a {{% fasta %}} file to CSV format, with the `-i` and `-s` options, to prints respectively the sequence identifier and the nucleotide sequence, and `-k` option to keep the desired attributes. Each record in the FASTA file corresponds to a line in the output file:

{{< code "two_sequences.fasta" fasta true >}}

```bash
obicsv -k count -k taxid -k family_taxid -k family_name \
       -i -s \
       two_sequences.fasta > two_sequences.csv
```
```
id,count,taxid,scientific_name,family_taxid,family_name,sequence
AB061527,1,62275,NA,9376,Soricidae,ttagccctaaacttaggtatttaatctaacaaaaatacccgtcagagaactactagcaatagcttaaaactcaaaggacttggcggtgctttatatccct
AL355887,2,9606,NA,9604,Hominidae,ttagccctaaactctagtagttacattaacaaaaccattcgtcagaatactacgagcaacagcttaaaactcaaaggacctggcagttctttatatccct
```

The result of the {{< obi obicsv >}} can be reformatted with the [csvlook](https://csvplot.readthedocs.io/en/latest/scripts/csvlook.html) command:

```bash
csvlook -I two_sequences.csv
```
```
| id       | count | taxid | family_taxid | family_name | sequence                                                                                             |
| -------- | ----- | ----- | ------------ | ----------- | ---------------------------------------------------------------------------------------------------- |
| AB061527 | 1     | 62275 | 9376         | Soricidae   | ttagccctaaacttaggtatttaatctaacaaaaatacccgtcagagaactactagcaatagcttaaaactcaaaggacttggcggtgctttatatccct |
| AL355887 | 2     | 9606  | 9604         | Hominidae   | ttagccctaaactctagtagttacattaacaaaaccattcgtcagaatactacgagcaacagcttaaaactcaaaggacctggcagttctttatatccct |
```

## Converting CSV file to FASTA format

To convert a sequence file in CSV format to {{% fasta %}} format, you can use the {{% obi obiconvert %}} command:

```bash
obiconvert two_sequences.csv
```
```
>AB061527 {"count":1,"family_name":"Soricidae","family_taxid":"9376","taxid":"62275"}
ttagccctaaacttaggtatttaatctaacaaaaatacccgtcagagaactactagcaat
agcttaaaactcaaaggacttggcggtgctttatatccct
>AL355887 {"count":2,"family_name":"Hominidae","family_taxid":"9604","taxid":"9606"}
ttagccctaaactctagtagttacattaacaaaaccattcgtcagaatactacgagcaac
agcttaaaactcaaaggacctggcagttctttatatccct
```

<!-- 
## Converting FASTQ file to CSV

In the same way as for {{% fasta %}} files, use the {{% obi obicsv %}} command to convert a {{% fastq %}} file to CSV format:

{{< code "two_sequences.fastq" fastq true >}}

```bash
obicsv -i -s -q two_sequences.fastq > two_sequences.csv
```

## Converting CSV file to FASTQ format

```bash
obiconvert --fastq-output two_sequences.csv
``` -->