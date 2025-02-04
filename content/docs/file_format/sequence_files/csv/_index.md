---
title: "CSV as sequence files"
weight: 90
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
---


## CSV as sequence files

{{< code "two_sequences.fasta" fasta true >}}

```bash
obicsv -k count -k taxid -k family_taxid -k family_name \
       -i -s \
       two_sequences.fasta > two_sequences.csv

csvlook -I two_sequences.csv
```
```
| id       | count | taxid | family_taxid | family_name | sequence                                                                                             |
| -------- | ----- | ----- | ------------ | ----------- | ---------------------------------------------------------------------------------------------------- |
| AB061527 | 1     | 62275 | 9376         | Soricidae   | ttagccctaaacttaggtatttaatctaacaaaaatacccgtcagagaactactagcaatagcttaaaactcaaaggacttggcggtgctttatatccct |
| AL355887 | 2     | 9606  | 9604         | Hominidae   | ttagccctaaactctagtagttacattaacaaaaccattcgtcagaatactacgagcaacagcttaaaactcaaaggacctggcagttctttatatccct |
```

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