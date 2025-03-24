---
archetype: "command"
title: "obigrep"
date: 2025-02-10
command: "obigrep"
category: basics
url: "/obitools/obigrep"
weight: 80
---

# `obigrep`: filter a sequence file

## Description 

{{< obi obigrep >}} is a tool that allows a subset of sequences to be selected based on a set of criteria. Sequences from the input data set that match all criteria are retained and printed in the result, while the other sequences are discarded. The criteria can be based on the sequence identifier, the sequence itself or the annotations of the sequence.

Criteria of selection can target various aspects of the sequence data, such as:

* The sequence identifier (ID)
* The annotations of the sequence.
* The sequence itself

### Selection based on sequence identifier (ID)

There are two ways for selecting sequences based on their identifier: 

* The usage of a [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) with option `-I`
* The usage of a list of identifiers (IDs) provided in a file with option `--id-list`
  
On the following five-sequences trial file:

{{< code "five_ids.fasta" fastq true >}}

To select sequences with IDs "seqA1" and "seqB1", you can use the command

```bash
obigrep -I '^seq[AB]1$' five_ids.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
```

the explanation of the regular pattern `^seq[AB]1$` is:
- the `^` at the start means the string should start with that pattern
- `seq` is the exact match for this string
- `[AB]` means any character in the set {A, B}
- `1` is the exact match for this character
- `$` ending the pattern means the string should end with that pattern

If the starting `^` had been omitted, the pattern would have matched any sequence ID that contains "seq" followed by a character in the set {A, B} and ending with "1", as example the ids `my_seqA1` or `my_seqB1` would have been matched. 

If the ending `$` had been omitted, the pattern would have matched any sequence ID that starts with "seq" followed by a character in the set {A, B} and contains "1", as example the ids `seqA102` or `seqB1023456789` would have been matched.

Another solution to extract these sequence IDs would be to use a text file containing them, one per line as follows:

{{< code "seqAB.txt" txt true >}}

This `seqAB.txt` is then usable as an index file by {{< obi obigrep >}}:

```bash
obigrep --id-list seqAB.txt five_ids.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
```



## Synopsis

```bash
obigrep [--allows-indels] [--approx-pattern <PATTERN>]...
        [--attribute|-a <KEY=VALUE>]... [--batch-size <int>] [--compress|-Z]
        [--debug] [--definition|-D <PATTERN>]... [--ecopcr] [--embl]
        [--fasta] [--fasta-output] [--fastq] [--fastq-output]
        [--force-one-cpu] [--genbank] [--has-attribute|-A <KEY>]...
        [--help|-h|-?] [--id-list <FILENAME>] [--identifier|-I <PATTERN>]...
        [--ignore-taxon|-i <TAXID>]... [--input-OBI-header]
        [--input-json-header] [--inverse-match|-v] [--json-output]
        [--max-count|-C <COUNT>] [--max-cpu <int>] [--max-length|-L <LENGTH>]
        [--min-count|-c <COUNT>] [--min-length|-l <LENGTH>] [--no-order]
        [--no-progressbar] [--only-forward] [--out|-o <FILENAME>]
        [--output-OBI-header|-O] [--output-json-header]
        [--paired-mode <forward|reverse|and|or|andnot|xor>]
        [--paired-with <FILENAME>] [--pattern-error <int>] [--pprof]
        [--pprof-goroutine <int>] [--pprof-mutex <int>]
        [--predicate|-p <EXPRESSION>]... [--require-rank <RANK_NAME>]...
        [--restrict-to-taxon|-r <TAXID>]... [--save-discarded <FILENAME>]
        [--sequence|-s <PATTERN>]... [--skip-empty] [--solexa]
        [--taxonomy|-t <string>] [--version] [<args>]
```

## Options

{{< option-sets/selection >}}

### Matching the sequence annotations

### Taxonomy based filtering

If the user specifies a taxonomy when calling {{< obitools obigrep >}} (see `--taxonomy` option), it is possible to filter the sequences based on taxonomic properties. Each of the following options can be used multiple times if needed to specify multiple taxids or ranks.

- {{< cmd-option name="restrict-to-taxon" short="r" param="TAXID" >}}
  Only sequences having a taxid belonging the provided taxid are conserved.
  {{< /cmd-option >}}

- {{< cmd-option name="ignore-taxon" short="i" param="TAXID" >}}
  Sequences having a taxid belonging the provided taxid are discarded.
  {{< /cmd-option >}}

- {{< cmd-option name="require-rank" param="RANK_NAME" >}}
  Only sequences having a taxid able to provide information at the <RANK_NAME> level are conserved.
  As an example, the NCBI taxid 74635 corresponding to *Rosa canina* is able to provide information at the *species*, *genus* or *family* level. But, taxid 3764 (*Rosa* genus) is not able to provide information at the *species* level. Many of the taxid related to environmental samples have partial classification and a taxon at the *species* level is not always connected to a taxon at the *genus* level as parent. They can sometimes be connected to a taxon at higher level. 
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obigrep --help
```
