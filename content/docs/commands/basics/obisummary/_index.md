---
archetype: "command"
title: "Obisummary"
date: 2025-01-23
command: "obisummary"
url: "/obitools/obisummary"
weight: 120
---

# `obisummary`: generate summary statistics

## Description 

Generate summary statistics describing the sequence content of a sequence file.

## Synopsis

```bash
obisummary [--batch-size <int>] [--debug] [--ecopcr] [--embl] [--fasta]
           [--fastq] [--force-one-cpu] [--genbank] [--help|-h|-?]
           [--input-OBI-header] [--input-json-header] [--json-output]
           [--map <string>]... [--max-cpu <int>] [--no-order] [--pprof]
           [--pprof-goroutine <int>] [--pprof-mutex <int>] [--solexa]
           [--version] [--yaml-output] [<args>]
```

## Options

#### {{< obi obisummary >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obisummary --help
```
