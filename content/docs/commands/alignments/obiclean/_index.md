---
archetype: "command"
title: "obiclean"
date: 2025-02-10
command: "obiclean"
category: alignments
url: "/obitools/obiclean"
weight: 10
---

# `obiclean`: a PCR aware denoising algorithm

## Description 

A denoising/clustering algorithm to filter out potential PCR-generated spurious sequences.

## Synopsis

```bash
obiclean [--batch-size <int>] [--compress|-Z] [--debug] [--distance|-d <int>]
         [--ecopcr] [--embl] [--fasta] [--fasta-output] [--fastq]
         [--fastq-output] [--force-one-cpu] [--genbank] [--head|-H]
         [--help|-h|-?] [--input-OBI-header] [--input-json-header]
         [--json-output] [--max-cpu <int>] [--min-eval-rate <int>]
         [--no-order] [--no-progressbar] [--out|-o <FILENAME>]
         [--output-OBI-header|-O] [--output-json-header] [--pprof]
         [--pprof-goroutine <int>] [--pprof-mutex <int>]
         [--ratio|-r <float64>] [--sample|-s <string>]
         [--save-graph <string>] [--save-ratio <string>] [--skip-empty]
         [--solexa] [--version] [<args>]
```

## Options

#### {{< obi obiclean >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiclean --help
```
