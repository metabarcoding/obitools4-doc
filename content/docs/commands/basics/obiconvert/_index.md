---
archetype: "command"
title: "obiconvert"
date: 2025-02-10
command: "obiconvert"
category: basics
url: "/obitools/obiconvert"
weight: 30
---

# `obiconvert`: convert a sequence file

## Description 

Convert a sequence file to {{% fasta %}}, {{% fastq %}}, or JSON format.

## Synopsis

```bash
obiconvert [--batch-size <int>] [--compress|-Z] [--csv] [--debug] [--ecopcr]
           [--embl] [--fail-on-taxonomy] [--fasta] [--fasta-output] [--fastq]
           [--fastq-output] [--force-one-cpu] [--genbank] [--help|-h|-?]
           [--input-OBI-header] [--input-json-header] [--json-output]
           [--max-cpu <int>] [--no-order] [--no-progressbar]
           [--out|-o <FILENAME>] [--output-OBI-header|-O]
           [--output-json-header] [--paired-with <FILENAME>] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>] [--raw-taxid]
           [--silent-warning] [--skip-empty] [--solexa]
           [--taxonomy|-t <string>] [--u-to-t] [--update-taxid] [--version]
           [--with-leaves] [<args>]
```

## Options

#### {{< obi obiconvert >}} specific options

- {{< cmd-options/paired-with >}}

{{< option-sets/taxonomy >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiconvert --help
```
