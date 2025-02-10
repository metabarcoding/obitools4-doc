---
archetype: "command"
title: "obiuniq"
date: 2025-02-10
command: "obiuniq"
category: basics
url: "/obitools/obiuniq"
weight: 130
---

# `obiuniq`: dereplicate a sequence file

## Description 

Dereplicate a sequence file, by merging identical sequences.

## Synopsis

```bash
obiuniq [--batch-size <int>] [--category-attribute|-c <CATEGORY>]...
        [--chunk-count <int>] [--compress|-Z] [--debug] [--ecopcr] [--embl]
        [--fasta] [--fasta-output] [--fastq] [--fastq-output]
        [--force-one-cpu] [--genbank] [--help|-h|-?] [--in-memory]
        [--input-OBI-header] [--input-json-header] [--json-output]
        [--max-cpu <int>] [--merge|-m <KEY>]... [--na-value <NA_NAME>]
        [--no-order] [--no-progressbar] [--no-singleton]
        [--out|-o <FILENAME>] [--output-OBI-header|-O] [--output-json-header]
        [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
        [--pprof-mutex <int>] [--skip-empty] [--solexa]
        [--taxonomy|-t <string>] [--version] [<args>]
```

## Options

#### {{< obi obiuniq >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiuniq --help
```
