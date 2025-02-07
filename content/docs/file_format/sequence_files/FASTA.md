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
OBITools use in more of the classical :ref:`fasta ` format an :ref:`extended
version ` of this format where structured data are included in the title line.

In *fasta* format a sequence is represented by a title line beginning with a **>** character and
the sequences by itself following the :doc:`iupac ` code. The sequence is usually split other 
several lines of the same length (expect for the last one) 

```
>my_sequence this is my pretty sequence
    ACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGT
    GTGCTGACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTGTTT
    AACGACGTTGCAGTACGTTGCAGT
```

## Bibliography

 {{< bibliography cited >}}