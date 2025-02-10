---
archetype: "command"
title: "Obidistribute"
date: 2025-01-23
command: "obidistribute"
url: "/obitools/obidistribute"
weight: 70
---

# `obidistribute`: split a sequence file into multiple files

## Description 

Distribute a sequence file accross multiple output files.

## Synopsis

```bash
obidistribute --pattern|-p <string> [--append|-A] [--batch-size <int>]
              [--batches|-n <int>] [--classifier|-c <string>] [--compress|-Z]
              [--debug] [--directory|-d <string>] [--ecopcr] [--embl]
              [--fasta] [--fasta-output] [--fastq] [--fastq-output]
              [--force-one-cpu] [--genbank] [--hash|-H <int>] [--help|-h|-?]
              [--input-OBI-header] [--input-json-header] [--json-output]
              [--max-cpu <int>] [--na-value <string>] [--no-order]
              [--no-progressbar] [--out|-o <FILENAME>]
              [--output-OBI-header|-O] [--output-json-header] [--pprof]
              [--pprof-goroutine <int>] [--pprof-mutex <int>] [--skip-empty]
              [--solexa] [--version] [<args>]
```

## Options

#### {{< obi obidistribute >}} specific options

- {{< cmd-option name="opt1" short="o" param="PARAM" >}}
  Here the description of the option
  {{< /cmd-option >}}

{{< option-sets/input >}}

{{< option-sets/output >}}

{{< option-sets/common >}}

## Examples

```bash
obidistribute --help
```
