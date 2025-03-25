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

{{< obi obigrep >}} is a tool for selecting a subset of sequences based on a set of criteria. Sequences from the input data set that match all criteria are retained and printed in the result, while the other sequences are discarded. The criteria can be based on the sequence identifier, the sequence itself or the annotations on the sequence.

Selection criteria can be based on different aspects of the sequence data, such as

* The sequence identifier (ID) 
* The sequence annotations
* The sequence itself

### Selection based on sequence identifier (ID)

There are two ways to select sequences based on their identifier: 

* Using a [regular pattern]({{% ref "docs/patterns/regular/_index.html" %}}) with option `-I`
* Using a list of identifiers (IDs) provided in a file with option `--id-list`
  
On the following five-sequences sample file:

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

The explanations for the regular pattern `^seq[AB]1$` are

- the `^` at the beginning means that the string should start with that pattern 
- `seq` is an exact match for that string 
- `[AB]` means any character in the set {A, B} 
- `1` is an exact match for that character 
- `$` at the end of the pattern means that the string should end with that pattern.

 If the starting `^` had been omitted, the pattern would have matched any sequence ID containing "seq" followed by a character from the set {A, B} and ending with "1", for example the IDs `my_seqA1` or `my_seqB1` would have been matched. 

If the ending '$' had been omitted, the pattern would have matched any sequence ID starting with 'seq' followed by a character in the set {A, B} and containing '1', e.g. the ids `seqA102` or `seqB1023456789` would have been matched.

Another solution to extract these sequence IDs would be to use a text file containing them, one per line, as follows

{{< code "seqAB.txt" txt true >}}

This `seqAB.txt` can then be used as an index file by  {{< obi obigrep >}}:

```bash
obigrep --id-list seqAB.txt five_ids.fasta
```
```
>seqA1 
cgatgctgcatgctagtgctagtcgat
>seqB1 
tagctagctagctagctagctagctagcta
```

### Selection based on the annotations

The `obigrep` tool can also be used to select sequences based on their annotations. Annotation are constituted by all the tags and values added to each sequence header in the {{% fasta %}}/{{% fastq %}} file. For instance, if you have a sequence file with the following headers:

{{< code "five_tags.fasta" fastq true >}}

#### Selecting sequences having a tag whatever its value

The `-A` option allows for selecting sequences having the given attribute whatever its value. In the following example, all the sequences having the `count` attribute are selected.

```bash
obigrep -A "count" five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
>seqC1 {"count":15,"tata":"foo","taxid":"taxon:9604 [Hominidae]@family","toto":"foo"}
cgatgctgcatgctagtgctagtcgatga
>seqB2 {"count":25,"tata":"bar"}
tagctagctagctagctagctagctagcta
```

Only four sequences are retained, the sequence `seqB1` is excluded because it does not have the tag `count`.

#### Selecting sequences having a tag with a specific value

The `-A` option allows for selecting sequences having the given attribute affected to a value matching the provided [regular pattern]({{% ref "docs/patterns/regular.md" %}}). In the following example, only the sequence *seqA1* having the `toto` attribute valued to `titi` is selected.

```bash
obigrep -a toto="titi" five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
```

As the value is a [regular pattern]({{% ref "docs/patterns/regular.md" %}}), it is possible to be less strict, and as example,
the next command will select all the sequences having the `toto` attribute valued with a value starting (`^` at the beginning of the expression) by a `t`.

```bash
obigrep -a toto="^t" five_tags.fasta
```
```
>seqA1 {"count":1,"tata":"bar","taxid":"taxon:9606 [Homo sapiens]@species","toto":"titi"}
cgatgctgcatgctagtgctagtcgat
>seqB1 {"tata":"bar","taxid":"taxon:63221 [Homo sapiens neanderthalensis]@subspecies","toto":"tata"}
tagctagctagctagctagctagctagcta
>seqA2 {"count":5,"tata":"foo","taxid":"taxon:9605 [Homo]@genus","toto":"tutu"}
gtagctagctagctagctagctagctaga
```

Sequence `seqC1` is excluded because its `toto` attribute is valued with `foo` which doesn't start by a `t` when `seqB2` is excluded because it doesn't have a `toto` attribute.

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
