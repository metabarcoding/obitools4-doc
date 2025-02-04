---
title: "The CSV format"
weight: 1
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
url: "/formats/csv"
---

# The *CSV* (coma separated values) flat file format

The *CSV* format is a simple text format that is widely used for storing tabular data. It is a comma-separated values format, meaning that each value in a row is separated by a comma. The format is widely used for storing tabular data, such as spreadsheets, databases, and other data storage systems. 

Each line of the file corresponds to a record that consists of the same number of fields. The first row of the file is a header row that contains the names of the fields. If the field delimiter, coma, itself may appear within a field, fields can be surrounded with quotation marks, usually `"`.

```bash
obicount two_sequences.fasta
```
```csv
entities,n
variants,2
reads,3
symbols,200
```

```bash
obicount two_sequences.fasta | csvlook
```
```
| entities |   n |
| -------- | --- |
| variants |   2 |
| reads    |   3 |
| symbols  | 200 |
```

```bash
obicount two_sequences.fasta \
   | uplot barplot -d, -H --xscale log10
```
```
                                n
            ┌                                        ┐ 
   variants ┤■■■■ 2.0                                  
      reads ┤■■■■■■■ 3.0                               
    symbols ┤■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■ 200.0   
            └                                        ┘ 
                             [log10]
```