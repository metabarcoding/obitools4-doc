---
archetype: "command"
title: "Obigrep"
date: 2025-02-10
command: "obigrep"
url: "/obitools/obigrep"
weight: 80
---

# `obigrep`: filter a sequence file

## Description 

{{< obi obigrep >}} is a tool to filter a sequence file based on multiple criteria. It allows selecting a subset of sequences based on a set of criteria. Sequences matching all the criteria are kept and printed to the standard output, while the other sequences are discarded. Criteria can apply to the sequence identifier, the sequence itself or the annotations of the sequence.

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
