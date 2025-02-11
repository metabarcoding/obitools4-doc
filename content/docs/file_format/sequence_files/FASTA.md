---
title: "Fasta file format"
weight: 10
# bookFlatSection: false
# bookToc: true
# bookHidden: false
# bookCollapseSection: false
# bookComments: false
# bookSearchExclude: false
bibFile: bibliography/bibliography.json 
url: "/formats/fasta"
---

# The *fasta* sequence file format

The *fasta* sequence file format is certainly the most widely used sequence file
format. This is certainly due to its simplicity. It was originally created
for the Lipman and Pearson [FASTA program](https://en.wikipedia.org/wiki/FASTA) {{< cite "Pearson:1988aa" >}}.
In addition to the classic `fasta ` format, OBITools uses an `extended
version ` of this format where structured data is included in the title line.

In *fasta* format, a sequence is represented by a title line starting with a **>** character and the sequences themselves on the following line(s) using the `iupac ` code. The sequence is generally divided into several lines of the same length (with the exception of the last line which may be shorter). 

```
>my_sequence this is my pretty sequence
ACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGT
GTGCTGACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTGTTT
AACGACGTTGCAGTACGTTGCAGT
```

## Bibliography

 {{< bibliography cited >}}