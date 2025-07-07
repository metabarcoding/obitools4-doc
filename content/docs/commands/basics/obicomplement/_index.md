---
archetype: "command"
title: "obicomplement"
date: 2025-02-10
command: "obicomplement"
category: basics
url: "/obitools/obicomplement"
weight: 20
---

# `obicomplement`: get sequences reverse complement

## Description 

Compute the reverse complement of the sequence entries. The output is written by default in {{% fasta %}} format if the input sequence file does not include quality scores, otherwise it is written in {{% fastq %}} format.

## Synopsis

```bash
obicomplement [--batch-size <int>] [--compress|-Z] [--csv] [--debug]
              [--ecopcr] [--embl] [--fail-on-taxonomy] [--fasta]
              [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
              [--genbank] [--help|-h|-?] [--input-OBI-header]
              [--input-json-header] [--json-output] [--max-cpu <int>]
              [--no-order] [--no-progressbar] [--out|-o <FILENAME>]
              [--output-OBI-header|-O] [--output-json-header]
              [--paired-with <FILENAME>] [--pprof] [--pprof-goroutine <int>]
              [--pprof-mutex <int>] [--raw-taxid] [--silent-warning]
              [--skip-empty] [--solexa] [--taxonomy|-t <string>] [--u-to-t]
              [--update-taxid] [--version] [--with-leaves] [<args>]
```

## Options

#### {{< obi obicomplement >}} specific options

- {{< cmd-options/paired-with >}}

#### Taxonomic options

- {{< cmd-options/taxonomy/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obicomplement --help
```
