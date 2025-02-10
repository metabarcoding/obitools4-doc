---
archetype: "command"
title: "obiconsensus"
date: 2025-02-10
command: "obiconsensus"
category: experimental
url: "/obitools/obiconsensus"
---

# `obiconsensus`: denoise MinION data using consensus sequences

## Description 

Denoise MinIon sequence data by constructing consensus sequences.

## Synopsis

```bash
obiconsensus [--batch-size <int>] [--cluster|-C] [--compress|-Z] [--debug]
             [--distance|-d <int>] [--ecopcr] [--embl] [--fasta]
             [--fasta-output] [--fastq] [--fastq-output] [--force-one-cpu]
             [--genbank] [--help|-h|-?] [--input-OBI-header]
             [--input-json-header] [--json-output] [--kmer-size <SIZE>]
             [--low-coverage <float64>] [--max-cpu <int>] [--no-order]
             [--no-progressbar] [--no-singleton] [--out|-o <FILENAME>]
             [--output-OBI-header|-O] [--output-json-header] [--pprof]
             [--pprof-goroutine <int>] [--pprof-mutex <int>]
             [--sample|-s <string>] [--save-graph <string>]
             [--save-ratio <string>] [--skip-empty] [--solexa] [--unique|-U]
             [--version] [<args>]
```

## Options

#### {{< obi obiconsensus >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obiconsensus --help
```
