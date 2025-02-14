---
archetype: "command"
title: "obitag"
date: 2025-02-10
command: "obitag"
category: alignments
url: "/obitools/obitag"
weight: 50
---

# `obitag`: annotate sequences with taxonomic information

## Description 

A Least Common Ancestor-based algorithm for taxonomic sequence annotation.

## Synopsis

```bash
obitag --reference-db|-R <FILENAME> [--batch-size <int>] [--compressed|-Z]
           [--debug] [--ecopcr] [--embl] [--fasta] [--fasta-output] [--fastq]
           [--fastq-output] [--force-one-cpu] [--genbank] [--geometric|-G]
           [--help|-h|-?] [--input-OBI-header] [--input-json-header]
           [--json-output] [--max-cpu <int>] [--no-order] [--no-progressbar]
           [--out|-o <FILENAME>] [--output-OBI-header|-O] [--output-json-header]
           [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
           [--pprof-mutex <int>] [--save-db <FILENAME>] [--skip-empty] [--solexa]
           [--taxonomy|-t <string>] [--version] [<args>]
```

## Options

#### {{< obi obitag >}} specific options

- {{< cmd-options/alignments/reference-db >}}
- {{< cmd-options/alignments/geometric >}}
- {{< cmd-options/paired-with >}}
- {{< cmd-options/alignments/save-db >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obitag --help
```
