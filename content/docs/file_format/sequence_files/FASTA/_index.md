---
title: "Fasta file format"
weight: 20
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

The *fasta* sequence file format is probably the most widely used sequence file format. This is probably due to its simplicity. It was originally created for the Lipman and Pearson [FASTA program](https://en.wikipedia.org/wiki/FASTA) {{< cite "Pearson:1988aa" >}}.

In the *fasta* format, a sequence is represented by a title line starting with a **>** character, and the sequences themselves follow the [`iupac`]({{< ref "/docs/patterns/dnagrep/#iupac-codes-for-ambiguous-bases" >}}) code. The sequence is usually split into several other lines of the same length (expect for the last one). Several sequences can be stored in the same file. The first line of the next sequence also marks the end of the previous one.

```
>my_sequence this is my pretty sequence
ACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGT
GTGCTGACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTACGTTGCAGTGTTT
AACGACGTTGCAGTACGTTGCAGT
```

The first word in the title line is the sequence identifier. The rest of the line is a description of the sequence. The {{% obitools %}} extend this format by adding structured data to the title line. In the previous version of the {{% obitools %}}, the structured data was stored after the sequence identifier in a `key=value;` format, as shown below. The sequence definition was stored as free text after the last `key=value;` pair.

{{< code "two_sequences_obi2.fasta" fasta true >}}

With {{% obitools4 %}} a new format has been introduced to store structured data in the title line. The *key*/*value* annotation pairs are now formatted as a [JSON](https://en.wikipedia.org/wiki/JSON) map object. The definition is stored as an additional *key*/*value* pair using the *key* `definition'.

{{< code "two_sequences_obi4.fasta" fasta true >}}

The {{< obi obiconvert >}} command, like all other {{% obitools4 %}} commands, has two options `--output-json-header` and `--output-OBI-header` to choose between the new [JSON](https://en.wikipedia.org/wiki/JSON) format and the old {{% obitools %}} format. The `--output-OBI-header` option can be abbreviated to `-O`. By default, the new [JSON](https://en.wikipedia.org/wiki/JSON) {{% obitools4 %}} format is used, so only the `-O` option is really useful if the old format is required for compatibility with other software.

Converting from the new [JSON](https://en.wikipedia.org/wiki/JSON) format to the old {{% obitools %}} format:

```bash
obiconvert -O two_sequences_obi4.fasta
```
{{< code "two_sequences_obi2.fasta" fasta false >}}

Converting from the old {{% obitools %}} format to the new [JSON](https://en.wikipedia.org/wiki/JSON) format:

```bash
obiconvert two_sequences_obi2.fasta
```
{{< code "two_sequences_obi4.fasta" fasta false >}}

The actual format of the header is automatically detected when {{% obitools4 %}} commands read a fasta file.

## Bibliography

 {{< bibliography cited >}}