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

# The *CSV (Coma-Separated Values)* flat file format

The [CSV](https://en.wikipedia.org/wiki/Comma-separated_values) format is a simple text format that is widely used for storing tabular data, such as spreadsheets, databases, and other data storage systems. It is a comma-separated values format, meaning that each value in a row is separated by a comma.

Each line of the file corresponds to a record that consists of the same number of fields. The first row of the file is a header row that contains the fields names. The field delimiter, the comma, can itself appear in a field using quotation marks around it, with `"`.

Here is an example with two sequences in a {{% fasta %}} file:

{{< code "two_sequences.fasta" fasta true >}}

The following command allows counting the number of records, and provides a CSV file:

```bash
obicount two_sequences.fasta
```
```csv
entities,n
variants,2
reads,3
symbols,200
```

In a prettier presentation:

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

The CSV format of the result of {{< obi obicount >}} is an easy way to make plots with `uplot`:

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